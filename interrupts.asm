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
	


;------ InterruptHandler -------------------------------------------------------
InterruptHandler:


