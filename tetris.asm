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
	call	ClearScreen
	
	
	
	ld	hl, titleText
	call	PutS
	
	call	GetKey
	
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
	call	_DrawStatusBar
	call	_DrawStatusBarInfo
	call	_ClrScrnFull
	ret


#include "game.asm"
#include "random.asm"
#include "text.asm"
#include "routines.asm"
#include "data.asm"
#include "font.asm"
