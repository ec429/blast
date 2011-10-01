# Makefile for blast, a curses-alike library for the ZX Spectrum

CC := gcc
CFLAGS := -Wall -Wextra -Werror -pedantic --std=gnu99
AS := z80-unknown-coff-as
ASFLAGS := -z80
LD := z80-unknown-coff-ld
LDFLAGS := -T blast.ld

OBJS := blast.o

all: test.tap

maketap: maketap.c
	$(CC) $(CFLAGS) -o $@ $<

test.tap: test maketap test_bas.tap
	cp test_bas.tap test.tap
	./maketap --org=32768 < test >> test.tap

test: test.o $(OBJS) blast.ld
	$(LD) -o $@ $(OBJS) $< $(LDFLAGS)

blast.o test.o: blast.inc

%.o: %.asm
	$(AS) $(ASFLAGS) $< -o $@

