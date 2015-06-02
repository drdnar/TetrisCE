; To do. . . .
;  - Low-level KBD scan


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
_:	.db	kbdIdle
	.db	15
	.dw	15
	.db	8
	.db	8
	.dw	0
	.dw	0FFh, 0
	.db	kbdIntKeyPressed
	


;------ KbdRawScan -------------------------------------------------------------
KbdRawScan:
; Scans the keyboard matrix for any pressed key, returning the first it finds,
; or 0 if none.
; Inputs:
;  - None
; Output:
;  - Code in A, or 0 if none
; Destroys:
;  - HL
	ld	bc, mpKbdRow1 | 0700h
	
	
	
	
	ld	bc, 07BFh
_gcsca:	; Matrix scan loop
	ld	a, c
;	out	(pKey), a
	rrca
	ld	c, a
	pop	af	; Probably should waste at least 20 cycles here.
	push	af	
;	push	ix
;	pop	ix
;	in	a, (pKey)
	cp	0ffh
	jr	nz, _gcscb	; Any key pressed?
	djnz	_gcsca
	; No keys pressed in any key group, so return 0.
	xor	a
	ret
_gcscb:	; Yay! Found a key, now form a scan code
	dec	b
	sla	b
	sla	b
	sla	b
	; Get which bit in A is reset
_gcscc:	rrca
	inc	b
	jr	c, _gcscc
	ld	a, b
	ret


;------ ------------------------------------------------------------------------
