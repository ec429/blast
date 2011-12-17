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
	LD C,32
	LD H,blast_module_id
	LD L,modulecall_blast_buflen
	CALL MODULECALL
	PUSH HL
	LD DE,0x0620
	CCF
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
	JR NZ,.reta
	LD BC,0
	RET
.reta:
	LD B,0
	LD C,A
	RET

.data

