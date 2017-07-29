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
*> Parameters: look at GC13CHECKBOX.cpy (use with copy Version: 1.0)
*> Author:     Eugenio Di Lorenzo - Italia (DILO)
*> License:    Copyright 2017 E.Di Lorenzo - GNU Lesser General Public License, LGPL, 3.0 (or greater)
*> Version:    1.0 2017.07.10
*> Changelog:  1.0 first release.
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
    03  Chk-Number     pic 9(02) value 0.
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

   perform Display-Checkbox thru Display-CheckboxEx
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

    call static "getch" returning Key-Pressed end-call


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
                perform Display-Checkbox thru Display-CheckboxEx

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
                  perform Display-Checkbox thru Display-CheckboxEx

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
                  perform Display-Checkbox thru Display-CheckboxEx

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
                  perform Display-Checkbox thru Display-CheckboxEx

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
                  perform Display-Checkbox thru Display-CheckboxEx
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
Display-Checkbox.
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
Display-CheckboxEx. exit.


End Program GC13CHECKBOX.
