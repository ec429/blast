include "modulecall.asm"

	XLIB blast_offset
	
.blast_offset
	ld hl,0
	add hl,sp	;save sp in hl
	
	pop ix		;don't care
	pop bc		;c = x_off
	pop de		;e = y_off
	ld b,e		;b = y_off, c = x_off
	pop ix		;ix = *buffer
	ld sp,hl	;restore sp
	
	ld h,MODULE_ID
	ld l,modulecall_blast_offset
	call MODULECALL

	ld h,0
	ld l,a
		
	ret
