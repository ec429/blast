; blast - a curses-alike library for the ZX Spectrum
;	Copyright (c) Edward Cree, 2011 <http://jttlov.no-ip.org>
;	Licensed under GNU GPL v3+; there is NO WARRANTY
;		see <http://www.gnu.org/licenses/gpl.html> or file COPYING
;	ao64: Driver for BFF_AO64 fonts (based on Andrew Owen's '64 column.asm')
;	entry call F_AO64_print
;	buffer=IX, y=B, x=C, char=A, attr=A'
.include	"blast_buffer.inc"

.section driver,"x"
.global F_AO64_print
F_AO64_print:
	EX AF, AF'
	EXX
	LD D,A		; save A' in D'
	EXX
	EX AF, AF'
	rra			; divide by two with remainder in carry
				; flag
	ld	l, a		; CHAR to low byte of HL
	ld	a, 0		; don't touch carry flag
	ld	h, a		; clear H
	ex	af, af'		; save the carry flag
	ld	d, h		; store HL in DE
	ld	e, l		; without using the stack
	add	hl, hl		; multiply
	add	hl, hl		; by
	add	hl, hl		; eight
	sbc	hl, de		; subtract DE to get original x7
	ld	e,(IX+O_FONT)	; offset
	ld	d,(IX+O_FONT+1)	; to FONT
	add	hl, de		; compensate for
	ld de,0x71		; font base being 32
	sbc hl, de		; HL holds address of first byte of character map in FONT
	push	hl		; save font address

; convert the row to the base screen address

	ld	a, b		; get the row
	and	0x18		; mask off bit 3-4
	ld	d, a		; store high byte of offset in D
	ld	a, b		; retrieve it
	and 0x07		; mask off bit 0-2
	rlca			; shift
	rlca			; five
	rlca			; bits
	rlca			; to the
	rlca			; left
	ld	e, a		; store low byte of offset in E

; add the column

	ld	a,c			; get the column
	rra				; divide by two with remainder in carry
					; flag
	push	af		; store the carry flag
	ld	h, 0x40		; base location
	ld	l, a		; plus column offset
	add	hl, de		; add the offset
	
; apply attributes
	PUSH HL
	EXX
	PUSH HL
	EXX
	SRL H
	SRL H
	SRL H
	LD A,0x50
	OR H
	LD H,A
	PUSH HL
	EXX
	POP HL
	LD (HL),D
	POP HL
	EXX
	POP HL
	ex	de, hl		; put the result back in DE

; HL now points to the location of the first byte of char data in FONT
; DE points to the first byte of the screen address
; C holds the offset to the routine

	pop	af		; restore column carry flag
	pop	hl		; restore the font address
	ld	b, 8		; 8 bytes to write
	jr	nc, odd_col	; jump if odd column

even_col:
	ex	af, af' 	; restore char position carry flag
	jr	c, l_on_l	; left char on left col
	jr	r_on_l		; right char on left col

odd_col:
	ex	af, af'		; restore char position carry flag
	jr	nc, r_on_r	; right char on right col
	jr	l_on_r		; left char on right col

; WRITE A CHARACTER TO THE SCREEN
; There are four separate routines
; HL points to the first byte of a character in FONT
; DE points to the first byte of the screen address

; left nibble on left hand side

ll_lp:
	ld	a, (hl)		; get byte of font

l_on_l:
	and	%00001111	; mask area used by new character
	ld	c, a		; store in c
	ld	a, (de)		; read byte at destination
	and	%11110000	; mask off unused half
	or	c		; combine with background
	ld	(de), a		; write it back
	inc	d		; point to next screen location
	inc	hl		; point to next font data
	djnz	ll_lp		; loop 8 times
	ret

; right nibble on right hand side

rr_lp:
	ld	a, (hl)		; read byte at destination

r_on_r:
	and	%11110000	; mask area used by new character
	ld	c, a		; store in c
	ld	a, (de)		; get byte of font
	and 	%00001111	; mask off unused half
	or	c		; combine with background
	ld	(de), a		; write it back
	inc	d		; point to next screen location
	inc	hl		; point to next font data
	djnz	rr_lp		; loop 8 times
	ret

; left nibble on right hand side

lr_lp:
	ld	a, (hl)		; read byte at destination
	rrca 			; shift right
	rrca			; four bits
	rrca			; leaving 7-4
	rrca			; empty

l_on_r:
	and	%11110000	; mask area used by new character
	ld	c, a		; store in c
	ld	a, (de)		; get byte of font
	and	%00001111	; mask off unused half
	or	c		; combine with background
	ld	(de), a		; write it back
	inc	d		; point to next screen location
	inc	hl		; point to next font data
	djnz	lr_lp		; loop 8 times
	ret

; right nibble on left hand side

rl_lp:
	ld	a, (hl)		; read byte at destination
	rlca			; shift left
	rlca			; four bits
	rlca			; leaving 3-0
	rlca			; empty

r_on_l:
	and	%00001111	; mask area used by new character
	ld	c, a		; store in c
	ld	a, (de)		; get byte of font
	and	%11110000	; mask off unused half
	or	c		; combine with background
	ld	(de), a		; write it back
	inc	d		; point to next screen location
	inc	hl		; point to next font data
	djnz	rl_lp		; loop 8 times
	ret

; HALF WIDTH 4x8 FONT
; Top row is always zero and not stored (336 bytes)

.section font,"dr"
.global TBL_AO64font
TBL_AO64font:
	defb	0x02, 0x02, 0x02, 0x02, 0x00, 0x02, 0x00	; !
	defb	0x52, 0x57, 0x02, 0x02, 0x07, 0x02, 0x00	;"#
	defb	0x25, 0x71, 0x62, 0x32, 0x74, 0x25, 0x00	;$%
	defb	0x22, 0x42, 0x30, 0x50, 0x50, 0x30, 0x00	;&'
	defb	0x14, 0x22, 0x41, 0x41, 0x41, 0x22, 0x14	;()
	defb	0x20, 0x70, 0x22, 0x57, 0x02, 0x00, 0x00	;*+
	defb	0x00, 0x00, 0x00, 0x07, 0x00, 0x20, 0x20	;,-
	defb	0x01, 0x01, 0x02, 0x02, 0x04, 0x14, 0x00	;./
	defb	0x22, 0x56, 0x52, 0x52, 0x52, 0x27, 0x00	;01
	defb	0x27, 0x51, 0x12, 0x21, 0x45, 0x72, 0x00	;23
	defb	0x57, 0x54, 0x56, 0x71, 0x15, 0x12, 0x00	;45
	defb	0x17, 0x21, 0x61, 0x52, 0x52, 0x22, 0x00	;67
	defb	0x22, 0x55, 0x25, 0x53, 0x52, 0x24, 0x00	;89
	defb	0x00, 0x00, 0x22, 0x00, 0x00, 0x22, 0x02	;:;
	defb	0x00, 0x10, 0x27, 0x40, 0x27, 0x10, 0x00	;<=
	defb	0x02, 0x45, 0x21, 0x12, 0x20, 0x42, 0x00	;>?
	defb	0x23, 0x55, 0x75, 0x77, 0x45, 0x35, 0x00	;@A
	defb	0x63, 0x54, 0x64, 0x54, 0x54, 0x63, 0x00	;BC
	defb	0x67, 0x54, 0x56, 0x54, 0x54, 0x67, 0x00	;DE
	defb	0x73, 0x44, 0x64, 0x45, 0x45, 0x43, 0x00	;FG
	defb	0x57, 0x52, 0x72, 0x52, 0x52, 0x57, 0x00	;HI
	defb	0x35, 0x15, 0x16, 0x55, 0x55, 0x25, 0x00	;JK
	defb	0x45, 0x47, 0x45, 0x45, 0x45, 0x75, 0x00	;LM
	defb	0x62, 0x55, 0x55, 0x55, 0x55, 0x52, 0x00	;NO
	defb	0x62, 0x55, 0x55, 0x65, 0x45, 0x43, 0x00	;PQ
	defb	0x63, 0x54, 0x52, 0x61, 0x55, 0x52, 0x00	;RS
	defb	0x75, 0x25, 0x25, 0x25, 0x25, 0x22, 0x00	;TU
	defb	0x55, 0x55, 0x55, 0x55, 0x27, 0x25, 0x00	;VW
	defb	0x55, 0x55, 0x25, 0x22, 0x52, 0x52, 0x00	;XY
	defb	0x73, 0x12, 0x22, 0x22, 0x42, 0x72, 0x03	;Z[
	defb	0x46, 0x42, 0x22, 0x22, 0x12, 0x12, 0x06	;\]
	defb	0x20, 0x50, 0x00, 0x00, 0x00, 0x00, 0x0f	;^_
	defb	0x20, 0x10, 0x03, 0x05, 0x05, 0x03, 0x00	;£a
	defb	0x40, 0x40, 0x63, 0x54, 0x54, 0x63, 0x00	;bc
	defb	0x10, 0x10, 0x32, 0x55, 0x56, 0x33, 0x00	;de
	defb	0x10, 0x20, 0x73, 0x25, 0x25, 0x43, 0x06	;fg
	defb	0x42, 0x40, 0x66, 0x52, 0x52, 0x57, 0x00	;hi
	defb	0x14, 0x04, 0x35, 0x16, 0x15, 0x55, 0x20	;jk
	defb	0x60, 0x20, 0x25, 0x27, 0x25, 0x75, 0x00	;lm
	defb	0x00, 0x00, 0x62, 0x55, 0x55, 0x52, 0x00	;no
	defb	0x00, 0x00, 0x63, 0x55, 0x55, 0x63, 0x41	;pq
	defb	0x00, 0x00, 0x53, 0x66, 0x43, 0x46, 0x00	;rs
	defb	0x00, 0x20, 0x75, 0x25, 0x25, 0x12, 0x00	;tu
	defb	0x00, 0x00, 0x55, 0x55, 0x27, 0x25, 0x00	;vw
	defb	0x00, 0x00, 0x55, 0x25, 0x25, 0x53, 0x06	;xy
	defb	0x01, 0x02, 0x72, 0x34, 0x62, 0x72, 0x01	;z{
	defb	0x24, 0x22, 0x22, 0x21, 0x22, 0x22, 0x04	;|}
	defb	0x56, 0xa9, 0x06, 0x04, 0x06, 0x09, 0x06	;~©
