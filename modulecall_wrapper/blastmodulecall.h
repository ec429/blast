/* header file for the blast module modcalls */

#ifndef _BLASTMODULECALL_H
#define _BLASTMODULECALL_H

/* error codes */
#define	BE_BADB					0x01
#define	BE_INVAL				0x02
#define	BE_RANGE				0x03
#define	BE_ATTR					0x04
#define	BE_CTRL					0x05
#define	BE_NO_MODULECALL		0xfe	//254
#define	BE_NO_MODULE			0xff	//255

/* font flags */
#define	BFF_ROMFONT				0x00
#define	BFF_AO42				0x01
#define	BFF_AO64				0x02
#define	BFO_STANDOUT			0x10

/* getfont() fontids */
#define	BFONT_AO64				0x02

/* Attributes */
#include <spectrum.h>	/* defines the colours */
#define STANDOUT		FLASH

/* entry points */
extern unsigned int	__LIB__ blast_buflen(unsigned char lines, unsigned char columns);
extern unsigned char __LIB__ blast_initscr(void *buffer, unsigned char lines, unsigned char columns);
extern unsigned char __LIB__ blast_setfont(void *buffer, void *fontdata, unsigned char options);
extern void __LIB__ *blast_getfont(unsigned char fontid);
extern unsigned char __LIB__ blast_offset(void *buffer, unsigned char y_off, unsigned char x_off);
extern unsigned char __LIB__ blast_raw(void *buffer);
extern unsigned char __LIB__ blast_cbreak(void *buffer);
extern unsigned char __LIB__ blast_delay(void *buffer, unsigned char timeout);
extern unsigned char __LIB__ blast_nodelay(void *buffer);

extern unsigned char __LIB__ blast_getch(void *buffer);
extern void __LIB__ blast_input_isv(void *buffer);

extern unsigned char __LIB__ blast_addch(void *buffer, char ch);
extern unsigned char __LIB__ blast_mvaddch(void *buffer, unsigned char y, unsigned char x, char ch);
extern unsigned char __LIB__ blast_addstr(void *buffer, void *str);
extern unsigned char __LIB__ blast_mvaddstr(void *buffer, unsigned char y, unsigned char x, void *str);
extern unsigned char __LIB__ blast_erase(void *buffer);
extern unsigned char __LIB__ blast_clear(void *buffer);
extern unsigned char __LIB__ blast_clrtobot(void *buffer);
extern unsigned char __LIB__ blast_clrtoeol(void *buffer);
extern void __LIB__ blast_clearok(void *buffer);
extern void __LIB__ blast_beep(void);
extern void __LIB__ blast_flash(void);
extern unsigned char __LIB__ blast_scroll(void *buffer, signed char count);
extern unsigned char __LIB__ blast_rscroll(void *buffer, signed char count);
extern unsigned char __LIB__ blast_refresh(void *buffer);

extern unsigned char __LIB__ blast_attrset(void *buffer, char attrib);
extern unsigned char __LIB__ blast_attron(void *buffer, char attrib);
extern unsigned char __LIB__ blast_attroff(void *buffer, char attrib);
extern char __LIB__ blast_attrget(void *buffer);
extern unsigned char __LIB__ blast_chgat(void *buffer, unsigned char count);
extern unsigned char __LIB__ blast_mvchgat(void *buffer, unsigned char count, unsigned char y, unsigned char x);

extern unsigned char __LIB__ blast_move(void *buffer, unsigned char y, unsigned char x);
extern unsigned char __LIB__ blast_getcury(void *buffer);
extern unsigned char __LIB__ blast_getcurx(void *buffer);
extern unsigned char __LIB__ blast_getmaxy(void *buffer);
extern unsigned char __LIB__ blast_getmaxx(void *buffer);
extern unsigned char __LIB__ blast_getyoff(void *buffer);
extern unsigned char __LIB__ blast_getxoff(void *buffer);
extern unsigned int __LIB__ blast_inch(void *buffer);
extern unsigned int __LIB__ blast_mvinch(void *buffer, unsigned char y, unsigned char x);
#endif
