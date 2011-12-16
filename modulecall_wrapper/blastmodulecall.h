/* header file for the blast module modcalls */

#ifndef _BLASTMODULECALL_H
#define _BLASTMODULECALL_H

#define BLAST_NO_MODULE			0xff	//255
#define BLAST_NO_MODULECALL		0xfe	//254

extern unsigned int __LIB__ blast_buflen(unsigned char lines, unsigned char columns);

#endif