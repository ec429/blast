include "modulecall.asm"

	XLIB blast_buflen
	
.blast_buflen
	ld hl,2
    add hl,sp			; skip over return address on stack
    ld c,(hl)			; c = columns
	inc hl
    inc hl
    ld b,(hl)			; b = lines
	
	ld h,MODULE_ID
	ld l,modulecall_blast_buflen
	call MODULECALL
	
	ret
