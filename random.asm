
InitializeRandomRoutines:
	ld	hl, RandomRoutinesStart
	ld	de, shortModeCode
	ld	bc, RandomRoutinesEndShort - RandomRoutinesStartShort
	ldir
	ret


;#define	RAND_SMC
#define	RAND_INC
#define	RAND_RANGE8
#define	RAND_RANGE16
;#define	RAND_RANGE10
;#define	RAND_TIBCD

; Random Number Generator Routines
; Author:
;  - Zeda Thomas (xedaelnara@gmail.com)
; License:
;  - All parts of this document may be used for any purpose.
;  - Give some credit to the author, even if only mentioned in the source code.
;     - This is mainly so that any issues with the codes or algorithms can be reported.
;     - If this license info is unchanged and included in this file, that will suffice.
; Disclaimer:
;  - These are NOT cryptographically secure. These are quality PRNGs for games and simulation.
; Routines:
;   routine         in         out              mode    size    speed
; =====================================================================
;   rand            ---         HL               Z80    53      65~67
;   randrange8      B           A in [0,B-1]     Z80    10      85~87
;   randrange16     BC          HL in [0,BC-1]   Z80    10      142~146
;   rand10          ---         A in [0,9]       Z80    16      88~90
;   randTI          HL          (hl)             Z80    27      1540~1568
;   mlt16           HL,BC       DEBC             Z80    30      54~56


#IFDEF	RAND_INC
Rand16:
	di
	stmix
	call.is	Rand16Short
	rsmix
	ei
	ret
#ENDIF

#IFDEF	RAND_RANGE8
RandRange8:
	di
	stmix
	call.is	RandRange8Short
	rsmix
	ei
	ret
#ENDIF

#IFDEF	RAND_RANGE16
RandRange16:
	di
	stmix
	call.is	RandRange16Short
	rsmix
	ei
	ret
#ENDIF


RandomRoutinesStart:
.ASSUME	ADL=0
.org	shortModeCode & 0FFFFh

RandomRoutinesStartShort:

#IFDEF	RAND_INC
Rand16Short:
; Inputs:
;  - (seed1) is a non-zero 16-bit int
;  - (seed2) is a 16-bit int
; Outputs:
;  - HL is the pseudo-random number
;  - DE is the output of the LFSR
;  - BC is the previous seed of the Lehmer PRNG
;  - (seed1) is the output of the LFSR
;  - (seed2) is the output of the Lehmer PRNG
; Destroys:
;  - AF
; Notes:
;  - This uses a 16-bit Lehmer PRNG, and an LFSR
;  - The period is 4,294,901,760 (65536*65535)
;  - Technically,the Lehmer PRNG here can have values from 1 to 65536. In this application, we store 65536 as 0.
; Speed:
;  - Add 4cc if smc==0
;  - 65+2a, a is 0 or 1
;     -  probability a= 1 is 38/65536
;  - Average: 65.00115966796875
;  - Best: 65
;  - Worst: 67
; 53 bytes
#IFNDEF	RAND_SMC
	ld	hl, (seed2Short)
#ELSE
seed2 = $ + 1
	ld	hl, 0
#ENDIF
	; multiply by 75
	ld	a,h
	or	l
	jr	nz, nospecial
	ld	hl, -74
	jr	writeseed2
nospecial:
	ld	b, h
	ld	c, 75
	ld	h, c
	mlt	hl
	mlt	bc
	ld	a, c
	add	a, h
	ld	h, a
	ld	c, b
	ld	b, 0
	sbc	hl, bc
	jr	nc, $ + 5
	inc	hl	\	inc	hl	\	inc	hl
writeseed2:
	ld	(seed2Short), hl
	ex	de, hl
#IFNDEF	RAND_SMC
	ld	hl, (seed1Short)
#ELSE
seed1 = $ + 1
	ld	hl, 1
#ENDIF
	ld	a, h
	add	hl, hl
	and	%10110100
	jp	po, $ + 4
	inc	l
	ld	(seed1Short), hl
	add	hl, de
	ret.l
#ENDIF


#IFDEF	RAND_RANGE8
RandRange8Short:
; Input:
;  - B
; Output:
;  - A, H is a number on [0,B-1]
; Example, if B is 10, this outputs an int from 0 to 9
; 85cc~87
; 10 bytes
	push	bc
	call.is	Rand16Short
	pop	bc
	ld	l, b
	mlt	hl
	ld	a, h
	ret.l
#ENDIF


#IFDEF	RAND_RANGE16
RandRange16Short:
; Input:
;  - BC is the exclusive upperbound
; Output:
;  - HL is an int less than BC
; 142cc~146cc
	push	bc
	call.is	Rand16Short
	pop	bc
	call.is	Mul16Short
	ex	de, hl
	ret.l
Mul16Short:
; Expects Z80 mode
; Inputs:
;  - HL
;  - BC
; Outputs:
;  - Upper 16 bits in DE, lower 16 bits in BC
; 54 or 56 t-states
; 30 bytes
	ld	d, c	\	ld	e, l	\	mlt	de	\	push	de
	ld	d, h	\	ld	e, b	\	mlt	de
	ld	a, l	\	ld	l, c	\	ld	c, a
	mlt	hl	
	mlt	bc
	add	hl, bc
	jr	nc, $ + 3 \	inc	de
	pop	bc
	ld	a, b	\	add	a, l	\	ld	b, a
	ld	a, e	\	adc	a, h	\	ld	e, a
	ret.l	nc
	inc	d
	ret.l
#ENDIF


#IFDEF	RAND_TIBCD
RandTIShort:
; Inputs:
;  - HL points to where the float should be written (does not allocate RAM).
; Outputs:
;  - Stores a random floating point number on [0,1) to where HL points
; 1540~1568
#IFNDEF	RAND_RANGE10
	#define	RAND_RANGE10
#ENDIF
	ld	(hl), 0		\	inc	hl
	ld	(hl), 7Fh	\	inc	hl
	ld	b, 7
randTIloop:
	push	bc
	push	hl
	call.is	RandRange10Short
	pop	hl
	rrd
	push	hl
	call.is	RandRange10Short
	pop	hl
	rrd
	pop	bc
	djnz	randTIloop
	ret.l
#ENDIF


#IFDEF	RAND_RANGE10
RandRange10Short:
; Output:
;  - A is an int from 0 to 9.
; 88cc~90cc
; 16 bytes
	call.is	Rand16Short
	xor	a
	ld	b, h
	ld	c, l
	add	hl, hl	\	rla
	add	hl, hl	\	rla
	add	hl, bc	\	adc	a, 0
	add	hl, hl	\	rla
	ret.l
#ENDIF


RandomRoutinesEndShort:
.ASSUME	ADL=1
.org	RandomRoutinesStart + (RandomRoutinesEndShort - RandomRoutinesStartShort)
RandomRoutinesEnd: