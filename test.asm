; blast - a curses-alike library for the ZX Spectrum
;	Copyright (c) Edward Cree, 2011 <http://jttlov.no-ip.org>
;	Licensed under GNU GPL v3+; there is NO WARRANTY
; test.asm: simple library exerciser

.include	"blast.inc"

.text
.global F_main
	EXX
	PUSH HL
	LD IX,0xB000
	LD B,24
	LD C,64
	CALL F_initscr
	LD DE,TBL_AO64font
	LD A,0x02
	CALL F_setfont
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
	CALL F_cbreak
	LD A,0x30
	CALL F_delay
	DI
	LD A,I
	PUSH AF
	LD BC,.isv_table
	LD A,B
	LD I,A
	EI
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
	JR .main_loop
.main_print:
	LD A,E
	CALL F_addch
	CALL F_refresh
	LD A,0x57
	CALL F_attrset
	JR .main_loop
.main_end:
	DI
	POP AF
	LD I,A
	IM 1
	POP HL
	EXX
	EI
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
	PUSH IX
	EXX
	LD IX,0xB000
	CALL F_input_isv
	EXX
	POP IX
	POP AF
	EI
	RETI

.data
.balign 0x100
.isv_table:
.fill 257,1,0xAC
STR_hello: .asciz "Hello, world! "
TBL_GMfont: .incbin "GenevaMono.font"
