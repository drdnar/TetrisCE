;------ OneSecondWait ----------------------------------------------------------
OneSecondWait:
; Does what it says.
; Destroys:
;  - HL
;  - DE
;  - AF
	; Halt timer & configure it
	ld	hl, mpTimersControlRegister
	ld	a, (hl)
	and	~(mTimer1Enable | mTimer1InterruptEnable)
	ld	(hl), a
	inc	hl
	ld	a, (hl)
	or	H_BYTE(mTimer1CountUp)
	ld	(hl), a
	; Zero-out counter
	ex	de, hl
	sbc	hl, hl	; C zeroed from above
	ld	(mpTimer1Count + 1), hl
	ld	(mpTimer1Count), hl
	; Set alarm registers to non-triggering value
	dec	hl
	ld	(mpTimer1AlarmValue1), hl
	ld	(mpTimer1AlarmValue2), hl
	; Enable timer!
	ex	de, hl
	dec	hl
	ld	a, (hl)
	or	mTimer1Enable | mTimer1SrcCrystal
	ld	(hl), a
	ex	de, hl
	ld	hl, mpTimer1Count + 1
_:	bit	7, (hl)
	jr	z, -_
	ex	de, hl
	ld	a, (hl)
	and	~mTimer1Enable
	ld	(hl), a
	ret


;------ StartGeneralPurposeTimer -----------------------------------------------
StartGeneralPurposeTimer:
	; Halt timer & configure it
	ld	hl, mpTimersControlRegister
	ld	a, (hl)
	and	~(mTimer1Enable | mTimer1InterruptEnable)
	ld	(hl), a
	inc	hl
	ld	a, (hl)
	or	H_BYTE(mTimer1CountUp)
	ld	(hl), a
	; Zero-out counter
	ex	de, hl
	sbc	hl, hl	; C zeroed from above
	ld	(mpTimer1Count + 1), hl
	ld	(mpTimer1Count), hl
	; Set alarm registers to non-triggering value
	dec	hl
	ld	(mpTimer1AlarmValue1), hl
	ld	(mpTimer1AlarmValue2), hl
	; Enable timer!
	ex	de, hl
	dec	hl
	ld	a, (hl)
	or	mTimer1Enable | mTimer1SrcCrystal
	ld	(hl), a
	ret


;------ SetGeneralPurposeTimer -------------------------------------------------
SetGeneralPurposeTimer:
	; The eZ80 doesn't have atomic multibyte writes.
	; So the counter can actually change between bytes.
	; So write the same value twice to deal with that.
	ld	(mpTimer1Count), hl
	ld	(mpTimer1Count), hl
	ret


;------ CheckTimer -------------------------------------------------------------
CheckTimer:
	or	a
	ld	hl, (mpTimer1Count)
	ld	de, (mpTimer1Count)
	sbc	hl, de
	jr	z, +_
	ld	de, (mpTimer1Count)
_:	or	a
	sbc	hl, hl
	ld	a, e
	and	1Fh
	ld	l, a
	call	SetGeneralPurposeTimer
	ld	b, 5	
_:	srl	d
	rr	e
	djnz	-_
	or	a
	ld	hl, (scrollTimer)
	sbc	hl, de
	ld	(scrollTimer), hl
	ret	nc
	or	a
	sbc	hl, hl
	ld	(scrollTimer), hl
	ret


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

	
;------ GetRtcTimeLinear -------------------------------------------------------
GetRtcTimeLinear:
; WARNING: THIS CODE WILL SOMETIMES (RARELY) READ THE TIME INCORRECTLY!
; It does not freeze the time before reading it.
; Not a problem for entropy-purposes, but it is a problem if you need the actual
; time.
;
; This monstrous routine will return the time as a 32-bit number of seconds in
; DE:HL.
; At least, I think.
; Inputs:
;  - None
; Output:
;  - DE:HL
; Destroys:
;  - AF
;  - BC
;  - IX maybe?
;  - ???
	; Minutes into seconds
	ld	de, (mpRtcMinutes)
	ld	d, 60
	mlt	de
	; Hours into seconds
	ld	hl, (mpRtcHours)
	ld	h, 225
	mlt	hl
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, de
	; Add seconds
	ld	de, (mpRtcSeconds)
	add	hl, de
	; Convert into DE:HL format
	push	hl
	ld	b, 8
rtcHighBitLoop:
	add	hl, hl
	adc	a, a
	djnz	rtcHighBitLoop
	pop	hl
	ld	e, a
;	ld	d, 0	; shouldn't be needed, for D should be zero from the previous load
	push	de
	push	hl
	; Days into seconds.
	ld	hl, (mpRtcDays)
	ld	bc, (60 * 60 * 24) / 2	; Half
	call	MultBcByHl
	push	bc
	pop	hl
	add.s	hl, hl
	ex	de, hl
	adc.s	hl, hl			; ... and double
	ex	de, hl
	; Add in time-of-day
	pop	bc
	add.s	hl, bc
	ex	de, hl
	pop	bc
	adc.s	hl, bc
	ex	de, hl
	; Done
	ret


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


#IFDEF	NEVER
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


#ENDIF