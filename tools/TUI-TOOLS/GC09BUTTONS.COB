       >> SOURCE FORMAT IS FREE
IDENTIFICATION DIVISION.
PROGRAM-ID. GC09BUTTONS is initial.
*> ***********************************************************************************
*> GnuCOBOL TT (TUI TOOLS) COLLECTION
*> Purpose:    DISPLAYS BUTTONS ON SCREEN
*> Tectonics:  cobc -m GC09BUTTONS.COB  (use GnuCOBOL 2.0 or greater)
*> Usage:      call GC09BUTTONS using BUTTONS-AREA
*> Parameters: look at GC09BUTTONS.cpy (use with copy Version: 1.0 2016.06.15)
*> Author:     Eugenio Di Lorenzo - Italia (DILO)
*> License:    Copyright 2016 E.Di Lorenzo - GNU Lesser General Public License, LGPL, 3.0 (or greater)
*> Version:    1.0 2016.06.15
*> Changelog:  1.0 first release.
*> ***********************************************************************************
ENVIRONMENT DIVISION.
CONFIGURATION SECTION.
SPECIAL-NAMES.
   CRT STATUS IS wCRT-STATUS.
DATA DIVISION.
Working-Storage Section.

01  .
    03  wCol         pic s9(02) value +0.
    03  wR           pic s9(02) value +0.
    03  wC           pic s9(02) value +0.
    03  w            pic s9(02) value +0.
    03  i            pic s9(02) value +1.
    03  j            pic s9(02) value +1.
    03  salva-j      pic s9(02) value +1.
    03  Btn-Number     pic s9(02) value +0.
    03  bco          PIC 9(02).
    03  fco          PIC 9(02).
    03  fcoH         PIC X(01).
    03  wDummy       PIC X(01) VALUE SPACE.
    03  wCRT-STATUS       PIC 9(04) VALUE 9999.
    03  wlen         pic 9(02) value 0.
    03  len-voce     pic 9(02) value 0.
01 wInt        BINARY-SHORT. *> SIGNED.

01 black   constant as 0.
01 blue    constant as 1.
01 green   constant as 2.
01 cyan    constant as 3.
01 red     constant as 4.
01 magenta constant as 5.
01 yellow  constant as 6.  *> or Brown
01 white   constant as 7.

*> Values that may be returned in CRT STATUS (or COB-CRT-STATUS)
78  K-ENTER       VALUE 0000.
78  K-UP          VALUE 2003.
78  K-DOWN        VALUE 2004.
78  K-LEFT        VALUE 2009.
78  K-RIGHT       VALUE 2010.
78  K-ESC         VALUE 2005.
78  K-TAB         VALUE 2007.
78  K-BACKTAB     VALUE 2008.
78  K-PAGEUP      VALUE 2001.
78  K-PAGEDOWN    VALUE 2002.
78  K-ESCAPE      VALUE 2005.

copy 'GC01BOX.CPY'.

LINKAGE SECTION.
copy 'GC09BUTTONS.CPY'.
*> ***********************************************************************************
*>           P R O C E D U R E   D I V I S I O N
*> ***********************************************************************************
PROCEDURE DIVISION using Buttons-Area.
*> sets in order to detect the PgUp, PgDn, PrtSc(screen print), Esc keys,
set environment 'COB_SCREEN_EXCEPTIONS' TO 'Y'.
set environment 'COB_SCREEN_ESC'        TO 'Y'.


   move 1 to i, j, w, Btn-Number.
*> ***********************************************************************************
*> display BUTTONS
*> ***********************************************************************************
Main.
   *> to count how many buttons
   if Bu-ele(i) = low-value
      compute Btn-Number = i - 1
      go to Main-Ex end-if

   if Bu-Act(i) = '1'          *> set color of selected button
      move i       to Bu-Selected
      Move Bu-bcoS to bco
      move Bu-fcoS to fco
   else                        *> set color of normal button
      Move Bu-bcoN to bco
      move Bu-fcoN to fco
   end-if

   perform Display-Button thru Display-Button-ex
   add  1 to i
   go to Main. *> go to display next Button
Main-Ex. exit.

*> ***********************************************************************************
*> WAIT FOR USER INPUT
*> ***********************************************************************************
loop-user-input.
   *> hide the cursor
   move 0 to wInt
   call static "curs_set" using by value wInt end-call

   accept wDummy at 2580
          with auto background-color red foreground-color white end-accept

   EVALUATE TRUE

   when wCRT-STATUS = K-RIGHT
     or wCRT-STATUS = K-DOWN
     or wCRT-STATUS = K-TAB
     or wCRT-STATUS = K-PAGEDOWN
      move Bu-Selected to i
      move space    to Bu-Act(Bu-Selected)
      *> display as normal Button
      Move Bu-bcoN to bco
      Move Bu-fcoN to fco
      Move Bu-fcoNH to fcoH
      perform Display-Button thru Display-Button-ex
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
      perform Display-Button thru Display-Button-ex

   when wCRT-STATUS = K-LEFT
     or wCRT-STATUS = K-UP
     or wCRT-STATUS = K-BACKTAB
     or wCRT-STATUS = K-PAGEUP
      move Bu-Selected to i
      move space            to Bu-Act(Bu-Selected)
      *> display as normal Button
      Move Bu-bcoN to bco
      Move Bu-fcoN to fco
      Move Bu-fcoNH to fcoH

      perform Display-Button thru Display-Button-ex
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
      perform Display-Button thru Display-Button-ex

   END-EVALUATE

   IF wCRT-STATUS = K-ENTER
      move K-Enter  to Bu-Key
      if Bu-click = 'Y' perform Click thru Click-Ex end-if
      go END-PROGRAM end-if
   IF wCRT-STATUS = K-ESCAPE move K-ESCAPE to Bu-Key go END-PROGRAM end-if

   go to loop-user-input
   .
END-PROGRAM.
   Goback.

*> ***********************************************************************************
*> DISPLAY A BUTTON
*> ***********************************************************************************
Display-Button.

   If Bu-Arrow = '1' or '2'
     perform varying j from 1 by 1 until Bu-Item(i) (j:1) = x'00' end-perform
   End-if
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

   *> save max length of Button items. useful for drawing a box around the menu
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
    perform Shadow-Button thru Shadow-Button-ex end-if
   .
Display-Button-EX. exit.


Shadow-Button.
*> Shadow is made of Ascci chars DF & DC
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

Click.
   *> not yet implemented
   *> erase the button
   *> redisplay the button 1 column left, without shedow and in black/white
   go to Click-Ex

   *> Move Bu-Selected to i

    *> move 'N' to Box-style
    *> move white    to Box-bco
    *> set Box-fco to white
    *> move Bu-r(i) to Box-r1
    *> move Bu-c(i) to Box-c1
    *> compute Box-r2  =  Bu-r(i) + 1
    *> compute Box-c2  =  Bu-c(i) + len-voce
    *> call 'GC01BOX' using BOX-AREA

   *> add 1 to Bu-c(i)
   *> Move "N" to Bu-Shadow
   *> move white to Bu-FcoS Bu-FcoN
   *> move black to Bu-BcoS Bu-BcoN
   *> perform Display-Button thru Display-Button-Ex.
   *> accept wDummy at 025080 with AUTO TIMEOUT 1 end-accept
   .
Click-Ex. exit.

End Program GC09BUTTONS.

