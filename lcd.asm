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
	push	hl	; ix - 3, ix - 2, ix - 1
	push	de	; ix - 6, ix - 5, ix - 4
	push	bc	; ix - 9, ix - 8, ix - 7
	call	DrawHorizLine
	ld	b, e
	call	DrawVertLine
	ld	c, (ix + -8)
	ld	b, 0
	add.sis	hl, bc
	ld	c, (ix + -7)
	ld	b, e
	call	DrawVertLine
	ld	hl, (ix + -1)
	ld	a, d
	add	a, e
	ld	d, a
;	call	DrawHorizLine
	pop	bc
	pop	de
	pop	hl
	pop	ix
	ret


;------ InvertRect -------------------------------------------------------------
InvertRect:
; Inverts the colors in a given region.
; Inputs:
;  - HL: Left size
;  - D: Top
;  - E: Width
;  - B: Height
; Output:
;  - Region inverted
; Destroys:
;  - AF
;  - BC
;  - DE
;  - HL
;------ DrawOutlinedFilledRect -------------------------------------------------
DrawOutlinedFilledRect:
; Draws a rectangle with a black outline and filled interior.
; Inputs:
;  - HL: Left side
;  - D: Top
;  - E: Height
;  - C: Fill color
;  - B: Width
	dec	b
	dec	e
	inc	hl
	inc	d
	call	DrawFilledRect
	inc	b
	inc	e
	inc	hl
	inc	d
	ld	c, 0
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
dfr_Flags	.equ	-12
dfr_RowBytes	.equ	-11
dfr_Rows	.equ	-10
dfr_Color_L	.equ	-13
dfr_Color_M	.equ	-14
dfr_Color_R	.equ	-15
dfr_OddStart	.equ	0
dfr_EvenEnd	.equ	1
;  - Area filled
; Destroys:
;  - AF
; Need:
;  - Address
;  - Row start odd flag
;  - Row byte count
;  - Row end odd flag
;  - Height
;  - Row address offset
	push	ix
	ld	ix, 0
	add	ix, sp
	push	hl	; ix - 3, ix - 2, ix - 1
	push	de	; ix - 6, ix - 5, ix - 4
	push	bc	; ix - 9, ix - 8, ix - 7
	push	de	; ix - 12, ix - 11, ix - 10
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
	jr	z, +_
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
	jr	nz, dfr_rw_cont
	set	dfr_EvenEnd, (ix + dfr_Flags)
	dec	b	; IS THIS CORRECT??
	jr	dfr_rw_cont
dfr_rw_even:
	bit	dfr_OddStart, (ix + dfr_Flags)
	jr	z, dfr_rw_cont
	set	dfr_EvenEnd, (ix + dfr_Flags)
dfr_rw_cont:
	ld	e, b
	ld	hl, 320 / 2
	sbc	hl, de
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
	and	0Fh
	or	(ix + dfr_Color_L)
	ld	(hl), a
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
	and	0F0h
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

