;------ SetTextMode ------------------------------------------------------------
SetTextMode:
; Sets the LCD to 8-bit palette mode
; Inputs:
;  - None
; Output:
;  - LCD mode changed
; Destroys:
;  - Whatever
	ld	hl, ColorPaletteTable
	ld	de, mpLcdPalette
	ld	bc, 32
	ldir
	ld	hl, lcdBpp4 | lcdPwr | lcdBigEndianPixels | lcdBgr
	ld	(mpLcdCtrl), hl
	ret
ColorPaletteTable:
	;	Irrrrrgggggbbbbb
	.dw	0000000000000000b	; 0 0000 Black
	.dw	0000000000011111b	; 1 0001 Blue
	.dw	0000001111100000b	; 2 0010 Green
	.dw	0000001000010000b	; 3 0011 Teal
	.dw	0111110000000000b	; 4 0100 Red
	.dw	0100000000010000b	; 5 0101 Purple
	.dw	0100001000000000b	; 6 0110 Amber
	.dw	0011110111101111b	; 7 0111 Dark Gray
	.dw	0110001100011000b	; 8 1000 Light Gray
;	.db	11101 110b, 110 10101b	; 9 1001 Light Blue
	.dw	0101011101111101b	; 9 1001 Light Blue
	.dw	1000011111110000b	; A 1010 Light Green
	.dw	1000001111111111b	; B 1011 Cyan
	.dw	1111111000010000b	; C 1100 Pink
	.dw	1111110000011111b	; D 1101 Magenta
	.dw	1111111111100000b	; E 1110 Yellow
	.dw	1111111111111111b	; F 1111 White
colorBlack		.equ	0000b
bgColorBlack		.equ	(colorBlack << 4)
colorBlue		.equ	0001b
bgColorBlue		.equ	(colorBlue << 4)
colorGreen		.equ	0010b
bgColorGreen		.equ	(colorGreen << 4)
colorTeal		.equ	0011b
bgColorTeal		.equ	(colorTeal << 4)
colorRed		.equ	0100b
bgColorRed		.equ	(colorRed << 4)
colorPurple		.equ	0101b
bgColorPurple		.equ	(colorPurple << 4)
colorAmber		.equ	0110b
bgColorAmber		.equ	(colorAmber << 4)
colorDarkGray		.equ	0111b
bgColorDarkGray		.equ	(colorDarkGray << 4)
colorLightGray		.equ	1000b
bgColorLightGray	.equ	(colorLightGray << 4)
colorLightBlue		.equ	1001b
bgColorLightBlue	.equ	(colorLightBlue << 4)
colorLightGreen		.equ	1010b
bgColorLightGreen	.equ	(colorLightGreen << 4)
colorCyan		.equ	1011b
bgColorCyan		.equ	(colorCyan << 4)
colorPink		.equ	1100b
bgColorPink		.equ	(colorPink << 4)
colorMagenta		.equ	1101b
bgColorMagenta		.equ	(colorMagenta << 4)
colorYellow		.equ	1110b
bgColorYellow		.equ	(colorYellow << 4)
colorWhite		.equ	1111b
bgColorWhite		.equ	(colorWhite << 4)


;------ FixLcdMode -------------------------------------------------------------
FixLcdMode:
; Fixes the LCD mode and other settings for the OS's benefit.
; Inputs:
;  - None
; Output:
;  - LCD mode changed
; Destroys:
;  - Whatever
	ld	hl, lcdNormalMode
	ld	(mpLcdCtrl), hl
	ld	hl, vRam
	ld	(mpLcdBase), hl
	ret


;------ LoadFont ---------------------------------------------------------------
LoadFont:
; Sets up font info struct
; Inputs:
;  - HL: Pointer to font
; Outputs:
;  - Font ready for use with PutC
;  - Don't forget to SetColors during initialization
; Destroys:
;  - AF
;  - BC
;  - DE
;  - HL
	push	ix
	ld	a, (hl)
	ld	(fontHeight), a
	push	hl
	pop	ix
	ld	de, (ix + 1)
	add	hl, de
	ld	(fontWidthsPtr), hl
	sbc	hl, de
	ld	de, (ix + 4)
	add	hl, de
	ld	(fontDataPtr), hl
	ret


;------ ClearScreen ------------------------------------------------------------
ClrScrnFull:
ClearScreen:
	ld	de, (mpLcdBase)
	or	a
	sbc	hl, hl
	ld	(lcdRow), hl
	ld	(lcdCol), hl
	add	hl, de
	inc	de
	ld	(hl), 0
	ld	bc, 320 * 240 - 1
	ldir
	ret


;------ NewLine ----------------------------------------------------------------
NewLine:
; Moves cursor to next line.
; Inputs:
;  - (lcdCol), (lcdRow)
; Outputs:
;  - Cursor adjusted
;  - DE = 0
;  - HL has old value of DE
; Destroys:
;  - AF
;  - B
;  - HL
	or	a
	sbc	hl, hl
	ld	(lcdCol), hl
	ex	de, hl
	ld	a, (fontHeight)
	ld	b, a
	ld	a, (lcdRow)
	add	a, b
	ld	(lcdRow), a
	add	a, b
	cp	240
	ret	c
	; Glyph will extend past bottom of screen, so force wrap
	xor	a
	ld	(lcdRow), a
	ret


;------ ClearEOL ---------------------------------------------------------------
ClearEOL:
; Erases everything from the cursor to the right edge of the screen.
; Inputs:
;  - LCD cursor
;  - Text background color
; Output:
;  - Erasing
; Destroys:
;  - AF
;  - BC
;  - DE
;  - HL
	push	ix
	push	iy
	ld	de, (lcdCol)
	ld	hl, 320 - 1
	or	a
	sbc	hl, de
	push	hl
	pop	ix
	;ld	a, (textBackColor)
	xor	a
	ld	iyl, 14
	call	GetCursorPtr
clearEolLoop:
	push	hl
	ld	(hl), a
	ex	de, hl
	or	a
	sbc	hl, hl
	add	hl, de
	inc	de
	push	ix
	pop	bc
	ldir
	pop	hl
	ld	de, 320
	add	hl, de
	dec	iyl
	jr	nz, clearEolLoop
	pop	iy
	pop	ix
	ret


;------ PutS -------------------------------------------------------------------
PutS:
; Displays a string.  If the string contains control codes, those codes are
; parsed.
; Input:
;  - HL: String to show
; Output:
;  - String shown
;  - HL advanced to the byte after the null terminator.
; Destroys:
;  - AF
	ld	a, (hl)
	inc	hl
	or	a
	scf
	ret	z
	cp	chNewLine
	jr	z, putSNewLine
	
	push	hl
	push	de
	call	GetGlyphWidth
	sbc	hl, hl	; C is reset from GetGlyphWidth
	ld	l, a
	ld	de, (lcdCol)
	add	hl, de	; C is reset
	ld	de, 320 - 5
	sbc	hl, de
	pop	de
	pop	hl
	ret	nc
	
	dec	hl
	ld	a, (hl)
	inc	hl
	call	PutC
	jr	PutS
putSNewLine:
	push	hl
	call	ClearEOL
	ld	a, (lcdRow)
	add	a, 14
	cp	240 - 14
	jr	c, +_
	xor	a
_:	ld	(lcdRow), a
	or	a
	sbc	hl, hl
	ld	(lcdCol), hl
	pop	hl
	jr	PutS


;------ GetCursorPtr -----------------------------------------------------------
GetCursorPtr:
; Computes the address the LCD cursor is referencing.
; Inputs:
;  - (lcdRow), (lcdCol)
; Outputs:
;  - HL: Pointer
; Destroys:
;  - Nothing
	push	de
	ld	hl, (lcdRow)
	ld	h, 160
	mlt	hl
	add	hl, hl
	ld	de, (lcdCol)
	add	hl, de
	ld	de, (mpLcdBase)
	add	hl, de
	pop	de
	ret


;------ SetColors --------------------------------------------------------------
SetColors:
; Sets the foreground and background colors.
; This function must be used instead of loading the value directly because PutC
; uses a cached table for decoding character bitmaps to 4-bit color.
; Inputs:
;  - A: (background << 4) | foreground
; Outputs:
;  - Colors updated
; Destroys:
;  - AF
	; 0		1
	; back << 4 | fore
	push	hl
	push	bc
	ld	hl, textColors + 1
	ld	(hl), a
	ld	b, a
	inc	hl
	rrca
	rrca
	rrca
	rrca
	ld	(hl), a
	inc	hl
	and	0F0h
	ld	c, a
	ld	a, b
	and	0Fh
	or	c
	ld	(hl), a
	dec	hl
	dec	hl
	dec	hl
	ld	a, b
	and	0F0h
	ld	b, a
	rrca
	rrca
	rrca
	rrca
	or	b
	ld	(hl), a
	pop	bc
	pop	hl
	ret


;------ SetForeColor -----------------------------------------------------------
SetForeColor:
; Sets the foreground color.
; This function must be used instead of loading the value directly because PutC
; uses a cached table for decoding character bitmaps to 4-bit color.
; Inputs:
;  - A: foreground
; Outputs:
;  - Colors updated
; Destroys:
;  - AF
	push	hl
	push	bc
	ld	c, a
	rrca
	rrca
	rrca
	rrca
	ld	b, a
	ld	hl, textColors + 1
	ld	a, (hl)
	and	0F0h
	or	c
	ld	(hl), a
	inc	hl
	ld	a, (hl)
	and	0Fh
	or	b
	ld	(hl), a
	inc	hl
	ld	a, b
	or	c
	ld	(hl), a
	pop	bc
	pop	hl
	ret


;------ SetBackColor -----------------------------------------------------------
SetBackColor:
; Sets the background color.
; This function must be used instead of loading the value directly because PutC
; uses a cached table for decoding character bitmaps to 4-bit color.
; Inputs:
;  - A: background (not left shifted), upper nibble must be zero
; Outputs:
;  - Colors updated
; Destroys:
;  - AF
	push	hl
	push	bc
	ld	c, a
	rrca
	rrca
	rrca
	rrca
	ld	b, a
	ld	hl, textColors
	or	c
	ld	(hl), a
	inc	hl
	ld	a, (hl)
	and	0Fh
	or	b
	ld	(hl), a
	inc	hl
	ld	a, (hl)
	and	0F0h
	or	c
	ld	(hl), a
	pop	bc
	pop	hl
	ret


;------ PutSCentered -----------------------------------------------------------
PutSCentered:
; Displays a string, centering it.  However, if the string contains control
; codes, the result will be weird.
; Input:
;  - HL: String to show
;  - B: Line on which to show the string.
; Output:
;  - String shown
;  - HL advanced to the byte after the null terminator.
; Destroys:
;  - AF
;  - BC
;  - DE
;  - HL

	push	hl
	ex	de, hl
	ld	l, b
	ld	h, 0
	call	Locate
	call	GetStrWidth
	ex	de, hl
	srl	d
	rr	e
	ld	hl, 320 / 2
	or	a
	sbc	hl, de
	ld	(lcdCol), hl
	pop	hl
	call	PutS
	ret


;------ GetGlyphWidth ----------------------------------------------------------
GetGlyphWidth:
; GetGlyphWidth
; Returns the width of the given glyph
; Input:
;  - A: Codepoint
; Output:
;  - A: Width
;  - Carry is reset
; Destroys:
;  - Nothing
	push	hl
	push	de
	or	a
	sbc	hl, hl
	ld	l, a
	ld	de, (fontWidthsPtr)
	add	hl, de
	ld	a, (hl)
	pop	de
	pop	hl
	ret


;------ GetStrWidth ------------------------------------------------------------
GetStrWidth:
; Computes the width, in pixels, of a string
; Input:
;  - DE: Pointer to string
; Output:
;  - HL: Width of string, in pixels
; Destroys:
;  - AF
	or	a
	sbc	hl, hl
	push	hl
	pop	bc
gswl:	ld	a, (de)
	inc	de
	or	a
	ret	z
	call	GetGlyphWidth
	ld	c, a
	add	hl, bc
	jr	gswl


;------ PutC -------------------------------------------------------------------
PutC:
; Displays a glyph.
; I hate this function.
; TODO:
;  - Branch into different subfunctions earlier if possible to avoid all those
;    in-loop conditionals.
; Inputs:
;  - A: ASCII code
; Outputs:
;  - Screen updated
; Destroys:
;  - Nothing
; Vars
PutC_Flags		.equ	0
PutC_BytesPerLine	.equ	1
PutC_FinalBits		.equ	2
PutC_FontWidth		.equ	3
PutC_FontHeight		.equ	4
PutC_ColorsCache	.equ	5
PutC_LocalsSize		.equ	9
; Flags
PutC_OddWidth		.equ	0
PutC_OddStart		.equ	1
; Loop unrolling
#macro PUT_C_DO_BYTE()
	lea	hl, iy + PutC_ColorsCache	; One less memory access than LD HL, imm24; same as LD HL, imm16 in Z80 mode
;	rlca
;	jr	nc, $ + 3
;	inc	hl
;	rlca
;	jr	nc, $ + 4
;	inc	hl
;	inc	hl
;	ldi
	rlca
	jr	nc, $ + 4
	inc	hl
	inc	hl
	rlca
	jr	nc, $ + 3
	inc	hl
	ldi
#endmacro
#macro	PUT_C_ODD_NIBBLE()
	lea	hl, iy + PutC_ColorsCache
	rlca
	jr	nc, $ + 3
	inc	hl
	ld	c, a
	ex	de, hl
	ld	a, (hl)
	and	0F0h
	ld	(hl), a
	ld	a, (de)
	and	0Fh
	or	(hl)
	ld	(hl), a
	ex	de, hl
	inc	de
	ld	a, c
	ld	c, 255
#endmacro
#macro	PUT_C_EVEN_NIBBLE()
	lea	hl, iy + PutC_ColorsCache + 1
	rlca
	jr	nc, $ + 3
	inc	hl
	ld	c, a
	ex	de, hl
	ld	a, (hl)
	and	0Fh
	ld	(hl), a
	ld	a, (de)
	and	0F0h
	or	(hl)
	ld	(hl), a
	ex	de, hl
;	inc	de	; Do not increment
	ld	a, c
	ld	c, 255
#endmacro
; Open stack frame
	push	af
	push	bc
	push	de
	push	hl
	push	ix
	push	iy
	ld	iy, -PutC_LocalsSize
	add	iy, sp
	ld	sp, iy
; Get font dimensions
	ld	hl, (fontWidth)
	ld	(iy + PutC_FontWidth), hl
; VRAM nibble alignment flags
	ld	(iy + PutC_Flags), 0
	bit	0, l
	jr	z, $ + 6
	set	PutC_OddWidth, (iy + PutC_Flags)
; Compute loop control counters
	ld	h, 0
	srl	l	; If even width, we'll only do H number of full bytes
	srl	l	; If odd width on odd start, we'll end with H full bytes
	rr	h	; If odd width on even start, we'll end with H full bytes plus one nibble
	srl	l	; So in every case, the low bit doesn't matter,
	rl	h	; and we don't round up
	rl	h
	ld	(iy + PutC_BytesPerLine), l
	ld	(iy + PutC_FinalBits), h
; Write char to ASCII buffer
	call	GetAsciiBufferCursorPtr
	ld	(hl), a
	inc	hl
	ex	de, hl
	ld	hl, textColors + 1
	ldi
; Get pointer to glyph data
	ld	e, a
	ld	d, (iy + PutC_FontWidth + 2)
	mlt	de
	ld	ix, (fontDataPtr)
	add	ix, de
; Cache colors to stack, because LEA HL, IY + simm8 is 1 bus op less than LD HL, imm24
	ld	bc, 4
	lea	de, iy + PutC_ColorsCache
	ld	hl, textColors
	ldir
; VRAM ptr
	ld	hl, (currentRow)
	ld	d, h
	ld	h, (iy + PutC_FontHeight)
	mlt	hl
	ld	h, 160
	mlt	hl
	ld	e, (iy + PutC_FontWidth)
	mlt	de
	srl	d
	rr	e
	jr	nc, PutCEvenStart
	set	PutC_OddStart, (iy + PutC_Flags)
PutCEvenStart:
	add	hl, de
	ld	de, (mpLcdBase)
	add	hl, de
	ex	de, hl
	ld	c, 255	; Prevent DLI from decrementing B
; Starting on a half-byte is weird. Use an entirely different code path.
	bit	PutC_OddStart, (iy + PutC_Flags)
	jp	nz, PutCOddLoopStart
	
PutCEvenLoop:
	ld	a, (iy + PutC_BytesPerLine)
	or	a
;	push	de
	jr	z, PutCEvenFinalBytes
	ld	b, a
PutCEvenBodyLoop:
	ld	a, (ix)
	inc	ix
	PUT_C_DO_BYTE()
	PUT_C_DO_BYTE()
	PUT_C_DO_BYTE()
	PUT_C_DO_BYTE()
	djnz	PutCEvenBodyLoop
PutCEvenFinalBytes:
	ld	a, (iy + PutC_FinalBits)
	or	a
	jr	nz, PutCEvenHaveFinalBytes
	bit	PutC_OddWidth, (iy + PutC_Flags)
	jr	z, PutCEvenNoFinalBit
	or	a
PutCEvenHaveFinalBytes:
	ld	b, a
	ld	a, (ix)
	inc	ix
	jr	z, PutCEvenFinalBit
PutCEvenFinalBytesLoop:
	PUT_C_DO_BYTE()
	djnz	PutCEvenFinalBytesLoop	
	bit	PutC_OddWidth, (iy + PutC_Flags)
	jr	z, PutCEvenNoFinalBit
PutCEvenFinalBit:
	PUT_C_EVEN_NIBBLE()
	inc	de
PutCEvenNoFinalBit:
;	pop	de
;	ld	hl, 160
	ld	hl, (fontLineSize)
	add	hl, de
	ex	de, hl
	dec	(iy + PutC_FontHeight)
	jp	nz, PutCEvenLoop
	jp	PutCDone

PutCOddLoopStart:
	ld	a, (iy + PutC_BytesPerLine)
	or	a
	jp	z, PutCSpecialOddLoop
PutCOddLoop:
	ld	b, (iy + PutC_BytesPerLine)
;	push	de
PutCOddBodyLoop:
	ld	a, (ix)
	inc	ix
	PUT_C_ODD_NIBBLE()
	PUT_C_DO_BYTE()
	PUT_C_DO_BYTE()
	PUT_C_DO_BYTE()
	PUT_C_EVEN_NIBBLE()
	djnz	PutCOddBodyLoop
	ld	a, (ix)
	inc	ix
	PUT_C_ODD_NIBBLE()	; Because this code path requires an odd number of bits. . . .
	ld	a, (iy + PutC_FinalBits)
	or	a
	jr	z, PutCOddNoFinalBytes
	ld	b, a
PutCOddFinalBytes:
	PUT_C_DO_BYTE()
	djnz	PutCOddFinalBytes
PutCOddNoFinalBytes:
;	pop	de
;	ld	hl, 160
	ld	hl, (fontLineSize)
	add	hl, de
	ex	de, hl
	dec	(iy + PutC_FontHeight)
	jp	nz, PutCOddLoop
	jr	PutCDone

PutCSpecialOddLoop: ; This only covers width = 7
	ld	a, (ix)
	inc	ix
	PUT_C_ODD_NIBBLE()
	PUT_C_DO_BYTE()
	PUT_C_DO_BYTE()
	PUT_C_DO_BYTE()
	ld	hl, 160 - 4
	add	hl, de
	ex	de, hl
	dec	(iy + PutC_FontHeight)
	jr	nz, PutCSpecialOddLoop
;	jr	PutCDone

PutCDone:
; Update cursor
	call	AdvanceCursor
; Close stack frame
	ld	iy, PutC_LocalsSize
	add	iy, sp
	ld	sp, iy
	pop	iy
	pop	ix
	pop	hl
	pop	de
	pop	bc
	pop	af
; End of function
	ret
