LIBLINKER = z80asm -d -ns -nm -Mo
OUT = blastmodulecall.lib
MODULES = blastmodulecall.lst

all:	build

build:	$(OBJS)
	$(LIBLINKER) -x$(OUT) @$(MODULES)

clean:
	rm -f *.o *.lib
