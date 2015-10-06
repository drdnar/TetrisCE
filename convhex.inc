#IFNDEF CONVHEX_INC

#DEFINE CONVHEX_INC

;convhex.inc
;By Galandros (with help of NanoWar and Spencer)
;You can now echo in hex! yay

#macro zconvhex(hexn)
#if hex_remain == 0
   "$",return
#else
 #define hex_digit eval(hexn & $0F)
 #define hex_remain eval(hexn/16)
 #ifndef return
   #define return ""
 #endif
    #if hex_digit == 0
      #define hex_char "0"
    #endif
    #if hex_digit == 1
      #define hex_char "1"
    #endif
    #if hex_digit == 2
      #define hex_char "2"
    #endif
    #if hex_digit == 3
      #define hex_char "3"
    #endif
    #if hex_digit == 4
      #define hex_char "4"
    #endif
    #if hex_digit == 5
      #define hex_char "5"
    #endif
    #if hex_digit == 6
      #define hex_char "6"
    #endif
    #if hex_digit == 7
      #define hex_char "7"
    #endif
    #if hex_digit == 8
      #define hex_char "8"
    #endif
    #if hex_digit == 9
      #define hex_char "9"
    #endif
    #if hex_digit == 10
      #define hex_char "A"
    #endif
    #if hex_digit == 11
      #define hex_char "B"
    #endif
    #if hex_digit == 12
      #define hex_char "C"
    #endif
    #if hex_digit == 13
      #define hex_char "D"
    #endif
    #if hex_digit == 14
      #define hex_char "E"
    #endif
    #if hex_digit == 15
      #define hex_char "F"
    #endif

 #define return eval(hex_char,return)
 zconvhex(eval(hex_remain))
#endif
#endmacro

;wrap the main macro up with another macro to clear the global defines to work more times
#macro convhex(zn)
  #define hex_remain -1
  #define return ""
  zconvhex(zn)
#endmacro

#ENDIF