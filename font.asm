font:
; FONT METADATA
; Code Page = Win-1252
; Name = MicrOS Default Font
; FirstChar = 31
; LastChar = 127
	.db	14	; font height
	.dl	fontWidthTable - font
	.dl	fontDataTable - font
; 
; GLYPH WIDTH TABLE
fontWidthTable:
	.db	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
	.db	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
	.db	9	; Heart
	.db	3	;    
	.db	3	; ! !
	.db	6	; " "
	.db	8	; # #
	.db	7	; $ $
	.db	6	; % %
	.db	8	; & &
	.db	4	; ' '
	.db	5	; ( (
	.db	5	; ) )
	.db	8	; * *
	.db	7	; + +
	.db	4	; , ,
	.db	7	; - -
	.db	3	; . .
	.db	5	; / /
	.db	7	; 0 0
	.db	7	; 1 1
	.db	7	; 2 2
	.db	7	; 3 3
	.db	7	; 4 4
	.db	7	; 5 5
	.db	7	; 6 6
	.db	7	; 7 7
	.db	7	; 8 8
	.db	7	; 9 9
	.db	3	; : :
	.db	4	; ; ;
	.db	7	; < <
	.db	7	; = =
	.db	7	; > >
	.db	7	; ? ?
	.db	8	; @ @
	.db	7	; A A
	.db	7	; B B
	.db	7	; C C
	.db	7	; D D
	.db	7	; E E
	.db	7	; F F
	.db	8	; G G
	.db	7	; H H
	.db	5	; I I
	.db	7	; J J
	.db	7	; K K
	.db	6	; L L
	.db	10	; M M
	.db	8	; N N
	.db	8	; O O
	.db	7	; P P
	.db	8	; Q Q
	.db	7	; R R
	.db	7	; S S
	.db	7	; T T
	.db	7	; U U
	.db	7	; V V
	.db	9	; W W
	.db	8	; X X
	.db	7	; Y Y
	.db	8	; Z Z
	.db	5	; [ [
	.db	5	; \ \
	.db	5	; ] ]
	.db	6	; ^ ^
	.db	8	; _ _
	.db	4	; ` `
	.db	7	; a a
	.db	7	; b b
	.db	7	; c c
	.db	7	; d d
	.db	7	; e e
	.db	6	; f f
	.db	7	; g g
	.db	7	; h h
	.db	3	; i i
	.db	6	; j j
	.db	7	; k k
	.db	3	; l l
	.db	9	; m m
	.db	7	; n n
	.db	7	; o o
	.db	7	; p p
	.db	7	; q q
	.db	7	; r r
	.db	7	; s s
	.db	5	; t t
	.db	7	; u u
	.db	8	; v v
	.db	9	; w w
	.db	8	; x x
	.db	7	; y y
	.db	6	; z z
	.db	6	; { {
	.db	3	; | |
	.db	5	; } }
	.db	8	; ~ ~
	.db	10	; Thick space
; 
; GLYPH DATA TABLE
fontDataTable:
	.dl	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
	.dl	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
	.dl	fontChar1F - fontDataTable	; ū ū
	.dl	fontChar20 - fontDataTable	;    
	.dl	fontChar21 - fontDataTable	; ! !
	.dl	fontChar22 - fontDataTable	; " "
	.dl	fontChar23 - fontDataTable	; # #
	.dl	fontChar24 - fontDataTable	; $ $
	.dl	fontChar25 - fontDataTable	; % %
	.dl	fontChar26 - fontDataTable	; & &
	.dl	fontChar27 - fontDataTable	; ' '
	.dl	fontChar28 - fontDataTable	; ( (
	.dl	fontChar29 - fontDataTable	; ) )
	.dl	fontChar2A - fontDataTable	; * *
	.dl	fontChar2B - fontDataTable	; + +
	.dl	fontChar2C - fontDataTable	; , ,
	.dl	fontChar2D - fontDataTable	; - -
	.dl	fontChar2E - fontDataTable	; . .
	.dl	fontChar2F - fontDataTable	; / /
	.dl	fontChar30 - fontDataTable	; 0 0
	.dl	fontChar31 - fontDataTable	; 1 1
	.dl	fontChar32 - fontDataTable	; 2 2
	.dl	fontChar33 - fontDataTable	; 3 3
	.dl	fontChar34 - fontDataTable	; 4 4
	.dl	fontChar35 - fontDataTable	; 5 5
	.dl	fontChar36 - fontDataTable	; 6 6
	.dl	fontChar37 - fontDataTable	; 7 7
	.dl	fontChar38 - fontDataTable	; 8 8
	.dl	fontChar39 - fontDataTable	; 9 9
	.dl	fontChar3A - fontDataTable	; : :
	.dl	fontChar3B - fontDataTable	; ; ;
	.dl	fontChar3C - fontDataTable	; < <
	.dl	fontChar3D - fontDataTable	; = =
	.dl	fontChar3E - fontDataTable	; > >
	.dl	fontChar3F - fontDataTable	; ? ?
	.dl	fontChar40 - fontDataTable	; @ @
	.dl	fontChar41 - fontDataTable	; A A
	.dl	fontChar42 - fontDataTable	; B B
	.dl	fontChar43 - fontDataTable	; C C
	.dl	fontChar44 - fontDataTable	; D D
	.dl	fontChar45 - fontDataTable	; E E
	.dl	fontChar46 - fontDataTable	; F F
	.dl	fontChar47 - fontDataTable	; G G
	.dl	fontChar48 - fontDataTable	; H H
	.dl	fontChar49 - fontDataTable	; I I
	.dl	fontChar4A - fontDataTable	; J J
	.dl	fontChar4B - fontDataTable	; K K
	.dl	fontChar4C - fontDataTable	; L L
	.dl	fontChar4D - fontDataTable	; M M
	.dl	fontChar4E - fontDataTable	; N N
	.dl	fontChar4F - fontDataTable	; O O
	.dl	fontChar50 - fontDataTable	; P P
	.dl	fontChar51 - fontDataTable	; Q Q
	.dl	fontChar52 - fontDataTable	; R R
	.dl	fontChar53 - fontDataTable	; S S
	.dl	fontChar54 - fontDataTable	; T T
	.dl	fontChar55 - fontDataTable	; U U
	.dl	fontChar56 - fontDataTable	; V V
	.dl	fontChar57 - fontDataTable	; W W
	.dl	fontChar58 - fontDataTable	; X X
	.dl	fontChar59 - fontDataTable	; Y Y
	.dl	fontChar5A - fontDataTable	; Z Z
	.dl	fontChar5B - fontDataTable	; [ [
	.dl	fontChar5C - fontDataTable	; \ \
	.dl	fontChar5D - fontDataTable	; ] ]
	.dl	fontChar5E - fontDataTable	; ^ ^
	.dl	fontChar5F - fontDataTable	; _ _
	.dl	fontChar60 - fontDataTable	; ` `
	.dl	fontChar61 - fontDataTable	; a a
	.dl	fontChar62 - fontDataTable	; b b
	.dl	fontChar63 - fontDataTable	; c c
	.dl	fontChar64 - fontDataTable	; d d
	.dl	fontChar65 - fontDataTable	; e e
	.dl	fontChar66 - fontDataTable	; f f
	.dl	fontChar67 - fontDataTable	; g g
	.dl	fontChar68 - fontDataTable	; h h
	.dl	fontChar69 - fontDataTable	; i i
	.dl	fontChar6A - fontDataTable	; j j
	.dl	fontChar6B - fontDataTable	; k k
	.dl	fontChar6C - fontDataTable	; l l
	.dl	fontChar6D - fontDataTable	; m m
	.dl	fontChar6E - fontDataTable	; n n
	.dl	fontChar6F - fontDataTable	; o o
	.dl	fontChar70 - fontDataTable	; p p
	.dl	fontChar71 - fontDataTable	; q q
	.dl	fontChar72 - fontDataTable	; r r
	.dl	fontChar73 - fontDataTable	; s s
	.dl	fontChar74 - fontDataTable	; t t
	.dl	fontChar75 - fontDataTable	; u u
	.dl	fontChar76 - fontDataTable	; v v
	.dl	fontChar77 - fontDataTable	; w w
	.dl	fontChar78 - fontDataTable	; x x
	.dl	fontChar79 - fontDataTable	; y y
	.dl	fontChar7A - fontDataTable	; z z
	.dl	fontChar7B - fontDataTable	; { {
	.dl	fontChar7C - fontDataTable	; | |
	.dl	fontChar7D - fontDataTable	; } }
	.dl	fontChar7E - fontDataTable	; ~ ~
	.dl	fontChar7F - fontDataTable	; ∞ ∞
; 
; GLYPH DATA
fontChar1F: ; Heart
	.db	00000000b, 00000000b
	.db	00000000b, 00000000b
	.db	00000000b, 00000000b
	.db	00110110b, 00000000b
	.db	01111111b, 00000000b
	.db	01111111b, 00000000b
	.db	01111111b, 00000000b
	.db	01111111b, 00000000b
	.db	00111110b, 00000000b
	.db	00011100b, 00000000b
	.db	00001000b, 00000000b
	.db	00000000b, 00000000b
	.db	00000000b, 00000000b
	.db	00000000b, 00000000b
fontChar20: ;    
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
	.db	00000000b
	.db	00000000b
	.db	00000000b
	.db	00000000b
fontChar21: ; ! !
	.db	00000000b
	.db	00000000b
	.db	11000000b
	.db	11000000b
	.db	11000000b
	.db	11000000b
	.db	11000000b
	.db	11000000b
	.db	00000000b
	.db	11000000b
	.db	11000000b
	.db	00000000b
	.db	00000000b
	.db	00000000b
fontChar22: ; " "
	.db	00000000b
	.db	11011000b
	.db	11011000b
	.db	11011000b
	.db	01010000b
	.db	00000000b
	.db	00000000b
	.db	00000000b
	.db	00000000b
	.db	00000000b
	.db	00000000b
	.db	00000000b
	.db	00000000b
	.db	00000000b
fontChar23: ; # #
	.db	00000000b
	.db	00000000b
	.db	01101100b
	.db	01101100b
	.db	11111110b
	.db	01101100b
	.db	01101100b
	.db	01101100b
	.db	11111110b
	.db	01101100b
	.db	01101100b
	.db	00000000b
	.db	00000000b
	.db	00000000b
fontChar24: ; $ $
	.db	00110000b
	.db	00110000b
	.db	01111000b
	.db	11001100b
	.db	11000100b
	.db	11000000b
	.db	01111000b
	.db	00001100b
	.db	10001100b
	.db	11001100b
	.db	01111000b
	.db	00110000b
	.db	00110000b
	.db	00000000b
fontChar25: ; % %
	.db	00000000b
	.db	00000000b
	.db	00000000b
	.db	11000000b
	.db	11001000b
	.db	00011000b
	.db	00110000b
	.db	01100000b
	.db	11000000b
	.db	10011000b
	.db	00011000b
	.db	00000000b
	.db	00000000b
	.db	00000000b
fontChar26: ; & &
	.db	00000000b
	.db	00000000b
	.db	00111000b
	.db	01101100b
	.db	01101100b
	.db	00111000b
	.db	01110110b
	.db	11011100b
	.db	11001100b
	.db	11001100b
	.db	01110110b
	.db	00000000b
	.db	00000000b
	.db	00000000b
fontChar27: ; ' '
	.db	00000000b
	.db	01100000b
	.db	01100000b
	.db	01100000b
	.db	11000000b
	.db	00000000b
	.db	00000000b
	.db	00000000b
	.db	00000000b
	.db	00000000b
	.db	00000000b
	.db	00000000b
	.db	00000000b
	.db	00000000b
fontChar28: ; ( (
	.db	00000000b
	.db	00000000b
	.db	00110000b
	.db	01100000b
	.db	11000000b
	.db	11000000b
	.db	11000000b
	.db	11000000b
	.db	11000000b
	.db	01100000b
	.db	00110000b
	.db	00000000b
	.db	00000000b
	.db	00000000b
fontChar29: ; ) )
	.db	00000000b
	.db	00000000b
	.db	11000000b
	.db	01100000b
	.db	00110000b
	.db	00110000b
	.db	00110000b
	.db	00110000b
	.db	00110000b
	.db	01100000b
	.db	11000000b
	.db	00000000b
	.db	00000000b
	.db	00000000b
fontChar2A: ; * *
	.db	00000000b
	.db	00000000b
	.db	00000000b
	.db	00000000b
	.db	01101100b
	.db	00111000b
	.db	11111110b
	.db	00111000b
	.db	01101100b
	.db	00000000b
	.db	00000000b
	.db	00000000b
	.db	00000000b
	.db	00000000b
fontChar2B: ; + +
	.db	00000000b
	.db	00000000b
	.db	00000000b
	.db	00000000b
	.db	00110000b
	.db	00110000b
	.db	11111100b
	.db	00110000b
	.db	00110000b
	.db	00000000b
	.db	00000000b
	.db	00000000b
	.db	00000000b
	.db	00000000b
fontChar2C: ; , ,
	.db	00000000b
	.db	00000000b
	.db	00000000b
	.db	00000000b
	.db	00000000b
	.db	00000000b
	.db	00000000b
	.db	00000000b
	.db	01100000b
	.db	01100000b
	.db	01100000b
	.db	11000000b
	.db	00000000b
	.db	00000000b
fontChar2D: ; - -
	.db	00000000b
	.db	00000000b
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
	.db	00000000b
	.db	00000000b
fontChar2E: ; . .
	.db	00000000b
	.db	00000000b
	.db	00000000b
	.db	00000000b
	.db	00000000b
	.db	00000000b
	.db	00000000b
	.db	00000000b
	.db	00000000b
	.db	11000000b
	.db	11000000b
	.db	00000000b
	.db	00000000b
	.db	00000000b
fontChar2F: ; / /
	.db	00000000b
	.db	00000000b
	.db	00010000b
	.db	00010000b
	.db	00110000b
	.db	00110000b
	.db	01100000b
	.db	01100000b
	.db	11000000b
	.db	11000000b
	.db	10000000b
	.db	10000000b
	.db	00000000b
	.db	00000000b
fontChar30: ; 0 0
	.db	00000000b
	.db	00000000b
	.db	01111000b
	.db	11001100b
	.db	11001100b
	.db	11011100b
	.db	11111100b
	.db	11101100b
	.db	11001100b
	.db	11001100b
	.db	01111000b
	.db	00000000b
	.db	00000000b
	.db	00000000b
fontChar31: ; 1 1
	.db	00000000b
	.db	00000000b
	.db	00110000b
	.db	01110000b
	.db	01110000b
	.db	00110000b
	.db	00110000b
	.db	00110000b
	.db	00110000b
	.db	00110000b
	.db	01111000b
	.db	00000000b
	.db	00000000b
	.db	00000000b
fontChar32: ; 2 2
	.db	00000000b
	.db	00000000b
	.db	01111000b
	.db	11001100b
	.db	00001100b
	.db	00011000b
	.db	00110000b
	.db	01100000b
	.db	11000000b
	.db	11001100b
	.db	11111100b
	.db	00000000b
	.db	00000000b
	.db	00000000b
fontChar33: ; 3 3
	.db	00000000b
	.db	00000000b
	.db	01111000b
	.db	11001100b
	.db	00001100b
	.db	00001100b
	.db	00111000b
	.db	00001100b
	.db	00001100b
	.db	11001100b
	.db	01111000b
	.db	00000000b
	.db	00000000b
	.db	00000000b
fontChar34: ; 4 4
	.db	00000000b
	.db	00000000b
	.db	00011000b
	.db	00111000b
	.db	01111000b
	.db	11011000b
	.db	11011000b
	.db	11111100b
	.db	00011000b
	.db	00011000b
	.db	00111100b
	.db	00000000b
	.db	00000000b
	.db	00000000b
fontChar35: ; 5 5
	.db	00000000b
	.db	00000000b
	.db	11111100b
	.db	11000000b
	.db	11000000b
	.db	11000000b
	.db	11111000b
	.db	00001100b
	.db	00001100b
	.db	11001100b
	.db	01111000b
	.db	00000000b
	.db	00000000b
	.db	00000000b
fontChar36: ; 6 6
	.db	00000000b
	.db	00000000b
	.db	00111000b
	.db	01100000b
	.db	11000000b
	.db	11000000b
	.db	11111000b
	.db	11001100b
	.db	11001100b
	.db	11001100b
	.db	01111000b
	.db	00000000b
	.db	00000000b
	.db	00000000b
fontChar37: ; 7 7
	.db	00000000b
	.db	00000000b
	.db	11111100b
	.db	11001100b
	.db	00001100b
	.db	00011000b
	.db	00110000b
	.db	00110000b
	.db	00110000b
	.db	00110000b
	.db	00110000b
	.db	00000000b
	.db	00000000b
	.db	00000000b
fontChar38: ; 8 8
	.db	00000000b
	.db	00000000b
	.db	01111000b
	.db	11001100b
	.db	11001100b
	.db	11001100b
	.db	01111000b
	.db	11001100b
	.db	11001100b
	.db	11001100b
	.db	01111000b
	.db	00000000b
	.db	00000000b
	.db	00000000b
fontChar39: ; 9 9
	.db	00000000b
	.db	00000000b
	.db	01111000b
	.db	11001100b
	.db	11001100b
	.db	11001100b
	.db	01111100b
	.db	00001100b
	.db	00001100b
	.db	00011000b
	.db	01110000b
	.db	00000000b
	.db	00000000b
	.db	00000000b
fontChar3A: ; : :
	.db	00000000b
	.db	00000000b
	.db	00000000b
	.db	11000000b
	.db	11000000b
	.db	00000000b
	.db	00000000b
	.db	00000000b
	.db	11000000b
	.db	11000000b
	.db	00000000b
	.db	00000000b
	.db	00000000b
	.db	00000000b
fontChar3B: ; ; ;
	.db	00000000b
	.db	00000000b
	.db	00000000b
	.db	01100000b
	.db	01100000b
	.db	00000000b
	.db	00000000b
	.db	00000000b
	.db	01100000b
	.db	01100000b
	.db	11000000b
	.db	00000000b
	.db	00000000b
	.db	00000000b
fontChar3C: ; < <
	.db	00000000b
	.db	00000000b
	.db	00001100b
	.db	00011000b
	.db	00110000b
	.db	01100000b
	.db	11000000b
	.db	01100000b
	.db	00110000b
	.db	00011000b
	.db	00001100b
	.db	00000000b
	.db	00000000b
	.db	00000000b
fontChar3D: ; = =
	.db	00000000b
	.db	00000000b
	.db	00000000b
	.db	00000000b
	.db	00000000b
	.db	11111100b
	.db	00000000b
	.db	00000000b
	.db	11111100b
	.db	00000000b
	.db	00000000b
	.db	00000000b
	.db	00000000b
	.db	00000000b
fontChar3E: ; > >
	.db	00000000b
	.db	00000000b
	.db	11000000b
	.db	01100000b
	.db	00110000b
	.db	00011000b
	.db	00001100b
	.db	00011000b
	.db	00110000b
	.db	01100000b
	.db	11000000b
	.db	00000000b
	.db	00000000b
	.db	00000000b
fontChar3F: ; ? ?
	.db	00000000b
	.db	00000000b
	.db	01111000b
	.db	11001100b
	.db	11001100b
	.db	00011000b
	.db	00110000b
	.db	00110000b
	.db	00000000b
	.db	00110000b
	.db	00110000b
	.db	00000000b
	.db	00000000b
	.db	00000000b
fontChar40: ; @ @
	.db	00000000b
	.db	00000000b
	.db	01111100b
	.db	11000110b
	.db	11000110b
	.db	11011110b
	.db	11011110b
	.db	11011110b
	.db	11011100b
	.db	11000000b
	.db	01111110b
	.db	00000000b
	.db	00000000b
	.db	00000000b
fontChar41: ; A A
	.db	00000000b
	.db	00000000b
	.db	00110000b
	.db	01111000b
	.db	11001100b
	.db	11001100b
	.db	11111100b
	.db	11001100b
	.db	11001100b
	.db	11001100b
	.db	11001100b
	.db	00000000b
	.db	00000000b
	.db	00000000b
fontChar42: ; B B
	.db	00000000b
	.db	00000000b
	.db	11111000b
	.db	11001100b
	.db	11001100b
	.db	11001100b
	.db	11111000b
	.db	11001100b
	.db	11001100b
	.db	11001100b
	.db	11111000b
	.db	00000000b
	.db	00000000b
	.db	00000000b
fontChar43: ; C C
	.db	00000000b
	.db	00000000b
	.db	00111000b
	.db	01101100b
	.db	11000100b
	.db	11000000b
	.db	11000000b
	.db	11000000b
	.db	11000100b
	.db	01101100b
	.db	00111000b
	.db	00000000b
	.db	00000000b
	.db	00000000b
fontChar44: ; D D
	.db	00000000b
	.db	00000000b
	.db	11110000b
	.db	11011000b
	.db	11001100b
	.db	11001100b
	.db	11001100b
	.db	11001100b
	.db	11001100b
	.db	11011000b
	.db	11110000b
	.db	00000000b
	.db	00000000b
	.db	00000000b
fontChar45: ; E E
	.db	00000000b
	.db	00000000b
	.db	11111100b
	.db	11000000b
	.db	11000000b
	.db	11000000b
	.db	11111000b
	.db	11000000b
	.db	11000000b
	.db	11000000b
	.db	11111100b
	.db	00000000b
	.db	00000000b
	.db	00000000b
fontChar46: ; F F
	.db	00000000b
	.db	00000000b
	.db	11111100b
	.db	11000000b
	.db	11000000b
	.db	11000000b
	.db	11111000b
	.db	11000000b
	.db	11000000b
	.db	11000000b
	.db	11000000b
	.db	00000000b
	.db	00000000b
	.db	00000000b
fontChar47: ; G G
	.db	00000000b
	.db	00000000b
	.db	00111100b
	.db	01100110b
	.db	11000010b
	.db	11000000b
	.db	11000000b
	.db	11001110b
	.db	11000110b
	.db	01100110b
	.db	00111010b
	.db	00000000b
	.db	00000000b
	.db	00000000b
fontChar48: ; H H
	.db	00000000b
	.db	00000000b
	.db	11001100b
	.db	11001100b
	.db	11001100b
	.db	11001100b
	.db	11111100b
	.db	11001100b
	.db	11001100b
	.db	11001100b
	.db	11001100b
	.db	00000000b
	.db	00000000b
	.db	00000000b
fontChar49: ; I I
	.db	00000000b
	.db	00000000b
	.db	11110000b
	.db	01100000b
	.db	01100000b
	.db	01100000b
	.db	01100000b
	.db	01100000b
	.db	01100000b
	.db	01100000b
	.db	11110000b
	.db	00000000b
	.db	00000000b
	.db	00000000b
fontChar4A: ; J J
	.db	00000000b
	.db	00000000b
	.db	00111100b
	.db	00011000b
	.db	00011000b
	.db	00011000b
	.db	00011000b
	.db	00011000b
	.db	11011000b
	.db	11011000b
	.db	01110000b
	.db	00000000b
	.db	00000000b
	.db	00000000b
fontChar4B: ; K K
	.db	00000000b
	.db	00000000b
	.db	11001100b
	.db	11001100b
	.db	11011000b
	.db	11011000b
	.db	11110000b
	.db	11011000b
	.db	11011000b
	.db	11001100b
	.db	11001100b
	.db	00000000b
	.db	00000000b
	.db	00000000b
fontChar4C: ; L L
	.db	00000000b
	.db	00000000b
	.db	11000000b
	.db	11000000b
	.db	11000000b
	.db	11000000b
	.db	11000000b
	.db	11000000b
	.db	11000000b
	.db	11000000b
	.db	11111000b
	.db	00000000b
	.db	00000000b
	.db	00000000b
fontChar4D: ; M M
	.db	00000000b, 00000000b
	.db	00000000b, 00000000b
	.db	11000001b, 10000000b
	.db	11000001b, 10000000b
	.db	11100011b, 10000000b
	.db	11110111b, 10000000b
	.db	11011101b, 10000000b
	.db	11001001b, 10000000b
	.db	11000001b, 10000000b
	.db	11000001b, 10000000b
	.db	11000001b, 10000000b
	.db	00000000b, 00000000b
	.db	00000000b, 00000000b
	.db	00000000b, 00000000b
fontChar4E: ; N N
	.db	00000000b
	.db	00000000b
	.db	11000110b
	.db	11000110b
	.db	11100110b
	.db	11110110b
	.db	11011110b
	.db	11001110b
	.db	11000110b
	.db	11000110b
	.db	11000110b
	.db	00000000b
	.db	00000000b
	.db	00000000b
fontChar4F: ; O O
	.db	00000000b
	.db	00000000b
	.db	00111000b
	.db	01101100b
	.db	11000110b
	.db	11000110b
	.db	11000110b
	.db	11000110b
	.db	11000110b
	.db	01101100b
	.db	00111000b
	.db	00000000b
	.db	00000000b
	.db	00000000b
fontChar50: ; P P
	.db	00000000b
	.db	00000000b
	.db	11111000b
	.db	11001100b
	.db	11001100b
	.db	11001100b
	.db	11111000b
	.db	11000000b
	.db	11000000b
	.db	11000000b
	.db	11000000b
	.db	00000000b
	.db	00000000b
	.db	00000000b
fontChar51: ; Q Q
	.db	00000000b
	.db	00000000b
	.db	01111100b
	.db	11000110b
	.db	11000110b
	.db	11000110b
	.db	11000110b
	.db	11010110b
	.db	11011110b
	.db	01111100b
	.db	00001100b
	.db	00001110b
	.db	00000000b
	.db	00000000b
fontChar52: ; R R
	.db	00000000b
	.db	00000000b
	.db	11111000b
	.db	11001100b
	.db	11001100b
	.db	11001100b
	.db	11111000b
	.db	11011000b
	.db	11001100b
	.db	11001100b
	.db	11001100b
	.db	00000000b
	.db	00000000b
	.db	00000000b
fontChar53: ; S S
	.db	00000000b
	.db	00000000b
	.db	01111000b
	.db	11001100b
	.db	11001100b
	.db	01100000b
	.db	00110000b
	.db	00011000b
	.db	11001100b
	.db	11001100b
	.db	01111000b
	.db	00000000b
	.db	00000000b
	.db	00000000b
fontChar54: ; T T
	.db	00000000b
	.db	00000000b
	.db	11111100b
	.db	00110000b
	.db	00110000b
	.db	00110000b
	.db	00110000b
	.db	00110000b
	.db	00110000b
	.db	00110000b
	.db	00110000b
	.db	00000000b
	.db	00000000b
	.db	00000000b
fontChar55: ; U U
	.db	00000000b
	.db	00000000b
	.db	11001100b
	.db	11001100b
	.db	11001100b
	.db	11001100b
	.db	11001100b
	.db	11001100b
	.db	11001100b
	.db	11001100b
	.db	01111000b
	.db	00000000b
	.db	00000000b
	.db	00000000b
fontChar56: ; V V
	.db	00000000b
	.db	00000000b
	.db	11001100b
	.db	11001100b
	.db	11001100b
	.db	11001100b
	.db	11001100b
	.db	11001100b
	.db	11001100b
	.db	01111000b
	.db	00110000b
	.db	00000000b
	.db	00000000b
	.db	00000000b
fontChar57: ; W W
	.db	00000000b, 00000000b
	.db	00000000b, 00000000b
	.db	11000011b, 00000000b
	.db	11000011b, 00000000b
	.db	11000011b, 00000000b
	.db	11011011b, 00000000b
	.db	11011011b, 00000000b
	.db	11011011b, 00000000b
	.db	11111111b, 00000000b
	.db	01100110b, 00000000b
	.db	01100110b, 00000000b
	.db	00000000b, 00000000b
	.db	00000000b, 00000000b
	.db	00000000b, 00000000b
fontChar58: ; X X
	.db	00000000b
	.db	00000000b
	.db	11000110b
	.db	11000110b
	.db	01101100b
	.db	00111000b
	.db	00111000b
	.db	00111000b
	.db	01101100b
	.db	11000110b
	.db	11000110b
	.db	00000000b
	.db	00000000b
	.db	00000000b
fontChar59: ; Y Y
	.db	00000000b
	.db	00000000b
	.db	11001100b
	.db	11001100b
	.db	11001100b
	.db	11001100b
	.db	01111000b
	.db	00110000b
	.db	00110000b
	.db	00110000b
	.db	00110000b
	.db	00000000b
	.db	00000000b
	.db	00000000b
fontChar5A: ; Z Z
	.db	00000000b
	.db	00000000b
	.db	11111110b
	.db	00000110b
	.db	00001100b
	.db	00011000b
	.db	00110000b
	.db	01100000b
	.db	11000000b
	.db	11000000b
	.db	11111110b
	.db	00000000b
	.db	00000000b
	.db	00000000b
fontChar5B: ; [ [
	.db	00000000b
	.db	00000000b
	.db	11110000b
	.db	11000000b
	.db	11000000b
	.db	11000000b
	.db	11000000b
	.db	11000000b
	.db	11000000b
	.db	11000000b
	.db	11110000b
	.db	00000000b
	.db	00000000b
	.db	00000000b
fontChar5C: ; \ \
	.db	00000000b
	.db	00000000b
	.db	10000000b
	.db	10000000b
	.db	11000000b
	.db	11000000b
	.db	01100000b
	.db	01100000b
	.db	00110000b
	.db	00110000b
	.db	00010000b
	.db	00010000b
	.db	00000000b
	.db	00000000b
fontChar5D: ; ] ]
	.db	00000000b
	.db	00000000b
	.db	11110000b
	.db	00110000b
	.db	00110000b
	.db	00110000b
	.db	00110000b
	.db	00110000b
	.db	00110000b
	.db	00110000b
	.db	11110000b
	.db	00000000b
	.db	00000000b
	.db	00000000b
fontChar5E: ; ^ ^
	.db	00100000b
	.db	01110000b
	.db	11011000b
	.db	10001000b
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
fontChar5F: ; _ _
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
	.db	00000000b
	.db	00000000b
	.db	11111110b
	.db	00000000b
fontChar60: ; ` `
	.db	11000000b
	.db	11000000b
	.db	01100000b
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
	.db	00000000b
fontChar61: ; a a
	.db	00000000b
	.db	00000000b
	.db	00000000b
	.db	00000000b
	.db	00000000b
	.db	01111000b
	.db	00001100b
	.db	01111100b
	.db	11001100b
	.db	11001100b
	.db	01111100b
	.db	00000000b
	.db	00000000b
	.db	00000000b
fontChar62: ; b b
	.db	00000000b
	.db	00000000b
	.db	11000000b
	.db	11000000b
	.db	11000000b
	.db	11110000b
	.db	11011000b
	.db	11001100b
	.db	11001100b
	.db	11001100b
	.db	11111000b
	.db	00000000b
	.db	00000000b
	.db	00000000b
fontChar63: ; c c
	.db	00000000b
	.db	00000000b
	.db	00000000b
	.db	00000000b
	.db	00000000b
	.db	01111000b
	.db	11001100b
	.db	11000000b
	.db	11000000b
	.db	11001100b
	.db	01111000b
	.db	00000000b
	.db	00000000b
	.db	00000000b
fontChar64: ; d d
	.db	00000000b
	.db	00000000b
	.db	00001100b
	.db	00001100b
	.db	00001100b
	.db	00111100b
	.db	01101100b
	.db	11001100b
	.db	11001100b
	.db	11001100b
	.db	01111100b
	.db	00000000b
	.db	00000000b
	.db	00000000b
fontChar65: ; e e
	.db	00000000b
	.db	00000000b
	.db	00000000b
	.db	00000000b
	.db	00000000b
	.db	01111000b
	.db	11001100b
	.db	11111100b
	.db	11000000b
	.db	11001100b
	.db	01111000b
	.db	00000000b
	.db	00000000b
	.db	00000000b
fontChar66: ; f f
	.db	00000000b
	.db	00000000b
	.db	00111000b
	.db	01101100b
	.db	01100100b
	.db	01100000b
	.db	11110000b
	.db	01100000b
	.db	01100000b
	.db	01100000b
	.db	01100000b
	.db	00000000b
	.db	00000000b
	.db	00000000b
fontChar67: ; g g
	.db	00000000b
	.db	00000000b
	.db	00000000b
	.db	00000000b
	.db	00000000b
	.db	01111100b
	.db	11001100b
	.db	11001100b
	.db	11001100b
	.db	01111100b
	.db	00001100b
	.db	11001100b
	.db	01111000b
	.db	00000000b
fontChar68: ; h h
	.db	00000000b
	.db	00000000b
	.db	11000000b
	.db	11000000b
	.db	11000000b
	.db	11011000b
	.db	11101100b
	.db	11001100b
	.db	11001100b
	.db	11001100b
	.db	11001100b
	.db	00000000b
	.db	00000000b
	.db	00000000b
fontChar69: ; i i
	.db	00000000b
	.db	00000000b
	.db	11000000b
	.db	11000000b
	.db	00000000b
	.db	11000000b
	.db	11000000b
	.db	11000000b
	.db	11000000b
	.db	11000000b
	.db	11000000b
	.db	00000000b
	.db	00000000b
	.db	00000000b
fontChar6A: ; j j
	.db	00000000b
	.db	00000000b
	.db	00011000b
	.db	00011000b
	.db	00000000b
	.db	00011000b
	.db	00011000b
	.db	00011000b
	.db	00011000b
	.db	00011000b
	.db	11011000b
	.db	11011000b
	.db	01110000b
	.db	00000000b
fontChar6B: ; k k
	.db	00000000b
	.db	00000000b
	.db	11000000b
	.db	11000000b
	.db	11000000b
	.db	11001100b
	.db	11011000b
	.db	11110000b
	.db	11011000b
	.db	11001100b
	.db	11001100b
	.db	00000000b
	.db	00000000b
	.db	00000000b
fontChar6C: ; l l
	.db	00000000b
	.db	00000000b
	.db	11000000b
	.db	11000000b
	.db	11000000b
	.db	11000000b
	.db	11000000b
	.db	11000000b
	.db	11000000b
	.db	11000000b
	.db	11000000b
	.db	00000000b
	.db	00000000b
	.db	00000000b
fontChar6D: ; m m
	.db	00000000b, 00000000b
	.db	00000000b, 00000000b
	.db	00000000b, 00000000b
	.db	00000000b, 00000000b
	.db	00000000b, 00000000b
	.db	11100110b, 00000000b
	.db	11111111b, 00000000b
	.db	11011011b, 00000000b
	.db	11011011b, 00000000b
	.db	11011011b, 00000000b
	.db	11011011b, 00000000b
	.db	00000000b, 00000000b
	.db	00000000b, 00000000b
	.db	00000000b, 00000000b
fontChar6E: ; n n
	.db	00000000b
	.db	00000000b
	.db	00000000b
	.db	00000000b
	.db	00000000b
	.db	11011000b
	.db	11101100b
	.db	11001100b
	.db	11001100b
	.db	11001100b
	.db	11001100b
	.db	00000000b
	.db	00000000b
	.db	00000000b
fontChar6F: ; o o
	.db	00000000b
	.db	00000000b
	.db	00000000b
	.db	00000000b
	.db	00000000b
	.db	01111000b
	.db	11001100b
	.db	11001100b
	.db	11001100b
	.db	11001100b
	.db	01111000b
	.db	00000000b
	.db	00000000b
	.db	00000000b
fontChar70: ; p p
	.db	00000000b
	.db	00000000b
	.db	00000000b
	.db	00000000b
	.db	00000000b
	.db	11011000b
	.db	11101100b
	.db	11001100b
	.db	11001100b
	.db	11110000b
	.db	11000000b
	.db	11000000b
	.db	11000000b
	.db	00000000b
fontChar71: ; q q
	.db	00000000b
	.db	00000000b
	.db	00000000b
	.db	00000000b
	.db	00000000b
	.db	01101100b
	.db	11011100b
	.db	11001100b
	.db	11001100b
	.db	01111100b
	.db	00001100b
	.db	00001100b
	.db	00001100b
	.db	00000000b
fontChar72: ; r r
	.db	00000000b
	.db	00000000b
	.db	00000000b
	.db	00000000b
	.db	00000000b
	.db	11011000b
	.db	11101100b
	.db	11001100b
	.db	11000000b
	.db	11000000b
	.db	11000000b
	.db	00000000b
	.db	00000000b
	.db	00000000b
fontChar73: ; s s
	.db	00000000b
	.db	00000000b
	.db	00000000b
	.db	00000000b
	.db	00000000b
	.db	01111000b
	.db	11001100b
	.db	01100000b
	.db	00011000b
	.db	11001100b
	.db	01111000b
	.db	00000000b
	.db	00000000b
	.db	00000000b
fontChar74: ; t t
	.db	00000000b
	.db	00000000b
	.db	01100000b
	.db	01100000b
	.db	01100000b
	.db	11110000b
	.db	01100000b
	.db	01100000b
	.db	01100000b
	.db	01100000b
	.db	00110000b
	.db	00000000b
	.db	00000000b
	.db	00000000b
fontChar75: ; u u
	.db	00000000b
	.db	00000000b
	.db	00000000b
	.db	00000000b
	.db	00000000b
	.db	11001100b
	.db	11001100b
	.db	11001100b
	.db	11001100b
	.db	11011100b
	.db	01101100b
	.db	00000000b
	.db	00000000b
	.db	00000000b
fontChar76: ; v v
	.db	00000000b
	.db	00000000b
	.db	00000000b
	.db	00000000b
	.db	00000000b
	.db	11000110b
	.db	11000110b
	.db	11000110b
	.db	01101100b
	.db	00111000b
	.db	00010000b
	.db	00000000b
	.db	00000000b
	.db	00000000b
fontChar77: ; w w
	.db	00000000b, 00000000b
	.db	00000000b, 00000000b
	.db	00000000b, 00000000b
	.db	00000000b, 00000000b
	.db	00000000b, 00000000b
	.db	11000011b, 00000000b
	.db	11000011b, 00000000b
	.db	11011011b, 00000000b
	.db	11011011b, 00000000b
	.db	11111111b, 00000000b
	.db	01100110b, 00000000b
	.db	00000000b, 00000000b
	.db	00000000b, 00000000b
	.db	00000000b, 00000000b
fontChar78: ; x x
	.db	00000000b
	.db	00000000b
	.db	00000000b
	.db	00000000b
	.db	00000000b
	.db	11000110b
	.db	01101100b
	.db	00111000b
	.db	00111000b
	.db	01101100b
	.db	11000110b
	.db	00000000b
	.db	00000000b
	.db	00000000b
fontChar79: ; y y
	.db	00000000b
	.db	00000000b
	.db	00000000b
	.db	00000000b
	.db	00000000b
	.db	11001100b
	.db	11001100b
	.db	11001100b
	.db	11001100b
	.db	01111100b
	.db	00001100b
	.db	00011000b
	.db	01110000b
	.db	00000000b
fontChar7A: ; z z
	.db	00000000b
	.db	00000000b
	.db	00000000b
	.db	00000000b
	.db	00000000b
	.db	11111000b
	.db	00011000b
	.db	00110000b
	.db	01100000b
	.db	11000000b
	.db	11111000b
	.db	00000000b
	.db	00000000b
	.db	00000000b
fontChar7B: ; { {
	.db	00000000b
	.db	00000000b
	.db	00111000b
	.db	01100000b
	.db	01100000b
	.db	01100000b
	.db	11000000b
	.db	01100000b
	.db	01100000b
	.db	01100000b
	.db	00111000b
	.db	00000000b
	.db	00000000b
	.db	00000000b
fontChar7C: ; | |
	.db	00000000b
	.db	00000000b
	.db	11000000b
	.db	11000000b
	.db	11000000b
	.db	11000000b
	.db	11000000b
	.db	11000000b
	.db	11000000b
	.db	11000000b
	.db	11000000b
	.db	00000000b
	.db	00000000b
	.db	00000000b
fontChar7D: ; } }
	.db	00000000b
	.db	00000000b
	.db	11000000b
	.db	01100000b
	.db	01100000b
	.db	01100000b
	.db	00110000b
	.db	01100000b
	.db	01100000b
	.db	01100000b
	.db	11000000b
	.db	00000000b
	.db	00000000b
	.db	00000000b
fontChar7E: ; ~ ~
	.db	00000000b
	.db	00000000b
	.db	01110110b
	.db	11011100b
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
fontChar7F: ; Thick space
	.db	00000000b, 00000000b
	.db	00000000b, 00000000b
	.db	00000000b, 00000000b
	.db	00000000b, 00000000b
	.db	00000000b, 00000000b
	.db	00000000b, 00000000b
	.db	00000000b, 00000000b
	.db	00000000b, 00000000b
	.db	00000000b, 00000000b
	.db	00000000b, 00000000b
	.db	00000000b, 00000000b
	.db	00000000b, 00000000b
	.db	00000000b, 00000000b
	.db	00000000b, 00000000b
