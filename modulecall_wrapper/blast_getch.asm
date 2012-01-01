include "modulecall.asm"

	XLIB blast_getch
	
.blast_getch
	ld hl,0
	add hl,sp	;save sp in hl
	
	pop ix		;don't care
	pop ix		;ix = *buffer
	ld sp,hl	;restore sp
	
	ld h,MODULE_ID
	ld l,modulecall_blast_getch
	call MODULECALL

	ld h,0
	ld l,a
		
	ret
