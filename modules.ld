/* Spectranet modules LD script */
OUTPUT_FORMAT("binary")
OUTPUT_ARCH("z80")
MEMORY {
   blast : ORIGIN = 0x2000, LENGTH = 0x1000
}
SECTIONS
{
.vectors : {
        *(.vectors)
        *(vectors)
        __Hvectors = .;
      } > blast
.isr : {
        *(.isr)
        *(isr)
        __Hisr = .;
       } > blast
.text : {
		*(driver)
        *(.text)
        *(text)
         __Htext = .;
        } > blast
.data : {
         __Ldata = .;
        *(.data)
        *(data)
         __Hdata = .;
        } > blast
}

