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
_:	.dw	kbdIntOnly | 0F00h, 0F00h
	.db	8
	.db	8
	.dw	0FFFFh
	.dw	0FFh, 0
	.db	kbdIntKeyPressed


;------ ConfigureKeyboard ------------------------------------------------------
ConfigureKeyboard:
;
	ld	hl, +_
	ld	de, mpKbdScanMode
	ld	bc, 13
	ldir
	ret
_:	.dw	kbdSingleScan | 0F00h, 0F00h	; Scan mode
	.db	8	; Rows
	.db	8	; Columns
	.dw	0	; unused
	.dw	0FFh, 0	; Int status/ACK
	.db	0	; Int enable
;_:	.dw	kbdContinuousScan | 0F00h, 0F00h	; Scan mode
;	.db	8	; Rows
;	.db	8	; Columns
;	.dw	0	; unused
;	.dw	0FFh, 0	; Int status/ACK
;	.db	0	; Int enable


;------ GetKey -----------------------------------------------------------------
GetKey:
; Waits for a keypress, and returns it.
; This may APD.
; Interrupts must be enabled.
; Inputs:
;  - None
; Output:
;  - Scan code in A
; Destroys:
;  - Nothing
	call	GetCSC
	or	a
	ret	nz
	ei
	halt
	jr	GetKey


;------ GetCSC -----------------------------------------------------------------
GetCSC:
; Returns the most recent keypress and removes it from the key queue.
; Inputs:
;  - None
; Output:
;  - Scan code in A
;  - Z: No key press waiting
;  - NZ: Key press waiting
; Destroys:
;  - Nothing
	push	hl
	ld	hl, keyBuffer
	ld	a, (hl)
	ld	(hl), 0
	pop	hl
	or	a
	ret


;------ KbdStartScan -----------------------------------------------------------
KbdStartScan:
; Starts a keyboard scan cycle.
; Inputs:
;  - None
; Output:
;  - Documented effect(s)
; Destroys:
;  - A
	ld	a, (mpKbdScanMode)
	cp	kbdSingleScan
	ret	z
	ld	a, kbdSingleScan
	ld	(mpKbdScanMode), a
	ret


;------ KbdScanEvent -----------------------------------------------------------
KbdScanEvent:
; Processes keyboard data from keyboard driver.
; Inputs:
;  - None
; Output:
;  - Documented effect(s)
; Destroys:
;  - AF
;  - B
;  - HL
	ld	a, kbdIntScanDone
	ld	(mpKbdInterruptStatus), a
	call	KbdRawScan
	; Is a key pressed?
	or	a
	jr	z, kbdNoKey
	; Key is pressed.  Was a key pressed before?
	ld	b, a
	ld	a, (kbdLastKey)
	; Is it the same as before?  If so, do not accept it as a new key press.
	cp	b
	ld	a, 2
	ld	(kbdInhibitTimer), a
	ret	z
	; Different, so accept new key press.
	ld	a, b
	ld	(kbdLastKey), a
	ld	(keyBuffer), a
	ret
kbdNoKey:
	; Should we decrement the key release debounce counter?
	ld	a, (kbdLastKey)
	or	a
	ret	z
	ld	hl, kbdInhibitTimer
	dec	(hl)
	ret	nz
	; Debounce counter expired, so allow key again.
	xor	a
	ld	(kbdLastKey), a
	ret


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
