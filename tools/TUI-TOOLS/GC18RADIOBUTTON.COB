       >> SOURCE FORMAT IS FREE
REPLACE ==:BCOL:== BY ==BACKGROUND-COLOR==  *> use :BCOL: & :FCOL: is to have short code
        ==:FCOL:== BY ==FOREGROUND-COLOR==.

IDENTIFICATION DIVISION.
PROGRAM-ID. GC18RADIOBUTTON is initial.
*> ***********************************************************************************
*> GnuCOBOL TT (TUI TOOLS) AND UTILITIES COLLECTION
*> Purpose:    DISPLAYS AND MANAGE RADIOBUTTON ITEMS ON SCREEN
*>             make only one of items "marked/selected" with cursor keys or left mousekey singleclick
*>             exit with: ENTER, TAB/BACKTAB, ESC, PAGEUP/DOWN, single or doubleclick of right mousekey
*> Tectonics:  cobc -m GC18RADIOBUTTON.COB -lpdcurses (compile with GnuCOBOL 3.1 or greater)
*> Usage:      call GC18RADIOBUTTON using RADIOBUTTON-AREA
*> Parameters: look at GC18RADIOBUTTON.cpy (use with copy Version: 2.0)
*> Author:     Eugenio Di Lorenzo - Italia (DILO) - eugenio.dilo@gmail.com
*> License:    Copyright 2017 E.Di Lorenzo - GNU Lesser General Public License, LGPL, 3.0 (or greater)
*> Version:    2.0 2021.01.01
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
*>
*> You can manage a group of max 98 RADIOBUTTON items on screen, each of 1 row (also overlapped).
*> Each radiobutton item has to be inserted in a table with 99 elements
*> there have to be a last item in the table, filled with low-value
*>
*> Example of use.
*> step 1. display a box (not mandatory ) but useful to have a better user interface
*> step 2. display a group of RADIOBUTTON items (switches) inside the BOX
*> step 3. wait for a user action . Some user actions:
*> use cursor keys to activate and mark a radiobutton
*> use left mouse key single or doubleclick on a radiobutton = activate and mark the radiobutton
*> To exit from radiobutton mgmt use: TAB, ENTER, ESC, PGUP/DOWN, right mouse key single or doubleclick
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

   *> display ALL RADIOBUTTON ITEMS
   perform DisplayRadioButtonItems thru DisplayRadioButtonItemsEx

   perform HideCursor thru HideCursorEx
   continue.

*> ***********************************************************************************
*> WAIT FOR USER ACTION
*> ***********************************************************************************
Accept-a-Key.

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
                *> if ( wCursorCol >= Ck-c(k) and  wCursorCol <= wCk-ItemCol-End(k) )
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

   *> *************************************************************************
   *> EXIT WITH ONE OF FOLLOWING KEYS - ONLY ONE OPTION SELECTED - THE  MARKED RADIOBUTTON
   *> *************************************************************************
       when wCRT-STATUS = K-TAB
         or wCRT-STATUS = K-ENTER
         or wCRT-STATUS = K-ESCAPE
         or wCRT-STATUS = K-PAGEUP
         or wCRT-STATUS = K-PAGEDOWN
         or wCRT-STATUS = K-BACKTAB
         or wCRT-STATUS = K-F1
         or wCRT-STATUS = K-F12
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

End Program GC18RADIOBUTTON.
