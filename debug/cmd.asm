;===============================================================================
;====== ========================================================================
;===============================================================================
debug_CmdInitialize:
; Reset windows
; Reset edit buffers
; Reset command history buffers
; Reset command output buffers
	call	debug_CmdScrollBufferInitialize
	ret


debug_CmdStart:
	
	ld	sp, debug_Stack + debug_StackSize + 1



;===============================================================================
;====== Scroll Buffer ==========================================================
;===============================================================================
debug_CmdScrollBufferInitialize:

	ret

;===============================================================================
;====== Edit Buffer ============================================================
;===============================================================================