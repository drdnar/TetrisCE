; GUI 2.0 for the eZ80!
; Now that we have tons of RAM and a 24-bit linear address space, we can have
; more complicated GUIness.

; Initial structure defining GUI objects
;	.db	objectId	; Identifies the object's RAM slot, 0 for render-only objects
;	.dw	objectSize
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


GuiLoadRoutinesTable:
; A table of routines called when each object is loaded
;	.dl	objectType0Routine
;	.dl	objectType1Routine
;	.dl	objectType2Routine
;	.dl	...
; Inputs:
;  - IX: Pointer to source data
;  - IY: Pointer to RAM vars
; Outputs:
;  - HL: Total RAM used
;  - NC to keep RAM allocated
;  - C to unallocate RAM (used for display-only objects)
; Destroys:
;  - Anything


GuiRenderRoutinesTable:
; A table of routines called to draw each object type, after loading.
; Used for GUIs that need to change what controls are displayed.
;	.dl	objectType0Routine
;	.dl	objectType1Routine
;	.dl	objectType2Routine
;	.dl	...
; Inputs:
;  - IX: Pointer to source data
;  - IY: Pointer to RAM vars
; Outputs:
;  - None
; Destroys:
;  - Anything


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
;  - IX: Pointer to source data
;  - IY: Pointer to RAM vars
;  - A: Button keycode pressed
; Outputs:
;  - Does not return; none
; Destroys:
;  - All


GuiLoad:
; Loads a new GUI context.
; Allocates memory in GUI object table.
; Computes object locations.
; Render objects.
; Input:
;  - IX: Pointer to GUI definition table
; Outputs:
;  - Does what it says
; Destroys:
;  - Assume all


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