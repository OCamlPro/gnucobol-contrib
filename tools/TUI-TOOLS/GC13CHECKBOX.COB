       >> SOURCE FORMAT IS FREE
REPLACE ==:BCOL:== BY ==BACKGROUND-COLOR==  *> use :BCOL: & :FCOL: is to have short code
        ==:FCOL:== BY ==FOREGROUND-COLOR==.

IDENTIFICATION DIVISION.
PROGRAM-ID. GC13CHECKBOX is initial.
*> ***********************************************************************************
*> GnuCOBOL TT (TUI TOOLS) AND UTILITIES COLLECTION
*> Purpose:    DISPLAYS AND MANAGE CHECKBOX ITEMS (SWITCHES) ON SCREEN
*>             make checkbox items active with cursor keys or left mousekey singleclick
*>             mark/unmark active checkbox item with spacebar or enter or left mousekey doubleclick
*>             exit with: TAB/BACKTAB, ESC, PAGEUP/DOWN, single or doubleclick of right mousekey
*> Tectonics:  cobc -m GC13CHECKBOX.COB  -lpdcurses (compile with GnuCOBOL 3.1 or greater)
*> Usage:      call GC13CHECKBOX using CHECKBOX-AREA
*> Parameters: look at GC13CHECKBOX.cpy (use with copy Version: 2.0)
*> Author:     Eugenio Di Lorenzo - Italia (DILO) - eugenio.dilo@gmail.com
*> License:    Copyright 2021 E.Di Lorenzo - GNU Lesser General Public License, LGPL, 3.0 (or greater)
*> Version:    2.1 2021.01.31
*> Changelog:  1.0 first release.
*>             1.1 hot key management added
*>             1.2 Ck-Hot from 9(01) to 9(02)
*>             1.3 Ck-wait management added
*>             1.4 Chk-Number changed to Ck-Number that is added in GC13CHECKBOX.cpy
*>                 use PgUp, PgDn, Tab to exit from Checkbox
*>             2.0 mouse management is added
*>                 changed from "call getch" to ACCEPT a DUMMY field
*>                 added single click of left mousekey on an item to make it active
*>                 double left-click is same as Enter
*>                 single or doubleclick of right mousekey is same as ESCAPE
*>             2.1 F1, ALT-F2/F3/F4/F5/F6/F7/F9 added (HELP and change colors)
*>
*> You can manage a group of max 98 CHECKBOX items on screen, each of 1 row (also overlapped).
*> Each checkbox item has to be inserted in a table with 99 elements
*> there have to be a last item in the table, filled with low-value
*>
*> Example of use.
*> step 1. display a box (not mandatory ) but useful to have a better user interface
*> step 2. display a group of CHECKBOX items (switches) inside the BOX
*> step 3. wait for a user action . Some user actions:
*> use cursor keys to activate an item
*> use a single click with left mouse key on item description or inside brackets = activate the item
*> use a double click with left mouse key or Enter or Spacebar = mark or unmark the active item
*> To exit from checkbox items management use: TAB, ESC, PGUP/DOWN, right mouse key single or doubleclick
*>
*> sample schema of CHECKBOX items list with 6 items
*>
*>       +----------------------------------------+
*>       |  [X] aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa  |
*>       |  [ ] bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb  |
*>       |  [X] cccccccccccccccccccccccccccccccc  |
*>       |  [ ] dddddddddddddddddddddddddddddddd  |
*>       |  [ ] eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee  |
*>       |  [X] ffffffffffffffffffffffffffffffff  |
*>       +----------------------------------------+
*>
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
    03  wlen         pic 9(02) value 0.
    03  len-voce     pic 9(02) value 0.
    03  wCk-c        pic 9(03) value zero.

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

01  wCk-ItemLenTab    Value zero.
    05 wCk-ItemLen     occurs 99 pic 9(03). *> item length (char number before X"00")
    05 wCk-ItemCol-End occurs 99 pic 9(03). *> end column of the item

*> SAVE/RESTORE SCREEN VARIABLES
01 wScreenName        PIC X(256).
01 wiScrOk            BINARY-LONG.

01 wCk-Parameters     PIC x(12) value space.

copy    'GC02BOXMEX.CPY' suppress.
copy 'GC97KEYCODEGC.CPY'  suppress.

LINKAGE SECTION.
copy 'GC13CHECKBOX.CPY'.

*> ***********************************************************************************
*>
*>                       P R O C E D U R E   D I V I S I O N
*>
*> ***********************************************************************************
PROCEDURE DIVISION using CHECKBOX-Area.
   perform InitialSettings thru InitialSettingsEx.
   move 1 to i, j, w.

   move Ck-Parameters to wCk-Parameters *> useful to reset colors
   perform HideCursor thru HideCursorEx
   continue.

DisplayScreen.
   *> display ALL CHECKBOX ITEMS
   perform DisplayCheckboxItems thru DisplayCheckboxItemsEx
   continue.

*> ***********************************************************************************
*> WAIT FOR USER ACTION
*> ***********************************************************************************
Accept-a-Key.
 *> accept of a 1 byte dummy field at a fixed position Ck-r(1) Ck-c(1)
 *> the dummy field is at cursor position of the 1st byte of the first checkbox ITEM
 *> it has same back and fore color of 1st ITEM so it is invisible
 *> the "with Auto" option is useful to detect user action ex.a cursor key is pressed

  move Ck-Item(1) (1:1) to wPrompt *> reset wDummy before accept

  if Ck-wait  = 'Y'
     *> after displayed checkbox items wait for user action (normal use)
     *> accept of the wDummy field is always on 1st byte of 1st item. it is normal or highlight
     if Ck-Selected = 1
        accept wDummy at line Ck-r(1) col Ck-c(1)
                 with auto-skip prompt character is wPrompt :BCOL: Ck-bcoA :FCOL: Ck-fcoA highlight
     else
        accept wDummy at line Ck-r(1) col Ck-c(1)
                with auto-skip prompt character is wPrompt :BCOL: Ck-bcoN :FCOL: Ck-fcoN
     end-if
  else
      *> if requested by the caller, after displayed checkbox items list, return to caller
      *> useful to just display checkbox items list on screen
      go to END-PROGRAM
  end-if

*> <escape> TAB/BAckTAB, PGUP/DOWN or right mouse key: return to caller
*> if pressed cursor down or right -> activate next checkbox Item
*> if pressed cursor up   or left  <- activate previous checkbox Item
*> *************************************************************************
*> ENTER = mark/unmark the checkbox item
*> *************************************************************************
*> detect Enter or ESCAPE key only if user has not typed a letter or a digit
*> if user has typed a letter or a digit then WDummy is just une char and has the "AUTO" attribute
*> then the wCRT-STATUS is = 00000 (K-ENTER) !

*> *************************************************************************
*> EVALUATE THE USER ACTION (A KEY OR A MOUSE KEY WASS PRESSED)
*> *************************************************************************
   EVALUATE TRUE

           *> NEXT CHECKBOX ITEM WILL BECAME "ACTIVE"
           when wCRT-STATUS = K-RIGHT   *> Cursor Key right or down
             or wCRT-STATUS = K-DOWN

                  *> set and display "current" checkbox item as Normal Checkbox item
                  move Ck-Selected to i
                  move space       to Ck-Act(Ck-Selected)
                  Move Ck-bcoN  to bco
                  Move Ck-fcoN  to fco
                  Move Ck-fcoNH to fcoH
                  perform DisplayCheckBox thru DisplayCheckBoxEx

                  *> set and display next checkbox item as Active Checkbox item
                  if Ck-Selected = Ck-Number
                     move 1 to Ck-Selected i
                  else
                     add  1 to Ck-Selected i
                  end-if
                  move '1'   to Ck-Act(Ck-Selected)
                  Move Ck-bcoA  to bco
                  Move Ck-fcoA  to fco
                  Move Ck-fcoAH to fcoH
                  perform DisplayCheckBox thru DisplayCheckBoxEx

           *> PREVIOUS CHECKBOX ITEM WILL BECAME "ACTIVE"
           when wCRT-STATUS = K-LEFT  *> Cursor Key left or Up
             or wCRT-STATUS = K-UP

                  *> set and display "current" checkbox item as Normal Checkbox item
                  move Ck-Selected to i
                  move space       to Ck-Act(Ck-Selected)
                  Move Ck-bcoN  to bco
                  Move Ck-fcoN  to fco
                  Move Ck-fcoNH to fcoH
                  perform DisplayCheckBox thru DisplayCheckBoxEx

                  *> set and display previous checkbox item as Active Checkbox item
                  if Ck-Selected = 1
                     move Ck-Number  to Ck-Selected i
                  else
                     subtract 1 from Ck-Selected i
                  end-if
                  move '1'      to Ck-Act(Ck-Selected)
                  Move Ck-bcoA  to bco
                  Move Ck-fcoA  to fco
                  Move Ck-fcoAH to fcoH
                  perform DisplayCheckBox thru DisplayCheckBoxEx

      *> User clicked a Left Mouse Key: check if mouse position was on an ITEM
      when (wCRT-STATUS = K-LEFT-PRESSED )
           perform varying k from 1 by 1 until k > Ck-number
             if wCursorRow  = Ck-r(k)
                compute wCk-c = Ck-c(k) - 4  *> (4 = 2 brackets + 1 marker + 1 space)
                *> if ( wCursorCol >= Ck-c(k) and  wCursorCol <= wCk-ItemCol-End(k) )
                if ( wCursorCol >= wCk-c and wCursorCol <= wCk-ItemCol-End(k) )
                  *> the mouse has been clicked on a ITEM (or on the checkbox marker itself)
                  move wCRT-STATUS  to Ck-Key
                  *> change display of active Checkbox to display as normal Checkbox
                  move Ck-Selected to i
                  move space       to Ck-Act(Ck-Selected)
                  Move Ck-bcoN     to bco
                  Move Ck-fcoN     to fco
                  Move Ck-fcoNH    to fcoH
                  perform DisplayCheckBox thru DisplayCheckBoxEx
                  *> change the clicked Checkbox to display from normal Checkbox to display as active
                  move k        to Ck-Selected i
                  move '1'      to Ck-Act(Ck-Selected)
                  Move Ck-bcoA  to bco
                  Move Ck-fcoA  to fco
                  Move Ck-fcoAH to fcoH
                  perform DisplayCheckBox thru DisplayCheckBoxEx

                  *> if wCRT-STATUS = K-LEFT-DBL-CLICK
                    *> move K-ENTER  to Ck-Key
                    *> go END-Program
                  *> end-if

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
               when   wKey-lc-Ele (wKey-lc-Idx) = wDummy  continue
        end-search
        *> search if the letter typed is a hotkey
        set wChars-Idx to wKey-lc-Idx
        perform varying k from 1 by 1 until k > Ck-Number
                if Ck-Hot(k) not = zero move Ck-Item(k) (Ck-Hot(k):1) to wChar end-if
                inspect wChar converting 'ABCDEFGHIJKLMNOPQRSTUVWXYZ' to 'abcdefghijklmnopqrstuvwxyz'
                if wChar = wChars-Ele(wChars-Idx)
                    *> the letter typed by the user is a valid hotkey !
                    *> change display of active item to display as normal item
                    move Ck-Selected to i
                    move space    to Ck-Act(Ck-Selected)
                    Move Ck-bcoN  to bco
                    Move Ck-fcoN  to fco
                    Move Ck-fcoNH to fcoH
                    perform DisplayCheckBox thru DisplayCheckBoxEx
                   *> change the item with the hotkey to display from normal item to display as active item
                    move k        to Ck-Selected i
                    move '1'      to Ck-Act(Ck-Selected)
                    Move Ck-bcoA  to bco
                    Move Ck-fcoA  to fco
                    Move Ck-fcoAH to fcoH
                    perform DisplayCheckBox thru DisplayCheckBoxEx
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
               when   wKey-num-Ele (wKey-num-Idx) = wDummy  continue
        end-search

        set wNums-Idx to wKey-num-Idx
        perform varying k from 1 by 1 until k > Ck-Number
                if Ck-Hot(k) not = zero move Ck-Item(k) (Ck-Hot(k):1) to wNum end-if
                if wNum = wNums-Ele(wNums-Idx)
                    *> the digit typed by the user is a valid hotkey !
                    *> change display of active item to display as normal item
                    move Ck-Selected to i
                    move space       to Ck-Act(Ck-Selected)
                    Move Ck-bcoN  to bco
                    Move Ck-fcoN  to fco
                    Move Ck-fcoNH to fcoH
                    perform DisplayCheckBox thru DisplayCheckBoxEx
                   *> change the item with the hotkey to display from normal item to display as active item
                    move k to Ck-Selected i
                    move '1'   to Ck-Act(Ck-Selected)
                    Move Ck-bcoA  to bco
                    Move Ck-fcoA  to fco
                    Move Ck-fcoAH to fcoH
                    perform DisplayCheckBox thru DisplayCheckBoxEx
                end-if
        end-perform

        *> TOGGLE THE MARK / UNMARK OF "ACTIVE" CHECKBOX ITEM
         when wCRT-STATUS = K-ENTER or wCRT-STATUS = K-LEFT-DBL-CLICK
            if Ck-Mark(i) = space
               move '1' to Ck-Mark(i)
            else
               move ' ' to Ck-Mark(i)
            end-if
            Move Ck-bcoA to bco
            move Ck-fcoA to fco
            perform DisplayCheckBox thru DisplayCheckBoxEx

     when wCRT-STATUS = K-F1              *> F1 HELP
            perform DisplayHelp thru DisplayHelpEx
            go to DisplayScreen
      when wCRT-STATUS = K-ALT-F2              *> change "non active" items Fore Color
            move 1 to i
            add 1 to Ck-FcoN
            If Ck-FcoN > 7 move 0 to Ck-FcoN end-if
            go to DisplayScreen
      when wCRT-STATUS = K-ALT-F3              *> change "non active" items Back Color
            move 1 to i
            add 1 to Ck-BcoN
            If Ck-BcoN > 7 move 0 to Ck-BcoN end-if
            go to DisplayScreen
      when wCRT-STATUS = K-ALT-F4              *> change "active" items Fore Color
            move 1 to i
            add 1 to Ck-FcoA
            If Ck-FcoA > 7 move 0 to Ck-FcoA end-if
            go to DisplayScreen
      when wCRT-STATUS = K-ALT-F5              *> change "active" items Back Color
            move 1 to i
            add 1 to Ck-BcoA
            If Ck-BcoA > 7 move 0 to Ck-BcoA end-if
            go to DisplayScreen
      when wCRT-STATUS = K-ALT-F6              *> change hotkey Fore Color
            move 1 to i
            add 1 to Ck-FcoH
            If Ck-FcoH > 7 move 0 to Ck-FcoH end-if
            go to DisplayScreen
      when wCRT-STATUS = K-ALT-F7              *> change hotkey Back Color
            move 1 to i
            add 1 to Ck-BcoH
            If Ck-BcoH > 7 move 0 to Ck-BcoH end-if
            go to DisplayScreen
      when wCRT-STATUS = K-ALT-F9              *> reset params & colors to initial state
            move 1 to i
            move wCk-Parameters to Ck-Parameters
            go to DisplayScreen

   *> *************************************************************************
   *> EXIT WITH ONE OF FOLLOWING KEYS
   *> *************************************************************************
       when wCRT-STATUS = K-TAB
         or wCRT-STATUS = K-ESCAPE
         or wCRT-STATUS = K-PAGEUP
         or wCRT-STATUS = K-PAGEDOWN
         or wCRT-STATUS = K-BACKTAB
         or wCRT-STATUS = K-RIGHT-PRESSED
         or wCRT-STATUS = K-RIGHT-DBL-CLICK
            move wCRT-STATUS to Ck-Key
            go to END-PROGRAM

   END-EVALUATE

   go to Accept-a-Key
   continue.

END-PROGRAM.
   perform ShowCursor thru ShowCursorEx
   GOBACK.

*> ***********************************************************************************
*> LOOP to display ALL CHECKBOX ITEMS
*> ***********************************************************************************
DisplayCheckboxItems.
   *> to count how many CHECKBOX items
   if Ck-ele(i) = low-value
      compute Ck-Number   =  i - 1
      move    Ck-Selected to i
      go to DisplayCheckboxItemsEx
   end-if

   if Ck-Act(i) = '1'
      *> set bco and fco to color of Active Checkbox
      move i       to Ck-Selected
      move Ck-bcoA to bco move Ck-fcoA to fco Move Ck-fcoAH to fcoH
   else
      *> set bco and fco to color of non active CHECKBOX
      move Ck-bcoN to bco move Ck-fcoN to fco Move Ck-fcoNH to fcoH
   end-if
   perform DisplayCheckBox thru DisplayCheckBoxEx
   add  1 to i

   *> go to display next Checkbox item
   go to DisplayCheckboxItems.

DisplayCheckboxItemsEx. exit.

*> ***********************************************************************************
*> DISPLAY A SINGLE CHECKBOX ITEM
*> ***********************************************************************************
DisplayCheckBox.
   *> j = number/position of single character of checkbox item description
   move 0 to j.

   *> store the legth of each Checkbox item, useful to detect if user has mouse clicked on it
   move zero to wCk-ItemLen(i)
   inspect Ck-Item(i) tallying wCk-ItemLen(i) FOR CHARACTERS before x"00"
   compute wCk-ItemCol-End(i) =  Ck-c(i) +  wCk-ItemLen(i) - 1
   continue.

loop1.
   *> loop to display single chars of a Checkbox item
   add 1 to j
   if Ck-Item(i) (j:1) = low-value go loop1-ex end-if

   *> save max length of Checkbox items
   compute wlen = (Ck-c(i) + j - 1) - (Ck-c(1) + 1)
   if wlen > len-voce move wlen to len-voce end-if

   compute wCol = Ck-c(i) + j - 1 end-compute

   if j = Ck-Hot(i)
      *> display the hotkey character of checkbox item with different colors
      if Ck-fcoHH = 'Y'
         display Ck-Item(i) (j:1) at line Ck-r(i) col wcol with :BCOL: Ck-bcoH :FCOL: Ck-fcoH highlight
      else
         display Ck-Item(i) (j:1) at line Ck-r(i) col wcol with :BCOL: Ck-bcoH :FCOL: Ck-fcoH
      end-if
   else
      *> display a normal character of checkbox item (active or non active)
      if fcoH = 'Y'
         display Ck-Item(i) (j:1) at line Ck-r(i) col wcol with :BCOL: bco :FCOL: fco highlight
      else
         display Ck-Item(i) (j:1) at line Ck-r(i) col wcol with :BCOL: bco :FCOL: fco
      end-if
   end-if
   go to loop1.

loop1-ex.
   *> display: a space, bracket open, the marker, bracket close
    if fcoH = 'Y'
       compute wCol = Ck-c(i) - 4 end-compute
       display ' '             at line Ck-r(i) col wcol with :BCOL: bco :FCOL: fco highlight
       compute wCol = Ck-c(i) - 3 end-compute
       display Ck-BracketChar1 at line Ck-r(i) col wcol with :BCOL: bco :FCOL: fco highlight
       compute wCol = Ck-c(i) - 1 end-compute
       display Ck-BracketChar2 at line Ck-r(i) col wcol with :BCOL: bco :FCOL: fco highlight
       compute wCol = Ck-c(i) - 2 end-compute
       if Ck-Mark(i) = '1'
          display Ck-MarkChar at line Ck-r(i) col wcol with :BCOL: bco :FCOL: fco highlight
       else
          display ' '         at line Ck-r(i) col wcol with :BCOL: bco :FCOL: fco highlight
       end-if
   else
       compute wCol = Ck-c(i) - 4 end-compute
       display ' '             at line Ck-r(i) col wcol with :BCOL: bco :FCOL: fco
       compute wCol = Ck-c(i) - 3 end-compute
       display Ck-BracketChar1 at line Ck-r(i) col wcol with :BCOL: bco :FCOL: fco
       compute wCol = Ck-c(i) - 1 end-compute
       display Ck-BracketChar2 at line Ck-r(i) col wcol with :BCOL: bco :FCOL: fco

       compute wCol = Ck-c(i) - 2 end-compute
       if Ck-Mark(i) = '1'
          display Ck-MarkChar  at line Ck-r(i) col wcol with :BCOL: bco :FCOL: fco
       else
          display ' '          at line Ck-r(i) col wcol with :BCOL: bco :FCOL: fco
       end-if
   end-if
   continue.
DisplayCheckBoxEx. exit.

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
    move z' Use left mouse button         ' to Bxm-mex(y) add 1 to y
    move z' or cursor keys or hotkeys     ' to Bxm-mex(y) add 1 to y
    move z' to activate a checkbox item.  ' to Bxm-mex(y) add 1 to y
    move z' Enter or spacebar or left     ' to Bxm-mex(y) add 1 to y
    move z' doubleclick to mark/unmark    ' to Bxm-mex(y) add 1 to y
    move z' the active item               ' to Bxm-mex(y) add 1 to y
    move z' TAB, ESC or right mouseclick  ' to Bxm-mex(y) add 1 to y
    move z' to exit from checkbox mgmt    ' to Bxm-mex(y) add 1 to y
    move z' F1 Help                       ' to Bxm-mex(y) add 1 to y
    move z' ALT-F2/F3 chg back/Fore color ' to Bxm-mex(y) add 1 to y
    move z' of non Active items.          ' to Bxm-mex(y) add 1 to y
    move z' ALT-F4/F5 chg back/Fore color ' to Bxm-mex(y) add 1 to y
    move z' of Active item.               ' to Bxm-mex(y) add 1 to y
    move z' ALT-F6/F7 chg back/Fore color ' to Bxm-mex(y) add 1 to y
    move z' of HotKey                     ' to Bxm-mex(y) add 1 to y
    move z' ALT-F9 reset all color changes' to Bxm-mex(y) add 1 to y
    move z' eugenio.dilo@gmail.com (2021) ' to Bxm-mex(y) add 1 to y
    move z' enter/mouseclick, continue ...' to Bxm-mex(y) add 1 to y
    move blue     to Bxm-bco    Bxm-titBco Bxm-bcoM
    move white    to Bxm-fco    Bxm-titFco Bxm-fcoM
    move 'Y'      to Bxm-Click  Bxm-tit
    move 'N'      to Bxm-3D     Bxm-OkButton
    move 'S'      to Bxm-style
    move x'B4' & ' CHECKBOX - HELP '  & x'C3' & x'00' to Bxm-titDes
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
   move Z'GC13CHECKBOX.TMP' to wScreenName
   call static 'scr_dump' using by reference wScreenName returning wiScrOk end-call.
ScreenSaveEx. exit.

ScreenRestore.
   call static 'scr_restore' using by reference wScreenName returning wiScrOk end-call
   CALL 'CBL_DELETE_FILE' USING wScreenName.
ScreenRestoreEx. exit.

End Program GC13CHECKBOX.
