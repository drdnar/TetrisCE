

;------ ------------------------------------------------------------------------
debug_textInverse		.equ	0
debug_textInverseM		.equ	1
debug_textHeight		.equ	14
debug_screenWidth		.equ	320
debug_screenHeight		.equ	240
debug_Rows			.equ	17
debug_Cols			.equ	40
debug_StackSize			.equ	512
debug_RegistersSize		.equ	32
debug_RegistersCount		.equ	10
debug_EditBufferSize		.equ	128
debug_HistoryBufferSize		.equ	256
debug_OutputBufferSize		.equ	2048
debug_BpListSize		.equ	512
debug_MaxBp			.equ	32

debug_chNewLine			.equ	01h

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
debug_textFlags			.equ	debug_CurCol + 2
debug_LcdPrevConfig		.equ	debug_textFlags + 1
debug_LcdSettingsSize		.equ	32
debug_LcdPrevPalette		.equ	debug_LcdPrevConfig + debug_LcdSettingsSize
debug_LastKey			.equ	debug_LcdPrevPalette + 5
debug_KeyReleaseCounter		.equ	debug_LastKey + 1
debug_KeyboardPrevConfig	.equ	debug_KeyReleaseCounter + 1
debug_KeyboardConfigSize	.equ	13

debug_EndOfStaticVars		.equ	debug_KeyboardPrevConfig + debug_KeyboardConfigSize

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