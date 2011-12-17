; blast - a curses-alike library for the ZX Spectrum
;	Copyright (c) Edward Cree, 2011 <http://jttlov.no-ip.org>
;	Licensed under GNU GPL v3+; there is NO WARRANTY
; module_exerciser.asm: library exerciser for the Spectranet module

.include	"spectranet.inc"
.include	"blast.inc"
.include	"blast_module.inc"

.text
.global F_main
	LD B,24
	LD C,64
	LD H,blast_module_id
	LD L,modulecall_blast_buflen
	CALL MODULECALL
	PUSH HL
	LD DE,0x0C20
	AND A
	SBC HL,DE
	JR Z,.bbok
	POP BC
	RET
.bbok:
	LD IX,0xB000
	LD H,blast_module_id
	LD L,modulecall_blast_initscr
	CALL MODULECALL
	AND A
	JP NZ,.reta
	LD A,0x02
	LD DE,TBL_AO64font
	LD H,blast_module_id
	LD L,modulecall_blast_setfont
	CALL MODULECALL
	AND A
	JP NZ,.reta
	LD A,'S'
	LD H,blast_module_id
	LD L,modulecall_blast_addch
	CALL MODULECALL
	AND A
	JP NZ,.reta
	LD A,'P'
	LD BC,0x0101
	LD H,blast_module_id
	LD L,modulecall_blast_mvaddch
	CALL MODULECALL
	AND A
	JP NZ,.reta
	LD BC,0x0202
	LD H,blast_module_id
	LD L,modulecall_blast_move
	CALL MODULECALL
	AND A
	JR NZ,.reta
	LD A,'e'
	LD H,blast_module_id
	LD L,modulecall_blast_addch
	CALL MODULECALL
	LD BC,0x0303
	LD H,blast_module_id
	LD L,modulecall_blast_move
	CALL MODULECALL
	LD DE,STR_c
	LD H,blast_module_id
	LD L,modulecall_blast_addstr
	CALL MODULECALL
	AND A
	JR NZ,.reta
	LD BC,0x0404
	LD DE,STR_t
	LD H,blast_module_id
	LD L,modulecall_blast_mvaddstr
	CALL MODULECALL
	AND A
	JR NZ,.reta
	LD A,0x07
	LD H,blast_module_id
	LD L,modulecall_blast_attrset
	CALL MODULECALL
	AND A
	JR NZ,.reta
	LD A,'r'
	LD BC,0x0505
	LD H,blast_module_id
	LD L,modulecall_blast_mvaddch
	CALL MODULECALL
	LD A,0x87
	LD H,blast_module_id
	LD L,modulecall_blast_attrset
	CALL MODULECALL
	AND A
	JR NZ,.reta
	LD A,'a'
	LD BC,0x0606
	LD H,blast_module_id
	LD L,modulecall_blast_mvaddch
	CALL MODULECALL
	LD A,0xB8
	LD H,blast_module_id
	LD L,modulecall_blast_attrset
	CALL MODULECALL
	LD BC,0x0707
	LD DE,STR_net
	LD H,blast_module_id
	LD L,modulecall_blast_mvaddstr
	CALL MODULECALL
.reta:
	LD B,0
	LD C,A
	PUSH BC
	LD H,blast_module_id
	LD L,modulecall_blast_refresh
	CALL MODULECALL
	POP BC
	RET

.data
STR_c: .asciz "c"
STR_t: .asciz "t"
STR_net: .asciz "NET"
