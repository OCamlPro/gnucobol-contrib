       >>SOURCE FORMAT IS FREE
ID DIVISION.
PROGRAM-ID. GC02BOXMEX is initial.
*> ***********************************************************************************
*> GnuCOBOL TT (TUI TOOLS) COLLECTION
*> Purpose:    DISPLAY A MESSAGE IN A BOX ON SCREEN WITH OPTIONS AND EFFECTS
*> Tectonics:  cobc -m GC02BOXMEX.COB  (use GnuCOBOL 2.0 or greater)
*> Usage:      call GC02BOXMEX using BOXMEX-AREA
*> Parameters: look at GC02BOXMEX.cpy (use with copy Version: 1.0 2016.06.15)
*> Author:     Eugenio Di Lorenzo - Italia (DILO)
*> License:    Copyright 2016 E.Di Lorenzo - GNU Lesser General Public License, LGPL, 3.0 (or greater)
*> Version:    1.0 2016.06.15
*> Changelog:  1.0 first release.
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
01  i    pic 999.
01  j    pic 999.
01  wR   pic 999 value zero.
01  wC   pic 999 value zero.

01  wVisibilityNew   BINARY-SHORT .
01  wVisibilityOld   BINARY-SHORT .

copy 'GC01BOX.CPY'.
copy 'GC09BUTTONS.CPY'.

LINKAGE SECTION.
copy 'GC02BOXMEX.CPY'.

*> ***********************************************************************************
*>           P R O C E D U R E   D I V I S I O N
*> ***********************************************************************************
PROCEDURE DIVISION using Boxmex-Area.
*> sets in order to detect the PgUp, PgDn, PrtSc(screen print), Esc keys,
set environment 'COB_SCREEN_EXCEPTIONS' TO 'Y'.
set environment 'COB_SCREEN_ESC'        TO 'Y'.


*> Display the BOX
initialize Box-area ALL TO VALUE
move Bxm-rc     to Box-rc.
move Bxm-bco    to Box-bco
move Bxm-fco    to Box-fco
move Bxm-fcoH   to Box-fcoH
move Bxm-style  to Box-Style
move Bxm-custom to Box-custom
*> move Bxm-fill   to Box-fill
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
perform varying i from 1 by 1
until bxm-mex(i) = low-value or i > 20
     *> chars loop
      compute wR = Bxm-r1 + i
      perform varying j from 1 by 1
      until Bxm-mex(i) (j:1) = low-value or j > length of Bxm-mex *> max 78 cols
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
*> DISPLAY A BUTTON AT -2 ROWS from LOWER BOX border
*> ***********************************************************************************
initialize Buttons-area ALL TO VALUE
move low-value to Bu-tab

*> (back of the button has to be the same than the back of the box )
move Bxm-bco to Bu-bcoShadow
move '0'   to Bu-Arrow
*> move '<>'  to Bu-Arrow-chars
move '14000000   OK   ' & x'00' to Bu-Ele(01)
compute Bu-r(1)  = Bxm-r2 - 2
compute Bu-c(1)  = Bxm-c1 + ((Bxm-c2 - Bxm-c1) / 2 ) - 4
*> call BUTTONS (it hide cursor, waits for a user input, reset cursor to its previous state)
call GC09BUTTONS using Buttons-Area

*> *> hide the cursor and save its previous state
*> *> (use always a display or an accept at .... before to have a call to 'initscr'
*> move 0 to wVisibilityNew
*> call static 'curs_set' using by value wVisibilityNew returning wVisibilityOld end-call
*> accept omitted
*> *> reset (show) the cursor to its previous state
*> move wVisibilityOld to wVisibilityNew
*> call static 'curs_set' using by value wVisibilityNew returning wVisibilityOld end-call

goback.

End Program GC02BOXMEX.
