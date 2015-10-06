; ISDB
; The In-System Debugger
; 
; Usage notes:
;  - ISDB assumes exclusive long-mode.  Some additional code is needed for
;    mixed-mode support.  Don't forget to save SPS.
; 
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
;        - Includes previous hardware state and CPU state for thread switching
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
;     - debug/debug.asm
;       This is sort of the main debugger file.
;        - Provides thread switching
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

;===============================================================================
;====== ========================================================================
;===============================================================================

debug_Dummy:
; Do-nothing dummy function.
	ld	a, '!'
	call	debug_PutC
	call	debug_GetKey
	cp	skClear
	call	z, debug_Exit
	jr	debug_Dummy


;====== Initialize =============================================================
debug_Initialize:
; Call this once at the start of the program to initialize the debugger.
; Otherwise, you'll crash when you attempt to enter it.
; Inputs:
;  - None
; Outputs:
;  - None
; Destroys:
;  - AF
;  - BC
;  - DE
;  - HL
	ld	a, 255
	ld	(debug_Lock), a
	ld	(debug_PreviousSp), sp
	call	debug_ClearLcd
	call	debug_HomeUp
	; This is pretty much safe because the stack is (should be) empty anyway.
	ld	sp, debug_Stack + debug_StackSize + 1 - 10
	ld	hl, debug_Dummy
	push	hl
	ld	(debug_Sp), sp
	ld	sp, (debug_PreviousSp)
	ret


;====== Enter ==================================================================
debug_Enter:
; Basically, this performs a thread switch and futzes with some hardware.
; State saved/restored:
;  - SP
;  - IEF2
;  - AFBCDEHLIXIY and shadows
; Inputs:
;  - Oh, please.
; Outputs:
;  - You're executing on a different thread. That's the "output" you're getting.
; Destroys:
;  - Everything, and nothing; it's a thread switch.
	ld	(debug_PreviousSp), sp
; First, deal with interrupts.  DI is required because of the PUSHes.
	push	af
	ld	a, i
	di
	ld	a, 0
	jp	po, debug_Enter_di
	inc	a
debug_Enter_di:
	ld	(debug_Ief2), a
; You can't enter the debugger while it's already active, so check for that.
	ld	a, (debug_Lock)
	inc	a
	call	nz, DEBUG_PANIC
	ld	(debug_Lock), a
	pop	af
; Now save registers.
	ld	sp, debug_PreviousRegisters + debug_RegistersSize + 1
	push	af
	push	bc
	push	de
	push	hl
	ex	af, af'
	exx
	push	af
	push	bc
	push	de
	push	hl
	push	ix
	push	iy
	; ISDB doesn't mess with I, MBASE, or SPS.
	; If you need code that futzes with R, well, put it in DEBUG_ENTER_FUNCTION.
	; You'll want to save SPS or other registers here, if need be.
	; Don't forget to do the reverse in debug_Exit.
; Before we switch the CPU state back, we need to change the hardware state.
; We do this before restoring registers so there's no need to worry about
; saving registers.
	ld	sp, (debug_Sp)
#ifdef	DEBUG_ENTER_FUNCTION
	call	DEBUG_ENTER_FUNCTION
#endif
	call	debug_InitializeKeyboard
	call	debug_InitializeLcd
; Now we can restore the register state.
	di	; Just in case. . . .
	ld	sp, debug_Registers + debug_RegistersSize + 1 - (3 * debug_RegistersCount)
	pop	iy
	pop	ix
	pop	hl
	pop	de
	pop	bc
	pop	af
	exx
	ex	af, af'
	pop	hl
	pop	de
	pop	bc
	pop	af
	ld	sp, (debug_Sp)
; Finally, deal with interrupts.
#ifdef	DEBUG_MUST_EI
	ei
	ret
#else
	push	af
	ld	a, (debug_Ief2)
	or	a
	jr	z, debug_Enter_di2
	pop	af
	ei
	ret
debug_Enter_di2:
	pop	af
	ret
#endif


;====== Exit ===================================================================
debug_Exit:
; Basically, this performs a thread switch and futzes with some hardware.
; BUT it does the reverse of debug_Enter.  So there's that.
; Inputs:
;  - Oh, please.
; Outputs:
;  - You're executing on a different thread. That's the "output" you're getting.
; Destroys:
;  - Everything, and nothing; it's a thread switch.
	di
	ld	(debug_Sp), sp
	ld	sp, debug_Registers + debug_RegistersSize + 1 - (3 * debug_RegistersCount)
	push	af
	push	bc
	push	de
	push	hl
	ex	af, af'
	exx
	push	af
	push	bc
	push	de
	push	hl
	push	ix
	push	iy
	ld	sp, (debug_Sp)
	call	debug_RestoreKeyboard
	call	debug_RestoreLcd
#ifdef	DEBUG_EXIT_FUNCTION
	call	DEBUG_EXIT_FUNCTION
#endif
	ld	sp, debug_PreviousRegisters + debug_RegistersSize + 1
	pop	iy
	pop	ix
	pop	hl
	pop	de
	pop	bc
	pop	af
	exx
	ex	af, af'
	pop	hl
	pop	de
	pop	bc
	pop	af
	ld	sp, (debug_PreviousSp)
	push	af
	ld	a, (debug_Lock)
	dec	a
	ld	(debug_Lock), a
	ld	a, (debug_Ief2)
	or	a
	jr	z, debug_Exit_di
	pop	af
	ei
	ret
debug_Exit_di:
	pop	af
	ret

