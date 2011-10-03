; blast - a curses-alike library for the ZX Spectrum
;	Copyright (c) Edward Cree, 2011 <http://jttlov.no-ip.org>
;	Licensed under GNU GPL v3+; there is NO WARRANTY
; test.asm: simple library exerciser

.include	"blast.inc"

.text
.global F_main
	LD IX,0xB000
	LD B,24
	LD C,32
	CALL F_initscr
	LD A,'a'
	CALL F_addch
	LD A,'b'
	CALL F_addch
	LD A,'c'
	CALL F_addch
	LD A,0x57
	CALL F_attrset
	LD BC,0x0100
	LD DE,STR_hello
	CALL F_mvaddstr
	CALL F_refresh
	LD BC,0x0302
	CALL F_move
.main_loop:
	CALL F_input_isv
	CALL F_getch
	AND A
	JR Z,.main_loop
	LD B,0
	LD C,A
	PUSH BC
	CALL F_addch
	CALL F_refresh
	POP BC
	RET

.data
STR_hello: .asciz "Hello, world!"
