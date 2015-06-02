; Interrupts!
; TODO:
;  - Select interrupt sources
;  - Timer stuff
;  - IM2 init
;  - Dispatch interrupts to correct handler


pIntStatus	.equ	7000h
mpIntStatus	.equ	0F00000h
pIntMask	.equ	7004h
mpIntMask	.equ	0F00004h
pIntAck		.equ	7008h
mpIntAck	.equ	0F00008h
pIntLachEnable	.equ	700Ch
mpIntLachEnable	.equ	0F0000Ch
pIntXor		.equ	7010h
mpIntXor	.equ	0F00010h
pIntStatusMasked	.equ	7014h
mpIntStatusMasked	.equ	0F00014h

intOnKey	.equ	1
intOnKeyB	.equ	0
intTimer1	.equ	2
intTimer1B	.equ	1
intTimer2	.equ	4
intTimer2B	.equ	2
intTimer3	.equ	8
intTimer3B	.equ	3
intOsTimer	.equ	10h
intOsTimerB	.equ	4
intKbd		.equ	400h
intKbdB		.equ	10
intLcd		.equ	800h
intLcdB		.equ	11
intRtc		.equ	1000h
intRtcB		.equ	12

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



;------ InterruptHandler -------------------------------------------------------
InterruptHandler:


