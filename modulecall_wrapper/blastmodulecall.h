/* header file for the blast module modcalls */

#ifndef _BLASTMODULECALL_H
#define _BLASTMODULECALL_H

/* error codes */
#define	BE_BADB					0x01
#define	BE_INVAL				0x02
#define	BE_RANGE				0x03
#define	BE_ATTR					0x04
#define BE_CTRL					0x05
#define BE_NO_MODULECALL		0xfe	//254
#define BE_NO_MODULE			0xff	//255

extern unsigned int __LIB__ blast_buflen(unsigned char lines, unsigned char columns);
extern unsigned char __LIB__ blast_initscr(void *buffer, unsigned char lines, unsigned char columns);

#endif