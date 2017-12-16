       >> SOURCE FORMAT IS FREE
       REPLACE ==:BCOL:== BY ==BACKGROUND-COLOR==
               ==:FCOL:== BY ==FOREGROUND-COLOR==.
IDENTIFICATION DIVISION.
PROGRAM-ID. GC13CHECKBOX is initial.
*> ***********************************************************************************
*> GnuCOBOL TT (TUI TOOLS) AND UTILITIES COLLECTION
*> Purpose:    DISPLAYS AND MANAGE CHECKBOX ITEMS (SWITHCES) ON SCREEN
*>             make items active with cursors/page/tab keys, mark/unmark a checkbox whit spacebar
*> Tectonics:  cobc -m GC13CHECKBOX.COB  (use GnuCOBOL 2.0 or greater)
*> Usage:      call GC13CHECKBOX using CHECKBOX-AREA
*> Parameters: look at GC13CHECKBOX.cpy (use with copy Version: 1.1)
*> Author:     Eugenio Di Lorenzo - Italia (DILO)
*> License:    Copyright 2017 E.Di Lorenzo - GNU Lesser General Public License, LGPL, 3.0 (or greater)
*> Version:    1.3 2017.11.15
*> Changelog:  1.0 first release.
*>             1.1 hot key management added
*>             1.2 Ck-Hot from 9(01) to 9(02)
*>             1.3 Ck-wait management added
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
    03  Chk-Number   pic 9(02) value 0.
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
copy 'GC13CHECKBOX.CPY'.


*> ***********************************************************************************
*>
*>                       P R O C E D U R E   D I V I S I O N
*>
*> ***********************************************************************************
PROCEDURE DIVISION using CHECKBOX-Area.
    *> sets in order to detect the PgUp, PgDn, PrtSc(screen print), Esc keys,
    set environment 'COB_SCREEN_EXCEPTIONS' TO 'Y'.
    set environment 'COB_SCREEN_ESC'        TO 'Y'.

    move 1 to i, j, w, Chk-Number.

*> ***********************************************************************************
*> display ALL CHECKBOXES and wait for user input
*> ***********************************************************************************
DisplayCheckboxItems.
   *> to count how many CHECKBOX
   if Ck-ele(i) = low-value
      compute Chk-Number  =  i - 1
      move    Ck-Selected to i
      go to DisplayCheckboxItemsEx end-if

   *> set bco and fco to color of Active Checkbox
   if Ck-Act(i) = '1'
      move i       to Ck-Selected
      Move Ck-bcoA to bco
      move Ck-fcoA to fco
      Move Ck-fcoAH to fcoH
  *> set bco and fco to color of non active CHECKBOX
   else
      Move Ck-bcoN to bco
      move Ck-fcoN to fco
      Move Ck-fcoNH to fcoH
   end-if

   perform DisplayCheckBox thru DisplayCheckBoxEx
   add  1 to i

   *> go to display next Checkbox item
   go to DisplayCheckboxItems.

DisplayCheckboxItemsEx. exit.

*> ***********************************************************************************
*> AFTER DISPLAYED CHECKBOX ITEMS WAIT FOR USER INPUT
*> ***********************************************************************************
loop-user-input.

    *> hide the cursor and save its previous state
    *> (use always a display or an accept at .... before to have a call to "initscr"
    move 0 to wVisibilityNew
    call static "curs_set" using by value wVisibilityNew returning wVisibilityOld end-call

    *> call static "getch" returning Key-Pressed end-call

    if Ck-wait  = 'Y'
      *> after dispalyed checkbox items wait for user key press
       call static "getch" returning Key-Pressed end-call
    else
       *> after dispalyed checkbox items return to caller
       go to END-PROGRAM
    end-if


   EVALUATE TRUE
   *> i = number of checkbox item

           *> TOGGLE THE MARK / UN-MARK OF "ACTIVE" CHECKBOX ITEM
           when Key-Pressed =  Key-space
                if Ck-Mark(i) = space
                   move '1' to Ck-Mark(i)
                else
                   move ' ' to Ck-Mark(i)
                end-if
                Move Ck-bcoA to bco
                move Ck-fcoA to fco
                perform DisplayCheckBox thru DisplayCheckBoxEx

           *> NEXT CHECKBOX ITEM WILL BECAME "ACTIVE"
           when     Key-Pressed = Key-CursRight
                 or Key-Pressed = Key-CursDn
                 or Key-Pressed = Key-Tab
                 or Key-Pressed = Key-PgDn

                  *> set and display "current" checkbox item as Normal Checkbox item
                  move Ck-Selected to i
                  move space       to Ck-Act(Ck-Selected)
                  Move Ck-bcoN  to bco
                  Move Ck-fcoN  to fco
                  Move Ck-fcoNH to fcoH
                  perform DisplayCheckBox thru DisplayCheckBoxEx

                  *> set and display next checkbox item as Active Checkbox item
                  if   Ck-Selected = Chk-Number
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
           when     Key-Pressed = Key-CursLeft
                 or Key-Pressed = Key-CursUp
                 *> or Key-Pressed = Key-BackTab  (backtab doesn't work ?!?!?)
                 or Key-Pressed = Key-PgUp

                  *> set and display "current" checkbox item as Normal Checkbox item
                  move Ck-Selected to i
                  move space       to Ck-Act(Ck-Selected)

                  Move Ck-bcoN  to bco
                  Move Ck-fcoN  to fco
                  Move Ck-fcoNH to fcoH
                  perform DisplayCheckBox thru DisplayCheckBoxEx

                  *> set and display previous checkbox item as Active Checkbox item
                  if   Ck-Selected = 1
                       move Chk-Number to Ck-Selected i
                  else
                       subtract 1 from Ck-Selected i
                  end-if
                  move '1'      to Ck-Act(Ck-Selected)
                  Move Ck-bcoA  to bco
                  Move Ck-fcoA  to fco
                  Move Ck-fcoAH to fcoH
                  perform DisplayCheckBox thru DisplayCheckBoxEx

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
        perform varying k from 1 by 1 until k > Chk-Number
                if Ck-Hot(k) not = zero move Ck-Item(k) (Ck-Hot(k):1) to wChar end-if
                inspect wChar converting 'ABCDEFGHIJKLMNOPQRSTUVWXYZ' to 'abcdefghijklmnopqrstuvwxyz'
                if wChar = wChars-Ele(wChars-Idx)
                    *> the letter typed by the user is a valid hotkey !
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
        perform varying k from 1 by 1 until k > Chk-Number
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

   END-EVALUATE

   *> *************************************************************************
   *> ENTER = SELECTED A Checkbox
   *> *************************************************************************
   IF Key-Pressed = Key-Enter
      move Key-Enter  to Ck-Key
      go to END-PROGRAM
   end-if

   IF Key-Pressed = Key-Escape
      move Key-Escape to Ck-Key
      go to END-PROGRAM
   end-if

   go to loop-user-input

   continue.
END-PROGRAM.

   *> reset (show) the cursor to its previous state
   move wVisibilityOld to wVisibilityNew
   call static "curs_set" using by value wVisibilityNew returning wVisibilityOld end-call

   GOBACK.



*> ***********************************************************************************
*> DISPLAY A CHECKBOX
*> ***********************************************************************************
DisplayCheckBox.
   *> j = number/position of single character of checkbox item description
   move 0 to j.
loop1.
   *> loop to display single chars of a Checkbox item
   add 1 to j
   if Ck-Item(i) (j:1) = low-value go loop1-ex end-if

   *> save max length of Checkbox items
   compute wlen = (Ck-c(i) + j - 1) - (Ck-c(1) + 1)
   if wlen > len-voce move wlen to len-voce end-if

   compute wCol = Ck-c(i) + j - 1 end-compute

      *> display j at 0103
      *> display Ck-Hot(i)  at 0203
      *> accept OMITTED

   if j = Ck-Hot(i)
     *> display the hotkey character of checkbox item with different colors
     if Ck-fcoHH = 'Y'
        display Ck-Item(i) (j:1) at line Ck-r(i) col wcol with :BCOL: Ck-bcoH :FCOL: Ck-fcoH highlight end-display
     else
        display Ck-Item(i) (j:1) at line Ck-r(i) col wcol with :BCOL: Ck-bcoH :FCOL: Ck-fcoH end-display
     end-if
   else
      *> display a normal character of checkbox item (active or non active)
      if fcoH = 'Y'
         display Ck-Item(i) (j:1) at line Ck-r(i) col wcol with :BCOL: bco :FCOL: fco highlight end-display
      else
         display Ck-Item(i) (j:1) at line Ck-r(i) col wcol with :BCOL: bco :FCOL: fco end-display
      end-if
   end-if
   go to loop1.

loop1-ex.
   *> display "brackets" and markchar

   compute wCol = Ck-c(i) - 4 end-compute
   display '     ' at line Ck-r(i) col wcol with :BCOL: bco :FCOL: fco end-display
   if fcoH = 'Y'
       compute wCol = Ck-c(i) - 3 end-compute
       display Ck-BracketChar1 at line Ck-r(i) col wcol with :BCOL: bco :FCOL: fco highlight end-display
       compute wCol = Ck-c(i) - 1 end-compute
       display Ck-BracketChar2 at line Ck-r(i) col wcol with :BCOL: bco :FCOL: fco highlight end-display
       compute wCol = Ck-c(i) - 2 end-compute
       if Ck-Mark(i) = '1'
          display Ck-MarkChar at line Ck-r(i) col wcol with :BCOL: bco :FCOL: fco highlight end-display
       else
          display ' '         at line Ck-r(i) col wcol with :BCOL: bco :FCOL: fco highlight end-display
       end-if
   else
       compute wCol = Ck-c(i) - 3 end-compute
       display Ck-BracketChar1 at line Ck-r(i) col wcol with :BCOL: bco :FCOL: fco end-display
       compute wCol = Ck-c(i) - 1 end-compute
       display Ck-BracketChar2 at line Ck-r(i) col wcol with :BCOL: bco :FCOL: fco end-display
       compute wCol = Ck-c(i) - 2 end-compute
       if Ck-Mark(i) = '1'
          display Ck-MarkChar  at line Ck-r(i) col wcol with :BCOL: bco :FCOL: fco end-display
       else
          display ' '          at line Ck-r(i) col wcol with :BCOL: bco :FCOL: fco end-display
       end-if
   end-if
   continue.
DisplayCheckBoxEx. exit.


End Program GC13CHECKBOX.
