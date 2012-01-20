include "blast_module.inc"

;spectranet include files
include "spectranet.inc"
include "sysvars.inc"

; spectranet module vector table
.section vectors
		defb 0xAA				; This is a ROM module
		defb blast_module_id	; our unique ID
		defw 0xFFFF				; no reset vector
		defw 0xFFFF
		defw 0xFFFF
		defw 0xFFFF
		defw 0xFFFF
		defw 0xFFFF
		defw STR_ident			; ROM identity string
		jp J_blast_modulecall	; MODULECALL entry point
		
.data
include "ver.asm"	; generated file containing the defenition of STR_ident, e.g. 'STR_ident: defb "Blast 0.1.2-3-gdeadbee",0'

