       >> SOURCE FORMAT IS FREE
REPLACE ==:BC== BY ==with background-color==
        ==:FC== BY ==foreground-color==     .
*> ***********************************************************************************
*> GnuCOBOL TT (TUI TOOLS) COLLECTION
*> Purpose:    DISPLAY A COLOR MAP OF 8 BACKGR x 8 FOREGR = 64 COLOR PAIR COMBINATION
*>             LET THE USER BROWSE ON THE COLOR MAP TO CHOOSE - RETURNS TO CALLER
*> Tectonics:  cobc -m GC52COLORPICKER.COB  (use GnuCOBOL 2.0 or greater)
*> Usage:      call GC52COLORPICKER using ColorPicker-Area
*> Parameters: look at GC52COLORPICKER.CPY  (use with copy Version: 1.0)
*> Author:     Eugenio Di Lorenzo - Italia (DILO)
*> License:    Copyright 2017 - GNU Lesser General Public License, LGPL, 3.0 (or greater)
*> Version:    1.0 2017.12.01
*> Changelog:  1.0 first release.
*>             1.1 added F1 = help
*> ***********************************************************************************
ID DIVISION.
PROGRAM-ID. GC52COLORPICKER.
ENVIRONMENT DIVISION.
DATA DIVISION.
WORKING-STORAGE SECTION.
01 black   constant as 00.
01 blue    constant as 01.
01 green   constant as 02.
01 cyan    constant as 03.
01 red     constant as 04.
01 magenta constant as 05.
01 yellow  constant as 06.  *> or Brown
01 white   constant as 07.

01  ROW1    PIC S9(9).
01  COL1    PIC S9(9).

01  COL1c    PIC S9(9) value zero.
01  ROW1c    PIC S9(9) value zero.

01  ROW     PIC S9(9).
01  ROW2    PIC S9(9).
01  COLU    PIC S9(9).

01  BG      PIC S9(9).
01  FG      PIC S9(9).
01  BG1     PIC 999.
01  FG1     PIC 999.

01 wBackCol   pic 9  value zero.
01 wForeCol   pic 9  value zero.
01 wColorPair pic 99 value zero.

01 wLin      Pic 99    value zero.
01 wCol      Pic 99    value zero.
01 wColor    pic 9     value zero.
01 wColorDes pic x(08) value space.

01 Ir pic 99.
01 Ic pic 99.

01  wVisibilityNot   BINARY-SHORT  value 0.  *> 0 = hide cursor
01  wVisibilityYes   BINARY-SHORT  value 2.  *> 2 = cursor visible full
01  wVisibilityNew   BINARY-SHORT .
01  wVisibilityOld   BINARY-SHORT .

*> SAVE/RESTORE SCREEN VARIABLES
01 wScreenName        PIC X(256).
01 wiScrOk            BINARY-LONG.

*> ****************************************************************************
*>  COLOR PAIR TAB FROM 00 TO 63.
*>  exceptions are 00 = white on black, 01 = green on black
*> ****************************************************************************


                                    *>    FOREGROUND
                                    *>    B B G R C M Y W
                                    *>    L L R E Y A E H
                                    *>    A U E D A G L I
                                    *>    C E E   N E L T
                                    *>    K   N     N O E
                                    *>              T W
                                    *>              A           BACKGROUND
01 wColorPair-Tab                  value '6302010304050600'  *> BLACK
                                       & '0708091011121314'  *> BLUE
                                       & '1516171819202122'  *> GREEN
                                       & '2324252627282930'  *> RED
                                       & '3132333435363738'  *> CYAN
                                       & '3940414243444546'  *> MAGENTA
                                       & '4748495051525354'  *> YELLOW
                                       & '5556575859606162'. *> WHITE
   03 wColorPair-Row occurs 8.
      05 wColorPair-Col occurs 8.
         07 wColorPair-Ele Pic 99.

COPY         'GC01BOX.CPY'.
copy      'GC02BOXMEX.CPY'.
COPY     'GC98KEYCODE.CPY'.

LINKAGE SECTION.
COPY 'GC52COLORPICKER.CPY'.

*> ***********************************************************************************
*>           P R O C E D U R E   D I V I S I O N
*> ***********************************************************************************
PROCEDURE DIVISION using ColorPicker-Area.
   *> sets in order to detect the PgUp, PgDn, PrtSc(screen print), Esc keys,
   set environment 'COB_SCREEN_EXCEPTIONS' TO 'Y'
   set environment 'COB_SCREEN_ESC'        TO 'Y'
   continue.

loop0.
   *> DISPLAY THE FRAME OF COLOR MAP
   *> initialize Box-area ALL TO VALUE
   move 1 to Ir Ic
   move Cop-r1     to ROW1
   move Cop-c1     to COL1
   move Cop-bco    to Box-bco Box-titBco
   move Cop-fco    to Box-fco Box-titFco
   move Cop-Style  to Box-style
   move Cop-Tit    to Box-tit
   move Cop-titDes to Box-titDes
   compute Box-r1 = ROW1 - 2
   compute Box-c1 = COL1 - 2
   compute Box-r2 = Box-r1 + 18
   compute Box-c2 = Box-c1 + 34
   move    Cop-tit to Box-tit
   call GC01BOX using BOX-AREA

   *> (use always a "display ...at ..."  or an "accept ... at ..." before to have a call to "initscr"
   perform CursorHide thru CursorHideEx

  *> Display Box for "Colors Informations" under Color MAP
   *> initialize Box-area ALL TO VALUE
   compute Box-r1 = ROW1   + 16
   compute Box-c1 = COL1   - 2
   compute Box-r2 = Box-r1 + 2
   compute Box-c2 = Box-c1 + 34
   move 'N' to Box-tit
   call GC01BOX using BOX-AREA

   compute wLin = ROW1 + 16
   compute wCol = COL1 -  2
   display x'C3' at line wLin col wCol :BC Cop-bco :FC Cop-fco highlight end-display
   compute wLin = ROW1 + 16
   compute wCol = COL1 + 32
   display x'B4' at line wLin col wCol :BC Cop-bco :FC Cop-fco highlight end-display

   *> Display a COLOR MAP  ( 8 x 8 = 64 combinatons)
   perform varying BG from 0 by 1 until BG > 7
       Perform varying FG from 0 by 1 until FG > 7
           move BG to BG1
           move FG to FG1
           compute COLU = FG * 4 + COL1
           compute ROW  = BG * 2 + ROW1
           if  FG = 0 or 7 *> or (Ic = Ir)
               display BG1 at line ROW  col COLU :BC BG  :FC FG
           else
               display BG1 at line ROW  col COLU :BC BG  :FC FG HIGHLIGHT
           end-if
       end-perform
   end-perform

   *> Display a "Big Cursor" and let the user select one of 64 combinations
   move ROW1 to ROW1c
   move COL1 to COL1c
   perform BigCursorDisplay thru BigCursorDisplayEx
   continue.

loop1.
   perform DisplayColorInformation thru DisplayColorInformationEx
   continue.

loop2.
   *> ***********************************************************************************
   *> WAIT FOR USER INPUT
   *> ***********************************************************************************
   *> (use always a "display ...at ..."  or an "accept ... at ..." before to have a call to "initscr"
   call static "getch" returning Key-Pressed end-call

   *> test if the user pressed a cursor KEY
   EVALUATE TRUE
      when Key-Pressed = Key-CursRight or Key-Tab or Key-space
            perform BigCursorReset   thru BigCursorresetEx
            add 4 to COL1c
            add 1 to wForeCol Ic
            if COL1c > ( COL1 + 29 ) move COL1 to COL1c move zero to wForeCol move 1 to Ic end-if
            perform BigCursorDisplay thru BigCursorDisplayEx
            go to loop1
      when Key-Pressed = Key-CursDn or Key-PgDn
            perform BigCursorReset   thru BigCursorresetEx
            add 2 to ROW1c
            add 1 to wBackCol Ir
            if ROW1c > ( ROW1 + 15 ) move ROW1 to ROW1c move 0 to wBackCol move 1 to Ir end-if
            perform BigCursorDisplay thru BigCursorDisplayEx
            go to loop1
      when Key-Pressed = Key-CursLeft
            perform BigCursorReset   thru BigCursorresetEx
            subtract 4 from COL1c
            subtract 1 from wForeCol Ic
            if COL1c < COL1  compute COL1c = COL1 + 28 move 7 to wForeCol move 8 to Ic end-if
            perform BigCursorDisplay thru BigCursorDisplayEx
            go to loop1
      when Key-Pressed = Key-CursUp or Key-PgUp
            perform BigCursorReset   thru BigCursorresetEx
            subtract 2 from ROW1c
            subtract 1 from wBackCol Ir
            if ROW1c < ROW1  compute ROW1c = ROW1 + 14 move 7 to wBackCol move 8 to Ir end-if
            perform BigCursorDisplay thru BigCursorDisplayEx
            go to loop1
      when Key-Pressed = Key-F1
            *> F1 HELP
            perform DisplayHelp thru DisplayHelpEx
            go to loop0
      when Key-Pressed = Key-F2
            *> F2 change frame Fore Color
            add 1 to Cop-Fco Cop-titFco
            If Cop-Fco > 7 move 0 to Cop-Fco Cop-titFco end-if
            move 1 to Ic Ir
            move 0 to wBackCol wForeCol
            perform BigCursorReset thru BigCursorResetEx
            go to loop0
      when Key-Pressed = Key-F3
            *> F3 change frame Back Color
            add 1 to Cop-Bco Cop-titBco
            If Cop-Bco > 7 move 0 to Cop-Bco Cop-titBco  end-if
            move 1 to Ic Ir
            move 0 to wBackCol wForeCol
            perform BigCursorReset thru BigCursorResetEx
            go to loop0
      when Key-Pressed = Key-Enter
            move Key-Enter to Cop-Key
            go to End-Program
      when Key-Pressed =  Key-Escape
            move  Key-Escape to Cop-Key
            go to End-Program
      when Other
             go to loop2
   END-EVALUATE

   continue.
End-Program.
   *> reset the cursor
   perform CursorReset thru CursorResetEx
   GOBACK.


*> ***********************************************************************************
*>
*> ***********************************************************************************
DecodeColor.
    evaluate wColor
      when 0 move ' black  ' to wColorDes
      when 1 move ' blue   ' to wColorDes
      when 2 move ' green  ' to wColorDes
      when 3 move ' cyan   ' to wColorDes
      when 4 move ' red    ' to wColorDes
      when 5 move ' magenta' to wColorDes
      when 6 move ' yellow ' to wColorDes
      when 7 move ' white  ' to wColorDes
    end-evaluate
    continue.
DecodeColorEx. exit.

BigCursorDisplay.
   *> DISPLAY "THE BIG CURSOR"
   initialize Box-area ALL TO VALUE
   compute Box-r1 = ROW1c - 1
   compute Box-c1 = COL1c - 1
   compute Box-r2 = Box-R1 + 2
   compute Box-c2 = Box-c1 + 4
   move black to Box-bco
   move 'S'   to Box-style
   move 'N' to Box-fill
   call GC01BOX using BOX-AREA
   continue.
BigCursorDisplayEx. exit.

BigCursorReset.
   *> RESET "THE BIG CURSOR"
   initialize Box-area ALL TO VALUE
   compute Box-r1 = ROW1c - 1
   compute Box-c1 = COL1c - 1
   compute Box-r2 = Box-R1 + 2
   compute Box-c2 = Box-c1 + 4
   move black to Box-bco
   move 'N' to Box-style
   move 'N' to Box-fill
   call GC01BOX using BOX-AREA
   continue.
BigCursorresetEx. exit.

DisplayColorInformation.
   *> Display Colors Informations under Color MAP
   compute wLin = ROW1 + 17
   compute wCol = COL1 - 1
   display ' BG: '   at line wLin col wCol :BC Cop-bco :FC Cop-fco highlight end-display
   Compute wCol = wCol + 4
   display wBackCol  at line wLin col wCol :BC Cop-bco :FC Cop-fco highlight end-display
   move    wBackCol  to wColor Cop-BackCol
   perform DecodeColor thru DecodeColorEx
   Compute wCol = wCol + 1
   display wColordes at line wLin col wCol :BC Cop-bco :FC Cop-fco highlight end-display

   Compute wCol = wCol + 8
   display ' FG: '   at line wLin col wCol :BC Cop-bco :FC Cop-fco highlight end-display
   Compute wCol = wCol + 4
   display wForeCol  at line wLin col wCol :BC Cop-bco :FC Cop-fco highlight end-display
   move    wForeCol  to wColor Cop-ForeCol
   perform DecodeColor thru DecodeColorEx
   Compute wCol = wCol + 1
   display wColordes at line wLin col wCol :BC Cop-bco :FC Cop-fco highlight end-display

   *> Display the "Color pair"
   Compute wCol = wCol + 8
   display ' CP: '   at line wLin col wCol :BC Cop-bco :FC Cop-fco highlight end-display
   Compute wCol = wCol + 4
   move    wColorPair-Ele(Ir, Ic) to Cop-ColorPair
   display wColorPair-Ele(Ir, Ic) at line wLin col wCol :BC Cop-bco :FC Cop-fco highlight end-display
   Compute wCol = wCol + 2
   display ' '                    at line wLin col wCol :BC Cop-bco :FC Cop-fco end-display
   continue.
DisplayColorInformationEx. exit.

CursorHide.
    *> save cursor state and hide the cursor
    *> (use always a "display ...at ..."  or an "accept ... at ..." before to have a call to "initscr"
    move wVisibilityNot to wVisibilityNew
    call static "curs_set" using by value wVisibilityNew returning wVisibilityOld end-call
    continue.
CursorHideEx. exit.

CursorReset.
    *> reset (show) the cursor to its saved previous state
    move wVisibilityOld to wVisibilityNew
    call static "curs_set" using by value wVisibilityNew returning wVisibilityOld end-call
    continue.
CursorResetEx. exit.

DisplayHelp.
   perform ScreenSave thru ScreenSaveEx
   *> DISPLAY THE FRAME AND THE HELP TEXT
    initialize Boxmex-Area ALL TO VALUE
    move low-value to Bxm-tabmex
    move z' Cursor, Tab, Page, space keys = ' to Bxm-mex(01)
    move z' browse the color pair map       ' to Bxm-mex(02)
    move z' F1 = displays this screen       ' to Bxm-mex(03)
    move z' F2 = change forecolor of frame  ' to Bxm-mex(04)
    move z' F3 = change backcolor of frame  ' to Bxm-mex(05)
    move z' Enter= select the color pair    ' to Bxm-mex(06)
    move z' ESC  = exit from color picker   ' to Bxm-mex(07)
    move z'                                 ' to Bxm-mex(08)
    move z' color pair map:                 ' to Bxm-mex(09)
    move z' B  B  G  R  C  M  Y  W          ' to Bxm-mex(10)
    move z' L  L  R  E  Y  A  E  H          ' to Bxm-mex(11)
    move z' 63 02 01 03 04 05 06 00  BLACK  ' to Bxm-mex(12)
    move z' 07 08 09 10 11 12 13 14  BLUE   ' to Bxm-mex(13)
    move z' 15 16 17 18 19 20 21 22  GREEN  ' to Bxm-mex(14)
    move z' 23 24 25 26 27 28 29 30  RED    ' to Bxm-mex(15)
    move z' 31 32 33 34 35 36 37 38  CYAN   ' to Bxm-mex(16)
    move z' 39 40 41 42 43 44 45 46  MAGENTA' to Bxm-mex(17)
    move z' 47 48 49 50 51 52 53 54  YELLOW ' to Bxm-mex(18)
    move z' 55 56 57 58 59 60 61 62  WHITE  ' to Bxm-mex(19)

    move blue     to Bxm-bco    Bxm-titBco Bxm-bcoM
    move white    to Bxm-fco    Bxm-titFco Bxm-fcoM
    move 'Y'      to Bxm-Click  Bxm-tit
    move 'N'      to Bxm-3D     Bxm-OkButton
    move 'D'      to Bxm-style
    move ' HELP ' & x'00'    to Bxm-titDes
   compute Bxm-r1 = Cop-r1 - 2
   compute Bxm-c1 = Cop-c1 - 2
   compute Bxm-r2 = Bxm-r1 + 20
   compute Bxm-c2 = Bxm-c1 + 34
   call GC02BOXMEX using BOXMEX-AREA
   perform ScreenRestore thru ScreenRestoreEx.
DisplayHelpEx. exit.

ScreenSave.
   move Z'SCRDUMP.SCR' to wScreenName
   call static 'scr_dump' using by reference wScreenName returning wiScrOk end-call.
ScreenSaveEx. exit.

ScreenRestore.
   call static 'scr_restore' using by reference wScreenName returning wiScrOk end-call
   CALL 'CBL_DELETE_FILE' USING wScreenName.
ScreenRestoreEx. exit.

End Program GC52COLORPICKER.
