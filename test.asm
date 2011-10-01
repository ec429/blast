; blast - a curses-alike library for the ZX Spectrum
;	Copyright (c) Edward Cree, 2011 <http://jttlov.no-ip.org>
;	Licensed under GNU GPL v3+; there is NO WARRANTY
; test.asm: simple library exerciser

.include	"blast.inc"

.text
.global F_main
	LD A,24
	LD B,40
	CALL F_b_buflen
	PUSH HL
	LD IX,0xB000
	LD A,24
	LD B,40
	CALL F_initscr
	POP BC
	AND A
	RET Z
	LD BC,0xFFFF
	RET
