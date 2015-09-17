;------ ------------------------------------------------------------------------
; Desired debugger functionality:
;  - 16 K static code & data
;     - No SMC, so could be located in flash, if we ever get flash apps
;  - 16 K RAM usage
;     - 9600 bytes VRAM
;        - Leaves 6784 bytes
;     - 680 or 720 bytes text buffer
;        - Why do I want this again?  You can easily save bitmap data to vars
;          for blinking cursor.
;        - Leaves 6064 bytes
;     - 512 bytes stack
;        - Leaves 5552 bytes
;     - 512 bytes reserved for static vars
;        - Leaves 5040 bytes
;     - 2 x 256 bytes command history buffers
;        - Leaves 4528 bytes
;     - 2 x 2048 bytes command output scroll buffer
;        - Leaves 432 bytes
;     - 2 x 128 bytes command edit buffer
;        - Leaves 176 bytes
;  - Command-line based interface for speedy usage (once you've learned the
;    commands, anyway)
;  - Output scroll buffer
;  - Two interactive windows, for fast toggling to compare things
;  - Need:
;     - debug_cmd.asm
;        - Section Windows
;           - Provides for global functions like exit and toggle active window
;        - Section Scroll Buffer
;           - Provides support for scrolling up and down
;        - Section Edit Buffer
;           - Provides the interactive edit buffer for commands
;        - Section Command Parser
;           - Provides command parsing and infrastructure for help and
;             completion
;     - debug_commands.asm
;        - 



;------ ------------------------------------------------------------------------
debug_Vram			.equ	DEBUG_RAM
debug_VramSize			.equ	320 * 240 / 8
debug_TextBuffer		.equ	debug_Vram + debug_VramSize
debug_Rows			.equ	17
debug_Cols			.equ	40
debug_CurRow			.equ	debug_textBuffer + (debug_Cols * debug_Rows)
debug_CurCol			.equ	debug_CorRow + 1
debug_LcdPrevConfig		.equ	debug_CurCol + 2
debug_LcdSettingsSize		.equ	32
debug_LcdPrevPalette		.equ	debug_LcdPrevConfig + debug_LcdSettingsSize
debug_LastKey			.equ	debug_LcdPrevPalette + 5
debug_KeyReleaseCounter		.equ	debug_LastKey + 1
debug_KeyboardPrevConfig	.equ	debug_KeyReleaseCounter + 1

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