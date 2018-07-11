       >> SOURCE FORMAT IS FREE
       REPLACE ==:BCOL:== BY ==BACKGROUND-COLOR==
               ==:FCOL:== BY ==FOREGROUND-COLOR==.
IDENTIFICATION DIVISION.
PROGRAM-ID. GC18RADIOBUTTON is initial.
*> ***********************************************************************************
*> GnuCOBOL TT (TUI TOOLS) AND UTILITIES COLLECTION
*> Purpose:    DISPLAYS AND MANAGE RADIOBUTTON ITEMS ON SCREEN
*>             make only one of items "marked/selected" with cursors/page/tab keys.
*> Tectonics:  cobc -m GC18RADIOBUTTON.COB  (use GnuCOBOL 2.0 or greater)
*> Usage:      call GC18RADIOBUTTON using RADIOBUTTON-AREA
*> Parameters: look at GC18RADIOBUTTON.cpy (use with copy Version: 1.3)
*> Author:     Eugenio Di Lorenzo - Italia (DILO)
*> License:    Copyright 2017 E.Di Lorenzo - GNU Lesser General Public License, LGPL, 3.0 (or greater)
*> Version:    1.4 2018-06.30
*> Changelog:  1.0 first release.
*>             1.1 hot key management added
*>             1.2 Rb-Hot from 9(01) to 9(02)
*>             1.3 Rb-wait management added
*>             1.4 Rbu-Number changed to Rb-Number that is added in GC18RADIOBUTTON.cpy
*>                 Use PgUp, PgDn, Tab to exit from Radiobutton
*> ***********************************************************************************

ENVIRONMENT DIVISION.
CONFIGURATION SECTION.

DATA DIVISION.
Working-Storage Section.
01  wWork.
    03  wCol         pic 9(02) value 0.
    03  w            pic 9(02) value 0.
    03  i            pic 9(02) value 1.
    03  j            pic 9(02) value 1.
    03  k            pic 9(02) value 1.
    *> 03  Rbu-Number    pic 9(02) value 0.
    03  bco          PIC 9(02).
    03  fco          PIC 9(02).
    03  fcoH         PIC X(01).
    03  wDummy       PIC X(01) VALUE SPACE.
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

01 wChar        PIC X(01).
01 wNum         PIC X(01).
01 wChars.
   03  wChars1 pic x(26) value 'abcdefghijklmnopqrstuvwxyz'.
   03  wChars-Ele redefines wChars1 pic x(01) occurs 26 indexed by wChars-Idx.
01 wNums.
   03  wNums1 pic x(26) value '0123456789'.
   03  wNums-Ele redefines wNums1 pic x(01) occurs 10 indexed by wNums-Idx.

COPY 'GC98KEYCODE.CPY'.

LINKAGE SECTION.
copy 'GC18RADIOBUTTON.CPY'.

*> ***********************************************************************************
*>
*>                       P R O C E D U R E   D I V I S I O N
*>
*> ***********************************************************************************
PROCEDURE DIVISION using RadioButton-Area.
    *> sets in order to detect the PgUp, PgDn, PrtSc(screen print), Esc keys,
    set environment 'COB_SCREEN_EXCEPTIONS' TO 'Y'.
    set environment 'COB_SCREEN_ESC'        TO 'Y'.

    move 1 to i, j, w. *> Rb-Number .

*> ***********************************************************************************
*> display ALL RADIOBUTTON items and wait for user input
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
*> AFTER DISPLAYED RADIOBUTTON ITEMS WAIT FOR USER INPUT
*> ***********************************************************************************
loop-user-input.
    *> hide the cursor and save its previous state
    *> (use always a display or an accept at .... before to have a call to "initscr"
    *> move 0 to wVisibilityNew
    *> call static "curs_set" using by value wVisibilityNew returning wVisibilityOld end-call
    perform CursorHide thru CursorHideEx

    if Rb-wait  = 'Y'
      *> after displayed radiobutton items wait for user key press
       call static "getch" returning Key-Pressed end-call
    else
       *> after displayed radiobutton items return to caller without waiting for user input
       *> useful whren you have just to display radiobuttons on screen
       go to END-PROGRAM
    end-if

   EVALUATE TRUE
   *> i = number of RadioButton item
           *> NEXT RADIOBUTTON ITEM WILL BECAME "ACTIVE" AND "MARKED"
           when Key-Pressed = Key-CursRight
             or Key-Pressed = Key-CursDn
             or Key-Pressed = Key-space

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
           when Key-Pressed = Key-CursLeft
             or Key-Pressed = Key-CursUp

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

    *> *****************************************************************************************
    *> IF USER HAS TYPED A LETTER - SEARCH IF IT IS A HOT KEY
    *> *****************************************************************************************
     when Key-Pressed >= Key-lc-a and <= Key-lc-z
        *> search the index of Key Pressed
        set wChars-Idx Key-lc-Idx to 0
        search Key-lc-Ele varying  Key-lc-Idx
               at end set Key-lc-Idx to 0
               when   Key-lc-Ele (Key-lc-Idx) = Key-Pressed  continue
        end-search

        set wChars-Idx to Key-lc-Idx
        perform varying k from 1 by 1 until k > Rb-Number
                if Rb-Hot(k) not = zero move Rb-Item(k) (Rb-Hot(k):1) to wChar end-if
                inspect wChar converting 'ABCDEFGHIJKLMNOPQRSTUVWXYZ' to 'abcdefghijklmnopqrstuvwxyz'
                if wChar = wChars-Ele(wChars-Idx)
                    *> the letter typed by the user is a valid hotkey !
                    *> change display of active item to display as normal item
                    move Rb-Selected to i
                    move space       to Rb-Act(Rb-Selected)
                    move ' '         to Rb-Mark(i)   *> unmark the item
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
     when Key-Pressed >= Key-0 and <= Key-9
        *> search the index of Key Pressed
        set wChars-Idx Key-num-Idx to 0
        search Key-num-Ele varying  Key-num-Idx
               at end set Key-num-Idx to 0
               when   Key-num-Ele (Key-num-Idx) = Key-Pressed  continue
        end-search

        set wNums-Idx to Key-num-Idx
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
   *> EXIT WITH ON EOF FOLLOWING KEYS ONLY ONE OPTION SELECTED - THE  MARKED RADIOBUTTON
   *> *************************************************************************
       when Key-Pressed = Key-Enter
         or Key-Pressed = Key-PgUp
         or Key-Pressed = Key-PgDn
         or Key-Pressed = Key-Tab
         or Key-Pressed = Key-Escape
         or Key-Pressed = Key-F1
         or Key-Pressed = Key-F12
            move Key-Pressed to Rb-Key
            go to END-PROGRAM
   END-EVALUATE

   go to loop-user-input
   continue.
END-PROGRAM.

   *> reset (show) the cursor to its previous state
   move wVisibilityOld to wVisibilityNew
   call static "curs_set" using by value wVisibilityNew returning wVisibilityOld end-call

   GOBACK.



*> ***********************************************************************************
*> DISPLAY A RADIOBUTTON
*> ***********************************************************************************
DisplayRadioButton.
   *> j = number/position of single character of RadioButton item description
   move 0 to j.
loop1.
   *> loop to display single chars of a RadioButton item
   add 1 to j
   if Rb-Item(i) (j:1) = low-value go loop1-ex end-if

   *> save max length of RadioButton items
   compute wlen = (Rb-c(i) + j - 1) - (Rb-c(1) + 1)
   if wlen > len-voce move wlen to len-voce end-if

   compute wCol = Rb-c(i) + j - 1 end-compute

      *> display j at 0103
      *> display Rb-Hot(i)  at 0203
      *> accept OMITTED

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
   *> display "brackets" and markchar

   compute wCol = Rb-c(i) - 4 end-compute
   display '     ' at line Rb-r(i) col wcol with :BCOL: bco :FCOL: fco end-display
   if fcoH = 'Y'
       compute wCol = Rb-c(i) - 3 end-compute
       display Rb-BracketChar1 at line Rb-r(i) col wcol with :BCOL: bco :FCOL: fco highlight end-display
       compute wCol = Rb-c(i) - 1 end-compute
       display Rb-BracketChar2 at line Rb-r(i) col wcol with :BCOL: bco :FCOL: fco highlight end-display
       compute wCol = Rb-c(i) - 2 end-compute
       if Rb-Mark(i) = '1'
          display Rb-MarkChar at line Rb-r(i) col wcol with :BCOL: bco :FCOL: fco highlight end-display
       else
          display ' '         at line Rb-r(i) col wcol with :BCOL: bco :FCOL: fco highlight end-display
       end-if
   else
       compute wCol = Rb-c(i) - 3 end-compute
       display Rb-BracketChar1 at line Rb-r(i) col wcol with :BCOL: bco :FCOL: fco end-display
       compute wCol = Rb-c(i) - 1 end-compute
       display Rb-BracketChar2 at line Rb-r(i) col wcol with :BCOL: bco :FCOL: fco end-display
       compute wCol = Rb-c(i) - 2 end-compute
       if Rb-Mark(i) = '1'
          display Rb-MarkChar  at line Rb-r(i) col wcol with :BCOL: bco :FCOL: fco end-display
       else
          display ' '          at line Rb-r(i) col wcol with :BCOL: bco :FCOL: fco end-display
       end-if
   end-if
   continue.
DisplayRadioButtonEx. exit.

CursorHide.
    *> save cursor state and hide the cursor
    *> (use always a "display ...at ..."  or an "accept ... at ..." before to have a call to "initscr"
    move wCursorHide  to wVisibilityNew
    call static "curs_set" using by value wVisibilityNew returning wVisibilityOld end-call
    continue.
CursorHideEx. exit.

*> CursorReset.
    *> perform CursorReset thru CursorResetEx
    *> *> reset (show) the cursor to its saved previous state
    *> move wVisibilityOld to wVisibilityNew
    *> call static "curs_set" using by value wVisibilityNew returning wVisibilityOld end-call
    *> continue.
*> CursorResetEx. exit.

End Program GC18RADIOBUTTON.
