; GUI 2.0 for the eZ80!
; Now that we have tons of RAM and a 24-bit linear address space, we can have
; more complicated GUIness.

;------ ------------------------------------------------------------------------
;     The GUI system requires both read-only source data, and special GUI RAM.
; GUI RAM starts with a table of pointers to each GUI object's RAM.  The table
; is statically allocated before loading, and RAM for each object is allocated
; directly after the table.
;
;     The GUI system starts with a loading and initial rendering phase.  In the
; loading phase, RAM is allocated for each object, and each object is given the
; chance to allocate additional GUI RAM, and update its variables.  The object
; should then render itself.
;
;     The loading and rendering routine returns to its caller, allowing the
; caller to perform any additional initialization.  After that, the caller
; should JUMP (not CALL) the GuiDo routine.

; Initial structure defining GUI objects
;	.db	objectId	; Identifies the object's RAM slot, 0 for render-only objects
;	.db	objectSize
;	.db	parentObjectId	; Identifies the object's parent
;	.db	objectTypeId
;	.db	flags
;	; Position
;	.dw	column
;	.db	row
;	; Size
;	.dw	width
;	.db	height
;	; Navigational data
;	.db	upObjectId
;	.db	leftObjectId
;	.db	rightObjectId
;	.db	downObjectId
;	; Custom data
;	.db	...

GuiObjId		.equ	0
GuiObjSize		.equ	GuiObjId + 1
GuiObjParentId		.equ	GuiObjSize + 1
GuiObjType		.equ	GuiObjParentId + 1
GuiObjFlags		.equ	GuiObjType + 1
GuiObjCol		.equ	GuiObjFlags + 1
GuiObjRow		.equ	GuiObjCol + 2
GuiObjWidth		.equ	GuiObjRow + 1
GuiObjHeight		.equ	GuiObjWidth + 2
GuiObjNavUpId		.equ	GuiObjHeight + 1
GuiObjNavLeftId		.equ	GuiObjNavUpId + 1
GuiObjNavRightId	.equ	GuiObjNavLeftId + 1
GuiObjNavDownId		.equ	GuiObjNavRightId + 1
GuiObjCustomData	.equ	GuiObjNavDownId + 1
GuiObjForeColor		.equ	GuiObjCustomData
GuiObjBackColor		.equ	GuiObjForeColor + 1

; RAM structure
;	.dl	initialDataPtr
;	.db	flags
;	; Position
;	.dw	column
;	.db	row
;	; Size
;	.dw	width
;	.db	height
;	; Navigational data
;	.db	upObjectId
;	.db	leftObjectId
;	.db	rightObjectId
;	.db	downObjectId
;	; Object puts whatever custom data it needs here
;	.db	...

GuiRamDataPtr		.equ	0
GuiRamFlags		.equ	GuiRamDataPtr + 1
GuiRamCol		.equ	GuiRamFlags + 1
GuiRamRow		.equ	GuiRamCol + 2
GuiRamWidth		.equ	GuiRamRow + 1
GuiRamHeight		.equ	GuiRamWidth + 2
GuiRamNavUpId		.equ	GuiRamHeight + 1
GuiRamNavLeftId		.equ	GuiRamNavUpId + 1
GuiRamNavRightId	.equ	GuiRamNavLeftId + 1
GuiRamNavDownId		.equ	GuiRamNavRightId + 1
GuiRamCustomData	.equ	GuiRamNavDownId + 1
GuiRamForeColor		.equ	GuiRamCustomData
GuiRamBackColor		.equ	GuiRamForeColor + 1

;	; Custom data for box
;	; . . . none needed.

;	; Custom data for label
;	.dw	textResourceId

;	; Custom data for graphic
;	.dw	resourceId

;	; Custom data for button
;	.dw	textResourceId
;	.dl	pressCallback

;	; Custom data for radio button
;	.dw	textResourceId
;	.dl	pressCallback
;	.db	buttonValue	; Value to write to varPtr when selected
;	.dl	varPtr		; Location to write to
;	.db	groupId		; Identifies the radio button group, to allow switching

;	; Custom data for checkbox
;	.dw	textResourceId
;	.dl	pressCallback
;	.db	buttonValue	; Value to write to varPtr when selected
;	.dl	varPtr		; Location to write to

;	; Custom data for numeric input
;	.dl	validateCallback ; Routine to call when the user is finished editing value
;	.dl	varPtr		; Location of variable being edited
;	.dl	minimumValue
;	.dl	maximumValue


;------ ------------------------------------------------------------------------

;------ GuiLoad ----------------------------------------------------------------
GuiLoad:
; Loads a new GUI context.
; Allocates memory in GUI object table.
; Computes object locations.
; Render objects.
; Input:
;  - A: Maximum number of objects allowed
;  - HL: Pointer to GUI RAM zone
;  - DE: Size of GUI RAM
;  - IY: Pointer to GUI definition table
; Outputs:
;  - Does what it says
; Destroys:
;  - Assume all
	ld	(GuiRamSize), de
	ld	(GuiRamStart), hl
	ld	bc, 0
	ld	(hl), bc
	ld	c, a
	ld	b, 3
	mlt	bc
	add	hl, bc
	ld	(GuiRamNext), hl
guiLoadLoop:
; End of object list?
	ld	a, (iy + GuiObjId)
	or	a
	jr	nz, +_
	ld	iy, flags
	ret
_:; Pointer to RAM vars
	ld	ix, (GuiRamNext)
; Write pointer to object table
	ld	e, (iy + GuiObjId)
	ld	d, 3
	mlt	de
	ld	hl, (GuiRamStart)
	add	hl, de
	ld	(hl), ix
; Initialize RAM vars
	ld	(ix + GuiRamDataPtr), iy
	ld	a, (iy + GuiObjFlags)
	ld	(ix + GuiRamFlags), a
	; Does object have parent?
	ld	a, (iy + GuiObjParentId)
	or	a
	jr	z, guiLoadNoParent
	call	GuiGetObjRamPtr
	ld	hl, (ix + GuiRamCol)
	ld	c, (ix + GuiRamRow)
	ld	ix, (GuiRamNext)
	ld	de, (iy + GuiObjCol)
	add	hl, de
	ld	(ix + GuiRamCol), hl
	ld	a, (iy + GuiObjRow)
	add	a, c
	ld	(ix + GuiRamRow), a
guiLoadNoParent:
	lea	de, ix + GuiRamWidth
	lea	hl, iy + GuiObjWidth
	ld	bc, 7
	ldir
guiLoadCallLoader:
; Fetch load routine
	ld	hl, GuiLoadRoutinesTable
	add	hl, de
	ld	hl, (hl)
	ld	de, +_
	push	de
	jp	(hl)
_:	jr	c, +_
	ld	de, (GuiRamNext)
	add	hl, de
	ld	(GuiRamNext), de
_:	or	a
	sbc	hl, hl
	ex	de, hl
	ld	e, (iy + GuiObjSize)
	add	iy, de
	jr	guiLoadLoop


;------ GuiGetObjRamPtr --------------------------------------------------------
GuiGetObjRamPtr:
; Gets a pointer to a GUI object's RAM.
; Input:
;  - A: Object ID
; Output:
;  - IX: Object pointer
; Destroys:
;  - Nothing
	push	af
	push	de
	push	hl
	ld	e, a
	ld	d, 3
	mlt	de
	ld	hl, (GuiRamStart)
	add	hl, de
	ld	ix, (hl)
	pop	hl
	pop	de
	pop	af
	ret


;------ ------------------------------------------------------------------------
GuiRenderObjects:
; Renders complete GUI.
; RAM variables may be updated.


GuiRenderObject:
; Renders a single object.
; Input:
;  - A: Object ID
; Outputs:
;  - Does what it says
;  - RAM variables may be updated
; Destroys:
;  - Assume all


GuiDo:
; GUI loop routine.  Allows user to move between fields and interact with
; objects.
; THIS IS A JUMP, NOT A CALL; DOES NOT RETURN TO CALLER
; Inputs:
;  - A: Object ID of object to start with
; Output:
;  - Does what it says
; Destroys:
;  - Does not return to caller, so . . . all?



;===============================================================================
;====== GUI Objects ============================================================
;===============================================================================
GuiObjIdEndOfObjects		.equ	0
GuiObjIdCustomObj		.equ	GuiObjIdEndOfObjects + 1
GuiObjIdIdleRoutine		.equ	GuiObjIdCustomObj + 1
GuiObjIdEmptyContainer		.equ	GuiObjIdIdleRoutine + 1
GuiObjIdText			.equ	GuiObjIdEmptyContainer + 1
GuiObjIdCenteredText		.equ	GuiObjIdText + 1
GuiObjIdRightAlignedText	.equ	GuiObjIdCenteredText + 1
GuiObjIdVertLine		.equ	GuiObjIdRightAlignedText + 1
GuiObjIdHorizLine		.equ	GuiObjIdVertLine + 1
GuiObjIdBox			.equ	GuiObjIdHorizLine + 1
GuiObjIdFilledBox		.equ	GuiObjIdBox + 1
GuiObjIdCenteredBox		.equ	GuiObjIdFilledBox + 1
GuiObjIdCenteredFilledBox	.equ	GuiObjIdCenteredBox + 1
GuiObjIdBoxedText		.equ	GuiObjIdCenteredFilledBox + 1
GuiObjIdCenteredBoxedText	.equ	GuiObjIdBoxedText + 1
GuiObjIdSprite			.equ	GuiObjIdCenteredBoxedText + 1
GuiObjIdButton			.equ	GuiObjIdSprite + 1
GuiObjIdCheckBox		.equ	GuiObjIdButton + 1
GuiObjIdRadioButton		.equ	GuiObjIdCheckBox + 1
GuiObjIdNumericUpDown		.equ	GuiObjIdRadioButton + 1
GuiObjIdSimpleTextBox		.equ	GuiObjIdNumericUpDown + 1

;------ ------------------------------------------------------------------------
GuiLoadRoutinesTable:
; A table of routines called when each object is loaded
;	.dl	objectType0Routine
;	.dl	objectType1Routine
;	.dl	objectType2Routine
;	.dl	...
; Inputs:
;  - IX: Pointer to RAM vars
;  - IY: Pointer to source data
; Outputs:
;  - HL: Total RAM used
;  - NC to keep RAM allocated
;  - C to unallocate RAM (used for display-only objects)
; Destroys:
;  - Anything
	.dl		; GuiObjIdEndOfObjects
	.dl		; GuiObjIdCustomObj
	.dl		; GuiObjIdIdleRoutine
	.dl		; GuiObjIdEmptyContainer
	.dl		; GuiObjIdText
	.dl		; GuiObjIdCenteredText
	.dl		; GuiObjIdRightAlignedText
	.dl		; GuiObjIdVertLine
	.dl		; GuiObjIdHorizLine
	.dl		; GuiObjIdBox
	.dl		; GuiObjIdFilledBox
	.dl		; GuiObjIdCenteredBox
	.dl		; GuiObjIdCenteredFilledBox
	.dl		; GuiObjIdBoxedText
	.dl		; GuiObjIdCenteredBoxedText
	.dl		; GuiObjIdSprite
	.dl		; GuiObjIdButton
	.dl		; GuiObjIdCheckBox
	.dl		; GuiObjIdRadioButton
	.dl		; GuiObjIdNumericUpDown
	.dl		; GuiObjIdSimpleTextBox


;------ ------------------------------------------------------------------------
GuiRenderRoutinesTable:
; A table of routines called to draw each object type, after loading.
; Used for GUIs that need to change what controls are displayed.
;	.dl	objectType0Routine
;	.dl	objectType1Routine
;	.dl	objectType2Routine
;	.dl	...
; Inputs:
;  - IX: Pointer to RAM vars
;  - IY: Pointer to source data
; Outputs:
;  - None
; Destroys:
;  - Anything
	.dl		; GuiObjIdEndOfObjects
	.dl		; GuiObjIdCustomObj
	.dl		; GuiObjIdIdleRoutine
	.dl		; GuiObjIdEmptyContainer
	.dl		; GuiObjIdText
	.dl		; GuiObjIdCenteredText
	.dl		; GuiObjIdRightAlignedText
	.dl		; GuiObjIdVertLine
	.dl		; GuiObjIdHorizLine
	.dl		; GuiObjIdBox
	.dl		; GuiObjIdFilledBox
	.dl		; GuiObjIdCenteredBox
	.dl		; GuiObjIdCenteredFilledBox
	.dl		; GuiObjIdBoxedText
	.dl		; GuiObjIdCenteredBoxedText
	.dl		; GuiObjIdSprite
	.dl		; GuiObjIdButton
	.dl		; GuiObjIdCheckBox
	.dl		; GuiObjIdRadioButton
	.dl		; GuiObjIdNumericUpDown
	.dl		; GuiObjIdSimpleTextBox


;------ ------------------------------------------------------------------------
GuiActionsTable:
; A table of routines called when the user wants to interact with an object
;	.dl	objectType0Routine
;	.dl	objectType1Routine
;	.dl	objectType2Routine
;	.dl	...
; THIS IS A JUMP, NOT A CALL
; To return to the GUI, load the object ID from the source data, and then jump
; to GuiDo.
; Inputs:
;  - A: Button keycode pressed
;  - IX: Pointer to RAM vars
; Outputs:
;  - Does not return; none
; Destroys:
;  - All
	.dl		; GuiObjIdEndOfObjects
	.dl		; GuiObjIdCustomObj
	.dl		; GuiObjIdIdleRoutine
	.dl		; GuiObjIdEmptyContainer
	.dl		; GuiObjIdText
	.dl		; GuiObjIdCenteredText
	.dl		; GuiObjIdRightAlignedText
	.dl		; GuiObjIdVertLine
	.dl		; GuiObjIdHorizLine
	.dl		; GuiObjIdBox
	.dl		; GuiObjIdFilledBox
	.dl		; GuiObjIdCenteredBox
	.dl		; GuiObjIdCenteredFilledBox
	.dl		; GuiObjIdBoxedText
	.dl		; GuiObjIdCenteredBoxedText
	.dl		; GuiObjIdSprite
	.dl		; GuiObjIdButton
	.dl		; GuiObjIdCheckBox
	.dl		; GuiObjIdRadioButton
	.dl		; GuiObjIdNumericUpDown
	.dl		; GuiObjIdSimpleTextBox
