include "modulecall.asm"

	XLIB blast_inch
	
.blast_inch
	ld hl,0
	add hl,sp	;save sp in hl
	
	pop ix		;don't care
	pop ix		;ix = *buffer
	ld sp,hl	;restore sp
	
	ld h,MODULE_ID
	ld l,modulecall_blast_inch
	call MODULECALL

	;character in L and attribute in H
	
	ret
