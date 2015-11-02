;------ CallHl -----------------------------------------------------------------
debug_CallHl:
; Calls HL, or returns immediately if HL is null.
; Input:
;  - HL
; Output:
;  - ? ? ?
; Destroys:
;  - ? ? ?
	push	af
	add	hl, de
	sbc	hl, de
	jr	z, +_
	pop	af
	jp	(hl)
_:	pop	af
	ret


;------ MapTable ---------------------------------------------------------------
debug_MapTable:
; Maps an input in A to an output in A.
; Inputs:
;  - A: Input value
;  - HL: Pointer to mapping table of form
;     .db numberOfEntries
;     .db inputValue1, outputValue1, inputValue2, outputValue2, &c.
; Outputs:
;  - A: Output value
;  - B: Reverse index number of mapping entry (e.g. in 7-entry table, first is
;       7, second is 6, &c., last is 1, 0 means not found, or first in 256 entry
;       table)
;  - NC if value found in table; C if no mapping found
;  - If NC, Z if output is 0, NZ if output is not zero
; Destroys:
;  - HL
	ld	b, (hl)
	inc	hl
_:	cp	(hl)
	inc	hl
	jr	z, +_
	inc	hl
	djnz	-_
	scf
	ret
_:	ld	a, (hl)
	or	a
	ret


;------ MapJumpTable -----------------------------------------------------------
debug_MapJumpTable:
; Maps an input in A to a call to an output function.
; Inputs:
;  - A: Input value
;  - HL: Pointer to mapping table of form
;     .db numberOfEntries
;     .db inputValue1
;     .dl function1
;     .db inputValue2
;     .dl function2
;     &c.
; Outputs:
;  - Returns to caller if no match found
;  - If match found,
;     - A: Input value
;     - B: Reverse index number of mapping entry (e.g. in 7-entry table, first
;          is 7, second is 6, &c., last is 1, 0 means not found, or first in 256
;          entry table)
; Destroys:
;  - HL
	ld	b, (hl)
	inc	hl
_:	cp	(hl)
	inc	hl
	jr	z, +_
	inc	hl
	inc	hl
	inc	hl
	djnz	-_
	ret
_:	ld	hl, (hl)
	inc	sp
	inc	sp
	inc	sp
	jp	(hl)



;===============================================================================
;====== Keyboard Utilities =====================================================
;===============================================================================
;------ GetHexByte -------------------------------------------------------------
debug_GetHexByte:
; Asks the user to enter in a hex byte.
; Inputs:
;  - None
; Outputs:
;  - A: Byte
;  - Carry if user pressed CLEAR (requested abort)
; Destroys:
;  - Nothing
	push	bc
	push	hl
	xor	a
	ld	(debug_CursorFlags), a
	call	debug_getHexNibble
	jr	z, debug_getHexAbort
	ld	a, b
	sla	a
	rla
	rla
	rla
	ld	c, a
	call	debug_getHexNibble
	jr	z, debug_getHexAbort2
	ld	a, b
	or	c
	pop	hl
	pop	bc
	ret
debug_getHexAbort2:
	call	debug_CursorLeft
	ld	a, ' '
	call	debug_PutC
	call	debug_CursorLeft
debug_getHexAbort:
	xor	a
	scf
	pop	hl
	pop	bc
	ret
debug_getHexNibble:
	call	debug_GetKeyBlinky
	cp	skClear
	ret	z
	ld	hl, debug_GetHexByteTable
	ld	b, 16
_:	cp	(hl)
	inc	hl
	jr	z, +_
	djnz	-_
	jr	debug_getHexNibble
_:	dec	b
	ld	a, b
	or	0F0h
	daa
	add	a, 0A0h
	adc	a, 40h
	call	debug_PutC
	ret


;------ GetHexByteNoAbort ------------------------------------------------------
debug_GetHexByteNoAbort:
; Like GetHexByte, but does not allow pressing CLEAR to abort.  However, CLEAR
; will backspace.
; Inputs:
;  - None
; Outputs:
;  - A: Byte
; Destroys:
;  - Nothing
	call	debug_GetHexByte
	ret	nc
	jr	debug_GetHexByteNoAbort


;------ GetHexWord -------------------------------------------------------------
debug_GetHexWord:
; Gets a long word in hex.
; Inputs:
;  - None
; Outputs:
;  - HL: Byte
;  - Carry if user pressed CLEAR (requested abort)
; Destroys:
;  - AF
	ld	hl, (debug_CurRow)
	push	hl
	ld	b, 3
_:	call	debug_RotateHighByte
	call	debug_GetHexByte
	jr	c, debug_getHexWordAbort
	ld	l, a
	djnz	-_
	inc	sp
	inc	sp
	inc	sp
	or	a
	ret
debug_getHexWordAbort:
	ex	(sp), hl
	ld	(debug_CurRow), hl
	ld	b, 6
	ld	a, ' '
_:	call	debug_PutC
	djnz	-_
	ld	(debug_CurRow), hl
	pop	hl
	scf
	ret


;------ GetHexWordNoAbort ------------------------------------------------------
debug_GetHexWordNoAbort:
	call	debug_GetHexWord
	ret	nc
	jr	debug_GetHexWordNoAbort



;===============================================================================
;====== Display Utilities ======================================================
;===============================================================================
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


;------ ShowVars ---------------------------------------------------------------
debug_ShowVars:
; Displays some variables for debugging.
; Input:
;  - IX: Pointer to variable list
;        .db Var flags
;            00h: End of list
;            [7]: Show label
;            [6]: Little-endian display order
;            [5]: New line before print
;            [3,0]: Bytes to display
;        .dl Var ptr
;        .dl If show label flag set, ptr to label string
; Outputs:
;  - Documented effect(s)
; Destroys:
;  - IX
debug_ShowVarsShowLabelB	.equ	7
debug_ShowVarsShowLabel		.equ	80h
debug_ShowVarsLittleEndianB	.equ	6
debug_ShowVarsLittleEndian	.equ	40h
debug_ShowVarsNewLineB		.equ	5
debug_ShowVarsNewLine		.equ	20h
debug_ShowVarsSizeMask		.equ	0Fh
debug_ShowVarsFlags		.equ	0
debug_ShowVarsVar		.equ	1
debug_ShowVarsLabel		.equ	4
	push	af
	push	bc
	push	de
	push	hl
debug_showVarsLoop:
; Show labels
	bit	debug_ShowVarsNewLineB, (ix + debug_ShowVarsFlags)
	call	nz, debug_NewLine
	ld	hl, (ix + debug_ShowVarsLabel)
	bit	debug_ShowVarsShowLabelB, (ix + debug_ShowVarsFlags)
	ld	a, ' '
	call	z, PutC
	call	nz, PutS
; Show variable data
	; Get pointer to data, and size
	ld	hl, (ix + debug_ShowVarsVar)
	ld	a, (ix + debug_ShowVarsFlags)
	and	debug_ShowVarsSizeMask
	jr	nz, +_
	ld	a, 16
_:	ld	b, a
	; Check for little-endian display order
	ld	de, 0
	bit	debug_ShowVarsLittleEndianB, (ix + debug_ShowVarsFlags)
	jr	z, +_
	dec	a
	ld	e, a
	add	hl, de
	ld	e, 0
	dec	de
_:	; Actual display loop
	ld	a, (hl)
	add	hl, de
	call	debug_DispByte
	djnz	-_
; Advance to next entry
	bit	debug_ShowVarsShowLabelB, (ix + debug_ShowVarsFlags)
	jr	z, +_
	lea	ix, ix + 3
_:	lea	ix, ix + 4
	ld	a, (ix)
	or	a
	jr	nz, debug_showVarsLoop
	pop	hl
	pop	de
	pop	bc
	pop	af
	ret