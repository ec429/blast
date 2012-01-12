include "modulecall.asm"

	XLIB blast_chgat
	
.blast_chgat
	ld hl,0
	add hl,sp	;save sp in hl
	
	pop ix		;don't care
	pop bc		;c = count
	ld a,c		;a = count
	pop ix		;ix = *buffer
	ld sp,hl	;restore sp
	
	ld h,MODULE_ID
	ld l,modulecall_blast_chgat
	call MODULECALL

	ld h,0
	ld l,a
		
	ret
