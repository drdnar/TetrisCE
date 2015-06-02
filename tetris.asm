.assume ADL=1
#include "ti84pce.inc"
#include "equates.asm"

	.org	userMem - 2
	.db	tExtTok, tAsm84CeCmp
	
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
	di
;	call	ConfigureKeyboard
	ld	hl, blarghsasdf
	call	PutS
_:	ld	a, (0F00020h)
	and	1
	jp	nz, Quit
	call	KbdRawScan
	or	a
	jr	z, -_
	call	DispByte
	jr	-_
	
	jp	Quit
blarghsasdf:
	.db	"Thingy: ", 0
	
	
	
	ld	hl, 0F50000h
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
	call	asdfasjdl
	call	NewLine
	call	asdfasjdl
	call	NewLine
	call	asdfasjdl
	call	NewLine
	call	asdfasjdl
	call	NewLine
	
	
	call	GetKey
	
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
#include "data.asm"
#include "keyboard.asm"
#include "font.asm"
