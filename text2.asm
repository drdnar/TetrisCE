; Vars
PutC_Flags		.equ	0
PutC_BytesPerLine	.equ	PutC_Flags + 1
PutC_FinalBits		.equ	PutC_BytesPerLine + 1
PutC_GlyphWidth		.equ	PutC_FinalBits + 1
PutC_GlyphHeight	.equ	PutC_GlyphWidth + 1
PutC_RowAdvance		.equ	PutC_GlyphHeight + 1
PutC_ColorsCache	.equ	PutC_RowAdvance + 3
PutC_LocalsSize		.equ	PutC_ColorsCache + 4
; Flags
PutC_OddWidth		.equ	0
PutC_OddStart		.equ	1
; Loop unrolling
#macro PUT_C_DO_BYTE()
	lea	hl, iy + PutC_ColorsCache	; One less memory access than LD HL, imm24; same as LD HL, imm16 in Z80 mode
;	rlca
;	jr	nc, $ + 3
;	inc	hl
;	rlca
;	jr	nc, $ + 4
;	inc	hl
;	inc	hl
;	ldi
	rlca
	jr	nc, $ + 4
	inc	hl
	inc	hl
	rlca
	jr	nc, $ + 3
	inc	hl
	ldi
#endmacro
#macro	PUT_C_ODD_NIBBLE()
	lea	hl, iy + PutC_ColorsCache
	rlca
	jr	nc, $ + 3
	inc	hl
	ld	c, a
	ex	de, hl
	ld	a, (hl)
	and	0F0h
	ld	(hl), a
	ld	a, (de)
	and	0Fh
	or	(hl)
	ld	(hl), a
	ex	de, hl
	inc	de
	ld	a, c
	ld	c, 255
#endmacro
#macro	PUT_C_EVEN_NIBBLE()
	lea	hl, iy + PutC_ColorsCache + 1
	rlca
	jr	nc, $ + 3
	inc	hl
	ld	c, a
	ex	de, hl
	ld	a, (hl)
	and	0Fh
	ld	(hl), a
	ld	a, (de)
	and	0F0h
	or	(hl)
	ld	(hl), a
	ex	de, hl
;	inc	de	; Do not increment
	ld	a, c
	ld	c, 255
#endmacro
	ld	(iy + PutC_Flags), 0
	; Get bitmap ptr
	ld	l, a
	ld	h, 3
	mlt	hl
	ld	de, (fontDataPtr)
	add	hl, de
	ld	ix, (hl)
	add	ix, de
	; Get glyph width
	or	a
	sbc	hl, hl
	ld	l, a
	ld	de, (fontWidthsPtr)
	add	hl, de
	ld	a, (hl)
	ld	(iy + PutC_GlyphWidth), a
	; Row width offset
	sbc	hl, hl
	rra
	ld	l, a
	jr	z, +_
	set	PutC_OddWidth, (iy + PutC_Flags)
_:	ex	de, hl
	ld	hl, 320 / 2
	or	a
	sbc	hl, de
	ld	(iy + PutC_RowAdvance), hl
	; Font height
	ld	a, (fontHeight)
	ld	(iy + PutC_FontWidth), a
	; Cache colors to stack, because LEA HL, IY + simm8 is 1 bus op less than LD HL, imm24
	ld	bc, 4
	lea	de, iy + PutC_ColorsCache
	ld	hl, textColors
	ldir
	; VRAM ptr
	ld	hl, (lcdCol)
	srl	h
	rr	l
	jr	z, +_
	set	PutC_OddStart, (iy + PutC_Flags)
_:	ld	a, (lcdRow)
	ld	e, a
	ld	d, 320 / 2
	mlt	de
	add	hl, de
	ld	de, (mpLcdBase)
	add	hl, de
	
	