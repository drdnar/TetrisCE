;------ DrawRect ---------------------------------------------------------------
DrawRect:
; Draws a rectangle with a black outline.
; Inputs:
;  - HL: Left side
;  - D: Top
;  - E: Height
;  - B: Width

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
;------ DrawFilledRect ---------------------------------------------------------
DrawFilledRect:
; Draws a filled rectangle.
; Inputs:
;  - HL: Left side
;  - D: Top
;  - E: Height
;  - C: Color
;  - B: Width
; Output:
;  - Area filled
; Destroys:
;  - BCU
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
	push	hl	; ix - 1, ix - 2, ix - 3
	push	de	; ix - 4, ix - 5, ix - 6
	push	bc	; ix - 7, ix - 8, ix - 9
	ld	(ix - 7), 0
	; Compute row width
	
	; Compute address
	ld	e, 320 / 2
	mlt	de
	srl	h
	rr	l
	jr	z, +_
	set	0, (ix - 7)
_:	add	hl, de
	ld	de, (mpLcdBase)
	add	hl, de
	
	
	
	pop	bc
	pop	de
	pop	hl
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
	pop	af
	jr	nz, dvlOdd
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
	inc	hl
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
	inc	hl
	djnz	-_
	pop	de
	pop	hl
	ret

