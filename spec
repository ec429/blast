blast - like curses

sizeof(short)==1; sizeof(long)==2.  Both are unsigned by default.
sizeof(foo *)==2 forall foo, of course.
typedef short bool;
typedef short int;
typedef short char;
Calling conventions:
	shorts in A,B,C
	longs in HL,DE,BC
	buffer pointer in IX
	if too many to fit, then on stack [first, ..., last, return_address]
	in general, indicated by __regname in this documentation.
	typically a (y,x) pair will be passed in (B,C)
	a function may trample /any/ register, so be sure to save the regs you care about on the stack (note: this includes argument registers).
	exception: void *buffer __IX is never trampled.
	The linker symbol for an entry point foo is F_foo.
Return conventions:
	short: A
	long: HL
	void: if error, then sets Carry flag.
Where the return value is used to indicate error conditions, success is indicated with the value 0.
Notes:
1.	While an implementation may choose to minimise the amount of painting (except where forced to repaint by clearok()), it is not required to do so; in particular it is permitted to simply repaint the entire screen each time refresh() is called.  Similarly, where optimisation is present, its degree is implementation-defined (for instance an implementation may repaint both the character and its attribute when only one or other has been changed; it may repaint a cell which has been 'changed' to the same character it previously contained; etc).

TO DEFINE:
	What effect do clear functions (erase(), clear(), clrtoeol(), clrtobot()) have on the cursor?  And what about [r]scroll()?

#define	BE_BADB		1
#define	BE_INVAL	2
#define	BE_RANGE	3
#define	BE_ATTR		4
#define BE_CTRL		5

Initialisation/option functions:
long b_buflen(short lines __B, short columns __C)
	Returns the length (in bytes) of the buffer which initscr() will require.
short initscr(void *buffer __IX, short lines __B, short columns __C)
	Set up blast data area.
	BE_INVAL: buffer==NULL.
	BE_RANGE: lines > 24 or columns > 85.
	BE_BADB: internal error (should never happen).
short setfont(void *buffer __IX, void *fontdata __DE, short options __A)
	Sets buffer to use the supplied font.  Implementations (and third-party fonts) should document the values of columns and opts required for each font to render correctly.  initscr() sets the font address to the Spectrum's 32-column ROM font (and standout font to NULL).
	options consists of flags which may be bitwise ORed together (except that only one BFF_format may be used):
		0x00	BFF_ROMFONT		Use the ROM font format (this is the default).
		0x01	BFF_TRUEFONT	Use Andrew Owen's TrueFONT format.
		0x10	BFO_STANDOUT	Font is to be used for text with the standout attribute set.  If fontdata is NULL, generated standout is used.
		(more formats and options may be added later).
	BE_INVAL: buffer==NULL, or bad arguments.
	BE_BADB: bad (corrupted?) buffer.
short raw(void *buffer __IX)
	Puts buffer into raw input mode.
	BE_INVAL: buffer==NULL.
	BE_BADB: bad (corrupted?) buffer.
short cbreak(void *buffer __IX)
	Puts buffer into cbreak (half-cooked) input mode.  This is the default after initscr().
	BE_INVAL: buffer==NULL.
	BE_BADB: bad (corrupted?) buffer.
short delay(void *buffer __IX, short timeout __A)
	Sets delay mode if timeout==0, else half-delay mode.
	BE_INVAL: buffer==NULL.
	BE_BADB: bad (corrupted?) buffer.
short nodelay(void *buffer __IX)
	Sets no-delay mode.  This is the default after initscr().
	BE_INVAL: buffer==NULL.
	BE_BADB: bad (corrupted?) buffer.

Input functions:
char getch(void *buffer __IX)
	Reads a character from the keyboard.  Returns 0 if no input waiting (and, in half-delay mode, timeout reached) or if buffer is NULL.
	For details of return values see "Keymapping", below.
void input_isv(void *buffer __IX)
	Interrupt Service routine to read the keyboard; a call to this function should be placed in your own interrupt service routine.

Output functions:
short addch(void *buffer __IX, char ch __A)
	Puts the character ch at the cursor, which is then advanced.  If the advance is at the right margin, the cursor automatically wraps to the beginning of the next line.  At the bottom margin, the screen is scrolled up one line.  If ch is a tab, newline, or backspace, the cursor is moved appropriately.  Backspace moves the cursor one character left; at the left margin it does nothing.  Newline does a clrtoeol, then moves the cursor to the left margin on the next line, scrolling the screen if on the last line.  Tabs are considered to be at every eighth column.
	BE_INVAL: buffer==NULL.
	BE_BADB: bad (corrupted?) buffer.
	BE_CTRL: unrecognised control character.
short mvaddch(void *buffer __IX, short y __B, short x __C, char ch __A)
	Like move followed by addch.
	BE_INVAL: buffer==NULL.
	BE_BADB: bad (corrupted?) buffer.
	BE_RANGE: y or x out of valid range.
	BE_CTRL: unrecognised control character.
short addstr(void *buffer __IX, void *str __DE)
	Writes the characters of the (null-terminated) character string str at the cursor.  It is similar to calling addch once for each character in the string.
	BE_INVAL: buffer==NULL.
	BE_BADB: bad (corrupted?) buffer.
	BE_CTRL: unrecognised control character.
short mvaddstr(void *buffer __IX, short y __B, short x __C, void *str __DE)
	Like move followed by addstr.
	BE_INVAL: buffer==NULL.
	BE_BADB: bad (corrupted?) buffer.
	BE_RANGE: y or x out of valid range.
	BE_CTRL: unrecognised control character.
short erase(void *buffer __IX)
	Write blanks to every position in the window (with the currently set attribute).
	BE_INVAL: buffer==NULL.
	BE_BADB: bad (corrupted?) buffer.
short clear(void *buffer __IX)
	Like erase followed by clearok (makes certain optimisations possible).
	BE_INVAL: buffer==NULL.
	BE_BADB: bad (corrupted?) buffer.
short clrtobot(void *buffer __IX)
	Erase from the cursor to the end of screen.
	BE_INVAL: buffer==NULL.
	BE_BADB: bad (corrupted?) buffer.
short clrtoeol(void *buffer __IX)
	Erase from the cursor to the end of line.
	BE_INVAL: buffer==NULL.
	BE_BADB: bad (corrupted?) buffer.
void clearok(void *buffer __IX)
	Marks the buffer to be repainted from scratch when next refresh() is called.  See note 1.
	(error if buffer==NULL)
void beep(void)
	Sounds an audible bell.
void flash(void)
	Flashes the screen (inverse video for a small number of frames).
short scroll(void *buffer __IX, signed short count __A)
	Scrolls the screen up count lines (down if count < 0); that is, the text moves up (which is equivalent to the screen moving down).  This will typically produce a rather time-consuming repaint on the next refresh(), so use rscroll() where possible.  Generated blanks use the currently set attributes.
	BE_INVAL: buffer==NULL.
	BE_BADB: bad (corrupted?) buffer.
short rscroll(void *buffer __IX, signed short count __A)
	refresh()es the screen, then scrolls both the buffer and the screen up count lines.  Use of this function allows certain optimisations which would not be possible if scroll() and then refresh() were called (though it may be implemented as such).
	BE_INVAL: buffer==NULL.
	BE_BADB: bad (corrupted?) buffer.
short refresh(void *buffer __IX)
	Paints the buffer to the screen.
	BE_INVAL: buffer==NULL.
	BE_BADB: bad (corrupted?) buffer.

Attribute functions:
short attrset(void *buffer __IX, char attrib __A)
	
short attron(void *buffer __IX, char attrib __A)
	
short attroff(void *buffer __IX, char attrib __A)
	
char attrget(void *buffer __IX)
	Returns the currently set attribute.  (If buffer is NULL, returns 0)
short chgat(void *buffer __IX, short count __A)
	Changes the attributes of count characters (starting at the cursor) to the currently set attributes.  It does not update the cursor and does not perform wrapping.  A character count of 0xFF means to change attributes all the way to the end of the current line.
	BE_INVAL: buffer==NULL.
	BE_BADB: bad (corrupted?) buffer.
short mvchgat(void *buffer __IX, short count __A, short y __B, short x __C)
	Like move(buffer, y, x) followed by chgat(buffer, count).
	BE_INVAL: buffer==NULL.
	BE_BADB: bad (corrupted?) buffer.
	BE_RANGE: y or x out of valid range.

Cursor functions:
short move(void *buffer __IX, short y __B, short x __C)
	BE_INVAL: buffer==NULL.
	BE_BADB: bad (corrupted?) buffer.
	BE_RANGE: y or x out of valid range.
short getcury(void *buffer __IX)
	0xFF on error.
short getcurx(void *buffer __IX)
	0xFF on error.
short getmaxy(void *buffer __IX)
	0xFF on error.
short getmaxx(void *buffer __IX)
	0xFF on error.
long inch(void *buffer __IX)
	Returns the character (in L) and attribute (in H) under the cursor; 0 on error.
long mvinch(void *buffer __IX, short y __B, short x __C)
	

Attributes:
attron() values:
	0x00 to 0x07: ink colour
	0x08 to 0x0F: paper colour
	0x40 bright
	0x80 standout
	otherwise BE_ATTR
attr_off(any ink colour) sets black ink
attr_off(any paper colour) sets white paper
It is an implementation detail whether generated-standout is done by flash or by a modified font (eg. bold, or underline).
attrset() and attrget() use SBPPPIII (that is, like a Spectrum attribute byte but with standout in place of flash).
initscr() sets attributes to ink 0, paper 7, bright 0, standout 0 (that is, attrset(0x38)).

Keymapping:
In CBREAK mode, keypresses are decoded according to the current shift state; in RAW mode, keypresses are instead prefixed with the shift state.
Examples:
Keypress	RAW			CBREAK
a			a			a
caps+a		CS,a		A
sym+a		SS,a		<discard>
caps+sym+a	EM,a		~ (0x7e)
caps+5		CS,5		left (0x8)
sym+5		SS,5		%
caps+sym+5	EM,5		<discard>
enter		enter		enter (0xd)
caps+space	CS, 		break (0x5)
caps		<nothing>	<nothing>

Control codes mapping:
	0x
x0	nul
x1	CS (Caps Shift)
x2	SS (Symbol Shift)
x3	EM (Extend Mode)
x4	CL (Caps Lock)
x5	GR (Graphics)
x6	break
x7	edit
x8	left
x9	right
xA	down
xB	up
xC	delete
xD	enter
xE	truvid
xF	invvid
The result of printing a control code other than 08 (backspace), 09 (tab), 0A (newline), 0C (backspace), or 0D (newline) is implementation-defined.
