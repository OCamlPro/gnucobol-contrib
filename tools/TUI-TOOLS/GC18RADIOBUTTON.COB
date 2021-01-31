       >> SOURCE FORMAT IS FREE
REPLACE ==:BCOL:== BY ==BACKGROUND-COLOR==
        ==:FCOL:== BY ==FOREGROUND-COLOR==.

IDENTIFICATION DIVISION.
PROGRAM-ID. GC18RADIOBUTTON is initial.
*> ***********************************************************************************
*> GnuCOBOL TT (TUI TOOLS) AND UTILITIES COLLECTION
*> Purpose:    DISPLAYS AND MANAGE RADIOBUTTON ITEMS ON SCREEN
*>             only one of the items "marked/selected" with cursor keys or left mousekey singleclick
*>             exit with: ENTER, TAB/BACKTAB, ESC, PAGEUP/DOWN, single or doubleclick of right mousekey
*> Tectonics:  cobc -m GC18RADIOBUTTON.COB -lpdcurses (compile with GnuCOBOL 3.1 or greater)
*> Usage:      call GC18RADIOBUTTON using RADIOBUTTON-AREA
*> Parameters: look at GC18RADIOBUTTON.cpy (use with copy Version: 2.0)
*> Author:     Eugenio Di Lorenzo - Italia (DILO) - eugenio.dilo@gmail.com
*> License:    Copyright 2021 E.Di Lorenzo - GNU Lesser General Public License, LGPL, 3.0 (or greater)
*> Version:    2.1 2021.01.31
*> Changelog:  1.0 first release.
*>             1.1 hot key management added
*>             1.2 Rb-Hot from 9(01) to 9(02)
*>             1.3 Rb-wait management added
*>             1.4 Rbu-Number changed to Rb-Number that is added in GC18RADIOBUTTON.cpy
*>                 Use PgUp, PgDn, Tab to exit from Radiobutton
*>             2.0 mouse management is added
*>                 changed from "call getch" to ACCEPT a DUMMY field
*>                 added single click of left mousekey on a radiobutton to make it active and marked
*>                 double left-click is same as Enter
*>                 single or doubleclick of right mousekey is same as ESCAPE
*>             2.1 F1, ALT-F2/F3/F4/F5/F6/F7/F9 added (HELP and change colors)
*>
*> You can manage a group of max 98 RADIOBUTTON items on screen, each of 1 row (also overlapped).
*> Each radiobutton item has to be inserted in a table with 99 elements
*> there have to be a last item in the table, filled with low-value
*>
*> Example of use.
*> step 1. display a box (not mandatory ) but useful to have better user interface
*> step 2. display a group of RADIOBUTTON items (switches) inside the BOX
*> step 3. wait for a user action . Some user actions:
*>  use cursor keys to activate and mark a radiobutton
*>  use left mouse key single or doubleclick on a radiobutton = activate and mark the radiobutton
*>  To exit from radiobutton mgmt use: TAB, ENTER, ESC, PGUP/DOWN, right mouse key single or doubleclick
*>
*> sample schema of RADIOBUTTON items list with 6 items
*>
*>       +----------------------------------------+
*>       |  ( ) aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa  |
*>       |  ( ) bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb  |
*>       |  ( ) cccccccccccccccccccccccccccccccc  |
*>       |  (o) dddddddddddddddddddddddddddddddd  |
*>       |  ( ) eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee  |
*>       |  ( ) ffffffffffffffffffffffffffffffff  |
*>       +----------------------------------------+
*> ***********************************************************************************
ENVIRONMENT DIVISION.
CONFIGURATION SECTION.
SPECIAL-NAMES.
    CRT STATUS IS wCRT-STATUS.    *> Return Code from Accept (ex.PF Keys, Mouse Keys)
    CURSOR     IS wCursorRowCol.  *> Cursor Position

DATA DIVISION.
Working-Storage Section.
01  wWork.
    03  wCol         pic 9(02) value 0.
    03  w            pic 9(02) value 0.
    03  i            pic 9(02) value 1.
    03  j            pic 9(02) value 1.
    03  k            pic 9(02) value 1.
    03  y            pic 9(02) value 1.
    03  bco          PIC 9(02).
    03  fco          PIC 9(02).
    03  fcoH         PIC X(01).
    03  wDummy       PIC X(01) VALUE SPACE.
    03  wPrompt      PIC X(01) VALUE SPACE.
    03  wRb-c        pic 9(03) value zero.
    03  wlen         pic 9(02) value 0.
    03  len-voce     pic 9(02) value 0.

01 black   constant as 0.
01 blue    constant as 1.
01 green   constant as 2.
01 cyan    constant as 3.
01 red     constant as 4.
01 magenta constant as 5.
01 yellow  constant as 6.  *> or Brown
01 white   constant as 7.

01  wVisibilityNew   BINARY-SHORT .
01  wVisibilityOld   BINARY-SHORT .
01  wVisibilityNot   BINARY-SHORT .
01  wCursorShow       BINARY-SHORT SIGNED value 2.
01  wCursorHide       BINARY-SHORT SIGNED value 0.

01 wKey-lc         PIC x(26) value 'abcdefghijklmnopqrstuvwxyz'.
01 wKey-lc-Table redefines wKey-lc.
   05 wKey-lc-Ele  pic x(01) occurs 26 indexed by wKey-lc-Idx.
01 wKey-num        PIC x(10) value '0123456789'.
01 wKey-num-Table redefines wKey-num.
   05 wKey-num-Ele pic X(01) occurs 10 indexed by wKey-num-Idx.

01 wChars.
   03  wChars1 pic x(26) value 'abcdefghijklmnopqrstuvwxyz'.
   03  wChars-Ele redefines wChars1 pic x(01) occurs 26 indexed by wChars-Idx.
01 wNums.
   03  wNums1 pic x(26) value '0123456789'.
   03  wNums-Ele redefines wNums1 pic x(01) occurs 10 indexed by wNums-Idx.

01 wChar        PIC X(01).
01 wNum         PIC X(01).

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

01  wCRT-STATUS         PIC 9(04) VALUE 9999.

01  wCursorRowCol       PIC 9(06) value zero.
01  redefines wCursorRowCol.
    05 wCursorRow       Pic 9(03).
    05 wCursorCol       Pic 9(03).

01  wRb-ItemLenTab    Value zero.
    05 wRb-ItemLen     occurs 99 pic 9(03). *> item length (char number before X"00")
    05 wRb-ItemCol-End occurs 99 pic 9(03). *> end column of the radiobutton item

*> SAVE/RESTORE SCREEN VARIABLES
01 wScreenName        PIC X(256).
01 wiScrOk            BINARY-LONG.

01 wRb-Parameters     PIC x(12) value space.

copy    'GC02BOXMEX.CPY' suppress.
copy 'GC97KEYCODEGC.CPY'  suppress.

LINKAGE SECTION.
copy 'GC18RADIOBUTTON.CPY'.

*> ***********************************************************************************
*>
*>                       P R O C E D U R E   D I V I S I O N
*>
*> ***********************************************************************************
PROCEDURE DIVISION using RadioButton-Area.
   perform InitialSettings thru InitialSettingsEx.
   move 1 to i, j, w.

   move Rb-Parameters to wRb-Parameters *> useful to reset colors
   perform HideCursor thru HideCursorEx
   continue.

DisplayScreen.
   *> display ALL RADIOBUTTON ITEMS
   perform DisplayRadioButtonItems thru DisplayRadioButtonItemsEx
   continue.

*> ***********************************************************************************
*> WAIT FOR USER ACTION
*> ***********************************************************************************
Accept-a-Key.
 *> accept of a 1 byte dummy field at a fixed position Rb-r(1) Rb-c(1)
 *> the dummy field is at cursor position of the 1st byte of the first rediobutton ITEM
 *> it has same back and fore color of 1st ITEM so it is invisible
 *> the "with Auto" option is useful to detect user action ex.a cursor key is pressed

   move Rb-Item(1) (1:1) to wPrompt *> reset wDummy before accept

   if Rb-wait  = 'Y'
      *> after displayed radiobutton items wait for user action (normal use)
      *> accept of the wDummy field is always on 1st byte of 1st item. it is normal or highlight
      if Rb-Selected = 1
         accept wDummy at line Rb-r(1) col Rb-c(1)
                  with auto-skip prompt character is wPrompt :BCOL: Rb-bcoA :FCOL: Rb-fcoA highlight
      else
         accept wDummy at line Rb-r(1) col Rb-c(1)
                 with auto-skip prompt character is wPrompt :BCOL: Rb-bcoN :FCOL: Rb-fcoN
      end-if
   else
       *> if requested by the caller, after displayed radiobuttons, return to caller
       *> useful to just display and show radiobuttons on screen
       go to END-PROGRAM
   end-if

*> <escape> TAB/BAckTAB, PGUP/DOWN or right mouse key: return to caller
*> if pressed cursor down or right -> activate next radiobutton Item
*> if pressed cursor up   or left  <- activate previous radiobutton Item
*> *************************************************************************
*>
*> *************************************************************************
*> detect Enter or ESCAPE key only if user has not typed a letter or a digit
*> if user has typed a letter or a digit then WDummy is just une char and has the "AUTO" attribute
*> then the wCRT-STATUS is = 00000 (K-ENTER) !

*> *************************************************************************
*> EVALUATE THE USER ACTION (A KEY OR A MOUSE KEY WASS PRESSED)
*> *************************************************************************
   EVALUATE TRUE
   *> i = number of RadioButton item
           *> NEXT RADIOBUTTON ITEM WILL BECAME "ACTIVE" AND "MARKED"
           when wCRT-STATUS = K-RIGHT   *> Cursor Key right or down
             or wCRT-STATUS = K-DOWN

                  *> set and display "current" RadioButton item as Normal & unmarked RadioButton item
                  move ' '         to Rb-Mark(i)   *> unmark the item
                  move Rb-Selected to i
                  move space       to Rb-Act(Rb-Selected)

                  Move Rb-bcoN  to bco
                  Move Rb-fcoN  to fco
                  Move Rb-fcoNH to fcoH
                  perform DisplayRadioButton thru DisplayRadioButtonEx

                  *> set & display next RadioButton item as Active and marked RadioButton item
                  if   Rb-Selected = Rb-Number
                       move 1 to Rb-Selected i
                  else
                       add  1 to Rb-Selected i
                  end-if
                  move '1'    to Rb-Mark(i)   *> mark the item
                  move '1'    to Rb-Act(Rb-Selected)

                  Move Rb-bcoA  to bco
                  Move Rb-fcoA  to fco
                  Move Rb-fcoAH to fcoH
                  perform DisplayRadioButton thru DisplayRadioButtonEx

           *> PREVIOUS RADIOBUTTON ITEM WILL BECAME "ACTIVE" AND MARKED
           when wCRT-STATUS = K-LEFT  *> Cursor Key left or Up
             or wCRT-STATUS = K-UP

                  *> set and display "current" RadioButton item as Normal & unmerked RadioButton item
                  move ' ' to Rb-Mark(i)   *> unmark the item
                  move Rb-Selected to i
                  move space       to Rb-Act(Rb-Selected)

                  Move Rb-bcoN  to bco
                  Move Rb-fcoN  to fco
                  Move Rb-fcoNH to fcoH
                  perform DisplayRadioButton thru DisplayRadioButtonEx

                  *> set and display previous RadioButton item as Active and marked RadioButton item
                  if   Rb-Selected = 1
                       move Rb-Number  to Rb-Selected i
                  else
                       subtract 1 from Rb-Selected i
                  end-if
                  move '1' to Rb-Mark(i)   *> mark the item
                  move '1' to Rb-Act(Rb-Selected)

                  Move Rb-bcoA to bco
                  Move Rb-fcoA to fco
                  Move Rb-fcoAH to fcoH
                  perform DisplayRadioButton thru DisplayRadioButtonEx

      *> User clicked a Left Mouse Key: check if mouse position was on a Radiobutton
      when  wCRT-STATUS = K-LEFT-PRESSED
         or wCRT-STATUS = K-LEFT-DBL-CLICK
           perform varying k from 1 by 1 until k > Rb-number
             if wCursorRow  = Rb-r(k)
                compute wRb-c = Rb-c(k) - 4  *> (4 = 2 brackets + 1 marker + 1 space)
                if ( wCursorCol >= wRb-c and wCursorCol <= wRb-ItemCol-End(k) )
                  *> the mouse has been clicked on a ITEM (or on the Radiobutton marker itself)
                  move wCRT-STATUS  to Rb-Key
                  *> change display of active Radiobutton to display as normal Radiobutton
                  move Rb-Selected to i
                  move space       to Rb-Act(Rb-Selected)
                  move Rb-bcoN     to bco
                  move Rb-fcoN     to fco
                  move Rb-fcoNH    to fcoH
                  move ' '         to Rb-Mark(i)   *> unmark the item
                  perform DisplayRadiobutton thru DisplayRadiobuttonEx
                  *> change the clicked Checkbox to display from normal Checkbox to display as active
                  move k        to Rb-Selected i
                  move '1'      to Rb-Act(Rb-Selected)
                  move '1'      to Rb-Mark(i)   *> mark the item
                  move Rb-bcoA  to bco
                  move Rb-fcoA  to fco
                  move Rb-fcoAH to fcoH
                  perform DisplayRadiobutton thru DisplayRadiobuttonEx
                end-if
             end-if
           end-perform

    *> *****************************************************************************************
    *> IF USER HAS TYPED A LETTER - SEARCH IF IT IS A HOT KEY
    *> *****************************************************************************************
     when wDummy >= "a" and <= "z"
       or wDummy >= "A" and <= "Z"

        *> change wDummy (if it is an uppercase) to lowercase
        inspect wDummy converting 'ABCDEFGHIJKLMNOPQRSTUVWXYZ' to 'abcdefghijklmnopqrstuvwxyz'

        *> search the index of Key Pressed
        set wChars-Idx wKey-lc-Idx to 0
        search wKey-lc-Ele varying  wKey-lc-Idx
               at end set wKey-lc-Idx to 0
               when   wKey-lc-Ele (wKey-lc-Idx) = wDummy continue
        end-search
        *> search if the letter typed is a hotkey
        set wChars-Idx to wKey-lc-Idx
        perform varying k from 1 by 1 until k > Rb-Number
                if Rb-Hot(k) not = zero move Rb-Item(k) (Rb-Hot(k):1) to wChar end-if
                inspect wChar converting 'ABCDEFGHIJKLMNOPQRSTUVWXYZ' to 'abcdefghijklmnopqrstuvwxyz'
                if wChar = wChars-Ele(wChars-Idx)
                    *> the letter typed by the user is a valid hotkey !
                    *> change display of active item to display as normal item
                    move Rb-Selected to i
                    move space    to Rb-Act(Rb-Selected)
                    move ' '      to Rb-Mark(i)   *> unmark the item
                    Move Rb-bcoN  to bco
                    Move Rb-fcoN  to fco
                    Move Rb-fcoNH to fcoH
                    perform DisplayRadioButton thru DisplayRadioButtonEx
                   *> change the item with the hotkey to display from normal item to display as active item
                    move k   to Rb-Selected i
                    move '1' to Rb-Act(Rb-Selected)
                    move '1' to Rb-Mark(i)   *> mark the item
                    Move Rb-bcoA  to bco
                    Move Rb-fcoA  to fco
                    Move Rb-fcoAH to fcoH
                    perform DisplayRadioButton thru DisplayRadioButtonEx
                end-if
        end-perform

    *> *****************************************************************************************
    *> IF USER HAS TYPED A DIGIT - SEARCH IF IT IS A HOT KEY
    *> *****************************************************************************************
     when wDummy >= "0" and <= "9"

        *> search the index of Key Pressed
        set wChars-Idx wKey-num-Idx to 0
        search wKey-num-Ele varying  wKey-num-Idx
               at end set wKey-num-Idx to 0
               when   wKey-num-Ele (wKey-num-Idx) = wDummy continue
        end-search

        set wNums-Idx to wKey-num-Idx
        perform varying k from 1 by 1 until k > Rb-Number
                if Rb-Hot(k) not = zero move Rb-Item(k) (Rb-Hot(k):1) to wNum end-if
                if wNum = wNums-Ele(wNums-Idx)
                    *> the digit typed by the user is a valid hotkey !
                    *> change display of active item to display as normal item
                    move Rb-Selected to i
                    move space       to Rb-Act(Rb-Selected)
                    move ' '         to Rb-Mark(i)   *> unmark the item
                    Move Rb-bcoN  to bco
                    Move Rb-fcoN  to fco
                    Move Rb-fcoNH to fcoH
                    perform DisplayRadioButton thru DisplayRadioButtonEx
                   *> change the item with the hotkey to display from normal item to display as active item
                    move k to Rb-Selected i
                    move '1'   to Rb-Act(Rb-Selected)
                    move '1' to Rb-Mark(i)   *> mark the item
                    Move Rb-bcoA  to bco
                    Move Rb-fcoA  to fco
                    Move Rb-fcoAH to fcoH
                    perform DisplayRadioButton thru DisplayRadioButtonEx
                end-if
        end-perform

     when wCRT-STATUS = K-F1              *> F1 HELP
            perform DisplayHelp thru DisplayHelpEx
            go to DisplayScreen
      when wCRT-STATUS = K-ALT-F2              *> change "non active" items Fore Color
            move 1 to i
            add 1 to Rb-FcoN
            If Rb-FcoN > 7 move 0 to Rb-FcoN end-if
            go to DisplayScreen
      when wCRT-STATUS = K-ALT-F3              *> change "non active" items Back Color
            move 1 to i
            add 1 to Rb-BcoN
            If Rb-BcoN > 7 move 0 to Rb-BcoN end-if
            go to DisplayScreen
      when wCRT-STATUS = K-ALT-F4              *> change "active" items Fore Color
            move 1 to i
            add 1 to Rb-FcoA
            If Rb-FcoA > 7 move 0 to Rb-FcoA end-if
            go to DisplayScreen
      when wCRT-STATUS = K-ALT-F5              *> change "active" items Back Color
            move 1 to i
            add 1 to Rb-BcoA
            If Rb-BcoA > 7 move 0 to Rb-BcoA end-if
            go to DisplayScreen
      when wCRT-STATUS = K-ALT-F6              *> change hotkey Fore Color
            move 1 to i
            add 1 to Rb-FcoH
            If Rb-FcoH > 7 move 0 to Rb-FcoH end-if
            go to DisplayScreen
      when wCRT-STATUS = K-ALT-F7              *> change hotkey Back Color
            move 1 to i
            add 1 to Rb-BcoH
            If Rb-BcoH > 7 move 0 to Rb-BcoH end-if
            go to DisplayScreen
      when wCRT-STATUS = K-ALT-F9              *> reset params & colors to initial state
            move 1 to i
            move wRb-Parameters to Rb-Parameters
            go to DisplayScreen

   *> *************************************************************************
   *> EXIT WITH ONE OF FOLLOWING KEYS - ONLY ONE OPTION SELECTED - THE  MARKED RADIOBUTTON
   *> *************************************************************************
       when wCRT-STATUS = K-TAB
         or wCRT-STATUS = K-ENTER
         or wCRT-STATUS = K-ESCAPE
         or wCRT-STATUS = K-PAGEUP
         or wCRT-STATUS = K-PAGEDOWN
         or wCRT-STATUS = K-BACKTAB
         or wCRT-STATUS = K-RIGHT-PRESSED
         or wCRT-STATUS = K-RIGHT-DBL-CLICK
            move wCRT-STATUS to Rb-Key
            go to END-PROGRAM
   END-EVALUATE

   go to Accept-a-Key
   continue.
END-PROGRAM.

   perform ShowCursor thru ShowCursorEx
   GOBACK.


*> ***********************************************************************************
*> LOOP to display ALL RADIOBUTTON items
*> ***********************************************************************************
DisplayRadioButtonItems.
   *> to count how many RadioButton
   if Rb-ele(i) = low-value
      compute Rb-Number   =  i - 1
      move    Rb-Selected to i
      go to DisplayRadioButtonItemsEx end-if

   *> set bco and fco to color of Active RadioButton
   if Rb-Act(i) = '1'
      move i       to Rb-Selected
      Move Rb-bcoA to bco
      move Rb-fcoA to fco
      Move Rb-fcoAH to fcoH
  *> set bco and fco to color of non active RadioButton
   else
      Move Rb-bcoN to bco
      move Rb-fcoN to fco
      Move Rb-fcoNH to fcoH
   end-if

   perform DisplayRadioButton thru DisplayRadioButtonEx
   add  1 to i

   *> go to display next RadioButton item
   go to DisplayRadioButtonItems.

DisplayRadioButtonItemsEx. exit.


*> ***********************************************************************************
*> DISPLAY A SINGLE RADIOBUTTON ITEM
*> ***********************************************************************************
DisplayRadioButton.
   *> j = number/position of single character of RadioButton item description
   move 0 to j.

   *> store the legth of each Radiobutton, useful to detect if user has mouse clicked on it
   move zero to wRb-ItemLen(i)
   inspect Rb-Item(i) tallying wRb-ItemLen(i) FOR CHARACTERS before x"00"
   compute wRb-ItemCol-End(i) =  Rb-c(i) +  wRb-ItemLen(i) - 1
   continue.

loop1.
   *> loop to display single chars of a RadioButton item
   add 1 to j
   if Rb-Item(i) (j:1) = low-value go loop1-ex end-if

   *> save max length of RadioButton items
   compute wlen = (Rb-c(i) + j - 1) - (Rb-c(1) + 1)
   if wlen > len-voce move wlen to len-voce end-if

   compute wCol = Rb-c(i) + j - 1 end-compute

   if j = Rb-Hot(i)
     *> display the hotkey character of RadioButton item with different colors
     if Rb-fcoHH = 'Y'
        display Rb-Item(i) (j:1) at line Rb-r(i) col wcol with :BCOL: Rb-bcoH :FCOL: Rb-fcoH highlight end-display
     else
        display Rb-Item(i) (j:1) at line Rb-r(i) col wcol with :BCOL: Rb-bcoH :FCOL: Rb-fcoH end-display
     end-if
   else
      *> display a normal character of RadioButton item (active or non active)
      if fcoH = 'Y'
         display Rb-Item(i) (j:1) at line Rb-r(i) col wcol with :BCOL: bco :FCOL: fco highlight end-display
      else
         display Rb-Item(i) (j:1) at line Rb-r(i) col wcol with :BCOL: bco :FCOL: fco end-display
      end-if
   end-if
   go to loop1.

loop1-ex.
   *> display: a space, bracket open, the marker, bracket close
   if fcoH = 'Y'
       compute wCol = Rb-c(i) - 4 end-compute
       display ' '             at line Rb-r(i) col wcol with :BCOL: bco :FCOL: fco highlight
       compute wCol = Rb-c(i) - 3 end-compute
       display Rb-BracketChar1 at line Rb-r(i) col wcol with :BCOL: bco :FCOL: fco highlight
       compute wCol = Rb-c(i) - 1 end-compute
       display Rb-BracketChar2 at line Rb-r(i) col wcol with :BCOL: bco :FCOL: fco highlight
       compute wCol = Rb-c(i) - 2 end-compute
       if Rb-Mark(i) = '1'
          display Rb-MarkChar at line Rb-r(i) col wcol with :BCOL: bco :FCOL: fco highlight
       else
          display ' '         at line Rb-r(i) col wcol with :BCOL: bco :FCOL: fco highlight
       end-if
   else
       compute wCol = Rb-c(i) - 4 end-compute
       display ' '             at line Rb-r(i) col wcol with :BCOL: bco :FCOL: fco
       compute wCol = Rb-c(i) - 3 end-compute
       display Rb-BracketChar1 at line Rb-r(i) col wcol with :BCOL: bco :FCOL: fco
       compute wCol = Rb-c(i) - 1 end-compute
       display Rb-BracketChar2 at line Rb-r(i) col wcol with :BCOL: bco :FCOL: fco

       compute wCol = Rb-c(i) - 2 end-compute
       if Rb-Mark(i) = '1'
          display Rb-MarkChar  at line Rb-r(i) col wcol with :BCOL: bco :FCOL: fco
       else
          display ' '          at line Rb-r(i) col wcol with :BCOL: bco :FCOL: fco
       end-if
   end-if
   continue.
DisplayRadioButtonEx. exit.

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

DisplayHelp.
    perform ScreenSave thru ScreenSaveEx

    initialize Boxmex-Area ALL TO VALUE
    move low-value to Bxm-tabmex
    move 1 to y
    move z'                               ' to Bxm-mex(y) add 1 to y
    move z' Use left mouse button         ' to Bxm-mex(y) add 1 to y
    move z' or cursor keys or hotkeys     ' to Bxm-mex(y) add 1 to y
    move z' to select a Radiobutton.      ' to Bxm-mex(y) add 1 to y
    move z' Use Enter,TAB, ESC, PAGE or   ' to Bxm-mex(y) add 1 to y
    move z' right mouseclick  to exit.    ' to Bxm-mex(y) add 1 to y
    move z'                               ' to Bxm-mex(y) add 1 to y
    move z' F1 Help                       ' to Bxm-mex(y) add 1 to y
    move z' ALT-F2/F3 chg back/Fore color ' to Bxm-mex(y) add 1 to y
    move z' of non Active items.          ' to Bxm-mex(y) add 1 to y
    move z' ALT-F4/F5 chg back/Fore color ' to Bxm-mex(y) add 1 to y
    move z' of Active item.               ' to Bxm-mex(y) add 1 to y
    move z' ALT-F6/F7 chg back/Fore color ' to Bxm-mex(y) add 1 to y
    move z' of HotKey                     ' to Bxm-mex(y) add 1 to y
    move z' ALT-F9 reset all color changes' to Bxm-mex(y) add 1 to y
    move z'                               ' to Bxm-mex(y) add 1 to y
    move z' eugenio.dilo@gmail.com (2021) ' to Bxm-mex(y) add 1 to y
    move z' enter/mouseclick, continue ...' to Bxm-mex(y) add 1 to y
    move blue     to Bxm-bco    Bxm-titBco Bxm-bcoM
    move white    to Bxm-fco    Bxm-titFco Bxm-fcoM
    move 'Y'      to Bxm-Click  Bxm-tit
    move 'N'      to Bxm-3D     Bxm-OkButton
    move 'S'      to Bxm-style
    move x'B4' & ' RADIOBUTTON - HELP '  & x'C3' & x'00' to Bxm-titDes
   compute Bxm-r1 = 05
   compute Bxm-c1 = 10
   compute Bxm-r2 = Bxm-r1 + 19
   compute Bxm-c2 = Bxm-c1 + 32
   call GC02BOXMEX using BOXMEX-AREA

   perform ScreenRestore thru ScreenRestoreEx.
DisplayHelpEx. exit.

HideCursor.
  *> hide the cursor and save its previous state
  *> use always a "display or an accept at .... " before,  to have done a call to "initscr"
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

ScreenSave.
   move Z'GC18RADIOBUTTON.TMP' to wScreenName
   call static 'scr_dump' using by reference wScreenName returning wiScrOk end-call.
ScreenSaveEx. exit.

ScreenRestore.
   call static 'scr_restore' using by reference wScreenName returning wiScrOk end-call
   CALL 'CBL_DELETE_FILE' USING wScreenName.
ScreenRestoreEx. exit.

End Program GC18RADIOBUTTON.
