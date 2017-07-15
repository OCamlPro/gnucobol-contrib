       >> SOURCE FORMAT IS FREE
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
    03  wCol         pic s9(02) value +0.
    03  w            pic s9(02) value +0.
    03  i            pic s9(02) value +1.
    03  j            pic s9(02) value +1.
    03  Chk-Number     pic s9(02) value +0.
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
Main.
   *> to count how many CHECKBOX
   if Ck-ele(i) = low-value
      compute Chk-Number = i - 1
      go to Main-Ex end-if

   *> set color of active Checkbox
   if Ck-Act(i) = '1'
      move i       to Ck-Selected
      Move Ck-bcoS to bco
      move Ck-fcoS to fco
  *> set color of non active CHECKBOX
   else
      Move Ck-bcoN to bco
      move Ck-fcoN to fco
   end-if

   perform Display-Checkbox thru Display-CheckboxEx
   add  1 to i

   *> go to display next Checkbox item
   go to Main.

Main-Ex. exit.

*> ***********************************************************************************
*> after displayed CHECKBOX ITEMS WAIT FOR USER INPUT
*> ***********************************************************************************
loop-user-input.

    *> hide the cursor and save its previous state
    *> (use always a display or an accept at .... before to have a call to "initscr"
    move 0 to wVisibilityNew
    call static "curs_set" using by value wVisibilityNew returning wVisibilityOld end-call

    call static "getch" returning Key-Pressed end-call


   EVALUATE TRUE
   *> i = number of checkbox item

   *> toggle the mark of "active" checkbox item
   when Key-Pressed =  Key-space
        if Ck-Mark(i) = space
           move '1' to Ck-Mark(i)
        else
           move ' ' to Ck-Mark(i)
        end-if
        perform Display-Checkbox thru Display-CheckboxEx

   *> next checkbox item will became "active"
   when Key-Pressed = Key-CursRight
     or Key-Pressed = Key-CursDn
     or Key-Pressed = Key-Tab
     or Key-Pressed = Key-PgDn
     or Key-Pressed = Key-space

      move Ck-Selected to i
      move space    to Ck-Act(Ck-Selected)
      *> display as normal Checkbox
      Move Ck-bcoN to bco
      Move Ck-fcoN to fco
      Move Ck-fcoNH to fcoH
      perform Display-Checkbox thru Display-CheckboxEx
      if   Ck-Selected = Chk-Number
           move 1 to Ck-Selected i
      else
           add  1 to Ck-Selected i
      end-if
      move '1'   to Ck-Act(Ck-Selected)
      *> display as active Checkbox
      Move Ck-bcoS to bco
      Move Ck-fcoS to fco
      Move Ck-fcoSH to fcoH
      perform Display-Checkbox thru Display-CheckboxEx

   *> previous checkbox item will became "active"
   when Key-Pressed = Key-CursLeft
     or Key-Pressed = Key-CursUp
     *> or Key-Pressed = Key-BackTab
     or Key-Pressed = Key-PgUp

      move Ck-Selected to i
      move space       to Ck-Act(Ck-Selected)
      *> display as normal Checkbox
      Move Ck-bcoN to bco
      Move Ck-fcoN to fco
      Move Ck-fcoNH to fcoH

      perform Display-Checkbox thru Display-CheckboxEx
      if   Ck-Selected = 1
           move Chk-Number to Ck-Selected i
      else
           subtract 1 from Ck-Selected i
      end-if
      move '1'   to Ck-Act(Ck-Selected)
      *> display as selected Checkbox
      Move Ck-bcoS to bco
      Move Ck-fcoS to fco
      Move Ck-fcoSH to fcoH
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
   .
END-PROGRAM.

  *> reset (show) the cursor to its previous state
  move wVisibilityOld to wVisibilityNew
  call static "curs_set" using by value wVisibilityNew returning wVisibilityOld end-call

   Goback.

*> ***********************************************************************************
*> DISPLAY A CHECKBOX
*> ***********************************************************************************
Display-Checkbox.

   move 0 to j.  *> j = position of single character of checkbox description
loop1.
   *> loop to display single chars of a Checkbox
   add 1 to j
   if Ck-Item(i) (j:1) = low-value go loop1-ex end-if

   *> save max length of Checkbox items
   compute wlen = (Ck-c(i) + j - 1) - (Ck-c(1) + 1)
   if wlen > len-voce move wlen to len-voce end-if

   compute wCol = Ck-c(i) + j - 1 end-compute
   if j = Ck-Hot(i)
      display Ck-Item(i) (j:1) at line Ck-r(i) col wcol with background-color  bco foreground-color Ck-fcoH highlight end-display
   else
      if fcoH = 'Y'
         display Ck-Item(i) (j:1) at line Ck-r(i) col wcol with background-color bco foreground-color fco highlight end-display
      else
         display Ck-Item(i) (j:1) at line Ck-r(i) col wcol with background-color bco foreground-color fco end-display
      end-if
   end-if

   *> display "brackets" and markchar
   compute wCol = Ck-c(i) - 4 end-compute
   display '     ' at line Ck-r(i) col wcol with background-color bco foreground-color fco end-display
   if fcoH = 'Y'
       compute wCol = Ck-c(i) - 3 end-compute
       display Ck-BracketChar1 at line Ck-r(i) col wcol with background-color bco foreground-color fco end-display
       compute wCol = Ck-c(i) - 1 end-compute
       display Ck-BracketChar2 at line Ck-r(i) col wcol with background-color bco foreground-color fco end-display
       compute wCol = Ck-c(i) - 2 end-compute
       if Ck-Mark(i) = '1'
          display Ck-MarkChar at line Ck-r(i) col wcol with background-color bco foreground-color fco end-display
       else
          display ' ' at line Ck-r(i) col wcol with background-color bco foreground-color fco end-display
       end-if
   else
       compute wCol = Ck-c(i) - 3 end-compute
       display Ck-BracketChar1 at line Ck-r(i) col wcol with background-color bco foreground-color fco highlight end-display
       compute wCol = Ck-c(i) - 1 end-compute
       display Ck-BracketChar2 at line Ck-r(i) col wcol with background-color bco foreground-color fco highlight end-display
       compute wCol = Ck-c(i) - 2 end-compute
       if Ck-Mark(i) = '1'
          display Ck-MarkChar at line Ck-r(i) col wcol with background-color bco foreground-color fco highlight end-display
       else
          display ' ' at line Ck-r(i) col wcol with background-color bco foreground-color fco highlight end-display
       end-if
   end-if


   go to loop1.
loop1-ex.


   continue
   .
Display-CheckboxEx. exit.


End Program GC13CHECKBOX.
