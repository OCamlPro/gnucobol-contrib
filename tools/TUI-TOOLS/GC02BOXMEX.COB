       >>SOURCE FORMAT IS FREE
ID DIVISION.
PROGRAM-ID. GC02BOXMEX is initial.
*> ***********************************************************************************
*> GnuCOBOL TT (TUI TOOLS) COLLECTION
*> Purpose:    DISPLAY A MESSAGE IN A BOX ON SCREEN WITH OPTIONS AND EFFECTS
*> Tectonics:  cobc -m GC02BOXMEX.COB  (use GnuCOBOL 2.0 or greater)
*> Usage:      call GC02BOXMEX using BOXMEX-AREA
*> Parameters: look at GC02BOXMEX.CPY (use with copy Version: 1.1)
*> Author:     Eugenio Di Lorenzo - Italia (DILO)
*> License:    Copyright 2016 E.Di Lorenzo - GNU Lesser General Public License, LGPL, 3.0 (or greater)
*> Version:    1.3 2018.06.30
*> Changelog:  1.0 first release.
*>             1.1 call to GC09BUTTONS deleted.
*>                 inserted code to  Display a single button
*>                 added possibility to have a click effect on the single button
*>                 added: save/restore screen option and to use cursor key to move boxmex on screen
*>                 added possibility to not displsy the single "OK" button (useful to display
*>                 message, return immediately to the caller that will call GC09BUTTONS
*>                 to have a message and next more buttons to be selected.
*>             1.2 changed Bu-Hot from 9(01) to 9(02)
*>             1.3 added DELETE TMP file at exit
*> ***********************************************************************************
DATA DIVISION.
WORKING-STORAGE SECTION.
01 black   constant as 0.
01 blue    constant as 1.
01 green   constant as 2.
01 cyan    constant as 3.
01 red     constant as 4.
01 magenta constant as 5.
01 yellow  constant as 6.  *> or Brown
01 white   constant as 7.
01 wInt        BINARY-SHORT. *>  SIGNED.
01  wLoop        pic  9(04) value  0.
01  i       pic 999.
01  j       pic 999.
01  salva-j pic 9(02) value 1.
01  wR   pic 999 value zero.
01  wC   pic 999 value zero.
01  wlen         pic 9(02) value 0.
01  wCol         pic 9(02) value 0.
01  len-voce     pic 9(02) value 0.
01  fcoH         PIC X(01).
01  bco          PIC 9(02).
01  fco          PIC 9(02).
01  wTime.
   03 wTimehh         pic  9(2).
   03 wTimemm         pic  9(2).
   03 wTimess         pic  9(2).
   03 wTimecc         pic  9(2).

*> SAVE/RESTORE SCREEN VARIABLES
01 wScreenName        PIC X(256).
01 wiScrOk            BINARY-LONG.
01  wVisibilityNew   BINARY-SHORT .
01  wVisibilityOld   BINARY-SHORT .

*> ***********************************************************************************
*>  SAME PARAMETERS OF GC09BUTTONS - call to GC09BUTTONS has been deleted,
*>  the code to diaplay on ebutton has been inserted in this program
*> ***********************************************************************************
01 Buttons-Area.
*> ***********************************************************************************
*>
*> PARAMETER DESCRIPTION
*> --------- -------------------------------------------------------------------------
*> Bu-Act    1= this item is displayed as the one Active (tobe Selected)
*>           only one of items can have '1' . it will be highlighted
*>           at first display of the menu. when you exit from the menu
*>           the active item will have '1' other items will have blank.
*> Bu-r      row & col where the button starts on screen
*> Bu-c      first row & col are 01, 01, last are 25,80 (row 25 col 80)
*>           buttons can be displayed in every position, also sparse.
*>           buttons can be also all overlapped (you will have a list-box)
*>
*> Bu-Item   charatcters string to be displayed on Button (max 80 chars).
*>           It has to be in ASCIIZ format (must have x'00'(low-value) as last byte
*> Bu-Hot    number of char to be used as hot key .
*>           ex. if item is "Exit" and this field is 2, the typing X is like activate the item
*> Bu-Shadow Y= draw a shadow around buttons  Default = Y
*> Bu-Arrow  If the selected button displayed in "selected" color,
*>           has also "arrows" before and after the button description
*>           1= ex.[> EXIT <] at border of button ;
*>           2= ex. [ > EXIT < ] at 2nd and penultimate position
*>           0 = (or other character) = no arrows;
*> Bu-Arrow-Char1/2 Single chars to make active button more visible
*> Bu-click  Y= when hit enter on a button you will have a "click effect"
*>           move button 1 char to right, black/white color , no shadow
*> Bu-beep   Y= when hit enter on button sound a beep
*> Bu bco-shadow set it to the same back color of the underlying background
*>
*> Bu-selected Returns to caller the number of sel.button by the user 01, 02, 03, ..
*> Bu-Key    key code pressed by user: 0000 = Enter, 2005 = Escape
*>           Caller pgm will know if user selected a button with enter
*>           or has pressed Escape key to exit whitout selection
*> *************************************************************
     03 Bu-Tab  value low-value.
        04 Bu-Ele occurs 25.
           05 Bu-Act          pic x(01).
           05 Bu-Hot          pic 9(02).
           05 Bu-r            pic 9(03).
           05 Bu-c            pic 9(03).
           05 Bu-Item         pic x(81).
     03 Bu-Parameters.
        05 Bu-Shadow             pic x(01) value 'Y'.
        05 Bu-Arrow              pic x(01) value '2'.
        05 Bu-Arrow-Chars.
           07 Bu-Arrow-Char1     pic x(01) value '>'.
           07 Bu-Arrow-Char2     pic x(01) value '<'.
        05 Bu-Click              pic x(01) value 'N'.
        05 Bu-Beep               pic x(01) value 'N'.
        *> colors for Normal button (non active)
        05 Bu-bcoN           pic 9(01) value green.  *> default backcolor for "normal" button
        05 Bu-fcoN           pic 9(01) value black.  *> default forecolor for "normal" button
        05 Bu-fcoNH          pic X(01) Value 'N'.    *> default foreground Normal in Highlight ?
        *> colors for active (to be selected) button
        05 Bu-bcoS           pic 9(01) value green.  *> default backcolor for "active" button
        05 Bu-fcoS           pic 9(01) value white.  *> default forecolor for "active" button
        05 Bu-fcoSH          pic X(01) Value 'Y'.    *> default forecolor of active in Highlight ?
        *> colors for hot key char of a button
        05 Bu-bcoH           pic 9(01) value white.  *> default backcolor for "hot key" char
        05 Bu-fcoH           pic 9(01) value red.    *> defalut forecolor for "hot key" char
        05 Bu-fcoHH          pic X(01) Value 'Y'.    *> default foreground hotkey in Highlight ?
        *> back color of shadow background (it has tobe settled to the same of box background)
        05 Bu-bcoShadow      pic 9(01) value white.  *> default backcolor for "shadow" of buttons
     *> *************************************************************
     *> RETUNRS TO CALLER
     *> *************************************************************
     03 Bu-Selected       pic 9(02).
     03 Bu-Key            pic 9(04).

copy 'GC01BOX.CPY'.
COPY 'GC98KEYCODE.CPY'.

LINKAGE SECTION.
copy 'GC02BOXMEX.CPY'.

*> ***********************************************************************************
*>           P R O C E D U R E   D I V I S I O N
*> ***********************************************************************************
PROCEDURE DIVISION using Boxmex-Area.
*> sets in order to detect the PgUp, PgDn, PrtSc(screen print), Esc keys,
set environment 'COB_SCREEN_EXCEPTIONS' TO 'Y'.
set environment 'COB_SCREEN_ESC'        TO 'Y'.

if Bxm-savescr = 'Y' perform ScreenSave thru ScreenSaveEx end-if.

LoopMain.
    *> Display the BOX around the message
    initialize Box-area ALL TO VALUE
    move Bxm-rc     to Box-rc.
    move Bxm-bco    to Box-bco Bu-bcoShadow
    move Bxm-fco    to Box-fco
    move Bxm-fcoH   to Box-fcoH
    move Bxm-style  to Box-Style
    move Bxm-custom to Box-custom
    move 'Y'        to Box-fill
    move Bxm-shadow to Box-Shadow
    move Bxm-3D     to Box-3D
    move Bxm-add1c  to Box-add1c
    move Bxm-tit    to Box-tit
    move Bxm-titBco to Box-titBco
    move Bxm-titFco to Box-titFco
    move Bxm-titFcoH to Box-titFcoH
    move Bxm-titDes  to Box-titDes
    call GC01BOX using BOX-AREA.

    *> ***********************************************************************************
    *> LOOP TO DISPLAY MESSAGE ROWS
    *> ***********************************************************************************
    if Bxm-tabmex = low-value go DisplayMessageEx end-if

    perform varying i from 1 by 1 until bxm-mex(i) = low-value or i > 20
         *> chars loop
          compute wR = Bxm-r1 + i
          *> max 78 cols
          perform varying j from 1 by 1 until Bxm-mex(i) (j:1) = low-value or j > length of Bxm-mex
                compute wC = Bxm-c1 + j
                if Bxm-fcoMH = 'Y'
                   display Bxm-mex(i) (j:1) at line wR col wC
                           with background-color Bxm-bcoM foreground-color Bxm-fcoM highlight end-display
                else
                   display Bxm-mex(i) (j:1) at line wR col wC
                           with background-color Bxm-bcoM foreground-color Bxm-fcoM end-display
                end-if
          end-perform
    end-perform.

DisplayMessageEx.


*> ***********************************************************************************
*> IF REQUESTED DISPLAY AN OK BUTTON AT -2 ROWS from LOWER BOX border
*> ***********************************************************************************
if Bxm-OkButton  = 'Y'
   initialize Buttons-area ALL TO VALUE
   move low-value to Bu-tab
   move 1 to i
   move i       to Bu-Selected
   Move Bu-bcoS to bco
   move Bu-fcoS to fco
   *> (back of the button has to be the same than the back of the box)
   move Bxm-bco to Bu-bcoShadow
   move '0'    to Bu-Arrow
   move '14000000   OK   ' & x'00' to Bu-Ele(01)
   compute Bu-r(1)  = Bxm-r2 - 2
   compute Bu-c(1)  = Bxm-c1 + ((Bxm-c2 - Bxm-c1) / 2 ) - 4
   perform Display-Button thru Display-ButtonEx
end-if.


LoopUserInput.
    if Bxm-wait = 'Y'
      *> after dispalyed the message wait for user key press
       call static "getch" returning Key-Pressed end-call
    else
       *> after dispalyed the message return to caller
       go to EndProgram
    end-if

    *> test if the user has pressed a cursor KEY
    if Bxm-savescr = 'Y'
       EVALUATE TRUE
           when Key-Pressed = Key-CursRight
                if Bxm-c2 <= 79
                   add 1 to Bxm-c1 Bxm-c2
                   perform ScreenRestore thru ScreenRestoreEx
                   go to LoopMain
                end-if
           when Key-Pressed = Key-CursDn
                if Bxm-r2 <= 24
                   add 1 to Bxm-r1 Bxm-r2
                   perform ScreenRestore thru ScreenRestoreEx
                   go to LoopMain
                end-if
           when Key-Pressed = Key-CursLeft
                if Bxm-c1 >= 2
                   subtract 1 from Bxm-c1 Bxm-c2
                   perform ScreenRestore thru ScreenRestoreEx
                   go to LoopMain
                end-if
           when Key-Pressed = Key-CursUp
                if Bxm-r1 >= 2
                   subtract 1 from Bxm-r1 Bxm-r2
                   perform ScreenRestore thru ScreenRestoreEx
                   go to LoopMain
                end-if
       END-EVALUATE
    end-if

   *> test if the user has pressed Enter or Escape
   IF Key-Pressed = Key-Enter or Key-Pressed = Key-Escape
      if Bxm-click   = 'Y' perform Click         thru Click-Ex        end-if
      if Bxm-savescr = 'Y' perform ScreenRestore thru ScreenRestoreEx end-if
      go to EndProgram
   end-if

   go to LoopUserInput.


*> ***********************************************************************************
EndProgram.
*> ***********************************************************************************
    if Bxm-savescr = 'Y' CALL 'CBL_DELETE_FILE' USING wScreenName end-if.
    GOBACK.


Display-Button.
*> ***********************************************************************************
*> DISPLAY AN OK BUTTON AT -2 ROWS from LOWER BOX border
*> ***********************************************************************************

*> following statements have been copied from GC09BUTTONS.COB (call to GC09BUTTONS has been deleted)
*> this program can diasaplay a single button and controls if have to wait for a user key or not.
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
   if bu-Shadow = 'Y' perform Shadow-Button thru Shadow-Button-ex end-if.
Display-ButtonEx. exit.


Shadow-Button.
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
      go Shadow-Button-ex
   end-if

   compute wR = Bu-r(i) + 1
   compute wC = Bu-c(i) + j
   *> half upper char (under the button)
   display X'DF' at line wR col wC
        with background-color Bu-bcoShadow foreground-color black end-display
   go to loop2.
Shadow-Button-EX. exit.

*> *******************************************************************************
*> CLICK EFFECT
*> redisplay the button 1 column right, without shedow and in black/white
*> *******************************************************************************
Click.
    *> if Ok Button not = Y , click effect is not considered
    if Bxm-OkButton not = 'Y' go to Click-ex end-if
    Move 1 to i
    add  1 to Bu-c(i)
    move black to bco
    move white to fco
    Move "N"   to Bu-shadow
    perform Display-Button thru Display-ButtonEx

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
    continue.
Click-Ex. exit.

ScreenSave.
   accept wTime from time
   string 'GC02BOXMEX' wTime '.TMP' x'00' into wScreenName
   call static 'scr_dump' using by reference wScreenName returning wiScrOk end-call.
ScreenSaveEx. Exit.

ScreenRestore.
   call static 'scr_restore' using by reference wScreenName returning wiScrOk end-call.
   CALL 'CBL_DELETE_FILE' USING wScreenName.
ScreenRestoreEx. Exit.

End Program GC02BOXMEX.
