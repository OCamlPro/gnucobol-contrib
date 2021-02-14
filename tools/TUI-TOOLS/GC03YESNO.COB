              >> SOURCE FORMAT IS FREE
       REPLACE ==:BCOL:== BY ==with BACKGROUND-COLOR==
               ==:FCOL:== BY      ==FOREGROUND-COLOR==.
IDENTIFICATION DIVISION.
PROGRAM-ID. GC03YESNO is initial.
*> ***********************************************************************************
*> GnuCOBOL TT (TUI TOOLS) COLLECTION
*> Purpose:    DISPLAY  YES & NO BUTTONS ON SCREEN
*> Tectonics:  cobc -m GC03YESNO.COB -lpdcurses (compile with GnuCOBOL 3.1 or greater)
*> Usage:      call GC03YESNO using YESNO-AREA
*> Parameters: look at GC03YESNO.cpy
*> Author:     Eugenio Di Lorenzo - Italia (DILO) - eugenio.dilo@gmail.com
*> License:    Copyright 2021 E.Di Lorenzo - GNU Lesser General Public License, LGPL, 3.0 (or greater)
*> Version:    2.0 20210202
*> Changelog:  1.0 first release.
*>             2.0 - mouse management is added:
*>                   changed from "call getch" to ACCEPT a DUMMY field
*>                   left click on a BUTTON to make it "active" (same as using cursor keys);
*>                   double left-click is same as Enter ( select a Button)
*>                   right click or double-right-click is same as ESCAPE
*>                 - YES and NO labels of buttons are now available as parameters
*>                 - colors from 9(01) to 9(02) to manage also colors fron 08 to 15
*>                 - added use of ALT-F2/3/4/5 to change colors
*> ***********************************************************************************
*> Displays a Box with a YES and NO options and returns the choice to caller
*> the BOX has a fixed size of 10 rows and 40 cols (included row/col for shadow)
*>
*>                     1         2         3         4
*>            1234567890123456789012345678901234567890
*>
*>        1   +------------------------------------+
*>        2   | XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX |北
*>        3   | XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX |北
*>        4   | XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX |北
*>        5   |    +----------+   +----------+     |北
*>        6   |    |   YES    |   |    NO    |     |北
*>        7   |    +----------+   +----------+     |北
*>        8   |                                    |北
*>        9   +------------------------------------+北
*>       10     北北北北北北北北北北北北北北北北北北北

ENVIRONMENT DIVISION.
CONFIGURATION SECTION.
SPECIAL-NAMES.
    CRT STATUS IS wCRT-STATUS.    *> Return Code from Accept (ex.PF Keys, Mouse Keys)
    CURSOR     IS wCursorRowCol.  *> Cursor Position
DATA DIVISION.
WORKING-STORAGE SECTION.
copy GC00COLORS.CPY.

01 wVisibilityNew  BINARY-SHORT . *> SIGNED.
01 wVisibilityOld  BINARY-SHORT . *> SIGNED.
01 wVisibilityNew9  pic 9(8).
01 wVisibilityOld9  pic 9(8).
*> 01 bco-sel     PIC 9.
*> 01 fco-sel     PIC 9.
*> 01 bco-nonsel  PIC 9.
*> 01 fco-nonsel  PIC 9.

01  j          pic s9(02) comp-5 value  +0.
01  x          pic s9(02) comp-5 value  +0.

01  wcol       PIC 9(03).
01  wlin       PIC 9(03).
01  wBox-bco   pic 9(02).
01  wBox-fco   pic 9(02).

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
01  COB-MOUSE-FLAGS         PIC 9(04).

01  wCRT-STATUS         PIC 9(04) VALUE 9999.

01  wCursorRowCol       PIC 9(06) value 0000.
01  redefines wCursorRowCol .
    05 wCursorRow       Pic 9(03).
    05 wCursorCol       Pic 9(03).
01  .                                          *> to save CUROR position
    05 wCursorRowS       Pic 9(3).
    05 wCursorColS       Pic 9(3).

01  wDummy       PIC X(01) VALUE SPACE.
01  wPrompt      PIC X(01) VALUE SPACE.

01 wYES-Box-r1 pic 999 value zero.
01 wYES-Box-c1 pic 999 value zero.
01 wYES-Box-r2 pic 999 value zero.
01 wYES-Box-c2 pic 999 value zero.
01 wNO-Box-r1  pic 999 value zero.
01 wNO-Box-c1  pic 999 value zero.
01 wNO-Box-r2  pic 999 value zero.
01 wNO-Box-c2  pic 999 value zero.

COPY 'GC01BOX.CPY'.
copy 'GC97KEYCODEGC.CPY'  suppress.

LINKAGE SECTION.
COPY 'GC03YESNO.CPY'.

*> ***********************************************************************************
*>           P R O C E D U R E   D I V I S I O N
*> ***********************************************************************************
PROCEDURE DIVISION using YesNo-Area.
    perform InitialSettings thru InitialSettingsEx
    move Yn-Parameters1 to wYn-Parameters1.              *> useful to reset colors

 DisplayBox-and-Buttons.
    *> Display the BOX containing messages and YES and NO buttons
    perform DisplayBox  thru DisplayBox-ex

    *> Display MESSAGES (3 rows)
    compute wYn-Lin-mess = Yn-r1 + 1
    compute wYn-Col-mess = Yn-c1 + 1
    move Yn-mess1 to wYn-mess
    perform DisplayMessage thru DisplayMessageEx
    compute wYn-Lin-mess = Yn-r1 + 2
    move Yn-mess2 to wYn-mess
    perform DisplayMessage thru DisplayMessageEx
    compute wYn-Lin-mess = Yn-r1 + 3
    move Yn-mess3 to wYn-mess
    perform DisplayMessage thru DisplayMessageEx

    *> Display YES and NO BUTTONS
    perform DisplayButton-Yes thru DisplayButton-YesEx
    perform DisplayButton-No  thru DisplayButton-NoEx

    perform HideCursor thru HideCursorEx
    continue.
*> ***********************************************************************************
*> after displayed box and buttons WAIT FOR USER ACTION
*> ***********************************************************************************
Accept-UserAction.
 *> the dummy field is at cursor position of the 1st char of Yes-No Message1 description
 *> it has same back end fore color so it is invisible
 *> the "with Auto-skip" option is useful to detect if cursor up/down/left/right is pressed
   move Yn-Mess2(1:1) to wDummy
   compute wYn-Lin-mess = Yn-r1 + 7
   compute wYn-Col-mess = Yn-c1 + 1
   *> use same forecolor  as backcolor to have invisible char
   perform AcceptDummy thru AcceptDummyEx
   *> accept wDummy at line wYn-Lin-mess col wYn-Col-mess
   *>       :BCOL: Yn-BcoNonSel :FCOL: Yn-BcoNonSel auto-skip prompt is wPrompt

*> *************************************************************************
*> EVALUATE THE USER ACTION (A KEY OR A MOUSE KEY WASS PRESSED)
*> *************************************************************************
   EVALUATE TRUE
      *> User pressed a Key: check if was one of the following keys to change active button
      when wCRT-STATUS = K-RIGHT    or wCRT-STATUS = K-LEFT
        or wCRT-STATUS = K-DOWN     or wCRT-STATUS = K-UP
        or wCRT-STATUS = K-PAGEDOWN or wCRT-STATUS = K-PAGEUP
        or wCRT-STATUS = K-TAB      or wCRT-STATUS = K-BACKTAB

           if Yn-yesno = 'Y' move 'N' to Yn-yesno else move 'Y' to Yn-yesno end-if
           perform DisplayButton-Yes thru DisplayButton-YesEx
           perform DisplayButton-No  thru DisplayButton-NoEx

      *> User clicked the Left Mouse Key: check if mouse position was on the YES on NO button
      when wCRT-STATUS = K-LEFT-PRESSED or wCRT-STATUS = K-LEFT-DBL-CLICK
            move wCursorRow to wCursorRowS
            move wCursorCol to wCursorColS

            *> if the mouse was on the YES BUTTON and YES button in not active
            if  ( (wCursorRowS >= wYES-Box-r1 and wCursorRowS <= wYES-Box-r2)
            and   (wCursorColS >= wYES-Box-c1 and wCursorColS <= wYES-Box-c2) )
            and Yn-yesno = 'N'
                 move 'Y' to Yn-yesno  *> make the YES button active
                 perform DisplayButton-Yes thru DisplayButton-YesEx
                 perform DisplayButton-No  thru DisplayButton-NoEx
            end-if

            *> if the mouse was on the NO BUTTON and NO button in not active
            if  ( (wCursorRowS >= wNO-Box-r1  and wCursorRowS <= wNO-Box-r2 )
            and   (wCursorColS >= wNO-Box-c1  and wCursorColS <= wNO-Box-c2 ) )
            and Yn-yesno = 'Y'
                 move 'N' to Yn-yesno  *> make the NO button active
                 perform DisplayButton-Yes thru DisplayButton-YesEx
                 perform DisplayButton-No  thru DisplayButton-NoEx
            end-if

            if wCRT-STATUS = K-LEFT-DBL-CLICK

                *> small delay to show the new active button
                call "CBL_GC_NANOSLEEP" USING 250000000 end-call *> pause 0.5 sec
      *> *****************************************************************
      *> inserire un "effetto click !!!  prina di uscire
      *> *****************************************************************
                move wCRT-STATUS            to Yn-Key
                go to End-Program
            end-if
      when wCRT-STATUS = K-ALT-F2  *> change Back Color of "non active" BUTTON and the YESNO box
            add 1 to Yn-BcoNonSel
            If Yn-BcoNonSel > 15 move 0 to Yn-BcoNonSel end-if
            go to DisplayBox-and-Buttons
      when wCRT-STATUS = K-ALT-F3  *> change Fore Color of "non active" BUTTON and the YESNO box
            add 1 to Yn-FcoNonSel
            If Yn-FcoNonSel > 15 move 0 to Yn-FcoNonSel end-if
            go to DisplayBox-and-Buttons
      when wCRT-STATUS = K-ALT-F4    *> change Back Color of "active" BUTTON
            add 1 to Yn-BcoSel
            If Yn-BcoSel > 15 move 0 to Yn-BcoSel end-if
            go to DisplayBox-and-Buttons
      when wCRT-STATUS = K-ALT-F5   *> change Fore Color of "active" BUTTON
            add 1 to Yn-FcoSel
            If Yn-FcoSel > 15 move 0 to Yn-FcoSel end-if
            go to DisplayBox-and-Buttons
      when wCRT-STATUS = K-ALT-F9              *> reset params & colors to initial state
            move wYn-Parameters1 to Yn-Parameters1
            go to DisplayBox-and-Buttons
   *> *************************************************************************
   *> EXIT WITH ONE OF FOLLOWING KEYS
   *> *************************************************************************
       when wCRT-STATUS = K-ENTER
         or wCRT-STATUS = K-ESCAPE
         or wCRT-STATUS = K-RIGHT-PRESSED
         or wCRT-STATUS = K-RIGHT-DBL-CLICK
            move wCRT-STATUS to Yn-Key
            go to END-PROGRAM
   END-EVALUATE

   go to Accept-UserAction
   continue.

End-Program.
   perform ShowCursor thru ShowCursorEx
   goback.


*> ***********************************************************************************
*>
*> ***********************************************************************************
DisplayBox.
    initialize Box-area ALL TO VALUE
    move Yn-shadow    to Box-shadow
    move Yn-Box-Style to Box-style
    move Yn-Box-3D    to Box-3D
    move Yn-BcoNonSel to Box-bco
    move Yn-FcoNonSel to Box-fco
    move Yn-r1        to Box-r1
    move Yn-c1        to Box-c1
    compute Box-r2 = Yn-r1 + 8
    compute Box-c2 = Yn-c1 + 37
    CALL GC01BOX USING BY CONTENT Box-AREA.
DisplayBox-Ex. exit.

*> ************************************************************************************
*> "YES" BUTTON
*> ************************************************************************************
DisplayButton-Yes.
   initialize Box-area ALL TO VALUE
   move 'N'          to Box-shadow
   move Yn-Button-3D to Box-3D
   if Yn-yesno = 'Y'
      move 'D' to Box-style
      set Box-bco to Yn-BcoSel    *> Selected Button
      set Box-fco to Yn-FcoSel
   else
      move 'S' to Box-style
      set Box-bco to Yn-BcoNonSel *> Non Selected Button
      set Box-fco to Yn-FcoNonSel
   end-if
   compute Box-r1 = Yn-r1 + 04  move Box-r1 to wYES-Box-r1
   compute Box-c1 = Yn-c1 + 05  move Box-c1 to wYES-Box-c1
   compute Box-r2 = Yn-r1 + 06  move Box-r2 to wYES-Box-r2
   compute Box-c2 = Yn-c1 + 16  move Box-c2 to wYES-Box-c2
   CALL GC01BOX USING BY CONTENT Box-AREA

   Move Yn-ButtonYES-label to wYn-Button
   Move 5       to x              *> Button 1 position
   compute wlin = Yn-r1 + 5       *> cursor row
   perform DisplayButtonLabel thru DisplayButtonLabel-ex
   continue.
DisplayButton-YesEx. exit.

*> ************************************************************************************
*> "NO" BUTTON
*> ************************************************************************************
DisplayButton-No.
   initialize Box-area ALL TO VALUE
   move 'N'          to Box-shadow
   move Yn-Button-3D to Box-3D
   if Yn-yesno = 'N'
      move 'D' to Box-style
      set Box-bco to Yn-BcoSel     *> Selected Button
      set Box-fco to Yn-FcoSel
   else
      set Box-bco to Yn-BcoNonSel  *> Non Selected Button
      set Box-fco to Yn-FcoNonSel
      move 'S' to Box-style
   end-if

   compute Box-r1 = Yn-r1 + 04 move Box-r1 to wNO-Box-r1
   compute Box-r2 = Yn-r1 + 06 move Box-r2 to wNO-Box-r2
   compute Box-c1 = Yn-c1 + 20 move Box-c1 to wNO-Box-c1
   compute Box-c2 = Yn-c1 + 31 move Box-c2 to wNO-Box-c2
   CALL GC01BOX USING BY CONTENT Box-AREA

   Move Yn-ButtonNO-label  to wYn-Button
   Move 20     to x             *> Button 1 position
   compute wlin = Yn-r1 + 5     *> cursor position
   perform DisplayButtonLabel thru DisplayButtonLabel-ex
   continue.
DisplayButton-NoEx. exit.

*> ***********************************************************************************
*> DISPLAY BUTTON LABEL
*> ***********************************************************************************
DisplayButtonLabel.
   move 0 to j.
DisplayButtonLabel-Loop.
   if j >= 10 go DisplayButtonLabel-Ex end-if
   add 1 to j
   compute wcol = Yn-c1 + x + j
   perform DisplayButtonLabelChar thru DisplayButtonLabelCharEx
   go to DisplayButtonLabel-Loop.
DisplayButtonLabel-Ex. exit.

DisplayButtonLabelChar.
  evaluate true
     when Box-bco > 7 and Box-fco >  7
         compute wBox-bco = Box-bco - 8
         compute wBox-fco = Box-fco - 8
         display wYn-Button (j:1) at line wlin col wcol :BCOL: wBox-bco :FCOL: wBox-fco blink highlight
      when Box-bco > 7 and Box-fco <= 7
         compute wBox-bco = Box-bco - 8
         compute wBox-fco = Box-fco
         display wYn-Button (j:1) at line wlin col wcol :BCOL: wBox-bco :FCOL: wBox-fco blink
     when Box-bco <= 7 and Box-fco >  7
         compute wBox-bco = Box-bco
         compute wBox-fco = Box-fco - 8
         display wYn-Button (j:1) at line wlin col wcol :BCOL: wBox-bco :FCOL: wBox-fco highlight
     when Box-bco <= 7 and Box-fco <= 7
         compute wBox-bco = Box-bco
         compute wBox-fco = Box-fco
         display wYn-Button (j:1) at line wlin col wcol :BCOL: wBox-bco :FCOL: wBox-fco
  end-evaluate
continue.
DisplayButtonLabelCharEx. exit.

DisplayMessage.
  evaluate true
     when Yn-BcoNonSel > 7 and Yn-FcoNonSel >  7
         compute wYn-BcoNonSel = Yn-BcoNonSel - 8
         compute wYn-FcoNonSel = Yn-FcoNonSel - 8
         display wYn-mess at line wYn-Lin-mess col wYn-Col-mess :BCOL: wYn-BcoNonSel :FCOL: wYn-FcoNonSel blink highlight
     when Yn-BcoNonSel > 7 and Yn-FcoNonSel <= 7
         compute wYn-BcoNonSel = Yn-BcoNonSel - 8
         compute wYn-FcoNonSel = Yn-FcoNonSel
         display wYn-mess at line wYn-Lin-mess col wYn-Col-mess :BCOL: wYn-BcoNonSel :FCOL: wYn-FcoNonSel blink
     when Yn-BcoNonSel <= 7 and Yn-FcoNonSel >  7
         compute wYn-BcoNonSel = Yn-BcoNonSel
         compute wYn-FcoNonSel = Yn-FcoNonSel - 8
         display wYn-mess at line wYn-Lin-mess col wYn-Col-mess :BCOL: wYn-BcoNonSel :FCOL: wYn-FcoNonSel highlight
      when Yn-BcoNonSel <= 7 and Yn-FcoNonSel <=  7
         compute wYn-BcoNonSel = Yn-BcoNonSel
         compute wYn-FcoNonSel = Yn-FcoNonSel
         display wYn-mess at line wYn-Lin-mess col wYn-Col-mess :BCOL: wYn-BcoNonSel :FCOL: wYn-FcoNonSel
  end-evaluate
continue.
DisplayMessageEx. exit.



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

HideCursor.
  *> hide the cursor and save its previous state
  *> (use always a display or an accept at .... before to have a call to "initscr"
  move 0 to wVisibilityNew
  call static "curs_set" using by value wVisibilityNew returning wVisibilityOld end-call
  continue.
HideCursorEx. exit.

ShowCursor.
  *> reset (re-show) the cursor to its previous state
  move wVisibilityOld to wVisibilityNew
  call static "curs_set" using by value wVisibilityNew returning wVisibilityOld end-call
  continue.
ShowCursorEx. exit.

AcceptDummy.
   *> use same fore & back color
   evaluate true
     when Yn-BcoNonSel > 7 and Yn-FcoNonSel >  7
         compute wYn-BcoNonSel = Yn-BcoNonSel - 8
         compute wYn-FcoNonSel = Yn-FcoNonSel - 8
         accept wDummy at line wYn-Lin-mess col wYn-Col-mess
               :BCOL: Yn-BcoNonSel :FCOL: Yn-BcoNonSel auto-skip blink highlight
     when Yn-BcoNonSel > 7 and Yn-FcoNonSel <= 7
         compute wYn-BcoNonSel = Yn-BcoNonSel - 8
         compute wYn-FcoNonSel = Yn-FcoNonSel
          accept wDummy at line wYn-Lin-mess col wYn-Col-mess
               :BCOL: Yn-BcoNonSel :FCOL: Yn-BcoNonSel auto-skip blink
     when Yn-BcoNonSel <= 7 and Yn-FcoNonSel >  7
         compute wYn-BcoNonSel = Yn-BcoNonSel
         compute wYn-FcoNonSel = Yn-FcoNonSel - 8
         accept wDummy at line wYn-Lin-mess col wYn-Col-mess
               :BCOL: Yn-BcoNonSel :FCOL: Yn-BcoNonSel auto-skip highlight
      when Yn-BcoNonSel <= 7 and Yn-FcoNonSel <=  7
         compute wYn-BcoNonSel = Yn-BcoNonSel
         compute wYn-FcoNonSel = Yn-FcoNonSel
          accept wDummy at line wYn-Lin-mess col wYn-Col-mess
               :BCOL: Yn-BcoNonSel :FCOL: Yn-BcoNonSel auto-skip
  end-evaluate
continue.
AcceptDummyEx. exit.


End Program GC03YESNO.
