include "modulecall.asm"

	XLIB blast_mvchgat
	
.blast_mvchgat
	ld hl,0
	add hl,sp	;save sp in hl
	
	pop ix		;don't care
	pop bc		;c = x
	pop de		;e = y
	ld b,e		;b = y, c = x
	pop de		;e = count
	ld a,e		;a = count
	pop ix		;ix = *buffer
	ld sp,hl	;restore sp
	
	ld h,MODULE_ID
	ld l,modulecall_blast_mvchgat
	call MODULECALL

	ld h,0
	ld l,a
		
	ret
