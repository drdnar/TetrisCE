

;------ ------------------------------------------------------------------------
debug_chNewLine			.equ	01h
; Text flags
debug_TextInverse		.equ	0
debug_TextInverseM		.equ	1
; Stuff, again
debug_textHeight		.equ	14
debug_screenWidth		.equ	320
debug_screenHeight		.equ	240
debug_Rows			.equ	17
debug_Cols			.equ	40
debug_CursorTime		.equ	1000h
debug_StackSize			.equ	512
debug_RegistersSize		.equ	32
debug_RegistersCount		.equ	10
debug_EditBufferSize		.equ	128
debug_HistoryBufferSize		.equ	256
debug_OutputBufferSize		.equ	2048
debug_BpListSize		.equ	512
debug_MaxBp			.equ	32
; Debug edit buffer struct
debug_EditStart			.equ	0
debug_EditEnd			.equ	debug_EditStart + 3
debug_EditPtr			.equ	debug_EditEnd + 3
debug_EditBottom		.equ	debug_EditPtr + 3
debug_EditY			.equ	EditBottom + 3
debug_EditX			.equ	debug_EditY + 1
debug_EditSize			.equ	debug_EditX + 2
; Cursor flags
debug_Cursor2nd			.equ	0
debug_Cursor2ndM		.equ	01h
debug_CursorInsert		.equ	1
debug_CursorInsertM		.equ	02h
debug_CursorAlpha		.equ	2
debug_CursorAlphaM		.equ	04h
debug_CursorLwrAlpha		.equ	3
debug_CursorLwrAlphaM		.equ	08h
debug_CursorOther		.equ	4
debug_CursorOtherM		.equ	10h
debug_CursorFull		.equ	1 + debug_CursorOtherM
debug_CursorBox			.equ	2 + debug_CursorOtherM
debug_CursorLine		.equ	3 + debug_CursorOtherM
debug_CursorActive		.equ	7
debug_CursorActiveM		.equ	80h
; Since every command window also has an edit buffer, why not combine the two structs?
; Debug Command struct
debug_CmdFlags			.equ	debug_EditSize
; Start = Byte 0 of buffer; End = last byte of buffer plus 1.
; Top = Ptr to first byte to read first entry from.
; Bottom = Ptr to where to write next entry to.
; The print and history buffers are circular.
debug_CmdOutBufStart		.equ	debug_CmdFlags + 1
debug_CmdOutBufEnd		.equ	debug_CmdOutBufStart + 3
debug_CmdOutBufTop		.equ	debug_CmdOutBufEnd + 3
debug_CmdOutBufBottom		.equ	debug_CmdOutBufTop + 3
debug_CmdHistStart		.equ	debug_CmdOutBufBottom + 3
debug_CmdHistEnd		.equ	debug_CmdHistStart + 3
debug_CmdHistTop		.equ	debug_CmdHistEnd + 3
debug_CmdHistBottom		.equ	debug_CmdHistTop + 3
debug_CmdSize			.equ	debug_CmdHistBottom + 3

; For some reason, this must be a multiple of 8.

debug_Vram			.equ	DEBUG_RAM + (8 - (DEBUG_RAM & 7))

debug_VramSize			.equ	(320 * 240) / 8
debug_Stack			.equ	debug_Vram + debug_VramSize
debug_StaticVars		.equ	debug_Stack + debug_StackSize
debug_PreviousRegisters		.equ	debug_StaticVars
debug_Registers			.equ	debug_PreviousRegisters + 32
debug_PreviousSp		.equ	debug_Registers + 32
debug_Sp			.equ	debug_PreviousSp + 3
debug_Ief2			.equ	debug_Sp + 3
debug_Lock			.equ	debug_Ief2 + 1
debug_CurRow			.equ	debug_Lock + 1
debug_CurCol			.equ	debug_CurRow + 1
debug_TextFlags			.equ	debug_CurCol + 2
debug_LcdPrevConfig		.equ	debug_TextFlags + 1
debug_LcdSettingsSize		.equ	32
debug_LcdPrevPalette		.equ	debug_LcdPrevConfig + debug_LcdSettingsSize
debug_LastKey			.equ	debug_LcdPrevPalette + 5
debug_KeyReleaseCounter		.equ	debug_LastKey + 1
debug_KeyboardPrevConfig	.equ	debug_KeyReleaseCounter + 1
debug_KeyboardConfigSize	.equ	13
debug_CursorFlags		.equ	debug_KeyboardPrevConfig + debug_KeyboardConfigSize
debug_CursorBitmapSave		.equ	debug_CursorFlags + 1
debug_CursorTimer		.equ	debug_CursorBitmapSave + 15
debug_CmdActive			.equ	debug_CursorTimer + 3
debug_Cmd0			.equ	debug_CmdActive + 1
debug_Cmd1			.equ	debug_Cmd0 + debug_CmdSize

debug_EndOfStaticVars		.equ	debug_Cmd1 + debug_CmdSize

.echo	"Size of debug static vars: ", debug_EndOfStaticVars - debug_StaticVars, " bytes"

;debug_TextBuffer		.equ	debug_EndOfStaticVars
;debug_EditBuffer1		.equ	debug_textBuffer + (debug_Cols * debug_Rows)
debug_EditBuffer1		.equ	debug_EndOfStaticVars
debug_EditBuffer2		.equ	debug_EditBuffer1 + debug_EditBufferSize
debug_OutputBuffer1		.equ	debug_EditBuffer2 + debug_EditBufferSize
debug_OutputBuffer2		.equ	debug_OutputBuffer1 + debug_OutputBufferSize
debug_HistoryBuffer1		.equ	debug_OutputBuffer2 + debug_OutputBufferSize
debug_HistoryBuffer2		.equ	debug_HistoryBuffer1 + debug_HistoryBufferSize
debug_BpList			.equ	debug_HistoryBuffer2 + debug_HistoryBufferSize

DEBUG_RAM_END			.equ	debug_BpList + debug_BpListSize

.echo	"Debug RAM free: ", 16384 - (DEBUG_RAM_END - DEBUG_RAM), " bytes"

; I think I'll have to rewrite my disassembler.
; Will need:
;  - Default mode, 16/24-bit
;  - Instruction mode prefix flags
;  - Possibly need larger output buffer
;  - Can remove BCALL support
; New eZ80 instructions
;  - 40 SIS
;  - 49 LIS
;  - 52 SIL
;  - 5B LIL
;  - ED00 IN0 B, (n)
;  - ED01 OUT0 (n), B
;  - ED02 LEA BC, IX + d
;  - ED03 LEA BC, IY + d
;  - ED04 TST A, B
;  - ED07 LD BC, (HL)
;  - ED08 IN0 C, (n)
;  - ED09 OUT0 (n), C
;  - ED0C TST A, C
;  - ED0F LD (HL), BC