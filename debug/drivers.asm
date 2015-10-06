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
;  - BC
;  - DE
;  - HL
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
;  - BC
;  - DE
;  - HL
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
;  - BC
;  - DE
;  - HL
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
;  - BC
;  - DE
;  - HL
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
;  - BC
;  - DE
;  - HL
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


;------ AdvanceCursor ----------------------------------------------------------
debug_AdvanceCursor:
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


;------ DispUhl ----------------------------------------------------------------
debug_DispUhl:
	call	debug_RotateHighByte
	call	debug_DispByte
	call	debug_RotateHighByte
	call	debug_DispByte
	call	debug_RotateHighByte
	jr	debug_DispByte
	

;------ GetHighByte ------------------------------------------------------------
debug_GetHighByte:
	push	hl
	call	debug_RotateHighByte
	pop	hl
	ret


;------ RotateHighByte ---------------------------------------------------------
debug_RotateHighByte:
	add	hl, hl
	adc	a, a
	add	hl, hl
	adc	a, a
	add	hl, hl
	adc	a, a
	add	hl, hl
	adc	a, a
	add	hl, hl
	adc	a, a
	add	hl, hl
	adc	a, a
	add	hl, hl
	adc	a, a
	add	hl, hl
	adc	a, a
	ret


;------ DispHl -----------------------------------------------------------------
debug_DispHl:
	ld	a, h
	call	debug_DispByte
	ld	a, l
;------ DispByte ---------------------------------------------------------------
debug_DispByte:
; Display A in hex.
; Input:
;  - A: Byte
; Output:
;  - Byte displayed
; Destroys:
;  - AF
	push	af
	rra
	rra
	rra
	rra
	call	debug_dba
	pop	af
debug_dba:
	or	0F0h
	daa
	add	a, 0A0h
	adc	a, 40h
	call	debug_PutC
	ret


;------ PutS -------------------------------------------------------------------
debug_PutS:
; Displays a string, processes new line, nothing else.
; Input:
;  - HL: Pointer to string
; Outputs:
;  - Documented effect(s)
; Destroys:
;  - AF
;  - HL
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
;  - AF
;  - BC
;  - DE
;  - HL
;  - IX
	ld	e, a
	; Get pointer to font data
	ld	d, debug_textHeight
	mlt	de
	ld	ix, debug_fontDataTable	;debug_font
	add	ix, de
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
	ret