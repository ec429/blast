include "blast_module.inc"

;spectranet include files
include "spectranet.inc"
include "sysvars.inc"

; spectranet module vector table
.section vectors
		defb 0xAA				; This is a ROM module
		defb module_id			; our unique ID
		defw F_init				; reset vector
		defw 0xFFFF
		defw 0xFFFF
		defw 0xFFFF
		defw 0xFFFF
		defw 0xFFFF
		defw STR_ident			; ROM identity string
		jp J_blast_modulecall	; MODULECALL entry point
		
.data
include "ver.asm"	; generated file containing the defenition of STR_ident, e.g. 'STR_ident: defb "Blast rev. 1",0'

; F_init: module initialisation
F_init:
	;Claim a page of SRAM for our sysvars.
	ld a, (v_pgb)		; Who are we?
	call RESERVEPAGE	; Reserve a page of static RAM.
	jr c, .failed
	ld b, a			; save the page number
	ld a, (v_pgb)		; and save the page we got
	rlca			; in our 8 byte area in sysvars
	rlca			; which we find by multiplying our ROM number
	rlca			; by 8.
	ld h, 0x39		; TODO - definition for this.
	ld l, a
	ld a, b
	ld (hl), a		; put the page number in byte 0 of this area.
	
	call F_restorepage
	ret

.failed:
	ld hl, STR_allocfailed
	call PRINT42
	ret
STR_allocfailed:	defb	"No memory pages available\n",0

; F_fetchpage
; Gets our page of RAM and puts it in page area A.
.globl F_fetchpage
F_fetchpage:
	push af
	push hl
	ld a, (v_pgb)		; get our ROM number and calculate
	rlca			; the offset in sysvars
	rlca
	rlca
	ld h, 0x39		; address in HL
	ld l, a
	ld a, (hl)		; fetch the page number
	and a			; make sure it's nonzero
	jr z, .nopage
	inc l			; point hl at "page number storage"
	ex af, af'
	ld a, (v_pga)
	ld (hl), a		; store current page A
	ex af, af'
	call SETPAGEA		; Set page A to the selected page
	pop hl
	pop af
	or a			; ensure carry is cleared
	ret
.nopage:
	pop hl			; restore the stack
	pop af
	ld a, 0xFF		; TODO: ENOMEM return code
	scf
	ret

; F_restorepage
; Restores page A to its original value.
.globl F_restorepage
F_restorepage:
	push af
	push hl
	ld a, (v_pgb)		; calculate the offset...
	rlca
	rlca
	rlca
	inc a			; +1
	ld h, 0x39
	ld l, a
	ld a, (hl)		; fetch original page
	call SETPAGEA		; and restore it
	pop hl
	pop af
	ret
