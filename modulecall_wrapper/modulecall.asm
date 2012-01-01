;modulecall functions
DEFC modulecall_blast_buflen			= 0x00		;modulecall 0x0400
DEFC modulecall_blast_b_buflen			= 0x00
DEFC modulecall_blast_initscr			= 0x01
DEFC modulecall_blast_setfont			= 0x04
DEFC modulecall_blast_getfont			= 0x05
DEFC modulecall_blast_raw				= 0x08
DEFC modulecall_blast_cbreak			= 0x09
DEFC modulecall_blast_delay				= 0x0C
DEFC modulecall_blast_nodelay			= 0x0D
DEFC modulecall_blast_getch				= 0x10
DEFC modulecall_blast_input_isv			= 0x18
DEFC modulecall_blast_addch				= 0x20
DEFC modulecall_blast_mvaddch			= 0x30
DEFC modulecall_blast_addstr			= 0x21
DEFC modulecall_blast_mvaddstr			= 0x31
DEFC modulecall_blast_erase				= 0x22
DEFC modulecall_blast_clear				= 0x32
DEFC modulecall_blast_cleartobot		= 0x23
DEFC modulecall_blast_cleartoeol		= 0x33
DEFC modulecall_blast_clearok			= 0x24
DEFC modulecall_blast_beep				= 0x25
DEFC modulecall_blast_flash				= 0x35
DEFC modulecall_blast_scroll			= 0x26
DEFC modulecall_blast_rscroll			= 0x36
DEFC modulecall_blast_refresh			= 0x3F
DEFC modulecall_blast_attrset			= 0x40
DEFC modulecall_blast_attrget			= 0x41
DEFC modulecall_blast_attron			= 0x42
DEFC modulecall_blast_attroff			= 0x43
DEFC modulecall_blast_chgat				= 0x44
DEFC modulecall_blast_mvchgat			= 0x4C
DEFC modulecall_blast_getcury			= 0x50
DEFC modulecall_blast_getcurx			= 0x51
DEFC modulecall_blast_getmaxy			= 0x52
DEFC modulecall_blast_getmaxx			= 0x53
DEFC modulecall_blast_inch				= 0x54
DEFC modulecall_blast_move				= 0x58
DEFC modulecall_blast_mvinc				= 0x5C

DEFC MODULECALL = 0x3FF8

DEFC MODULE_ID = 0x04	;same as in ../blast_module.inc

