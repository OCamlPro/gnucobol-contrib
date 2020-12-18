       >> SOURCE FORMAT IS FREE
IDENTIFICATION DIVISION.
PROGRAM-ID. GC03YESNO is initial.
*> ***********************************************************************************
*> GnuCOBOL TT (TUI TOOLS) COLLECTION
*> Purpose:    DISPLAY  YES & NO BUTTONS ON SCREEN
*> Tectonics:  cobc -m GC03YESNO.COB (use GnuCOBOL 2.0 or greater)
*> Usage:      call GC03YESNO using YESNO-AREA
*> Parameters: look at GC03YESNO.cpy (use with copy Version: 1.0 2016.06.15)
*> Author:     Eugenio Di Lorenzo - Italia (DILO) - eugenio.dilo@gmail.com
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

01 wInt        BINARY-SHORT . *> SIGNED.
01 wVisibilityNew  BINARY-SHORT . *> SIGNED.
01 wVisibilityOld  BINARY-SHORT . *> SIGNED.
01 wVisibilityNew9  pic 9(8).
01 wVisibilityOld9  pic 9(8).
01 bco-sel     PIC 9.
01 fco-sel     PIC 9.
01 bco-nonsel  PIC 9.
01 fco-nonsel  PIC 9.
01 wDummy      PIC X value space.
01  wButton    pic x(10).
01  j          pic s9(02) comp-5 value  +0.
01  x          pic s9(02) comp-5 value  +0.
01  result     usage binary-long.
01  wresult    pic S9(8).
01  wcol       PIC 9(03).
01  wlin       PIC 9(03).

COPY 'GC01BOX.CPY'.

LINKAGE SECTION.
COPY 'GC03YESNO.CPY'.

*> ***********************************************************************************
*>           P R O C E D U R E   D I V I S I O N
*> ***********************************************************************************
PROCEDURE DIVISION using YesNo-Area.
*> sets in order to detect the PgUp, PgDn, PrtSc(screen print), Esc keys,
set environment 'COB_SCREEN_EXCEPTIONS' TO 'Y'.
set environment 'COB_SCREEN_ESC'        TO 'Y'.

    *> BIG BOX
    move Yn-shadow to Box-shadow
    move 'I'      to Box-3D
    move 'Y'      to Box-add1c
    perform Big-Box thru Big-Box-ex
    perform Message1  thru Message1-ex
    *> box YES
    move 'N'      to Box-shadow
    move 'E'      to box-3D
    move 'N'      to Box-add1c
    perform Box-Yes thru Box-Yes-ex
    *> box NO
    move 'N'      to Box-shadow
    move 'E'      to box-3D
    move 'N'      to Box-add1c
    perform Box-No thru Box-No-ex.

    *> hide the cursor
    move 0 to wVisibilityNew
    *> move 9 to wVisibilityOld  *> to test if is changed after retuning from call
    call static "curs_set" using by value wVisibilityNew returning wVisibilityOld end-call
    move wVisibilityNew to wVisibilityNew9
    move wVisibilityOld to wVisibilityOld9

    *> display "wVisibilityOld: " wVisibilityOld9 " wVisibilityNew: " wVisibilityNew9
    *> accept omitted
    .
*> ***********************************************************************************
*> WAIT FOR USER INPUT
*> ***********************************************************************************
Loop-Key.

    call static "getch" returning result end-call
    move result to wresult.

    *> display "key pressed: "  at 2015 with background-color 01 foreground-color 07 end-display
    *> display     wresult      at 2030 with background-color 01 foreground-color 07 end-display

    *> check which key is pressed
    if wresult = 27 *> ESCAPE
    or wresult = 13 *> ENTER
      move wresult  to yn-Key go End-Program end-if

    *> cursor right o down or space or tab or pgup or pgdn
    if (wresult = 77 or wresult = 80 or wresult = 32 or wresult = 09 or 73 or 81)
      if yn-yesno = 'Y'
         move 'N' to yn-yesno
      else
         move 'Y' to yn-yesno
      end-if
    end-if
    *> cursor left or up
    if (wresult = 75 or wresult = 72)
       if yn-yesno = 'N'
          move 'Y' to yn-yesno
       else
          move 'N' to yn-yesno
       end-if
    end-if
    perform Box-Yes thru Box-Yes-ex     *> box YES
    perform Box-No  thru Box-No-ex      *> box NO

    go to Loop-Key
    .

End-Program.
   GOBACK.


*> ***********************************************************************************
*>
*> ***********************************************************************************
Big-Box.
    set box-bco to Yn-BcoNonSel
    set box-fco to Yn-FcoNonSel
    move yn-r1 to  box-r1
    move yn-c1 to  box-c1
    compute box-r2 = yn-r1 + 8
    compute box-c2 = yn-c1 + 37
    if yn-box = 'Y'
       move 'D' to box-style
    else
       move 'S' to box-style
    end-if
    CALL 'GC01BOX' USING BY CONTENT BOX-AREA
    .
Big-Box-EX. exit.

Message1.
   move 0 to j
   compute wlin = yn-r1 + 2 *> riga del cursore
   .
loopm. *> loop per display singoli caratteri della voce di menu
   if j >= 34 go Message1-ex end-if
   add 1 to j
   *> cursor column
   compute wcol = yn-c1 + 1 + j
   display Yn-mess (j:1) at line wlin col wcol
     with background-color Yn-BcoNonSel foreground-color Yn-FcoNonSel highlight end-display

   go to loopm
   .
Message1-EX. exit.

*> ************************************************************************************
*> YES BUTTON
*> ************************************************************************************
Box-Yes.
   if yn-yesno = 'Y'
      move 'D' to box-style
      set box-bco to Yn-BcoSel    *> Selected Button
      set box-fco to Yn-FcoSel
   else
      move 'S' to box-style
      set box-bco to Yn-BcoNonSel *> Non Selected Button
      set box-fco to Yn-FcoNonSel
   end-if
   compute box-r1 = yn-r1 + 4
   compute box-c1 = yn-c1 + 5
   compute box-r2 = yn-r1 + 6
   compute box-c2 = yn-c1 + 16
   CALL 'GC01BOX' USING BY CONTENT BOX-AREA

   Move '   YES    ' to wButton
   Move 5 to x              *> Button 1 position
   compute wlin = yn-r1 + 5 *> cursor row
   perform Display-Item thru Display-Item-ex
   .
Box-Yes-EX. exit.

*> ************************************************************************************
*> NO BUTTON
*> ************************************************************************************
Box-No.
   if yn-yesno = 'N'
      move 'D' to box-style
      set box-bco to Yn-BcoSel     *> Selected Button
      set box-fco to Yn-FcoSel
   else
      set box-bco to Yn-BcoNonSel  *> Non Selected Button
      set box-fco to Yn-FcoNonSel
      move 'S' to box-style
   end-if
   compute box-c1 = yn-c1 + 20
   compute box-c2 = yn-c1 + 31
   CALL 'GC01BOX' USING BY CONTENT BOX-AREA

   Move '    NO    ' to wButton
   Move 20 to x             *> Button 1 position
   compute wlin = yn-r1 + 5 *> cursore position
   perform Display-Item thru Display-Item-ex
   .
Box-No-EX. exit.

*> ***********************************************************************************
*> display chars of the button description
*> ***********************************************************************************
Display-Item.
   move 0 to j
   .
loop1.
   if j >= 10 go Display-Item-ex end-if
   add 1 to j
   compute wcol = yn-c1 + x + j
   display wButton (j:1) at line wlin col wcol
     with background-color box-bco foreground-color box-fco highlight end-display
   go to loop1
   .
Display-Item-EX. exit.

End Program GC03YESNO.
