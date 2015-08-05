; TODO:
;  - Verify keyboard driver
;  - Test IM2 with:
;     - ON key
;     - OS timer
;     - KBD
; Keyboard configuration
;  - Continuous rescan
;  - Interrupt after every scan

.assume ADL=1
#include "ti84pce.inc"
#include "equates.asm"

	.org	userMem - 2
	.db	tExtTok, tAsm84CeCmp


;	ld	hl, 0F00005h
;	res	5, (hl)
;	ret

	
	
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



	ld	hl, readystr
	call	PutS
	
	call	InitializeInterrupts

	ei
	
	
_:	ld	hl, (lcdRow)
	push	hl
	ld	hl, (lcdCol)
	push	hl
	
	ld	hl, (generalTimer)
	call	DispUhl
	
	ld	a, '#'
	call	PutC
	
	ld	hl, (mpIntStatusMasked)
	call	DispUhl
	
	pop	hl
	ld	(lcdCol), hl
	pop	hl
	ld	(lcdRow), hl
	
	call	KbdRawScan
	or	a
	jr	z, -_
	

	jp	Quit
readystr:
	.db	"READY. . . . ", 0

	
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
	di
	im	1
	ld	iy, flags
	ld	sp, (savedSp)
	call	ResetInterrupts
	call	FixLcdMode
	call	ResetKeyboard
	call	_DrawStatusBar
	call	_DrawStatusBarInfo
	call	_ClrScrnFull
	ld	b, 8
_:	ei
	halt
	djnz	-_
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
