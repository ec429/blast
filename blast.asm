; blast - a curses-alike library for the ZX Spectrum
;	Copyright (c) Edward Cree, 2011 <http://jttlov.no-ip.org>
;	Licensed under GNU GPL v3+; there is NO WARRANTY
;		see <http://www.gnu.org/licenses/gpl.html> or file COPYING

.include	"blast.inc"

O_MAXY		equ	0
O_MAXX		equ	1
O_CURY		equ	2
O_CURX		equ	3
O_INMODE	equ	4
O_INTM		equ	5
; padding	at	7
O_INBUF		equ	8
O_INBUFP	equ	0x10
O_ATTR		equ	0x11
O_FONT		equ	0x12
O_FONTSTAND	equ	0x14
O_FONTFMT	equ	0x16
O_ADO		equ	0x17
O_CHARDATA	equ	0x18

.text
.global F_b_buflen
F_b_buflen:
	LD C,A
	CALL .multiply8
	LD A,L
	ADD HL,HL
	AND 7
	JR Z,.buflen_round
	XOR 7
	INC A
	ADD A,L
	LD L,A
	JR NC,.buflen_round
	INC H
.buflen_round:
	LD DE,O_CHARDATA
	ADD HL,DE
	RET

.global F_initscr
F_initscr:
	LD C,A
	LD A,IXH
	OR IXL
	LD A,BE_INVAL
	RET Z
.init_inval:
	LD A,C
	CP 25
	LD A,BE_RANGE
	RET P
.init_range:
	LD (IX+O_MAXY),C
	LD (IX+O_MAXX),B
	LD (IX+O_INMODE),1
	LD (IX+O_INBUFP),0
	LD (IX+O_FONT),0
	LD (IX+O_FONT+1),0x3C
	LD (IX+O_FONTSTAND),0
	LD (IX+O_FONTSTAND+1),0
	LD (IX+O_FONTFMT),0
	LD (IX+O_ATTR),0x38
	CALL .multiply8
	LD A,L
	AND 7
	PUSH AF
	SRL H
	RR L
	SRL H
	RR L
	SRL H
	RR L
	POP AF
	JR Z,.init_round
	INC HL
.init_round:
	LD A,H
	AND A
	JR Z,.init_range2
	LD A,BE_RANGE
	RET
.init_range2:
	LD (IX+O_ADO),L
	JP F_clear

.global F_clear
F_clear:
	LD A,IXH
	OR IXL
	LD A,BE_INVAL
	RET Z
	LD L,(IX+O_ADO)
	LD H,0
	SLA L
	RL H
	SLA L
	RL H
	SLA L
	RL H
	PUSH HL				; ado<<3
	LD DE,O_CHARDATA
	SBC HL,DE
	PUSH HL
	POP BC
	DEC BC
	PUSH BC				; ldircount
	PUSH IX
	POP HL
	LD DE,O_CHARDATA
	ADD HL,DE
	PUSH HL				; &chardata
	POP DE				; ^
	INC DE
	LD (HL),0xA0		; ' ' | 0x80
	LDIR
	POP BC				; =ldircount
	POP DE				; =ado<<3
	PUSH IX
	POP HL
	ADD HL,DE
	PUSH HL
	POP DE
	INC DE
	LD A,(IX+O_ATTR)
	LD (HL),A
	LDIR
	LD A,0
	RET

.global F_refresh
F_refresh:
	LD A,IXH
	OR IXL
	LD A,BE_INVAL
	RET Z
	LD BC,0
.refresh_loop:
	PUSH BC				; {y,x}
	LD C,(IX+O_MAXX)
	CALL .multiply8
	POP BC				; ={y,x}
	PUSH BC				; {y,x}
	LD B,0
	ADD HL,BC
	PUSH IX
	POP BC
	ADD HL,BC
	PUSH HL				; buffer+(y*maxx)+x
	EX AF,AF'
	LD H,0
	LD L,(IX+O_ADO)
	ADD HL,HL
	ADD HL,HL
	ADD HL,HL
	PUSH HL
	POP BC
	POP HL				; =buffer+(y*maxx)+x
	PUSH HL				; buffer+(y*maxx)+x
	ADD HL,BC
	LD A,(HL)
	EX AF,AF'
	POP HL				; =buffer+(y*maxx)+x
	LD BC,O_CHARDATA
	ADD HL,BC
	LD A,(HL)
	XOR 0x80
	POP BC				; ={y,x}
	JP M, .refresh_next
	PUSH BC				; {y,x}
	LD (HL),A
						; paint character: buffer=IX, y=B, x=C, char=A, attr=A'
						; TODO: test font_fmt and standout
	LD L,A
	LD H,0
	ADD HL,HL
	ADD HL,HL
	ADD HL,HL
	LD E,(IX+O_FONT)
	LD D,(IX+O_FONT+1)
	ADD HL,DE
	PUSH HL
	LD A,B
	AND 0x18
	OR 0x40
	LD H,A
	LD A,B
	SLA A
	SLA A
	SLA A
	SLA A
	SLA A
	OR C
	LD L,A
	POP DE
	EX DE,HL
	PUSH DE
	SRL D
	SRL D
	SRL D
	LD A,0x50
	OR D
	LD D,A
	EX AF,AF'
	LD (DE),A
	EX AF,AF'
	POP DE
.paint_romfont_loop:
	LD A,(HL)
	LD (DE),A
	INC HL
	INC D
	LD A,7
	AND D
	JR NZ,.paint_romfont_loop
						; finished painting character
	POP BC				; ={y,x}
.refresh_next:
	INC C
	LD A,C
	CP (IX+O_MAXX)
	JP M,.refresh_loop
	LD C,0
	INC B
	LD A,B
	CP (IX+O_MAXY)
	JP M,.refresh_loop
	LD A,0
	RET

.multiply8:				; HL = B * C; uses A,D
	LD HL,0
	LD D,0x80
.mult8_loop:
	LD A,B
	AND D
	JR Z,.mult8_next
	LD A,L
	ADD A,C
	LD L,A
	JR NC,.mult8_next
	INC H
.mult8_next:
	SRL D
	RET Z
	SLA L
	RL H
	JR .mult8_loop
