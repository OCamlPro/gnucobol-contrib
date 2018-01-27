       >> SOURCE FORMAT IS FREE
ID DIVISION.
program-id. GC61CALC.
*> ***********************************************************************************
*> GnuCOBOL TT (TUI TOOLS) COLLECTION
*> Purpose:    POCKET CALCULATOR
*> Tectonics:  cobc -x GC61CALC.COB (use GnuCOBOL 2.2 or greater)
*> Usage:      call GC61CALC using Calc-Area
*> Parameters: look at GC61CALC.cpy  (use with copy Version: 1.0)
*> Author:     Eugenio Di Lorenzo - Italia (DILO)
*> License:    Copyright 2018 E.Di Lorenzo - GNU Lesser General Public License, LGPL, 3.0 (or greater)
*> Version:    1.0 2018.01.31
*> Changelog:  -
*> ***********************************************************************************

ENVIRONMENT DIVISION.
CONFIGURATION SECTION.

SPECIAL-NAMES.
   Currency Sign is '€'
   Decimal-Point is Comma.

REPOSITORY.
    FUNCTION ALL INTRINSIC.

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

01  wDummy     pic x(01) VALUE space.
01  wOper      pic x(3)  value space.

01 wlin1       pic 99 value 06.
01 wlin2       pic 99 value 07.
01 wlin3       pic 99 value 08.
01 wcol1       pic 99 value 10.
01 wcol2       pic 99 value 29.

01  wNum9-1      Pic 9(13) value zero.
01  wNum9-result Pic 9(13) value zero.
01  wNum9        Pic 9(13) value zero.
01  wNum         redefines wNum9.
    03 wNumEle   pic X occurs 13 indexed by wNum-idx.
01 wNumZ         PIC ----.---.---.--9.

01 wDisplayTab.
   03 wDisplayEl occurs 3.
      05 wDisplayEle PIC ----.---.---.--9.

01 wOperTab.
   03 wOperEl occurs 3.
      05 wOperEle PIC XXX.

COPY 'GC01BOX.CPY'.
COPY 'GC09BUTTONS.CPY'.
COPY 'GC98KEYCODE.CPY'.

LINKAGE SECTION.
COPY 'GC61CALC.CPY'.
*> **************************************************************
*>           P R O C E D U R E   D I V I S I O N
*> **************************************************************
PROCEDURE DIVISION using Calc-Area.
  *> sets in order to detect the PgUp, PgDn, PrtSc(screen print), Esc keys,
  set environment 'COB_SCREEN_EXCEPTIONS' TO 'Y'.
  set environment 'COB_SCREEN_ESC'        TO 'Y'.

StartCalc.
  *> *********************************************************************************
  *> FIRST DISPLAY CALCULATOR BOX AND ZERO DIGITS
  *> *********************************************************************************
  set  Box-bco  Box-fco to white
  move '004006' to Box-r1c1
  move '020035' to Box-r2c2
  move 'S'      to Box-style
  move 'N'      to Box-3D
  Move 'Y'      to Box-tit
  move blue     to Box-fco Box-titFco
  Move ' Pocket Calculator ' & x'00' to Box-titDes
  call GC01BOX using BOX-AREA.
  *> display wNumZ  at line wlin3 col wcol1 with  Background-Color black Foreground-Color green highlight
  display wDisplayEle(1) at line wlin1 col wcol1 with  Background-Color black Foreground-Color green highlight
  display wDisplayEle(2) at line wlin2 col wcol1 with  Background-Color black Foreground-Color green highlight
  display wDisplayEle(3) at line wlin3 col wcol1 with  Background-Color black Foreground-Color green highlight

  *> *********************************************************************************
  *> FIRST DISPLAY CALCULATOR BUTTONS
  *> *********************************************************************************
  initialize Buttons-area ALL TO VALUE
  move low-value to Bu-tab
  move '0'       to Bu-Arrow
  move 'Y'       to Bu-Click
  set Bu-bcoN to green.  *> backcolor for "normal" button
  set Bu-fcoN to black.  *> forecolor for "normal" button - not used just 1 char hotkey !
  set Bu-bcoS to red.    *> backcolor for "active" button
  set Bu-fcoS to yellow. *> forecolor for "active" button - not used just 1 char hotkey !
  set Bu-bcoH to white.  *> backcolor for "hot key" char
  set Bu-fcoH to white.  *> forecolor for "hot key" char
  perform SetCalcButtons thru SetCalcButtonsEx
  move '1'    to Bu-Act(1)
  continue.

DisplayCalcButtons.
  call GC09BUTTONS using BUTTONS-AREA

  if BU-Selected < 11
     *> typed a digit : 1,2,3,4,5,6,7,8,9,0
     if wNum = ZERO
        move Bu-Selected to wNum9
     else
         move wNum(2:12) to wNum(1:12)
         move Bu-Selected (2:1) to wNumEle (13)
     end-if
     move wNum9 to wNumZ wDisplayEle(3)
     *> display wNumZ  at line wlin3 col wcol1   with  Background-Color black Foreground-Color green highlight
     display wDisplayEle(3)  at line wlin3 col wcol1   with  Background-Color black Foreground-Color green highlight
  else
     *> typed an operator +, -, *, : , =
     move wDisplayEle(2) to wDisplayEle(1)
     move wNum9          to wNumZ wDisplayEle(2)

     *> display wNumZ  at line wlin2 col wcol1   with  Background-Color black Foreground-Color green highlight
     display wDisplayEle(1)  at line wlin1 col wcol1   with  Background-Color black Foreground-Color green highlight
     display wDisplayEle(2)  at line wlin2 col wcol1   with  Background-Color black Foreground-Color green highlight
     evaluate Bu-selected
        when = 11  move ' + ' to wOper move wNum9 to wNum9-1 perform DisplayNumber thru DisplayNumberEx
                                                             perform DisplayOper   thru DisplayOperEx
        when = 12  move ' - ' to wOper move wNum9 to wNum9-1 perform DisplayNumber thru DisplayNumberEx
                                                             perform DisplayOper   thru DisplayOperEx
        when = 13  move ' x ' to wOper move wNum9 to wNum9-1 perform DisplayNumber thru DisplayNumberEx
                                                             perform DisplayOper   thru DisplayOperEx
        when = 14  move ' : ' to wOper move wNum9 to wNum9-1 perform DisplayNumber thru DisplayNumberEx
                                                             perform DisplayOper   thru DisplayOperEx
        when = 15
                   *> ******************** DEBUG ******************************************
                   *> display 'Bu-selected = 15' at 0460  with  Background-Color black Foreground-Color green highlight end-display
                   *> display wOper              at 0560  with  Background-Color black Foreground-Color green highlight end-display
                   *> display wNum9-1            at 0660  with  Background-Color black Foreground-Color green highlight end-display
                   *> display wNum9              at 0760  with  Background-Color black Foreground-Color green highlight end-display
                   *> ******************** END-DEBUG **************************************
                   evaluate wOper
                        when ' + ' compute wNum9-result = wNum9-1 + Wnum9
                        when ' - ' compute wNum9-result = wNum9-1 - Wnum9
                        when ' x ' compute wNum9-result = wNum9-1 * Wnum9
                        when ' : ' compute wNum9-result = wNum9-1 / Wnum9
                   end-evaluate
                   move ' = ' to wOper
                   *> display wOper at line wlin2 col wcol2  with  Background-Color black Foreground-Color green highlight
                   move wOperEle(2) to WOperEle(1)
                   move wOper       to WOperEle(2)
                   display wOperEle(1) at line wlin1 col wcol2  with  Background-Color black Foreground-Color green highlight
                   display wOperEle(2) at line wlin2 col wcol2  with  Background-Color black Foreground-Color green highlight
                   move wNum9-result to wNumZ wDisplayEle(3)
                   *> display wNumZ at line wlin3 col wcol1 with  Background-Color black Foreground-Color green highlight
                   display wDisplayEle(3) at line wlin3 col wcol1 with  Background-Color black Foreground-Color green highlight
        when = 16  *> CANCEL
                   move wDisplayEle(2) to wDisplayEle(1)
                   move wDisplayEle(3) to wDisplayEle(2)
                   move zero to wDisplayEle(3)
                   move space to wOper
                   perform DisplayNumber thru DisplayNumberEx
                   perform DisplayOper   thru DisplayOperEx
     end-evaluate
  end-if

  move space to Bu-Act(1)
  move '1'   to Bu-Act(Bu-Selected)

  if   Bu-Key = Key-Escape go EndProgram end-if

  perform SetCalcButtons thru SetCalcButtonsEx
  move '1'   to Bu-Act(Bu-Selected)
  go            DisplayCalcButtons

  continue.

EndProgram.
  move wNum9-result to Cc-Result
  Goback.


*> *********************************************************************************
*>
*> *********************************************************************************
DisplayNumber.
     display wDisplayEle(1) at line wlin1 col wcol1 with  Background-Color black Foreground-Color green highlight
     display wDisplayEle(2) at line wlin2 col wcol1 with  Background-Color black Foreground-Color green highlight
     move zero  to wNum9
     move wNum9 to wNumZ wDisplayEle(3)
     display wDisplayEle(3) at line wlin3 col wcol1 with  Background-Color black Foreground-Color green highlight
     continue.

DisplayNumberEx. exit.

DisplayOper.
      move wOperEle(2) to WOperEle(1)
      move wOper       to WOperEle(2)
      display wOperEle(1) at line wlin1 col wcol2  with  Background-Color black Foreground-Color green highlight
      display wOperEle(2) at line wlin2 col wcol2  with  Background-Color black Foreground-Color green highlight
      continue.
DisplayOperEx. exit.

SetCalcButtons.
  move 'Y' to Bu-Shadow
  Move ' 02016010 1  '       & x'00' to Bu-Ele(01)
  Move ' 02016016 2  '       & x'00' to Bu-Ele(02)
  Move ' 02016022 3  '       & x'00' to Bu-Ele(03)
  Move ' 02014010 4  '       & x'00' to Bu-Ele(04)
  Move ' 02014016 5  '       & x'00' to Bu-Ele(05)
  Move ' 02014022 6  '       & x'00' to Bu-Ele(06)
  Move ' 02012010 7  '       & x'00' to Bu-Ele(07)
  Move ' 02012016 8  '       & x'00' to Bu-Ele(08)
  Move ' 02012022 9  '       & x'00' to Bu-Ele(09)
  Move ' 05018010    0     ' & x'00' to Bu-Ele(10)
  Move ' 00012029 + '        & x'00' to Bu-Ele(11)
  Move ' 00014029 - '        & x'00' to Bu-Ele(12)
  Move ' 00016029 x '        & x'00' to Bu-Ele(13)
  Move ' 00018029 : '        & x'00' to Bu-Ele(14)
  Move ' 00018022 =  '       & x'00' to Bu-Ele(15)
  Move ' 00010029 C '        & x'00' to Bu-Ele(16)
  continue.
SetCalcButtonsEx. exit.

End Program GC61CALC.
