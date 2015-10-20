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
	.dl	debug_EditBuffer1	; debug_EditStart
	.dl	debug_EditBuffer1 + debug_EditBufferSize - 1	; debug_EditEnd
	.dl	debug_EditBuffer1	; debug_EditPtr
	.dl	debug_EditBuffer1	; debug_EditBottom
	.dl	0	; debug_EditStartY, debug_EditStartX
	.dl	0	; debug_EditY, debug_EditX
	.db	0	; debug_CmdFlags
	.dl	debug_OutputBuffer1	; debug_CmdOutBufStart
	.dl	debug_OutputBuffer1 + debug_OutputBufferSize	; debug_CmdOutBufEnd
	.dl	debug_OutputBuffer1	; debug_CmdOutBufTop
	.dl	debug_OutputBuffer1	; debug_CmdOutBufBottom
	.dl	debug_HistoryBuffer1	; debug_CmdHistStart
	.dl	debug_HistoryBuffer1 + debug_HistoryBufferSize	; debug_CmdHistEnd
	.dl	debug_HistoryBuffer1	; debug_CmdHistTop
	.dl	debug_HistoryBuffer1	; debug_CmdHistBottom


;------ ------------------------------------------------------------------------
debug_CmdStart:
; Reset stack
	ld	sp, debug_Stack + debug_StackSize + 1
; TODO: Redraw output buffer
	call	debug_ClearLcd
	call	debug_HomeUp
	
; Display command prompt
	ld	hl, debug_prompt
	call	debug_PutS
	
	ld	iy, debug_Cmd0
	call	debug_EditClear
	call	debug_EditBegin
	cp	skMode | 40h
	call	nz, debug_Exit
	
	jr	debug_CmdStart


_:	call	debug_GetKeyAscii
	bit	7, a
	jr	nz, +_
	call	debug_PutC
	jr	-_
_:	cp	skClear | 80h
	jr	nz, debug_CmdStart
	call	debug_Exit
	jr	debug_CmdStart

debug_prompt:
	.db	"> ", 0



;===============================================================================
;====== Scroll Buffer ==========================================================
;===============================================================================
debug_CmdScrollBufferInitialize:

	ret


;------ PrintStr ---------------------------------------------------------------
debug_PrintStr:
	call	debug_PutS
	ret


;===============================================================================
;====== Edit Buffer ===========================================================++=
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


	
	
debug_ShowEditBufferVars:
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
	ld	hl, (debug_CurRow)
	ld	(iy + debug_EditStartY), hl
	ld	hl, (iy + debug_EditStart)
	call	debug_PutS
	dec	hl
	; TODO: Check that this is a legal end-of-string position
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
	
	call	debug_ShowEditBufferVars
	
	
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
	ld	hl, (iy + debug_EditPtr)
	push	hl
	ld	hl, (iy + debug_EditY)
	push	hl
	call	debug_EditOverwriteByte
	pop	hl
	ld	(debug_CurRow), hl
	pop	hl
	; If the character was not put into the buffer, do not display
	jr	c, debug_editLoop
	ld	a, (hl)
	call	PutC
	jr	debug_editLoop
_:	; Insert
	ld	hl, (iy + debug_EditPtr)
	push	hl
	ld	hl, (iy + debug_EditY)
	push	hl
	call	debug_EditInsertByte
	pop	hl
	ld	(debug_CurRow), hl
	pop	hl
	call	debug_PutS
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
	.db	skGraph
	.dl	debug_editLoopRedraw
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

debug_editLoopRedraw:
	ld	hl, (iy + debug_EditStartY)
	ld	(debug_CurRow), hl
	ld	a, 1
	ld	b, 128
_:	call	debug_PutC
	djnz	-_
	call	debug_EditShowBuffer
	jp	debug_editLoop


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
; Writes one byte to the current cursor location.  The cursor is advanced.
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
	call	debug_EditCursorRight
	or	a
	ret


;------ EditInsertByte ---------------------------------------------------------
debug_EditInsertByte:
; Inserts one byte at the current cursor location.  The cursor is advanced.
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
	call	debug_EditCursorRight
	or	a
	ret


;------ EditDeleteByte ---------------------------------------------------------
debug_EditDeleteByte:
; Deletes one byte at the current cursor location.  The cursor does not move.
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