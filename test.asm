; blast - a curses-alike library for the ZX Spectrum
;	Copyright (c) Edward Cree, 2011 <http://jttlov.no-ip.org>
;	Licensed under GNU GPL v3+; there is NO WARRANTY
; test.asm: simple library exerciser

.include	"blast.inc"

.text
.global F_main
	LD IX,0xB000
	LD B,24
	LD C,42
	CALL F_initscr
	LD DE,TBL_GMfont
	LD A,0x01
	CALL F_setfont
	LD A,'a'
	CALL F_addch
	LD A,'b'
	CALL F_addch
	LD A,'c'
	CALL F_addch
	LD A,0x57|0x80
	CALL F_attrset
	LD BC,0x0100
	LD DE,STR_hello
	CALL F_mvaddstr
	LD A,0x57
	CALL F_attrset
	LD A,' '
	CALL F_addch
	CALL F_refresh
	LD BC,0x0302
	CALL F_move
	CALL F_cbreak
	LD A,0
	CALL F_delay
	LD A,1
	CALL F_scroll
	LD BC,.isv_table
	LD A,B
	LD I,A
	IM 2
.main_loop:
	CALL F_getch
	AND A
	JR Z,.main_blank
	LD E,A
	CP 'x'
	JR Z,.main_end
	AND 0xe0
	LD A,E
	JR NZ,.main_print
	CALL F_attrset
	CALL F_beep
	JR .main_loop
.main_print:
	LD A,E
	CALL F_addch
	CALL F_refresh
	LD A,0x57
	CALL F_attrset
	JR .main_loop
.main_end:
	IM 1
	LD BC,0
	RET
.main_blank:
	LD A,0x20
	CALL F_addch
	CALL F_refresh
	JR .main_loop

.section isr
.skip 0xAC
.isr:
	PUSH AF
	PUSH BC
	PUSH DE
	PUSH HL
	PUSH IX
	LD IX,0xB000
	CALL F_input_isv
	POP IX
	POP HL
	POP DE
	POP BC
	POP AF
	EI
	RETI

.data
.balign 0x100
.isv_table:
.fill 257,1,0xAC
STR_hello: .asciz "Hello, world!"
TBL_GMfont: .incbin "GenevaMono.font"
