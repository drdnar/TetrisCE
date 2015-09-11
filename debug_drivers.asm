;===============================================================================
;====== Keyboard Driver ========================================================
;===============================================================================
#ifndef	DEBUG_KEYBOARD_ROUTINE
debug_InitializeKeyboard:
debug_RestoreKeyboard:


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

#else

debug_GetKey	.equ	DEBUG_KEYBOARD_ROUTINE
debug_InitializeKeyboard:
	ld	hl, mpKbdScanMode
	ld	de, debug_KeyboardPrevConfig
	ld	bc, 13
	ldir
	ld	hl, +_
	ld	de, mpKbdScanMode
	ld	bc, 13
	ldir
	ret
_:	.dw	kbdSingleScan | 0F00h, 0F00h	; Scan mode
	.db	8	; Rows
	.db	8	; Columns
	.dw	0	; unused
	.dw	0FFh, 0	; Int status/ACK
	.db	0	; Int enable


debug_RestoreKeyboard:
	ld	hl, debug_KeyboardPrevConfig
	ld	de, mpKbdScanMode
	ld	bc, 13
	ldir
	ret

#endif


;===============================================================================
;====== LCD Driver =============================================================
;===============================================================================

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


;====== PutMap =================================================================
debug_AdvanceCursor:


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
_:	call	debug_PutMap
	call	debug_AdvanceCursor
	pop	ix
	pop	hl
	pop	de
	pop	bc
	pop	af
	ret


;====== PutMap =================================================================
debug_PutMap:
	ld	e, a
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
	ret