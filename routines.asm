;------ GetKey -----------------------------------------------------------------
GetKey:
	call	_GetCSC
	or	a
	ret	nz
	jr	GetKey


;------ ClearMem ---------------------------------------------------------------
ClearMem:
; Clears a section of memory SLOW! :p
; Input:
;  - HL: Location to kill
;  - B: Number of bytes to kill
;  - A: What to clear it with
	ld	(hl), a
	inc	hl
	djnz	ClearMem
	ret


#IFDEF	NEVER
;------ MultHlByA --------------------------------------------------------------
MultHlByA:
; Multiplies 16-bit HL by A.
; Inputs:
;  - HL, high byte will be discarded
;  - A
; Output:
;  - HL: 24-bit product
; Destroys:
;  - DE
;  - Flags
	ld	e, l
	ld	d, a
	mlt	de
	ld	l, a
	mlt	hl
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, de
	ret
#ENDIF

	
#IFDEF	NEVER
;------ Mult10 -----------------------------------------------------------------
Mult10:
; Multiplies HL by ten.
; Input:
;  - HL
; Output:
;  - HL
; Destroys:
;  - DE
	add	hl, hl
	push	hl
	pop	de
	add	hl, hl
	add	hl, hl
	add	hl, de
	ret
#ENDIF


;------ MultBcByHl -------------------------------------------------------------
MultBcByHl:
; Multiplies BC (16-bit) by HL (16-bit).
; From Xeda
; Inputs:
;  - HL (16-bits)
;  - BC (16-bits)
; Output:
;  - DE:BC
; Destroys:
;  - HL
;  - AF
	ld	d, c	\	ld	e, l	\	mlt	de	\	push	de
	ld	d, h	\	ld	e, b	\	mlt	de
	ld	a, l	\	ld	l, c	\	ld	c, a
	mlt	hl	
	mlt	bc
	add.s	hl, bc
	jr	nc, $ + 3 \	inc	de
	pop	bc
	ld	a, b	\	add	a, l	\	ld	b, a
	ld	a, e	\	adc	a, h	\	ld	e, a
	ret	nc
	inc	d
	ret


;#IFDEF	NEVER
;------ DivDByE ----------------------------------------------------------------
DivDByE:
; Divides D by E
; Inputs:
;  - D
;  - E
; Outputs:
;  - D: Quotient
;  - A: Remainder
; Destroys:
;  - B
	xor	a
	ld	b, 8
DivDByELoop:
	sla	d		; unroll 8 times
	rla			; ...
	cp	e		; ...
	jr	c, $ + 4	; ...
	sub	e		; ...
	inc	d		; ...
	djnz	DivDByELoop
	ret


;------ DivHlByC ---------------------------------------------------------------
DivHlByC:
; Divides HL by C.
; Inputs:
;  - HL 16 bits
;  - C
; Outputs:
;  - HL: Quotient
;  - A: Remainder
; Destroys:
;  - BC
	xor	a
	ld	b, 16
DivHlByCLoop:
	add.s	hl, hl		; unroll 16 times
	rla			; ...
	cp	c		; ...
	jr	c, $ + 4	; ...
	sub	c		; ...
	inc	l		; ...
	djnz	DivHlByCLoop
	ret


;------ DispUhl ----------------------------------------------------------------
DispUhl:
	call	RotateHighByte
	call	DispByte
	call	RotateHighByte
	call	DispByte
	call	RotateHighByte
	jr	DispByte
	

;------ GetHighByte ------------------------------------------------------------
GetHighByte:
	push	hl
	call	RotateHighByte
	pop	hl
	ret


;------ RotateHighByte ---------------------------------------------------------
RotateHighByte:
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
DispHl:
	ld	a, h
	call	DispByte
	ld	a, l
;------ DispByte ---------------------------------------------------------------
DispByte:
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
	call	_dba
	pop	af
_dba:	or	0F0h
	daa
	add	a, 0A0h
	adc	a, 40h
	call	PutC
;	call	_PutC
	ret


;------ BranchOnA --------------------------------------------------------------
BranchOnA:
; Branches depending on the value of A.
; Format:
;	.db	numberOfItems
;	.db	someValue
;	.dl	branchTarget
;	.db	anotherValue
;	.dl	anotherBranchTarget
;	&c.
; Can be either called or jumped to.
; Inputs:
;  - A: Value to branch on
;  - HL: Pointer to table mapping bytes to jump addresses
; Outputs:
;  - Branch based on A
;  - Target gets branch value in A
;  - Returns to caller if no matching value
; Destroys:
;  - All
	ld	b, (hl)
_:	cp	(hl)
	inc	hl
	jr	z, +_
	inc	hl
	inc	hl
	inc	hl
	djnz	-_
	ret
_:	ld	de, (hl)
	ex	de, hl
	jp	(hl)


;------ GetStrIndexed ----------------------------------------------------------
GetStrIndexed:
; Given an index into a table of ZTSs, this finds the specified string
; Inputs:
;  - A: Index
;  - HL: Pointer to table
; Output:
;  - HL: Pointer to selected string
	or	a
	ret	z
	push	bc
	ld	b, a
	xor	a
_gsia:	cp	(hl)
	inc	hl
	jr	nz, _gsia
	djnz	_gsia
	pop	bc
	ret


;------ GetStrLength -----------------------------------------------------------
GetStrLength:
; Finds the null terminator in a string.
; Input:
;  - HL: Ptr to string
; Output:
;  - HL: Length
;  - DE: Ptr to string
; Destroys:
;  - BC
	ld	bc, 0
	xor	a
	ex	de, hl
	add	hl, de
	cpir
	or	a
	sbc	hl, de
	ret


;#ENDIF