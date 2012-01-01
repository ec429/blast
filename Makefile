# Makefile for blast, a curses-alike library for the ZX Spectrum

CC := gcc
CFLAGS := -Wall -Wextra -Werror -pedantic --std=gnu99
AS := z80-unknown-coff-as
ASFLAGS := -z80
LD := z80-unknown-coff-ld
LDFLAGS := -T blast.ld
OBJS := blast.o ao42.o ao64.o
MLDFLAGS := -T modules.ld
MOBJS := blast_module.o modulecall_dispatcher.o getfont.o

all: test.tap blast.module modulecall module_exerciser.tap

blast.module: $(MOBJS)
	$(LD) -o blast.module $(MOBJS) $(OBJS) $(MLDFLAGS)

modulecall:
	make -C modulecall_wrapper

maketap: maketap.c
	$(CC) $(CFLAGS) -o $@ $<

module_exerciser.tap: module_exerciser maketap test_bas.tap
	./maketap --org=32768 "<module_exerciser" ">module_exerciser_bin.tap"
	cat test_bas.tap module_exerciser_bin.tap > module_exerciser.tap
	-rm module_exerciser_bin.tap

test.tap: test maketap test_bas.tap
	./maketap --org=32768 "<test" ">test_bin.tap"
	cat test_bas.tap test_bin.tap > test.tap
	-rm test_bin.tap

test: test.o $(OBJS) blast.ld
	$(LD) -o $@ $(OBJS) $< $(LDFLAGS)

blast.o: ao42.o

blast.o test.o: blast.inc

blast_module.o: blast_module.inc spectranet.inc sysvars.inc

test.o: blast.inc GenevaMono.font

module_exerciser.o: blast.inc spectranet.inc blast_module.inc

module_exerciser: module_exerciser.o blast.ld
	$(LD) -o $@ $(OBJS) $< $(LDFLAGS)

modulecall_dispatcher.o: blast.inc blast_module.inc

%.o: %.asm
	$(AS) $(ASFLAGS) $< -o $@

blast_module.o: ver.asm

ver.asm: FORCE
	./constructversion

FORCE:

clean:
	-rm -f *.o *.module *.bin
