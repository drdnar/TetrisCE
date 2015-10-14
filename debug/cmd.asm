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
	.dl	debug_EditBuffer1 + debug_EditBufferSize	; debug_EditEnd
	.dl	debug_EditBuffer1	; debug_EditPtr
	.dl	0	; debug_EditLen
	.dl	0	; debug_EditX, debug_EditY
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
	call	debug_GetKeyShifts
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
	ld	(hl), 0
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
	ld	hl, (debug_EditStart)
	call	debug_PutS
	dec	hl
	ld	(debug_EditPtr), hl
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
	call	debug_GetKeyBlinky
	; Check alpha and 2nd keys
	ret


;------ EditCursorLeft ---------------------------------------------------------
debug_EditCursorLeft:
; Moves the cursor one byte to the left, if possible.
; Input:
;  - IY: Pointer to edit buffer
; Output:
;  - Documented effect(s)
; Destroys:
;  - AF, BC, DE, HL, IX


;------ EditCursorRight --------------------------------------------------------
debug_EditCursorRight:
; Moves the cursor one byte to the right, if possible.
; Input:
;  - IY: Pointer to edit buffer
; Output:
;  - Documented effect(s)
; Destroys:
;  - AF, BC, DE, HL, IX


;------ EditOverwriteByte ------------------------------------------------------
debug_EditOverwriteByte:
; Writes one byte to the current cursor location.  The cursor is advanced.
; Input:
;  - IY: Pointer to edit buffer
; Output:
;  - Documented effect(s)
; Destroys:
;  - AF, BC, DE, HL, IX


;------ EditInsertByte ---------------------------------------------------------
debug_EditInsertByte:
; Inserts one byte at the current cursor location.  The cursor is advanced.
; Input:
;  - IY: Pointer to edit buffer
; Output:
;  - Documented effect(s)
; Destroys:
;  - AF, BC, DE, HL, IX


;------ EditDeleteByte ---------------------------------------------------------
debug_EditDeleteByte:
; Deletes one byte at the current cursor location.  The cursor does not move.
; Input:
;  - IY: Pointer to edit buffer
; Output:
;  - Documented effect(s)
; Destroys:
;  - AF, BC, DE, HL, IX


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


;------ EditGetCursorTop -------------------------------------------------------
debug_EditGetCursorTop:
; Returns the top-left position of the edit buffer.
; Input:
;  - IY: Pointer to edit buffer
; Output:
;  - Documented effect(s)
; Destroys:
;  - AF, BC, DE, HL, IX
