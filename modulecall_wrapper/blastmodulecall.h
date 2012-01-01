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

/* entry points */
extern unsigned int	__LIB__ blast_buflen(unsigned char lines, unsigned char columns);
extern unsigned char __LIB__ blast_initscr(void *buffer, unsigned char lines, unsigned char columns);
extern unsigned char __LIB__ blast_setfont(void *buffer, void *fontdata, unsigned char options);
extern void __LIB__ *blast_getfont(unsigned char fontid);
extern unsigned char __LIB__ blast_raw(void *buffer);
extern unsigned char __LIB__ blast_cbreak(void *buffer);
extern unsigned char __LIB__ blast_delay(void *buffer, unsigned char timeout);
extern unsigned char __LIB__ blast_nodelay(void *buffer);

extern unsigned char __LIB__ blast_getch(void *buffer);
extern void __LIB__ blast_input_isv(void *buffer);

extern unsigned char __LIB__ blast_addch(void *buffer, char ch);
extern unsigned char __LIB__ blast_mvaddch(void *buffer, unsigned char y, unsigned char x, char ch);

extern unsigned char __LIB__ blast_refresh(void *buffer);

#endif
