       >>SOURCE FORMAT IS FREE
       replace ==:BCOL:== BY ==with BACKGROUND-COLOR==
               ==:FCOL:== BY ==FOREGROUND-COLOR==.

IDENTIFICATION DIVISION.
PROGRAM-ID.   GC64CALCULATOR is initial.
author.       Eugenio Di Lorenzo. Italy. - eugenio.dilo@gmail.com
date-written. 2020-04-10.
security.     Copyright 2020 E.Di Lorenzo.
remarks.      Calculator written in GnuCOBOL.
*> ***********************************************************************************
*> GnuCOBOL TT (TUI TOOLS) COLLECTION
*> Purpose:    CALCULATOR ON SCREEN (USE MOUSE TO CLICK BUTTONS)
*> Tectonics:  cobc -m GC64CALCULATOR.COB (use GnuCOBOL 3.1)
*> Usage:      call GC64CALCULATOR using Calculatora-Area
*> Parameters: look at GC64CALCULATOR.cpy
*> Author:     Eugenio Di Lorenzo - Italia (DILO) - eugenio.dilo@gmail.com
*> License:    Copyright 2020 E.Di Lorenzo - GNU Lesser General Public License,
*> Version:    1.0 2020.04.10
*> Changelog:  1.0 first release.
*> ***********************************************************************************
*>
*> Displays a Calculator ina box and returns the result to caller
*> the BOX has a size of 20 rows and 40 cols (included cols for shadow)
*> use the left mouse button to click calculator digits and operators
*>
*>             1234567890123456789012345678901234567890
*>          1  +------- GnuCOBOL Calculator ----------+
*>          2  | 99999999999999999999999999999999 XXX |
*>          3  | 99999999999999999999999999999999 XXX |
*>          4  | 99999999999999999999999999999999 XXX |
*>          5  | +----+ +---+ +---+ +---+ +---+ +---+ |
*>          6  | | M+ | |x^y| | C | |<- | | % | |+/-| |
*>          7  | +----+ +---+ +---+ +---+ +---+ +---+ |
*>          8  | +----+ +---+ +---+ +---+ +---+ +---+ |
*>          9  | | M- | |x^2| | 7 | | 8 | | 9 | | / | |
*>          0  | +----+ +---+ +---+ +---+ +---+ +---+ |
*>          1  | +----+ +---+ +---+ +---+ +---+ +---+ |
*>          2  | | M->| |1/x| | 4 | | 5 | | 6 | | * | |
*>          3  | +----+ +---+ +---+ +---+ +---+ +---+ |
*>          4  | +----+ +---+ +---+ +---+ +---+ +---+ |
*>          5  | | M<-| |sqr| | 1 | | 2 | | 3 | | - | |
*>          6  | +----+ +---+ +---+ +---+ +---+ +---+ |
*>          7  | +----+ +---+ +---+ +---+ +---+ +---+ |
*>          8  | | M<>| |log| | 0 | | . | | = | | + | |
*>          9  | +----+ +---+ +---+ +---+ +---+ +---+ |
*>          0  +--- F1=help; esc/r-click=exit --------+
*>
*> ***********************************************************************************
ENVIRONMENT DIVISION.
CONFIGURATION SECTION.
*> source-computer. WINDOWS10 64bit WITH DEBUGGING MODE.
special-names.
   Currency Sign is '€'.
   Decimal-Point is Comma.
   CRT STATUS    is wRetCode.      *> Return Code (es. PF, Arrows, TAB, Mouse Keys)
   CURSOR        is wCursorRowCol. *> Cursor Position

DATA DIVISION.
WORKING-STORAGE SECTION.
01 black   constant as 0.
01 blue    constant as 1.
01 green   constant as 2.
01 cyan    constant as 3.
01 red     constant as 4.
01 magenta constant as 5.
01 yellow  constant as 6.  *> or Brown
01 white   constant as 7.

01 wVisibilityNew  BINARY-SHORT . *> SIGNED.
01 wVisibilityOld  BINARY-SHORT . *> SIGNED.

01  wDummy  PIC X.
01  wSpaces1 PIC X(25) value space.
01  wSpaces2 PIC X(03) value space.

01  wRetCode            PIC 9(4) value 0.  *> CRT-STATUS codes

01  wCursorRowCol       PIC 9(6) value 0.  *> from CURSOR IS ...
01  redefines wCursorRowCol .
    05 wCursorRow       Pic 9(3).
    05 wCursorCol       Pic 9(3).
01  .                                          *> save CUROR position
    05 wCursorRowS       Pic 9(3).
    05 wCursorColS       Pic 9(3).

01  wStatusCode         PIC 99 COMP-5.
01  wRow                PIC 9(3) value 0.
01  wCol                PIC 9(3) value 0.

01  k                   PIC 9(3) value 0.
01  wButtonPressed      PIC 9(3) value 0.

*> Pocket Calculator has 30 buttons. Button coord Positions
01  i                   PIC 9(3) value 0.
01 wTab-Buttons.
   03 wButton occurs 30.
      05 wBurUL.                 *> Upper Left corner
         07 wButUL-Row pic 999.
         07 wButUL-Col pic 999.
      05 wButUR.                 *> Upper Right corner
         07 wButUR-Row pic 999.
         07 wButUR-Col pic 999.
      05 wButLL.                 *> Lower Left corner
         07 wButLL-Row pic 999.
         07 wButLL-Col pic 999.
      05 wButLR.                 *> Lower Right corner
         07 wButLR-Row pic 999.
         07 wButLR-Col pic 999.

01 r                PIC 9(3) value 0.
01 wDec             PIC 9 value 1.
01 wDecimalPoint    PIC X value 'N'.
01 wDigit           PIC 9(1) value 0.
01 wMemory          PIC S9(16)V999.
01 wMemory2         PIC S9(16)V999.
01 wResult          PIC S9(16)V999.
01 wResultRows.
   05 wResultDigit3E  PIC -----.---.---.---.--9,999 value 0 blank when zero.
   05 wResultDigit2E  PIC -----.---.---.---.--9,999 value 0 blank when zero.
   05 wResultDigit1E  PIC -----.---.---.---.--9,999 value 0.
                  *>      1234567890123456789012345   25  chars PIC X
   05 wResultDigit3X  PIC X(25).      *> - , 4 volte . = 6 caratteri  + 16 + 3 = 19 cifre = 25
   05 wResultDigit2X  PIC X(25).      *> - , 4 volte . = 6 caratteri  + 16 + 3 = 19 cifre = 25
   05 wResultDigit1X  PIC X(25).      *> - , 4 volte . = 6 caratteri  + 16 + 3 = 19 cifre = 25

   05 wResultDigit39  PIC s9(16)V999.  *> - , 16 digits and 3 decimals
   05 wResultDigit29  PIC s9(16)V999.  *> - , 16 digits and 3 decimals
   05 wResultDigit19  PIC s9(16)V999.  *> - , 16 digits and 3 decimals

   05 wResultOper3   pic x(03) value space.
   05 wResultOper2   pic x(03) value space.
   05 wResultOper1   pic x(03) value space.

*> SAVE/RESTORE SCREEN VARIABLES
01 wScreenName        PIC X(256).
01 wiScrOk            BINARY-LONG.

*>  mouse mask, apply to COB_MOUSE_FLAGS
78  SET-AUTO-MOUSE-HANDLING    VALUE 1.
78  SET-LEFT-DOWN              VALUE 2.
78  SET-LEFT-UP                VALUE 4.
78  SET-LEFT-DOUBLE            VALUE 8.
78  SET-MIDDLE-DOWN            VALUE 16.
78  SET-MIDDLE-UP              VALUE 32.
78  SET-MIDDLE-DOUBLE          VALUE 64.
78  SET-RIGHT-DOWN             VALUE 128.
78  SET-RIGHT-UP               VALUE 256.
78  SET-RIGHT-DOUBLE           VALUE 512.
78  SET-MOUSE-MOVE             VALUE 1024.
01  MOUSE-FLAGS      PIC 9(04).

COPY 'GC01BOX.CPY'        suppress.
copy 'GC02BOXMEX.CPY'     suppress.
copy 'GC97KEYCODEGC.CPY'  suppress.

LINKAGE SECTION.
COPY 'GC64CALCULATOR.CPY' suppress.

*> ***********************************************************************************
*>           P R O C E D U R E   D I V I S I O N
*> ***********************************************************************************
PROCEDURE DIVISION using Calculator-Area.

    perform InitSettings thru InitSettingsEx

    if Ca-box = 'Y' perform BigBox   thru BigBoxEx end-if
    perform DisplayCalculatorButtons thru DisplayCalculatorButtonsEx

    move 0 to wResultDigit1E wResultDigit19
    move 0 to wResultDigit2E wResultDigit29
    move 0 to wResultDigit3E wResultDigit39
    perform DisplayResult  thru DisplayResultEx

    *> hide the cursor
    move 0 to wVisibilityNew
    call static "curs_set" using by value wVisibilityNew returning wVisibilityOld end-call

    continue.
*> ***********************************************************************************
*> WAIT FOR USER INPUT
*> ***********************************************************************************
LoopKey.
    *> accept a 1 char dummy field . same colors so the field is invisible
    compute wRow = Ca-r1 + 1    compute wCol = Ca-c1 + 1
    accept wDummy at line wRow col wCol  :BCOL: Ca-Box-bco :FCOL: Ca-Box-fco auto no-echo size 0 end-accept

    if wRetCode = K-ESCAPE                                        go to LoopKey-Ex  end-if
    if wRetCode = K-RIGHT-PRESSED or wRetCode = K-RIGHT-DBL-CLICK go to LoopKey-Ex  end-if
    if wRetCode = K-F1   perform DisplayHelp thru DisplayHelpEx   go to LoopKey     end-if

    evaluate TRUE
      when  (wRetCode = K-LEFT-PRESSED  or wRetCode = K-LEFT-DBL-CLICK
          or wRetCode = K-MID-PRESSED   or wRetCode = K-MID-DBL-CLICK)

            *> check if mouse position was on a calculator button
            move wCursorRow to wCursorRowS
            move wCursorCol to wCursorColS
            perform varying k from 1 by 1 until k > 30

                if  (wCursorRowS >= wButUL-Row(k) and wCursorRowS <= wButLR-Row(k))
                and (wCursorColS >= wButUL-Col(k) and wCursorColS <= wButLR-Col(k))

                    move 'N' to Box-shadow Box-fill Box-tit
                    move 'R' to Box-3D
                    move 'S' to box-style
                    move '7' to Box-bco
                    move '7' to Box-fco
                    compute box-r1 = wButUL-Row(k)    compute box-c1 = wButUL-Col(k)
                    compute box-r2 = wButLR-Row(k)    compute box-c2 = wButLR-Col(k)
                    CALL GC01BOX USING BY CONTENT BOX-AREA

                    *> CALL "C$SLEEP" USING 1 *> small delay to show the click effect
                    *> continue after 0.5 seconds
                    call "CBL_GC_NANOSLEEP" USING 250000000 end-call *> pause 0.5 sec

                    move 'N' to Box-shadow Box-fill Box-tit
                    move 'E' to Box-3D
                    move 'S' to box-style
                    move '7' to Box-bco
                    move '7' to Box-fco
                    compute box-r1 = wButUL-Row(k)    compute box-c1 = wButUL-Col(k)
                    compute box-r2 = wButLR-Row(k)    compute box-c2 = wButLR-Col(k)
                    CALL GC01BOX USING BY CONTENT BOX-AREA

                    perform EvaluateButton thru EvaluateButtonEx
                    perform DisplayResult  thru DisplayResultEx
                end-if
            end-perform

        when other
            continue
      end-evaluate

    go to LoopKey
    continue.

LoopKey-Ex.
    move wResult to Ca-Result
    continue.

End-Program.
   GOBACK.

*> ***********************************************************************************
*>
*> ***********************************************************************************
EvaluateButton.
  evaluate true
     when k = 1   *> M+ add display to memory
        move 'N' to wDecimalPoint move 1 to wDec
        compute wMemory= wMemory + wResultDigit19
        move "M+ " to wResultOper1
        continue
     when k = 2   *> M-subtract display from memory
        move 'N' to wDecimalPoint move 1 to wDec
        compute wMemory= wMemory - wResultDigit19
        move "M- " to wResultOper1
        continue
     when k = 3   *> M-> set to memory
        move 'N' to wDecimalPoint move 1 to wDec
        move wResultDigit19 to wMemory
        move "M->" to wResultOper1
        continue
     when k = 4   *> M<-  set display from memory
        move 'N' to wDecimalPoint
        move  wMemory to wResultDigit19
        move "M<-" to wResultOper1
        continue
     when k = 5   *> M<>  exchange display and memory
        move 'N' to wDecimalPoint move 1 to wDec
        move wResultDigit19 to wMemory2
        move wMemory        to wResultDigit19
        move wMemory2       to wMemory
        move "M<>" to wResultOper1
        continue
     when k = 6   *> x^y
        move 'N' to wDecimalPoint move 1 to wDec
        move wResultDigit29 to wResultDigit39
        move wResultDigit19 to wResultDigit29
        compute wResult rounded = 0
        move wResult        to wResultDigit19
        move wResultOper2 to wResultOper3
        move "x^y"        to wResultOper2
        move "   "        to wResultOper1
        continue
     when k = 7   *> x^2
        move 'N' to wDecimalPoint move 1 to wDec
        move wResultDigit29 to wResultDigit39
        move wResultDigit19 to wResultDigit29
        compute wResult rounded = wResultDigit19 * wResultDigit19
        move wResult        to wResultDigit19

        move wResultOper2 to wResultOper3
        move "x^2"        to wResultOper2
        move "   "        to wResultOper1
        continue
     when k = 8   *> 1/x
        move 'N' to wDecimalPoint move 1 to wDec
        move wResultDigit29 to wResultDigit39
        move wResultDigit19 to wResultDigit29
        compute wResult rounded = 1 / wResultDigit19
        move wResult        to wResultDigit19
        move wResultOper2 to wResultOper3
        move "1/x"        to wResultOper2
        move "   "        to wResultOper1
        continue
     when k = 9   *> sqr
        move 'N' to wDecimalPoint move 1 to wDec
        move wResultDigit29 to wResultDigit39
        move wResultDigit19 to wResultDigit29
        move Function SQRT (wResultDigit19 ) to wResult
        move wResult        to wResultDigit19
        move wResultOper2 to wResultOper3
        move "sqr"        to wResultOper2
        move "   "        to wResultOper1
        continue
     when k = 10   *> log
        move 'N' to wDecimalPoint move 1 to wDec
        move wResultDigit29 to wResultDigit39
        move wResultDigit19 to wResultDigit29
        move Function LOG (wResultDigit19 ) to wResult
        move wResult        to wResultDigit19
        move wResultOper2 to wResultOper3
        move "log"        to wResultOper2
        move "   "        to wResultOper1
        continue
     when k = 11   *> C  cancel to zero
        move 'N' to wDecimalPoint move 1 to wDec
        move wResultDigit29 to wResultDigit39
        move wResultDigit19 to wResultDigit29
        compute wResult = 0
        move wResult        to wResultDigit19
        move wResultOper2 to wResultOper3
        move " C "        to wResultOper2
        move "   "        to wResultOper1
        continue
     when k = 12   *> 7
        move 7 to wDigit
        perform DigitAdd      thru DigitAddEx
        continue
     when k = 13   *> 4
        move 4 to wDigit
        perform DigitAdd      thru DigitAddEx
        continue
     when k = 14   *> 1
        move 1 to wDigit
        perform DigitAdd      thru DigitAddEx
        continue
     when k = 15   *> 0
        move 0 to wDigit
        perform DigitAdd      thru DigitAddEx
        continue
     when k = 16   *> <-  to cancel last digit
        *> to be completed
        perform DigitCancel thru DigitCancelEx
        continue
     when k = 17   *> 8
        move 8 to wDigit
        perform DigitAdd      thru DigitAddEx
        continue
     when k = 18   *> 5
        move 5 to wDigit
        perform DigitAdd      thru DigitAddEx
        continue
     when k = 19   *> 2
        move 2 to wDigit
        perform DigitAdd      thru DigitAddEx
        continue
     when k = 20   *> .
        if wDecimalPoint = 'N'
           move 'Y' to wDecimalPoint
        else
           move 'N' to wDecimalPoint
        end-if
        continue
     when k = 21   *> %
        move 'N' to wDecimalPoint move 1 to wDec
        move wResultDigit29 to wResultDigit39
        move wResultDigit19 to wResultDigit29
        compute wResult rounded = 0
        move wResult        to wResultDigit19
        move wResultOper2 to wResultOper3
        move " % "        to wResultOper2
        move "   "        to wResultOper1
        continue
     when k = 22   *> 9
        move 9 to wDigit
        perform DigitAdd      thru DigitAddEx
        continue
     when k = 23   *> 6
        move 6 to wDigit
        perform DigitAdd      thru DigitAddEx
        continue
     when k = 24   *> 3
        move 3 to wDigit
        perform DigitAdd      thru DigitAddEx
        continue
     when k = 25   *> =  compute result
        move 'N' to wDecimalPoint move 1 to wDec
        evaluate true
            when wResultOper2 = " / "
                 compute wResult rounded = wResultDigit29 / wResultDigit19
            when wResultOper2 = " x "
                 compute wResult rounded = wResultDigit29 * wResultDigit19
            when wResultOper2 = " + "
                 compute wResult rounded = wResultDigit29 + wResultDigit19
            when wResultOper2 = " - "
                 compute wResult rounded = wResultDigit29 - wResultDigit19
            when wResultOper2 = " % "
                 compute wResult rounded = ( wResultDigit29 / 100 ) * wResultDigit19
            when wResultOper2 = "x^y"
                 compute wResult rounded = wResultDigit29 ** wResultDigit19
        end-evaluate
        move wResultDigit29 to wResultDigit39
        move wResultDigit19 to wResultDigit29
        move wResult        to wResultDigit19
        move wResultOper2 to wResultOper3
        move " = "        to wResultOper2
        move "   "        to wResultOper1
        continue
     when k = 26   *> +/- change sign
        move 'N' to wDecimalPoint move 1 to wDec
        move wResultDigit29 to wResultDigit39
        move wResultDigit19 to wResultDigit29
        compute wResult rounded = wResultDigit19 * -1
        move wResult        to wResultDigit19
        move wResultOper2 to wResultOper3
        move "+/-"        to wResultOper2
        move "   "        to wResultOper1
        continue
     when k = 27   *> / divide
        move 'N' to wDecimalPoint move 1 to wDec
        move wResultDigit29 to wResultDigit39
        move wResultDigit19 to wResultDigit29
        compute wResult = 0
        move wResult        to wResultDigit19
        move wResultOper2 to wResultOper3
        move " / "        to wResultOper2
        move "   "        to wResultOper1
        continue
     when k = 28   *> x multiply
        move 'N' to wDecimalPoint move 1 to wDec
        move wResultDigit29 to wResultDigit39
        move wResultDigit19 to wResultDigit29
        compute wResult = 0
        move wResult        to wResultDigit19
        move wResultOper2 to wResultOper3
        move " x "        to wResultOper2
        move "   "        to wResultOper1
        continue
     when k = 29   *> - subtract
        move 'N' to wDecimalPoint move 1 to wDec
        move wResultDigit29 to wResultDigit39
        move wResultDigit19 to wResultDigit29
        compute wResult = 0
        move wResult        to wResultDigit19
        move wResultOper2 to wResultOper3
        move " - "        to wResultOper2
        move "   "        to wResultOper1
        continue
     when k = 30   *> + add
        move 'N' to wDecimalPoint move 1 to wDec
        move wResultDigit29 to wResultDigit39
        move wResultDigit19 to wResultDigit29
        compute wResult = 0
        move wResult        to wResultDigit19
        move wResultOper2 to wResultOper3
        move " + "        to wResultOper2
        move "   "        to wResultOper1
        continue
  continue.
EvaluateButtonEx. exit.

DigitAdd.
   if wDecimalPoint = 'N'
       *> integer part digits
       if wResult = 0
          move wDigit        to  wResult
       else
          move wResult(2:15) to wResult(1:15)
          move wDigit        to wResult(16:1)
       end-if
   else
       *> decimal part digits
       *> first decimal digit
       if wDec = 1
          add 1 to wDec
          move wDigit to wResult(17:1)
       else if wDec = 2
               *> 2nd decomal digit
               add 1 to wDec
               move wDigit to wResult(18:1)
            else if wDec = 3
                   *>3rd decimal digit
                    move 1 to wDec
                    move wDigit to wResult(19:1)
                    move 'N' to wDecimalPoint
                 end-if
            end-if
       end-if
   end-if

   move wResult to wResultDigit19
   continue.
DigitAddEx. exit.

DigitCancel.
   if wDecimalPoint = 'N'
       *> integer part digits
       if wResult = 0
          continue
       else
          move wResult(1:15) to wResult(2:15)
       end-if
   else
       *> decimal part digits
       if wDec = 3
          move 0 to wResult(19:1)
          subtract 1 from wDec
       else if wDec = 2
               subtract 1 from wDec
               move 0 to wResult(18:1)
            else if wDec = 1
                    move 1 to wDec
                    move 0 to wResult(17:1)
                    *> move 'N' to wDecimalPoint
                 end-if
            end-if
       end-if
   end-if

   move wResult to wResultDigit19
   continue.
DigitCancelEx. exit.

DisplayResult.
  *> 3 rows to display digits and operators
  compute wRow = Ca-r1 + 1
  compute wCol = Ca-c1 + 2
  move   wResultDigit39 to wResultDigit3E
  display wResultDigit3E  at line wRow col wCol :BCOL: black :FCOL: green highlight
  compute wCol = Ca-c1 + 28
  display wResultOper3    at line wRow col wCol :BCOL: black :FCOL: yellow highlight

  compute wRow = Ca-r1 + 2
  compute wCol = Ca-c1 + 2
  move   wResultDigit29 to wResultDigit2E
  display wResultDigit2E  at line wRow col wCol :BCOL: black :FCOL: green highlight
  compute wCol = Ca-c1 + 28
  display wResultOper2    at line wRow col wCol :BCOL: black :FCOL: yellow highlight

  compute wRow = Ca-r1 + 3
  compute wCol = Ca-c1 + 2
  move   wResultDigit19 to wResultDigit1E
  display wResultDigit1E  at line wRow col wCol :BCOL: black :FCOL: green highlight
  compute wCol = Ca-c1 + 28
  display wResultOper1    at line wRow col wCol :BCOL: black :FCOL: yellow highlight

  continue.
DisplayResultEx. exit.

*> ***********************************************************************************
*>
*> ***********************************************************************************
BigBox.
    move Ca-r1          to  box-r1
    move Ca-c1          to  box-c1
    compute box-r2 = Ca-r1 + 19
    compute box-c2 = Ca-c1 + 32
    move Ca-Box-shadow  to Box-shadow
    move Ca-Box-3D      to Box-3D
    move Ca-Box-tit     to Box-tit
    move Ca-Box-titDes  to Box-titDes
    move Ca-Box-bco     to Box-bco
    move Ca-Box-fco     to Box-fco
    move Ca-Box-style   to box-style
    CALL GC01BOX USING BY CONTENT BOX-AREA
    compute box-c1 =  box-c1 + 3
    display ' F1=help; esc/r-click=exit ' at line box-r2 col box-c1 :BCOL: 7 :FCOL: black
    continue.
BigBoxEx. exit.

DisplayCalculatorButtons.
  compute wRow = Ca-r1 + 5      compute wCol = Ca-c1 + 2
  display ' M+   x^y   C   <-    %   +/-' at line wRow col wCol :BCOL: 7 :FCOL: red highlight
  compute wRow = Ca-r1 + 8
  display ' M-   x^2   7    8    9    / ' at line wRow col wCol :BCOL: 7 :FCOL: red highlight
  compute wRow = Ca-r1 + 11
  display ' M->  1/x   4    5    6    x ' at line wRow col wCol :BCOL: 7 :FCOL: red highlight
  compute wRow = Ca-r1 + 14
  display ' M<-  sqr   1    2    3    - ' at line wRow col wCol :BCOL: 7 :FCOL: red highlight
  compute wRow = Ca-r1 + 17
  display ' M<>  log   0    ,    =    + ' at line wRow col wCol :BCOL: 7 :FCOL: red highlight



  move 'N' to Box-shadow Box-fill Box-tit
  move 'E' to Box-3D
  move 'S' to box-style
  move 7   to Box-bco
  move 7   to Box-fco

  move 0 to i

  *> BUTTON COLUMN 01
  compute box-r1 = Ca-r1 + 04    compute box-c1 = Ca-c1 + 01
  compute box-r2 = Ca-r1 + 06    compute box-c2 = Ca-c1 + 06
  perform SetBoxCoord thru SetBoxCoordEx
  CALL GC01BOX USING BY CONTENT BOX-AREA
  compute box-r1 = Ca-r1 + 07    compute box-c1 = Ca-c1 + 01
  compute box-r2 = Ca-r1 + 09    compute box-c2 = Ca-c1 + 06
  perform SetBoxCoord thru SetBoxCoordEx
  CALL GC01BOX USING BY CONTENT BOX-AREA
  compute box-r1 = Ca-r1 + 10    compute box-c1 = Ca-c1 + 01
  compute box-r2 = Ca-r1 + 12    compute box-c2 = Ca-c1 + 06
  perform SetBoxCoord thru SetBoxCoordEx
  CALL GC01BOX USING BY CONTENT BOX-AREA
  compute box-r1 = Ca-r1 + 13    compute box-c1 = Ca-c1 + 01
  compute box-r2 = Ca-r1 + 15    compute box-c2 = Ca-c1 + 06
  perform SetBoxCoord thru SetBoxCoordEx
  CALL GC01BOX USING BY CONTENT BOX-AREA
  compute box-r1 = Ca-r1 + 16    compute box-c1 = Ca-c1 + 01
  compute box-r2 = Ca-r1 + 18    compute box-c2 = Ca-c1 + 06
  perform SetBoxCoord thru SetBoxCoordEx
  CALL GC01BOX USING BY CONTENT BOX-AREA

  *> BUTTON COLUMN 02
  compute box-r1 = Ca-r1 + 04    compute box-c1 = Ca-c1 + 07
  compute box-r2 = Ca-r1 + 06    compute box-c2 = Ca-c1 + 11
  perform SetBoxCoord thru SetBoxCoordEx
  CALL GC01BOX USING BY CONTENT BOX-AREA
  compute box-r1 = Ca-r1 + 07    compute box-c1 = Ca-c1 + 07
  compute box-r2 = Ca-r1 + 09    compute box-c2 = Ca-c1 + 11
  perform SetBoxCoord thru SetBoxCoordEx
  CALL GC01BOX USING BY CONTENT BOX-AREA
  compute box-r1 = Ca-r1 + 10    compute box-c1 = Ca-c1 + 07
  compute box-r2 = Ca-r1 + 12    compute box-c2 = Ca-c1 + 11
  perform SetBoxCoord thru SetBoxCoordEx
  CALL GC01BOX USING BY CONTENT BOX-AREA
  compute box-r1 = Ca-r1 + 13    compute box-c1 = Ca-c1 + 07
  compute box-r2 = Ca-r1 + 15    compute box-c2 = Ca-c1 + 11
  perform SetBoxCoord thru SetBoxCoordEx
  CALL GC01BOX USING BY CONTENT BOX-AREA
  compute box-r1 = Ca-r1 + 16    compute box-c1 = Ca-c1 + 07
  compute box-r2 = Ca-r1 + 18    compute box-c2 = Ca-c1 + 11
  perform SetBoxCoord thru SetBoxCoordEx
  CALL GC01BOX USING BY CONTENT BOX-AREA

  *> BUTTON COLUMN 03
  compute box-r1 = Ca-r1 + 04    compute box-c1 = Ca-c1 + 12
  compute box-r2 = Ca-r1 + 06    compute box-c2 = Ca-c1 + 16
  perform SetBoxCoord thru SetBoxCoordEx
  CALL GC01BOX USING BY CONTENT BOX-AREA
  compute box-r1 = Ca-r1 + 07    compute box-c1 = Ca-c1 + 12
  compute box-r2 = Ca-r1 + 09    compute box-c2 = Ca-c1 + 16
  perform SetBoxCoord thru SetBoxCoordEx
  CALL GC01BOX USING BY CONTENT BOX-AREA
  compute box-r1 = Ca-r1 + 10    compute box-c1 = Ca-c1 + 12
  compute box-r2 = Ca-r1 + 12    compute box-c2 = Ca-c1 + 16
  perform SetBoxCoord thru SetBoxCoordEx
  CALL GC01BOX USING BY CONTENT BOX-AREA
  compute box-r1 = Ca-r1 + 13    compute box-c1 = Ca-c1 + 12
  compute box-r2 = Ca-r1 + 15    compute box-c2 = Ca-c1 + 16
  perform SetBoxCoord thru SetBoxCoordEx
  CALL GC01BOX USING BY CONTENT BOX-AREA
  compute box-r1 = Ca-r1 + 16    compute box-c1 = Ca-c1 + 12
  compute box-r2 = Ca-r1 + 18    compute box-c2 = Ca-c1 + 16
  perform SetBoxCoord thru SetBoxCoordEx
  CALL GC01BOX USING BY CONTENT BOX-AREA

  *> BUTTON COLUMN 04
  compute box-r1 = Ca-r1 + 04    compute box-c1 = Ca-c1 + 17
  compute box-r2 = Ca-r1 + 06    compute box-c2 = Ca-c1 + 21
  perform SetBoxCoord thru SetBoxCoordEx
  CALL GC01BOX USING BY CONTENT BOX-AREA
  compute box-r1 = Ca-r1 + 07    compute box-c1 = Ca-c1 + 17
  compute box-r2 = Ca-r1 + 09    compute box-c2 = Ca-c1 + 21
  perform SetBoxCoord thru SetBoxCoordEx
  CALL GC01BOX USING BY CONTENT BOX-AREA
  compute box-r1 = Ca-r1 + 10    compute box-c1 = Ca-c1 + 17
  compute box-r2 = Ca-r1 + 12    compute box-c2 = Ca-c1 + 21
  perform SetBoxCoord thru SetBoxCoordEx
  CALL GC01BOX USING BY CONTENT BOX-AREA
  compute box-r1 = Ca-r1 + 13    compute box-c1 = Ca-c1 + 17
  compute box-r2 = Ca-r1 + 15    compute box-c2 = Ca-c1 + 21
  perform SetBoxCoord thru SetBoxCoordEx
  CALL GC01BOX USING BY CONTENT BOX-AREA
  compute box-r1 = Ca-r1 + 16    compute box-c1 = Ca-c1 + 17
  compute box-r2 = Ca-r1 + 18    compute box-c2 = Ca-c1 + 21
  perform SetBoxCoord thru SetBoxCoordEx
  CALL GC01BOX USING BY CONTENT BOX-AREA

  *> BUTTON COLUMN 05
  compute box-r1 = Ca-r1 + 04    compute box-c1 = Ca-c1 + 22
  compute box-r2 = Ca-r1 + 06    compute box-c2 = Ca-c1 + 26
  perform SetBoxCoord thru SetBoxCoordEx
  CALL GC01BOX USING BY CONTENT BOX-AREA
  compute box-r1 = Ca-r1 + 07    compute box-c1 = Ca-c1 + 22
  compute box-r2 = Ca-r1 + 09    compute box-c2 = Ca-c1 + 26
  perform SetBoxCoord thru SetBoxCoordEx
  CALL GC01BOX USING BY CONTENT BOX-AREA
  compute box-r1 = Ca-r1 + 10    compute box-c1 = Ca-c1 + 22
  compute box-r2 = Ca-r1 + 12    compute box-c2 = Ca-c1 + 26
  perform SetBoxCoord thru SetBoxCoordEx
  CALL GC01BOX USING BY CONTENT BOX-AREA
  compute box-r1 = Ca-r1 + 13    compute box-c1 = Ca-c1 + 22
  compute box-r2 = Ca-r1 + 15    compute box-c2 = Ca-c1 + 26
  perform SetBoxCoord thru SetBoxCoordEx
  CALL GC01BOX USING BY CONTENT BOX-AREA
  compute box-r1 = Ca-r1 + 16    compute box-c1 = Ca-c1 + 22
  compute box-r2 = Ca-r1 + 18    compute box-c2 = Ca-c1 + 26
  perform SetBoxCoord thru SetBoxCoordEx
  CALL GC01BOX USING BY CONTENT BOX-AREA

  *> BUTTON COLUMN 06
  compute box-r1 = Ca-r1 + 04    compute box-c1 = Ca-c1 + 27
  compute box-r2 = Ca-r1 + 06    compute box-c2 = Ca-c1 + 31
  perform SetBoxCoord thru SetBoxCoordEx
  CALL GC01BOX USING BY CONTENT BOX-AREA
  compute box-r1 = Ca-r1 + 07    compute box-c1 = Ca-c1 + 27
  compute box-r2 = Ca-r1 + 09    compute box-c2 = Ca-c1 + 31
  perform SetBoxCoord thru SetBoxCoordEx
  CALL GC01BOX USING BY CONTENT BOX-AREA
  compute box-r1 = Ca-r1 + 10    compute box-c1 = Ca-c1 + 27
  compute box-r2 = Ca-r1 + 12    compute box-c2 = Ca-c1 + 31
  perform SetBoxCoord thru SetBoxCoordEx
  CALL GC01BOX USING BY CONTENT BOX-AREA
  compute box-r1 = Ca-r1 + 13    compute box-c1 = Ca-c1 + 27
  compute box-r2 = Ca-r1 + 15    compute box-c2 = Ca-c1 + 31
  perform SetBoxCoord thru SetBoxCoordEx
  CALL GC01BOX USING BY CONTENT BOX-AREA
  compute box-r1 = Ca-r1 + 16    compute box-c1 = Ca-c1 + 27
  compute box-r2 = Ca-r1 + 18    compute box-c2 = Ca-c1 + 31
  perform SetBoxCoord thru SetBoxCoordEx
  CALL GC01BOX USING BY CONTENT BOX-AREA

  *> 3 rows to display digits and operators
  compute wRow = Ca-r1 + 1
  compute wCol = Ca-c1 + 2
  display wSpaces1  at line wRow col wCol :BCOL: black :FCOL: green
  compute wCol = Ca-c1 + 28
  display wSpaces2  at line wRow col wCol :BCOL: black :FCOL: green

  compute wRow = Ca-r1 + 2
  compute wCol = Ca-c1 + 2
  display wSpaces1  at line wRow col wCol :BCOL: black :FCOL: green
  compute wCol = Ca-c1 + 28
  display wSpaces2  at line wRow col wCol :BCOL: black :FCOL: green

  compute wRow = Ca-r1 + 3
  compute wCol = Ca-c1 + 2
  display wSpaces1  at line wRow col wCol :BCOL: black :FCOL: green
  compute wCol = Ca-c1 + 28
  display wSpaces2  at line wRow col wCol :BCOL: black :FCOL: green

  compute wCol = Ca-c1 + 26
  display '0'       at line wRow col wCol :BCOL: black :FCOL: green
  continue.
DisplayCalculatorButtonsEx. exit.

SetBoxCoord.
  add 1 to i
  compute wButUL-Row(i) = box-r1
  compute wButUL-Col(i) = box-c1
  compute wButUR-Row(i) = box-r1
  compute wButUR-Col(i) = box-c2
  compute wButLL-Row(i) = box-r2
  compute wButLL-Col(i) = box-c1
  compute wButLR-Row(i) = box-r2
  compute wButLR-Col(i) = box-c2
  continue.
SetBoxCoordEx. exit.


InitSettings.
  *> sets in order to detect the PgUp, PgDn, PrtSc(screen print), Esc keys,
  set environment 'COB_SCREEN_EXCEPTIONS' TO 'Y'.
  set environment 'COB_SCREEN_ESC'        TO 'Y'.
  *> display ' ' at 001001 with erase eos.

  *> set mouse mask  - make mouse active
  COMPUTE MOUSE-FLAGS = SET-AUTO-MOUSE-HANDLING
                      + SET-LEFT-DOWN   + SET-MIDDLE-DOWN   + SET-RIGHT-DOWN
                      + SET-LEFT-UP     + SET-MIDDLE-UP     + SET-RIGHT-UP
                      + SET-LEFT-DOUBLE + SET-MIDDLE-DOUBLE + SET-RIGHT-DOUBLE
                      + SET-MOUSE-MOVE
  SET environment     "COB_MOUSE_FLAGS"   to MOUSE-FLAGS
  continue.
InitSettingsEx. exit.

DisplayHelp.
    perform ScreenSave thru ScreenSaveEx
    *> DISPLAY THE FRAME AND THE HELP TEXT
    initialize Boxmex-Area ALL TO VALUE
    move low-value to Bxm-tabmex
    move z'                               ' to Bxm-mex(01)
    move z'                               ' to Bxm-mex(02)
    move z'                               ' to Bxm-mex(03)
    move z' Use left mouse button to      ' to Bxm-mex(04)
    move z' select digits or operators.   ' to Bxm-mex(05)
    move z' M-> move digits to memory     ' to Bxm-mex(06)
    move z' M<- recall from memory        ' to Bxm-mex(07)
    move z' M<> exchange with memory      ' to Bxm-mex(08)
    move z' M+  add to memory             ' to Bxm-mex(09)
    move z' M-  subtract from memory      ' to Bxm-mex(10)
    move z'                               ' to Bxm-mex(11)
    move z'                               ' to Bxm-mex(12)
    move z'                               ' to Bxm-mex(13)
    move z'                               ' to Bxm-mex(14)
    move z'                               ' to Bxm-mex(15)
    move z'                               ' to Bxm-mex(16)
    move z' eugenio.dilo@gmail.com (c)2020' to Bxm-mex(17)
    move z'                               ' to Bxm-mex(18)

    move blue     to Bxm-bco    Bxm-titBco Bxm-bcoM
    move white    to Bxm-fco    Bxm-titFco Bxm-fcoM
    move 'Y'      to Bxm-Click  Bxm-tit
    move 'N'      to Bxm-3D     Bxm-OkButton
    move 'S'      to Bxm-style
    move x'B4' & ' GnuCOBOL Calculator - HELP '  & x'C3' & x'00' to Bxm-titDes
   compute Bxm-r1 = Ca-r1
   compute Bxm-c1 = Ca-c1
   compute Bxm-r2 = Bxm-r1 + 19
   compute Bxm-c2 = Bxm-c1 + 32
   call GC02BOXMEX using by content BOXMEX-AREA
        on exception display 'CALL BOXMEX error. Module BOXMEX not Found.' end-call
   perform ScreenRestore thru ScreenRestoreEx.
DisplayHelpEx. exit.

ScreenSave.
   move Z'GC64CALCULATOR.SCR' to wScreenName
   call static 'scr_dump' using by reference wScreenName returning wiScrOk end-call.
ScreenSaveEx. exit.

ScreenRestore.
   call static 'scr_restore' using by reference wScreenName returning wiScrOk end-call
   CALL 'CBL_DELETE_FILE' USING wScreenName.
ScreenRestoreEx. exit.

End Program GC64CALCULATOR.
