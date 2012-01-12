include "modulecall.asm"

	XLIB blast_move
	
.blast_move
	ld hl,0
	add hl,sp	;save sp in hl
	
	pop ix		;don't care
	pop bc		;c = x
	pop de		;e = y
	ld b,e		;b = y, c = x
	pop ix		;ix = *buffer
	ld sp,hl	;restore sp
	
	ld h,MODULE_ID
	ld l,modulecall_blast_move
	call MODULECALL

	ld h,0
	ld l,a
		
	ret
