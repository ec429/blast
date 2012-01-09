include "modulecall.asm"

	XLIB blast_mvaddstr
	
.blast_mvaddstr
	ld hl,0
	add hl,sp	;save sp in hl
	
	pop ix		;don't care
	pop ix		;ix = *str
	pop bc		;c = x
	pop de		;e = y
	ld b,e		;b = y, c = x
	push ix
	pop de		;de = *str
	pop ix		;ix = *buffer
	ld sp,hl	;restore sp
	
	ld h,MODULE_ID
	ld l,modulecall_blast_mvaddstr
	call MODULECALL

	ld h,0
	ld l,a
		
	ret
