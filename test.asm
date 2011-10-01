; blast - a curses-alike library for the ZX Spectrum
;	Copyright (c) Edward Cree, 2011 <http://jttlov.no-ip.org>
;	Licensed under GNU GPL v3+; there is NO WARRANTY
; test.asm: simple library exerciser

.include	"blast.inc"

.text
.global F_main
	LD IX,0xB000
	LD A,24
	LD B,40
	CALL F_initscr
	LD C,A
	PUSH BC
	LD A,'a'
	CALL F_addch
	LD A,'b'
	CALL F_addch
	LD A,'c'
	CALL F_addch
	CALL F_refresh
	POP BC
	LD B,A
	RET
