;===============================================================================
;====== GUI Objects ============================================================
;===============================================================================
; ID 0 reserved
GuiObjIdCustomObj		.equ	1
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
	.dl	0	; 
	.dl	GuiObjCustomObjLoad	; GuiObjIdCustomObj
	.dl	GuiObjIdleRoutineLoad	; GuiObjIdIdleRoutine
	.dl	GuiObjEmptyContainerLoad	; GuiObjIdEmptyContainer
	.dl	GuiObjTextLoad	; GuiObjIdText
	.dl	GuiObjCTextLoad	; GuiObjIdCenteredText
	.dl	GuiObjRTextLoad	; GuiObjIdRightAlignedText
	.dl	0	; GuiObjIdVertLine
	.dl	0	; GuiObjIdHorizLine
	.dl	0	; GuiObjIdBox
	.dl	0	; GuiObjIdFilledBox
	.dl	0	; GuiObjIdCenteredBox
	.dl	0	; GuiObjIdCenteredFilledBox
	.dl	0	; GuiObjIdBoxedText
	.dl	0	; GuiObjIdCenteredBoxedText
	.dl	0	; GuiObjIdSprite
	.dl	0	; GuiObjIdButton
	.dl	0	; GuiObjIdCheckBox
	.dl	0	; GuiObjIdRadioButton
	.dl	0	; GuiObjIdNumericUpDown
	.dl	0	; GuiObjIdSimpleTextBox


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
	.dl	0	; 
	.dl	GuiObjCustomObjRender	; GuiObjIdCustomObj
	.dl	0	; GuiObjIdIdleRoutine
	.dl	0	; GuiObjIdEmptyContainer
	.dl	GuiObjTextRender	; GuiObjIdText
	.dl	GuiObjCTextLoad	; GuiObjIdCenteredText
	.dl	GuiObjRTextLoad	; GuiObjIdRightAlignedText
	.dl	0	; GuiObjIdVertLine
	.dl	0	; GuiObjIdHorizLine
	.dl	0	; GuiObjIdBox
	.dl	0	; GuiObjIdFilledBox
	.dl	0	; GuiObjIdCenteredBox
	.dl	0	; GuiObjIdCenteredFilledBox
	.dl	0	; GuiObjIdBoxedText
	.dl	0	; GuiObjIdCenteredBoxedText
	.dl	0	; GuiObjIdSprite
	.dl	0	; GuiObjIdButton
	.dl	0	; GuiObjIdCheckBox
	.dl	0	; GuiObjIdRadioButton
	.dl	0	; GuiObjIdNumericUpDown
	.dl	0	; GuiObjIdSimpleTextBox


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
	.dl	0	; 
	.dl	GuiObjCustomObjAction	; GuiObjIdCustomObj
	.dl	0	; GuiObjIdIdleRoutine
	.dl	0	; GuiObjIdEmptyContainer
	.dl	0	; GuiObjIdText
	.dl	0	; GuiObjIdCenteredText
	.dl	0	; GuiObjIdRightAlignedText
	.dl	0	; GuiObjIdVertLine
	.dl	0	; GuiObjIdHorizLine
	.dl	0	; GuiObjIdBox
	.dl	0	; GuiObjIdFilledBox
	.dl	0	; GuiObjIdCenteredBox
	.dl	0	; GuiObjIdCenteredFilledBox
	.dl	0	; GuiObjIdBoxedText
	.dl	0	; GuiObjIdCenteredBoxedText
	.dl	0	; GuiObjIdSprite
	.dl	0	; GuiObjIdButton
	.dl	0	; GuiObjIdCheckBox
	.dl	0	; GuiObjIdRadioButton
	.dl	0	; GuiObjIdNumericUpDown
	.dl	0	; GuiObjIdSimpleTextBox


;====== Custom Object ==========================================================
; Allows for one-off objects.
GuiObjCustomLoadRoutine	.equ	GuiObjCustomData
GuiObjCustomRenderRoutine	.equ	GuiObjCustomLoadRoutine + 3
GuiObjCustomActionRoutine	.equ	GuiObjCustomRenderRoutine + 3
GuiObjCustomSize	.equ	GuiObjCustomActionRoutine + 3

;------ ------------------------------------------------------------------------
GuiObjCustomObjLoad:
	ld	hl, (iy + GuiObjCustomLoadRoutine)
	scf
	jp	CallHL


;------ ------------------------------------------------------------------------
GuiObjCustomObjRender:
	ld	hl, (iy + GuiObjCustomRenderRoutine)
	jp	CallHL


;------ ------------------------------------------------------------------------
GuiObjCustomObjAction:
	ld	hl, (iy + GuiObjCustomActionRoutine)
	jp	CallHL


;====== Idle Routine Object ====================================================
; This is not a real object, but instead just sets up a pointer to a routine
; called while the GUI is idle.
;
; This takes the format:
;	.db	0
;	.db	GuiObjIdleRoutineSize
;	.db	0
;	.db	GuiObjIdIdleRoutine
;	.db	0
;	.dl	idleRoutineForGui
GuiObjIdleRoutineSize	.equ	GuiObjCol + 3

;------ ------------------------------------------------------------------------
GuiObjIdleRoutineLoad:
	ld	de, (iy + GuiObjCol)
	ld	hl, (GuiRamStart)
	ld	(hl), de
	scf
	ret


;====== Empty Container ========================================================
; A do-nothing container.  Simply used to allow relative positioning of other
; objects.  Allocates only enough RAM for its position and size.

;------ ------------------------------------------------------------------------
GuiObjEmptyContainerLoad:
	ld	hl, GuiRamNavUpId
	or	a
	ret


;====== Simple Text Object =====================================================
; Displays text.
GuiObjTextColors	.equ	GuiObjNavUpId
GuiObjTextRsrcId	.equ	GuiObjTextColors + 1
GuiObjTextSize	.equ	GuiObjTextRsrcId + 2
GuiRamTextColors	.equ	GuiRamNavIdUp
GuiRamTextRsrcId	.equ	GuiRamTextColors + 1
GuiRamTextSize	.equ	GuiRamTextRsrcId + 2

;------ ------------------------------------------------------------------------
GuiObjTextLoad:
GuiObjTextRender:
	ld	a, (fontHeight)
	or	a
	jr	nz, +_
	ld	(ix + GuiRamHeight), a
_:	ld	hl, (ix + GuiRamCol)
	inc	hl
	dec.sis	hl
	ld	(lcdCol), hl
	ld	a, (ix + GuiRamRow)
	ld	(lcdRow), a
	ld	a, (ix + GuiRamTextColors)
	call	SetColors
	ld	hl, (ix + GuiRamTextRsrcId)
	call	GetResource
	push	hl
	call	GetStrWidth
	ld	(ix + GuiRamWidth), hl
	pop	hl
	call	PutS
	ld	hl, GuiRamTextSize
	or	a
	ret


;====== Centered Text Object ===================================================
GuiObjCTextSize	.equ	GuiObjTextSize
GuiRamCTextSize	.equ	GuiRamTextSize

GuiObjCTextLoad:
GuiObjCTextRender:
	ld	a, (fontHeight)
	or	a
	jr	nz, +_
	ld	(ix + GuiRamHeight), a
_:	ld	a, (ix + GuiRamRow)
	ld	(lcdRow), a
	ld	a, (ix + GuiRamTextColors)
	call	SetColors
	ld	hl, (ix + GuiRamTextRsrcId)
	call	GetResource
	ld	de, (ix + GuiRamCol)
	call	PutSCentered
	ld	(ix + GuiRamWidth), c
	ld	(ix + GuiRamWidth + 1), b
	ld	(ix + GuiRamCol), e
	ld	(ix + GuiRamCol + 1), d
	ld	hl, GuiRamTextSize
	or	a
	ret


;====== Right-Alighed Text Object ==============================================
GuiObjRTextSize	.equ	GuiObjTextSize
GuiRamRextSize	.equ	GuiRamTextSize

GuiObjRTextLoad:
GuiObjRTextRender:
	ld	a, (fontHeight)
	or	a
	jr	nz, +_
	ld	(ix + GuiRamHeight), a
_:	ld	a, (ix + GuiRamRow)
	ld	(lcdRow), a
	ld	a, (ix + GuiRamTextColors)
	call	SetColors
	ld	hl, (ix + GuiRamTextRsrcId)
	call	GetResource
	push	hl
	call	GetStrWidth
	ld	(ix + GuiRamWidth), l
	ld	(ix + GuiRamWidth + 1), h
	ld	de, (ix + GuiRamCol)
	ex	de, hl
	or	a
	sbc.sis	hl, de
	ld	(lcdCol), hl
	pop	hl
	call	PutS
	ld	hl, GuiRamTextSize
	or	a
	ret
