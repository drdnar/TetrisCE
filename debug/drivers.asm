;===============================================================================
;====== Keyboard Driver ========================================================
;===============================================================================
#ifndef	DEBUG_KEYBOARD_ROUTINE

;------ GetKey -----------------------------------------------------------------
debug_GetKey:
	push	bc
	call	debug_GetCSC
	ld	bc, (debug_LastKey)
	cp	c
	jr	nz, +_
	xor	a
	ret
_:	ld	(debug_LastKey), a
	pop	bc
	ret


;------ GetCSC -----------------------------------------------------------------
debug_GetCSC:
; Scans the keyboard matrix for any pressed key, returning the first it finds,
; or 0 if none.
; Inputs:
;  - None
; Output:
;  - Code in A, or 0 if none
; Destroys:
;  - BC
	ld	bc, mpKbdRow1 | 0700h
_:	ld	a, (bc)
	or	a
	jr	nz, +_
	inc	c
	inc	c
	djnz	-_
	ret
_:	dec	b
	sla	b
	sla	b
	sla	b
	; Get which bit in A is reset
_:	rrca
	inc	b
	jr	nc, -_
	ld	a, b
	ret


;------ InitializeKeyboard -----------------------------------------------------
debug_InitializeKeyboard:
; Switches keyboard configuration into debug mode.
; Inputs:
;  - None
; Outputs:
;  - Documented effect(s)
; Destroys:
;  - BC, DE, HL
	ld	hl, mpKbdScanMode
	ld	de, debug_KeyboardPrevConfig
	ld	bc, debug_KeyboardConfigSize
	ldir
	ld	hl, +_
	ld	de, mpKbdScanMode
	ld	bc, debug_KeyboardConfigSize
	ldir
	ret
_:	.dw	kbdSingleScan | 0F00h, 0F00h	; Scan mode
	.db	8	; Rows
	.db	8	; Columns
	.dw	0	; unused
	.dw	0FFh, 0	; Int status/ACK
	.db	0	; Int enable


;------ RestoreKeyboard --------------------------------------------------------
debug_RestoreKeyboard:
; Inputs:
;  - None
; Outputs:
;  - Documented effect(s)
; Destroys:
;  - BC, DE, HL
	ld	hl, debug_KeyboardPrevConfig
	ld	de, mpKbdScanMode
	ld	bc, debug_KeyboardConfigSize
	ldir
	ret

#else

debug_InitializeKeyboard:
debug_RestoreKeyboard:
	ret

#endif


;------ GetKeyBlinky -----------------------------------------------------------
debug_GetKeyBlinky:
; Gets a key, and blinks a cursor.
; Input:
;  - Cursor type
; Output:
;  - A: Key code
	push	bc
	push	de
	push	hl
	push	ix
	call	debug_CursorOn
debug_getKeyBlinkyLoop:
	call	GetCSC
	or	a
	jr	z, +_
	push	af
	ld	a, (debug_CursorFlags)
	and	debug_CursorActiveM
	call	nz, debug_CursorOff
	pop	af
	pop	ix
	pop	hl
	pop	de
	pop	bc
	ret
_:	ld	b, 0
	djnz	$
	ld	hl, (debug_CursorTimer)
	dec	hl
	ld	(debug_CursorTimer), hl
	add	hl, de
	sbc	hl, de
	call	z, debug_CursorBlink
	jr	debug_getKeyBlinkyLoop


;------ CursorBlink ------------------------------------------------------------
debug_CursorBlink:
; Blinks the cursor.
	ld	a, (debug_CursorFlags)
	and	debug_CursorActiveM
	jp	nz, debug_CursorOff
	; Fall through to CursorOn
;------ CursorOn ---------------------------------------------------------------
debug_CursorOn:
; Displays the cursor.
; Inputs:
;  - Cursor type
;  - Cursor location
; Outputs:
;  - Documented effect(s)
;  - Cursor timer reset
; Destroys:
;  - AF, BC, DE, HL, IX
	ld	ix, debug_CursorBitmapSave
	call	debug_ReadGlyphBitmap
	ld	a, (debug_CursorFlags)
	or	debug_CursorActiveM
	ld	(debug_CursorFlags), a
	bit	debug_CursorOther, a
	jr	nz, debug_cursorOnOther
	ld	b, 80h
	bit	debug_CursorInsert, a
	jr	z, +_
	set	2, b
_:	bit	debug_Cursor2nd, a
	jr	z, +_
	set	0, b
	jr	debug_cursorOnHaveCursor
_:	bit	debug_CursorAlpha, a
	jr	z, debug_cursorOnHaveCursor
	set	1, b
	bit	debug_CursorLwrAlpha, a
	jr	z, debug_cursorOnHaveCursor
	set	0, b
	jr	debug_cursorOnHaveCursor
debug_cursorOnOther:
	ld	de, +_
	and	03h
	jr	z, debug_cursorOnInverse
	sbc	hl, hl
	ld	l, a
	add	hl, de
	ld	b, (hl)
	jr	debug_cursorOnHaveCursor
_:	.db	0, 1, 16, 2
debug_cursorOnInverse:
	ld	a, (debug_TextFlags)
	push	af
	or	debug_TextInverseM
	ld	(debug_TextFlags), a
	ld	ix, debug_CursorBitmapSave
	call	debug_PutMapRaw
	pop	af
	ld	(debug_TextFlags), a
	jr	+_
debug_cursorOnHaveCursor:
	ld	a, b
	call	debug_PutMap
_:	ld	hl, debug_CursorTime
	ld	(debug_CursorTimer), hl
	ret


;------ CursorOff --------------------------------------------------------------
debug_CursorOff:
; Hides the cursor.
; Inputs:
;  - Old cursor bitmap
;  - Cursor location
; Outputs:
;  - Documented effect(s)
;  - Cursor timer reset
; Destroys:
;  - AF, BC, DE, HL, IX
	ld	a, (debug_CursorFlags)
	and	(~debug_CursorActiveM) & 0FFh
	ld	(debug_CursorFlags), a
	ld	a, (debug_TextFlags)
	push	af
	and	(~debug_TextInverseM) & 255
	ld	(debug_TextFlags), a
	ld	ix, debug_CursorBitmapSave
	call	debug_PutMapRaw
	pop	af
	ld	(debug_TextFlags), a
	ld	hl, debug_CursorTime
	ld	(debug_CursorTimer), hl
	ret


;------ GetKey2nd --------------------------------------------------------------
_:	ld	a, (debug_CursorFlags)
	xor	debug_Cursor2ndM
	ld	(debug_CursorFlags), a
debug_GetKey2nd:
; Gets a key, but also processes 2nd.
; Input:
;  - Cursor type
; Output:
;  - A: Key code, bit 6 set if 2nd was pressed
; Destroys:
;  - Flags
	call	debug_GetKeyBlinky
	cp	sk2nd
	jr	z, -_
	push	hl
	ld	hl, (debug_CursorFlags)
	bit	debug_Cursor2nd, (hl)
	pop	hl
	ret	z
	or	40h
	ret


;------ GetKeyShifts -----------------------------------------------------------
debug_GetKeyShifts:
; Gets a key, but also processes shift keys.
; Input:
;  - Cursor type
; Output:
;  - A: Key code
; Destroys:
;  - Flags
	call	debug_GetKeyBlinky
	cp	sk2nd
	jr	z, debug_getKeyShiftsCycle2nd
	cp	skAlpha
	jr	z, debug_getKeyShiftsCycleAlpha
	cp	skDel
	ret	nz
	ld	a, (debug_CursorFlags)
	bit	debug_Cursor2nd, a
	jr	nz, +_
	ld	a, skDel
	ret
_:	and	(~debug_Cursor2ndM) & 255
	xor	debug_CursorInsertM
debug_getKeyShiftsSaveCursor:
	ld	(debug_CursorFlags), a
	jr	debug_GetKeyShifts
debug_getKeyShiftsCycle2nd:
	ld	a, (debug_CursorFlags)
	xor	debug_Cursor2ndM
	jr	debug_getKeyShiftsSaveCursor
debug_getKeyShiftsCycleAlpha:
	ld	a, (debug_CursorFlags)
	bit	debug_Cursor2nd, a
	jr	z, +_
	and	(~debug_Cursor2ndM) & 255
	jr	debug_getKeyShiftsSaveCursor
_:	bit	debug_CursorAlpha, a
	jr	nz, +_
	or	debug_CursorAlphaM
	and	(~debug_CursorLwrAlphaM) & 255
	jr	debug_getKeyShiftsSaveCursor
_:	bit	debug_CursorLwrAlpha, a
	jr	nz, +_
	or	debug_CursorLwrAlphaM
	jr	debug_getKeyShiftsSaveCursor
_:	and	(~(debug_CursorLwrAlphaM | debug_CursorAlphaM)) & 255
	jr	debug_getKeyShiftsSaveCursor


;------ GetKeyAscii ------------------------------------------------------------
debug_GetKeyAscii:
; Gets an ASCII character, or a key code.
; Inputs:
;  - None
; Output:
;  - A: Key code
;       Bit 7 set if return is not ASCII, but key code
;       Bit 6 set if 2nd was pressed (e.g. 2nd + Up -> skUp | 40h)
; Destroys:
;  - Flags
	push	bc
	push	hl
	call	debug_GetKeyShifts
	ld	hl, (debug_CursorFlags)
	bit	debug_Cursor2nd, l
	jr	nz, debug_getKeyAscii2nd
	bit	debug_CursorAlpha, l
	jr	nz, debug_getKeyAsciiAlpha
	ld	hl, debug_KeyAsciiTableNumbers
	call	debug_MapTable
	jr	nc, debug_getKeyAsciiRet
	or	80h
	jr	debug_getKeyAsciiRet
debug_getKeyAscii2nd:
	ld	hl, debug_CursorFlags
	res	debug_Cursor2nd, (hl)
	ld	hl, debug_KeyAsciiTableNumbers2nd
	call	debug_MapTable
	jr	nc, debug_getKeyAsciiRet
	or	0C0h
	jr	debug_getKeyAsciiRet
debug_getKeyAsciiAlpha:
	ld	hl, debug_KeyAsciiTableLetters
	call	debug_MapTable
	jr	nc, +_
	or	80h
	jr	debug_getKeyAsciiRet
_:	ld	hl, debug_CursorFlags
	bit	debug_CursorLwrAlpha, (hl)
	jr	z, debug_getKeyAsciiRet
	cp	'Z' + 1
	jr	nc, debug_getKeyAsciiRet
	cp	'A'
	jr	c, debug_getKeyAsciiRet
	add	a, 'a' - 'A'
debug_getKeyAsciiRet:
	pop	hl
	pop	bc
	ret



;===============================================================================
;====== LCD Driver =============================================================
;===============================================================================

;------ ClearLcd ---------------------------------------------------------------
debug_ClearLcd:
; Clears the screen.
; Inputs:
;  - None
; Outputs:
;  - Documented effect(s)
; Destroys:
;  - BC, DE, HL
	ld	hl, debug_Vram	;(mpLcdBase)
	ld	(hl), 0
	push	hl
	pop	de
	inc	de
	ld	bc, debug_VramSize - 1
	ldir
	ret


;------ InitializeLcd ----------------------------------------------------------
debug_InitializeLcd:
; Changes the LCD into debug mode.
; Inputs:
;  - None
; Outputs:
;  - Documented effect(s)
; Destroys:
;  - BC, DE, HL
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
	
	
;------ RestoreLcd -------------------------------------------------------------
; Restores the LCD to its settings from before entering debug mode.
; Inputs:
;  - None
; Outputs:
;  - Documented effect(s)
; Destroys:
;  - BC, DE, HL
debug_RestoreLcd:
	ld	hl, debug_LcdPrevConfig
	ld	de, mpLcdCtrlRange
	ld	bc, debug_LcdSettingsSize
	ldir
	ld	de, mpLcdPalette
	ld	bc, 5
	ldir
	ret


;------ HomeUp -----------------------------------------------------------------
debug_HomeUp:
; Moves the cursor to the top-left.
; Inputs:
;  - None
; Outputs:
;  - Documented effect(s)
; Destroys:
;  - Nothing
	push	af
	xor	a
	ld	(debug_CurRow), a
	ld	(debug_CurCol), a
	pop	af
	ret


;------ CursorLeft -------------------------------------------------------------
debug_CursorLeft:
; Moves the cursor left.
; Inputs:
;  - None
; Outputs:
;  - Documented effect(s)
; Destroys:
;  - AF
	ld	a, (debug_CurCol)
	dec	a
	ld	(debug_CurCol), a
	ret	p
	ld	a, debug_Cols - 1
	ld	(debug_CurCol), a
	ld	a, (debug_CurRow)
	dec	a
	ld	(debug_CurRow), a
	ret	p
	ld	a, debug_Rows - 1
	ld	(debug_CurRow), a
	ret


;------ AdvanceCursor ----------------------------------------------------------
debug_AdvanceCursor:
debug_CursorRight:
; Moves the cursor right.
; Inputs:
;  - None
; Outputs:
;  - Documented effect(s)
; Destroys:
;  - AF
	ld	a, (debug_CurCol)
	inc	a
	ld	(debug_CurCol), a
	cp	debug_Cols
	ret	c
;------ NewLine ----------------------------------------------------------------
debug_NewLine:
; Moves the cursor to a new line.
; Inputs:
;  - None
; Outputs:
;  - Documented effect(s)
; Destroys:
;  - AF
	xor	a
	ld	(debug_CurCol), a
	ld	a, (debug_CurRow)
	inc	a
	ld	(debug_CurRow), a
	cp	debug_Rows
	ret	c
	xor	a
	ld	(debug_CurRow), a
	ret


;------ PutS -------------------------------------------------------------------
debug_PutS:
; Displays a string, processes new line, nothing else.
; Input:
;  - HL: Pointer to string
; Outputs:
;  - Documented effect(s)
; Destroys:
;  - AF, HL
	ld	a, (hl)
	inc	hl
	or	a
	ret	z
	cp	debug_chNewLine
	call	nz, debug_PutC
	call	z, debug_NewLine
	jr	debug_PutS


;------ PutC -------------------------------------------------------------------
debug_PutC:
; Displays a character at the current cursor location and advances cursor.
; Also copies to ASCII buffer if flag is set.
; Inputs:
;  - A: Character code
; Outputs:
;  - Documented effect(s)
; Destroys:
;  - Nothing
	push	af
	push	bc
	push	de
	push	hl
	push	ix
#ifdef	NEVER
	; Write ASCII to text buffer
	ld	hl, (debug_CurRow)
	ld	bc, 0
	ld	c, h
	ld	h, debug_Cols
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
_:	
#endif
	call	debug_PutMap
	call	debug_AdvanceCursor
	pop	ix
	pop	hl
	pop	de
	pop	bc
	pop	af
	ret


;------ PutMap -----------------------------------------------------------------
debug_PutMap:
; Displays the given character on screen, at current cursor location.
; Inputs:
;  - A: Character code
; Outputs:
;  - Documented effect(s)
; Destroys:
;  - AF, BC, DE, HL, IX
	ld	e, a
	; Get pointer to font data
	ld	d, debug_textHeight
	mlt	de
	ld	ix, debug_fontDataTable	;debug_font
	add	ix, de
debug_PutMapRaw:
; This lets you use anything as the bitmap to display.
	; Get LCD VRAM pointer
	ld	hl, (debug_CurRow)
	ld	bc, 0
	ld	c, h
	ld	h, debug_textHeight	; Row times lines per row . . .
	mlt	hl
	ld	h, debug_Cols		; . . . times bytes per line
	mlt	hl
	add	hl, bc
	ld	de, debug_Vram	;(mpLcdBase)
	add	hl, de
	; Loop
	ld	c, 0
	ld	a, (debug_TextFlags)
	and	debug_TextInverseM
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
	ret


;------ ScrollUpOneLine --------------------------------------------------------
debug_ScrollUpOneLine:
; Scrolls all text up one line.
; Erases the bottom line of text.
; Inputs:
;  - None
; Outputs:
;  - Documented effect(s)
; Destroys:
;  - Nothing.
	push	bc
	push	de
	push	hl
	ld	hl, debug_Vram + (debug_textHeight * 320 / 8)
	ld	de, debug_Vram
	ld	bc, (debug_Rows - 1) * (debug_textHeight * 320 / 8)
	ldir
	ld	hl, debug_Vram + ((debug_textHeight * 320 / 8) * (debug_Rows - 1))
	ld	(hl), 0
	ld	de, debug_Vram + ((debug_textHeight * 320 / 8) * (debug_Rows - 1)) + 1
	ld	bc, (debug_textHeight * 320 / 8) - 1
	ldir
	pop	hl
	pop	de
	pop	bc
	ret


;------ ReadGlyphBitmap --------------------------------------------------------
debug_ReadGlyphBitmap:
; Reads the bitmap data at the current cursor location.
; Inputs:
;  - Cursor location
;  - IX: Location to write bitmap to
; Outputs:
;  - Documented effect(s)
; Destroys:
;  - AF, BC, DE, HL, IX
	; Get LCD VRAM pointer
	ld	hl, (debug_CurRow)
	ld	bc, 0
	ld	c, h
	ld	h, debug_textHeight	; Row times lines per row . . .
	mlt	hl
	ld	h, debug_Cols		; . . . times bytes per line
	mlt	hl
	add	hl, bc
	ld	de, debug_Vram	;(mpLcdBase)
	add	hl, de
	; Loop
	ld	de, 320 / 8
	ld	b, debug_textHeight
_:	ld	a, (hl)
	ld	(ix), a
	inc	ix
	add	hl, de
	djnz	-_
	ret