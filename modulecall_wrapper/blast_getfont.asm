include "modulecall.asm"

	XLIB blast_getfont
	
.blast_getfont
	ld hl,2
    add hl,sp			; skip over return address on stack
    ld a,(hl)			; A = fontid
	
	ld h,MODULE_ID
	ld l,modulecall_blast_getfont
	call MODULECALL
	
	ex de,hl			; put the result in HL
	ret
