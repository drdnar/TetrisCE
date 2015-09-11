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
userLang	.equ	savedSp + 3
; Keyboard
keyBuffer	.equ	userLang + 1
kbdLastKey	.equ	keyBuffer + 1
kbdInhibitTimer	.equ	kbdLastKey + 1
; Text
textColors	.equ	kbdInhibitTimer + 1
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
; GUI
GuiRamStart	.equ	generalTimer + 4
GuiRamSize	.equ	GuiRamStart + 3
GuiRamNext	.equ	GuiRamSize + 3
GuiMaxObjects	.equ	GuiRamNext + 3
GuiRam		.equ	GuiMaxObjects + 1

;end_of_game_vars	.equ	OP7 + 9

; 262144 bytes (256 K) main RAM
; 153600 bytes (150 K) VRAM
; 415744 bytes (406 K) total RAM
; D00000	System vars, 12790 bytes
; D031F6	pixelShadow	8400
; D052C6	pixelShadow2	8400
; D07396	cmdPixelShadow	8400
; D09466	plotSScreen	21945
; D0EA1F	saveSScreen	21945
; D13FD8	end of scrap RAM
; D1A881	userMem
; Total static allocation: 108673 bytes
; 25800h 150 K  Size of VRAM
; 12C00  75 K   Half-size of VRAM
; 9600   37.5 K Quarter-size of VRAM
; D40000 START OF VRAM
; D49600 First quarter of VRAM
; D52C00 Middle of VRAM
; D5C200 Third quarter of VRAM
; D5D5D5 ISR
; D65800 END OF VRAM
; So let's put the IVT at D5D600, 258 bytes
;ivtLocation	.equ	(pixelShadow2 + 8400 - 258) & 0FFFF00h
ivtLocation	.equ	0D5D600h
isrLocation	.equ	0D5D5D5h

