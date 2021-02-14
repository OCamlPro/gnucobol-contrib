              >> SOURCE FORMAT IS FREE
REPLACE ==:BCOL:== BY ==with BACKGROUND-COLOR== ==:FCOL:== BY ==FOREGROUND-COLOR==.
IDENTIFICATION DIVISION.
PROGRAM-ID. GC05YESNOCANC is initial.
*> ***********************************************************************************
*> GnuCOBOL TT (TUI TOOLS) COLLECTION
*> Purpose:    DISPLAY  YES, NO & CANCEL BUTTONS ON SCREEN
*>             use cursor keys,mouse left singleclcik,tab/backtab,pgup/dn to activate a button
*>             use Enter or mouse left doubleclick to select and exit
*>             use ESC or other char or mouse right single or doubleclick to to exit
*>             to change colors: ALT-F2/F3 back/foreground of TOOL
*>             to change colors: ALT-F4/F5 back/foreground of active button
*>             to reset colors: ALT-F9
*>             Use colors from 0 to 7 and also from 8 to 15
*> Tectonics:  cobc -m GC05YESNOCANC.COB -lpdcurses (compile with GnuCOBOL 3.1 or greater)
*> Usage:      call GC05YESNOCANC using YESNOCANC-AREA
*> Parameters: look at GC05YESNOCANC.cpy
*> Author:     Eugenio Di Lorenzo - Italia (DILO) - eugenio.dilo@gmail.com
*> License:    (c)2021 E.Di Lorenzo - GNU Lesser General Public License, LGPL, 3.0 (or greater)
*> Version:    1.0 20210202
*> Changelog:  1.0 first release.
*> ***********************************************************************************
*> Displays a Box with a YES a NO and CANCEL buttons and returns the choice to caller
*>
*>                     1         2         3         4
*>            123456789012345678901234567890123456789012345678
*>        1   +--------------------------------------------+
*>        2   | XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX |±±
*>        3   | XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX |±±
*>        4   | XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX |±±
*>        5   |  +----------+  +----------+  +----------+  |±±
*>        6   |  |   YES    |  |    NO    |  |  CANCEL  |  |±±
*>        7   |  +----------+  +----------+  +----------+  |±±
*>        8   |                                            |±±
*>        9   +--------------------------------------------+±±
*>       10    ±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±

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
01  .  *> to save CURSOR position
    05 wCursorRowS      Pic 9(3).
    05 wCursorColS      Pic 9(3).

01  wDummy       PIC X(01) VALUE SPACE.
01  wPrompt      PIC X(01) VALUE SPACE.

01 wYES-Box-r1   pic 999 value zero.
01 wYES-Box-c1   pic 999 value zero.
01 wYES-Box-r2   pic 999 value zero.
01 wYES-Box-c2   pic 999 value zero.
01 wNO-Box-r1    pic 999 value zero.
01 wNO-Box-c1    pic 999 value zero.
01 wNO-Box-r2    pic 999 value zero.
01 wNO-Box-c2    pic 999 value zero.
01 wCANC-Box-r1  pic 999 value zero.
01 wCANC-Box-c1  pic 999 value zero.
01 wCANC-Box-r2  pic 999 value zero.
01 wCANC-Box-c2  pic 999 value zero.

COPY 'GC01BOX.CPY'.
copy 'GC97KEYCODEGC.CPY'  suppress.

LINKAGE SECTION.
COPY 'GC05YESNOCANC.CPY'.

*> ***********************************************************************************
*>           P R O C E D U R E   D I V I S I O N
*> ***********************************************************************************
PROCEDURE DIVISION using YesNoCanc-Area.
    perform InitialSettings thru InitialSettingsEx
    move Ync-Parameters1 to wYnc-Parameters1.              *> useful to reset colors

 DisplayBox-and-Buttons.
    *> Display the BOX containing messages and YES and NO buttons
    perform DisplayBox  thru DisplayBox-ex

    *> Display MESSAGES (3 rows)
    compute wYnc-Lin-mess = Ync-r1 + 1
    compute wYnc-Col-mess = Ync-c1 + 1
    move Ync-mess1 to wYnc-mess
    perform DisplayMessage thru DisplayMessageEx
    compute wYnc-Lin-mess = Ync-r1 + 2
    move Ync-mess2 to wYnc-mess
    perform DisplayMessage thru DisplayMessageEx
    compute wYnc-Lin-mess = Ync-r1 + 3
    move Ync-mess3 to wYnc-mess
    perform DisplayMessage thru DisplayMessageEx

    *> Display YES, NO & CANCEL BUTTONS
    perform DisplayButton-Yes  thru DisplayButton-YesEx
    perform DisplayButton-No   thru DisplayButton-NoEx
    perform DisplayButton-Canc thru DisplayButton-CancEx

    perform HideCursor thru HideCursorEx
    continue.
*> ***********************************************************************************
*> after displayed box and buttons WAIT FOR USER ACTION
*> ***********************************************************************************
Accept-UserAction.
 *> the dummy field is at cursor position of the 1st char of Yes-No Message1 description
 *> it has same back end fore color so it is invisible
 *> the "with Auto-skip" option is useful to detect if cursor up/down/left/right is pressed
   move Ync-Mess2(1:1) to wDummy
   compute wYnc-Lin-mess = Ync-r1 + 7
   compute wYnc-Col-mess = Ync-c1 + 1
   *> use same forecolor  as backcolor to have invisible char
   perform AcceptDummy thru AcceptDummyEx

*> *************************************************************************
*> EVALUATE THE USER ACTION (A KEY OR A MOUSE KEY WASS PRESSED)
*> *************************************************************************
   EVALUATE TRUE
      *> User pressed a Key: check if was one of the following keys to change active button
      when wCRT-STATUS = K-RIGHT
        or wCRT-STATUS = K-DOWN
        or wCRT-STATUS = K-PAGEDOWN
        or wCRT-STATUS = K-TAB

           evaluate Ync-YesNoCanc
             when = 'Y' move 'N' to Ync-YesNoCanc
             when = 'N' move 'C' to Ync-YesNoCanc
             when = 'C' move 'Y' to Ync-YesNoCanc
           end-evaluate
           perform DisplayButton-Yes  thru DisplayButton-YesEx
           perform DisplayButton-No   thru DisplayButton-NoEx
           perform DisplayButton-Canc thru DisplayButton-CancEx

      *> User pressed a Key: check if was one of the following keys to change active button
      when   wCRT-STATUS = K-LEFT
          or wCRT-STATUS = K-UP
          or wCRT-STATUS = K-PAGEUP
          or wCRT-STATUS = K-BACKTAB

           evaluate Ync-YesNoCanc
             when = 'Y' move 'C' to Ync-YesNoCanc
             when = 'N' move 'Y' to Ync-YesNoCanc
             when = 'C' move 'N' to Ync-YesNoCanc
           end-evaluate
           perform DisplayButton-Yes  thru DisplayButton-YesEx
           perform DisplayButton-No   thru DisplayButton-NoEx
           perform DisplayButton-Canc thru DisplayButton-CancEx

      *> User clicked the Left Mouse Key: check if mouse position was on the YES on NO button
      when wCRT-STATUS = K-LEFT-PRESSED or wCRT-STATUS = K-LEFT-DBL-CLICK
            move wCursorRow to wCursorRowS
            move wCursorCol to wCursorColS

            *> if the mouse was on the YES BUTTON and YES button in not active
            if  ( (wCursorRowS >= wYES-Box-r1 and wCursorRowS <= wYES-Box-r2)
            and   (wCursorColS >= wYES-Box-c1 and wCursorColS <= wYES-Box-c2) )
            and Ync-YesNoCanc not = 'Y'
                 move 'Y' to Ync-YesNoCanc  *> make the YES button active
                 perform DisplayButton-Yes  thru DisplayButton-YesEx
                 perform DisplayButton-No   thru DisplayButton-NoEx
                 perform DisplayButton-Canc thru DisplayButton-CancEx
            end-if

            *> if the mouse was on the NO BUTTON and NO button in not active
            if  ( (wCursorRowS >= wNO-Box-r1  and wCursorRowS <= wNO-Box-r2 )
            and   (wCursorColS >= wNO-Box-c1  and wCursorColS <= wNO-Box-c2 ) )
            and Ync-YesNoCanc not = 'N'
                 move 'N' to Ync-YesNoCanc  *> make the NO button active
                 perform DisplayButton-Yes  thru DisplayButton-YesEx
                 perform DisplayButton-No   thru DisplayButton-NoEx
                 perform DisplayButton-Canc thru DisplayButton-CancEx
            end-if

            *> if the mouse was on the CANC BUTTON and CANC button in not active
            if  ( (wCursorRowS >= wCANC-Box-r1  and wCursorRowS <= wCANC-Box-r2 )
            and   (wCursorColS >= wCANC-Box-c1  and wCursorColS <= wCANC-Box-c2 ) )
            and Ync-YesNoCanc not = 'C'
                 move 'C' to Ync-YesNoCanc  *> make the NO button active
                 perform DisplayButton-Yes  thru DisplayButton-YesEx
                 perform DisplayButton-No   thru DisplayButton-NoEx
                 perform DisplayButton-Canc thru DisplayButton-CancEx
            end-if

            if wCRT-STATUS = K-LEFT-DBL-CLICK

                *> small delay to show the new active button
                call "CBL_GC_NANOSLEEP" USING 250000000 end-call *> pause 0.5 sec
      *> *****************************************************************
      *> inserire un "effetto click !!!  prima di uscire
      *> *****************************************************************
                move wCRT-STATUS  to Ync-Key
                go to End-Program
            end-if
      when wCRT-STATUS = K-ALT-F2  *> change Back Color of "non active" BUTTON and the YESNO box
            add 1 to Ync-BcoNonSel
            If Ync-BcoNonSel > 15 move 0 to Ync-BcoNonSel end-if
            go to DisplayBox-and-Buttons
      when wCRT-STATUS = K-ALT-F3  *> change Fore Color of "non active" BUTTON and the YESNO box
            add 1 to Ync-FcoNonSel
            If Ync-FcoNonSel > 15 move 0 to Ync-FcoNonSel end-if
            go to DisplayBox-and-Buttons
      when wCRT-STATUS = K-ALT-F4    *> change Back Color of "active" BUTTON
            add 1 to Ync-BcoSel
            If Ync-BcoSel > 15 move 0 to Ync-BcoSel end-if
            go to DisplayBox-and-Buttons
      when wCRT-STATUS = K-ALT-F5   *> change Fore Color of "active" BUTTON
            add 1 to Ync-FcoSel
            If Ync-FcoSel > 15 move 0 to Ync-FcoSel end-if
            go to DisplayBox-and-Buttons
      when wCRT-STATUS = K-ALT-F9              *> reset params & colors to initial state
            move wYnc-Parameters1 to Ync-Parameters1
            go to DisplayBox-and-Buttons
   *> *************************************************************************
   *> EXIT WITH ONE OF FOLLOWING KEYS
   *> *************************************************************************
       when wCRT-STATUS = K-ENTER
         or wCRT-STATUS = K-ESCAPE
         or wCRT-STATUS = K-RIGHT-PRESSED
         or wCRT-STATUS = K-RIGHT-DBL-CLICK
            move wCRT-STATUS to Ync-Key
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
    move Ync-shadow    to Box-shadow
    move Ync-Box-Style to Box-style
    move Ync-Box-3D    to Box-3D
    move Ync-BcoNonSel to Box-bco
    move Ync-FcoNonSel to Box-fco
    move Ync-r1        to Box-r1
    move Ync-c1        to Box-c1
    compute Box-r2 = Ync-r1 + 8
    compute Box-c2 = Ync-c1 + 41
    CALL GC01BOX USING BY CONTENT Box-AREA.
DisplayBox-Ex. exit.

*> ************************************************************************************
*> "YES" BUTTON
*> ************************************************************************************
DisplayButton-Yes.
   initialize Box-area ALL TO VALUE
   move 'N'           to Box-shadow
   move Ync-Button-3D to Box-3D
   if Ync-YesNoCanc = 'Y'
      move 'D' to Box-style
      set Box-bco to Ync-BcoSel    *> display YES as Selected Button
      set Box-fco to Ync-FcoSel
   else
      move 'S' to Box-style
      set Box-bco to Ync-BcoNonSel *> display YES as Non Selected Button
      set Box-fco to Ync-FcoNonSel
   end-if
   compute Box-r1 = Ync-r1 + 04  move Box-r1 to wYES-Box-r1
   compute Box-c1 = Ync-c1 + 02  move Box-c1 to wYES-Box-c1
   compute Box-r2 = Ync-r1 + 06  move Box-r2 to wYES-Box-r2
   compute Box-c2 = Ync-c1 + 13  move Box-c2 to wYES-Box-c2
   CALL GC01BOX USING BY CONTENT Box-AREA

   Move Ync-ButtonYES-label to wYnc-Button
   Move 2       to x               *> Button 1 position
   compute wlin = Ync-r1 + 5       *> cursor row
   perform DisplayButtonLabel thru DisplayButtonLabel-ex
   continue.
DisplayButton-YesEx. exit.

*> ************************************************************************************
*> "NO" BUTTON
*> ************************************************************************************
DisplayButton-No.
   initialize Box-area ALL TO VALUE
   move 'N'          to Box-shadow
   move Ync-Button-3D to Box-3D
   if Ync-YesNoCanc = 'N'
      move 'D' to Box-style
      set Box-bco to Ync-BcoSel     *> display NO as Selected Button
      set Box-fco to Ync-FcoSel
   else
      set Box-bco to Ync-BcoNonSel  *> display NO as Non Selected Button
      set Box-fco to Ync-FcoNonSel
      move 'S' to Box-style
   end-if

   compute Box-r1 = Ync-r1 + 04 move Box-r1 to wNO-Box-r1
   compute Box-c1 = Ync-c1 + 15 move Box-c1 to wNO-Box-c1
   compute Box-r2 = Ync-r1 + 06 move Box-r2 to wNO-Box-r2
   compute Box-c2 = Ync-c1 + 26 move Box-c2 to wNO-Box-c2
   CALL GC01BOX USING BY CONTENT Box-AREA

   Move Ync-ButtonNO-label  to wYnc-Button
   Move 15     to x             *> Button 1 position
   compute wlin = Ync-r1 + 5    *> cursor position
   perform DisplayButtonLabel thru DisplayButtonLabel-ex
   continue.
DisplayButton-NoEx. exit.

*> ************************************************************************************
*> "CANCEL" BUTTON
*> ************************************************************************************
DisplayButton-Canc.
   initialize Box-area ALL TO VALUE
   move 'N'           to Box-shadow
   move Ync-Button-3D to Box-3D
   if Ync-YesNoCanc = 'C'
      move 'D' to Box-style
      set Box-bco to Ync-BcoSel     *> display CANCEL as Selected Button
      set Box-fco to Ync-FcoSel
   else
      set Box-bco to Ync-BcoNonSel  *> display CANCEL as Non Selected Button
      set Box-fco to Ync-FcoNonSel
      move 'S' to Box-style
   end-if

   compute Box-r1 = Ync-r1 + 04 move Box-r1 to wCANC-Box-r1
   compute Box-c1 = Ync-c1 + 28 move Box-c1 to wCANC-Box-c1
   compute Box-r2 = Ync-r1 + 06 move Box-r2 to wCANC-Box-r2
   compute Box-c2 = Ync-c1 + 39 move Box-c2 to wCANC-Box-c2
   CALL GC01BOX USING BY CONTENT Box-AREA

   Move Ync-ButtonCanc-label  to wYnc-Button
   Move 28     to x              *> Button 1 position
   compute wlin = Ync-r1 + 5     *> cursor position
   perform DisplayButtonLabel thru DisplayButtonLabel-ex
   continue.
DisplayButton-CancEx. exit.

*> ***********************************************************************************
*> DISPLAY BUTTON LABEL
*> ***********************************************************************************
DisplayButtonLabel.
   move 0 to j.
DisplayButtonLabel-Loop.
   if j >= 10 go DisplayButtonLabel-Ex end-if
   add 1 to j
   compute wcol = Ync-c1 + x + j
   perform DisplayButtonLabelChar thru DisplayButtonLabelCharEx
   go to DisplayButtonLabel-Loop.
DisplayButtonLabel-Ex. exit.

DisplayButtonLabelChar.
  evaluate true
     when Box-bco > 7 and Box-fco >  7
         compute wBox-bco = Box-bco - 8
         compute wBox-fco = Box-fco - 8
         display wYnc-Button (j:1) at line wlin col wcol :BCOL: wBox-bco :FCOL: wBox-fco blink highlight
      when Box-bco > 7 and Box-fco <= 7
         compute wBox-bco = Box-bco - 8
         compute wBox-fco = Box-fco
         display wYnc-Button (j:1) at line wlin col wcol :BCOL: wBox-bco :FCOL: wBox-fco blink
     when Box-bco <= 7 and Box-fco >  7
         compute wBox-bco = Box-bco
         compute wBox-fco = Box-fco - 8
         display wYnc-Button (j:1) at line wlin col wcol :BCOL: wBox-bco :FCOL: wBox-fco highlight
     when Box-bco <= 7 and Box-fco <= 7
         compute wBox-bco = Box-bco
         compute wBox-fco = Box-fco
         display wYnc-Button (j:1) at line wlin col wcol :BCOL: wBox-bco :FCOL: wBox-fco
  end-evaluate
continue.
DisplayButtonLabelCharEx. exit.

DisplayMessage.
  evaluate true
     when Ync-BcoNonSel > 7 and Ync-FcoNonSel >  7
         compute wYnc-BcoNonSel = Ync-BcoNonSel - 8
         compute wYnc-FcoNonSel = Ync-FcoNonSel - 8
         display wYnc-mess at line wYnc-Lin-mess col wYnc-Col-mess :BCOL: wYnc-BcoNonSel :FCOL: wYnc-FcoNonSel blink highlight
     when Ync-BcoNonSel > 7 and Ync-FcoNonSel <= 7
         compute wYnc-BcoNonSel = Ync-BcoNonSel - 8
         compute wYnc-FcoNonSel = Ync-FcoNonSel
         display wYnc-mess at line wYnc-Lin-mess col wYnc-Col-mess :BCOL: wYnc-BcoNonSel :FCOL: wYnc-FcoNonSel blink
     when Ync-BcoNonSel <= 7 and Ync-FcoNonSel >  7
         compute wYnc-BcoNonSel = Ync-BcoNonSel
         compute wYnc-FcoNonSel = Ync-FcoNonSel - 8
         display wYnc-mess at line wYnc-Lin-mess col wYnc-Col-mess :BCOL: wYnc-BcoNonSel :FCOL: wYnc-FcoNonSel highlight
      when Ync-BcoNonSel <= 7 and Ync-FcoNonSel <=  7
         compute wYnc-BcoNonSel = Ync-BcoNonSel
         compute wYnc-FcoNonSel = Ync-FcoNonSel
         display wYnc-mess at line wYnc-Lin-mess col wYnc-Col-mess :BCOL: wYnc-BcoNonSel :FCOL: wYnc-FcoNonSel
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
     when Ync-BcoNonSel > 7 and Ync-FcoNonSel >  7
         compute wYnc-BcoNonSel = Ync-BcoNonSel - 8
         compute wYnc-FcoNonSel = Ync-FcoNonSel - 8
         accept wDummy at line wYnc-Lin-mess col wYnc-Col-mess
               :BCOL: Ync-BcoNonSel :FCOL: Ync-BcoNonSel auto-skip blink highlight
     when Ync-BcoNonSel > 7 and Ync-FcoNonSel <= 7
         compute wYnc-BcoNonSel = Ync-BcoNonSel - 8
         compute wYnc-FcoNonSel = Ync-FcoNonSel
          accept wDummy at line wYnc-Lin-mess col wYnc-Col-mess
               :BCOL: Ync-BcoNonSel :FCOL: Ync-BcoNonSel auto-skip blink
     when Ync-BcoNonSel <= 7 and Ync-FcoNonSel >  7
         compute wYnc-BcoNonSel = Ync-BcoNonSel
         compute wYnc-FcoNonSel = Ync-FcoNonSel - 8
         accept wDummy at line wYnc-Lin-mess col wYnc-Col-mess
               :BCOL: Ync-BcoNonSel :FCOL: Ync-BcoNonSel auto-skip highlight
      when Ync-BcoNonSel <= 7 and Ync-FcoNonSel <=  7
         compute wYnc-BcoNonSel = Ync-BcoNonSel
         compute wYnc-FcoNonSel = Ync-FcoNonSel
          accept wDummy at line wYnc-Lin-mess col wYnc-Col-mess
               :BCOL: Ync-BcoNonSel :FCOL: Ync-BcoNonSel auto-skip
  end-evaluate
  continue.
AcceptDummyEx. exit.

End Program GC05YESNOCANC.
