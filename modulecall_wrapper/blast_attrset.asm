include "modulecall.asm"

	XLIB blast_attrset
	
.blast_attrset
	ld hl,0
	add hl,sp	;save sp in hl
	
	pop ix		;don't care
	pop bc		;c = attrib
	ld a,c		;a = attrib
	pop ix		;ix = *buffer
	ld sp,hl	;restore sp
	
	ld h,MODULE_ID
	ld l,modulecall_blast_attrset
	call MODULECALL

	ld h,0
	ld l,a
		
	ret
