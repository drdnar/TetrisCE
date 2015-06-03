.assume ADL=1
#include "ti84pce.inc"
#include "equates.asm"

	.org	userMem - 2
	.db	tExtTok, tAsm84CeCmp

	00 80 00 00
19 30 00 00
00 00 00 00
19 00 08 00


now it's
00 80 00 00
19 30 00 00
00 00 00 00
19 00 00 00

00 00 00 00
18 00 00 00



Anyway. . . .
USB not-plugged:
00 80 08 00
11 30 00 00
00 00 00 00
19 00 00 00

00 00 00 00
10 00 00 00


	ld	hl, (0F00005)
	res	5, (hl)
	ret

Crypto
Inter-chip bus
Watchdog timer
USB
USB DMA?


Bit   	Interrupt Source   
0 1	ON Button
1 2	Timer 1
2 4	Timer 2
3 8	Timer 3
4 10	Unknown, but disabling causes freeze (might be OS timer?)
5 20	
6 40	
7 80	
8 100	
9 200	
10 400	Keyboard
11 800	LCD Controller
12 1000	Real-Time Clock
13 2000	???
14 4000	
15 8000	Unknown, but signal seems to be constantly on
16 1 0000
17 2 0000
18 4 0000
19 8 0000	???
20 10 0000
21 20 0000


	
	ld	hl, (0F00005h)
	res	5, (hl)
	ret

	
	
	call	_RunIndicOff
	
#IFDEF	NOT_YET
	; Some entropy
	ld	bc, 3
	ld	iy, ((1024 * 256) + (320 * 240 * 2)) / 256
	ld	hl, 0D00000h
_:	xor	a
_:	ld	de, (hl)
	add	hl, bc
	add	ix, de
	dec	a
	jr	nz, -_
	dec	iy
	ld	a, iyl
	or	iyh
	jr	nz, --_
	ld	iy, flags
#ENDIF

	; Clear variables
	ld	de, vars
	or	a
	sbc	hl, hl
	add	hl, de
	inc	de
	ld	(hl), 0
	ld	bc, 255	; Just pick a number, I guess
	ldir
	
	; Save value from above
	ld	(seed1), ix
;	call	GetRtcTimeLinear
	ld	(seed2), hl
	
	; Initialize short-mode routines
;	call	InitializeRandomRoutines
	
	ld	(savedSp), sp
	
	di
	
	; Timers
	
	; Keyboard
	call	ConfigureKeyboard
	
	; Interrupts
	
	; Text driver
	call	SetTextMode
	ld	hl, font
	call	LoadFont
;	call	ClearScreen
	ld	a, bgColorBlue | colorWhite
	call	SetColors
	ld	hl, 0
	ld	(lcdRow), hl
	ld	(lcdCol), hl
	
TitleScreen:
	ld	hl, 0F00000h
	call	asdfasjdl
	call	NewLine
	call	asdfasjdl
	call	NewLine
	call	asdfasjdl
	call	NewLine
	call	asdfasjdl
	call	NewLine
	call	NewLine
	call	asdfasjdl
	call	NewLine
	call	asdfasjdl
	call	NewLine
	call	asdfasjdl
	call	NewLine
	call	asdfasjdl
	call	NewLine
	call	NewLine
	call	asdfasjdl
	call	NewLine
	call	asdfasjdl
	call	NewLine
	call	asdfasjdl
	call	NewLine
	call	asdfasjdl
	call	NewLine
	
	
_:	call	KbdRawScan
	or	a
	jr	z, -_
	
	jp	Quit

	
asdfasjdl:
	ld	b, 4
_:	push	hl
	push	bc
	ld	a, (hl)
	call	DispByte
	ld	a, ' '
	call	PutC
	pop	bc
	pop	hl
	inc	hl
	djnz	-_
	ret


	di
	ld	hl, (0F50012h)
	
	
	

	ei

	call	ClearScreen
	ld	hl, titleText
	call	PutS
	call	GetKey
	cp	skClear
	jp	nz, TitleScreen
	
	jp	StartGame
	
	jp	Quit
	
	
Panic:
	ld	iy, flags
	ld	sp, (savedSp)
	push	hl
	call	FixLcdMode
	pop	hl
	call	_PutS
	call	GetKey
	
Quit:
	
	ld	iy, flags
	ld	sp, (savedSp)
	call	FixLcdMode
	call	ResetKeyboard
	call	_DrawStatusBar
	call	_DrawStatusBarInfo
	call	_ClrScrnFull
	ei
	ret


#include "game.asm"
#include "random.asm"
#include "text.asm"
#include "routines.asm"
#include "interrupts.asm"
#include "keyboard.asm"
#include "timers.asm"
#include "rtc.asm"
#include "data.asm"
#include "font.asm"
