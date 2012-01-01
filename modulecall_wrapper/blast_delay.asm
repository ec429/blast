include "modulecall.asm"

	XLIB blast_delay
	
.blast_delay
	ld hl,0
	add hl,sp	;save sp in hl
	
	pop ix		;don't care
	pop bc		;c = timeout
	ld a,c		;a = timeout
	pop ix		;ix = *buffer
	ld sp,hl	;restore sp
	
	ld h,MODULE_ID
	ld l,modulecall_blast_delay
	call MODULECALL

	ld h,0
	ld l,a
		
	ret
