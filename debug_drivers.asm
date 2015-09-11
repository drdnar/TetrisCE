
;====== ClearLcd ===============================================================
debug_ClearLcd:
	ld	hl, (mpLcdBase)
	ld	(hl), 0
	push	hl
	pop	de
	inc	de
	ld	bc, debug_VramSize - 1
	ldir
	ret


;====== InitializeLcd ==========================================================
debug_InitializeLcd:
	ld	hl, mpLcdCtrlRange
	ld	de, debug_LcdPrevConfig
	ld	bc, debug_LcdSettingsSize
	ldir
	ld	hl, mpLcdPalette
	ld	bc, 5
	ldir
	ld	hl, lcdBpp1 | lcdPwr | lcdBigEndianPixels | lcdBgr
	ld	(mpLcdCtrl), hl
	or	a
	sbc	hl, hl
	ld	(mpLcdPalette), hl
	dec.sis	hl
	ld	(mpLcdPalette + 2), hl
	ld	hl, debug_Vram
	ld	(mpLcdBase), hl
	ret
	
	
;====== RestoreLcd =============================================================
debug_RestoreLcd:
	ld	hl, debug_LcdPrevConfig
	ld	de, mpLcdCtrlRange
	ld	bc, debug_LcdSettingsSize
	ldir
	ld	de, mpLcdPalette
	ld	bc, 5
	ldir
	ret


;====== PutC ===================================================================
debug_PutC:
	push	af
	push	bc
	push	de
	push	hl
	push	ix
	; Write ASCII to text buffer
	ld	hl, (debug_CurRow)
	ld	bc, 0
	ld	c, h
	ld	h, debug_screenWidth
	mlt	hl
	add	hl, bc
	ld	de, debug_TextBuffer
	add	hl, de
	ld	(hl), a
	ex	de, hl
	ld	hl, debug_textFlags
	bit	debug_textInverse, (hl)
	jr	z, +_
	ex	de, hl
	set	7, (hl)
_:	ld	e, a
	; Get pointer to font data
	ld	d, debug_textHeight
	mlt	de
	ld	ix, debug_font
	add	ix, de
	; Get LCD VRAM pointer
	ld	hl, (debug_CurRow)
	ld	c, h	; Other bytes zero from above
	ld	h, (320 / debug_screenWidth) * debug_textHeight
	mlt	hl
	add	hl, bc
	ld	de, (mpLcdBase)
	add	hl, de
	; Loop
	ld	c, 0
	ld	a, (debug_textFlags)
	and	debug_textInverseM
	jr	z, +_
	ld	c, 255
_:	ld	de, 320 / 8
	ld	b, debug_textHeight
_:	ld	a, (ix)
	inc	ix
	xor	c
	ld	(hl), a
	add	hl, de
	djnz	-_
	pop	ix
	pop	hl
	pop	de
	pop	bc
	pop	af
	ret
