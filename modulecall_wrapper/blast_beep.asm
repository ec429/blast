include "modulecall.asm"

	XLIB blast_beep
	
.blast_beep
	ld h,MODULE_ID
	ld l,modulecall_blast_beep
	call MODULECALL
	
	ret
