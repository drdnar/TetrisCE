debug_KeyAsciiTableLetters:
	.db	(debug_KeyAsciiTableLetters_end - debug_KeyAsciiTableLetters - 1) / 2
	.db	skMath, "A"
	.db	skMatrix, "B"
	.db	skPrgm, "C"
	.db	skRecip, "D"
	.db	skSin, "E"
	.db	skCos, "F"
	.db	skTan, "G"
	.db	skPower, "H"
	.db	skSquare, "I"
	.db	skComma, "J"
	.db	skLParen, "K"
	.db	skRParen, "L"
	.db	skDiv, "M"
	.db	skLog, "N"
	.db	sk7, "O"
	.db	sk8, "P"
	.db	sk9, "Q"
	.db	skMul, "R"
	.db	skLn, "S"
	.db	sk4, "T"
	.db	sk5, "U"
	.db	sk6, "V"
	.db	skSub, "W"
	.db	skStore, "X"
	.db	sk1, "Y"
	.db	sk2, "Z"
	.db	sk0, " "
	.db	skDecPnt, ":"
	.db	skChs, "?"
	.db	skAdd, 22h	; Double quote
	.db	sk3, debug_chTheta	; Theta
debug_KeyAsciiTableLetters_end:
debug_KeyAsciiTableNumbers:
	.db	(debug_KeyAsciiTableNumbers_end - debug_KeyAsciiTableNumbers - 1) / 2
	.db	sk7, "7"
	.db	sk8, "8"
	.db	sk9, "9"
	.db	sk4, "4"
	.db	sk5, "5"
	.db	sk6, "6"
	.db	skSub, "-"
	.db	sk1, "1"
	.db	sk2, "2"
	.db	sk3, "3"
	.db	sk0, "0"
	.db	skMath, "A"
	.db	skMatrix, "B"
	.db	skPrgm, "C"
	.db	skRecip, "D"
	.db	skSin, "E"
	.db	skCos, "F"
	.db	skDecPnt, "."
	.db	skComma, ","
	.db	skLParen, "("
	.db	skRParen, ")"
	.db	skDiv, 2Fh
	.db	skMul, "*"
	.db	skAdd, "+"
	.db	skPower, "^"
	.db	skStore, "="
	.db	skSquare, "`"
	.db	skLog, "$"
	.db	skLn, "%"
debug_KeyAsciiTableNumbers_end:
debug_KeyAsciiTableNumbers2nd:
	.db	(debug_KeyAsciiTableNumbers2nd_end - debug_KeyAsciiTableNumbers2nd - 1) / 2
	.db	skLParen, "{"
	.db	skRParen, "}"
	.db	skDecPnt, "|"
	.db	sk0, "_"
	.db	skComma, ";"
	.db	sk8, "<"
	.db	sk9, ">"
	.db	skDiv, 5Ch	; Backslash
	.db	skStore, "@"
	.db	skPower, "~"
	.db	skMul, "["
	.db	skSub, "]"
	.db	skAdd, 27h	; Single quote
	.db	skLog, "#"
	.db	skLn, "&"
	.db	skSquare, "!"
debug_KeyAsciiTableNumbers2nd_end: