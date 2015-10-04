;------ ------------------------------------------------------------------------
; Desired debugger functionality:
;  - 16 K static code & data
;     - No SMC, so could be located in flash, if we ever get flash apps
;  - 16 K RAM usage
;     - 9600 bytes VRAM
;       Leaves 6784 bytes
;     - 512 bytes stack
;       Leaves 6272 bytes
;     - 512 bytes reserved for static vars
;       Leaves 5760 bytes
;     - 2 x 256 bytes command history buffers
;       Leaves 5248 bytes
;     - 2 x 2048 bytes command output scroll buffer
;       Leaves 1152 bytes
;     - 2 x 128 bytes command edit buffer
;       Leaves 896 bytes
;     - 512 bytes for breakpoints list (54 entries)
;       Leaves 384 bytes
;  - Command-line based interface for speedy usage (once you've learned the
;    commands, anyway)
;  - Output scroll buffer
;  - Two interactive windows, for fast toggling to compare things
;  - Need:
;     - debug/equates.asm
;       Provides . . . equates.
;        - RAM locations
;        - Debugger's custom character codes
;     - debug/drivers.asm
;        - Section Keyboard
;          Provides keyboard driver if host does not provide keyboard driver,
;          or if host requires debugger to disable interrupts
;        - Section LCD
;          Provides B&W text-mode LCD ddriver
;     - debug/cmd.asm
;        - Section Windows
;          Provides for global functions like exit and toggle active window
;        - Section Scroll Buffer
;          Provides support for scrolling up and down
;        - Section Edit Buffer
;          Provides the interactive edit buffer for commands
;        - Section Command Parser
;          Provides command parsing and infrastructure for help and
;          completion
;     - debug/debugger.asm
;        - Section Breakpoints
;          Provides breakpoint management:
;           - Write breakpoints into program code
;           - Restore program code after breakpoint
;           - Add and remove breakpoints
;        - Section Intruction Information
;          Provides information on the size and type of instructions
;          Used by the breakpoints system and single-stepper to prevent issues
;          breaking after branches
;        - Section Symbols
;          Provides the built-in symbol list
;        - Section Single Step
;          Provides the functionality for single-stepping
;        - Section Commands
;          Provides command-line functions
;        - Section Interactive Single Stepping
;          Provides the interactive single-stepper
;     - debug/hexeditor.asm
;        - Section Commands
;          Provides command-line functions
;        - Section Interactive Hex Editor
;          Provides the interactive hex editor
;     - debug/disassembler.asm
;        - Section Interactive UI
;          Provides the disassembler's UI
;        - Section Disassmbler
;          Provides the actual disassembly routines
;     - debug/disassembler_data.asm
;          Provides data used by the disassembler
;     - debug/hardware.asm
;        - Section LCD
;          Provides LCD driver status information
;        - Section Keyboard
;          Provides keyboard driver information
;        - Section Interrupts
;          Provides information on master interrupt mask
;        - Section RTC
;          Just shows and sets the timer
;        - Section Timers
;          Provides information on the timers
;        - Section Backlight
;          Provides LCD backlight status
;        - Section USB
;          Provide MAGIC
;        - Section LED
;          Shows the testing LED status.  Useless.
;     - debug/os.asm
;        - Section Flags
;          Provides OS flags list
;        - Section VAT
;          Provides the Amazing VAT Walker!
;        - Section Apps
;          Provides app list


;------ ------------------------------------------------------------------------
debug_textInverse		.equ	0
debug_textInverseM		.equ	1
debug_textHeight		.equ	14
debug_screenWidth		.equ	320
debug_screenHeight		.equ	240

debug_chNewLine			.equ	01h

debug_Vram			.equ	DEBUG_RAM
debug_VramSize			.equ	(320 * 240) / 8
debug_TextBuffer		.equ	debug_Vram + debug_VramSize
debug_Rows			.equ	17
debug_Cols			.equ	40
debug_CurRow			.equ	debug_textBuffer + (debug_Cols * debug_Rows)
debug_CurCol			.equ	debug_CurRow + 1
debug_textFlags			.equ	debug_CurCol + 2
debug_LcdPrevConfig		.equ	debug_textFlags + 1
debug_LcdSettingsSize		.equ	32
debug_LcdPrevPalette		.equ	debug_LcdPrevConfig + debug_LcdSettingsSize
debug_LastKey			.equ	debug_LcdPrevPalette + 5
debug_KeyReleaseCounter		.equ	debug_LastKey + 1
debug_KeyboardPrevConfig	.equ	debug_KeyReleaseCounter + 1
debug_KeyboardConfigSize	.equ	13

DEBUG_RAM_END			.equ	debug_KeyboardPrevConfig + debug_KeyboardConfigSize

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