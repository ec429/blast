# Makefile for blast, a curses-alike library for the ZX Spectrum

CC := gcc
CFLAGS := -Wall -Wextra -Werror -pedantic --std=gnu99
AS := z80-unknown-coff-as
ASFLAGS := -z80
LD := z80-unknown-coff-ld
LDFLAGS := -T blast.ld
OBJS := blast.o
MOBJS := blast_module.o modulecall_dispatcher.o
MOUT := blast.module
MLDFLAGS := -T modules.ld

all: test.tap $(MOUT)

$(MOUT): $(MOBJS)
	./constructversion
	$(LD) -o $(MOUT) $(MOBJS) $(OBJS) $(MLDFLAGS)

modulecall:
	make -C modulecall_wrapper

maketap: maketap.c
	$(CC) $(CFLAGS) -o $@ $<

test.tap: test maketap test_bas.tap
	./maketap --org=32768 "<test" ">test_bin.tap"
	cat test_bas.tap test_bin.tap > test.tap
	-rm test_bin.tap

test: test.o $(OBJS) blast.ld
	$(LD) -o $@ $(OBJS) $< $(LDFLAGS)

blast.o test.o: blast.inc

%.o: %.asm
	$(AS) $(ASFLAGS) $< -o $@

clean:
	-rm -f *.o *.module *.bin
