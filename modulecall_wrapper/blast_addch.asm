include "modulecall.asm"

	XLIB blast_addch
	
.blast_addch
	ld hl,0
	add hl,sp	;save sp in hl
	
	pop ix		;don't care
	pop bc		;c = ch
	ld a,c		;a = ch
	pop ix		;ix = *buffer
	ld sp,hl	;restore sp
	
	ld h,MODULE_ID
	ld l,modulecall_blast_addch
	call MODULECALL

	ld h,0
	ld l,a
		
	ret
