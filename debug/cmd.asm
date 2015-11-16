;===============================================================================
;====== ========================================================================
;===============================================================================
;------ ------------------------------------------------------------------------
debug_CmdInitialize:
; Reset windows
; Reset edit buffers
; Reset command history buffers
; Reset command output buffers
	call	debug_CmdScrollBufferInitialize
	xor	a
	ld	(debug_CmdActive), a
	ld	bc, debug_CmdSize
	ld	de, debug_Cmd0
	ld	hl, debug_Cmd0Clear
	ldir
	ret
debug_Cmd0Clear:
	.dl	0	; debug_EditFlags
	.dl	debug_EditBuffer1	; debug_EditStart
	.dl	debug_EditBuffer1 + debug_EditBufferSize - 1	; debug_EditEnd
	.dl	debug_EditBuffer1	; debug_EditPtr
	.dl	debug_EditBuffer1	; debug_EditBottom
	.dl	0	; debug_EditStartY, debug_EditStartX
	.dl	0	; debug_EditY, debug_EditX
	.db	0	; debug_CmdFlags
	.db	0	; debug_CmdScBufLock
	.db	6	; debug_CmdScBufBottomLine
	.db	0			; debug_CmdScBufRow
	.db	0			; debug_CmdScBufCol
	.db	0			; debug_CmdScBufUnused
	.dl	debug_OutputBuffer1	; debug_CmdOutBufStart
	.dl	debug_OutputBuffer1 + 128;debug_OutputBufferSize	; debug_CmdOutBufEnd
	.dl	debug_OutputBuffer1	; debug_CmdOutBufTop
	.dl	debug_OutputBuffer1	; debug_CmdOutBufBottom
	.dl	debug_HistoryBuffer1	; debug_CmdHistStart
	.dl	debug_HistoryBuffer1 + debug_HistoryBufferSize	; debug_CmdHistEnd
	.dl	debug_HistoryBuffer1	; debug_CmdHistTop
	.dl	debug_HistoryBuffer1	; debug_CmdHistBottom





debug_testStuff:
	.db	6
	.db	0
	.db	0
	.db	0
	.dl	debug_OutputBuffer1	; debug_CmdOutBufStart
	.dl	debug_OutputBuffer1 + 8;debug_OutputBufferSize	; debug_CmdOutBufEnd
	.dl	debug_OutputBuffer1 + 5	; debug_CmdOutBufTop
	.dl	debug_OutputBuffer1 + 2	; debug_CmdOutBufBottom

debug_testStr:
	.db	"I am happy to join with you today in what will go down in history as the greatest demonstration for freedom in the history of our nation. Five score years ago, a great American, in whose symbolic shadow we stand, signed the Emancipation Proclamation. "
	.db	"This momentous decree came as a great beacon light of hope to millions of Negro slaves who had been seared in the flames of withering injustice. "
	.db	"It came as a joyous daybreak to end the long night of captivity. But 100 years later, we must face the tragic. . . .", 0

debug_Cmd0VarsList:
	.db	debug_ShowVarsSetCursorPos
	.db	14, 0
	.db	debug_ShowVarsShowLabel | 2
	.dl	debug_Cmd0 + debug_CmdFlags
	.dl	debug_strFlags
	.db	debug_ShowVarsShowLabel | 1
	.dl	debug_Cmd0 + debug_CmdScBufBottomLine
	.dl	debug_strBottomLine
	.db	debug_ShowVarsShowLabel | 2
	.dl	debug_Cmd0 + debug_CmdScBufRow
	.dl	debug_strCursor
	.db	debug_ShowVarsShowLabel | debug_ShowVarsLittleEndian | debug_ShowVarsNewLine | 3
	.dl	debug_Cmd0 + debug_CmdScBufStart
	.dl	debug_strStart
	.db	debug_ShowVarsShowLabel | debug_ShowVarsLittleEndian | 3
	.dl	debug_Cmd0 + debug_CmdScBufEnd
	.dl	debug_strEnd
	.db	debug_ShowVarsShowLabel | debug_ShowVarsLittleEndian | debug_ShowVarsNewLine | 3
	.dl	debug_Cmd0 + debug_CmdScBufTop
	.dl	debug_strTop
	.db	debug_ShowVarsShowLabel | debug_ShowVarsLittleEndian | 3
	.dl	debug_Cmd0 + debug_CmdScBufBottom
	.dl	debug_strBottom
	.db	0

debug_strFlags:
	.db	"Flags: ", 0
debug_strBottomLine:
	.db	" B-Line: ", 0
debug_strCursor:
	.db	" Cursor: ", 0
debug_strStart:
	.db	"Start: ", 0
debug_strEnd:
	.db	" End: ", 0
debug_strTop:
	.db	"Top: ", 0
debug_strBottom:
	.db	" Bottom: ", 0


;------ ------------------------------------------------------------------------
debug_CmdStart:
; Reset stack
	ld	sp, debug_Stack + debug_StackSize + 1
; Get reference to starting buffer
	ld	iy, debug_Cmd0
; TODO: Redraw output buffer
	call	debug_ClearLcd
	call	debug_HomeUp
	
; Display command prompt



	call	debug_ScBufClear
	
	ld	hl, debug_testStuff
	lea	de, iy + debug_CmdScBufBottomLine
	ld	bc, 19
	ldir
	ld	hl, debug_testStr
	ld	de, debug_OutputBuffer1
	ld	bc, 513
	ldir
	
	DEBUG_EDIT_VARS(debug_Cmd0VarsList, 13)
	
	call	debug_GetKey
	call	debug_Exit
	
	
debug_TestLoopBlah:
	
	ld	hl, 8
	ld	(debug_CurRow), hl
	
	call	debug_GetKeyAscii
	bit	7, a
	jr	z, +_
	call	debug_PrintChar
	call	debug_ScBufPrintVars
	jr	debug_TestLoopBlah
_:	cp	skClear | 80h
	call	z, debug_Exit
	
	jr	debug_TestLoopBlah
	

	ld	hl, debug_prompt
	call	debug_PutS
	
	ld	iy, debug_Cmd0
	call	debug_EditClear
	call	debug_EditBegin
	cp	skMode | 40h
	call	nz, debug_Exit
	
	jp	debug_CmdStart


_:	call	debug_GetKeyAscii
	bit	7, a
	jr	nz, +_
	call	debug_PutC
	jr	-_
_:	cp	skClear | 80h
	jp	nz, debug_CmdStart
	call	debug_Exit
	jp	debug_CmdStart

debug_prompt:
	.db	"> ", 0



;===============================================================================
;====== Scroll Buffer ==========================================================
;===============================================================================
debug_CmdScrollBufferInitialize:

	ret



;------ ScBufClear -------------------------------------------------------------
debug_ScBufClear:
; Clears the scroll buffer
; Input:
;  - IY: Pointer to scroll buffer struct
; Outputs:
;  - Documented effect(s)
; Destroys:
;  - HL
	ld	hl, (iy + debug_CmdScBufStart)
	ld	(iy + debug_CmdScBufTop), hl
	ld	(iy + debug_CmdScBufBottom), hl
	ret


;------ ScBufIsEmpty -----------------------------------------------------------
debug_ScBufIsEmpty:
; Tests if the scroll buffer is empty.
; Input:
;  - IY: Pointer to scroll buffer struct
; Output:
;  - Z if empty, NZ if not empty
; Destroys:
;  - Nothing
	push	hl
	push	de
	ld	hl, (iy + debug_CmdScBufTop)
	ld	de, (iy + debug_CmdScBufBottom)
	or	a
	sbc	hl, de
	pop	de
	pop	hl
	ret


;------ ScBufIncPtr ------------------------------------------------------------
debug_ScBufIncPtr:
; Increments a pointer in the scroll buffer, handling wrapping, but does not
; check whether the pointer will stay within the buffer data bounds.
; Inputs:
;  - HL: Pointer
;  - IY: Pointer to scroll buffer struct
; Output:
;  - HL: Pointer
; Destroys:
;  - Nothing
	push	af
	push	de
	inc	hl
	ld	de, (iy + debug_CmdScBufEnd)
	or	a
	sbc	hl, de
	add	hl, de
	jr	c, +_
	ld	hl, (iy + debug_CmdScBufStart)
_:	pop	de
	pop	af
	ret


;------ ScBufDecPtr ------------------------------------------------------------
debug_ScBufDecPtr:
; Deincrements a pointer in the scroll buffer, handling wrapping, but does not
; check whether the pointer will stay within the buffer data bounds.
; Inputs:
;  - HL: Pointer
;  - IY: Pointer to scroll buffer struct
; Outputs:
;  - HL: Pointer
; Destroys:
;  - Nothing
	push	af
	push	de
	ld	de, (iy + debug_CmdScBufStart)
	dec	hl
	or	a
	sbc	hl, de
	add	hl, de
	jr	nc, +_
	ld	hl, (iy + debug_CmdScBufEnd)
	dec	hl
_:	pop	de
	pop	af
	ret


;------ ScBufForward -----------------------------------------------------------
debug_ScBufForward:
; Increments a pointer in the scroll buffer.
; Inputs:
;  - HL: Pointer
;  - IY: Pointer to scroll buffer struct
; Outputs:
;  - HL: Pointer
;  - Z if already at end of buffer, NZ if still more buffer
; Destroys:
;  - Flags
	call	debug_ScBufIsEmpty
	ret	z
	push	de
	inc	hl
	; Check for wrapping
	ld	de, (iy + debug_CmdScBufEnd)
	or	a
	sbc	hl, de
	add	hl, de
	ld	de, (iy + debug_CmdScBufBottom)
	jr	c, +_
	; Wrapped
	ld	hl, (iy + debug_CmdScBufTop)
	or	a
	sbc	hl, de
	add	hl, de
	pop	de
	ret	z
	ld	hl, (iy + debug_CmdScBufStart)
	ret
_:	; Not wrapped
	or	a
	sbc	hl, de
	add	hl, de
	pop	de
	ret	nz
	dec	hl
	ret


;------ ScBufBackward ----------------------------------------------------------
debug_ScBufBackward:
; Decrements a pointer in the scroll buffer.
; Inputs:
;  - HL: Pointer
;  - IY: Pointer to scroll buffer struct
; Outputs:
;  - HL: Pointer
;  - Z if already at start of buffer, NZ if still more
; Destroys:
;  - Flags
	call	debug_ScBufIsEmpty
	ret	z
	push	de
	; Check for wrapping
	ld	de, (iy + debug_CmdScBufStart)
	inc	de
	or	a
	sbc	hl, de
	add	hl, de
	ld	de, (iy + debug_CmdScBufTop)
	jr	nc, +_
	; Wrapped
	or	a
	sbc	hl, de
	add	hl, de
	pop	de
	ret	z
	ld	hl, (iy + debug_CmdScBufEnd)
	dec	hl
	ret
_:	; Not wrapped
	or	a
	sbc	hl, de
	add	hl, de
	pop	de
	dec	hl
	ret	nz
	inc	hl
	ret


;------ ScBufNextLine ----------------------------------------------------------
debug_ScBufNextLine:
; Seeks to the next line of the scroll buffer, given the start of a line.
; Inputs:
;  - HL: Pointer to current line
;  - IY: Pointer to scroll buffer struct
; Outputs:
;  - HL: Pointer to start of next line
;  - Z if end-of-buffer before next new line
; Destroys:
;  - AF, B
	ld	b, debug_Cols
_:	call	debug_ScBufForward
	ret	z
	ld	a, (hl)
	cp	debug_chNewLine
	jr	z, +_
	djnz	-_
	ret
_:	call	debug_ScBufForward
	xor	a
	inc	a
	ret


;------ ScBufPrevLine ----------------------------------------------------------
debug_ScBufPrevLine:
; Seeks to the previous line of the scroll buffer, given the start of a line.
; Inputs:
;  - HL: Pointer to current line
;  - IY: Pointer to scroll buffer struct
; Outputs:
;  - HL: Pointer to start of next line
;  - Z if seeked to start of buffer and cannot go further back
; Destroys:
;  - AF
	call	debug_ScBufBackward
	ret	z	
	push	bc
	ld	b, debug_Cols - 1
_:	call	debug_ScBufBackward
	ret	z
	ld	a, (hl)
	cp	debug_chNewLine
	jr	z, +_
	djnz	-_
	pop	bc
	ret
_:	call	debug_ScBufForward
	xor	a
	inc	a
	pop	bc
	ret


;------ ScBufFlushALine --------------------------------------------------------
debug_ScBufFlushALine:
; Removes the top-most line from the scroll buffer.
; Input:
;  - IY: Pointer to scroll buffer struct
; Output
;  - Text removed from buffer
; Destroys:
;  - Flags, HL
	ld	hl, (iy + debug_CmdScBufTop)
	call	debug_ScBufNextLine
	ld	(iy + debug_CmdScBufTop), hl
	set	debug_CmdFlagScBufEraseNotify, (iy + debug_CmdFlags)
	ret


;====== API for Actual Texty Stuff =============================================
;------ PrintChar --------------------------------------------------------------
debug_PrintChar:
; Prints a single glyph to the current scroll buffer.
;  - Carry if cannot print due to buffer locked
	push	hl
	push	de
	push	bc
	ld	c, a
	xor	a
	sub	(iy + debug_CmdScBufLock)
	jp	m, debug_printCharLocked
	inc	(iy + debug_CmdScBufLock)
	jr	nz, debug_printCharLocked
	ld	hl, (iy + debug_CmdScBufBottom)
	call	debug_ScBufIncPtr
	ld	de, (iy + debug_CmdScBufTop)
	or	a
	sbc	hl, de
	jr	nz, +_
	push	hl
	call	debug_ScBufFlushALine
	pop	hl
_:	ld	(hl), a
	ld	(iy + debug_CmdScBufBottom), hl
	ld	(iy + debug_CmdScBufLock), 255
	set	debug_CmdFlagScBufWriteNotify, (iy + debug_CmdFlags)
	or	a
debug_printCharLocked:
	ld	hl, (debug_CurRow)
	push	hl
	ld	hl, (iy + debug_CmdScBufRow)
	ld	c, a
	ld	a, (iy + debug_CmdScBufBottom)
	or	a
	jr	z, debug_printCharNoPrint
	cp	l
	jr	z, +_
	jr	nc, ++_
_:	

_:	ld	(debug_CurRow), hl
	call	debug_PutC
	
debug_printCharNoPrint:
	pop	hl
	ld	(debug_CurRow), hl
debug_printCharExit:
	pop	bc
	pop	de
	pop	hl
	ret


;------ PrintStr ---------------------------------------------------------------
debug_PrintStr:
	call	debug_PutS
	ret

debug_PrintUhl:

debug_PrintUhlDec:

debug_PrintByte:


;------ LogChar ----------------------------------------------------------------
debug_LogChar:
; Logs a single character to the current debug log scroll buffer.

debug_LogStr:

debug_LogUhl:

debug_LogUhlDec:

debug_LogByte:


;====== Display Routines =======================================================


;------ ScBufRefreshBuffer -----------------------------------------------------
debug_ScBufRefreshBuffer:
; Refreshes the buffer display.
	ld	a, (iy + debug_CmdScBufBottomLine)
	or	a
	ret	z
	ld	b, a
	ld	hl, (iy + debug_CmdScBufBottom)
_:	call	debug_ScBufPrevLine
	djnz	-_
	; Fall through to ScBufShowBuffer
;------ ScBufShowBuffer --------------------------------------------------------
debug_ScBufShowBuffer:
; Shows the buffer starting at a given position in the scroll buffer, and prints
; until CmdScBufBottom or it runs out of buffer.
; Input:
;  - HL: Start position
;  - IY: Pointer to scroll buffer struct
; Output:
;  - Documented effect(s)
; Destroys:
;  - AF, BC, DE, HL
;  - Cursor positon
	push	hl
	call	debug_ScBufPrintVars
	ld	hl, 0
	ld	(debug_CurRow), hl
	ld	hl, (iy + debug_CmdScBufStart)
	ld	de, (iy + debug_CmdScBufEnd)
	sbc	hl, de
	pop	hl
	jr	z, debug_scBufShowBufferClearEndOfWindow
debug_scBufShowBufferLoop:
	ld	a, (debug_CurRow)
	cp	(iy + debug_CmdScBufBottomLine)
	ret	nc
	ld	a, (hl)
	or	a
	ret	z
	cp	debug_chNewLine
	call	z, debug_NewLineClearEol
	call	debug_ScBufForward
	jr	nz, debug_scBufShowBufferLoop
debug_scBufShowBufferClearEndOfWindow:
	ld	a, (debug_CurRow)
	cp	(iy + debug_CmdScBufBottomLine)
	ret	nc
	call	debug_NewLineClearEol
	jr	debug_scBufShowBufferClearEndOfWindow


;------ ------------------------------------------------------------------------
debug_ScBufPrintVars:
	ld	hl, (debug_CurRow)
	push	hl
	ld	hl, 14
	ld	(debug_CurRow), hl
	ld	a, (iy + debug_CmdFlags)
	call	debug_DispByte
	ld	a, (iy + debug_CmdScBufLock)
	call	debug_DispByte
	ld	a, (iy + debug_CmdScBufBottomLine)
	call	debug_DispByte
	ld	a, ' '
	call	debug_PutC
	call	debug_PutC
	ld	hl, (iy + debug_CmdScBufStart)
	call	debug_DispUhl
	ld	a, ' '
	call	debug_PutC
	call	debug_PutC
	ld	hl, (iy + debug_CmdScBufEnd)
	call	debug_DispUhl
	ld	a, ' '
	call	debug_PutC
	call	debug_PutC
	ld	hl, (iy + debug_CmdScBufTop)
	call	debug_DispUhl
	ld	a, ' '
	call	debug_PutC
	call	debug_PutC
	ld	hl, (iy + debug_CmdScBufBottom)
	call	debug_DispUhl
	pop	hl
	ld	(debug_CurRow), hl
	ret



;===============================================================================
;====== Edit Buffer ============================================================
;===============================================================================

;------ EditClear --------------------------------------------------------------
debug_EditClear:
; Clears the edit buffer.
; Input:
;  - IY: Pointer to edit buffer
; Output:
;  - Documented effect(s)
; Destroys:
;  - AF, BC, DE, HL, IX
	ld	hl, (iy + debug_EditStart)
	ld	(iy + debug_EditBottom), hl
	ld	(iy + debug_EditPtr), hl
	ld	(hl), 0
	ld	hl, (iy + debug_EditStartY)
	ld	(iy + debug_EditY), hl
	ret


;------ EditShowBuffer ---------------------------------------------------------
debug_EditShowBuffer:
; Refreshes the edit buffer display.
; Input:
;  - IY: Pointer to edit buffer
; Output:
;  - Documented effect(s)
; Destroys:
;  - AF, BC, DE, HL, IX
	ld	hl, (debug_CurRow)
	push	hl
	ld	hl, (iy + debug_EditStartY)
	ld	(debug_CurRow), hl
	ld	hl, (iy + debug_EditStart)
	call	debug_PutS
	pop	hl
	ld	(debug_CurRow), hl
	ret


;------ EditBegin --------------------------------------------------------------
debug_EditBegin:
; Enters the edit buffer.  Anything in the edit buffer will be displayed
; starting at the current cursor position.  The edit cursor will be at the end
; of the text.
; Input:
;  - IY: Pointer to edit buffer
; Output:
;  - Documented effect(s)
; Destroys:
;  - AF, BC, DE, HL, IX
	ld	hl, (iy + debug_EditEnd)
	ld	(hl), 0
	ld	hl, (debug_CurRow)
	ld	(iy + debug_EditStartY), hl
	ld	hl, (iy + debug_EditStart)
	call	debug_PutS
	dec	hl
	ld	(iy + debug_EditBottom), hl
	ld	(iy + debug_EditPtr), hl
	ld	hl, (debug_CurRow)
	ld	(iy + debug_EditY), hl
	ld	a, debug_CursorInsertM | debug_CursorAlphaM | debug_CursorLwrAlphaM
	ld	(debug_CursorFlags), a
; Fall through to EditResume
;------ EditResume -------------------------------------------------------------
debug_EditResume:
; Returns to the edit buffer.  This assumes that the edit buffer is already
; displayed and that the cursor hasn't moved.
; Input:
;  - IY: Pointer to edit buffer
; Output:
;  - Documented effect(s)
; Destroys:
;  - AF, BC, DE, HL, IX
debug_editLoop:
#ifdef	NEVER
	call	debug_ShowEditBufferVars
#endif
	; Actual edit loop stuff
	ld	hl, (iy + debug_EditY)
	ld	(debug_CurRow), hl
	call	debug_GetKeyAscii
	; Was an actual character typed?
	bit	7, a
	jr	nz, debug_editLoopNonAscii
	; Check if we're in insert or overstrike mode
	ld	hl, debug_CursorFlags
	bit	debug_CursorInsert, (hl)
	jr	nz, +_
	; Overstrike
	call	debug_EditOverwriteByte
	; If the character was not put into the buffer, do not display
	jr	c, debug_editLoop
;	ld	hl, (iy + debug_EditY)
;	ld	(debug_CurRow), hl
	ld	hl, (iy + debug_EditPtr)
	ld	a, (hl)
	call	debug_PutC
	call	debug_EditCursorRight
	jr	debug_editLoop
_:	; Insert
	call	debug_EditInsertByte
;	ld	hl, (iy + debug_EditY)
;	ld	(debug_CurRow), hl
	ld	hl, (iy + debug_EditPtr)
	call	debug_PutS
	call	debug_EditCursorRight
	jr	debug_editLoop
debug_editLoopNonAscii:
	and	7Fh
	ld	hl, debug_editLoopKeyTable
	call	debug_MapJumpTable
	ret
debug_editLoopKeyTable:
	.db	(debug_editLoopKeyTableEnd - debug_editLoopKeyTable - 1) / 4
	.db	skClear
	.dl	debug_editLoopBackspace
	.db	skClear | 40h
	.dl	debug_editLoopClear
	.db	skDel
	.dl	debug_editLoopDelete
	.db	skLeft
	.dl	debug_editLoopLeft
	.db	skRight
	.dl	debug_editLoopRight
	.db	skLeft | 40h
	.dl	debug_editLoopHome
	.db	skRight | 40h
	.dl	debug_editLoopEnd
;	.db	skGraph
;	.dl	debug_editLoopRedraw
debug_editLoopKeyTableEnd:
debug_editLoopBackspace:
	call	debug_EditCursorLeft
	call	c, debug_EditDeleteByte
	ld	hl, (iy + debug_EditStartY)
	ld	(debug_CurRow), hl
	ld	hl, (iy + debug_EditStart)
	call	debug_PutS
	ld	a, ' '
	call	debug_PutC
	jp	debug_editLoop

debug_editLoopClear:
	ld	hl, (iy + debug_EditBottom)
	ld	de, (iy + debug_EditStart)
	or	a
	sbc	hl, de
	jp	z, debug_editLoop
	ld	de, (iy + debug_EditStartY)
	ld	(debug_CurRow), de
	ld	a, ' '
	or	a
	ld	de, 0
_:	call	debug_PutC
	dec	hl
	sbc	hl, de
	jr	nz, -_
	call	debug_EditClear
	jp	debug_editLoop
	
debug_editLoopDelete:
	call	debug_EditDeleteByte
	jp	nc, debug_editLoop
	ld	hl, (iy + debug_EditStartY)
	ld	(debug_CurRow), hl
	ld	hl, (iy + debug_EditStart)
	call	debug_PutS
	ld	a, ' '
	call	debug_PutC
	jp	debug_editLoop

debug_editLoopLeft:
	call	debug_EditCursorLeft
	jp	debug_editLoop

debug_editLoopRight:
	call	debug_EditCursorRight
	jp	debug_editLoop

debug_editLoopHome:
	ld	hl, (iy + debug_EditStartY)
	ld	(iy + debug_EditY), hl
	ld	hl, (iy + debug_EditStart)
	ld	(iy + debug_EditPtr), hl
	jp	debug_editLoop

debug_editLoopEnd:
	ld	hl, (iy + debug_EditStartY)
	ld	(debug_CurRow), hl
	ld	hl, (iy + debug_EditStart)
	call	debug_PutS
	dec	hl
	ld	(iy + debug_EditPtr), hl
	ld	hl, (debug_CurRow)
	ld	(iy + debug_EditY), hl
	jp	debug_editLoop

;debug_editLoopRedraw:
;	ld	hl, (iy + debug_EditStartY)
;	ld	(debug_CurRow), hl
;	ld	a, 1
;	ld	b, 128
;_:	call	debug_PutC
;	djnz	-_
;	call	debug_EditShowBuffer
;	jp	debug_editLoop


;------ EditCursorLeft ---------------------------------------------------------
debug_EditCursorLeft:
; Moves the cursor one byte to the left, if possible.
; Input:
;  - IY: Pointer to edit buffer
; Output:
;  - Documented effect(s)
;  - NC if cannot move cursor, C if did move cursor
; Destroys:
;  - AF, BC, DE, HL, IX
	; Compare write pointer to buffer start
	ld	hl, (iy + debug_EditStart)
	ld	de, (iy + debug_EditPtr)
	or	a
	sbc	hl, de
	ret	nc
	; Decrement if possible
	dec	de
	ld	(iy + debug_EditPtr), de
	; Move cursor
	ld	hl, (iy + debug_EditY)
	ld	(debug_CurRow), hl
	call	debug_CursorLeft
	ld	hl, (debug_CurRow)
	ld	(iy + debug_EditY), hl
	scf
	ret


;------ EditCursorRight --------------------------------------------------------
debug_EditCursorRight:
; Moves the cursor one byte to the right, if possible.
; Input:
;  - IY: Pointer to edit buffer
; Output:
;  - Documented effect(s)
;  - C if cannot move cursor, NC if did move cursor
; Destroys:
;  - AF, BC, DE, HL, IX
	; Compare write pointer to buffer end
	ld	hl, (iy + debug_EditBottom)
	ld	de, (iy + debug_EditPtr)
	scf
	sbc	hl, de
	ret	c
	; Increment if possible
	inc	de
	ld	(iy + debug_EditPtr), de
	; Move cursor
	ld	hl, (iy + debug_EditY)
	ld	(debug_CurRow), hl
	call	debug_CursorRight
	ld	hl, (debug_CurRow)
	ld	(iy + debug_EditY), hl
	or	a
	ret


;------ EditOverwriteByte ------------------------------------------------------
debug_EditOverwriteByte:
; Writes one byte to the current cursor location.
; If the cursor is at the end of the buffer, the byte is appended.
; If the buffer is already full, nothing happens.
; Inputs:
;  - A: Byte to write
;  - IY: Pointer to edit buffer
; Output:
;  - Documented effect(s)
;  - C if buffer is full, NC if buffer is not yet full
; Destroys:
;  - AF, BC, DE, HL, IX
	ld	de, (iy + debug_EditPtr)
	ld	hl, (iy + debug_EditBottom)
	or	a
	sbc	hl, de
	ret	c
	jr	z, debug_EditInsertByte
	ld	(de), a
	or	a
	ret


;------ EditInsertByte ---------------------------------------------------------
debug_EditInsertByte:
; Inserts one byte at the current cursor location.
; Inputs:
;  - A: Byte to write
;  - IY: Pointer to edit buffer
; Output:
;  - Documented effect(s)
;  - C if buffer is full, NC if buffer is not yet full
; Destroys:
;  - AF, BC, DE, HL
	; Increment string size
	ld	hl, (iy + debug_EditEnd)
	ld	de, (iy + debug_EditBottom)
	inc	de
	or	a
	sbc	hl, de
	ret	c
	ld	(iy + debug_EditBottom), de
	; Compute move size
	ld	hl, (iy + debug_EditBottom)
	ld	de, (iy + debug_EditPtr)
	; or	a	; NC from above
	sbc	hl, de
	push	hl
	pop	bc
	ld	de, (iy + debug_EditBottom)
	push	de
	pop	hl
	dec	hl
	; LDDR data to make room
	lddr
	; Write byte
	ld	hl, (iy + debug_EditPtr)
	ld	(hl), a
	or	a
	ret


;------ EditDeleteByte ---------------------------------------------------------
debug_EditDeleteByte:
; Deletes one byte at the current cursor location.
; Input:
;  - IY: Pointer to edit buffer
; Output:
;  - Documented effect(s)
;  - NC if buffer is empty, C if buffer is not yet empty
; Destroys:
;  - AF, BC, DE, HL
	; Check string size
	ld	hl, (iy + debug_EditStart)
	ld	de, (iy + debug_EditBottom)
	or	a
	sbc	hl, de
	ret	nc
	; Compute move size
	ld	hl, (iy + debug_EditBottom)
	ld	de, (iy + debug_EditPtr)
	or	a
	sbc	hl, de
	; Check for problems
	ret	z	; Can't move zero bytes. . . .
	ccf
	ret	nc	; Bad things will happen if you try to move negative bytes
	push	hl
	pop	bc
	; Decrement input size
	add	hl, de
	dec	hl
	ld	(iy + debug_EditBottom), hl
	; Get pointers
	push	de
	pop	hl
	inc	hl
	; LDIR data to make room
	ldir
	scf
	ret


#ifdef	NEVER
;------ ShowEditBufferVars -----------------------------------------------------
debug_ShowEditBufferVars:
; Debugging function.
; Input:
;  - IY: Pointer to edit buffer
; Output:
;  - Documented effect(s)
;  - NC if buffer is empty, C if buffer is not yet empty
; Destroys:
;  - AF, BC, DE, HL, IX
	ld	hl, (debug_CurRow)
	push	hl
	; Display edit buffer variables?
	ld	hl, 10
	ld	(debug_CurRow), hl
;	lea	ix, iy + 0
;	ld	b, 6
;_:	ld	hl, (ix)
;	call	debug_DispUhl
;	ld	a, ' '
;	call	debug_PutC
;	call	debug_PutC
;	lea	ix, ix + 3
;	djnz	-_
	
	ld	hl, (iy + 0)
	call	debug_DispUhl
	ld	a, ' '
	call	debug_PutC
	call	debug_PutC
	ld	hl, (iy + 3)
	call	debug_DispUhl
	ld	a, ' '
	call	debug_PutC
	call	debug_PutC
	ld	hl, (iy + 6)
	call	debug_DispUhl
	ld	a, ' '
	call	debug_PutC
	call	debug_PutC
	ld	hl, (iy + 9)
	call	debug_DispUhl
	ld	a, ' '
	call	debug_PutC
	call	debug_PutC
	ld	hl, (iy + 12)
	call	debug_DispUhl
	ld	a, ' '
	call	debug_PutC
	call	debug_PutC
	ld	hl, (iy + 15)
	call	debug_DispUhl
	ld	a, ' '
	call	debug_PutC
	call	debug_PutC
;	call	debug_GetKey
	pop	hl
	ld	(debug_CurRow), hl
	ret
#endif


;------ EditScrollUp -----------------------------------------------------------
debug_EditScrollUp:
; Scrolls the screen and edit buffer up one line, allowing more text to be
; entered.
; Input:
;  - IY: Pointer to edit buffer
; Output:
;  - Documented effect(s)
; Destroys:
;  - AF, BC, DE, HL, IX