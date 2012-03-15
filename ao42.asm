; blast - a curses-alike library for the ZX Spectrum
;	Copyright (c) Edward Cree, 2011 <http://jttlov.no-ip.org>
;	Licensed under GNU GPL v3+; there is NO WARRANTY
;		see <http://www.gnu.org/licenses/gpl.html> or file COPYING
;	ao42: Driver for BFF_AO42 fonts (based on Andrew Owen's '42 column.asm')
;	entry call F_AO42_print
;	buffer=IX, y=B, x=C, char=A, attr=A'
.include	"blast_buffer.inc"

.section driver,"x"
get_addr:
	ld	h, 0		; Figure out where the character's
	ld	l, a		; definition is stored in memory.
	add	hl, hl		;
	add	hl, hl		;
	add	hl, hl		;
	DEC H
	ex	de, hl		;
	ret				;

.global F_AO42_print
F_AO42_print:
	PUSH BC
	EXX
	POP BC
	PUSH HL
	call	.fchr
	POP HL
	EXX
	EX AF,AF'
	LD B,A
	EX AF,AF'
	SRL H
	SRL H
	SRL H
	LD A,0x50
	OR H
	LD H,A
	LD (HL),B
	ld A,3
	EXX
	AND E			; column%4
	EXX
	;RET Z
	CP 3
	;RET Z
	INC HL
	LD (HL),B
	RET
	
.fchr:
	PUSH AF
	LD A,B			; compute screen location
	AND 0x18
	OR 0x40
	LD H,A
	LD A,B
	SLA A
	SLA A
	SLA A
	SLA A
	SLA A
	LD L,A
	LD A,C
	EXX
	LD E,A			; save the column in E', we need its low bits
	EXX
	ADD A,C
	ADD A,C
	SRL A
	SRL A
	OR L
	LD L,A			; HL=&screen[y][x]
	POP AF
	PUSH IX
	PUSH HL
	call	get_addr
	EX AF,AF'
	LD B,A
	AND 0x7F
	EX AF,AF'
	LD A,0x80
	AND B
	JR Z,.nostand
	LD L,(IX+O_FONTSTAND)
	LD H,(IX+O_FONTSTAND+1)
	LD A,H
	OR L
	JR NZ,.stand
	EX AF,AF'
	OR 0x80
	EX AF,AF'
.nostand:
	LD L,(IX+O_FONT)
	LD H,(IX+O_FONT+1)
.stand:
	ADD HL,DE
	LD A,(HL)
	POP IX			; IX=&screen[y][x]
	PUSH HL
	EXX
	POP BC			; BC'=font pointer
	LD D,0			; D'=line counter
	EXX
	PUSH IX
	POP HL			; HL=&screen[y][x]
	POP IX			; IX=buffer
	PUSH HL
.fchr_loop:
	AND 0x7E		; get the middle six AND clear the outer two pixels
	ld D,A			; the row of font data
	ld A,3
	EXX
	AND E			; column%4
	EXX
	CALL .print_w
	PUSH HL
	EXX
	POP HL
	LD A,H
	AND 0xf8
	LD H,A
	INC D
	LD A,7
	AND D
	JR Z,.fchr_done
	OR H
	LD H,A
	INC BC
	LD A,(BC)
	PUSH HL
	EXX
	POP HL
	JR .fchr_loop
	
.fchr_done:
	EXX
	POP HL			; HL=&screen[y][x]
	RET
	
.print_w:
	EX AF,AF'
	LD B,A
	AND 0x80
	JR Z,.standok
	EXX
	LD A,D
	EXX
	CP 7
	JR NZ,.standok
	LD A,0x7F
	AND B
	EX AF,AF'
	JR Z,.stand_0
	DEC A
	JR Z,.stand_1
	DEC A
	JR Z,.stand_2
.stand_3:
	LD A,(HL)
	OR 0x3F
	LD (HL),A
	RET
.stand_2:
	LD A,(HL)
	OR 0x0F
	LD (HL),A
	INC HL
	LD A,(HL)
	OR 0xC0
	LD (HL),A
	RET
.stand_1:
	LD A,(HL)
	OR 0x03
	LD (HL),A
	INC HL
	LD A,(HL)
	OR 0xF0
	LD (HL),A
	RET
.stand_0:
	LD A,(HL)
	OR 0xFC
	LD (HL),A
	RET

.standok:
	LD A,B
	EX AF,AF'
	JR Z,.print_0
	DEC A
	JR Z,.print_1
	DEC A
	JR Z,.print_2
.print_3:
	SRL D
	LD A,(HL)
	AND 0xC0
	OR D
	LD (HL),A
	RET
.print_2:
	PUSH DE
	SRL D
	SRL D
	SRL D
	LD A,(HL)
	AND 0xF0
	OR D
	LD (HL),A
	INC HL
	POP DE
	RRC D
	RRC D
	RRC D
	LD A,0xC0
	AND D
	LD D,A
	LD A,(HL)
	AND 0x3F
	OR D
	LD (HL),A
	DEC HL
	RET
.print_1:
	PUSH DE
	RLC D
	RLC D
	RLC D
	LD A,0x03
	AND D
	LD D,A
	LD A,(HL)
	AND 0xFC
	OR D
	LD (HL),A
	INC HL
	POP DE
	SLA D
	SLA D
	SLA D
	LD A,(HL)
	AND 0x0F
	OR D
	LD (HL),A
	DEC HL
	RET
.print_0:
	SLA D
	LD A,(HL)
	AND 0x03
	OR D
	LD (HL),A
	RET
