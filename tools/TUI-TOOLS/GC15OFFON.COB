       >> SOURCE FORMAT IS FREE
REPLACE ==:BCOL:== BY ==BACKGROUND-COLOR==  *> use :BCOL: & :FCOL: is to have short code
        ==:FCOL:== BY ==FOREGROUND-COLOR==.

IDENTIFICATION DIVISION.
PROGRAM-ID. GC15OFFON is initial.
*> ***********************************************************************************
*> GnuCOBOL TT (TUI TOOLS) AND UTILITIES COLLECTION
*> Purpose:    DISPLAYS AND MANAGE A GROUP OF OFF/ON ITEMS (SWITCHES) ON SCREEN
*>             make OFFON items active with cursor keys or left mousekey singleclick
*>             change OFFON item with spacebar or enter or left mousekey doubleclick
*>             exit with: TAB/BACKTAB, ESC, PAGEUP/DOWN, single or doubleclick of right mousekey
*> Tectonics:  cobc -m GC15OFFON.COB  -lpdcurses (compile with GnuCOBOL 3.1 or greater)
*> Usage:      call GC15OFFON using OFFON-AREA
*> Parameters: look at GC15OFFON.CPY (use with copy Version: 1.0)
*> Author:     Eugenio Di Lorenzo - Italia (DILO) - eugenio.dilo@gmail.com
*> License:    Copyright 2021 E.Di Lorenzo - GNU Lesser General Public License, LGPL, 3.0 (or greater)
*> Version:    1.0 2021.01.01
*> Changelog:  1.0 first release.
*>
*> You can manage a group of max 98 OFFON items on screen, each of 1 row (also overlapped).
*> Each OFFON item has to be inserted in a table with 99 elements
*> there have to be a last item in the table, filled with low-value
*>
*> Example of use.
*> step 1. display a box (not mandatory ) but useful to have a better user interface
*> step 2. display a group of OFFON items (switches) inside the BOX
*> step 3. wait for a user action . Some user actions:
*> use cursor keys to activate an OFFON item (have the focus)
*> use a single click with left mouse key on item description or inside brackets = activate the item
*> use a double click with left mouse key or Enter or Spacebar = put ON or OFF the active item
*> To exit from OFFON items management use: TAB, ESC, PGUP/DOWN, right mouse key single or doubleclick
*>
*> sample schema of OFFON items list with 9 items
*>
*>       +------------------------------------------+
*>       |  Stop after first error... OFF [X  ] ON  |
*>       |  Allow LABEL and GOTO..... OFF [X  ] ON  |
*>       |  Enable macros............ OFF [  X] ON  |
*>       |  Allow inline............. OFF [X  ] ON  |
*>       |  Include assertion code... OFF [  X] ON  |
*>       |  Load compatible units.... OFF [  X] ON  |
*>       |  Allow STATIC in objects.. OFF [  X] ON  |
*>       |  C like operators......... OFF [X  ] ON  |
*>       |  Conditional defines...... OFF [  X] ON  |
*>       +------------------------------------------+
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
    *> 03  w            pic 9(02) value 0.
    03  i            pic 9(02) value 1.
    03  j            pic 9(02) value 1.
    03  k            pic 9(02) value 1.
    03  bco          PIC 9(02).
    03  fco          PIC 9(02).
    03  fcoH         PIC X(01).
    03  wDummy       PIC X(01) VALUE SPACE.
    03  wPrompt      PIC X(01) VALUE SPACE.
    03  wlen         pic 9(02) value 0.
    03  len-voce     pic 9(02) value 0.
    03  wOo-c        pic 9(03) value zero.

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

01  wOo-ItemLenTab    Value zero.
    05 wOo-ItemLen     occurs 99 pic 9(03). *> item length (char number before X"00")
    05 wOo-ItemCol-End occurs 99 pic 9(03). *> end column of the item

*> SAVE/RESTORE SCREEN VARIABLES
01 wScreenName        PIC X(256).
01 wiScrOk            BINARY-LONG.

01 wOo-Parameters     PIC x(12) value space.


copy    'GC02BOXMEX.CPY' suppress.
copy 'GC97KEYCODEGC.CPY'  suppress.

LINKAGE SECTION.
copy 'GC15OFFON.CPY'.

*> ***********************************************************************************
*>
*>                       P R O C E D U R E   D I V I S I O N
*>
*> ***********************************************************************************
PROCEDURE DIVISION using OFFON-Area.
   perform InitialSettings thru InitialSettingsEx.
   move 1 to i, j

   move Oo-Parameters to wOo-Parameters *> useful to reset colors
   perform HideCursor thru HideCursorEx
   continue.

DisplayScreen.
   *> display ALL OFFON ITEMS
   perform DisplayOFFONItems thru DisplayOFFONItemsEx
   continue.

*> ***********************************************************************************
*> WAIT FOR USER ACTION
*> ***********************************************************************************
Accept-a-Key.
 *> accept of a 1 byte dummy field at a fixed position Oo-r(1) Oo-c(1)
 *> the dummy field is at cursor position of the 1st byte of the first OFFON ITEM
 *> it has same back and fore color of 1st ITEM so it is invisible
 *> the "with Auto" option is useful to detect user action ex.a cursor key is pressed

      move Oo-Item(1) (1:1) to wPrompt *> set wDummy before Accept

  if Oo-wait  = 'Y'
     *> after displayed OFFON items wait for user action (normal use)
     *> accept of the wDummy field is always on 1st byte of 1st item. it is normal or highlight
     if Oo-Selected = 1
        accept wDummy at line Oo-r(1) col Oo-c(1)
                 with auto-skip prompt character is wPrompt :BCOL: Oo-bcoA :FCOL: Oo-fcoA highlight
                *> with auto-skip update                      :BCOL: Oo-bcoA :FCOL: Oo-fcoA highlight
     else
        accept wDummy at line Oo-r(1) col Oo-c(1)
                with auto-skip prompt character is wPrompt :BCOL: Oo-bcoN :FCOL: Oo-fcoN
                *> with auto-skip update                        :BCOL: Oo-bcoN :FCOL: Oo-fcoN
     end-if
  else
      *> if requested by the caller, after displayed OFFON items list, return to caller
      *> useful to just display OFFON items list on screen
      go to END-PROGRAM
  end-if


*> <escape> TAB/BAckTAB, PGUP/DOWN or right mouse key: return to caller
*> if pressed cursor down or right -> activate next radiobutton Item
*> if pressed cursor up   or left  <- activate previous radiobutton Item
*> *************************************************************************
*> ENTER = mark/unmark the OFFON item
*> *************************************************************************
*> detect Enter or ESCAPE key only if user has not typed a letter or a digit
*> if user has typed a letter or a digit then WDummy is just une char and has the "AUTO" attribute
*> then the wCRT-STATUS is = 00000 (K-ENTER) !


*> *************************************************************************
*> EVALUATE THE USER ACTION (A KEY OR A MOUSE KEY WASS PRESSED)
*> *************************************************************************
   EVALUATE TRUE

           *> NEXT OFFON ITEM WILL BECAME "ACTIVE"
           when wCRT-STATUS = K-RIGHT   *> Cursor Key right or down
             or wCRT-STATUS = K-DOWN

                  *> set and display "current" OFFON item as Normal OFFON item
                  move Oo-Selected to i
                  move space       to Oo-Act(Oo-Selected)
                  Move Oo-bcoN  to bco
                  Move Oo-fcoN  to fco
                  Move Oo-fcoNH to fcoH
                  perform DisplayOFFON thru DisplayOFFONEx

                  *> set and display next OFFON item as Active OFFON item
                  if Oo-Selected = Oo-Number
                     move 1 to Oo-Selected i
                  else
                     add  1 to Oo-Selected i
                  end-if
                  move '1'   to Oo-Act(Oo-Selected)
                  Move Oo-bcoA  to bco
                  Move Oo-fcoA  to fco
                  Move Oo-fcoAH to fcoH
                  perform DisplayOFFON thru DisplayOFFONEx

           *> PREVIOUS OFFON ITEM WILL BECAME "ACTIVE"
           when wCRT-STATUS = K-LEFT  *> Cursor Key left or Up
             or wCRT-STATUS = K-UP

                  *> set and display "current" OFFON item as Normal OFFON item
                  move Oo-Selected to i
                  move space       to Oo-Act(Oo-Selected)
                  Move Oo-bcoN  to bco
                  Move Oo-fcoN  to fco
                  Move Oo-fcoNH to fcoH
                  perform DisplayOFFON thru DisplayOFFONEx

                  *> set and display previous OFFON item as Active OFFON item
                  if Oo-Selected = 1
                     move Oo-Number  to Oo-Selected i
                  else
                     subtract 1 from Oo-Selected i
                  end-if
                  move '1'      to Oo-Act(Oo-Selected)
                  Move Oo-bcoA  to bco
                  Move Oo-fcoA  to fco
                  Move Oo-fcoAH to fcoH
                  perform DisplayOFFON thru DisplayOFFONEx

      *> User clicked a Left Mouse Key: check if mouse position was on an ITEM
      when (wCRT-STATUS = K-LEFT-PRESSED )
           perform varying k from 1 by 1 until k > Oo-number
             if wCursorRow  = Oo-r(k)
                compute wOo-c = wOo-ItemCol-End(k) + 13  *> (13 = 'OFF ' 2 brackets + 3 marker + ' ON '
                if ( wCursorCol >= Oo-c(k) and  wCursorCol <= wOo-c )
                *> if ( wCursorCol >= wOo-c and wCursorCol <= wOo-ItemCol-End(k) )
                  *> the mouse has been clicked on a ITEM (or on the OFFON marker itself)
                  move wCRT-STATUS  to Oo-Key
                  *> change display of active OFFON to display as normal OFFON
                  move Oo-Selected to i
                  move space       to Oo-Act(Oo-Selected)
                  Move Oo-bcoN     to bco
                  Move Oo-fcoN     to fco
                  Move Oo-fcoNH    to fcoH
                  perform DisplayOFFON thru DisplayOFFONEx
                  *> change the clicked OFFON to display from normal OFFON to display as active
                  move k        to Oo-Selected i
                  move '1'      to Oo-Act(Oo-Selected)
                  Move Oo-bcoA  to bco
                  Move Oo-fcoA  to fco
                  Move Oo-fcoAH to fcoH
                  perform DisplayOFFON thru DisplayOFFONEx

                  *> if wCRT-STATUS = K-LEFT-DBL-CLICK
                    *> move K-ENTER  to Oo-Key
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
        perform varying k from 1 by 1 until k > Oo-Number
                if Oo-Hot(k) not = zero move Oo-Item(k) (Oo-Hot(k):1) to wChar end-if
                inspect wChar converting 'ABCDEFGHIJKLMNOPQRSTUVWXYZ' to 'abcdefghijklmnopqrstuvwxyz'
                if wChar = wChars-Ele(wChars-Idx)
                    *> the letter typed by the user is a valid hotkey !
                    *> change display of active item to display as normal item
                    move Oo-Selected to i
                    move space    to Oo-Act(Oo-Selected)
                    Move Oo-bcoN  to bco
                    Move Oo-fcoN  to fco
                    Move Oo-fcoNH to fcoH
                    perform DisplayOFFON thru DisplayOFFONEx
                   *> change the item with the hotkey to display from normal item to display as active item
                    move k        to Oo-Selected i
                    move '1'      to Oo-Act(Oo-Selected)
                    Move Oo-bcoA  to bco
                    Move Oo-fcoA  to fco
                    Move Oo-fcoAH to fcoH
                    perform DisplayOFFON thru DisplayOFFONEx
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
        perform varying k from 1 by 1 until k > Oo-Number
                if Oo-Hot(k) not = zero move Oo-Item(k) (Oo-Hot(k):1) to wNum end-if
                if wNum = wNums-Ele(wNums-Idx)
                    *> the digit typed by the user is a valid hotkey !
                    *> change display of active item to display as normal item
                    move Oo-Selected to i
                    move space       to Oo-Act(Oo-Selected)
                    Move Oo-bcoN  to bco
                    Move Oo-fcoN  to fco
                    Move Oo-fcoNH to fcoH
                    perform DisplayOFFON thru DisplayOFFONEx
                   *> change the item with the hotkey to display from normal item to display as active item
                    move k to Oo-Selected i
                    move '1'   to Oo-Act(Oo-Selected)
                    Move Oo-bcoA  to bco
                    Move Oo-fcoA  to fco
                    Move Oo-fcoAH to fcoH
                    perform DisplayOFFON thru DisplayOFFONEx
                end-if
        end-perform

        *> TOGGLE THE MARK / UNMARK OF "ACTIVE" OFFON ITEM
         when wCRT-STATUS = K-ENTER or wCRT-STATUS = K-LEFT-DBL-CLICK
            if Oo-Mark(i) = space
               move '1' to Oo-Mark(i)
            else
               move ' ' to Oo-Mark(i)
            end-if
            Move Oo-bcoA to bco
            move Oo-fcoA to fco
            perform DisplayOFFON thru DisplayOFFONEx

     when wCRT-STATUS = K-F1              *> F1 HELP
            perform DisplayHelp thru DisplayHelpEx
            go to DisplayScreen
      when wCRT-STATUS = K-F2              *> F2 change "non active" items Fore Color
            move 1 to i
            add 1 to Oo-FcoN
            If Oo-FcoN > 7 move 0 to Oo-FcoN end-if
            go to DisplayScreen
      when wCRT-STATUS = K-F3              *> F3 change "non active" items Back Color
            move 1 to i
            add 1 to Oo-BcoN
            If Oo-BcoN > 7 move 0 to Oo-BcoN end-if
            go to DisplayScreen
      when wCRT-STATUS = K-F4              *> F2 change "active" items Fore Color
            move 1 to i
            add 1 to Oo-FcoA
            If Oo-FcoA > 7 move 0 to Oo-FcoA end-if
            go to DisplayScreen
      when wCRT-STATUS = K-F5              *> F3 change "active" items Back Color
            move 1 to i
            add 1 to Oo-BcoA
            If Oo-BcoA > 7 move 0 to Oo-BcoA end-if
            go to DisplayScreen
      when wCRT-STATUS = K-F9              *> F9 reset colors to their initial state
            move 1 to i
            move wOo-Parameters to Oo-Parameters
            go to DisplayScreen
   *> *************************************************************************
   *> EXIT WITH ONE OF FOLLOWING KEYS
   *> *************************************************************************
       when wCRT-STATUS = K-TAB
         or wCRT-STATUS = K-BACKTAB
         or wCRT-STATUS = K-PAGEUP
         or wCRT-STATUS = K-PAGEDOWN
         or wCRT-STATUS = K-ESCAPE
         or wCRT-STATUS = K-RIGHT-PRESSED
         or wCRT-STATUS = K-RIGHT-DBL-CLICK
            move wCRT-STATUS to Oo-Key
            go to END-PROGRAM

   END-EVALUATE

   go to Accept-a-Key
   continue.

END-PROGRAM.
   perform ShowCursor thru ShowCursorEx
   GOBACK.


*> ***********************************************************************************
*> LOOP to display ALL OFFON ITEMS
*> ***********************************************************************************
DisplayOFFONItems.
   *> to count how many OFFON items
   if Oo-ele(i) = low-value
      compute Oo-Number   =  i - 1
      move    Oo-Selected to i
      go to DisplayOFFONItemsEx
   end-if

   if Oo-Act(i) = '1'
      *> set bco and fco to color of Active OFFON
      move i       to Oo-Selected
      move Oo-bcoA to bco move Oo-fcoA to fco Move Oo-fcoAH to fcoH
   else
      *> set bco and fco to color of non active OFFON
      move Oo-bcoN to bco move Oo-fcoN to fco Move Oo-fcoNH to fcoH
   end-if
   perform DisplayOFFON thru DisplayOFFONEx
   add  1 to i

   *> go to display next OFFON item
   go to DisplayOFFONItems.

DisplayOFFONItemsEx. exit.

*> ***********************************************************************************
*> DISPLAY A SINGLE OFFON ITEM
*> ***********************************************************************************
DisplayOFFON.
   *> j = number/position of single character of OFFON item description
   move 0 to j.

   *> store the legth of each OFFON item, useful later to detect if user has mouse clicked on it
   move zero to wOo-ItemLen(i)
   inspect Oo-Item(i) tallying wOo-ItemLen(i) FOR CHARACTERS before x"00"
   compute wOo-ItemCol-End(i) =  Oo-c(i) +  wOo-ItemLen(i) - 1
   continue.

loop1.
   *> loop to display single chars of a OFFON item
   add 1 to j
   if Oo-Item(i) (j:1) = low-value go loop1-ex end-if

   *> save max length of OFFON items
   compute wlen = (Oo-c(i) + j - 1) - (Oo-c(1) + 1)
   if wlen > len-voce move wlen to len-voce end-if

   compute wCol = Oo-c(i) + j - 1 end-compute

   if j = Oo-Hot(i)
      *> display the hotkey character of OFFON item with different colors
      if Oo-fcoHH = 'Y'
         display Oo-Item(i) (j:1) at line Oo-r(i) col wcol with :BCOL: Oo-bcoH :FCOL: Oo-fcoH highlight
      else
         display Oo-Item(i) (j:1) at line Oo-r(i) col wcol with :BCOL: Oo-bcoH :FCOL: Oo-fcoH
      end-if
   else
      *> display a normal character of OFFON item (active or non active)
      if fcoH = 'Y'
         display Oo-Item(i) (j:1) at line Oo-r(i) col wcol with :BCOL: bco :FCOL: fco highlight
      else
         display Oo-Item(i) (j:1) at line Oo-r(i) col wcol with :BCOL: bco :FCOL: fco
      end-if
   end-if
   go to loop1.

loop1-ex.
   *> display: space, OFF, space, bracket open, 3 chars for marker, bracket close, space,ON (13 chars)
    if fcoH = 'Y'
       compute wCol = Oo-c-OFFON(i)      end-compute
       display 'OFF '          at line Oo-r(i) col wcol with :BCOL: bco :FCOL: fco highlight
       compute wCol = Oo-c-OFFON(i) +  4 end-compute
       display Oo-BracketChar1 at line Oo-r(i) col wcol with :BCOL: bco :FCOL: fco highlight
       compute wCol = Oo-c-OFFON(i) +  6 end-compute
       display ' '             at line Oo-r(i) col wcol with :BCOL: bco :FCOL: fco highlight
       compute wCol = Oo-c-OFFON(i) +  8 end-compute
       display Oo-BracketChar2 at line Oo-r(i) col wcol with :BCOL: bco :FCOL: fco highlight
       compute wCol = Oo-c-OFFON(i) +  9 end-compute
       display ' ON '          at line Oo-r(i) col wcol with :BCOL: bco :FCOL: fco highlight

       if Oo-Mark(i) = '1'
          compute wCol = Oo-c-OFFON(i) + 7 end-compute
          display Oo-MarkChar at line Oo-r(i) col wcol with :BCOL: bco :FCOL: fco highlight
          compute wCol = Oo-c-OFFON(i) + 5 end-compute
          display ' '         at line Oo-r(i) col wcol with :BCOL: bco :FCOL: fco highlight
       else
          compute wCol = Oo-c-OFFON(i) + 7 end-compute
          display ' '         at line Oo-r(i) col wcol with :BCOL: bco :FCOL: fco highlight
          compute wCol = Oo-c-OFFON(i) + 5 end-compute
          display Oo-MarkChar at line Oo-r(i) col wcol with :BCOL: bco :FCOL: fco highlight
       end-if
   else
       compute wCol = Oo-c-OFFON(i)     end-compute
       display 'OFF '          at line Oo-r(i) col wcol with :BCOL: bco :FCOL: fco
       compute wCol = Oo-c-OFFON(i) +  4 end-compute
       display Oo-BracketChar1 at line Oo-r(i) col wcol with :BCOL: bco :FCOL: fco
       compute wCol = Oo-c-OFFON(i) +  6 end-compute
       display ' '             at line Oo-r(i) col wcol with :BCOL: bco :FCOL: fco
       compute wCol = Oo-c-OFFON(i) +  8 end-compute
       display Oo-BracketChar2 at line Oo-r(i) col wcol with :BCOL: bco :FCOL: fco
       compute wCol = Oo-c-OFFON(i) +  9 end-compute
       display ' ON '          at line Oo-r(i) col wcol with :BCOL: bco :FCOL: fco

       if Oo-Mark(i) = '1'
          compute wCol = Oo-c-OFFON(i) + 7 end-compute
          display Oo-MarkChar at line Oo-r(i) col wcol with :BCOL: bco :FCOL: fco
          compute wCol = Oo-c-OFFON(i) + 5 end-compute
          display ' '         at line Oo-r(i) col wcol with :BCOL: bco :FCOL: fco
       else
          compute wCol = Oo-c-OFFON(i) + 7 end-compute
          display ' '         at line Oo-r(i) col wcol with :BCOL: bco :FCOL: fco
          compute wCol = Oo-c-OFFON(i) + 5 end-compute
          display Oo-MarkChar at line Oo-r(i) col wcol with :BCOL: bco :FCOL: fco
       end-if
   end-if
   continue.
DisplayOFFONEx. exit.

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
    move z'                               ' to Bxm-mex(01)
    move z' Use left mouse button on item ' to Bxm-mex(02)
    move z' to activate the item          ' to Bxm-mex(03)
    move z'                               ' to Bxm-mex(04)
    move z' Use cursor keys or hotkeys    ' to Bxm-mex(05)
    move z' to activate an item           ' to Bxm-mex(06)
    move z'                               ' to Bxm-mex(07)
    move z' Enter or spacebar o left      ' to Bxm-mex(08)
    move z' doubleclick to set OFF or ON  ' to Bxm-mex(09)
    move z' the active item               ' to Bxm-mex(10)
    move z'                               ' to Bxm-mex(11)
    move z' TAB, ESC or right mouseclick  ' to Bxm-mex(12)
    move z' to exit from OFFON mgmt       ' to Bxm-mex(13)
    move z'                               ' to Bxm-mex(14)
    move z'                               ' to Bxm-mex(15)
    move z' eugenio.dilo@gmail.com   2021 ' to Bxm-mex(16)
    move z'                               ' to Bxm-mex(17)
    move z' hit <enter> to return ...     ' to Bxm-mex(18)
    move blue     to Bxm-bco    Bxm-titBco Bxm-bcoM
    move white    to Bxm-fco    Bxm-titFco Bxm-fcoM
    move 'Y'      to Bxm-Click  Bxm-tit
    move 'N'      to Bxm-3D     Bxm-OkButton
    move 'S'      to Bxm-style
    move x'B4' & ' GnuCOBOL OFFON - HELP '  & x'C3' & x'00' to Bxm-titDes
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
   move Z'GC15OFFON.TMP' to wScreenName
   call static 'scr_dump' using by reference wScreenName returning wiScrOk end-call.
ScreenSaveEx. exit.

ScreenRestore.
   call static 'scr_restore' using by reference wScreenName returning wiScrOk end-call
   CALL 'CBL_DELETE_FILE' USING wScreenName.
ScreenRestoreEx. exit.

End Program GC15OFFON.
