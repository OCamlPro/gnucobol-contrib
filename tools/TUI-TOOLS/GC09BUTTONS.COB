       >> SOURCE FORMAT IS FREE
IDENTIFICATION DIVISION.
PROGRAM-ID. GC09BUTTONS is initial.
*> ***********************************************************************************
*> GnuCOBOL TT (TUI TOOLS) AND UTILITIES COLLECTION
*> Purpose:    DISPLAYS BUTTONS ON SCREEN
*> Tectonics:  cobc -m GC09BUTTONS.COB  (use GnuCOBOL 2.0 or greater)
*> Usage:      call GC09BUTTONS using BUTTONS-AREA
*> Parameters: look at GC09BUTTONS.cpy (use with copy Version: 1.1)
*> Author:     Eugenio Di Lorenzo - Italia (DILO)
*> License:    Copyright 2016 E.Di Lorenzo - GNU Lesser General Public License, LGPL, 3.0 (or greater)
*> Version:    1.4 2017.10.03
*> Changelog:  1.0 first release.
*>             1.1 changed from ACCEPT a DUMMY field to "call getch"
*>             1.2 added the "click effect" and beep on request
*>             1.3 some estethic changes
*>             1.4 added hot key management.
*> ***********************************************************************************
ENVIRONMENT DIVISION.

DATA DIVISION.
Working-Storage Section.
01  .
    03  wLoop        pic  9(04) value  0.
    03  wCol         pic s9(02) value +0.
    03  wR           pic s9(02) value +0.
    03  wC           pic s9(02) value +0.
    03  w            pic s9(02) value +0.
    03  i            pic s9(02) value +1.
    03  j            pic s9(02) value +1.
    03  k            pic 9(02) value 1.
    03  Item-Len     pic 9(02) value 0.
    03  Item-MaxLen  pic 9(02) value 0.
    03  salva-j      pic s9(02) value +1.
    03  Btn-Number     pic s9(02) value +0. *> count how many button items
    03  bco          PIC 9(02).
    03  fco          PIC 9(02).
    03  fcoH         PIC X(01).
    03  wDummy       PIC X(01) VALUE SPACE.
    03  wlen         pic 9(02) value 0.
    03  len-voce     pic 9(02) value 0.

01 wChar        PIC X(01).
01 wNum         PIC X(01).


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
01 wChars.
   03  wChars1 pic x(26) value 'abcdefghijklmnopqrstuvwxyz'.
   03  wChars-Ele redefines wChars1 pic x(01) occurs 26 indexed by wChars-Idx.


01 wNums.
   03  wNums1 pic x(26) value '0123456789'.
   03  wNums-Ele redefines wNums1 pic x(01) occurs 10 indexed by wNums-Idx.

COPY 'GC98KEYCODE.CPY'.

LINKAGE SECTION.
copy 'GC09BUTTONS.CPY'.


*> ***********************************************************************************
*>
*>                       P R O C E D U R E   D I V I S I O N
*>
*> ***********************************************************************************
PROCEDURE DIVISION using Buttons-Area.
*> sets in order to detect the PgUp, PgDn, PrtSc(screen print), Esc keys,
set environment 'COB_SCREEN_EXCEPTIONS' TO 'Y'.
set environment 'COB_SCREEN_ESC'        TO 'Y'.

   move 1 to i, j, w, Btn-Number.

*> ***********************************************************************************
*> display ALL BUTTONS and wait for user input
*> ***********************************************************************************
Main.
   *> to count how many buttons
   if Bu-ele(i) = low-value
      compute Btn-Number = i - 1
      go to Main-Ex end-if

   *> set color of selected button
   if Bu-Act(i) = '1'
      move i       to Bu-Selected
      Move Bu-bcoS to bco
      move Bu-fcoS to fco
  *> set color of non selected buttons
   else
      Move Bu-bcoN to bco
      move Bu-fcoN to fco
   end-if

   perform DisplayButton thru DisplayButtonEx
   add  1 to i

   *> go to display next Button
   go to Main.

Main-Ex. exit.

*> ***********************************************************************************
*> after displayed buttons WAIT FOR USER INPUT
*> ***********************************************************************************
loop-user-input.

*> hide the cursor and save its previous state
*> (use always a display or an accept at .... before to have a call to "initscr"
move 0 to wVisibilityNew
call static "curs_set" using by value wVisibilityNew returning wVisibilityOld end-call

call static "getch" returning Key-Pressed end-call


   EVALUATE TRUE

   when Key-Pressed = Key-CursRight
     or Key-Pressed = Key-CursDn
     or Key-Pressed = Key-Tab
     or Key-Pressed = Key-PgDn
     or Key-Pressed = Key-space

      move Bu-Selected to i
      move space    to Bu-Act(Bu-Selected)
      *> display as normal Button
      Move Bu-bcoN to bco
      Move Bu-fcoN to fco
      Move Bu-fcoNH to fcoH
      perform DisplayButton thru DisplayButtonEx
      if   Bu-Selected = Btn-Number
           move 1 to Bu-Selected i
      else
           add  1 to Bu-Selected i
      end-if
      move '1'   to Bu-Act(Bu-Selected)
      *> display as active Button
      Move Bu-bcoS to bco
      Move Bu-fcoS to fco
      Move Bu-fcoSH to fcoH
      perform DisplayButton thru DisplayButtonEx

   when Key-Pressed = Key-CursLeft
     or Key-Pressed = Key-CursUp
     *> or Key-Pressed = Key-BackTab
     or Key-Pressed = Key-PgUp

      move Bu-Selected to i
      move space            to Bu-Act(Bu-Selected)
      *> display as normal Button
      Move Bu-bcoN to bco
      Move Bu-fcoN to fco
      Move Bu-fcoNH to fcoH

      perform DisplayButton thru DisplayButtonEx
      if   Bu-Selected = 1
           move Btn-Number to Bu-Selected i
      else
           subtract 1 from Bu-Selected i
      end-if
      move '1'   to Bu-Act(Bu-Selected)
      *> display as selected Button
      Move Bu-bcoS to bco
      Move Bu-fcoS to fco
      Move Bu-fcoSH to fcoH
      perform DisplayButton thru DisplayButtonEx

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
        perform varying k from 1 by 1 until k > Btn-Number
                move Bu-Item(k) (Bu-Hot(k):1) to wChar
                inspect wChar converting 'ABCDEFGHIJKLMNOPQRSTUVWXYZ' to 'abcdefghijklmnopqrstuvwxyz'
                if wChar = wChars-Ele(wChars-Idx)
                    *> the letter typed by the user is a valid hotkey !
                    *> change display of active item to display as normal item
                    move Bu-Selected to i
                    move space       to Bu-Act(Bu-Selected)
                    Move Bu-bcoN  to bco
                    Move Bu-fcoN  to fco
                    Move Bu-fcoNH to fcoH
                    perform DisplayButton thru DisplayButtonEx
                   *> change the item with the hotkey to display from normal item to display as active item
                    move k to Bu-Selected i
                    move '1'   to Bu-Act(Bu-Selected)
                    Move Bu-bcoS  to bco
                    Move Bu-fcoS  to fco
                    Move Bu-fcoSH to fcoH
                    perform DisplayButton thru DisplayButtonEx
                end-if
        end-perform

    *> *****************************************************************************************
    *> IF USER HAS TYPED A NUMBER - SEARCH IF IT IS A HOT KEY
    *> *****************************************************************************************
     when Key-Pressed >= Key-0 and <= Key-9
        *> search the index of Key Pressed
        set wChars-Idx Key-num-Idx to 0
        search Key-num-Ele varying  Key-num-Idx
               at end set Key-num-Idx to 0
               when   Key-num-Ele (Key-num-Idx) = Key-Pressed  continue
        end-search

        set wNums-Idx to Key-num-Idx
        perform varying k from 1 by 1 until k > Btn-Number
                move Bu-Item(k) (Bu-Hot(k):1) to wNum
                if wNum = wNums-Ele(wNums-Idx)
                    *> the number typed by the user is a valid hotkey !
                    *> change display of active item to display as normal item
                    move Bu-Selected to i
                    move space       to Bu-Act(Bu-Selected)
                    Move Bu-bcoN  to bco
                    Move Bu-fcoN  to fco
                    Move Bu-fcoNH to fcoH
                    perform DisplayButton thru DisplayButtonEx
                   *> change the item with the hotkey to display from normal item to display as active item
                    move k to Bu-Selected i
                    move '1'   to Bu-Act(Bu-Selected)
                    Move Bu-bcoS  to bco
                    Move Bu-fcoS  to fco
                    Move Bu-fcoSH to fcoH
                    perform DisplayButton thru DisplayButtonEx
                end-if
        end-perform

   END-EVALUATE

   *> *************************************************************************
   *> ENTER = SELECTED A BUTTON
   *> *************************************************************************
   IF Key-Pressed = Key-Enter
      move Key-Enter  to Bu-Key
      if Bu-beep  = 'Y'  CALL X'E5'                   end-if
      if Bu-click = 'Y'  perform Click thru Click-Ex  end-if
      go to END-PROGRAM
   end-if

   IF Key-Pressed = Key-Escape
      move Key-Escape to Bu-Key
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
*> DISPLAY A BUTTON
*> ***********************************************************************************
DisplayButton.
   if Bu-Arrow = '1' or '2'
     perform varying j from 1 by 1 until Bu-Item(i) (j:1) = x'00' end-perform
   end-if

   Evaluate True
     when Bu-Arrow = '1'
          if Bu-Act(i) = '1'
             move Bu-Arrow-Char1 to Bu-Item(i) (1:1)
             move Bu-Arrow-Char2 to Bu-Item(i) (j - 1:1)
          else
             move space  to Bu-Item(i) (1:1)
             move space  to Bu-Item(i) (j - 1:1)
          end-if
     when Bu-Arrow = '2'
          if Bu-Act(i) = '1'
             move Bu-Arrow-Char1 to Bu-Item(i) (2:1)
             move Bu-Arrow-Char2 to Bu-Item(i) (j - 2:1)
          else
             move space  to Bu-Item(i) (2:1)
             move space  to Bu-Item(i) (j - 2:1)
          end-if
   end-evaluate

   move 0 to j.
loop1.
   *> loop to display single chars of a BUTTON
   add 1 to j
   if Bu-Item(i) (j:1) = low-value go loop1-ex end-if

   *> save max length of Button items
   compute wlen = (Bu-c(i) + j - 1) - (Bu-c(1) + 1)
   if wlen > len-voce move wlen to len-voce end-if

   compute wCol = Bu-c(i) + j - 1 end-compute
   if j = Bu-Hot(i)
      display Bu-Item(i) (j:1) at line Bu-r(i) col wcol
        with background-color  bco foreground-color Bu-fcoH highlight end-display
   else
      if fcoH = 'Y'
         display Bu-Item(i) (j:1) at line Bu-r(i) col wcol
            with background-color bco foreground-color fco highlight end-display
      else
         display Bu-Item(i) (j:1) at line Bu-r(i) col wcol
            with background-color bco foreground-color fco end-display
      end-if
   end-if

   go to loop1.
loop1-ex.
   if bu-Shadow = 'Y'
      perform ShadowButton thru ShadowButtonEx
   end-if
   continue.
DisplayButtonEx. exit.


ShadowButton.
*> the shadow is made of Ascii chars x'DF' & x'DC'
*> with same background color of existing background
   move j to salva-j  *> j = last button column
   move 0 to j.

*> loop to display single shadow char of button
loop2.
   add 1 to j
   if j >= salva-j
      compute wR = Bu-r(i) *> + 1
      compute wC = Bu-c(i) + j - 1
      *> half lower  char (last position at right of button)
      display X'DC' at line wR col wC
          with background-color Bu-bcoShadow foreground-color black end-display
      go ShadowButtonEx
   end-if

   compute wR = Bu-r(i) + 1
   compute wC = Bu-c(i) + j
   *> half upper char (under the button)
   display X'DF' at line wR col wC
        with background-color Bu-bcoShadow foreground-color black end-display
   go to loop2.
ShadowButtonEx. exit.

*> *******************************************************************************
*> CLICK EFFECT
*> redisplay the button 1 column right, without shedow and in black/white
*> *******************************************************************************
Click.
    Move Bu-Selected to i

    add 1 to Bu-c(i)
    move black to bco
    move white to fco
    Move "N"   to Bu-shadow
    perform DisplayButton thru DisplayButtonEx

   *> delete the char at left of the button
   compute wR = Bu-r(i)
   compute wC = Bu-c(i) - 1
   display ' ' at line wR col wC
        with background-color Bu-bcoShadow foreground-color black end-display

   *> count number of chars of the button
   move 1 to j
   perform until (Bu-Item(i) (j:1) = x'00') add 1 to j end-perform
   compute len-voce = j + 1
   *> delete shadow under the button
   compute wR = Bu-r(i) + 1
   compute wC = Bu-c(i) - 1
   move 1 to wLoop.
Click1.
    display ' ' at line wR col wC
        with background-color Bu-bcoShadow foreground-color black end-display
    add 1 to wLoop  wC
    if wLoop < len-voce go to click1 end-if
    *> small delay to show the click effect
    CALL "C$SLEEP" USING 1
   .
Click-Ex. exit.

End Program GC09BUTTONS.
