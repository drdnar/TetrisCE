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
lcdRow		.equ	textColors + 4
lcdCol		.equ	lcdRow + 1
fontHeight	.equ	lcdCol + 3
fontWidthsPtr	.equ	fontHeight + 1
fontDataPtr	.equ	fontWidthsPtr + 3
; Random
randomVal	.equ	fontDataPtr + 3
randomValShort	.equ	(randomVal & 0FFFFh)
seed1		.equ	randomVal
seed1Short	.equ	(seed1 & 0FFFFh)
seed2		.equ	randomVal + 2
seed2Short	.equ	(seed2 & 0FFFFh)
; Timers
generalTimer	.equ	seed2 + 3
;end_of_game_vars	.equ	OP7 + 9

; 25800h Size of VRAM
; 12C00  Half-size of VRAM
; D40000 START OF VRAM
; D52C00 Middle of VRAM
; D65800 END OF VRAM	
; D5D5D5 ISR
; So let's put the IVT at D5D600, 258 bytes
;ivtLocation	.equ	(pixelShadow2 + 8400 - 258) & 0FFFF00h
ivtLocation	.equ	0D5D600h
isrLocation	.equ	0D5D5D5h

