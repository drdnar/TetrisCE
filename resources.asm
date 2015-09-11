GetResource:
; Gets a pointer to a resource, given a resource ID.
; Input:
;  - HL: Resource ID
; Output:
;  - HL: Pointer to resource
; Destroys:
;  - Nothing
	push	af
	push	de
	inc	hl
	dec.sis	hl
	ld	de, GlobalResourcesTable
	bit	7, h
	jr	z, +_
	res	7, h
	ld	de, LocalizedResourcesTablesTable
	push	hl
	ld	hl, (userLang)
	ld	h, 3
	mlt	hl
	add	hl, de
	ld	de, (hl)
	pop	hl
_:	add	hl, de
	ld	hl, (hl)
	pop	de
	pop	af
	ret


;------ ------------------------------------------------------------------------
LocalizedResourcesTablesTable:
	.dl	EnglishResourcesTable


;------ ------------------------------------------------------------------------
GlobalResourcesTable:
RsrcTestString	.equ	0
	.dl	rsrc_TestString





rsrc_TestString:
	.db	"TEST String", 0


