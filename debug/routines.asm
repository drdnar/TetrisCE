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