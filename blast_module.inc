;module number
blast_module_id						equ 0x04	; unique module id

;modulecalls
modulecall_blast_buflen				equ 0x00
modulecall_blast_initscr			equ 0x01
modulecall_blast_setfont			equ 0x04
modulecall_blast_getfont			equ 0x05
modulecall_blast_raw				equ 0x08
modulecall_blast_cbreak				equ 0x09
modulecall_blast_delay				equ 0x0C
modulecall_blast_nodelay			equ 0x0D
modulecall_blast_getch				equ 0x10
modulecall_blast_input				equ 0x18
modulecall_blast_addch				equ 0x20
modulecall_blast_mvaddch			equ 0x30
modulecall_blast_addstr				equ 0x21
modulecall_blast_mvaddstr			equ 0x31
modulecall_blast_erase				equ 0x22
modulecall_blast_clear				equ 0x32
modulecall_blast_clrtobot			equ 0x23
modulecall_blast_clrtoeol			equ 0x33
modulecall_blast_clearok			equ 0x24
modulecall_blast_beep				equ 0x25
modulecall_blast_flash				equ 0x35
modulecall_blast_scroll				equ 0x26
modulecall_blast_rscroll			equ 0x36
modulecall_blast_refresh			equ 0x3F
modulecall_blast_attrset			equ 0x40
modulecall_blast_attrget			equ 0x41
modulecall_blast_attron				equ 0x42
modulecall_blast_attroff			equ 0x43
modulecall_blast_chgat				equ 0x44
modulecall_blast_mvchgat			equ 0x4C
modulecall_blast_getcury			equ 0x50
modulecall_blast_getcurx			equ 0x51
modulecall_blast_getmaxy			equ 0x52
modulecall_blast_getmaxx			equ 0x53
modulecall_blast_inch				equ 0x54
modulecall_blast_move				equ 0x58
modulecall_blast_mvinch				equ 0x5C

;modulecall return values
modulecall_no_such_module			equ 0xff
modulecall_no_such_modulecall		equ 0xfe

;builtin font ids (getfont)
blast_fontid_ao64					equ 0x02

