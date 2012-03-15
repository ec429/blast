; blast - a curses-alike library for the ZX Spectrum
;	Copyright (c) Edward Cree, 2011 <http://jttlov.no-ip.org>
;	Licensed under GNU GPL v3+; there is NO WARRANTY
;		see <http://www.gnu.org/licenses/gpl.html> or file COPYING

.include	"blast.inc"
.include	"blast_buffer.inc"

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
	LD (IX+O_YOFF),0
	LD (IX+O_XOFF),0
	LD (IX+O_INMODE),1
	LD (IX+O_INBUFP),0
	LD (IX+O_FONT),0
	LD (IX+O_FONT+1),0x3D
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

.global F_setfont
F_setfont:
	LD C,A
	LD A,IXH
	OR IXL
	LD A,BE_INVAL
	RET Z
	LD A,BFO_STANDOUT
	AND C
	JR NZ,.setfont_stand
	LD (IX+O_FONT),E
	LD (IX+O_FONT+1),D
	LD A,(IX+O_FONTFMT)
	AND 0xf0
	LD B,A
	LD A,C
	AND 0x0f
	OR B
	LD (IX+O_FONTFMT),A
	XOR A
	RET
.setfont_stand:
	LD (IX+O_FONTSTAND),E
	LD (IX+O_FONTSTAND+1),D
	LD A,(IX+O_FONTFMT)
	AND 0x0f
	LD B,A
	LD A,C
	AND 0x0f
	RLCA
	RLCA
	RLCA
	RLCA
	OR B
	LD (IX+O_FONTFMT),A
	XOR A
	RET

.global F_raw
F_raw:
	LD A,IXH
	OR IXL
	LD A,BE_INVAL
	RET Z
	RES 0,(IX+O_INMODE)
	XOR A
	RET

.global F_cbreak
F_cbreak:
	LD A,IXH
	OR IXL
	LD A,BE_INVAL
	RET Z
	SET 0,(IX+O_INMODE)
	XOR A
	RET

.global F_delay
F_delay:
	LD D,A
	LD A,IXH
	OR IXL
	LD A,BE_INVAL
	RET Z
	SET 2,(IX+O_INMODE)
	LD (IX+O_INTM),D
	XOR A
	RET

.global F_nodelay
F_nodelay:
	LD A,IXH
	OR IXL
	LD A,BE_INVAL
	RET Z
	RES 2,(IX+O_INMODE)
	XOR A
	RET

.getch_mode:
	BIT 2,(IX+O_INMODE)
	RET Z
	LD A,(IX+O_INTM)
	AND A
	JR Z,F_getch
	SUB (IX+O_INWAIT)
	RET Z
	JR .getch_repeat

.global F_getch
F_getch:
	LD A,IXH
	OR IXL
	RET Z
	LD (IX+O_INWAIT),0
.getch_repeat:
	LD A,(IX+O_INBUFP)
	LD B,A
	AND 7
	LD E,A
	LD A,B
	AND 0x70
	RLCA
	RLCA
	RLCA
	RLCA
	XOR E
	JR Z,.getch_mode
	XOR E
	LD D,A
	DI
	LD A,(IX+O_INBUFP)
	CP B
	JR Z,.getch_cont
	EI
	JR F_getch
.getch_cont:
	AND 0x80
	OR E
	LD E,A
	LD A,D
	ADD A,O_INBUF
	LD C,A
	LD B,0
	PUSH IX
	POP HL
	ADD HL,BC
	LD A,D
	INC A
	AND 7
	RLCA
	RLCA
	RLCA
	RLCA
	OR E
	LD (IX+O_INBUFP),A
	LD A,(HL)
	EI
	RET

.global F_input_isv
F_input_isv:
	LD A,IXH
	OR IXL
	SCF
	RET Z
	INC (IX+O_INWAIT)
	LD A,(IX+O_INBUFP)
	LD B,A
	INC A
	AND 7
	LD E,A
	LD A,B
	AND 0x70
	RLCA
	RLCA
	RLCA
	RLCA
	XOR E
	RET Z
	LD C,0xFE
	LD B,0x7F			; we need the shift state (symbol shift)
	IN A,(C)
	AND 2
	XOR 2
	LD D,A				; D is now 2 if sym shift pressed, else 0
	LD B,C
.input_isv_loop:
	IN A,(C)
	AND 0x1f
	XOR 0x1f
	JP Z,.input_isv_next
	LD E,A
	LD A,B
	CP C
	JR NZ,.input_isv_ss
	LD A,E
	AND 1
	OR D
	LD D,A				; D is now (2:sym shift)|(1:caps shift)
	LD A,0x1e
	AND E
	JP Z,.input_isv_next
	LD E,A
	JR .input_isv_what
.input_isv_ss:
	CP 0x7F
	JR NZ,.input_isv_what
	LD A,0x1d			; 00011101
	AND E
	JP Z,.input_isv_next
	LD E,A
.input_isv_what:
	BIT 7,(IX+O_INBUFP)
	JR Z,.input_isv_not_cl
	LD A,D
	XOR 1
	LD D,A				; D is now (2:sym shift)|(1:caps shift^caps lock)
.input_isv_not_cl:
	LD A,0xff
.input_isv_column:
	INC A
	SRL E
	JR NC,.input_isv_column
	RRCA
	RRCA
	RRCA
	LD E,A
	LD A,0xff
.input_isv_row:
	INC A
	SRL B
	JR C,.input_isv_row
	OR E
	LD E,A
	LD A,(IX+O_INLASTSCN)
	AND 0xe7
	XOR E
	RET Z
	LD (IX+O_INLASTSCN),E
	BIT 0,(IX+O_INMODE)
	JR NZ,.input_isv_cbreak
	LD A,D
	AND 3
	LD L,A
	JR Z,.input_isv_raw
	LD A,(IX+O_INBUFP)
	LD B,A
	INC A
	INC A
	AND 7
	LD D,A
	LD A,B
	AND 0x70
	RLCA
	RLCA
	RLCA
	RLCA
	XOR D
	RET Z
	LD A,L
	CALL .input_isv_storech
.input_isv_raw:
	LD A,(IX+O_INLASTSCN)
	AND 0xe7
	LD C,A
	LD B,0
	LD HL,.table_cbreak
	ADD HL,BC
	LD A,(HL)
	JR .input_isv_storech
.input_isv_cbreak:
	LD A,E
	RLC D
	RLC D
	RLC D
	OR D
	LD C,A
	LD B,0
	LD HL,.table_cbreak
	ADD HL,BC
	LD A,(HL)
	BIT 7,(IX+O_INBUFP)
	JR Z,.input_isv_cl
	CP '2'
	JR NZ,.input_isv_cl
	LD A,4
.input_isv_cl:
	CP 4
	JP M,.input_isv_discard
	JR NZ,.input_isv_storech
	LD A,(IX+O_INBUFP)
	XOR 0x80
	LD (IX+O_INBUFP),A
	RET
.input_isv_discard:
	XOR A
	RET
.input_isv_next:
	SCF
	RL B
	JP C,.input_isv_loop
	LD (IX+O_INLASTSCN),0
	RET
.input_isv_storech:
	LD E,A
	LD A,(IX+O_INBUFP)
	LD D,A
	AND 7
	ADD A,O_INBUF
	LD C,A
	LD B,0
	PUSH IX
	POP HL
	ADD HL,BC
	LD (HL),E
	LD A,D
	INC A
	AND 7
	LD E,A
	LD A,D
	AND 0xf0
	OR E
	LD (IX+O_INBUFP),A
	RET

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
	CP 0xD
	JR Z,.addch_nl
	CP 0xA
	JR Z,.addch_nl
	CP 0x9
	JR Z,.addch_tab
	CP 0x8
	JR Z,.addch_bs
	CP 0xC
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
	LD C,(IX+O_ADO)
	LD B,(IX+O_ADO+1)
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
	LD B,H
	LD C,L
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

.global F_beep
F_beep:
	LD BC,0
	LD DE,0
	LD A,0
.beep_loop:
	OUT (0xFE),A
	EX AF,AF'
	INC BC
	INC D
	INC E
	LD A,D
	SUB 4
	JR NZ,.beep_1
	LD D,A
	EX AF,AF'
	XOR 0x10
	EX AF,AF'
.beep_1:
	LD A,E
	SUB 7
	JR NZ,.beep_2
	LD E,A
	EX AF,AF'
	XOR 0x10
	EX AF,AF'
.beep_2:
	PUSH BC
	LD B,0x80
.beep_wait:
	DJNZ .beep_wait
	POP BC
	LD A,B
	AND 0
	OR C
	RET Z
	EX AF,AF'
	JR .beep_loop

.global F_scroll
F_scroll:
	LD D,A
	LD A,IXH
	OR IXL
	LD A,BE_INVAL
	RET Z
	LD A,D
	CP 0
	RET Z
	JP M,.scroll_down
	PUSH IX
	POP HL
	LD DE,O_CHARDATA
	ADD HL,DE
	PUSH HL
	LD B,(IX+O_MAXX)
	LD C,A
	EX AF,AF'
	CALL .multiply8
	POP DE
	ADD HL,DE
	PUSH HL
	PUSH DE
	LD C,(IX+O_ADO)
	LD B,(IX+O_ADO+1)
	PUSH IX
	POP HL
	ADD HL,BC
	LD B,H
	LD C,L
	POP DE
	POP HL
.scroll_charloop:
	LD A,(HL)
	OR 0x80
	LD (DE),A
	INC DE
	INC HL
	PUSH HL
	AND A
	SBC HL,BC
	POP HL
	JR NZ,.scroll_charloop
	LD A,0xA0
	PUSH BC
.scroll_charclear:
	LD (DE),A
	INC DE
	PUSH HL
	SBC HL,DE
	POP HL
	JR NZ,.scroll_charclear
	EX AF,AF'
	PUSH AF				; {count,}
	LD B,(IX+O_MAXX)
	LD C,A
	CALL .multiply8
	POP BC				; ={count,}
	POP DE				; =&attrdata[y][x]
	ADD HL,DE
	PUSH BC
	PUSH DE
	PUSH HL
	LD A,(IX+O_MAXY)
	SUB B
	LD B,A
	LD C,(IX+O_MAXX)
	CALL .multiply8
	LD B,H
	LD C,L
	POP HL
	POP DE
	LDIR
	POP BC
	LD C,(IX+O_MAXX)
	PUSH DE
	CALL .multiply8
	POP DE
	LD B,H
	LD C,L
	LD H,D
	LD L,E
	LD A,(IX+O_ATTR)
	LD (HL),A
	INC DE
	DEC BC
	LDIR
	LD A,0
	RET
.scroll_down:
	LD A,0xFF
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
	LD D,A
	EX AF,AF'
	LD (HL),A
	LD E,A
						; paint character: buffer=IX, y=B, x=C, char=A, attr=A'
	LD A,0x80
	AND D
	JR Z,.refresh_no_standout
	LD A,(IX+O_FONTSTAND)
	OR (IX+O_FONTSTAND+1)
	JR Z,.refresh_no_standout
	LD A,(IX+O_FONTFMT)
	AND 0xF0
	RLCA
	RLCA
	RLCA
	RLCA
	JR .refresh_standout
.refresh_no_standout:
	LD A,(IX+O_FONTFMT)
	AND 0xF
.refresh_standout:
	LD D,A
	LD A,E
	CALL Z,.paint_romfont
	DEC D
	CALL Z,F_AO42_print
	DEC D
	CALL Z,F_AO64_print
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

.paint_romfont:
	EXX
	LD D,0
	EXX
	LD L,A
	LD H,0
	ADD HL,HL
	ADD HL,HL
	ADD HL,HL
	DEC H
	EX AF,AF'
	LD D,A
	EX AF,AF'
	LD A,0x80
	AND D
	JR Z,.paint_romfont_nostand
	LD E,(IX+O_FONTSTAND)
	LD D,(IX+O_FONTSTAND+1)
	LD A,D
	OR E
	JR NZ,.paint_romfont_stand
	EXX
	INC D
	EXX
.paint_romfont_nostand:
	LD E,(IX+O_FONT)
	LD D,(IX+O_FONT+1)
.paint_romfont_stand:
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
	AND 0x7F			; clear the high bit (standout, not flash)
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
	EXX
	LD A,D
	AND A				; check for genstandout
	EXX
	RET Z
	DEC D
	LD A,0xFF
	LD (DE),A
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

.global F_getcury
F_getcury:
	LD A,IXH
	OR IXL
	LD A,0xFF
	RET Z
	LD A,(IX+O_CURY)
	RET

.global F_getcurx
F_getcurx:
	LD A,IXH
	OR IXL
	LD A,0xFF
	RET Z
	LD A,(IX+O_CURX)
	RET

.global F_getmaxy
F_getmaxy:
	LD A,IXH
	OR IXL
	LD A,0xFF
	RET Z
	LD A,(IX+O_MAXY)
	RET

.global F_getmaxx
F_getmaxx:
	LD A,IXH
	OR IXL
	LD A,0xFF
	RET Z
	LD A,(IX+O_MAXX)
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

.data
.table_cbreak:
	; column 0
.byte 0x1,'a','q','1','0','p',0xd,' '
.byte 0x1,'A','Q',0x7,0xC,'P',0xd,0x6
.byte 0x3, 0 , 0 ,'!','-','"',0xd,' '
.byte 0x1,'~', 0 , 0 , 0,0x7f,0xd,' '
	; column 1
.byte 'z','s','w','2','9','o','l',0x2
.byte 'Z','S','W',0x4,0x5,'O','L',0x3
.byte ':', 0 , 0 ,'@',')',';','=',0x2
.byte  0 ,'|', 0 , 0 , 0 , 0 , 0 ,0x2
	; column 2
.byte 'x','d','e','3','8','i','k','m'
.byte 'X','D','E',0xe,0x9,'I','K','M'
.byte 0x60,0 , 0 ,'#','(', 0 ,'+','.'
.byte  0,0x5c, 0 , 0 , 0 , 0 , 0 , 0
	; column 3
.byte 'c','f','r','4','7','u','j','n'
.byte 'C','F','R',0xf,0xb,'U','J','N'
.byte '?', 0 ,'<','$',0x27,0 ,'-',','
.byte  0 ,'{', 0 , 0 , 0 ,']', 0 , 0
	; column 4
.byte 'v','g','t','5','6','y','h','b'
.byte 'V','G','T',0x8,0xA,'Y','H','B'
.byte '/', 0 ,'>','%','&', 0 ,'^','*'
.byte  0 ,'}', 0 , 0 , 0 ,'[', 0 , 0
