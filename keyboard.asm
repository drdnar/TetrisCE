; Key held?
; 00 0F 00 0F
; 08 08 FF FF
; 01 00 00 00
; 01 00 00 00
; 00 00 00 00
; No key:
; 01 0F 00 0F
; 08 08 FF FF
; 00 00 00 00
; 04 00 00 00
; 00 00 00 00


;------ ResetKeyboard ----------------------------------------------------------
ResetKeyboard:
; Resets the keyboard back to the normal OS values
; Inputs:
;  - None
; Outputs:
;  - Documented effect(s)
; Destroys:
;  - Assume all
	ld	hl, +_
	ld	de, mpKbdScanMode
	ld	bc, 13
	ldir
	ret
_:	.dw	kbdIdle | 0F00h, 0F00h
	.db	8
	.db	8
	.dw	0
	.dw	0FFh, 0
	.db	kbdIntScanDone
	


;------ KbdRawScan -------------------------------------------------------------
KbdRawScan:
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

#IFDEF	DIAGONAL_ARROWS
	ld	bc, mpKbdRow1 | 0600h
_:	ld	a, (bc)
	or	a
	jr	nz, +_
	inc	c
	inc	c
	djnz	-_
	ld	a, (bc)
	or	a
	ret	z
	cp	1
	jr	z, +_
	cp	2
	jr	z, +_
	cp	4
	jr	z, +_
	cp	8
	jr	z, +_
	or	0F0h
	ret
_:	sla	b
	sla	b
	sla	b
	; Get which bit in A is reset
_:	rrca
	inc	b
	jr	nc, -_
	ld	a, b
	ret
#ENDIF


;------ ------------------------------------------------------------------------
