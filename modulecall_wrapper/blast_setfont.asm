include "modulecall.asm"

	XLIB blast_setfont
	
.blast_setfont
	ld hl,0
	add hl,sp	;save sp in hl
	
	pop ix		;don't care
	pop bc		;c = options
	ld a,c		;a = options
	pop de		;de = *fontdata
	pop ix		;ix = *buffer
	ld sp,hl	;restore sp
	
	ld h,MODULE_ID
	ld l,modulecall_blast_setfont
	call MODULECALL

	ld h,0
	ld l,a
		
	ret
