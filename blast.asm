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
O_INBUFP	equ	7
O_INBUF		equ	8
O_ADO		equ	0x10
O_FONT		equ	0x12
O_FONTSTAND	equ	0x14
O_FONTFMT	equ	0x16
O_ATTR		equ	0x17
O_CHARDATA	equ	0x18

.text
.global F_b_buflen
F_b_buflen:
	CALL .multiply8
	LD A,L
	ADD HL,HL
	LD DE,O_CHARDATA
	ADD HL,DE
	RET

.global F_initscr
F_initscr:
	LD A,IXH
	OR IXL
	LD A,BE_INVAL
	RET Z
	LD A,B
	CP 25
	LD A,BE_RANGE
	RET P
	LD A,C
	CP 86
	LD A,BE_RANGE
	RET P
	LD (IX+O_MAXY),B
	LD (IX+O_MAXX),C
	LD (IX+O_CURY),0
	LD (IX+O_CURX),0
	LD (IX+O_INMODE),1
	LD (IX+O_INBUFP),0
	LD (IX+O_FONT),0
	LD (IX+O_FONT+1),0x3C
	LD (IX+O_FONTSTAND),0
	LD (IX+O_FONTSTAND+1),0
	LD (IX+O_FONTFMT),0
	LD (IX+O_ATTR),0x38
	CALL .multiply8
	LD DE,O_CHARDATA
	ADD HL,DE
	LD (IX+O_ADO),L
	LD (IX+O_ADO+1),H
	JP F_clear

.addch_nl:
	LD A,0x20
	CALL F_addch
	LD A,(IX+O_CURX)
	AND A
	RET Z
	JR .addch_nl
.addch_tab:
	LD A,0x20
	CALL F_addch
	LD A,(IX+O_CURX)
	AND 7
	RET Z
	JR .addch_tab
.addch_bs:
	XOR A
	DEC (IX+O_CURX)
	RET P
	LD (IX+O_CURX),A
	RET

.addch_ctrl:
	CP 13
	JR Z,.addch_nl
	CP 10
	JR Z,.addch_nl
	CP 9
	JR Z,.addch_tab
	CP 8
	JR Z,.addch_bs
	LD A,BE_CTRL
	RET

.global F_addch
F_addch:
	LD D,A
	LD A,IXH
	OR IXL
	LD A,BE_INVAL
	RET Z
	LD A,D
	CP 0x20
	JP M,.addch_ctrl
	OR 0x80
	PUSH AF				; {char,X}
	LD B,(IX+O_CURY)
	LD C,(IX+O_CURX)
	PUSH BC				; {cury,curx}
	LD C,(IX+O_MAXX)
	CALL .multiply8
	POP BC				; ={cury,curx}
	LD B,0
	ADD HL,BC
	PUSH IX
	POP BC
	ADD HL,BC
	PUSH HL				; buffer+(cury*maxx)+curx
	LD L,(IX+O_ADO)
	LD H,(IX+O_ADO+1)
	PUSH HL
	POP BC
	POP HL				; =buffer+(cury*maxx)+curx
	PUSH HL				; buffer+(cury*maxx)+curx
	ADD HL,BC
	LD A,(IX+O_ATTR)
	LD (HL),A
	POP HL				; =buffer+(cury*maxx)+curx
	LD BC,O_CHARDATA
	ADD HL,BC
	POP AF				; ={char,X}
	LD (HL),A
	LD A,(IX+O_CURX)
	INC A
	LD (IX+O_CURX),A
	CP (IX+O_MAXX)
	JP M, .addch_ok
.addch_nexty:
	LD (IX+O_CURX),0
	LD A,(IX+O_CURY)
	INC A
	LD (IX+O_CURY),A
	CP (IX+O_MAXY)
	JP M, .addch_ok
	; TODO: scroll the screen up one line (by calling scroll())
	DEC A
	LD (IX+O_CURY),A
	LD A,0xFF
	RET
.addch_ok:
	XOR A
	RET

.global F_mvaddch
F_mvaddch:
	LD D,A
	PUSH DE
	CALL F_move
	POP DE
	AND A
	RET NZ
	LD A,D
	JP F_addch

.global F_addstr
F_addstr:
	LD A,(DE)
	AND A
	RET Z
	PUSH DE
	CALL F_addch
	POP DE
	AND A
	RET NZ
	INC DE
	JR F_addstr

.global F_mvaddstr
F_mvaddstr:
	PUSH DE
	CALL F_move
	POP DE
	AND A
	RET NZ
	JP F_addstr

.global F_clear
F_clear:
	LD A,IXH
	OR IXL
	LD A,BE_INVAL
	RET Z
	LD L,(IX+O_ADO)
	LD H,(IX+O_ADO+1)
	PUSH HL				; ado
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
	POP DE				; =ado
	PUSH IX
	POP HL
	ADD HL,DE
	PUSH HL
	POP DE
	INC DE
	LD A,(IX+O_ATTR)
	LD (HL),A
	LDIR
	XOR A
	RET

.global F_refresh
F_refresh:
	LD A,IXH
	OR IXL
	LD A,BE_INVAL
	RET Z
	PUSH IX
	POP HL
	LD E,(IX+O_ADO)
	LD D,(IX+O_ADO+1)
	ADD HL,DE
	EX DE,HL
	PUSH IX
	POP HL
	LD BC,O_CHARDATA
	ADD HL,BC
	LD BC,0
.refresh_loop:
	LD A,(HL)
	XOR 0x80
	JP M, .refresh_next
	PUSH BC				; {y,x}
	PUSH DE				; &attrdata[y][x]
	PUSH HL				; &chardata[y][x]
	EX AF,AF'
	LD A,(DE)
	EX AF,AF'
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
	PUSH HL				; &font[char]
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
	POP DE				; =&font[char]
	EX DE,HL
	PUSH DE				; &screen[y][x]
	SRL D
	SRL D
	SRL D
	LD A,0x50
	OR D
	LD D,A
	EX AF,AF'
	LD (DE),A
	EX AF,AF'
	POP DE				; =&screen[y][x]
.paint_romfont_loop:
	LD A,(HL)
	LD (DE),A
	INC HL
	INC D
	LD A,7
	AND D
	JR NZ,.paint_romfont_loop
						; finished painting character
	POP HL				; &chardata[y][x]
	POP DE				; &attrdata[y][x]
	POP BC				; ={y,x}
.refresh_next:
	INC HL
	INC DE
	INC C
	LD A,C
	CP (IX+O_MAXX)
	JP M,.refresh_loop
	LD C,0
	INC B
	LD A,B
	CP (IX+O_MAXY)
	JP M,.refresh_loop
	XOR A
	RET

.global F_attrset
F_attrset:
	LD D,A
	LD A,IXH
	OR IXL
	LD A,BE_INVAL
	RET Z
	LD (IX+O_ATTR),D
	XOR A
	RET

.global F_attrget
F_attrget:
	LD A,IXH
	OR IXL
	RET Z
	LD A,(IX+O_ATTR)
	RET

.global F_move
F_move:
	LD A,IXH
	OR IXL
	LD A,BE_INVAL
	RET Z
	LD A,B
	CP (IX+O_MAXY)
	LD A,BE_RANGE
	RET P
	LD A,C
	CP (IX+O_MAXX)
	LD A,BE_RANGE
	RET P
	LD (IX+O_CURY),B
	LD (IX+O_CURX),C
	XOR A
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
