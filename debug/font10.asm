debug_font:
; FONT METADATA
; Code Page = ASCII
; FirstChar = 0
; LastChar = 135
; AsmName = debug_font
	.db	6	; font width
	.db	10	; font height
	.db	((6 + 7) >> 3) * 10	; Bytes per character bitmap
; 
; GLYPH DATA TABLE
debug_fontDataTable:
	; Code point 00 � �
	.db	00000000b
	.db	00000000b
	.db	00000000b
	.db	00000000b
	.db	00000000b
	.db	00000000b
	.db	00000000b
	.db	00000000b
	.db	00000000b
	.db	00000000b
	; Code point 01 � �
	.db	00000000b
	.db	10101000b
	.db	01010000b
	.db	10101000b
	.db	01010000b
	.db	10101000b
	.db	01010000b
	.db	10101000b
	.db	00000000b
	.db	00000000b
	; Code point 02 � �
	.db	00000000b
	.db	01100000b
	.db	01100000b
	.db	01100000b
	.db	01100000b
	.db	01100000b
	.db	01100000b
	.db	01100000b
	.db	01100000b
	.db	00000000b
	; Code point 03 � �
	.db	00000000b
	.db	00000000b
	.db	00000000b
	.db	00000000b
	.db	00000000b
	.db	00000000b
	.db	00000000b
	.db	11111000b
	.db	11111000b
	.db	00000000b
	; Code point 04 ♥ ☐
	.db	00000000b
	.db	00000000b
	.db	11111100b
	.db	11111100b
	.db	11111100b
	.db	11111100b
	.db	11111100b
	.db	11111100b
	.db	11111100b
	.db	11111100b
	; Code point 05 ♦ ☒
	.db	11111100b
	.db	11111100b
	.db	11111100b
	.db	11111100b
	.db	11111100b
	.db	11111100b
	.db	11111100b
	.db	11111100b
	.db	00000000b
	.db	00000000b
	; Code point 06 ♣ ☑
	.db	00000000b
	.db	00000000b
	.db	11111100b
	.db	11111100b
	.db	11111100b
	.db	11111100b
	.db	11111100b
	.db	11111100b
	.db	00000000b
	.db	00000000b
	; Code point 07 ♠ ◦
	.db	00000000b
	.db	00000000b
	.db	00110000b
	.db	01001000b
	.db	10110100b
	.db	10110100b
	.db	01001000b
	.db	00110000b
	.db	00000000b
	.db	00000000b
	; Code point 08 • •
	.db	00000000b
	.db	00000000b
	.db	00110000b
	.db	01111000b
	.db	11111100b
	.db	11111100b
	.db	01111000b
	.db	00110000b
	.db	00000000b
	.db	00000000b
	; Code point 09 ◦ ◦
	.db	00000000b
	.db	00000000b
	.db	00110000b
	.db	01001000b
	.db	10000100b
	.db	10000100b
	.db	01001000b
	.db	00110000b
	.db	00000000b
	.db	00000000b
	; Code point 0A → →
	.db	00000000b
	.db	00000000b
	.db	00100000b
	.db	00010000b
	.db	11111000b
	.db	00010000b
	.db	00100000b
	.db	00000000b
	.db	00000000b
	.db	00000000b
	; Code point 0B ← ←
	.db	00000000b
	.db	00000000b
	.db	00100000b
	.db	01000000b
	.db	11111000b
	.db	01000000b
	.db	00100000b
	.db	00000000b
	.db	00000000b
	.db	00000000b
	; Code point 0C ↔ ↔
	.db	00000000b
	.db	00000000b
	.db	00000000b
	.db	01010000b
	.db	11111000b
	.db	01010000b
	.db	00000000b
	.db	00000000b
	.db	00000000b
	.db	00000000b
	; Code point 0D ↓ ↓
	.db	00000000b
	.db	00100000b
	.db	00100000b
	.db	00100000b
	.db	00100000b
	.db	10101000b
	.db	01110000b
	.db	00100000b
	.db	00000000b
	.db	00000000b
	; Code point 0E ↑ ↑
	.db	00000000b
	.db	00100000b
	.db	01110000b
	.db	10101000b
	.db	00100000b
	.db	00100000b
	.db	00100000b
	.db	00100000b
	.db	00000000b
	.db	00000000b
	; Code point 0F ↕ ↕
	.db	00000000b
	.db	00100000b
	.db	01110000b
	.db	10101000b
	.db	00100000b
	.db	10101000b
	.db	01110000b
	.db	00100000b
	.db	00000000b
	.db	00000000b
	; Code point 10 □ □
	.db	00000000b
	.db	11111000b
	.db	10001000b
	.db	10001000b
	.db	10001000b
	.db	10001000b
	.db	10001000b
	.db	11111000b
	.db	00000000b
	.db	00000000b
	; Code point 11 ▒ ▒
	.db	10101000b
	.db	01010100b
	.db	10101000b
	.db	10101000b
	.db	01010100b
	.db	10101000b
	.db	10101000b
	.db	01010100b
	.db	10101000b
	.db	10101000b
	; Code point 12 ▄ ▄
	.db	00000000b
	.db	00000000b
	.db	00000000b
	.db	00000000b
	.db	11111100b
	.db	11111100b
	.db	11111100b
	.db	11111100b
	.db	11111100b
	.db	11111100b
	; Code point 13 ▀ ▀
	.db	11111100b
	.db	11111100b
	.db	11111100b
	.db	11111100b
	.db	00000000b
	.db	00000000b
	.db	00000000b
	.db	00000000b
	.db	00000000b
	.db	00000000b
	; Code point 14 █ █
	.db	11111100b
	.db	11111100b
	.db	11111100b
	.db	11111100b
	.db	11111100b
	.db	11111100b
	.db	11111100b
	.db	11111100b
	.db	11111100b
	.db	11111100b
	; Code point 15 ─ ─
	.db	00000000b
	.db	00000000b
	.db	00000000b
	.db	00000000b
	.db	11111100b
	.db	00000000b
	.db	00000000b
	.db	00000000b
	.db	00000000b
	.db	00000000b
	; Code point 16 ┐ ┐
	.db	00000000b
	.db	00000000b
	.db	00000000b
	.db	00000000b
	.db	11100000b
	.db	00100000b
	.db	00100000b
	.db	00100000b
	.db	00100000b
	.db	00100000b
	; Code point 17 ┌ ┌
	.db	00000000b
	.db	00000000b
	.db	00000000b
	.db	00000000b
	.db	00111100b
	.db	00100000b
	.db	00100000b
	.db	00100000b
	.db	00100000b
	.db	00100000b
	; Code point 18 ┬ ┬
	.db	00000000b
	.db	00000000b
	.db	00000000b
	.db	00000000b
	.db	11111100b
	.db	00100000b
	.db	00100000b
	.db	00100000b
	.db	00100000b
	.db	00100000b
	; Code point 19 ┘ ┘
	.db	00100000b
	.db	00100000b
	.db	00100000b
	.db	00100000b
	.db	11100000b
	.db	00000000b
	.db	00000000b
	.db	00000000b
	.db	00000000b
	.db	00000000b
	; Code point 1A └ └
	.db	00100000b
	.db	00100000b
	.db	00100000b
	.db	00100000b
	.db	00111100b
	.db	00000000b
	.db	00000000b
	.db	00000000b
	.db	00000000b
	.db	00000000b
	; Code point 1B ┴ ┴
	.db	00100000b
	.db	00100000b
	.db	00100000b
	.db	00100000b
	.db	11111100b
	.db	00000000b
	.db	00000000b
	.db	00000000b
	.db	00000000b
	.db	00000000b
	; Code point 1C │ │
	.db	00100000b
	.db	00100000b
	.db	00100000b
	.db	00100000b
	.db	00100000b
	.db	00100000b
	.db	00100000b
	.db	00100000b
	.db	00100000b
	.db	00100000b
	; Code point 1D ┤ ┤
	.db	00100000b
	.db	00100000b
	.db	00100000b
	.db	00100000b
	.db	11100000b
	.db	00100000b
	.db	00100000b
	.db	00100000b
	.db	00100000b
	.db	00100000b
	; Code point 1E ├ ├
	.db	00100000b
	.db	00100000b
	.db	00100000b
	.db	00100000b
	.db	00111100b
	.db	00100000b
	.db	00100000b
	.db	00100000b
	.db	00100000b
	.db	00100000b
	; Code point 1F ┼ ┼
	.db	00100000b
	.db	00100000b
	.db	00100000b
	.db	00100000b
	.db	11111100b
	.db	00100000b
	.db	00100000b
	.db	00100000b
	.db	00100000b
	.db	00100000b
	; Code point 20    
	.db	00000000b
	.db	00000000b
	.db	00000000b
	.db	00000000b
	.db	00000000b
	.db	00000000b
	.db	00000000b
	.db	00000000b
	.db	00000000b
	.db	00000000b
	; Code point 21 ! !
	.db	00000000b
	.db	00100000b
	.db	00100000b
	.db	00100000b
	.db	00100000b
	.db	00100000b
	.db	00000000b
	.db	00100000b
	.db	00000000b
	.db	00000000b
	; Code point 22 " "
	.db	00000000b
	.db	01010000b
	.db	01010000b
	.db	00100000b
	.db	00000000b
	.db	00000000b
	.db	00000000b
	.db	00000000b
	.db	00000000b
	.db	00000000b
	; Code point 23 # #
	.db	00000000b
	.db	01010000b
	.db	11111000b
	.db	01010000b
	.db	01010000b
	.db	01010000b
	.db	11111000b
	.db	01010000b
	.db	00000000b
	.db	00000000b
	; Code point 24 $ $
	.db	00000000b
	.db	00100000b
	.db	01111000b
	.db	10100000b
	.db	01110000b
	.db	00101000b
	.db	11110000b
	.db	00100000b
	.db	00000000b
	.db	00000000b
	; Code point 25 % %
	.db	00000000b
	.db	11000000b
	.db	11001000b
	.db	00010000b
	.db	00100000b
	.db	01000000b
	.db	10011000b
	.db	00011000b
	.db	00000000b
	.db	00000000b
	; Code point 26 & &
	.db	00000000b
	.db	01100000b
	.db	10010000b
	.db	10100000b
	.db	01000000b
	.db	10101000b
	.db	10010000b
	.db	01101000b
	.db	00000000b
	.db	00000000b
	; Code point 27 ' '
	.db	00000000b
	.db	00100000b
	.db	00100000b
	.db	00100000b
	.db	00000000b
	.db	00000000b
	.db	00000000b
	.db	00000000b
	.db	00000000b
	.db	00000000b
	; Code point 28 ( (
	.db	00000000b
	.db	00010000b
	.db	00100000b
	.db	01000000b
	.db	01000000b
	.db	01000000b
	.db	00100000b
	.db	00010000b
	.db	00000000b
	.db	00000000b
	; Code point 29 ) )
	.db	00000000b
	.db	01000000b
	.db	00100000b
	.db	00010000b
	.db	00010000b
	.db	00010000b
	.db	00100000b
	.db	01000000b
	.db	00000000b
	.db	00000000b
	; Code point 2A * *
	.db	00000000b
	.db	00000000b
	.db	01010000b
	.db	00100000b
	.db	11111000b
	.db	00100000b
	.db	01010000b
	.db	00000000b
	.db	00000000b
	.db	00000000b
	; Code point 2B + +
	.db	00000000b
	.db	00000000b
	.db	00100000b
	.db	00100000b
	.db	11111000b
	.db	00100000b
	.db	00100000b
	.db	00000000b
	.db	00000000b
	.db	00000000b
	; Code point 2C , ,
	.db	00000000b
	.db	00000000b
	.db	00000000b
	.db	00000000b
	.db	00000000b
	.db	01100000b
	.db	01100000b
	.db	00100000b
	.db	01000000b
	.db	00000000b
	; Code point 2D - -
	.db	00000000b
	.db	00000000b
	.db	00000000b
	.db	00000000b
	.db	11111000b
	.db	00000000b
	.db	00000000b
	.db	00000000b
	.db	00000000b
	.db	00000000b
	; Code point 2E . .
	.db	00000000b
	.db	00000000b
	.db	00000000b
	.db	00000000b
	.db	00000000b
	.db	00000000b
	.db	01100000b
	.db	01100000b
	.db	00000000b
	.db	00000000b
	; Code point 2F / /
	.db	00000000b
	.db	00000000b
	.db	00001000b
	.db	00010000b
	.db	00100000b
	.db	01000000b
	.db	10000000b
	.db	00000000b
	.db	00000000b
	.db	00000000b
	; Code point 30 0 0
	.db	00000000b
	.db	01110000b
	.db	10001000b
	.db	10011000b
	.db	10101000b
	.db	11001000b
	.db	10001000b
	.db	01110000b
	.db	00000000b
	.db	00000000b
	; Code point 31 1 1
	.db	00000000b
	.db	00100000b
	.db	01100000b
	.db	00100000b
	.db	00100000b
	.db	00100000b
	.db	00100000b
	.db	01110000b
	.db	00000000b
	.db	00000000b
	; Code point 32 2 2
	.db	00000000b
	.db	01110000b
	.db	10001000b
	.db	00001000b
	.db	00010000b
	.db	00100000b
	.db	01000000b
	.db	11111000b
	.db	00000000b
	.db	00000000b
	; Code point 33 3 3
	.db	00000000b
	.db	11111000b
	.db	00010000b
	.db	00100000b
	.db	01110000b
	.db	00001000b
	.db	00001000b
	.db	11110000b
	.db	00000000b
	.db	00000000b
	; Code point 34 4 4
	.db	00000000b
	.db	00010000b
	.db	00110000b
	.db	01010000b
	.db	10010000b
	.db	11111000b
	.db	00010000b
	.db	00010000b
	.db	00000000b
	.db	00000000b
	; Code point 35 5 5
	.db	00000000b
	.db	11111000b
	.db	10000000b
	.db	11110000b
	.db	00001000b
	.db	00001000b
	.db	10001000b
	.db	01110000b
	.db	00000000b
	.db	00000000b
	; Code point 36 6 6
	.db	00000000b
	.db	00110000b
	.db	01000000b
	.db	10000000b
	.db	11110000b
	.db	10001000b
	.db	10001000b
	.db	01110000b
	.db	00000000b
	.db	00000000b
	; Code point 37 7 7
	.db	00000000b
	.db	11111000b
	.db	00001000b
	.db	00010000b
	.db	00100000b
	.db	00100000b
	.db	00100000b
	.db	00100000b
	.db	00000000b
	.db	00000000b
	; Code point 38 8 8
	.db	00000000b
	.db	01110000b
	.db	10001000b
	.db	10001000b
	.db	01110000b
	.db	10001000b
	.db	10001000b
	.db	01110000b
	.db	00000000b
	.db	00000000b
	; Code point 39 9 9
	.db	00000000b
	.db	01110000b
	.db	10001000b
	.db	10001000b
	.db	01111000b
	.db	00001000b
	.db	00010000b
	.db	01100000b
	.db	00000000b
	.db	00000000b
	; Code point 3A : :
	.db	00000000b
	.db	00000000b
	.db	01100000b
	.db	01100000b
	.db	00000000b
	.db	01100000b
	.db	01100000b
	.db	00000000b
	.db	00000000b
	.db	00000000b
	; Code point 3B ; ;
	.db	00000000b
	.db	00000000b
	.db	01100000b
	.db	01100000b
	.db	00000000b
	.db	01100000b
	.db	01100000b
	.db	00100000b
	.db	01000000b
	.db	00000000b
	; Code point 3C < <
	.db	00000000b
	.db	00010000b
	.db	00100000b
	.db	01000000b
	.db	10000000b
	.db	01000000b
	.db	00100000b
	.db	00010000b
	.db	00000000b
	.db	00000000b
	; Code point 3D = =
	.db	00000000b
	.db	00000000b
	.db	00000000b
	.db	11111000b
	.db	00000000b
	.db	11111000b
	.db	00000000b
	.db	00000000b
	.db	00000000b
	.db	00000000b
	; Code point 3E > >
	.db	00000000b
	.db	01000000b
	.db	00100000b
	.db	00010000b
	.db	00001000b
	.db	00010000b
	.db	00100000b
	.db	01000000b
	.db	00000000b
	.db	00000000b
	; Code point 3F ? ?
	.db	00000000b
	.db	01110000b
	.db	10001000b
	.db	00001000b
	.db	00010000b
	.db	00100000b
	.db	00000000b
	.db	00100000b
	.db	00000000b
	.db	00000000b
	; Code point 40 @ @
	.db	00000000b
	.db	01110000b
	.db	10001000b
	.db	00001000b
	.db	01101000b
	.db	10101000b
	.db	10101000b
	.db	01110000b
	.db	00000000b
	.db	00000000b
	; Code point 41 A A
	.db	00000000b
	.db	00100000b
	.db	01010000b
	.db	10001000b
	.db	10001000b
	.db	11111000b
	.db	10001000b
	.db	10001000b
	.db	00000000b
	.db	00000000b
	; Code point 42 B B
	.db	00000000b
	.db	11110000b
	.db	01001000b
	.db	01001000b
	.db	01110000b
	.db	01001000b
	.db	01001000b
	.db	11110000b
	.db	00000000b
	.db	00000000b
	; Code point 43 C C
	.db	00000000b
	.db	01110000b
	.db	10001000b
	.db	10000000b
	.db	10000000b
	.db	10000000b
	.db	10001000b
	.db	01110000b
	.db	00000000b
	.db	00000000b
	; Code point 44 D D
	.db	00000000b
	.db	11110000b
	.db	10001000b
	.db	10001000b
	.db	10001000b
	.db	10001000b
	.db	10001000b
	.db	11110000b
	.db	00000000b
	.db	00000000b
	; Code point 45 E E
	.db	00000000b
	.db	11111000b
	.db	10000000b
	.db	10000000b
	.db	11110000b
	.db	10000000b
	.db	10000000b
	.db	11111000b
	.db	00000000b
	.db	00000000b
	; Code point 46 F F
	.db	00000000b
	.db	11111000b
	.db	10000000b
	.db	10000000b
	.db	11110000b
	.db	10000000b
	.db	10000000b
	.db	10000000b
	.db	00000000b
	.db	00000000b
	; Code point 47 G G
	.db	00000000b
	.db	01111000b
	.db	10000000b
	.db	10000000b
	.db	10011000b
	.db	10001000b
	.db	10001000b
	.db	01110000b
	.db	00000000b
	.db	00000000b
	; Code point 48 H H
	.db	00000000b
	.db	10001000b
	.db	10001000b
	.db	10001000b
	.db	11111000b
	.db	10001000b
	.db	10001000b
	.db	10001000b
	.db	00000000b
	.db	00000000b
	; Code point 49 I I
	.db	00000000b
	.db	01110000b
	.db	00100000b
	.db	00100000b
	.db	00100000b
	.db	00100000b
	.db	00100000b
	.db	01110000b
	.db	00000000b
	.db	00000000b
	; Code point 4A J J
	.db	00000000b
	.db	00111000b
	.db	00010000b
	.db	00010000b
	.db	00010000b
	.db	00010000b
	.db	10010000b
	.db	01100000b
	.db	00000000b
	.db	00000000b
	; Code point 4B K K
	.db	00000000b
	.db	10001000b
	.db	10010000b
	.db	10100000b
	.db	11000000b
	.db	10100000b
	.db	10010000b
	.db	10001000b
	.db	00000000b
	.db	00000000b
	; Code point 4C L L
	.db	00000000b
	.db	10000000b
	.db	10000000b
	.db	10000000b
	.db	10000000b
	.db	10000000b
	.db	10000000b
	.db	11111000b
	.db	00000000b
	.db	00000000b
	; Code point 4D M M
	.db	00000000b
	.db	10001000b
	.db	11011000b
	.db	10101000b
	.db	10101000b
	.db	10001000b
	.db	10001000b
	.db	10001000b
	.db	00000000b
	.db	00000000b
	; Code point 4E N N
	.db	00000000b
	.db	10001000b
	.db	10001000b
	.db	11001000b
	.db	10101000b
	.db	10011000b
	.db	10001000b
	.db	10001000b
	.db	00000000b
	.db	00000000b
	; Code point 4F O O
	.db	00000000b
	.db	01110000b
	.db	10001000b
	.db	10001000b
	.db	10001000b
	.db	10001000b
	.db	10001000b
	.db	01110000b
	.db	00000000b
	.db	00000000b
	; Code point 50 P P
	.db	00000000b
	.db	11110000b
	.db	10001000b
	.db	10001000b
	.db	11110000b
	.db	10000000b
	.db	10000000b
	.db	10000000b
	.db	00000000b
	.db	00000000b
	; Code point 51 Q Q
	.db	00000000b
	.db	01110000b
	.db	10001000b
	.db	10001000b
	.db	10001000b
	.db	10101000b
	.db	10010000b
	.db	01101000b
	.db	00000000b
	.db	00000000b
	; Code point 52 R R
	.db	00000000b
	.db	11110000b
	.db	10001000b
	.db	10001000b
	.db	11110000b
	.db	10100000b
	.db	10010000b
	.db	10001000b
	.db	00000000b
	.db	00000000b
	; Code point 53 S S
	.db	00000000b
	.db	01110000b
	.db	10001000b
	.db	10000000b
	.db	01110000b
	.db	00001000b
	.db	10001000b
	.db	01110000b
	.db	00000000b
	.db	00000000b
	; Code point 54 T T
	.db	00000000b
	.db	11111000b
	.db	00100000b
	.db	00100000b
	.db	00100000b
	.db	00100000b
	.db	00100000b
	.db	00100000b
	.db	00000000b
	.db	00000000b
	; Code point 55 U U
	.db	00000000b
	.db	10001000b
	.db	10001000b
	.db	10001000b
	.db	10001000b
	.db	10001000b
	.db	10001000b
	.db	01110000b
	.db	00000000b
	.db	00000000b
	; Code point 56 V V
	.db	00000000b
	.db	10001000b
	.db	10001000b
	.db	10001000b
	.db	01010000b
	.db	01010000b
	.db	00100000b
	.db	00100000b
	.db	00000000b
	.db	00000000b
	; Code point 57 W W
	.db	00000000b
	.db	10001000b
	.db	10001000b
	.db	10001000b
	.db	10101000b
	.db	10101000b
	.db	11011000b
	.db	10001000b
	.db	00000000b
	.db	00000000b
	; Code point 58 X X
	.db	00000000b
	.db	10001000b
	.db	10001000b
	.db	01010000b
	.db	00100000b
	.db	01010000b
	.db	10001000b
	.db	10001000b
	.db	00000000b
	.db	00000000b
	; Code point 59 Y Y
	.db	00000000b
	.db	10001000b
	.db	10001000b
	.db	01010000b
	.db	00100000b
	.db	00100000b
	.db	00100000b
	.db	00100000b
	.db	00000000b
	.db	00000000b
	; Code point 5A Z Z
	.db	00000000b
	.db	11111000b
	.db	00001000b
	.db	00010000b
	.db	00100000b
	.db	01000000b
	.db	10000000b
	.db	11111000b
	.db	00000000b
	.db	00000000b
	; Code point 5B [ [
	.db	00000000b
	.db	00110000b
	.db	00100000b
	.db	00100000b
	.db	00100000b
	.db	00100000b
	.db	00100000b
	.db	00110000b
	.db	00000000b
	.db	00000000b
	; Code point 5C \ \
	.db	00000000b
	.db	00000000b
	.db	10000000b
	.db	01000000b
	.db	00100000b
	.db	00010000b
	.db	00001000b
	.db	00000000b
	.db	00000000b
	.db	00000000b
	; Code point 5D ] ]
	.db	00000000b
	.db	01100000b
	.db	00100000b
	.db	00100000b
	.db	00100000b
	.db	00100000b
	.db	00100000b
	.db	01100000b
	.db	00000000b
	.db	00000000b
	; Code point 5E ^ ^
	.db	00000000b
	.db	00000000b
	.db	00100000b
	.db	01010000b
	.db	10001000b
	.db	10001000b
	.db	00000000b
	.db	00000000b
	.db	00000000b
	.db	00000000b
	; Code point 5F _ _
	.db	00000000b
	.db	00000000b
	.db	00000000b
	.db	00000000b
	.db	00000000b
	.db	00000000b
	.db	00000000b
	.db	11111000b
	.db	00000000b
	.db	00000000b
	; Code point 60 ` `
	.db	00000000b
	.db	00100000b
	.db	00100000b
	.db	00010000b
	.db	00000000b
	.db	00000000b
	.db	00000000b
	.db	00000000b
	.db	00000000b
	.db	00000000b
	; Code point 61 a a
	.db	00000000b
	.db	00000000b
	.db	00000000b
	.db	01110000b
	.db	10010000b
	.db	10010000b
	.db	10010000b
	.db	01101000b
	.db	00000000b
	.db	00000000b
	; Code point 62 b b
	.db	00000000b
	.db	10000000b
	.db	10000000b
	.db	10110000b
	.db	11001000b
	.db	10001000b
	.db	10001000b
	.db	11110000b
	.db	00000000b
	.db	00000000b
	; Code point 63 c c
	.db	00000000b
	.db	00000000b
	.db	00000000b
	.db	01110000b
	.db	10000000b
	.db	10000000b
	.db	10001000b
	.db	01110000b
	.db	00000000b
	.db	00000000b
	; Code point 64 d d
	.db	00000000b
	.db	00001000b
	.db	00001000b
	.db	01101000b
	.db	10011000b
	.db	10001000b
	.db	10001000b
	.db	01111000b
	.db	00000000b
	.db	00000000b
	; Code point 65 e e
	.db	00000000b
	.db	00000000b
	.db	00000000b
	.db	01110000b
	.db	10001000b
	.db	11111000b
	.db	10000000b
	.db	01110000b
	.db	00000000b
	.db	00000000b
	; Code point 66 f f
	.db	00000000b
	.db	00010000b
	.db	00101000b
	.db	00100000b
	.db	01110000b
	.db	00100000b
	.db	00100000b
	.db	00100000b
	.db	00000000b
	.db	00000000b
	; Code point 67 g g
	.db	00000000b
	.db	00000000b
	.db	00000000b
	.db	01110000b
	.db	10010000b
	.db	10010000b
	.db	10010000b
	.db	01110000b
	.db	00010000b
	.db	01100000b
	; Code point 68 h h
	.db	00000000b
	.db	10000000b
	.db	10000000b
	.db	11100000b
	.db	10010000b
	.db	10010000b
	.db	10010000b
	.db	10010000b
	.db	00000000b
	.db	00000000b
	; Code point 69 i i
	.db	00000000b
	.db	00100000b
	.db	00000000b
	.db	00100000b
	.db	00100000b
	.db	00100000b
	.db	00100000b
	.db	00100000b
	.db	00000000b
	.db	00000000b
	; Code point 6A j j
	.db	00000000b
	.db	00010000b
	.db	00000000b
	.db	00110000b
	.db	00010000b
	.db	00010000b
	.db	00010000b
	.db	00010000b
	.db	10010000b
	.db	01100000b
	; Code point 6B k k
	.db	00000000b
	.db	01000000b
	.db	01000000b
	.db	01001000b
	.db	01010000b
	.db	01100000b
	.db	01010000b
	.db	01001000b
	.db	00000000b
	.db	00000000b
	; Code point 6C l l
	.db	00000000b
	.db	00100000b
	.db	00100000b
	.db	00100000b
	.db	00100000b
	.db	00100000b
	.db	00100000b
	.db	00100000b
	.db	00000000b
	.db	00000000b
	; Code point 6D m m
	.db	00000000b
	.db	00000000b
	.db	00000000b
	.db	01010000b
	.db	10101000b
	.db	10101000b
	.db	10101000b
	.db	10101000b
	.db	00000000b
	.db	00000000b
	; Code point 6E n n
	.db	00000000b
	.db	00000000b
	.db	00000000b
	.db	10110000b
	.db	11001000b
	.db	10001000b
	.db	10001000b
	.db	10001000b
	.db	00000000b
	.db	00000000b
	; Code point 6F o o
	.db	00000000b
	.db	00000000b
	.db	00000000b
	.db	01110000b
	.db	10001000b
	.db	10001000b
	.db	10001000b
	.db	01110000b
	.db	00000000b
	.db	00000000b
	; Code point 70 p p
	.db	00000000b
	.db	00000000b
	.db	00000000b
	.db	11110000b
	.db	10001000b
	.db	10001000b
	.db	10001000b
	.db	11110000b
	.db	10000000b
	.db	10000000b
	; Code point 71 q q
	.db	00000000b
	.db	00000000b
	.db	00000000b
	.db	01110000b
	.db	10010000b
	.db	10010000b
	.db	10110000b
	.db	01010000b
	.db	00010000b
	.db	00011000b
	; Code point 72 r r
	.db	00000000b
	.db	00000000b
	.db	00000000b
	.db	10110000b
	.db	11000000b
	.db	10000000b
	.db	10000000b
	.db	10000000b
	.db	00000000b
	.db	00000000b
	; Code point 73 s s
	.db	00000000b
	.db	00000000b
	.db	00000000b
	.db	01110000b
	.db	10000000b
	.db	01110000b
	.db	00001000b
	.db	11110000b
	.db	00000000b
	.db	00000000b
	; Code point 74 t t
	.db	00000000b
	.db	00000000b
	.db	01000000b
	.db	11100000b
	.db	01000000b
	.db	01000000b
	.db	01010000b
	.db	00100000b
	.db	00000000b
	.db	00000000b
	; Code point 75 u u
	.db	00000000b
	.db	00000000b
	.db	00000000b
	.db	10001000b
	.db	10001000b
	.db	10001000b
	.db	10011000b
	.db	01101000b
	.db	00000000b
	.db	00000000b
	; Code point 76 v v
	.db	00000000b
	.db	00000000b
	.db	00000000b
	.db	10001000b
	.db	10001000b
	.db	10001000b
	.db	01010000b
	.db	00100000b
	.db	00000000b
	.db	00000000b
	; Code point 77 w w
	.db	00000000b
	.db	00000000b
	.db	00000000b
	.db	10001000b
	.db	10001000b
	.db	10101000b
	.db	10101000b
	.db	01010000b
	.db	00000000b
	.db	00000000b
	; Code point 78 x x
	.db	00000000b
	.db	00000000b
	.db	00000000b
	.db	11101000b
	.db	00110000b
	.db	00100000b
	.db	01100000b
	.db	10111000b
	.db	00000000b
	.db	00000000b
	; Code point 79 y y
	.db	00000000b
	.db	00000000b
	.db	00000000b
	.db	10010000b
	.db	10010000b
	.db	10010000b
	.db	10010000b
	.db	01110000b
	.db	00010000b
	.db	01100000b
	; Code point 7A z z
	.db	00000000b
	.db	00000000b
	.db	00000000b
	.db	11111000b
	.db	00010000b
	.db	00100000b
	.db	01000000b
	.db	11111000b
	.db	00000000b
	.db	00000000b
	; Code point 7B { {
	.db	00000000b
	.db	00110000b
	.db	00100000b
	.db	00100000b
	.db	01000000b
	.db	00100000b
	.db	00100000b
	.db	00110000b
	.db	00000000b
	.db	00000000b
	; Code point 7C | |
	.db	00000000b
	.db	00100000b
	.db	00100000b
	.db	00100000b
	.db	00100000b
	.db	00100000b
	.db	00100000b
	.db	00100000b
	.db	00000000b
	.db	00000000b
	; Code point 7D } }
	.db	00000000b
	.db	01100000b
	.db	00100000b
	.db	00100000b
	.db	00010000b
	.db	00100000b
	.db	00100000b
	.db	01100000b
	.db	00000000b
	.db	00000000b
	; Code point 7E ~ ~
	.db	00000000b
	.db	00000000b
	.db	00000000b
	.db	01000000b
	.db	10101000b
	.db	00010000b
	.db	00000000b
	.db	00000000b
	.db	00000000b
	.db	00000000b
	; Code point 7F θ θ
	.db	00000000b
	.db	01110000b
	.db	10001000b
	.db	10001000b
	.db	11111000b
	.db	10001000b
	.db	10001000b
	.db	01110000b
	.db	00000000b
	.db	00000000b
	; Code point 80 � �
	.db	00000000b
	.db	11111000b
	.db	11111000b
	.db	11111000b
	.db	11111000b
	.db	11111000b
	.db	11111000b
	.db	11111000b
	.db	11111000b
	.db	00000000b
	; Code point 81 � �
	.db	00000000b
	.db	11111000b
	.db	11011000b
	.db	10001000b
	.db	01010000b
	.db	11011000b
	.db	11011000b
	.db	11011000b
	.db	11111000b
	.db	00000000b
	; Code point 82 � �
	.db	00000000b
	.db	11111000b
	.db	11011000b
	.db	10101000b
	.db	10101000b
	.db	10001000b
	.db	10101000b
	.db	10101000b
	.db	11111000b
	.db	00000000b
	; Code point 83 � �
	.db	00000000b
	.db	11111000b
	.db	11111000b
	.db	11011000b
	.db	11101000b
	.db	11001000b
	.db	10101000b
	.db	11001000b
	.db	11111000b
	.db	00000000b
	; Code point 84 � �
	.db	00000000b
	.db	00000000b
	.db	00000000b
	.db	00000000b
	.db	00000000b
	.db	00000000b
	.db	00000000b
	.db	00000000b
	.db	11111000b
	.db	00000000b
	; Code point 85 � �
	.db	00000000b
	.db	00100000b
	.db	01110000b
	.db	10101000b
	.db	00100000b
	.db	00100000b
	.db	00100000b
	.db	00000000b
	.db	11111000b
	.db	00000000b
	; Code point 86 � �
	.db	00000000b
	.db	00000000b
	.db	00100000b
	.db	01010000b
	.db	01110000b
	.db	01010000b
	.db	01010000b
	.db	00000000b
	.db	11111000b
	.db	00000000b
	; Code point 87 � �
	.db	00000000b
	.db	00000000b
	.db	00100000b
	.db	00010000b
	.db	00110000b
	.db	01010000b
	.db	00110000b
	.db	00000000b
	.db	11111000b
	.db	00000000b
