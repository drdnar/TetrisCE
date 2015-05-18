chQuotes	.equ	22h
chNewLine	.equ	01h
chEnter		.equ	01h
chTab		.equ	02h
chBackspace	.equ	03h
chDel		.equ	03h
ch1stPrintableChar	.equ	4
chThickSpace	.equ	7Fh

objTblOffset	.equ	12	; Comes from structure of file

;===============================================================================
;====== Vars ===================================================================
;===============================================================================

someFlags	.equ	-128

shortModeCode	.equ	pixelShadow2

vars		.equ	pixelShadow2 + 1024

savedSp		.equ	vars
; Text
textColors	.equ	savedSp + 3
textForeColor	.equ	textColors
textBackColor	.equ	foreColor + 1
lcdRow		.equ	textColors + 3
lcdCol		.equ	lcdRow + 1
fontHeight	.equ	lcdCol + 3
fontWidthsPtr	.equ	fontHeight + 1
fontDataPtr	.equ	fontWidthsPtr + 3
; Game
cursorY		.equ	objectArray + 256
cursorX		.equ	cursorY + 1
randomVal	.equ	cursorX + 1
randomValShort	.equ	(randomVal & 0FFFFh)
seed1		.equ	randomVal
seed1Short	.equ	(seed1 & 0FFFFh)
seed2		.equ	randomVal + 2
seed2Short	.equ	(seed2 & 0FFFFh)
rotationTimer	.equ	seed2 + 2
itemsCount	.equ	rotationTimer + 1
objectCount	.equ	itemsCount + 3
foundObject	.equ	objectCount + 1
stringOffset	.equ	foundObject + 1
stringStage	.equ	stringOffset + 3
scrollTimer	.equ	stringStage + 1
lastItemPtr	.equ	scrollTimer + 3
fpItems		.equ	lastItemPtr + 2
OP7		.equ	fpItems + 9
end_of_game_vars	.equ	OP7 + 9

ivtLocation	.equ	(pixelShadow2 + 8400 - 258) & 0FFFF00h
isrLocation	.equ	0D4D4D4h