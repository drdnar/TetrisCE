debug_Vram			.equ	DEBUG_RAM
debug_VramSize			.equ	320 * 240 / 8
debug_TextBuffer		.equ	debug_Vram + debug_VramSize
debug_CurRow			.equ	debug_textBuffer + (40 * 18)
debug_CurCol			.equ	debug_CorRow + 1
debug_LcdPrevConfig		.equ	debug_CurCol + 2
debug_LcdSettingsSize		.equ	32
debug_LcdPrevPalette		.equ	debug_LcdPrevConfig + debug_LcdSettingsSize
debug_LastKey			.equ	debug_LcdPrevPalette + 5
debug_KeyReleaseCounter		.equ	debug_LastKey + 1
debug_KeyboardPrevConfig	.equ	debug_KeyReleaseCounter + 1