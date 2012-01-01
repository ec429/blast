; blast - a curses-alike library for the ZX Spectrum
;	Copyright (c) Edward Cree, 2011 <http://jttlov.no-ip.org>
;	Licensed under GNU GPL v3+; there is NO WARRANTY
;		see <http://www.gnu.org/licenses/gpl.html> or file COPYING
;	getfont: get addresses of builtin fonts (for dynamic Spectranet module)
;	entry call F_getfont
;	fontid=A

.text
.global F_getfont
F_getfont:
	CP (.END_fonts-.TBL_fonts)/2
	LD HL,0
	RET P
	LD DE,.TBL_fonts
	LD H,0
	LD L,A
	ADD HL,HL
	ADD HL,DE
	LD E,(HL)
	INC HL
	LD D,(HL)
	RET

.data
.TBL_fonts:
	defw 0
	defw 0
	defw TBL_AO64font
.END_fonts:
