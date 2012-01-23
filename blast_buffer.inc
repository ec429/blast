; blast - a curses-alike library for the ZX Spectrum
;	Copyright (c) Edward Cree, 2011 <http://jttlov.no-ip.org>
;	Licensed under GNU GPL v3+; there is NO WARRANTY
;		see <http://www.gnu.org/licenses/gpl.html> or file COPYING
;	blast_buffer.inc: offsets in the buffer struct
;	USER CODE SHOULD NOT GO NEAR THIS!  Only for use in font drivers etc.

O_MAXY		equ	0
O_MAXX		equ	1
O_CURY		equ	2
O_CURX		equ	3
O_INMODE	equ	4
O_INTM		equ	5
O_INWAIT	equ	6
O_INBUFP	equ	7
O_INBUF		equ	8
O_INLASTSCN	equ	0x10
O_FONT		equ	0x12
O_FONTSTAND	equ	0x14
O_FONTFMT	equ	0x16
O_ATTR		equ	0x17
O_ADO		equ	0x18
O_YOFF		equ	0x1A
O_XOFF		equ	0x1B
O_CHARDATA	equ	0x20