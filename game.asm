shortWait	.equ	128	; 0.125 s	;500
longWait	.equ	2048	; 2 s		;6000
mediumWait	.equ	1024	; 1 s	;3000

firstNkiChar	.equ	33
lastNkiChar	.equ	126

RobotFindsKitten:
;------ StartGame --------------------------------------------------------------
StartGame:
	; Reset some vars
	ld	hl, 0
	ld	(foundObject), hl
	ld	(stringOffset), hl
	ld	(stringStage), hl
	ld	(scrollTimer), hl
	; Clear object table
	ld	a, 255
	ld	hl, objectArray
	call	ClearMem
; Choose number of NKIs to generate
	ld	b, 12
	call	RandRange8
	add	a, 16
	ld	(objectCount), a
	ld	(stringStage), a
	ld	ix, objectArray
generateLoop:

;	ld	a, '.'
;	call	PutC

	; Random location
;	push	ix
	call	RandomLocation
	ld	(ix), e
	ld	(ix+1), d
robj:	; Random item

	ld	bc, (itemsCount)
	call	RandRange16
;	dec	hl	; I'm not sure what this was for? Range?
	; Check for duplicate objects
;#ifdef	NEVER
	ex	de, hl
	ld	hl, objectArray
	ld	a, (objectCount)
	ld	b, a
	inc	hl
	inc	hl
robjlp:	ld	a, (hl)
	inc	hl
	cp	e
	jr	nz, +_
	ld	a, (hl)
	cp	d
	jr	z, robj
_:	inc	hl
	inc	hl
	inc	hl
	inc	hl
	inc	hl
	djnz	robjlp
;#endif
	ld	(ix+2), e
	ld	(ix+3), d
rglph:	; Random glyph
	ld	b, lastNkiChar - firstNkiChar
	call	RandRange8
	add	a, firstNkiChar
	cp	'#'
	jr	z, rglph
	ld	(ix+4), a
rclr:	; Random color
	call	Rand16
	ld	a, h
	ld	hl, colorsBlacklist
	ld	b, (hl)
	inc	hl
_:	cp	(hl)
	inc	hl
	jr	z, rclr
	djnz	-_
	ld	(ix+5), a
	; Loop control
	lea	ix, ix + 6
	ld	a, (stringStage)
	dec	a
	ld	(stringStage), a
	jp	nz, generateLoop
	ld	a, 255
	ld	(textForeColor), a
; Random location for kitten
; Just use the last generated random item
	ld	(ix-3), 255
	ld	(ix-4), 255

; Initial Location
	call	RandomLocation
	ld	(cursorY), de


;------ ------------------------------------------------------------------------

; Wait
	call	GetKey
; Draw everything
	; Erase intro text
	call	ClrScrnFull
	ld	ix, objectArray
	ld	a, (objectCount)
	ld	b, a
_:	ld	l, (ix)
	inc	ix
	ld	h, (ix)
	inc	ix
	call	Locate
	inc	ix
	inc	ix
	ld	a, (ix+1)
	inc	ix
	ld	(textForeColor), a
	ld	a, (ix-1)
	inc	ix
	call	PutC
	djnz	-_
	
	ld	a, 255
	ld	(textForeColor), a
	
; Get the timer going
	call	StartGeneralPurposeTimer


;------ GameLoop ---------------------------------------------------------------
GameLoop:
	ld	hl, (cursorY)
	call	Locate
	ld	a, '#'
	call	PutC
	
getKeyLoop:
	call	CheckTimer
	ld	a, (foundObject)
	or	a
	jp	z, getKeyLoopKeyGet
	ld	a, (stringStage)
	cp	1
	jp	z, stringPause1
	cp	2
	jr	z, stringScroll
	cp	3
	jp	z, stringPause2
stringRestart:
; This string scrolling code is recycled largely unchanged from my old B&W RFK.
	ld	a, 1
	ld	(stringStage), a
	xor	a
	ld	(foundObject), a
	ld	hl, 16
	call	Locate
	ld	hl, itemCache
	call	PutS
	push	af
	call	ClearEOL
	pop	af
	jp	c, getKeyLoopKeyGet
	ld	hl, 1F10h
	call	Locate
	ld	a, '.'
	call	PutC
	call	PutC
	call	PutC
	ld	a, 1
	ld	(foundObject), a
	ld	hl, mediumWait
	ld	(scrollTimer), hl
	ld	hl, itemCache
	ld	(stringOffset), hl
	jp	getKeyLoopKeyGet
stringScroll:
	ld	hl, (scrollTimer)
	ld	de, 0FFFFFFh
	add	hl, de	; flags
	jr	c, getKeyLoopKeyGet
	ld	hl, 16
	call	Locate
	ld	hl, (stringOffset)
	inc	hl
	ld	(stringOffset), hl
	call	PutS
	push	af
	call	ClearEOL
	pop	af
	jr	c, stringScrollDispStringDoneScroll
	ld	hl, 1F10h
	call	Locate
	ld	a, '.'
	call	PutC
	call	PutC
	call	PutC
	ld	hl, shortWait
	ld	(scrollTimer), hl
	jr	getKeyLoopKeyGet
stringScrollDispStringDoneScroll:
	ld	hl, longWait
	ld	(scrollTimer), hl
	ld	a, (stringStage)
	inc	a
	ld	(stringStage), a
	jr	getKeyLoopKeyGet
stringPause1:
stringPause2:
	ld	hl, (scrollTimer)
	ld	de, 0FFFFFFh
	add	hl, de
	jr	c, getKeyLoopKeyGet
	ld	hl, shortWait
	ld	(scrollTimer), hl
	ld	a, (stringStage)
	inc	a
	ld	(stringStage), a
	
getKeyLoopKeyGet:
	ei
	halt
	call	_GetCSC
	or	a
	jp	z, getKeyLoop

	push	af
	ld	hl, (cursorY)
	call	Locate
	ld	a, chThickSpace
	call	PutC
	pop	af
	cp	skUp
	jr	z, glUp
	cp	skDown
	jr	z, glDown
	cp	skLeft
	jr	z, glLeft
	cp	skRight
	jr	z, glRight
	cp	skClear
	jp	z, Quit
;	cp	skGraph
;	jp	z, StartGame
;	cp	skGraph
;	jp	z, redraw
	jp	GameLoop
glUp:
	ld	de, (cursorY)
	ld	a, e
	or	a
	jp	z, GameLoop
	dec	a
	ld	e, a
	call	TestCollision
	jr	c, glSetNki
	ld	(cursorY), de
	jp	GameLoop
glDown:
	ld	de, (cursorY)
	ld	a, e
	inc	a
	cp	16
	jp	z, GameLoop
	ld	e, a
	call	TestCollision
	jr	c, glSetNki
	ld	(cursorY), de
	jp	GameLoop
glLeft:
	ld	de, (cursorY)
	ld	a, d
	or	a
	jp	z, GameLoop
	dec	a
	ld	d, a
	call	TestCollision
	jr	c, glSetNki
	ld	(cursorY), de
	jp	GameLoop
glRight:
	ld	de, (cursorY)
	ld	a, d
	inc	a
	cp	32
	jp	z, GameLoop
	ld	d, a
	call	TestCollision
	jr	c, glSetNki
	ld	(cursorY), de
	jp	GameLoop
glSetNki:
	push	hl
	pop	ix
	xor	a
	ld	(stringStage), a
	inc	a
	ld	(foundObject), a
	ld	de, 0
	ld	e, (hl)
	inc	hl
	ld	d, (hl)
	ex	de, hl
	ld	a, l
	cp	255
	jr	nz, +_
	ld	a, h
	cp	255
	jr	z, robotfoundkitten
_:	call	GetMessage
	;ld	hl, 16
	;call	Locate
	;ld	hl, itemCache
	;call	PutS
	;call	ClearEOL
	jp	GameLoop

#ifdef NEVER
redraw:
	call	ClrScrnFull
	ld	ix, objectArray
	ld	a, (objectCount)
	ld	b, a
_:	ld	l, (ix)
	inc	ix
	ld	h, (ix)
	inc	ix
	call	Locate
	inc	ix
	inc	ix
	ld	a, (ix+1)
	inc	ix
	ld	(textForeColor), a
	ld	a, (ix-1)
	inc	ix
	call	PutC
	djnz	-_
	
	ld	a, 255
	ld	(textForeColor), a
	jp	GameLoop
#endif


;------ Robot found kitten! ----------------------------------------------------
robotfoundkitten:
meetingLine	.equ	5
	ld	hl, 0FFh
	ld	(textColors), hl
	call	ClrScrnFull
	
	ld	a, 0FFh
	ld	(textForeColor), a
	ld	hl, endSeq1
	ld	b, meetingLine
	call	PutSCentered
	ld	a, (ix+3)
	ld	(textForeColor), a
	ld	a, (ix+2)
	call	PutC
	call	OneSecondWait
	
	ld	hl, meetingLine
	call	Locate
	call	ClearEOL
	ld	a, 0FFh
	ld	(textForeColor), a
	ld	hl, endSeq2
	ld	b, meetingLine
	call	PutSCentered
	ld	a, (ix+3)
	ld	(textForeColor), a
	ld	a, (ix+2)
	call	PutC
	call	OneSecondWait
	
	ld	hl, meetingLine
	call	Locate
	call	ClearEOL
	ld	a, 0FFh
	ld	(textForeColor), a
	ld	hl, endSeq3
	ld	b, meetingLine
	call	PutSCentered
	ld	a, (ix+3)
	ld	(textForeColor), a
	ld	a, (ix+2)
	call	PutC
	call	OneSecondWait
	
	ld	hl, meetingLine
	call	Locate
	call	ClearEOL
	ld	a, 0FFh
	ld	(textForeColor), a
	ld	hl, endSeq4
	ld	b, meetingLine
	call	PutSCentered
	ld	a, (ix+3)
	ld	(textForeColor), a
	ld	a, (ix+2)
	call	PutC
	call	OneSecondWait
	
;	ld	hl, meetingLine
;	call	Locate
;	call	ClearEOL
	ld	a, 0E0h	;0FFh
	ld	(textForeColor), a
	ld	hl, robotfindskittenMsg
	ld	b, meetingLine - 1
	call	PutSCentered
	call	OneSecondWait

;	call	GetCSC
;	xor	a
;	ld	(keyBuffer), a
	
	ld	hl, 0FFh
	ld	(textColors), hl
	ld	hl, goodJobMsg
	ld	b, 11	;meetingLine + 1	;11
	call	PutSCentered

	ld	hl, 16
	call	Locate
	ld	hl, repeatMsg
	call	PutS
	
	call	GetKey
	cp	skEnter
	jp	z, TitleScreen
	cp	sk1
	jp	z, TitleScreen
	jp	Quit




;====== Routines ===============================================================
;------ TestCollision ----------------------------------------------------------
TestCollision:
; Tests if is an item at the given location.
; Input:
;  - D: X
;  - E: Y
; Outp
;  - C on collision
;  - NC if no collision
;  - HL points to object entry's itemId
;  - HL points to garbage otherwise
; Destroys:
;  - AF
;  - BC
	push	bc
	ld	hl, objectArray
	ld	a, (objectCount)
	ld	b, a
testCollisionLoop:
	ld	a, (hl)
	inc	hl
	cp	e
	ld	a, (hl)
	inc	hl
	jr	nz, +_
	cp	d
	jr	nz, +_
	scf
	pop	bc
	ret
_:	inc	hl
	inc	hl
	inc	hl
	inc	hl
	djnz	testCollisionLoop
	or	a
	pop	bc
	ret


;------ RandomLocation ---------------------------------------------------------
RandomLocation:
; Returns DE
;	push	ix
	call	Rand16
	ld	a, h
	and	1Fh
	ld	d, a
	ld	a, l
	and	0Fh
	ld	e, a
	call	TestCollision
	jr	c, RandomLocation
	ret