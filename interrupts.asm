; Interrupts!
; TODO:
;  - Select interrupt sources
;  - Timer stuff
;  - IM2 init
;  - Dispatch interrupts to correct handler



;------ ResetInterrupts --------------------------------------------------------
ResetInterrupts:
; Resets interrupt controller back to OS's expected values
; Inputs:
;  - None
; Outputs:
;  - Documented effect(s)
; Destroys:
;  - Assume all
	ld	hl, +_
	ld	de, mpIntMask
	ld	bc, 16
	ldir
	ret
_:	.dw	intOnKey | intOsTimer | intRtc | 2000h, 0
	.dw	0FFFFh, 0FFFFh
	.dw	intOnKey | intTimer3 | intOsTimer, 0
	.dw	0, 0


;------ InitializeInterrupts ---------------------------------------------------
InitializeInterrupts:
; Initializes internal IM2.
; Inputs:
;  - None
; Outputs:
;  - Documented effect(s)
; Destroys:
;  - Assume all
	di
	; Configure interrupt sources
	ld	hl, interruptConfiguration
	ld	de, mpIntMask
	ld	bc, 16
	ldir
	; Configure IVT location
	ld	hl, ivtLocation >> 8
	ld	i, hl
	; Build IVT
	ld	a, isrLocation & 255
	ld	de, ivtLocation + 1
	ld	hl, ivtLocation
	ld	(hl), a
	ld	bc, 257
	ldir	; 257+1 bytes
	; Branch to real ISR
	ld	hl, isrLocation
	ld	a, 0C3h
	ld	(hl), a
	inc	hl
	ld	de, InterruptHandler
	ld	(hl), de
	im	2
	ret
interruptConfiguration:
	; Mask
	.dl	intOnKey | intTimer1 | intOsTimer | intKbd
	.db	0
	; ACK any outstanding interrupts
	.dl	0FFFFFFh
	.db	0
	; Latch
	.dl	intOnKey | intTimer1 | intOsTimer | intKbd
	.db	0
	; Invert
	.dl	0
	.db	0;	CHECK IF INTERRUPT VECTOR IS BUS NOISE OR FORCED TO SPECIFIC VALUE


;------ InterruptHandler -------------------------------------------------------
InterruptHandler:
	push	af
	push	hl
	; Check interrupt source
	ld	hl, (mpIntStatusMasked)
	ld	a, l
	add	a, a	; Bit 7
	jr	c, unknownInt
	add	a, a	; Bit 6
	jr	c, unknownInt
	add	a, a	; Bit 5
	jr	c, unknownInt
	add	a, a	; Bit 4 (possibly OS timer?)
	jr	c, handleOsTimer
	add	a, a	; Bit 3 (timer 3)
	jr	c, unknownInt
	add	a, a	; Bit 2 (timer 2)
	jr	c, unknownInt
	add	a, a	; Bit 1 (timer 1)
	jr	c, handleTimer1
	add	a, a	; Bit 0 (ON key)
	jp	c, handleOnKey
	ld	a, h
	add	a, a	; Bit 15
	jr	c, unknownInt
	add	a, a	; Bit 14
	jr	c, unknownInt
	add	a, a	; Bit 13
	jr	c, unknownInt
	add	a, a	; Bit 12 (RTC)
	jr	c, handleRtc
	add	a, a	; Bit 11 (LCD)
	jr	c, handleLcd
	add	a, a	; Bit 10 (keyboard)
	jr	c, handleKeyboard
	add	a, a	; Bit 9
	jr	c, unknownInt
	add	a, a	; Bit 8
	jr	c, unknownInt
unknownInt:
handleRtc:
handleLcd:
	jp	Quit
handleOsTimer:
	ld	a, MASK_TO_BYTE(intOsTimer)
	ld	(mpIntAck + BIT_TO_OFFSET(intOsTimerB)), a
	ld	hl, (generalTimer)
	inc	hl
	ld	(generalTimer), hl
exitInterrupt:
	pop	hl
	pop	af
	ei
	ret


handleKeyboard:
	ld	a, MASK_TO_BYTE(intKbd)
	ld	(mpIntAck + BIT_TO_OFFSET(intKbdB)), a
	jr	exitInterrupt


handleTimer1:
	ld	a, MASK_TO_BYTE(intTimer1)
	ld	(mpIntAck + BIT_TO_OFFSET(intTimer1B)), a
	jr	exitInterrupt


handleOnKey:
	ld	a, MASK_TO_BYTE(intOnKey)
	ld	(mpIntAck + BIT_TO_OFFSET(intOnKeyB)), a
	pop	hl
	pop	af
	jp	Quit

