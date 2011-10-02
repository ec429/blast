/* LD script for blast test */
OUTPUT_FORMAT("binary")
OUTPUT_ARCH("z80")
MEMORY {
   program : ORIGIN = 0x8000, LENGTH = 0x4000
   blast : ORIGIN = 0xC000, LENGTH = 0x4000
}
SECTIONS
{
.blast : {
        blast.o
        } > blast
.text : {
        *(.text)
        *(text)
        } > program
.data : {
        *(.data)
        *(data)
        } > program
}
