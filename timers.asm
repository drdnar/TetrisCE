; Timers
; TODO:
;  - Deal with USB stuff at some point, for now assume USB off
;  - Set up general-purpose 1 kHz timer
;  - Handle timing
;  - Interrupt handler

;------ ResetTimers ------------------------------------------------------------
ResetTimers:
; Resets timer hardware back to OS-expected values
; Inputs:
;  - None
; Outputs:
;  - Documented effect(s)
; Destroys:
;  - Assume all
	ret


;------ OneSecondWait ----------------------------------------------------------
OneSecondWait:
; Does what it says.
; Destroys:
;  - HL
;  - DE
;  - AF
	; Halt timer & configure it
	ld	hl, mpTimersControlRegister
	ld	a, (hl)
	and	~(mTimer1Enable | mTimer1InterruptEnable)
	ld	(hl), a
	inc	hl
	ld	a, (hl)
	or	H_BYTE(mTimer1CountUp)
	ld	(hl), a
	; Zero-out counter
	ex	de, hl
	sbc	hl, hl	; C zeroed from above
	ld	(mpTimer1Count + 1), hl
	ld	(mpTimer1Count), hl
	; Set alarm registers to non-triggering value
	dec	hl
	ld	(mpTimer1AlarmValue1), hl
	ld	(mpTimer1AlarmValue2), hl
	; Enable timer!
	ex	de, hl
	dec	hl
	ld	a, (hl)
	or	mTimer1Enable | mTimer1SrcCrystal
	ld	(hl), a
	ex	de, hl
	ld	hl, mpTimer1Count + 1
_:	bit	7, (hl)
	jr	z, -_
	ex	de, hl
	ld	a, (hl)
	and	~mTimer1Enable
	ld	(hl), a
	ret


;------ StartGeneralPurposeTimer -----------------------------------------------
StartGeneralPurposeTimer:
	; Halt timer & configure it
	ld	hl, mpTimersControlRegister
	ld	a, (hl)
	and	~(mTimer1Enable | mTimer1InterruptEnable)
	ld	(hl), a
	inc	hl
	ld	a, (hl)
	or	H_BYTE(mTimer1CountUp)
	ld	(hl), a
	; Zero-out counter
	ex	de, hl
	sbc	hl, hl	; C zeroed from above
	ld	(mpTimer1Count + 1), hl
	ld	(mpTimer1Count), hl
	; Set alarm registers to non-triggering value
	dec	hl
	ld	(mpTimer1AlarmValue1), hl
	ld	(mpTimer1AlarmValue2), hl
	; Enable timer!
	ex	de, hl
	dec	hl
	ld	a, (hl)
	or	mTimer1Enable | mTimer1SrcCrystal
	ld	(hl), a
	ret


;------ SetGeneralPurposeTimer -------------------------------------------------
SetGeneralPurposeTimer:
	; The eZ80 doesn't have atomic multibyte writes.
	; So the counter can actually change between bytes.
	; So write the same value twice to deal with that.
	ld	(mpTimer1Count), hl
	ld	(mpTimer1Count), hl
	ret


;------ CheckTimer -------------------------------------------------------------
CheckTimer:
	or	a
	ld	hl, (mpTimer1Count)
	ld	de, (mpTimer1Count)
	sbc	hl, de
	jr	z, +_
	ld	de, (mpTimer1Count)
_:	or	a
	sbc	hl, hl
	ld	a, e
	and	1Fh
	ld	l, a
	call	SetGeneralPurposeTimer
	ld	b, 5	
_:	srl	d
	rr	e
	djnz	-_
	or	a
	ld	hl, (generalTimer)
	sbc	hl, de
	ld	(generalTimer), hl
	ret	nc
	or	a
	sbc	hl, hl
	ld	(generalTimer), hl
	ret

