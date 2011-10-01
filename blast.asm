; blast - a curses-alike library for the ZX Spectrum
;	Copyright (c) Edward Cree, 2011 <http://jttlov.no-ip.org>
;	Licensed under GNU GPL v3+; there is NO WARRANTY
;		see <http://www.gnu.org/licenses/gpl.html> or file COPYING

.include	"blast.inc"

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
	LD DE,0x10
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
	LD (IX+0),C
	LD (IX+1),B
	LD (IX+2),1
	LD (IX+8),0
	LD (IX+9),0
	LD (IX+10),0x3C
	LD (IX+11),0
	LD (IX+12),0
	LD (IX+13),0
	LD (IX+15),0x38
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
	LD (IX+14),L
	JP F_clear

.global F_clear
F_clear:
	LD A,IXH
	OR IXL
	LD A,BE_INVAL
	RET Z
	LD L,(IX+14)
	LD H,0
	SLA L
	RL H
	SLA L
	RL H
	SLA L
	RL H
	PUSH HL				; ado<<3
	LD DE,0x10
	SBC HL,DE
	PUSH HL
	POP BC
	DEC BC
	PUSH BC				; ldircount
	PUSH IX
	POP HL
	LD DE,0x10
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
	LD A,(IX+15)
	LD (HL),A
	LDIR
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
