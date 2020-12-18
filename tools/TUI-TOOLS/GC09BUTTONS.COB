              >> SOURCE FORMAT IS FREE
       REPLACE ==:BCOL:== BY ==with BACKGROUND-COLOR==
               ==:FCOL:== BY      ==FOREGROUND-COLOR==.
IDENTIFICATION DIVISION.
PROGRAM-ID. GC09BUTTONS is initial.
*> ***********************************************************************************
*> GnuCOBOL TT (TUI TOOLS) AND UTILITIES COLLECTION
*> Purpose:    DISPLAYS BUTTONS ON SCREEN AD WAIT FOR A USER CHOICE (WITH KEYBOARD OR MOUSE)
*> Tectonics:  cobc -m GC09BUTTONS.COB -lpdcurses (compile with GnuCOBOL 3.1 or greater)
*> Usage:      call GC09BUTTONS using Buttons-Area
*> Parameters: look at GC09BUTTONS.CPY
*> Author:     Eugenio Di Lorenzo - Italia (DILO) - eugenio.dilo@gmail.com
*> License:    Copyright 2020 E.Di Lorenzo - GNU Lesser General Public License LGPL 3.0
*> Changelog:  1.0 first release.
*>             1.1 changed from ACCEPT a DUMMY field to "call getch"
*>             1.2 added the "click effect" and beep on request
*>             1.3 some estethic changes
*>             1.4 added hot key management.
*>             1.5 Bu-Hot from 9(01) to 9(02)
*>             2.0 reversed from "call getch" to ACCEPT a DUMMY field
*>                 mouse management is added
*>                 left click on a BUTTON to make it "active" similar to cursor keys;
*>                 double left-click similar to Enter ( select a Button)
*>                 right click or double-right-click is similar to ESCAPE
*> ***********************************************************************************
ENVIRONMENT DIVISION.
CONFIGURATION SECTION.
SPECIAL-NAMES.
    CRT STATUS IS wCRT-STATUS.    *> Return Code from Accept (ex.PF Keys, Mouse Keys)
    CURSOR     IS wCursorRowCol.  *> Cursor Position

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
    03  k            pic  9(02) value  1.
    03  Item-Len     pic  9(02) value  0.
    03  Item-MaxLen  pic  9(02) value  0.
    03  salva-j      pic s9(02) value +1.
    03  Btn-Number   pic s9(02) value +0. *> count how many button items
    03  bco          PIC 9(02).
    03  fco          PIC 9(02).
    03  fcoH         PIC X(01).
    03  wDummy       PIC X(01) VALUE SPACE.
    03  wPrompt      PIC X(01) VALUE SPACE.
    03  wString      pic x(40) VALUE SPACE.
    03  wlen         pic 9(02) value 0.
    03  len-voce     pic 9(02) value 0.

01  wVisibilityNew   BINARY-SHORT .
01  wVisibilityOld   BINARY-SHORT .

01 black   constant as 0.
01 blue    constant as 1.
01 green   constant as 2.
01 cyan    constant as 3.
01 red     constant as 4.
01 magenta constant as 5.
01 yellow  constant as 6.  *> or Brown
01 white   constant as 7.

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
01  COB-MOUSE-FLAGS         PIC 9(04).

01  wCRT-STATUS         PIC 9(04) VALUE 9999.

01  wCursorRowCol       PIC 9(06) value 0000.
01  redefines wCursorRowCol .
    05 wCursorRow       Pic 9(03).
    05 wCursorCol       Pic 9(03).

01 wBu-ItemLenTab    Value zero.
   05 wBu-ItemLen     occurs 25 pic 9(03). *> button item length (char number before X"00")
   05 wBu-ItemCol-End occurs 25 pic 9(03). *> end column of the button

copy 'GC97KEYCODEGC.CPY'  suppress.

LINKAGE SECTION.
copy 'GC09BUTTONS.CPY'.

*> ***********************************************************************************
*>
*>                       P R O C E D U R E   D I V I S I O N
*>
*> ***********************************************************************************
PROCEDURE DIVISION using Buttons-Area.
  perform InitialSettings thru InitialSettingsEx.
  move 1 to i, j, w, Btn-Number.

*> ***********************************************************************************
*> Loop to display ALL BUTTONS
*> ***********************************************************************************
Main.
   *> to count how many buttons
   if Bu-ele(i) = low-value
      compute Btn-Number = i - 1
      go to MainEx
   end-if

   if Bu-Act(i) = '1'  *> set color of selected button
      move i        to Bu-Selected
      Move Bu-bcoS  to bco move Bu-fcoS  to fco move Bu-fcoSH to fcoH
   else                *> set color of non selected buttons
      Move Bu-bcoN  to bco move Bu-fcoN  to fco move Bu-fcoNH to fcoH
   end-if

   perform DisplayButton thru DisplayButtonEx
   add  1 to i

   *> go to display next Button
   go to Main.

MainEx.
  perform HideCursor thru HideCursorEx
  continue.

*> ***********************************************************************************
*> after displayed all buttons WAIT FOR USER INPUT
*> ***********************************************************************************
Accept-a-Key.
 *> accept of a 1 byte dummy field.
 *> the dummy field is at cursor position of the 1st byte of the first Button
 *> it has same back end fore color of 1st Button so it is invisible
 *> the "with Auto" option is useful to detect if cursor up/down/left/right is pressed
 move Bu-Item(1) (1:1) to wPrompt
 move space to wDummy

 if Bu-Selected = 1
    accept wDummy at line Bu-r(1) col Bu-c(1)
           *> with auto no-echo size 0 :BCOL: Bu-bcoS :FCOL: Bu-fcoS end-accept
           with auto-skip prompt character is wPrompt :BCOL: Bu-bcoS :FCOL: Bu-fcoS highlight end-accept
 else
    accept wDummy at line Bu-r(1) col Bu-c(1)
           *> with auto no-echo size 0 :BCOL: Bu-bcoN :FCOL: Bu-fcoN end-accept
           with auto-skip prompt character is wPrompt :BCOL: Bu-bcoN :FCOL: Bu-fcoN end-accept
 end-if

*> <enter> or <escape> return to caller Bu-Selected
*> if pressed cursor down or right -> activate next Button
*> if pressed cursor up   or left  <- activate previous Button
*> move space to Bu-Act of the Button
*> move '1' to Bu-Act of next or previous Button; other keys have no effect
*> *************************************************************************
*> ENTER = A BUTTON IS SELECTED
*> *************************************************************************
*> detect Enter or ESCAPE key only if user has not typed a letter or a digit
*> if user has typed a letter or a digit then WDummy is just une char and has the "AUTO" attribute
*> then the wCRT-STATUS is = 00000 (K-ENTER) !
If wDummy = space
   IF wCRT-STATUS = K-ENTER
      move wCRT-STATUS  to Bu-Key
      if Bu-beep  = 'Y'  CALL X'E5'                  end-if
      if Bu-click = 'Y'  perform Click thru ClickEx  end-if
      go END-Program
   END-IF
   *> Escape or Mouse Right Button = exit
   IF wCRT-STATUS = K-ESCAPE or wCRT-STATUS = K-RIGHT-PRESSED or wCRT-STATUS = K-RIGHT-DBL-CLICK
      move wCRT-STATUS to Bu-Key
      go End-Program
   end-if
end-if

*> *************************************************************************
*> EVALUATE THE USER ACTION (A KEY OR A MOUSE KEY WASS PRESSED)
*> *************************************************************************
   EVALUATE TRUE

     when wCRT-STATUS = K-RIGHT   *> Cursor Key right or down
       or wCRT-STATUS = K-DOWN
       or wCRT-STATUS = K-TAB
       or wCRT-STATUS = K-PAGEDOWN
       *> or wCRT-STATUS = barra spaziatrice

          move Bu-Selected to i
          move space       to Bu-Act(Bu-Selected)
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

     when wCRT-STATUS = K-LEFT  *> Cursor Key left or Up
       or wCRT-STATUS = K-UP
       or wCRT-STATUS = K-BACKTAB
       or wCRT-STATUS = K-PAGEUP

          move Bu-Selected to i
          move space       to Bu-Act(Bu-Selected)
          *> display as normal Button
          Move Bu-bcoN to bco
          Move Bu-fcoN to fco
          Move Bu-fcoNH to fcoH

          perform DisplayButton thru DisplayButtonEx
          if Bu-Selected = 1
             move Btn-Number to Bu-Selected i
          else
             subtract 1    from Bu-Selected i
          end-if
          move '1' to Bu-Act(Bu-Selected)
          *> display as selected Button
          Move Bu-bcoS to bco
          Move Bu-fcoS to fco
          Move Bu-fcoSH to fcoH
          perform DisplayButton thru DisplayButtonEx

      *> User clicked a Left Mouse Key: check if mouse position was on a Button
      when (wCRT-STATUS = K-LEFT-PRESSED or wCRT-STATUS = K-LEFT-DBL-CLICK)
           perform varying k from 1 by 1 until k > Btn-number
             if wCursorRow  = Bu-r(k)
                if ( wCursorCol >= Bu-c(k) and  wCursorCol <= wBu-ItemCol-End(k) )
                  *> the mouse has been clicked on a Button
                  move wCRT-STATUS  to Bu-Key
                  *> change display of active Button to display as normal Button
                  move Bu-Selected to i
                  move space       to Bu-Act(Bu-Selected)
                  Move Bu-bcoN     to bco
                  Move Bu-fcoN     to fco
                  Move Bu-fcoNH    to fcoH
                  perform DisplayButton thru DisplayButtonEx
                  *> change the clicked Button to display from normal Button to display as active
                  move k        to Bu-Selected i
                  move '1'      to Bu-Act(Bu-Selected)
                  Move Bu-bcoS  to bco
                  Move Bu-fcoS  to fco
                  Move Bu-fcoSH to fcoH
                  perform DisplayButton thru DisplayButtonEx

                  if wCRT-STATUS = K-LEFT-DBL-CLICK
                    *> if doubleclik, have a small delay to show the click effect
                    *> continue after 0.5 seconds
                    *> Windows systems will only be able to sleep at a millisecond granularity
                    call "CBL_GC_NANOSLEEP" USING 500000000 end-call
                    move K-ENTER  to Bu-Key
                    if Bu-beep  = 'Y' CALL X'E5'                 end-if
                    if Bu-click = 'Y' perform Click thru ClickEx end-if
                    go END-Program
                  end-if

                end-if
             end-if
           end-perform

    *> *****************************************************************************************
    *> IF USER HAS TYPED A LETTER (lower o upper case) - SEARCH IF IT IS A HOT KEY
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
        perform varying k from 1 by 1 until k > Btn-Number
                *> move the Hotkey to wChar
                if Bu-Hot(k) not = zero move Bu-Item(k) (Bu-Hot(k):1) to wChar end-if
                *> change wChar (if it is an uppercase Hotkey) to lowercase
                inspect wChar converting 'ABCDEFGHIJKLMNOPQRSTUVWXYZ' to 'abcdefghijklmnopqrstuvwxyz'

                if wChar = wChars-Ele(wChars-Idx)
                    *> the letter typed by the user is a valid hotkey !
                    *> change display of active Button to display as normal Button
                    move Bu-Selected to i
                    move space       to Bu-Act(Bu-Selected)
                    Move Bu-bcoN  to bco
                    Move Bu-fcoN  to fco
                    Move Bu-fcoNH to fcoH
                    perform DisplayButton thru DisplayButtonEx
                   *> change the Button with the hotkey to display from normal to display as active
                    move k to Bu-Selected i
                    move '1'   to Bu-Act(Bu-Selected)
                    Move Bu-bcoS  to bco
                    Move Bu-fcoS  to fco
                    Move Bu-fcoSH to fcoH
                    perform DisplayButton thru DisplayButtonEx
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
        perform varying k from 1 by 1 until k > Btn-Number
                if Bu-Hot(k) not = zero move Bu-Item(k) (Bu-Hot(k):1) to wNum end-if
                if wNum = wNums-Ele(wNums-Idx)
                    *> the digit typed by the user is a valid hotkey !
                    *> change display of active Button to display as normal Button
                    move Bu-Selected to i
                    move space       to Bu-Act(Bu-Selected)
                    Move Bu-bcoN  to bco
                    Move Bu-fcoN  to fco
                    Move Bu-fcoNH to fcoH
                    perform DisplayButton thru DisplayButtonEx
                   *> change the Button with the hotkey to display from normal Button to display as active
                    move k to Bu-Selected i
                    move '1'   to Bu-Act(Bu-Selected)
                    Move Bu-bcoS  to bco
                    Move Bu-fcoS  to fco
                    Move Bu-fcoSH to fcoH
                    perform DisplayButton thru DisplayButtonEx
                end-if
        end-perform


   END-EVALUATE

   go to Accept-a-Key
   continue.

END-PROGRAM.
   perform ShowCursor thru ShowCursorEx
   Goback.
*> ***********************************************************************************
*>                              E N D   O F   P R O G R A M
*> ***********************************************************************************




*> ***********************************************************************************
*> DISPLAY A BUTTON
*> ***********************************************************************************
DisplayButton.
   if Bu-Arrow = '1' or '2'
     perform varying j from 1 by 1 until Bu-Item(i) (j:1) = x'00' continue end-perform
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

 *> store the legth of a Button, useful to detect if user has mouse clicked on it
 move zero to wBu-ItemLen(i)
 inspect Bu-Item(i) tallying wBu-ItemLen(i) FOR CHARACTERS before x"00"
 compute wBu-ItemCol-End(i) =  Bu-c(i) +  wBu-ItemLen(i) - 1
 continue.
loop1.
   *> loop to display single characters of a BUTTON
   add 1 to j
   if Bu-Item(i) (j:1) = low-value go loop1-ex end-if

   *> save max length of Button items
   compute wlen = (Bu-c(i) + j - 1) - (Bu-c(1) + 1)
   if wlen > len-voce move wlen to len-voce end-if

*> display single character of a BUTTON
   compute wCol = Bu-c(i) + j - 1 end-compute
   if j = Bu-Hot(i)
      display Bu-Item(i) (j:1) at line Bu-r(i) col wcol :BCOL:  bco :FCOL: Bu-fcoH highlight end-display
   else
      if fcoH = 'Y'
         display Bu-Item(i) (j:1) at line Bu-r(i) col wcol :BCOL: bco :FCOL: fco highlight end-display
      else
         display Bu-Item(i) (j:1) at line Bu-r(i) col wcol :BCOL: bco :FCOL: fco end-display
      end-if
   end-if

   go to loop1.
loop1-ex.
   if bu-Shadow = 'Y' perform ShadowButton thru ShadowButtonEx end-if
   continue.
DisplayButtonEx. exit.


*> *******************************************************************************
*> SHADOW EFFETCT
*> *******************************************************************************
ShadowButton.
*> the shadow is made of Ascii chars x'DF' & x'DC' with same background color of existing background
   move j to salva-j  *> j = last button column
   move 0 to j.
*> loop to display single shadow char of button
loop2.
   add 1 to j
   if j >= salva-j
      compute wR = Bu-r(i)                *> + 1
      compute wC = Bu-c(i) + j - 1
      *> half lower  char (last position at right of button)
      display X'DC' at line wR col wC :BCOL: Bu-bcoShadow :FCOL: black end-display
      go ShadowButtonEx
   end-if
   compute wR = Bu-r(i) + 1
   compute wC = Bu-c(i) + j
   *> half upper char (under the button)
   display X'DF' at line wR col wC :BCOL: Bu-bcoShadow :FCOL: black end-display
   go to loop2.
ShadowButtonEx. exit.

*> *******************************************************************************
*> CLICK EFFECT
*> redisplay the button 1 column right, without shadow and in black/white colors
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
   display ' ' at line wR col wC :BCOL: Bu-bcoShadow :FCOL: black end-display

   *> count number of chars of the button
   move 1 to j
   perform until (Bu-Item(i) (j:1) = x'00') add 1 to j end-perform
   compute len-voce = j + 1
   *> delete shadow under the button
   compute wR = Bu-r(i) + 1
   compute wC = Bu-c(i) - 1
   move 1 to wLoop.
Click1.
    display ' ' at line wR col wC :BCOL: Bu-bcoShadow :FCOL: black end-display
    add 1 to wLoop  wC
    if wLoop < len-voce go to click1 end-if
    *> small delay to show the click effect
    CALL "C$SLEEP" USING 1
    continue.
ClickEx. exit.

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

  *> perform hide-cursor thru hide-cursor-ex
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

End Program GC09BUTTONS.
