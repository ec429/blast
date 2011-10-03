#include <stdio.h>
#include <stdint.h>
#include <string.h>

int main(int argc, char *argv[])
{
	FILE *fin=stdin, *fout=stdout;
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
		else if(argv[arg][0]=='<')
		{
			FILE *fp=fopen(argv[arg]+1, "rb");
			if(fp) fin=fp;
			else
			{
				fprintf(stderr, "maketap: failed to open input file: %s\n", argv[arg]+1);
				perror("fopen");
				return(1);
			}
		}
		else if(argv[arg][0]=='>')
		{
			FILE *fp=fopen(argv[arg]+1, "wb");
			if(fp) fout=fp;
			else
			{
				fprintf(stderr, "maketap: failed to open output file: %s\n", argv[arg]+1);
				perror("fopen");
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
	while((i=fgetc(fin))!=EOF)
		data[pos++]=(unsigned char)i;
	uint16_t len=pos;
	fprintf(stderr, "maketap: org=%04x len=%04x\n", org, len);
	fputc(0x13, fout);
	fputc(0, fout);
	fputc(0, fout);
	fputc(3, fout);
	fputs("bin       ", fout);
	uint8_t cksum=0x23^'b'^'i'^'n';
	fputc(len, fout);
	cksum^=len;
	fputc(len>>8, fout);
	cksum^=(len>>8);
	fputc(org, fout);
	cksum^=org;
	fputc(org>>8, fout);
	cksum^=(org>>8);
	fputc(0, fout);
	fputc(0x80, fout);
	cksum^=0x80;
	fputc(cksum, fout);
	fputc(len+2, fout);
	fputc((len+2)>>8, fout);
	fputc(0xff, fout);
	cksum=0xff;
	for(pos=0;pos<len;pos++)
	{
		fputc(data[pos], fout);
		cksum^=data[pos];
	}
	fputc(cksum, fout);
	fclose(fin);
	fclose(fout);
	return(0);
}
