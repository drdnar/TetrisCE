; TI-84 Plus CE Include file
; Various parts contributed by
;  - BrandonW
;  - calc84
;  - tr1p1ea
;  - Texas Instruments (parts recycled from ti83plus.inc)
.nolist
#ifndef TI84PCE
#define TI84PCE
;===============================================================================
;====== Include Stuff ==========================================================
;===============================================================================

;Included for TASM Compatibility
;-------------------------------
#define equ .equ
#define EQU .equ
#define end .end
#define END .end
#define L_BYTE(x) (x)
#define H_BYTE(x) ((x >> 8) & 255)
#define U_BYTE(x) ((x >> 16) & 255)

lcdWidth        EQU      320
lcdHeight       EQU      240

;====== Ports ==================================================================
pCpuSpeed               EQU 0001
pHardwareId             EQU 0003
pUsbRange               EQU 3000h
; LCD ports
pLcdCtrlRange           EQU 4000h
mpLcdCtrlRange          EQU 0E30000h
pLcdBase                EQU 4010h
mpLcdBase               EQU 0E30010h

pLcdCtrl                EQU 4018h
mpLcdCtrl               EQU 0E30018h
; Bits [7:6] and [4] are not valid for our LCD
lcdEn                   EQU 1
lcdTft                  EQU 20h
lcdBpp1                 EQU 0000b | lcdTft | lcdEn
lcdBpp2                 EQU 0010b | lcdTft | lcdEn
lcdBpp4                 EQU 0100b | lcdTft | lcdEn
lcdBpp8                 EQU 0110b | lcdTft | lcdEn
lcdBpp16Alt             EQU 1000b | lcdTft | lcdEn
lcdBpp24                EQU 1010b | lcdTft | lcdEn
lcdBpp16                EQU 1100b | lcdTft | lcdEn ; Default
lcdBpp12                EQU 1110b | lcdTft | lcdEn
lcdBgr                  EQU 100h
lcdBigEndian            EQU 200h
lcdBigEndianPixels      EQU 400h
lcdPwr                  EQU 800h
lcdIntVSync             EQU 0
lcdIntBack              EQU 1000h
lcdIntActiveVideo       EQU 2000h
lcdIntFront             EQU 4000h
lcdWatermark            EQU 10000h
lcdNormalMode           EQU lcdPwr | lcdBgr | lcdBpp16

pLcdPalette             EQU 4200h
mpLcdPalette            EQU 0E30200h
pLcdCursorImg           EQU 4800h
mpLcdCursorImg          EQU 0E30800h
pLcdCrsrCtrl            EQU 4C00h
mpLcdCrsrCtrl           EQU 0E30C00h
pLcdCrsrConfig          EQU 4C04h
mpLcdCrsrConfig         EQU 0E30C04h
pLcdCrsrPal0            EQU 4C08h
mpLcdCrsrPal0           EQU 0E30C08h
pLcdCrsrPal1            EQU 4C0Ch
mpLcdCrsrPal1           EQU 0E30C0Ch
pLcdCrsrXy              EQU 4C10h
mpLcdCrsrXy             EQU 0E30C10h
pLcdCrsrClip            EQU 4C14h
mpLcdCrsrClip           EQU 0E30C14h
; Timers
pTimersRange            EQU 7000h
mpTimersRange           EQU 0F20000h
pTimer1Count            EQU (pTimersRange + 00h)
mpTimer1Count           EQU (mpTimersRange + 00h)
pTimer2Count            EQU (pTimersRange + 10h)
mpTimer2Count           EQU (mpTimersRange + 10h)
pTimer3Count            EQU (pTimersRange + 20h)
mpTimer3Count           EQU (mpTimersRange + 20h)
pTimer1ResetValue       EQU (pTimersRange + 04h)
mpTimer1ResetValue      EQU (mpTimersRange + 04h)
pTimer2ResetValue       EQU (pTimersRange + 14h)
mpTimer2ResetValue      EQU (mpTimersRange + 14h)
pTimer3ResetValue       EQU (pTimersRange + 24h)
mpTimer3ResetValue      EQU (mpTimersRange + 24h)
pTimer1AlarmValue1      EQU (pTimersRange + 08h)
mpTimer1AlarmValue1     EQU (mpTimersRange + 08h)
pTimer1AlarmValue2      EQU (pTimersRange + 0Ch)
mpTimer1AlarmValue2     EQU (mpTimersRange + 0Ch)
pTimer2AlarmValue1      EQU (pTimersRange + 18h)
mpTimer2AlarmValue1     EQU (mpTimersRange + 18h)
pTimer2AlarmValue2      EQU (pTimersRange + 1Ch)
mpTimer2AlarmValue2     EQU (mpTimersRange + 1Ch)
pTimer3AlarmValue1      EQU (pTimersRange + 28h)
mpTimer3AlarmValue1     EQU (mpTimersRange + 28h)
pTimer3AlarmValue2      EQU (pTimersRange + 2Ch)
mpTimer3AlarmValue2     EQU (mpTimersRange + 2Ch)
pTimersControlRegister  EQU (pTimersRange + 30h)
mpTimersControlRegister EQU (mpTimersRange + 30h)
bTimer1Enable           EQU 0
mTimer1Enable           EQU (1 << bTimer1Enable)
bTimer2Enable           EQU 3
mTimer2Enable           EQU (1 << bTimer2Enable)
bTimer3Enable           EQU 6
mTimer3Enable           EQU (1 << bTimer3Enable)
bTimer1SrcCrystal       EQU 1
mTimer1SrcCrystal       EQU (1 << bTimer1SrcCrystal)
bTimer2SrcCrystal       EQU 4
mTimer2SrcCrystal       EQU (1 << bTimer2SrcCrystal)
bTimer3SrcCrystal       EQU 7
mTimer3SrcCrystal       EQU (1 << bTimer3SrcCrystal)
bTimer1InterruptEnable  EQU 2
mTimer1InterruptEnable  EQU (1 << bTimer1InterruptEnable)
bTimer2InterruptEnable  EQU 5
mTimer2InterruptEnable  EQU (1 << bTimer2InterruptEnable)
bTimer3InterruptEnable  EQU 8
mTimer3InterruptEnable  EQU (1 << bTimer3InterruptEnable)
bTimer1CountUp          EQU 9
mTimer1CountUp          EQU (1 << bTimer1CountUp)
bTimer2CountUp          EQU 10
mTimer2CountUp          EQU (1 << bTimer1CountUp)
bTimer3CountUp          EQU 11
mTimer3CountUp          EQU (1 << bTimer1CountUp)
pTimersInterruptStatus  EQU (pTimersRange + 34h)
mpTimersInterruptStatus EQU (mpTimersRange + 34h)
bTimer1Alarm1           EQU 0
mTimer1Alarm1           EQU (1 << bTimer1Alarm1)
bTimer1Alarm2           EQU 1
mTimer1Alarm2           EQU (1 << bTimer1Alarm2)
bTimer1Overflow         EQU 2
mTimer1Overflow         EQU (1 << bTimer1Overflow)
bTimer2Alarm1           EQU 3
mTimer2Alarm1           EQU (1 << bTimer2Alarm1)
bTimer2Alarm2           EQU 4
mTimer2Alarm2           EQU (1 << bTimer2Alarm2)
bTimer2Overflow         EQU 5
mTimer2Overflow         EQU (1 << bTimer2Overflow)
bTimer3Alarm1           EQU 6
mTimer3Alarm1           EQU (1 << bTimer3Alarm1)
bTimer3Alarm2           EQU 7
mTimer3Alarm2           EQU (1 << bTimer3Alarm2)
bTimer3Overflow         EQU 8
mTimer3Overflow         EQU (1 << bTimer3Overflow)


; RTC
pRtcRange               EQU 8000h
mpRtcRange              EQU 0F30000h
mpRtcSeconds		EQU (mpRtcRange + 0)
mpRtcMinutes		EQU (mpRtcRange + 4)
mpRtcHours		EQU (mpRtcRange + 8)
mpRtcDays		EQU (mpRtcRange + 12)

pKbdRange               EQU 0A000h
mpKbdRange              EQU 0F50000h
pBlLevel                EQU 0B024h
mpBlLevel               EQU 0F60024h

;====== Boot Calls =============================================================
_getBootVerMajor EQU 0000080h
_getHardwareVersion EQU 0000084h
_getKeyID        EQU 0000088h
_getBootVerMinor EQU 000008Ch
_getBootVerBuild EQU 0000090h
;0000094h ;outputs A to 0FFFEh and locks up, only on certain hardware revision?
_memchr         EQU  000009Ch
_memcmp         EQU  00000A0h
_memcpy         EQU  00000A4h
_memmove        EQU  00000A8h
_memset         EQU  00000ACh
_memclear       EQU  00000B0h
_DoNothing      EQU  00000F8h
_setjmp         EQU  00000B8h
_longjmp        EQU  0000098h
_sprintf        EQU  00000BCh
_strcat         EQU  00000C0h
_strchr         EQU  00000C4h
_strcmp         EQU  00000C8h
_strcpy         EQU  00000CCh
_strcspn        EQU  00000D0h
_strlen         EQU  00000D4h
_strncat        EQU  00000D8h
_strncmp        EQU  00000DCh
_strncpy        EQU  00000E0h
_strpbrk        EQU  00000E4h
_strrchr        EQU  00000E8h
_strspn         EQU  00000ECh
_strstr         EQU  00000F0h
_strtok         EQU  00000F4h; Uses static 24-bit variable at 0D0FFFFh
__case          EQU  0000110h
__case16        EQU  0000114h
__case16D       EQU  0000118h
__case24        EQU  000011Ch
__case24D       EQU  0000120h
__case8         EQU  0000124h
__case8D        EQU  0000128h
__frameset0     EQU  0000130h
__frameset      EQU  000012Ch
__iand          EQU  0000134h
__icmpzero      EQU  0000138h
__idivs         EQU  000013Ch
__idivu         EQU  0000140h
__idvrmu        EQU  0000144h
__ildix         EQU  0000148h
__ildiy         EQU  000014Ch
__imul_b        EQU  0000150h
__imuls         EQU  0000154h
__imulu         EQU  0000158h
__indcall       EQU  000015Ch
__ineg          EQU  0000160h
__sneg          EQU  000022Ch
__inot          EQU  0000164h
__snot          EQU  0000230h
__ior           EQU  0000168h
__irems         EQU  000016Ch
__iremu         EQU  0000170h
__ishl_b        EQU  0000178h
__ishl          EQU  0000174h
__ishrs_b       EQU  0000180h
__ishrs         EQU  000017Ch
__ishru_b       EQU  0000188h
__ishru         EQU  0000184h
__istix         EQU  000018Ch
__istiy         EQU  0000190h
__itol          EQU  0000194h
__ixor          EQU  0000198h
__ladd_b        EQU  00001A0h
__ladd          EQU  000019Ch
__land          EQU  00001A4h
__lcmps         EQU  00001A8h
__lcmpu         EQU  00001ACh
__lcmpzero      EQU  00001B0h
__ldivs         EQU  00001B4h
__ldivu         EQU  00001B8h
__ldvrmu        EQU  00001BCh
__lldix         EQU  00001C0h
__lldiy         EQU  00001C4h
__lmuls         EQU  00001C8h
__lmulu         EQU  00001CCh
__lneg          EQU  00001D0h
__lnot          EQU  00001D4h
__lor           EQU  00001D8h
__lrems         EQU  00001DCh
__lremu         EQU  00001E0h
__lshl          EQU  00001E4h
__lshrs         EQU  00001E8h
__lshru         EQU  00001ECh
__bshru         EQU  0000104h
__bshl          EQU  0000100h
__bldiy         EQU  00000FCh
__bstiy         EQU  0000108h
__bstix         EQU  000010Ch
__lstix         EQU  00001F0h
__lstiy         EQU  00001F4h
__lsub          EQU  00001F8h
__lxor          EQU  00001FCh
__sand          EQU  0000200h
__scmp0         EQU  0000204h
__sdivs         EQU  0000208h
__sdivu         EQU  000020Ch
__seqcase       EQU  0000210h
__seqcaseD      EQU  0000214h
__setflag       EQU  0000218h
__sldix         EQU  000021Ch
__sldiy         EQU  0000220h
__smuls         EQU  0000224h
__smulu         EQU  0000228h
__sor           EQU  0000234h
__srems         EQU  0000238h
__sremu         EQU  000023Ch
__sshl_b        EQU  0000244h
__sshl          EQU  0000240h
__sshrs_b       EQU  000024Ch
__sshrs         EQU  0000248h
__sshru_b       EQU  0000254h
__sshru         EQU  0000250h
__sstix         EQU  0000258h
__sstiy         EQU  000025Ch
__stoi          EQU  0000260h
__stoiu         EQU  0000264h
__sxor          EQU  0000268h
;00002D0h   ;checks something about field 80C0h in the OS header (value 0101h)
_WriteAByte     EQU  00002D4h
_EraseFlash     EQU  00002D8h
_EraseFlashPage EQU  00002DCh
_WriteFlash     EQU  00002E0h
_WriteAByte2    EQU  00002E4h    ;no difference
_WriteAByteA    EQU  00002E8h    ;byte is in A, not B
;00002ECh   ;lots of writes/erases involving sectors 3Bh/3Fh
;00002F0h   ;zeroes out 4KB at 0D1887Ch and writes 0D18C7Ch to start of it
_WriteFlashUnsafe EQU 0000334h
_DispStr        EQU  0000378h
_NewLine_Boot   EQU  0000390h

__fppack        EQU  000026Ch
FLT_MAX         EQU  0000294h; NOT A ROUTINE LOL
__fadd          EQU  0000270h
__fcmp          EQU  0000274h
__fdiv          EQU  0000278h
__ftol          EQU  000027Ch
__ltof          EQU  0000284h
__fmul          EQU  0000288h
__fneg          EQU  000028Ch
__fsub          EQU  0000290h
__ultof         EQU  0000280h
_fsqrt          EQU  0000298h
__frbtof        EQU  000029Ch
__frftob        EQU  00002A0h
__frftoi        EQU  00002A8h
__frftos        EQU  00002B0h
__frftoub       EQU  00002A4h
__frftoui       EQU  00002ACh
__frftous       EQU  00002B4h
__fritof        EQU  00002B8h
__frstof        EQU  00002C0h
__frubtof       EQU  00002C4h
__fruitof       EQU  00002BCh
__frustof       EQU  00002C8h



;====== System Calls ===========================================================

_OsSize         EQU  0020104h ; Not actually a routine, just a pointer to the end of the OS, sans signature
_bootOS         EQU  0020108h
_interruptHandler EQU 002010Ch
_rst10Handler   EQU  0020110h
_rst18Handler   EQU  0020114h
_rst20Handler   EQU  0020118h
_rst28Handler   EQU  002011Ch
_rst30Handler   EQU  0020120h
;0020124h   ;This...isn't a ROM call, it's a reference to RAM addresses, for some reason
_GetCSC         EQU  002014Ch
_Mov9ToOP1      EQU  0020320h
_ZeroOP1        EQU  0020384h
_OP1ExOP2       EQU  00203FCh
_chkFindSym     EQU  002050Ch
_createProg     EQU  0020568h
_PushRealO1     EQU  0020614h
_PutMap         EQU  00207B4h
_PutC           EQU  00207B8h
_DispHL         EQU  00207BCh
_PutS           EQU  00207C0h
_NewLine        EQU  00207F0h
_RunIndicOn     EQU  0020844h
_RunIndicOff    EQU  0020848h
_vPutS          EQU  0020834h
_vPutMap        EQU  0020830h
_ToFrac         EQU  002096Ch
;0020D8Ch   ;I think this is _getKey
_StoOther       EQU  0020F4Ch
_RclVarSym      EQU  0020F60h
;002114Ch   ;I think this forces the interrupt to scan the keypad (subroutine of _getKey)
_createAppVar   EQU  0021330h
_createProtProg EQU  0021334h
_lockFlash      EQU  00213ACh
_DelVarArc      EQU  0021434h
_Arc_Unarc      EQU  0021448h
_DispHL24       EQU  0021EE0h
_nmiHandler     EQU  00220A8h

_DrawStatusBar  EQU  021A3Ch 
_DrawStatusBarInfo EQU  021AB4h
_DrawBatteryIndicator EQU  021A50h
_ClrLCDFull	equ	020808h
_ClrLCD	equ	02080ch
_ClrScrnFull	equ	020810h
_ClrScrn	equ	020814h
_ClrTxtShd	equ	020818h
_ClrWindow	equ	02081ch
_FindSym	equ	020510h
_AnsName	equ	020FF4h
_IsA2ByteTok	equ	0204ach
_Get_Tok_Strng	equ	020870h
_GetTokString	equ	020874h


;====== RAM Locations/Address Space ============================================

flags           EQU  0D00080h
CurRow          EQU  0D00595h
CurCol          EQU  0D00596h
OP1             EQU  0D005F8h
OP2             EQU  0D00603h
OP3             EQU  0D0060Eh
OP4             EQU  0D00619h
OP5             EQU  0D00624h
OP6             EQU  0D0062Fh
PenCol          EQU  0D008D2h
PenRow          EQU  0D008D5h
pixelShadow     EQU  0D031F6h
pixelShadow2    EQU  0D052C6h
cmdPixelShadow  EQU  0D07396h
userMem         EQU  0D1A881h

 
vRam            EQU  0D40000h







;====== Scan Codes =============================================================
skDown          EQU       01h
skLeft          EQU       02h
skRight         EQU       03h
skUp            EQU       04h
skEnter         EQU       09h
skAdd           EQU       0Ah
skSub           EQU       0Bh
skMul           EQU       0Ch
skDiv           EQU       0Dh
skPower         EQU       0Eh
skClear         EQU       0Fh
skChs           EQU       11h
sk3             EQU       12h
sk6             EQU       13h
sk9             EQU       14h
skRParen        EQU       15h
skTan           EQU       16h
skVars          EQU       17h
skDecPnt        EQU       19h
sk2             EQU       1Ah
sk5             EQU       1Bh
sk8             EQU       1Ch
skLParen        EQU       1Dh
skCos           EQU       1Eh
skPrgm          EQU       1Fh
skStat          EQU       20h
sk0             EQU       21h
sk1             EQU       22h
sk4             EQU       23h
sk7             EQU       24h
skComma         EQU       25h
skSin           EQU       26h
skMatrix        EQU       27h
skGraphvar      EQU       28h
skStore         EQU       2Ah
skLn            EQU       2Bh
skLog           EQU       2Ch
skSquare        EQU       2Dh
skRecip         EQU       2Eh
skMath          EQU       2Fh
skAlpha         EQU       30h
skGraph         EQU       31h
skTrace         EQU       32h
skZoom          EQU       33h
skWindow        EQU       34h
skYEqu          EQU       35h
sk2nd           EQU       36h
skMode          EQU       37h
skDel           EQU       38h
skDownLeft      EQU       252
skDownRight     EQU       250
skUpLeft        EQU       245
skUpRight       EQU       243


;====== Tokens =================================================================
EOSSTART        EQU       0
;
;
;   DISPLAY CONVERSIONS COME IMMEDIATELY BEFORE 'TSTORE'
;
DCONV           EQU       01h
;
tToDMS          EQU       DCONV       ; 01h
tToDEC          EQU       DCONV+1     ; 02h
tToAbc          EQU       DCONV+2     ; 03h    > A b/c
;
tStore          EQU       DCONV+3     ; 04h Lstore                01
;
tBoxPlot        EQU       05h
;
BRACKS          EQU       06h
;
tLBrack         EQU       BRACKS      ; 06h '['
tRBrack         EQU       BRACKS+1    ; 07h ']'
tLBrace         EQU       BRACKS+2    ; 08h '{'
tRBrace         EQU       BRACKS+3    ; 09h '}'
;
tPOST1          EQU       BRACKS+4
;
tFromRad        EQU       tPOST1       ; 0Ah Lradian
tFromDeg        EQU       tPOST1+1     ; 0Bh Ldegree
tRecip          EQU       tPOST1+2     ; 0Ch Linverse
tSqr            EQU       tPOST1+3     ; 0Dh Lsquare
tTrnspos        EQU       tPOST1+4     ; 0Eh Ltranspose
tCube           EQU       tPOST1+5     ; 0Fh '^3'
;
tLParen         EQU       10h         ; 10h '('
tRParen         EQU       11h         ; 11h ')'
;
;
IMUN            EQU       12h
;
tRound          EQU       IMUN        ; 12h 'round'
tPxTst          EQU       IMUN+1      ; 13h 'PXL-TEST'
tAug            EQU       IMUN+2      ; 14h 'aug'
tRowSwap        EQU       IMUN+3      ; 15h 'rSwap'
tRowPlus        EQU       IMUN+4      ; 16h 'rAdd'
tmRow           EQU       IMUN+5      ; 17h 'multR'
tmRowPlus       EQU       IMUN+6      ; 18h 'mRAdd'
tMax            EQU       IMUN+7      ; 19h 'max'
tMin            EQU       IMUN+8      ; 1Ah 'min'
tRToPr          EQU       IMUN+9      ; 1Bh 'R>Pr
tRToPo          EQU       IMUN+10     ; 1Ch 'R>Po
tPToRx          EQU       IMUN+11     ; 1Dh 'P>Rx
tPToRy          EQU       IMUN+12     ; 1Eh 'P>Ry
tMedian         EQU       IMUN+13     ; 1Fh 'MEDIAN
tRandM          EQU       IMUN+14     ; 20h 'randM'
tMean           EQU       IMUN+15     ; 21h
tRoot           EQU       IMUN+16     ; 22h 'ROOT'
tSeries         EQU       IMUN+17     ; 23h 'seq'
tFnInt          EQU       IMUN+18     ; 24h 'fnInt'
tNDeriv         EQU       IMUN+19     ; 25h 'fnIr'
tEvalF          EQU       IMUN+20     ; 26h
tFmin           EQU       IMUN+21     ; 27h
tFmax           EQU       IMUN+22     ; 28h
;
tEOSEL          EQU       IMUN+23
;
tSpace          EQU       tEOSEL       ; 29h   ' '
tString         EQU       tEOSEL+1     ; 2Ah  '"'
tComma          EQU       tEOSEL+2     ; 2Bh  ','
;
;
tii             EQU       2Ch         ; i
;
;-------------------------------------------------------------------------------
;           Postfix Functions
tPost           EQU       2Dh
;
tFact           EQU       tPost       ; 2Dh '!'
;
tCubicR         EQU       2Eh
tQuartR         EQU       2Fh

;-------------------------------------------------------------------------------
;           Number Tokens 
NUMS            EQU       30h
;
t0              EQU       NUMS        ; 30h
t1              EQU       NUMS+1      ; 31h
t2              EQU       NUMS+2      ; 32h
t3              EQU       NUMS+3      ; 33h
t4              EQU       NUMS+4      ; 34h
t5              EQU       NUMS+5      ; 35h
t6              EQU       NUMS+6      ; 36h
t7              EQU       NUMS+7      ; 37h
t8              EQU       NUMS+8      ; 38h
t9              EQU       NUMS+9      ; 39h
tDecPt          EQU       NUMS+10     ; 3Ah
tee             EQU       NUMS+11     ; 3Bh
;
;-------------------------------------------------------------------------------
;            BINARY OP
tOr             EQU       3Ch         ; 3Ch  '_or_'
tXor            EQU       3Dh         ; 3Dh
;
tColon          EQU       3Eh         ; 3Eh ':'
tEnter          EQU       3Fh         ; 3Fh  Lenter
;
tAnd            EQU       40h         ; 40h  '_and_'       
;-------------------------------------------------------------------------------
;            LETTER TOKENS   
;
LET             EQU       41h
;
tA              EQU       LET         ; 41h
tB              EQU       LET+1       ; 42h
tC              EQU       LET+2       ; 43h
tD              EQU       LET+3       ; 44h
tE              EQU       LET+4       ; 45h
tF              EQU       LET+5       ; 46h
tG              EQU       LET+6       ; 47h
tH              EQU       LET+7       ; 48h
tI              EQU       LET+8       ; 49h
tJ              EQU       LET+9       ; 4Ah
tK              EQU       LET+10      ; 4Bh
tL              EQU       LET+11      ; 4Ch
tM              EQU       LET+12      ; 4Dh
tN              EQU       LET+13      ; 4Eh
tO              EQU       LET+14      ; 4Fh
tP              EQU       LET+15      ; 50h
tQ              EQU       LET+16      ; 51h
tR              EQU       LET+17      ; 52h
tS              EQU       LET+18      ; 53h
tT              EQU       LET+19      ; 54h
tU              EQU       LET+20      ; 55h
tV              EQU       LET+21      ; 56h
tW              EQU       LET+22      ; 57h
tX              EQU       LET+23      ; 58h
tY              EQU       LET+24      ; 59h
tZ              EQU       LET+25      ; 5Ah
tTheta          EQU       LET+26      ; 5Bh
;
;-------------------------------------------------------------------------------
;   THESE VAR TOKENS ARE 1ST OF A DOUBLE TOKEN 
;
vToks           EQU       LET+27    ;
;
;       USER MATRIX TOKEN, 2ND TOKEN NEEDED FOR NAME
;
tVarMat         EQU       vToks       ; 5Ch
;
;       USER LIST TOKEN, 2ND TOKEN NEEDED FOR NAME
;
tVarLst         EQU       vToks+1     ; 5Dh
;
;       USER EQUATION TOKEN, 2ND TOKEN NEEDED FOR NAME
;
tVarEqu         EQU       vToks+2     ; 5Eh
tProg           EQU       vToks+3     ; 5Fh
;
;       USER PICT TOKEN, 2ND TOKEN NEEDED FOR NAME
;
tVarPict        EQU       vToks+4     ; 60h
;
;       USER GDB TOKEN, 2ND TOKEN NEEDED FOR NAME
;
tVarGDB         EQU       vToks+5     ; 61h
tVarOut         EQU       vToks+6     ; 62h
tVarSys         EQU       vToks+7     ; 63h
;
;
;-------------------------------------------------------------------------------
;            Mode Setting Commands
;
MODESA          EQU       vToks+8     ; 64h
;
tRad            EQU       MODESA      ; 64h 'Radian'
tDeg            EQU       MODESA+1    ; 65h 'Degree'
tNormF          EQU       MODESA+2    ; 66h 'Normal'
tSci            EQU       MODESA+3    ; 67h 'Sci'
tEng            EQU       MODESA+4    ; 68h 'Eng'
tFloat          EQU       MODESA+5    ; 69h 'Float'
;
CMPS            EQU       6Ah
;
tEQ             EQU       CMPS        ; 6Ah '=='
tLT             EQU       CMPS+1      ; 6Bh '<'
tGT             EQU       CMPS+2      ; 6Ch '>'
tLE             EQU       CMPS+3      ; 6Dh LLE
tGE             EQU       CMPS+4      ; 6Eh LGE
tNE             EQU       CMPS+5      ; 6Fh LNE
;
;-------------------------------------------------------------------------------
;            BINARY OP
;
tAdd            EQU       70h         ; 70h '+'
tSub            EQU       71h         ; 71h '-'
tAns            EQU       72h         ; 72h
;
;-------------------------------------------------------------------------------
;            Mode Setting Commands
MODES           EQU       73h
;
tFix            EQU       MODES       ; 73h 'Fix_'
tSplitOn        EQU       MODES+1     ; 74h
tFullScreen     EQU       MODES+2     ; 75h
tStndrd         EQU       MODES+3     ; 76h 'Func'
tParam          EQU       MODES+4     ; 77h 'Param'
tPolar          EQU       MODES+5     ; 78h 'Pol'
tSeqG           EQU       MODES+6     ; 79h
tAFillOn        EQU       MODES+7     ; 7Ah 'AUTO FILL ON
tAFillOff       EQU       MODES+8     ; 7Bh
tACalcOn        EQU       MODES+9     ; 7Ch
tACalcOff       EQU       MODES+10    ; 7Dh 'AutoFill OFF
;
;       GRAPH FORMAT TOKENS ARE 2 BYTE TOKENS
;
tGFormat        EQU       MODES+11    ; 7Eh
;
tBoxIcon        EQU       7Fh
tCrossIcon      EQU       80h
tDotIcon        EQU       81h
;
;-------------------------------------------------------------------------------
;            (More) BINARY OP
tMul            EQU       82h         ; 82h  '*'
tDiv            EQU       83h         ; 83h  '/'
;
;-------------------------------------------------------------------------------
;            SOME GRAPH COMMANDS
GRCMDS          EQU       84h
;
tTrace          EQU       GRCMDS      ; 84h 'Trace'
tClDrw          EQU       GRCMDS+1    ; 85h 'ClDrw'
tZoomStd        EQU       GRCMDS+2    ; 86h 'ZStd'
tZoomtrg        EQU       GRCMDS+3    ; 87h 'Ztrg'
tZoomBox        EQU       GRCMDS+4    ; 88h 'ZBOX'
tZoomIn         EQU       GRCMDS+5    ; 89h 'ZIn'
tZoomOut        EQU       GRCMDS+6    ; 8Ah 'ZOut'
tZoomSqr        EQU       GRCMDS+7    ; 8Bh 'ZSqr'
tZoomInt        EQU       GRCMDS+8    ; 8Ch 'ZInt'
tZoomPrev       EQU       GRCMDS+9    ; 8Dh 'ZPrev'
tZoomDec        EQU       GRCMDS+10   ; 8Eh 'ZDecm'
tZoomStat       EQU       GRCMDS+11   ; 8Fh 'ZStat
tUsrZm          EQU       GRCMDS+12   ; 90h 'ZRcl'
tPrtScrn        EQU       GRCMDS+13   ; 91h 'PrtScrn'
tZoomSto        EQU       GRCMDS+14   ; 92h  ZOOM STORE
tText           EQU       GRCMDS+15   ; 93h
;
;-------------------------------------------------------------------------------
;           BINARY OP  (Combination & Permutation)
tnPr            EQU       GRCMDS+16   ; 94h '_nPr_'
tnCr            EQU       GRCMDS+17   ; 95h '_nCr_'
;
;-------------------------------------------------------------------------------
;           MORE GRAPH COMMANDS
tYOn            EQU       GRCMDS+18   ; 96h 'FnOn_'
tYOff           EQU       GRCMDS+19   ; 97h 'FnOff_'
tStPic          EQU       GRCMDS+20   ; 98h 'StPic_'
tRcPic          EQU       GRCMDS+21   ; 99h 'RcPic_'
tStoDB          EQU       GRCMDS+22   ; 9Ah 'StGDB_'
tRclDB          EQU       GRCMDS+23   ; 9Bh 'RcGDB_'
tLine           EQU       GRCMDS+24   ; 9Ch 'Line'
tVert           EQU       GRCMDS+25   ; 9Dh 'Vert_'
tPtOn           EQU       GRCMDS+26   ; 9Eh 'PtOn'
tPtOff          EQU       GRCMDS+27   ; 9Fh 'PtOff'
;
;-------------------------------------------------------------------------------
;           TOKEN A0 CANNOT BE AN EOS FUNCTION
;           SINCE LOW MULT=A0 ALREADY
tPtChg          EQU       GRCMDS+28   ; A0h 'PtChg'
tPXOn           EQU       GRCMDS+29   ; A1h
tPXOff          EQU       GRCMDS+30   ; A2h
tPXChg          EQU       GRCMDS+31   ; A3h
tShade          EQU       GRCMDS+32   ; A4h 'Shade'
tCircl          EQU       GRCMDS+33   ; A5h 'Circl'
tHorz           EQU       GRCMDS+34   ; A6h 'HORIZONTAL'
tTanLn          EQU       GRCMDS+35   ; A7h 'TanLn'
tDrInv          EQU       GRCMDS+36   ; A8h 'DrInv_'
tDrawF          EQU       GRCMDS+37   ; A9h 'DrawF_'
;
tVarStrng       EQU       0AAh
;
;-------------------------------------------------------------------------------
;           Functions with No Arguments                                    
NOARG           EQU       0ABh
;
tRand           EQU       NOARG       ; ABh 'rand'
tPi             EQU       NOARG+1     ; ACh  Lpi
tGetKey         EQU       NOARG+2     ; ADh 'getKy'
;
;
tAPost          EQU       tGetKey+1   ; APOSTROPHY
tQuest          EQU       tAPost+1    ; QUESTION MARK
;
;
UNARY           EQU       tQuest+1              ; B0h
;
tChs            EQU       UNARY       ; B0h
tInt            EQU       UNARY+1     ; B1h
tAbs            EQU       UNARY+2     ; B2h
tDet            EQU       UNARY+3     ; B3h
tIdent          EQU       UNARY+4     ; B4h
tDim            EQU       UNARY+5     ; B5h
tSum            EQU       UNARY+6     ; B6h
tProd           EQU       UNARY+7     ; B7h
tNot            EQU       UNARY+8     ; B8h
tIPart          EQU       UNARY+9     ; B9h
tFPart          EQU       UNARY+10    ; BAh
;
;
;-------------------------------------------------------------------------------
;           NEW 2 BYTE TOKENS
t2ByteTok       EQU       0BBh         ;
;
;
UNARYLR         EQU       UNARY+12
;
tSqrt           EQU       UNARYLR     ; BCh
tCubRt          EQU       UNARYLR+1   ; BDh
tLn             EQU       UNARYLR+2   ; BEh
tExp            EQU       UNARYLR+3   ; BFh
tLog            EQU       UNARYLR+4   ; C0h
tALog           EQU       UNARYLR+5   ; C1h
tSin            EQU       UNARYLR+6   ; C2h
tASin           EQU       UNARYLR+7   ; C3h
tCos            EQU       UNARYLR+8   ; C4h
tACos           EQU       UNARYLR+9   ; C5h
tTan            EQU       UNARYLR+10  ; C6h
tATan           EQU       UNARYLR+11  ; C7h
tSinH           EQU       UNARYLR+12  ; C8h
tASinH          EQU       UNARYLR+13  ; C9h
tCosH           EQU       UNARYLR+14  ; CAh
tACosH          EQU       UNARYLR+15  ; CBh
tTanH           EQU       UNARYLR+16  ; CCh
tATanH          EQU       UNARYLR+17  ; CDh
; 
;-------------------------------------------------------------------------------
;           SOME PROGRAMMING COMMANDS                                      
PROGTOK         EQU       UNARYLR+18
;
tIf             EQU       PROGTOK     ; CEh
tThen           EQU       PROGTOK+1   ; CFh
tElse           EQU       PROGTOK+2   ; D0h
tWhile          EQU       PROGTOK+3   ; D1h
tRepeat         EQU       PROGTOK+4   ; D2h
tFor            EQU       PROGTOK+5   ; D3h
tEnd            EQU       PROGTOK+6   ; D4h
tReturn         EQU       PROGTOK+7   ; D5h
tLbl            EQU       PROGTOK+8   ; D6h   'Lbl_'
tGoto           EQU       PROGTOK+9   ; D7h   'Goto_'
tPause          EQU       PROGTOK+10  ; D8h   'Pause_'
tStop           EQU       PROGTOK+11  ; D9h   'Stop'
tISG            EQU       PROGTOK+12  ; DAh   'IS>'
tDSL            EQU       PROGTOK+13  ; DBh   'DS<'
tInput          EQU       PROGTOK+14  ; DCh   'Input_'
tPrompt         EQU       PROGTOK+15  ; DDh   'Prompt_'
tDisp           EQU       PROGTOK+16  ; DEh   'Disp_'
tDispG          EQU       PROGTOK+17  ; DFh   'DispG'
;
tOutput         EQU       PROGTOK+18  ; E0h    'Outpt'
tClLCD          EQU       PROGTOK+19  ; E1h    'ClLCD'
tConst          EQU       PROGTOK+20  ; E2h    'Fill'
tSortA          EQU       PROGTOK+21  ; E3h    'sortA_'
tSortD          EQU       PROGTOK+22  ; E4h    'sortD_'
tDispTab        EQU       PROGTOK+23  ; E5h    'Disp Table
tMenu           EQU       PROGTOK+24  ; E6h    'Menu'
tSendMBL        EQU       PROGTOK+25  ; E7h    'SEND'
tGetMBL         EQU       PROGTOK+26  ; E8h    'GET'
;-------------------------------------------------------------------------------
;           STAT PLOT COMMANDS                                             
statPCmd        EQU       PROGTOK+27
;
tPlotOn         EQU       statPCmd    ; E9h     ' PLOTSON'
tPlotOff        EQU       statPCmd+1   ; EAh     ' PLOTSOFF
;
tListName       EQU       0EBh        ; LIST DESIGNATOR
;
tPlot1          EQU       0ECh
tPlot2          EQU       0EDh
tPlot3          EQU       0EEh
;
tUnused01       EQU       0EFh        ;        available?
;
tPower          EQU       0F0h        ;        '^'
tXRoot          EQU       0F1h        ;        LsupX,Lroot

STATCMD         EQU       0F2h
;
tOneVar         EQU       STATCMD     ; F2h    'OneVar_'
tTwoVar         EQU       STATCMD+1   ; F3h
tLR             EQU       STATCMD+2   ; F4h    'LinR(A+BX
tLRExp          EQU       STATCMD+3   ; F5h    'ExpR_'
tLRLn           EQU       STATCMD+4   ; F6h    'LnR_'
tLRPwr          EQU       STATCMD+5   ; F7h    'PwrR_'
tMedMed         EQU       STATCMD+6   ; F8h
tQuad           EQU       STATCMD+7   ; F9h
tClrLst         EQU       STATCMD+8   ; FAh    'CLEAR LIST
tClrTbl         EQU       STATCMD+9   ; FBh    CLEAR TABLE
tHist           EQU       STATCMD+10  ; FCh    'Hist_'
txyLine         EQU       STATCMD+11  ; FDh    'xyline_'
tScatter        EQU       STATCMD+12  ; FEh    'Scatter_'
tLR1            EQU       STATCMD+13  ; FFh    'LINR(AX+B

;       
;-------------------------------------------------------------------------------
;           2ND HALF OF GRAPH FORMAT TOKENS
;-------------------------------------------------------------------------------
;           Format settings commands
;
GFMT            EQU       0
;
tSeq            EQU       GFMT        ; 'SeqG'
tSimulG         EQU       GFMT+1      ; 'SimulG'
tPolarG         EQU       GFMT+2      ; 'PolarGC'
tRectG          EQU       GFMT+3      ; 'RectGC'
tCoordOn        EQU       GFMT+4      ; 'CoordOn'
tCoordOff       EQU       GFMT+5      ; 'CoordOff'
tDrawLine       EQU       GFMT+6      ; 'DrawLine'
tDrawDot        EQU       GFMT+7      ; 'DrawDot'
tAxisOn         EQU       GFMT+8      ; 'AxesOn'
tAxisOff        EQU       GFMT+9      ; 'AxesOff'
tGridOn         EQU       GFMT+10     ; 'GridOn'
tGridOff        EQU       GFMT+11     ; 'GridOff'
tLblOn          EQU       GFMT+12     ; 'LabelOn'
tLblOff         EQU       GFMT+13     ; 'LabelOff'
tWebOn          EQU       GFMT+14     ; 'WebOn'
tWebOff         EQU       GFMT+15     ; 'WebOFF'
tuv             EQU       GFMT+16     ; U vs V
tvw             EQU       GFMT+17     ; V vs W
tuw             EQU       GFMT+18     ; U vs W
;
;-------------------------------------------------------------------------------
;           2ND HALF OF USER MATRIX TOKENS                                 
tMatA           EQU       00h         ; MAT A
tMatB           EQU       01h         ; MAT B
tMatC           EQU       02h         ; MAT C
tMatD           EQU       03h         ; MAT D
tMatE           EQU       04h         ; MAT E
tMatF           EQU       05h         ; MAT F
tMatG           EQU       06h         ; MAT G
tMatH           EQU       07h         ; MAT H
tMatI           EQU       08h         ; MAT I
tMatJ           EQU       09h         ; MAT J
;      
;-------------------------------------------------------------------------------
;           2ND HALF OF USER LIST TOKENS
tL1             EQU       00h         ; LIST 1
tL2             EQU       01h         ; LIST 2
tL3             EQU       02h         ; LIST 3
tL4             EQU       03h         ; LIST 4
tL5             EQU       04h         ; LIST 5
tL6             EQU       05h         ; LIST 6

;
;-------------------------------------------------------------------------------
;           2ND HALF OF USER EQUATION TOKENS
;
;       "Y" EQUATIONS HAVE BIT 4 SET
;
tY1             EQU       10h         ; Y1
tY2             EQU       11h         ; Y2
tY3             EQU       12h         ; Y3
tY4             EQU       13h         ; Y4
tY5             EQU       14h         ; Y5
tY6             EQU       15h         ; Y6
tY7             EQU       16h         ; Y7
tY8             EQU       17h         ; Y8
tY9             EQU       18h         ; Y9
tY0             EQU       19h         ; Y0
;
;       PARAM EQUATIONS HAVE BIT 5 SET
;
tX1T            EQU       20h         ; X1t
tY1T            EQU       21h         ; Y1t
tX2T            EQU       22h         ; X2t
tY2T            EQU       23h         ; Y2t
tX3T            EQU       24h         ; X3t
tY3T            EQU       25h         ; Y3t
tX4T            EQU       26h         ; X4t
tY4T            EQU       27h         ; Y4t
tX5T            EQU       28h         ; X5t
tY5T            EQU       29h         ; Y5t
tX6T            EQU       2Ah         ; X6t
tY6T            EQU       2Bh         ; Y6t
;
;       POLAR EQUATIONS HAVE BIT 6 SET
;
tR1             EQU       40h         ; R1
tR2             EQU       41h         ; R2
tR3             EQU       42h         ; R3
tR4             EQU       43h         ; R4
tR5             EQU       44h         ; R5
tR6             EQU       45h         ; R6
;
;       RECURSION EQUATIONS HAVE BIT 7 SET
;
tun             EQU       80h         ; Un
tvn             EQU       81h         ; Vn
twn             EQU       82h         ; Wn
;
;-------------------------------------------------------------------------------
;           2ND HALF OF USER PICTURE TOKENS                                
tPic1           EQU       00h         ; PIC1
tPic2           EQU       01h         ; PIC2
tPic3           EQU       02h         ; PIC3
tPic4           EQU       03h         ; PIC4
tPic5           EQU       04h         ; PIC5
tPic6           EQU       05h         ; PIC6
tPic7           EQU       06h         ; PIC7
tPic8           EQU       07h         ; PIC8
tPic9           EQU       08h         ; PIC9
tPic0           EQU       09h         ; PIC0
; 
;-------------------------------------------------------------------------------
;           2ND HALF OF USER GRAPH DATABASE TOKENS                         
tGDB1           EQU       00h         ; GDB1
tGDB2           EQU       01h         ; GDB2
tGDB3           EQU       02h         ; GDB3
tGDB4           EQU       03h         ; GDB4
tGDB5           EQU       04h         ; GDB5
tGDB6           EQU       05h         ; GDB6
tGDB7           EQU       06h         ; GDB7
tGDB8           EQU       07h         ; GDB8
tGDB9           EQU       08h         ; GDB9
tGDB0           EQU       09h         ; GDB0
;  
;-------------------------------------------------------------------------------
;           2ND HALF OF STRING VARS                                        
tStr1           EQU       00h
tStr2           EQU       01h
tStr3           EQU       02h
tStr4           EQU       03h
tStr5           EQU       04h
tStr6           EQU       05h
tStr7           EQU       06h
tStr8           EQU       07h
tStr9           EQU       08h
tStr0           EQU       09h

; 
;-------------------------------------------------------------------------------
;           2ND HALF OF SYSTEM OUTPUT ONLY VARIABLES                       
;
;   OPEN        EQU       00h
;
tRegEq          EQU       01h         ; REGRESSION EQUATION
;
tStatN          EQU       02h         ; STATISTICS N
;
tXMean          EQU       03h         ; X MEAN
tSumX           EQU       04h         ; SUM(X)
tSumXSqr        EQU       05h         ; SUM(X^2)
tStdX           EQU       06h         ; STANDARD DEV X
tStdPX          EQU       07h         ; STANDARD DEV POP X
tMinX           EQU       08h         ; Min X VALUE
tMaxX           EQU       09h         ; Max X VALUE
;
tMinY           EQU       0Ah         ; Min Y VALUE
tMaxY           EQU       0Bh         ; Max Y VALUE
tYmean          EQU       0Ch         ; Y MEAN
tSumY           EQU       0Dh         ; SUM(Y)
tSumYSqr        EQU       0Eh         ; SUM(Y^2)
tStdY           EQU       0Fh         ; STANDARD DEV Y
tStdPY          EQU       10h         ; STANDARD DEV POP Y
;
tSumXY          EQU       11h         ; SUM(XY)
tCorr           EQU       12h         ; CORRELATION
tMedX           EQU       13h         ; MED(X)
tQ1             EQU       14h         ; 1ST QUADRANT OF X
tQ3             EQU       15h         ; 3RD QUADRANT OF X
tQuadA          EQU       16h         ; 1ST TERM OF QUAD POLY REG/ Y-INT
tQuadB          EQU       17h         ; 2ND TERM OF QUAD POLY REG/ SLOPE
tQuadC          EQU       18h         ; 3RD TERM OF QUAD POLY REG
tCubeD          EQU       19h         ; 4TH TERM OF CUBIC POLY REG
tQuartE         EQU       1Ah         ; 5TH TERM OF QUART POLY REG
tMedX1          EQU       1Bh         ; x1 FOR MED-MED
tMedX2          EQU       1Ch         ; x2 FOR MED-MED
tMedX3          EQU       1Dh         ; x3 FOR MED-MED
tMedY1          EQU       1Eh         ; y1 FOR MED-MED
tMedY2          EQU       1Fh         ; y2 FOR MED-MED
tMedY3          EQU       20h         ; y3 FOR MED-MED
;
tRecurn         EQU       21h       ; RECURSION N
tStatP          EQU       22h
tStatZ          EQU       23h
tStatT          EQU       24h
tStatChi        EQU       25h
tStatF          EQU       26h
tStatDF         EQU       27h
tStatPhat       EQU       28h
tStatPhat1      EQU       29h
tStatPhat2      EQU       2Ah
tStatMeanX1     EQU       2Bh
tStatStdX1      EQU       2Ch
tStatN1         EQU       2Dh
tStatMeanX2     EQU       2Eh
tStatStdX2      EQU       2Fh
tStatN2         EQU       30h
tStatStdXP      EQU       31h
tStatLower      EQU       32h
tStatUpper      EQU       33h
tStat_s         EQU       34h
tLRSqr          EQU       35h         ; r^2
tBRSqr          EQU       36h         ; R^2
;
;-------------------------------------------------------------------------------
;       These next tokens are only used to access the data
;       they are display only and the user cannot access them at all
tF_DF           EQU       37h       ; ANOFAV FACTOR DF
tF_SS           EQU       38h       ; ANOFAV FACTOR SS
tF_MS           EQU       39h       ; ANOFAV FACTOR MS
tE_DF           EQU       3Ah       ; ANOFAV ERROR DF
tE_SS           EQU       3Bh       ; ANOFAV ERROR SS
tE_MS           EQU       3Ch       ; ANOFAV ERROR MS
;
;
;-------------------------------------------------------------------------------
;           2ND HALF OF SYSTEM INPUT/OUTPUT VARIABLES
;      SYSTEM VARIABLE EQUATES
;
tuXscl          EQU       0
tuYscl          EQU       1
tXscl           EQU       2
tYscl           EQU       3
tRecuru0        EQU       4        ; U 1ST INITIAL COND
tRecurv0        EQU       5        ; V 1ST INITIAL COND
tun1            EQU       6        ; U(N-1)    ; NOT USED
tvn1            EQU       7        ; V(N-1)    ; NOT USED
tuRecuru0       EQU       8        ;
tuRecurv0       EQU       9        ;
;         
tXmin           EQU       0Ah
tXmax           EQU       0Bh
tYmin           EQU       0Ch
tYmax           EQU       0Dh
tTmin           EQU       0Eh
tTmax           EQU       0Fh
tThetaMin       EQU       10h
tThetaMax       EQU       11h
tuXmin          EQU       12h
tuXmax          EQU       13h
tuYmin          EQU       14h
tuYmax          EQU       15h
tuThetMin       EQU       16h
tuThetMax       EQU       17h
tuTmin          EQU       18h
tuTmax          EQU       19h
tTblMin         EQU       1Ah
tPlotStart      EQU       1Bh
tuPlotStart     EQU       1Ch
tnMax           EQU       1Dh
tunMax          EQU       1Eh
tnMin           EQU       1Fh
tunMin          EQU       20h
;                 
tTblStep        EQU       21h
tTStep          EQU       22h
tThetaStep      EQU       23h
tuTStep         EQU       24h
tuThetStep      EQU       25h
;                 
tDeltaX         EQU       26h
tDeltaY         EQU       27h
;                 
tXFact          EQU       28h
tYFact          EQU       29h
;
tTblInput       EQU       2Ah
;
tFinN           EQU       2Bh
tFinI           EQU       2Ch
tFinPV          EQU       2Dh
tFinPMT         EQU       2Eh
tFinFV          EQU       2Fh
tFinPY          EQU       30h
tFinCY          EQU       31h
;
tRecurw0        EQU       32h         ; w0(1)
tuRecurw0       EQU       33h
;
tPlotStep       EQU       34h
tuPlotStep      EQU       35h
;
tXres           EQU       36h
tuXres          EQU       37h
;
tRecuru02       EQU       38h         ; u0(2)
tuRecuru02      EQU       39h
tRecurv02       EQU       3Ch         ; v0(2)
tuRecurv02      EQU       3Dh
tRecurw02       EQU       3Eh         ; w0(2)
tuRecurw02      EQU       3Fh
;
;-------------------------------------------------------------------------------
;           2nd byte of t2ByteTok tokens
;
tFinNPV         EQU       00h         ;
tFinIRR         EQU       01h         ;
tFinBAL         EQU       02h         ;
tFinPRN         EQU       03h         ;
tFinINT         EQU       04h         ;
tFinToNom       EQU       05h         ;
tFinToEff       EQU       06h         ;
tFinDBD         EQU       07h         ;
tLCM            EQU       08h         ;
tGCD            EQU       09h         ;
tRandInt        EQU       0Ah         ;
tRandBin        EQU       0Bh         ;
tSubStrng       EQU       0Ch         ;
tStdDev         EQU       0Dh         ;
tVariance       EQU       0Eh         ;
tInStrng        EQU       0Fh         ;
tDNormal        EQU       10h         ;
tInvNorm        EQU       11h         ;
tDT             EQU       12h         ;
tChI            EQU       13h         ;
tDF             EQU       14h         ;
tBINPDF         EQU       15h         ;
tBINCDF         EQU       16h         ;
tPOIPDF         EQU       17h         ;
tPOICDF         EQU       18h         ;
tGEOPDF         EQU       19h         ;
tGEOCDF         EQU       1Ah         ;
tNormalPDF      EQU       1Bh         ;
tTPDF           EQU       1Ch         ;
tChiPDF         EQU       1Dh         ;
tFPDF           EQU       1Eh         ;
tRandNorm       EQU       1Fh         ;
tFinFPMT        EQU       20h         ;
tFinFI          EQU       21h         ;
tFinFPV         EQU       22h         ;
tFinFN          EQU       23h         ;
tFinFFV         EQU       24h         ;
tConj           EQU       25h         ;
tReal           EQU       26h         ;
tImag           EQU       27h         ;
tAngle          EQU       28h         ;
tCumSum         EQU       29h         ;
tExpr           EQU       2Ah         ;
tLength         EQU       2Bh         ;
tDeltaLst       EQU       2Ch         ;
tRef            EQU       2Dh         ;
tRRef           EQU       2Eh         ;
tToRect         EQU       2Fh         ;
tToPolar        EQU       30h         ;
tConste         EQU       31h         ;
tSinReg         EQU       32h         ;
tLogistic       EQU       33h         ;
tLinRegTTest    EQU       34h         ;
tShadeNorm      EQU       35h         ;
tShadeT         EQU       36h         ;
tShadeChi       EQU       37h         ;
tShadeF         EQU       38h         ;
tMatToLst       EQU       39h         ;
tLstToMat       EQU       3Ah         ;
tZTest          EQU       3Bh         ;
tTTest          EQU       3Ch         ;
t2SampZTest     EQU       3Dh         ;
t1PropZTest     EQU       3Eh         ;
t2PropZTest     EQU       3Fh         ;
tChiTest        EQU       40h         ;
tZIntVal        EQU       41h         ;
t2SampZInt      EQU       42h         ;
t1PropZInt      EQU       43h         ;
t2PropZInt      EQU       44h         ;
tGraphStyle     EQU       45h         ;
t2SampTTest     EQU       46h         ;
t2SampFTest     EQU       47h         ;
tTIntVal        EQU       48h         ;
t2SampTInt      EQU       49h         ;
tSetupLst       EQU       4Ah         ;
tFinPMTend      EQU       4Bh         ;
tFinPMTbeg      EQU       4Ch         ;
tRealM          EQU       4Dh         ;
tPolarM         EQU       4Eh         ;
tRectM          EQU       4Fh         ;
tExprOn         EQU       50h         ;
tExprOff        EQU       51h         ;
tClrAllLst      EQU       52h         ;
tGetCalc        EQU       53h         ;
tDelVar         EQU       54h         ;
tEquToStrng     EQU       55h         ;
tStrngToEqu     EQU       56h         ;
tDelLast        EQU       57h         ;
tSelect         EQU       58h         ;
tANOVA          EQU       59h         ;
tModBox         EQU       5Ah         ;
tNormProb       EQU       5Bh         ;
;
;
tMGT            EQU       64h         ; VERTICAL SPLIT
tZFit           EQU       65h         ; ZOOM FIT
tDiag_on        EQU       66h         ; DIANOSTIC DISPLAY ON
tDiag_off       EQU       67h         ; DIANOSTIC DISPLAY OFF
tOkEnd2v0       EQU       67h         ;end of 2byte tokens for version 0.
tArchive        EQU       68h         ;archive
tUnarchive      EQU       69h         ;unarchive
tasm            EQU       6Ah
tasmComp        EQU       6Bh         ; assm compile
tasmPrgm        EQU       6Ch         ; signifies a program is assm
tasmCmp         EQU       6Dh         ; assm program is compiled
;
tLcapAAcute     EQU       6Eh
tLcapAGrave     EQU       6Fh
tLcapACaret     EQU       70h
tLcapADier      EQU       71h
tLaAcute        EQU       72h
tLaGrave        EQU       73h
tLaCaret        EQU       74h
tLaDier         EQU       75h
tLcapEAcute     EQU       76h
tLcapEGrave     EQU       77h
tLcapECaret     EQU       78h
tLcapEDier      EQU       79h
tLeAcute        EQU       7Ah
tLeGrave        EQU       7Bh
tLeCaret        EQU       7Ch
tLeDier         EQU       7Dh
;
tLcapIGrave     EQU       7Fh
tLcapICaret     EQU       80h
tLcapIDier      EQU       81h
tLiAcute        EQU       82h
tLiGrave        EQU       83h
tLiCaret        EQU       84h
tLiDier         EQU       85h
tLcapOAcute     EQU       86h
tLcapOGrave     EQU       87h
tLcapOCaret     EQU       88h
tLcapODier      EQU       89h
tLoAcute        EQU       8Ah
tLoGrave        EQU       8Bh
tLoCaret        EQU       8Ch
tLoDier         EQU       8Dh
tLcapUAcute     EQU       8Eh
tLcapUGrave     EQU       8Fh
tLcapUCaret     EQU       90h
tLcapUDier      EQU       91h
tLuAcute        EQU       92h
tLuGrave        EQU       93h
tLuCaret        EQU       94h
tLuDier         EQU       95h
tLcapCCed       EQU       96h
tLcCed          EQU       97h
tLcapNTilde     EQU       98h
tLnTilde        EQU       99h
tLaccent        EQU       9Ah
tLgrave         EQU       9Bh
tLdieresis      EQU       9Ch
tLquesDown      EQU       9Dh
tLexclamDown    EQU       9Eh
tLalpha         EQU       9Fh
tLbeta          EQU      0a0h
tLgamma         EQU      0a1h
tLcapDelta      EQU      0a2h
tLdelta         EQU      0a3h
tLepsilon       EQU      0a4h
tLlambda        EQU      0a5h
tLmu            EQU      0a6h
tLpi            EQU      0a7h
tLrho           EQU      0a8h
tLcapSigma      EQU      0a9h
;
;
tLphi           EQU      0aBh
tLcapOmega      EQU      0aCh
tLphat          EQU      0aDh
tLchi           EQU      0aEh
tLstatF         EQU      0aFh
;

tLa             EQU      0b0h
tLb             EQU      0b1h
tLc             EQU      0b2h
tLd             EQU      0b3h
tLsmalle        EQU      0b4h
tLf             EQU      0b5h
tLsmallg        EQU      0b6h
tLh             EQU      0b7h
tLi             EQU      0b8h
tLj             EQU      0b9h
tLk             EQU      0bAh
;

tLl             EQU      0bCh
tLm             EQU      0bDh
;tLn             EQU      0bEh
tLo             EQU      0bFh
tLp             EQU      0c0h
tLq             EQU      0c1h
tLsmallr        EQU      0c2h
tLs             EQU      0c3h
tLsmallt        EQU      0c4h
tLu             EQU      0c5h
tLv             EQU      0c6h
tLw             EQU      0c7h
tLx             EQU      0c8h
tLy             EQU      0c9h
tLz             EQU      0cAh
tLsigma         EQU      0cbh
tLtau           EQU      0cch
tLcapIAcute     EQU      0cdh
;
;
tGarbagec       EQU      0Ceh
LastToken       EQU      0Ceh         ;tLAST TOKEN IN THIS VERSION...

; EXTENDED TOKENS
;-----------------------------------------------
; These are new on OSes after 1.15 or whatever
tExtTok         EQU      0EFh

; New tokens on the TI-84+
tSetDate        EQU       00h
tSetTime        EQU       01h
tCheckTmr       EQU       02h
tSetDtFmt       EQU       03h
tSetTmFmt       EQU       04h
tTimeCnv        EQU       05h
tDayOfWk        EQU       06h
tGetDtStr       EQU       07h
tGetTmStr       EQU       08h
tGetDate        EQU       09h
tGetTime        EQU       0Ah
tStartTmr       EQU       0Bh
tGtDtFmt        EQU       0Ch
tGetTmFmt       EQU       0Dh
tIsClockOn      EQU       0Eh
tClockOff       EQU       0Fh
tClockOn        EQU       10h
tOpenLib        EQU       11h
tExecLib        EQU       12h
tInvT           EQU       13h
tChiSquaredGofTest  EQU   14h
tLinRegTInt     EQU       15h
tManualFit      EQU       16h
 
; MathPrint 
tZQuadrant      EQU       17h
tZFracHalf      EQU       18h
tZFracThird     EQU       19h
tZFracFourth    EQU       1Ah
tZFracFifth     EQU       1Bh
tZFracEighth    EQU       1Ch
tZFracTenth     EQU       1Dh
tFracSlash      EQU       2Eh
tFracMixedNum   EQU       2Fh
tSwapImProper   EQU       30h
tSwapFracDec    EQU       31h
tRemainder      EQU       32h
tSummationSigma EQU       33h
tLogBase        EQU       34h
tRandIntNoRep   EQU       35h
tMathPrint      EQU       37h
tClassic        EQU       38h
tAutoAnswer     EQU       3Bh
tDecAnswer      EQU       3Ch
tFracAnswer     EQU       3Dh

; TI-84+CSE
tBlue           EQU       41h
tRed            EQU       42h
tBlack          EQU       43h
tMagenta        EQU       44h
tGreen          EQU       45h
tOrange         EQU       46h
tBrown          EQU       47h
tNavy           EQU       48h
tLtBlue         EQU       49h
tYellow         EQU       4Ah
tWhite          EQU       4Bh
tLtGray         EQU       4Ch
tMedGray        EQU       4Dh
tGray           EQU       4Eh
tDarkGray       EQU       4Fh
          
tGraphColor     EQU       65h
tTextColor      EQU       67h
tBackgroundOn   EQU       5Bh
tBackgroundOff  EQU       64h

tThin           EQU       74h
;tThick - 0x7E 0x06 (was "Connected"?)
tAsm84CPrgm     EQU       68h
tAsm84CCmp      EQU       69h
tBorderColor    EQU       6Ch
          
tAsm84CeCmp     EQU      07Bh
tAsm84CePrgm    EQU      07Ah




;====== Data Types =============================================================
RealObj         EQU       0
ListObj         EQU       1
MatObj          EQU       2
EquObj          EQU       3
StrngObj        EQU       4
ProgObj         EQU       5
ProtProgObj     EQU       6
PictObj         EQU       7
GDBObj          EQU       8
UnknownObj      EQU       9
UnknownEquObj   EQU       0Ah
NewEquObj       EQU       0Bh
CplxObj         EQU       0Ch
CListObj        EQU       0Dh
UndefObj        EQU       0Eh
WindowObj       EQU       0Fh
ZStoObj         EQU       10h
TblRngObj       EQU       11h
LCDObj          EQU       12h
BackupObj       EQU       13h
AppObj          EQU       14h       ;application, only used in menus/link
AppVarObj       EQU       15h       ;application variable
TempProgObj     EQU       16h           ;program, home deletes when finished
GroupObj        EQU       17h           ;group.


;====== System Error Codes =====================================================
E_EDITF         EQU       7       ;allow re-entering application
E_EDIT          EQU       1<<E_EDITF
E_Mask          EQU       7Fh
                  
E_Overflow      EQU       1 +E_EDIT
E_DivBy0        EQU       2 +E_EDIT
E_SingularMat   EQU       3 +E_EDIT
E_Domain        EQU       4 +E_EDIT
E_Increment     EQU       5 +E_EDIT
E_Break         EQU       6 +E_EDIT
E_NonReal       EQU       7 +E_EDIT
E_Syntax        EQU       8 +E_EDIT
E_DataType      EQU       9 +E_EDIT
E_Argument      EQU       10+E_EDIT
E_DimMismatch   EQU       11+E_EDIT
E_Dimension     EQU       12+E_EDIT
E_Undefined     EQU       13+E_EDIT
E_Memory        EQU       14+E_EDIT
E_Invalid       EQU       15+E_EDIT
E_IllegalNest   EQU       16+E_EDIT
E_Bound         EQU       17+E_EDIT
E_GraphRange    EQU       18+E_EDIT
E_Zoom          EQU       19+E_EDIT
E_Label         EQU       20
E_Stat          EQU       21
E_Solver        EQU       22+E_EDIT
E_Singularity   EQU       23+E_EDIT
E_SignChange    EQU       24+E_EDIT
E_Iterations    EQU       25+E_EDIT
E_BadGuess      EQU       26+E_EDIT
E_StatPlot      EQU       27
E_TolTooSmall   EQU       28+E_EDIT
E_Reserved      EQU       29+E_EDIT
E_Mode          EQU       30+E_EDIT
E_LnkErr        EQU       31+E_EDIT
E_LnkMemErr     EQU       32+E_EDIT
E_LnkTransErr   EQU       33+E_EDIT
E_LnkDupErr     EQU       34+E_EDIT
E_LnkMemFull    EQU       35+E_EDIT
E_Unknown       EQU       36+E_EDIT
  
E_Scale         EQU       37+E_EDIT
E_IdNotFound    EQU       38
E_NoMode        EQU       39+E_EDIT
E_Validation    EQU       40
E_Length        EQU       41+E_EDIT
E_Application   EQU       42+E_EDIT
E_AppErr1       EQU       43+E_EDIT
E_AppErr2       EQU       44+E_EDIT
E_ExpiredApp    EQU       45
E_BadAddr       EQU       46
E_Archived      EQU       47+E_EDIT
E_Version       EQU       48
E_ArchFull      EQU       49
E_Variable      EQU       50+E_EDIT
E_Duplicate     EQU       51+E_EDIT
HigErrNum       EQU       51


; obsolete error numbers34              ;first LINK error
E_LinkIOChkSum  EQU       34
E_LinkIOTimeOut EQU       35
E_LinkIOBusy    EQU       36
E_LinkIOVer     EQU       37


;====== Stat Vars Equates ======================================================
FPLEN           EQU        9       ;Length of a floating-point number.
StatN           EQU        statVars
XMean           EQU        StatN      + FPLEN
SumX            EQU        XMean      + FPLEN
SumXSqr         EQU        SumX       + FPLEN
StdX            EQU        SumXSqr    + FPLEN
StdPX           EQU        StdX       + FPLEN
MinX            EQU        StdPX      + FPLEN
MaxX            EQU        MinX       + FPLEN
MinY            EQU        MaxX       + FPLEN
MaxY            EQU        MinY       + FPLEN
YMean           EQU        MaxY       + FPLEN
SumY            EQU        YMean      + FPLEN
SumYSqr         EQU        SumY       + FPLEN
StdY            EQU        SumYSqr    + FPLEN
StdPY           EQU        StdY       + FPLEN
SumXY           EQU        StdPY      + FPLEN
Corr            EQU        SumXY      + FPLEN
MedX            EQU        Corr       + FPLEN
Q1              EQU        MedX       + FPLEN
Q3              EQU        Q1         + FPLEN
QuadA           EQU        Q3         + FPLEN
QuadB           EQU        QuadA      + FPLEN
QuadC           EQU        QuadB      + FPLEN
CubeD           EQU        QuadC      + FPLEN
QuartE          EQU        CubeD      + FPLEN
MedX1           EQU        QuartE     + FPLEN
MedX2           EQU        MedX1      + FPLEN
MedX3           EQU        MedX2      + FPLEN
MedY1           EQU        MedX3      + FPLEN
MedY2           EQU        MedY1      + FPLEN
MedY3           EQU        MedY2      + FPLEN
PStat           EQU        MedY3      + 2*FPLEN
ZStat           EQU        PStat      + FPLEN
TStat           EQU        ZStat      + FPLEN
ChiStat         EQU        TStat      + FPLEN
FStat           EQU        ChiStat    + FPLEN
DF              EQU        FStat      + FPLEN
Phat            EQU        DF         + FPLEN
Phat1           EQU        Phat       + FPLEN
Phat2           EQU        Phat1      + FPLEN
MeanX1          EQU        Phat2      + FPLEN
StdX1           EQU        MeanX1     + FPLEN
StatN1          EQU        StdX1      + FPLEN
MeanX2          EQU        StatN1     + FPLEN
StdX2           EQU        MeanX2     + FPLEN
StatN2          EQU        StdX2      + FPLEN
StdXP2          EQU        StatN2     + FPLEN
SLower          EQU        StdXP2     + FPLEN
SUpper          EQU        SLower     + FPLEN
SStat           EQU        SUpper     + FPLEN
   
;F_DF            EQU        anovaf_vars
;F_SS            EQU        F_DF + FPLEN
;F_MS            EQU        F_SS + FPLEN
;E_DF            EQU        F_MS + FPLEN
;E_SS            EQU        E_DF + FPLEN
;E_MS            EQU        E_SS + FPLEN
   
#endif
.list
