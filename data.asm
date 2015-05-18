rfkDataName:
	.db	AppVarObj, "RFKDATA", 0

dataVerifyString:
dataVerifyStringLength	.equ	8
	.db	"RFK data"
	
dataNotFoundMsg:
	;	 12345678901234567890123456
	.db	"Robot could not find its  "
	.db	"memory. Please send the   "
	.db	"RFKDATA appvar and make   "
	.db	"sure it is archived."
	.db	0

;dataNotFound1:
;	.db	" Robot could not find its memory. ", 0
;dataNotFound2:
;	.db	" Please send the RFKDATA appvar, ", 0
;dataNotFound3:
;	.db	" and make sure it is archived. ", 0

titleText:
	.db	"Originally by the illustrious Leonard Richardson", chNewLine
	.db	"Cloned by Dr. D\'nar, 16 May 2015", chNewLine
	.db	"Written especially for the TI-84 Plus CE", chNewLine
	.db	chNewLine
	.db	"In this game, you are robot (#). Your job is to find", chNewLine
	.db	"kitten. This task is complicated by the existence of", chNewLine
	.db	"various things which are not kitten. Robot must touch", chNewLine
	.db	"items to determine if they are kitten or not. The game", chNewLine
	.db	"ends when robotfindskitten. Alternatively, you may", chNewLine
	.db	"end the game by hitting the Clear key.", chNewLine
	.db	chNewLine
	.db	"Press any key to start.", chNewLine
;	.db	chNewLine
;	.db	chNewLine
;	.db	chNewLine
;	.db	chNewLine
;	.db	chNewLine
;	.db	chNewLine	; This last chNewLine is an evil hack.
	.db	0


colorsBlacklist:
	.db	end_colorsBlacklist - start_colorsBlacklist
start_colorsBlacklist:
	.db	00, 01, 02, 08, 20h, 21h, 28h, 40h, 41h, 60h
end_colorsBlacklist:

robotfindskittenMsg:
	;	 1234567890123456
;	.db	"robotfindskitten", 0
	.db	32, 32, 1Fh, 1Fh, 0

goodJobMsg:
	.db	"You found kitten! Way to go robot!", 0

repeatMsg:
	.db	"Play again? [Y/n]", 0
	
endSeq1:
	.db	"#", chThickSpace, chThickSpace, chThickSpace, chThickSpace, chThickSpace, chThickSpace, chThickSpace, chThickSpace, chThickSpace, chThickSpace, chThickSpace, chThickSpace, 0
endSeq2:
	.db	"#", chThickSpace, chThickSpace, chThickSpace, chThickSpace, chThickSpace, chThickSpace, chThickSpace, chThickSpace, 0
endSeq3:
	.db	"#", chThickSpace, chThickSpace, chThickSpace, chThickSpace, 0
endSeq4:
	.db	"#", 0

