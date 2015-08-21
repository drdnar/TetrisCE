;------ DrawRect ---------------------------------------------------------------
DrawRect:
; Draws a rectangle.
; Inputs:
;  - HL: Left side
;  - D: Top
;  - E: Height
;  - B: Width
;  - C: Color
	push	ix
	ld	ix, 0
	add	ix, sp
	push	hl	; ix - 1, ix - 2, ix - 3
	push	de	; ix - 4, ix - 5, ix - 6
	push	bc	; ix - 7, ix - 8, ix - 9
	call	DrawHorizLine
	ld	b, e
	call	DrawVertLine
	ld	c, (ix + -8)
	ld	b, 0
	add.sis	hl, bc
	dec	hl
	ld	c, (ix + -9)
	ld	b, e
	call	DrawVertLine
	ld	hl, (ix + -3)
	ld	a, d
	add	a, e
	ld	d, a
	dec	d
	ld	b, (ix + -8)
	call	DrawHorizLine
	pop	bc
	pop	de
	pop	hl
	pop	ix
	ret


;------ InvertRect -------------------------------------------------------------
InvertRect:
; Inverts the colors in a given region.
; This may malfunction if the rectangle width is less than 3.
; Inputs:
;  - HL: Left size
;  - D: Top
;  - E: Width
;  - B: Height
; Output:
;  - Region inverted
; Destroys:
;  - AF
ivr_Flags	.equ	-10
ivr_RowBytes	.equ	-11
ivr_Rows	.equ	-12
ivr_OddStart	.equ	0
ivr_EvenEnd	.equ	1
; Variables:
;  - Address
;  - Row start odd flag
;  - Row byte count
;  - Row end odd flag
;  - Height
;  - Row address offset
	push	ix
	ld	ix, 0
	add	ix, sp
	push	hl	; ix - 1, ix - 2, ix - 3
	push	de	; ix - 4, ix - 5, ix - 6
	push	bc	; ix - 7, ix - 8, ix - 9
	push	de	; ix - 10, ix - 11, ix - 12
	ld	(ix + ivr_Flags), 0
	; Compute address
	ld	e, 320 / 2
	mlt	de
	srl	h
	rr	l
	jr	nc, +_
	set	ivr_OddStart, (ix + ivr_Flags)
_:	add	hl, de
	ld	de, (mpLcdBase)
	add	hl, de
	; Compute row width
	push	hl
	srl	b
	ld	(ix + ivr_RowBytes), b
	jr	nc, ivr_rw_even
	bit	ivr_OddStart, (ix + ivr_Flags)
	jr	nz, +_
	set	ivr_EvenEnd, (ix + ivr_Flags)
	jr	ivr_rw_cont
_:	inc	b
	jr	ivr_rw_cont
ivr_rw_even:
	bit	ivr_OddStart, (ix + ivr_Flags)
	jr	z, ivr_rw_cont
	set	ivr_EvenEnd, (ix + ivr_Flags)
	dec	(ix + ivr_RowBytes)
ivr_rw_cont:
	ld	e, b
	ld	d, 0
	ld	hl, 320 / 2
	or	a
	sbc.sis	hl, de
	ex	de, hl
	pop	hl
ivrloop:
; Main fill loop
; HL: Write ptr
; DE: Row increment offset
; B: Bytes to write per row
	bit	ivr_OddStart, (ix + ivr_Flags)
	jr	z, +_
	ld	a, (hl)
	xor	0Fh
	ld	(hl), a
	inc	hl
_:	ld	a, (ix + ivr_RowBytes)
	or	a
	jr	z, ++_
	ld	b, a
_:	ld	a, (hl)
	cpl
	ld	(hl), a
	inc	hl
	djnz	-_
_:	bit	ivr_EvenEnd, (ix + ivr_Flags)
	jr	z, +_
	ld	a, (hl)
	xor	0F0h
	ld	(hl), a
_:	add	hl, de
	dec	(ix + ivr_Rows)
	jr	nz, ivrloop
	inc	sp
	inc	sp
	inc	sp
	pop	bc
	pop	de
	pop	hl
	pop	ix
	ret


;------ DrawOutlinedFilledRect -------------------------------------------------
DrawOutlinedFilledRect:
; Draws a rectangle with a black outline and filled interior.
; Inputs:
;  - HL: Left side
;  - D: Top
;  - E: Height
;  - C: High nibble: Line color, Low nibble: Fill color
;  - B: Width
	dec	b
	dec	b
	dec	e
	dec	e
	inc	hl
	inc	d
	call	DrawFilledRect
	inc	b
	inc	b
	inc	e
	inc	e
	dec	hl
	dec	d
	ld	a, c
	add	a, a
	adc	a, a
	adc	a, a
	adc	a, a
	adc	a, a
	ld	c, a
	jp	DrawRect


;------ DrawFilledRect ---------------------------------------------------------
DrawFilledRect:
; Draws a filled rectangle.
; This may malfunction if the rectangle width is less than 3.
; Inputs:
;  - HL: Left side
;  - D: Top
;  - E: Height
;  - C: Color
;  - B: Width
; Output:
;  - Area filled
; Destroys:
;  - AF
dfr_Flags	.equ	-10
dfr_RowBytes	.equ	-11
dfr_Rows	.equ	-12
dfr_Color_L	.equ	-13
dfr_Color_M	.equ	-14
dfr_Color_R	.equ	-15
dfr_OddStart	.equ	0
dfr_EvenEnd	.equ	1
; Variables:
;  - Address
;  - Row start odd flag
;  - Row byte count
;  - Row end odd flag
;  - Height
;  - Row address offset
	push	ix
	ld	ix, 0
	add	ix, sp
	push	hl	; ix - 1, ix - 2, ix - 3
	push	de	; ix - 4, ix - 5, ix - 6
	push	bc	; ix - 7, ix - 8, ix - 9
	push	de	; ix - 10, ix - 11, ix - 12
	dec	sp	; ix - 13
	dec	sp	; ix - 14
	dec	sp	; ix - 15
	ld	(ix + dfr_Flags), 0
	; Compute colors
	ld	a, c
	and	0Fh
	ld	(ix + dfr_Color_L), a
	ld	c, a
	add	a, a
	add	a, a
	add	a, a
	add	a, a
	or	c
	ld	(ix + dfr_Color_M), a
	and	0F0h
	ld	(ix + dfr_Color_R), a
	; Compute address
	ld	e, 320 / 2
	mlt	de
	srl	h
	rr	l
	jr	nc, +_
	set	dfr_OddStart, (ix + dfr_Flags)
_:	add	hl, de
	ld	de, (mpLcdBase)
	add	hl, de
	; Compute row width
	push	hl
	srl	b
	ld	(ix + dfr_RowBytes), b
	jr	nc, dfr_rw_even
	bit	dfr_OddStart, (ix + dfr_Flags)
	jr	nz, +_
	set	dfr_EvenEnd, (ix + dfr_Flags)
	jr	dfr_rw_cont
_:	inc	b
	jr	dfr_rw_cont
dfr_rw_even:
	bit	dfr_OddStart, (ix + dfr_Flags)
	jr	z, dfr_rw_cont
	set	dfr_EvenEnd, (ix + dfr_Flags)
	dec	(ix + dfr_RowBytes)
dfr_rw_cont:
	ld	e, b
	ld	d, 0
	ld	hl, 320 / 2
	or	a
	sbc.sis	hl, de
	ex	de, hl
	pop	hl
dfrloop:
; Main fill loop
; HL: Write ptr
; DE: Row increment offset
; B: Bytes to write per row
	bit	dfr_OddStart, (ix + dfr_Flags)
	jr	z, +_
	ld	a, (hl)
	and	0F0h
	or	(ix + dfr_Color_L)
	ld	(hl), a
	inc	hl
_:	ld	a, (ix + dfr_RowBytes)
	or	a
	jr	z, ++_
	ld	b, a
	ld	a, (ix + dfr_Color_M)
_:	ld	(hl), a
	inc	hl
	djnz	-_
_:	bit	dfr_EvenEnd, (ix + dfr_Flags)
	jr	z, +_
	ld	a, (hl)
	and	0Fh
	or	(ix + dfr_Color_R)
	ld	(hl), a
_:	add	hl, de
	dec	(ix + dfr_Rows)
	jr	nz, dfrloop
	inc	sp
	inc	sp
	inc	sp
	inc	sp
	inc	sp
	inc	sp
	pop	bc
	pop	de
	pop	hl
	pop	ix
	ret


;------ DrawHorizLine ----------------------------------------------------------
DrawHorizLine:
; Draws a horizontal line.
; Inputs:
;  - HL: Left side
;  - D: Row
;  - B: Length
;  - C: Color
; Output:
;  - Line draw
; Destroys:
;  - AF
;  - B
	push	hl
	push	de
	ld	a, c
	and	0Fh
	ld	c, a
	add	a, a
	add	a, a
	add	a, a
	add	a, a
	or	c
	ld	c, a
	ld	e, 320 / 2
	mlt	de
	srl	h
	rr	l
	push	af
	add	hl, de
	ld	de, (mpLcdBase)
	add	hl, de
	pop	af
	jr	nc, +_
	ld	a, (hl)
	and	0F0h
	ld	d, a
	ld	a, c
	and	0Fh
	or	d
	ld	(hl), a
	inc	hl
	dec	b
_:	srl	b
	rl	d
_:	ld	(hl), c
	inc	hl
	djnz	-_
	bit	0, d
	jr	z, +_
	ld	a, (hl)
	and	0Fh
	ld	b, a
	ld	a, c
	and	0F0h
	or	b
	ld	(hl), a
_:	pop	de
	pop	hl
	ret


;------ DrawVertLine -----------------------------------------------------------
DrawVertLine:
; Draws a vertical line.
; Inputs:
;  - HL: Column
;  - D: Start row
;  - B: Length
;  - C: Color
; Output:
;  - Line draw
; Destroys:
;  - AF
;  - B
	push	hl
	push	de
	ld	e, 320 / 2
	mlt	de
	srl	h
	rr	l
	push	af
	add	hl, de
	ld	de, (mpLcdBase)
	add	hl, de
	ld	de, 320 / 2
	pop	af
	jr	c, dvlOdd
	ld	a, c
	add	a, a
	add	a, a
	add	a, a
	add	a, a
	ld	c, a
_:	ld	a, (hl)
	and	0Fh
	or	c
	ld	(hl), a
	add	hl, de
	djnz	-_
	ld	a, c
	adc	a, a
	adc	a, a
	adc	a, a
	adc	a, a
	adc	a, a
	ld	c, a
	pop	de
	pop	hl
	ret
dvlOdd:	ld	a, c
	and	0Fh
	ld	c, a
_:	ld	a, (hl)
	and	0F0h
	or	c
	ld	(hl), a
	add	hl, de
	djnz	-_
	pop	de
	pop	hl
	ret

