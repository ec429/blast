include "blast_module.inc"
include "blast.inc"

.globl J_blast_modulecall
J_blast_modulecall:
	call F_fetchpage	;get our ram page
	ret c				;failed to get our page
	
	exx
	ld de,.finished
	push de
	exx
	
	;modulecall number in L register
	push ix
	ld ix,.jumptbl
	EX AF,AF'
	LD A,L
	CP (.jumpend-.jumptbl)/2
	JP P,.unknowncall
	EX AF,AF'
	ld h,0
	add hl,hl
	ex de,hl
	add ix,de
	ex de,hl
	ld l,(ix+0)
	ld h,(ix+1)
	pop ix
	EX AF,AF'
	LD A,H
	OR L
	JP Z,.unknowncall
	EX AF,AF'
	jp (hl)
	
	;jump table
.jumptbl:
	defw	F_b_buflen
	defw	F_initscr
	defw	0
	defw	0
	defw	F_setfont
	defw	F_getfont
	defw	0
	defw	0
	defw	F_raw
	defw	F_cbreak
	defw	0
	defw	0
	defw	F_delay
	defw	F_nodelay
	defw	0
	defw	0
	defw	F_getch
	defw	0,0,0,0,0,0,0
	defw	F_input_isv
	defw	0,0,0,0,0,0,0
	defw	F_addch
	defw	F_addstr
	defw	0;F_erase
	defw	0;F_clrtobot
	defw	0;F_clearok
	defw	0;F_beep
	defw	F_scroll
	defw	0,0,0,0,0,0,0,0,0
	defw	F_mvaddch
	defw	F_mvaddstr
	defw	F_clear
	defw	0;F_clrtoeol
	defw	0
	defw	0;F_flash
	defw	0;F_rscroll
	defw	0,0,0,0,0,0,0,0
	defw	F_refresh
	defw	F_attrset
	defw	F_attrget
	defw	0;F_attron
	defw	0;F_attroff
	defw	0;F_chgat
	defw	0,0,0,0,0,0,0
	defw	0;F_mvchgat
	defw	0,0,0
	defw	F_getcury
	defw	F_getcurx
	defw	F_getmaxy
	defw	F_getmaxx
	defw	0;F_inch
	defw	0,0,0
	defw	F_move
	defw	0,0,0
	defw	0;F_mvinch
	defw	0,0,0
.jumpend:

.unknowncall:
	;the call byte is not matched by anything
	pop hl	;we didn't "return" to .finished
	call F_restorepage
	ld a, modulecall_no_such_modulecall	;error no such function
	scf					;signal an error
	ret

.finished:
	call F_restorepage
	and a
	ret
