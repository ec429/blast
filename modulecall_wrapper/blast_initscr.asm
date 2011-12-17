include "modulecall.asm"

	XLIB blast_initscr
	
.blast_initscr
	ld hl,0
	add hl,sp	;save sp in hl
	
	pop ix		;don't care
	pop bc		;c = columns
	pop de		;e = lines
	ld b,e		;b = lines, c = columns
	pop ix		;ix = *buffer
	ld sp,hl	;restore sp
	
	ld h,MODULE_ID
	ld l,modulecall_blast_buflen
	call MODULECALL
	
	ret
