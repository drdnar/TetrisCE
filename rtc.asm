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


