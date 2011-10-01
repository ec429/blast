blast - like curses

sizeof(short)==8; sizeof(long)==16.  Both are unsigned by default.
sizeof(foo *)==16 forall foo, of course.
typedef short bool;
typedef short int;
typedef short char;
Calling conventions:
	shorts in A,B,C
	longs in HL,DE,BC
	if too many to fit, then on stack [first, ..., last, return_address]
	in general, indicated by __regname in this documentation.
	a function may trample /any/ register, so be sure to save the regs you care about on the stack (note: this includes argument registers)
Return conventions:
	short: A
	long: HL
	void: if error, then sets Carry flag.
Where the return value is used to indicate error conditions, success is indicated with the value 0.
Notes:
1.	While an implementation may choose to minimise the amount of painting (except where forced to repaint by clearok()), it is not required to do so; in particular it is permitted to simply repaint the entire screen each time refresh() is called.  Similarly, where optimisation is present, its degree is implementation-defined (for instance an implementation may repaint both the character and its attribute when only one or other has been changed; it may repaint a cell which has been 'changed' to the same character it previously contained; etc).

#define	BE_BADB		1
#define	BE_INVAL	2
#define	BE_RANGE	3
#define	BE_ATTR		4

Initialisation/option functions:
long b_buflen(short lines __A, short columns __B)
	Returns the length (in bytes) of the buffer which initscr() will require.
short initscr(void *buffer __HL, short lines __A, short columns __B)
	Set up blast data area.
	BE_INVAL: buffer==NULL.
	BE_RANGE: lines > 24 or lines*columns > 2040.
short setfont(void *buffer __HL, void *fontdata __DE, short options __A)
	Sets buffer to use the supplied font.  Implementations (and third-party fonts) should document the values of columns and opts required for each font to render correctly.  initscr() sets the font address to the Spectrum's 40-column ROM font.
	options consists of flags which may be bitwise ORed together (except that only one BFF_format may be used):
		0x00	BFF_ROMFONT		Use the ROM font format (this is the default).
		0x01	BFF_TRUEFONT	Use Andrew Owen's TrueFONT format.
		0x10	BFO_STANDOUT	Font is to be used for text with the standout attribute set.  (If the columns value does not match that of the non-standout font, returns BE_INVAL).  If fontdata is NULL, generated underlining is used for standout (and columns is ignored).
		(more formats and options may be added later).
	BE_INVAL: buffer==NULL, or bad arguments.
	BE_BADB: bad (corrupted?) buffer.
short raw(void *buffer __HL)
	Puts buffer into raw input mode.
	BE_INVAL: buffer==NULL.
	BE_BADB: bad (corrupted?) buffer.
short cbreak(void *buffer __HL)
	Puts buffer into cbreak (half-cooked) input mode.  This is the default after initscr().
	BE_INVAL: buffer==NULL.
	BE_BADB: bad (corrupted?) buffer.
short nocbreak(void *buffer __HL, char *linebuf __DE, long linebuflen __BC)
	Puts buffer into nocbreak (line, "cooked") input mode.  In line mode the bottom row of the screen is reserved for line input.
	BE_INVAL: buffer==NULL.
	BE_BADB: bad (corrupted?) buffer.
#define noraw(b) nocbreak(b)
short echo(void *buffer __HL, bool doecho __A)
	Enables or disables character echoing (has no effect in line mode, wherein characters are always echoed).
	BE_INVAL: buffer==NULL.
	BE_BADB: bad (corrupted?) buffer.
short delay(void *buffer __HL, long timeout __DE)
	Sets delay mode if timeout==0, else half-delay mode.
	BE_INVAL: buffer==NULL.
	BE_BADB: bad (corrupted?) buffer.
short nodelay(void *buffer __HL)
	Sets no-delay mode.
	BE_INVAL: buffer==NULL.
	BE_BADB: bad (corrupted?) buffer.

Input functions:
char getch(void *buffer __HL)
	Reads a character from the keyboard.  Returns 0 if no input waiting (and, in half-delay mode, timeout reached).
	For details of return values see "Keymapping", below.
char *getstr(void *buffer __HL)
	Reads a line from the keyboard.  Returns NULL if no input waiting (otherwise the address should be within the linebuf supplied by nocbreak()) or if not in nocbreak (line) mode.  Unlike _getch(), does not return mapped keys (instead, function keys are used for line editing); the string returned by getstr() should consist entirely of printable characters (except for the trailing NUL).
void input_isv(void *buffer __HL)
	Interrupt Service routine to read the keyboard; a call to this function should be placed in your own interrupt service routine.

Output functions:
short addch(void *buffer __HL, char ch __A)
	
short mvaddch(void *buffer __HL, short y __B, short x __C, char ch __A)
	
short addstr(void *buffer __HL, void *str __DE)
	
short mvaddstr(void *buffer __HL, short y __B, short x __C, void *str __DE)
	
short erase(void *buffer __HL)
	Write blanks to every position in the window (with the currently set attribute).
	BE_INVAL: buffer==NULL.
	BE_BADB: bad (corrupted?) buffer.
short clear(void *buffer __HL)
	Like erase, but also calls clearok.
	BE_INVAL: buffer==NULL.
	BE_BADB: bad (corrupted?) buffer.
short clrtobot(void *buffer __HL)
	Erase from the cursor to the end of screen.
	BE_INVAL: buffer==NULL.
	BE_BADB: bad (corrupted?) buffer.
short clrtoeol(void *buffer __HL)
	Erase from the cursor to the end of line.
	BE_INVAL: buffer==NULL.
	BE_BADB: bad (corrupted?) buffer.
void clearok(void *buffer __HL)
	Marks the buffer to be repainted from scratch when next refresh() is called.  See note 1.
	(error if buffer==NULL)
void beep(void)
	Sounds an audible bell.
void flash(void)
	Flashes the screen (inverse video for a small number of frames).
short scroll(void *buffer __HL, signed short count __A)
	Scrolls the screen up count lines (down if count < 0); that is, the text moves up (which is equivalent to the screen moving down).  This will typically produce a rather time-consuming repaint on the next refresh(), so use rscroll() where possible.  Generated blanks use the currently set attributes.
	BE_INVAL: buffer==NULL.
	BE_BADB: bad (corrupted?) buffer.
short rscroll(void *buffer __HL, signed short count __A)
	refresh()es the screen, then scrolls both the buffer and the screen up count lines.  Use of this function allows certain optimisations which would not be possible if scroll() and then refresh() were called.
	BE_INVAL: buffer==NULL.
	BE_BADB: bad (corrupted?) buffer.
short refresh(void *buffer __HL)
	Paints the buffer to the screen.
	BE_INVAL: buffer==NULL.
	BE_BADB: bad (corrupted?) buffer.

Attribute functions:
short attrset(void *buffer __HL, char attrib __A)
	
short attron(void *buffer __HL, char attrib __A)
	
short attroff(void *buffer __HL, char attrib __A)
	
char attrget(void *buffer __HL)
	Returns the currently set attribute.
short chgat(void *buffer __HL, short count __A)
	Changes the attributes of count characters (starting at the cursor) to the currently set attributes.  It does not update the cursor and does not perform wrapping.  A character count of 0xFF means to change attributes all the way to the end of the current line.
	BE_INVAL: buffer==NULL.
	BE_BADB: bad (corrupted?) buffer.
short mvchgat(void *buffer __HL, short count __A, short y __B, short x __C)
	Like move(buffer, y, x) followed by chgat(buffer, count).
	BE_INVAL: buffer==NULL.
	BE_BADB: bad (corrupted?) buffer.
	BE_RANGE: y or x out of valid range.

Cursor functions:
short move(void *buffer __HL, short y __B, short x __C)
	BE_INVAL: buffer==NULL.
	BE_BADB: bad (corrupted?) buffer.
	BE_RANGE: y or x out of valid range.
short getcury(void *buffer __HL)
	0xFF on error.
short getcurx(void *buffer __HL)
	0xFF on error.
short getmaxy(void *buffer __HL)
	0xFF on error.
short getmaxx(void *buffer __HL)
	0xFF on error.
long inch(void *buffer __HL)
	Returns the character (in L) and attribute (in H) under the cursor; 0 on error.
long mvinch(void *buffer __HL, short y __B, short x __C)
	

Attributes:
attron() values:
	0x00 to 0x07: ink colour
	0x08 to 0x0F: paper colour
	0x40 bright
	0x80 standout
	otherwise BE_ATTR
attr_off(any ink colour) sets black ink
attr_off(any paper colour) sets white paper
It is an implementation detail whether standout is done by flash or by a modified font (eg. bold, or underline).
attrset() and attrget() use SBPPPIII (that is, like a Spectrum attribute byte but with standout in place of flash).
initscr() sets attributes to ink 0, paper 7, bright 0, standout 0 (that is, attrset(0x38)).

Keymapping:
