#include <stdio.h>
#include <stdint.h>
#include <string.h>

int main(int argc, char *argv[])
{
	uint16_t org=0xC000;
	for(int arg=1;arg<argc;arg++)
	{
		if(strncmp(argv[arg], "--org=", 6)==0)
		{
			if(sscanf(argv[arg]+6, "%u", (unsigned int *)&org)!=1)
			{
				fprintf(stderr, "maketap: --org without integer: %s\n", argv[arg]+6);
				return(1);
			}
		}
		else
		{
			fprintf(stderr, "maketap: unrecognised argument (ignoring): %s\n", argv[arg]);
		}
	}
	uint8_t data[0x10000-org];
	uint16_t pos=0;
	int i;
	while((i=getchar())!=EOF)
		data[pos++]=(unsigned char)i;
	uint16_t len=pos;
	fprintf(stderr, "maketap: org=%04x len=%04x\n", org, len);
	putchar(0x13);
	putchar(0);
	putchar(0);
	putchar(3);
	fputs("bin       ", stdout);
	uint8_t cksum=0x23^'b'^'i'^'n';
	putchar(len);
	cksum^=len;
	putchar(len>>8);
	cksum^=(len>>8);
	putchar(org);
	cksum^=org;
	putchar(org>>8);
	cksum^=(org>>8);
	putchar(0);
	putchar(0x80);
	cksum^=0x80;
	putchar(cksum);
	putchar(len+2);
	putchar((len+2)>>8);
	putchar(0xff);
	cksum=0xff;
	for(pos=0;pos<len;pos++)
	{
		putchar(data[pos]);
		cksum^=data[pos];
	}
	putchar(cksum);
	return(0);
}
