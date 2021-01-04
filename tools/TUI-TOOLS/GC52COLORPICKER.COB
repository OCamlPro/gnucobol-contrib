       >> SOURCE FORMAT IS FREE
REPLACE ==:BCOL:== BY ==BACKGROUND-COLOR== ==:FCOL:== BY ==FOREGROUND-COLOR==.
*> ***********************************************************************************
*> GnuCOBOL TT (TUI TOOLS) COLLECTION
*> Purpose:    DISPLAY A COLOR MAP OF 8 BACKGR x 8 FOREGR = 64 COLOR PAIR COMBINATION
*>             LET THE USER BROWSE ON THE COLOR MAP TO CHOOSE ONE - RETURNS TO CALLER
*> Tectonics:  cobc -m GC52COLORPICKER.COB  -lpdcurses (compile with GnuCOBOL 3.1 or greater)
*> Usage:      call GC52COLORPICKER using ColorPicker-Area
*> Parameters: look at GC52COLORPICKER.CPY  (use copy Version: 2.0)
*> Author:     Eugenio Di Lorenzo - Italia (DILO) - eugenio.dilo@gmail.com
*> License:    Copyright 2017 - GNU Lesser General Public License, LGPL, 3.0 (or greater)
*> Version:    2.0 2021.01.01
*> Changelog:  1.0 first release.
*>             1.1 added F1 = help
*>             2.0 mouse management is added
*>                 changed from "call getch" to ACCEPT a DUMMY field
*>                 added single click of left mousekey on a colormap to make it active
*>                 double left-click is same as Enter (select a new color pair)
*>                 single or doubleclick of right mousekey is same as ESCAPE
*> ***********************************************************************************
ID DIVISION.
PROGRAM-ID. GC52COLORPICKER.

ENVIRONMENT DIVISION.
CONFIGURATION SECTION.
SPECIAL-NAMES.
    CRT STATUS IS wCRT-STATUS.    *> Return Code from Accept (ex.PF Keys, Mouse Keys)
    CURSOR     IS wCursorRowCol.  *> Cursor Position

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

01  wVisibilityNot   BINARY-SHORT  value 0.  *> 0 = hide cursor
01  wVisibilityYes   BINARY-SHORT  value 2.  *> 2 = cursor visible full
01  wVisibilityNew   BINARY-SHORT .
01  wVisibilityOld   BINARY-SHORT .

*> SAVE/RESTORE SCREEN VARIABLES
01 wScreenName        PIC X(256).
01 wiScrOk            BINARY-LONG.

01  wDummy       PIC X(01) VALUE SPACE.
01  wPrompt      PIC X(01) VALUE SPACE.
01  wCRT-STATUS  PIC 9(04) VALUE 9999.

01  wCursorRowCol       PIC 9(06) value zero.
01  redefines wCursorRowCol.
    05 wCursorRow       Pic 9(03).
    05 wCursorCol       Pic 9(03).
01  .                                          *> to save CUROR position
    05 wCursorRowS       Pic 9(3).
    05 wCursorColS       Pic 9(3).

*> ****************************************************************************
*>  COLOR PAIR CODES TAB - 64 combinations FROM 00 TO 63.
*>  in the table there are some exceptions (all when BackGround is black):
*>  white on black= 00, green on black= 01, black on black= 63
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

*> row & col variables to access the table of colormap codes wColorPair-Tab
01 Ir pic 99.
01 Ic pic 99.

01  j                   PIC 9(3) value 0.
01  k                   PIC 9(3) value 0.
01  w                   PIC 9(3) value 0.

*> Color Map has 64 (8 x 8) buttons.
*> Button coord Positions useful to detect mouse click
01  i                   PIC 9(3) value 0.
01 wTab-Buttons.
   03 wButtonPos occurs 64.
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

*>  mouse mask, apply to COB_MOUSE_FLAGS
78  COB-AUTO-MOUSE-HANDLING          VALUE 1.
78  COB-ALLOW-LEFT-DOWN              VALUE 2.
78  COB-ALLOW-LEFT-UP                VALUE 4.
78  COB-ALLOW-LEFT-DOUBLE            VALUE 8.
78  COB-ALLOW-MIDDLE-DOWN            VALUE 16.
78  COB-ALLOW-MIDDLE-UP              VALUE 32.
78  COB-ALLOW-MIDDLE-DOUBLE          VALUE 64.
78  COB-ALLOW-RIGHT-DOWN             VALUE 128.
78  COB-ALLOW-RIGHT-UP               VALUE 256.
78  COB-ALLOW-RIGHT-DOUBLE           VALUE 512.
78  COB-ALLOW-MOUSE-MOVE             VALUE 1024.
01  COB-MOUSE-FLAGS                  PIC 9(04).

COPY       'GC01BOX.CPY' suppress.
copy    'GC02BOXMEX.CPY' suppress.
copy 'GC97KEYCODEGC.CPY' suppress.

LINKAGE SECTION.
COPY 'GC52COLORPICKER.CPY'.

*> ***********************************************************************************
*>           P R O C E D U R E   D I V I S I O N
*> ***********************************************************************************
PROCEDURE DIVISION using ColorPicker-Area.

   perform InitialSettings thru InitialSettingsEx
   continue.

DisplayColorMap.
   *> DISPLAY THE FRAME OF COLOR MAP
   move 1          to Ir Ic
   move Cop-r1     to ROW1                move Cop-c1     to COL1
   move Cop-bco    to Box-bco Box-titBco  move Cop-fco    to Box-fco Box-titFco
   move Cop-Style  to Box-style
   move Cop-tit    to Box-tit             move Cop-titDes to Box-titDes
   compute Box-r1 = ROW1 - 2              compute Box-c1 = COL1 - 2
   compute Box-r2 = Box-r1 + 18           compute Box-c2 = Box-c1 + 34
   perform callGC01BOX thru callGC01BOX-ex
   *> (use always a "display ...at ..."  or an "accept ... at ..." before to have a call to "initscr"
   perform CursorHide thru CursorHideEx

  *> Display Box for "Colors Informations" under Color MAP
   compute Box-r1 = ROW1   + 16   compute Box-c1 = COL1   - 2
   compute Box-r2 = Box-r1 + 2    compute Box-c2 = Box-c1 + 34
   move 'N' to Box-tit
   perform callGC01BOX thru callGC01BOX-ex
   compute wLin = ROW1 + 16       compute wCol = COL1 -  2
   display x'C3' at line wLin col wCol :BCOL: Cop-bco :FCOL: Cop-fco highlight end-display
   compute wLin = ROW1 + 16       compute wCol = COL1 + 32
   display x'B4' at line wLin col wCol :BCOL: Cop-bco :FCOL: Cop-fco highlight end-display

   *> Display the COLOR MAP  ( 8 x 8 = 64 codes / combinations)
   *> SET the color map codes position in a Table (useful to verify the mouse click
   move zero to i
   perform varying BG from 0 by 1 until BG > 7
       Perform varying FG from 0 by 1 until FG > 7

           move BG to BG1
           move FG to FG1
           compute COLU = FG * 4 + COL1
           compute ROW  = BG * 2 + ROW1
           if  FG = 0 or 7 *> or (Ic = Ir)
               display BG1 at line ROW  col COLU :BCOL: BG  :FCOL: FG
           else
               display BG1 at line ROW  col COLU :BCOL: BG  :FCOL: FG highlight
           end-if

           *> set the table with color codes position
           add 1 to i
           compute wButUL-Row(i) = ROW
           compute wButUL-Col(i) = COLU
           compute wButUR-Row(i) = ROW
           compute wButUR-Col(i) = COLU + 2
           compute wButLL-Row(i) = ROW
           compute wButLL-Col(i) = COLU
           compute wButLR-Row(i) = ROW
           compute wButLR-Col(i) = COLU + 2

       end-perform
   end-perform

   *> Display a "Big Cursor" and let the user select one of 64 combinations
   move ROW1 to ROW1c
   move COL1 to COL1c
   perform BigCursorDisplay thru BigCursorDisplayEx
   continue.

DisplayColorDescription.
   perform DisplayColorInformation thru DisplayColorInformationEx
   continue.

Accept-a-Key.
   *> ***********************************************************************************
   *> WAIT FOR USER ACTION
   *> ***********************************************************************************
   *> (use always a "display ...at ..."  or an "accept ... at ..." before to have a call to "initscr"
      accept wDummy at line Cop-r1 col Cop-c1
             with auto-skip prompt character is wPrompt :BCOL: Cop-bco :FCOL: Cop-fco

   EVALUATE TRUE

      when wCRT-STATUS = K-RIGHT
        or wCRT-STATUS = K-TAB
            perform BigCursorReset   thru BigCursorResetEx
            add 4 to COL1c
            add 1 to wForeCol Ic
            if COL1c > ( COL1 + 29 ) move COL1 to COL1c move zero to wForeCol move 1 to Ic end-if
            perform BigCursorDisplay thru BigCursorDisplayEx
            go to DisplayColorDescription
      when wCRT-STATUS = K-DOWN
        or wCRT-STATUS = K-PAGEDOWN
            perform BigCursorReset   thru BigCursorResetEx
            add 2 to ROW1c
            add 1 to wBackCol Ir
            if ROW1c > ( ROW1 + 15 ) move ROW1 to ROW1c move 0 to wBackCol move 1 to Ir end-if
            perform BigCursorDisplay thru BigCursorDisplayEx
            go to DisplayColorDescription
      when wCRT-STATUS = K-LEFT
        or wCRT-STATUS = K-BACKTAB
            perform BigCursorReset   thru BigCursorResetEx
            subtract 4 from COL1c
            subtract 1 from wForeCol Ic
            if COL1c < COL1  compute COL1c = COL1 + 28 move 7 to wForeCol move 8 to Ic end-if
            perform BigCursorDisplay thru BigCursorDisplayEx
            go to DisplayColorDescription
      when wCRT-STATUS = K-UP
        or wCRT-STATUS = K-PAGEUP
            perform BigCursorReset   thru BigCursorResetEx
            subtract 2 from ROW1c
            subtract 1 from wBackCol Ir
            if ROW1c < ROW1  compute ROW1c = ROW1 + 14 move 7 to wBackCol move 8 to Ir end-if
            perform BigCursorDisplay thru BigCursorDisplayEx
            go to DisplayColorDescription

      when wCRT-STATUS = K-LEFT-PRESSED
        or wCRT-STATUS = K-LEFT-DBL-CLICK

            *> search if the mouse was on a color code
            move wCursorRow to wCursorRowS
            move wCursorCol to wCursorColS
            perform varying k from 1 by 1 until k > 64
                if  (wCursorRowS >= wButUL-Row(k) and wCursorRowS <= wButLR-Row(k))
                and (wCursorColS >= wButUL-Col(k) and wCursorColS <= wButLR-Col(k))

                    perform BigCursorReset   thru BigCursorResetEx
                    compute ROW1c = wButUL-Row(k)
                    compute COL1c = wButUL-Col(k)

                    compute w = k - 1
                    divide  w by 8 giving wBackCol remainder wForeCol
                    compute Ir  = wBackCol + 1
                    compute Ic  = wForeCol + 1

                end-if
            end-perform

                    if wCRT-STATUS = K-LEFT-PRESSED
                       perform BigCursorDisplay thru BigCursorDisplayEx
                       go to DisplayColorDescription
                    end-if

                    if wCRT-STATUS = K-LEFT-DBL-CLICK
                        perform BigCursorDisplay thru BigCursorDisplayEx
                        *> small delay to show the "Big Cursor"
                        call "CBL_GC_NANOSLEEP" USING 250000000 end-call *> pause 0.5 sec

                        move wCRT-STATUS            to Cop-Key
                        move wBackCol               to Cop-BackCol
                        move wForeCol               to Cop-ForeCol
                        move wColorPair-Ele(Ir, Ic) to Cop-ColorPair
                        go to End-Program
                    end-if

      when wCRT-STATUS = K-F1            *> F1 HELP
            perform DisplayHelp thru DisplayHelpEx
            move 1 to Ic Ir
            move 0 to wBackCol wForeCol
            perform BigCursorReset thru BigCursorResetEx
            go to DisplayColorMap
      when wCRT-STATUS = K-F2             *> F2 change frame Fore Color
            add 1 to Cop-Fco Cop-titFco
            If Cop-Fco > 7 move 0 to Cop-Fco Cop-titFco end-if
            move 1 to Ic Ir
            move 0 to wBackCol wForeCol
            perform BigCursorReset thru BigCursorResetEx
            go to DisplayColorMap
      when wCRT-STATUS = K-F3              *> F3 change frame Back Color
            add 1 to Cop-Bco Cop-titBco
            If Cop-Bco > 7 move 0 to Cop-Bco Cop-titBco  end-if
            move 1 to Ic Ir
            move 0 to wBackCol wForeCol
            perform BigCursorReset thru BigCursorResetEx
            go to DisplayColorMap
      when wCRT-STATUS = K-ENTER
        *> or wCRT-STATUS = K-LEFT-DBL-CLICK
            move wCRT-STATUS            to Cop-Key
            move wBackCol               to Cop-BackCol
            move wForeCol               to Cop-ForeCol
            move wColorPair-Ele(Ir, Ic) to Cop-ColorPair
            go to End-Program
      when wCRT-STATUS = K-ESCAPE
        or wCRT-STATUS = K-RIGHT-PRESSED
            move wCRT-STATUS to Cop-Key
            go to End-Program
      when Other
            go to Accept-a-Key
   END-EVALUATE
   continue.

End-Program.
   perform CursorShow thru CursorShowEx
   GOBACK.


*> ***********************************************************************************
*>
*> ***********************************************************************************

BigCursorDisplay.
   *> DISPLAY "THE BIG CURSOR" (a BOX frame around the color code)
   initialize Box-area ALL TO VALUE
   compute Box-r1 = ROW1c - 1   compute Box-c1 = COL1c - 1
   compute Box-r2 = Box-R1 + 2  compute Box-c2 = Box-c1 + 4
   move black     to Box-bco    move 'S'       to Box-style   move 'N' to Box-fill
   perform callGC01BOX thru callGC01BOX-ex
   continue.
BigCursorDisplayEx. exit.

BigCursorReset.
   *> RESET (HIDE) "THE BIG CURSOR"
   initialize Box-area ALL TO VALUE
   compute Box-r1 = ROW1c  - 1   compute Box-c1 = COL1c  - 1
   compute Box-r2 = Box-R1 + 2   compute Box-c2 = Box-c1 + 4
   move black to Box-bco
   move 'N' to Box-style Box-fill
   perform callGC01BOX thru callGC01BOX-ex
   continue.
BigCursorResetEx. exit.

DisplayColorInformation.
   *> Display Back and Fore Colors descriptions under the Color MAP

   compute wLin = ROW1 + 17
   compute wCol = COL1 - 1
   display ' BG: '   at line wLin col wCol :BCOL: Cop-bco :FCOL: Cop-fco highlight end-display
   Compute wCol = wCol + 4
   display wBackCol  at line wLin col wCol :BCOL: Cop-bco :FCOL: Cop-fco highlight end-display
   move    wBackCol  to wColor
   perform DecodeColor thru DecodeColorEx
   Compute wCol = wCol + 1
   display wColordes at line wLin col wCol :BCOL: Cop-bco :FCOL: Cop-fco highlight end-display

   Compute wCol = wCol + 8
   display ' FG: '   at line wLin col wCol :BCOL: Cop-bco :FCOL: Cop-fco highlight end-display
   Compute wCol = wCol + 4
   display wForeCol  at line wLin col wCol :BCOL: Cop-bco :FCOL: Cop-fco highlight end-display
   move    wForeCol  to wColor
   perform DecodeColor thru DecodeColorEx
   Compute wCol = wCol + 1
   display wColordes at line wLin col wCol :BCOL: Cop-bco :FCOL: Cop-fco highlight end-display

   *> Display the "Color pair"
   Compute wCol = wCol + 8
   display ' CP: '   at line wLin col wCol :BCOL: Cop-bco :FCOL: Cop-fco highlight end-display
   Compute wCol = wCol + 4
   display wColorPair-Ele(Ir, Ic) at line wLin col wCol :BCOL: Cop-bco :FCOL: Cop-fco highlight end-display
   Compute wCol = wCol + 2
   display ' '                    at line wLin col wCol :BCOL: Cop-bco :FCOL: Cop-fco end-display
   continue.
DisplayColorInformationEx. exit.

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

callGC01BOX.
    call GC01BOX using by content BOX-AREA
         on exception     display ' CALL GC01BOX error. Module GC01BOX not Found !' at 0501
                          display ' type Enter to continue without boxes ...      ' at 0601
                          accept OMITTED
         not on exception continue
    end-call
    continue.
callGC01BOX-ex. exit.

CursorHide.
    *> save cursor state and hide the cursor
    *> (use always a "display ...at ..."  or an "accept ... at ..." before to have a call to "initscr"
    move wVisibilityNot to wVisibilityNew
    call static "curs_set" using by value wVisibilityNew returning wVisibilityOld end-call
    continue.
CursorHideEx. exit.

CursorShow.
    *> show the cursor - reset to its saved previous state
    move wVisibilityOld to wVisibilityNew
    call static "curs_set" using by value wVisibilityNew returning wVisibilityOld end-call
    continue.
CursorShowEx. exit.

DisplayHelp.
   perform ScreenSave thru ScreenSaveEx

   *> DISPLAY THE FRAME AND THE HELP TEXT
    initialize Boxmex-Area ALL TO VALUE
    move low-value to Bxm-tabmex
    move z' Cursor,Tab, Page, Leftmouse key ' to Bxm-mex(01)
    move z'    to browse the Color Pair map ' to Bxm-mex(02)
    move z' Enter,leftmouse key doubleclick ' to Bxm-mex(03)
    move z' = select the color pair and exit' to Bxm-mex(04)
    move z' ESC/rightmouse click = exit     ' to Bxm-mex(05)
    move z' F1 = displays this screen       ' to Bxm-mex(06)
    move z' F2/F3= chg fore/back frame color' to Bxm-mex(07)
    move z'------ Color Pair Code map ------' to Bxm-mex(08)
    move z' 0B 1B 2G 3R 4C 5M 6Y 7W <-(FG)  ' to Bxm-mex(09)
    move z'  L  L  R  E  Y  A  E  H         ' to Bxm-mex(10)
    move z'  A  U  E  D  A  G  L  I   (BG)  ' to Bxm-mex(11)
    move z' 63 02 01 03 04 05 06 00 0BLACK  ' to Bxm-mex(12)
    move z' 07 08 09 10 11 12 13 14 1BLUE   ' to Bxm-mex(13)
    move z' 15 16 17 18 19 20 21 22 2GREEN  ' to Bxm-mex(14)
    move z' 23 24 25 26 27 28 29 30 3RED    ' to Bxm-mex(15)
    move z' 31 32 33 34 35 36 37 38 4CYAN   ' to Bxm-mex(16)
    move z' 39 40 41 42 43 44 45 46 5MAGENTA' to Bxm-mex(17)
    move z' 47 48 49 50 51 52 53 54 6YELLOW ' to Bxm-mex(18)
    move z' 55 56 57 58 59 60 61 62 7WHITE  ' to Bxm-mex(19)
    move blue     to Bxm-bco    Bxm-titBco Bxm-bcoM
    move white    to Bxm-fco    Bxm-titFco Bxm-fcoM
    move 'Y'      to Bxm-Click  Bxm-tit
    move 'N'      to Bxm-3D     Bxm-OkButton
    move 'S'      to Bxm-style
    move x'B4' & ' Color Pair Picker - HELP '  & x'C3' & x'00' to Bxm-titDes
   compute Bxm-r1 = Cop-r1 - 2   compute Bxm-c1 = Cop-c1 - 2
   compute Bxm-r2 = Bxm-r1 + 20  compute Bxm-c2 = Bxm-c1 + 34
   call GC02BOXMEX using BOXMEX-AREA

   perform ScreenRestore thru ScreenRestoreEx.
DisplayHelpEx. exit.

InitialSettings.
  *> sets in order to detect the PgUp, PgDn, PrtSc(screen print), Esc keys,
  set environment 'COB_SCREEN_EXCEPTIONS' TO 'Y'.
  set environment 'COB_SCREEN_ESC'        TO 'Y'.

  *> make mouse active
  COMPUTE COB-MOUSE-FLAGS = COB-AUTO-MOUSE-HANDLING
                      + COB-ALLOW-LEFT-DOWN   + COB-ALLOW-MIDDLE-DOWN   + COB-ALLOW-RIGHT-DOWN
                      + COB-ALLOW-LEFT-UP     + COB-ALLOW-MIDDLE-UP     + COB-ALLOW-RIGHT-UP
                      + COB-ALLOW-LEFT-DOUBLE + COB-ALLOW-MIDDLE-DOUBLE + COB-ALLOW-RIGHT-DOUBLE
                      + COB-ALLOW-MOUSE-MOVE
  SET environment     "COB_MOUSE_FLAGS"         to COB-MOUSE-FLAGS

  continue.
InitialSettingsEx. exit.

ScreenSave.
   move Z'GC52COLORPICKER.SCR' to wScreenName
   call static 'scr_dump' using by reference wScreenName returning wiScrOk end-call.
ScreenSaveEx. exit.

ScreenRestore.
   call static 'scr_restore' using by reference wScreenName returning wiScrOk end-call
   CALL 'CBL_DELETE_FILE' USING wScreenName.
ScreenRestoreEx. exit.

End Program GC52COLORPICKER.
