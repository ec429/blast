/* LD script for blast test */
OUTPUT_FORMAT("binary")
OUTPUT_ARCH("z80")
MEMORY {
   program : ORIGIN = 0x8000, LENGTH = 0x2C00
   isr : ORIGIN = 0xAC00, LENGTH = 0x0400
   blast : ORIGIN = 0xC000, LENGTH = 0x4000
}
SECTIONS
{
.blast : {
		*(driver)
		*(font)
		blast.o
		} > blast
.text : {
		*(.text)
		*(text)
		} > program
.isr : {
		*(.isr)
		*(isr)
		} > isr
.data : {
		*(.data)
		*(data)
		} > program
}
