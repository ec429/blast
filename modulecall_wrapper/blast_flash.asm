include "modulecall.asm"

	XLIB blast_flash
	
.blast_flash
	ld h,MODULE_ID
	ld l,modulecall_blast_flash
	call MODULECALL
	
	ret
