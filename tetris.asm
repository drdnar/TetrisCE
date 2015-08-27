; TODO:
;  - Figure out if interrupt vector is random or not.

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


	call	ClrScrnFull

	ld	hl, readystr
	call	PutS
	
	call	InitializeInterrupts

	ei
;  - HL: Left side
;  - D: Top
;  - E: Height
;  - B: Width
;  - C: Color




	ld	a, 128
	ld	de, 1024
	ld	hl, GuiRam
	ld	iy, testGui
	call	GuiLoad
	call	GetKey
	ret


testGui:
	.db	1				; GuiObjId
	.db	GuiObjTextSize			; GuiObjSize
	.db	0				; GuiObjParentId
	.db	GuiObjIdText			; GuiObjType
	.db	0				; GuiObjFlags
	.dw	10				; GuiObjCol
	.db	15				; GuiObjRow
	.db	0				; GuiObjWidth
	.db	0				; GuiObjHeight
	.db	colorWhite | bgColorBlack	; GuiObjTextColors
	.dw	RsrcTestString			; GuiObjTextRsrcId

	.db	2				; GuiObjId
	.db	GuiObjTextSize			; GuiObjSize
	.db	0				; GuiObjParentId
	.db	GuiObjIdCenteredText		; GuiObjType
	.db	0				; GuiObjFlags
	.dw	310				; GuiObjCol
	.db	15				; GuiObjRow
	.db	0				; GuiObjWidth
	.db	0				; GuiObjHeight
	.db	colorWhite | bgColorBlack	; GuiObjTextColors
	.dw	RsrcTestString			; GuiObjTextRsrcId

	.db	3				; GuiObjId
	.db	GuiObjTextSize			; GuiObjSize
	.db	0				; GuiObjParentId
	.db	GuiObjIdCenteredText		; GuiObjType
	.db	0				; GuiObjFlags
	.dw	160				; GuiObjCol
	.db	15				; GuiObjRow
	.db	0				; GuiObjWidth
	.db	0				; GuiObjHeight
	.db	colorWhite | bgColorBlack	; GuiObjTextColors
	.dw	RsrcTestString			; GuiObjTextRsrcId



; End of widgets list
	.db	0	; GuiObjId


	.db	1				; GuiObjId
	.db	GuiObjTextSize			; GuiObjSize
	.db	0				; GuiObjParentId
	.db	GuiObjIdText			; GuiObjType
	.db	0				; GuiObjFlags
	.dw	10				; GuiObjCol
	.db	15				; GuiObjRow
	.db	0				; GuiObjWidth
	.db	0				; GuiObjHeight
	.db	0				; GuiObjNavUpId
	.db	0				; GuiObjNavLeftId
	.db	0				; GuiObjNavRightId
	.db	0				; GuiObjNavDownId
	.db	0				; GuiObjCustomData
	.db	0				; GuiObjColors
	.db	0				; GuiObjRsrcId


	
	ld	hl, 10	; Column
	ld	d, 4	; Row
	ld	e, 6	; Height
	ld	b, 12	; Width
	ld	c, 042h
	call	DrawOutlinedFilledRect
	
	ld	hl, 30	; Column
	ld	d, 12	; Row
	ld	e, 30	; Height
	ld	b, 30	; Width
	ld	c, 042h
	call	DrawOutlinedFilledRect
	
	ld	hl, 70	; Column
	ld	d, 12	; Row
	ld	e, 30	; Height
	ld	b, 31	; Width
	ld	c, 042h
	call	DrawOutlinedFilledRect
	
	ld	hl, 111	; Column
	ld	d, 12	; Row
	ld	e, 30	; Height
	ld	b, 30	; Width
	ld	c, 042h
	call	DrawOutlinedFilledRect
	
	ld	hl, 151	; Column
	ld	d, 12	; Row
	ld	e, 31	; Height
	ld	b, 31	; Width
	ld	c, 042h
	call	DrawOutlinedFilledRect
	
#ifdef	NEVER
	ld	hl, 10
	ld	d, 5
	ld	b, 10
	ld	c, 2
	call	DrawHorizLine
	ld	hl, 10
	ld	d, 6
	ld	b, 10
	ld	c, 2
	call	DrawHorizLine
	
	ld	hl, 9
	ld	d, 7
	ld	b, 9
	ld	c, 3
	call	DrawHorizLine
	ld	hl, 9
	ld	d, 8
	ld	b, 9
	ld	c, 3
	call	DrawHorizLine
	
	ld	hl, 9
	ld	d, 9
	ld	b, 10
	ld	c, 4
	call	DrawHorizLine
	ld	hl, 9
	ld	d, 10
	ld	b, 10
	ld	c, 4
	call	DrawHorizLine
	
	ld	hl, 10
	ld	d, 11
	ld	b, 11
	ld	c, 5
	call	DrawHorizLine
	ld	hl, 10
	ld	d, 12
	ld	b, 11
	ld	c, 5
	call	DrawHorizLine
	
	ld	hl, 10
	ld	d, 6
	ld	b, 5
	ld	c, 6
	call	DrawVertLine
	ld	hl, 11
	ld	d, 6
	ld	b, 6
	ld	c, 6
	call	DrawVertLine
	
	ld	hl, 12
	ld	d, 7
	ld	b, 2
	ld	c, 7
	call	DrawVertLine
	ld	hl, 13
	ld	d, 7
	ld	b, 3
	ld	c, 7
	call	DrawVertLine
	
	ld	hl, 15
	ld	d, 6
	ld	b, 6
	ld	c, 8
	call	DrawVertLine
	ld	hl, 18
	ld	d, 6
	ld	b, 6
	ld	c, 8
	call	DrawVertLine
#endif
	
	
	
	
	call	GetKey
	jp	Quit
	
loop:	
	ld	hl, (lcdRow)
	push	hl
	ld	hl, (lcdCol)
	push	hl
	
	ld	hl, (generalTimer)
	call	DispUhl
	
	ld	a, '#'
	call	PutC
	
	ld	a, (mpKbdScanMode)
	call	DispByte
	ld	a, (mpKbdInterruptStatus)
	call	DispByte
	ld	a, '#'
	call	PutC
	
	
	ld	hl, (mpIntStatusMasked)
	call	DispUhl
;	call	GetCSC
	ld	a, (kbdLastKey)
	or	a
	jr	z, +_
	push	af
	ld	a, ','
	call	PutC
	pop	af
	call	DispByte
_:	ld	a, '#'
	call	PutC
	
	pop	hl
	ld	(lcdCol), hl
	pop	hl
	ld	(lcdRow), hl
	
	jr	loop
;	call	KbdRawScan
;	or	a
;	jr	z, loop
	

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
#include "lcd.asm"
#include "gui.asm"
#include "gui_widgets.asm"
#include "resources.asm"
#include "resources_english.asm"
#include "data.asm"
#include "font.asm"
