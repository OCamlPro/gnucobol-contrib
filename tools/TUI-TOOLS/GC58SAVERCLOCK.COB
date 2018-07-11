       >> SOURCE FORMAT IS FREE
IDENTIFICATION DIVISION.
PROGRAM-ID. GC58SAVERCLOCK.
*> ***********************************************************************************
*> GnuCOBOL TT (TUI TOOLS) COLLECTION
*> Purpose:    SCREENSAVER DISPLAYING A MOVING CLOCK and optionally A SCROLLING STRING
*> Tectonics:  cobc -x GC58SAVERCLOCK.COB  (use GnuCOBOL 2.0 or greater)
*> Usage:      call GC58SAVERCLOCK using SAVER-AREA
*> Parameters: look at GC58SAVERCLOCK.cpy  (use with copy Version: 1.2)
*> Author:     Eugenio Di Lorenzo - Italia (DILO)
*> License:    Copyright 2016 E.Di Lorenzo - GNU LGPL, 3.0 (or greater)
*> Version:    1.1 2018.07.11
*> Changelog:  1.0 first release.
*>             1.1 SSChangeCol & SSChangeColT (change clock and scrolling string colors)
*> ***********************************************************************************
ENVIRONMENT DIVISION.
CONFIGURATION SECTION.
SPECIAL-NAMES.
   CRT STATUS IS wCRT-STATUS.
DATA DIVISION.
WORKING-STORAGE SECTION.
*> ***************************************************************
*> CLOCK NUMBERS
*> ***************************************************************
01   kNum.
   03 kNum-0 pic x(15) value X'C9CDCDBB20'  &
                             X'BA2020BA20'  &
                             X'C8CDCDBC20'.
   03 kNum-1 pic x(15) value X'2020BB2020'  &
                             X'2020BA2020'  &
                             X'2020CA2020'.
   03 kNum-2 pic x(15) value X'C9CDCDBB20'  &
                             X'C9CDCDBC20'  &
                             X'C8CDCDBC20'.
   03 kNum-3 pic x(15) value X'C9CDCDBB20'  &
                             X'20CDCDB920'  &
                             X'C8CDCDBC20'.
   03 kNum-4 pic x(15) value X'C92020BB20'  &
                             X'C8CDCDB920'  &
                             X'202020CA20'.
   03 kNum-5 pic x(15) value X'C9CDCDBB20'  &
                             X'C8CDCDBB20'  &
                             X'C8CDCDBC20'.
   03 kNum-6 pic x(15) value X'C9CDCDBB20'  &
                             X'CCCDCDBB20'  &
                             X'C8CDCDBC20'.
   03 kNum-7 pic x(15) value X'C9CDCDBB20'  &
                             X'2020CDB920'  &
                             X'202020CA20'.
   03 kNum-8 pic x(15) value X'C9CDCDBB20'  &
                             X'CCCDCDB920'  &
                             X'C8CDCDBC20'.
   03 kNum-9 pic x(15) value X'C9CDCDBB20'  &
                             X'C8CDCDB920'  &
                             X'C8CDCDBC20'.
01  redefines kNum.
   03 kEle1    occurs 10.
      05 kEle2 occurs 03 pic x(05).

01 black   constant as 0.
01 blue    constant as 1.
01 green   constant as 2.
01 cyan    constant as 3.
01 red     constant as 4.
01 magenta constant as 5.
01 yellow  constant as 6.  *> or Brown
01 white   constant as 7.
01 wCRT-STATUS  PIC  9(04) VALUE 9999.
*> Values returned in CRT STATUS (or COB-CRT-STATUS)
78  K-ENTER       VALUE 0000.
78  K-UP          VALUE 2003.
78  K-DOWN        VALUE 2004.
78  K-LEFT        VALUE 2009.
78  K-RIGHT       VALUE 2010.
78  K-ESCAPE      VALUE 2005.
78  K-TAB         VALUE 2007.
78  K-BACKTAB     VALUE 2008.
78  K-PAGEUP      VALUE 2001.
78  K-PAGEDOWN    VALUE 2002.
78  K-NO-FIELD    VALUE 8000.  *> NO DATA FROM ACCEPT (also 8001)


copy 'GC01BOX.CPY'.

01  wClockRow1       pic  x(36). *> row 1 of clock
01  wClockRow2       pic  x(36). *> row 2 of clock
01  wClockRow3       pic  x(36). *> row 3 of clock
01  wCount          pic 99 comp-5 value 1.
01  wCol             pic 99 comp-5.
01  wCol1            pic 99 comp-5.
01  wlin1            pic 99 comp-5.
01  wlin2            pic 99 comp-5.
01  wlin3            pic 99 comp-5.
01  FlipFlop       pic 9  value zero.
01  sw             pic 9  value zero.

01  i              pic 9(04) value zero.
01  wScr            pic x(81) value space. *> wScrollingString che scorre
01  wRow            pic x(80).

01  wTime.
   03 wTimehh         pic 9(02).
   03 wTimemm         pic 9(02).
   03 wTimess         pic 9(02).
   03 wTimecc         pic 9(02).
01  wTime9 redefines wTime pic 9(08).

01  TimeX.
   03 Timehh1         pic  9.
   03 Timehh2         pic  9.
   03 Timemm1         pic  9.
   03 Timemm2         pic  9.
   03 Timess1         pic  9.
   03 Timess2         pic  9.
   03 Timecc1         pic  9.
   03 Timecc2         pic  9.
01  Time9 redefines TimeX pic 9(08).

01  DeltaTime                 pic 9(08).
01  wInt        BINARY-SHORT. *>  SIGNED.
01  wDummy        pic x(01) VALUE ' '.


*> SAVE/RESTORE SCREEN VARIABLES
77    szScreenName        PIC X(256).
77    iScrOk              BINARY-LONG.


LINKAGE SECTION.
COPY 'GC58SAVERCLOCK.CPY'.

*> **************************************************************
*>           P R O C E D U R E   D I V I S I O N
*> **************************************************************
PROCEDURE DIVISION  using SAVER-AREA.
  *> sets in order to detect the PgUp, PgDn, PrtSc(screen print), Esc keys,
  set environment 'COB_SCREEN_EXCEPTIONS' TO 'Y'.
  set environment 'COB_SCREEN_ESC'        TO 'Y'.

MAIN.
  *> SAVE SCREEN
  MOVE Z"GC58SAVERCLOCK.TMP" TO szScreenName.   *> Filename ends with X"00"
  CALL STATIC "scr_dump" USING BY REFERENCE szScreenName RETURNING iScrOk END-CALL.

  *> erase the screen
   display ' ' at 0101 with blank screen end-display.

   perform InitialSettings         thru InitialSettingsEx
   perform DisplayScrollingString  thru DisplayScrollingStringEx

  *> hide the cursor (use always a display or an accept at .... before to have a call to "initscr"
  move 0 to wInt
  call static 'curs_set' using by value wInt end-call

   move   99   to   wCount

   accept wTime from time
   move   wTime to   TimeX
   perform DisplayClock thru DisplayClockEx

   PERFORM FOREVER
   *> loop until a key pressed
   *> accept without value returns 8001 to CRT-STATUS
        accept wDummy at 025080 with AUTO TIMEOUT 1 end-accept
        IF wCRT-STATUS NOT = 8001 EXIT PERFORM END-IF

        accept TimeX from time
        compute DeltaTime = Time9 - wTime9

        *> display clock and text every one second
        Display " " AT 0101 WITH ERASE EOS end-display
        if DeltaTime >= 100
           perform DisplayScrollingString  thru DisplayScrollingStringEx
           perform DisplayClock            thru DisplayClockEx
           move TimeX to wTime
           move 0 to sw
        else
           *> display only ScrollingString every 0.5 second
           if DeltaTime(7:1) = 5 and sw = 0
               perform DisplayScrollingString thru DisplayScrollingStringEx
               move 1 to sw
           end-if
        end-if
   end-perform

   *> RESTORE SCREEN
   CALL STATIC "scr_restore" USING BY REFERENCE szScreenName RETURNING iScrOk END-CALL
   .
   goback.

*> ***************************************************************
*>                      ROUTINES AREA
*> ***************************************************************
DisplayClock.
   *> **********************************************************
   *> time is displayed every one second
   *> box is displayed only when clock moves (to be implemented)
   *> **********************************************************
      if wCount > SSMove - 2 *> move the clock every 1 second

          move 0 to wCount

          *> define random clock position on screen
          if FlipFlop > 2
             subtract Timess1 from wCol1                   *> column
             add      Timess1 to   wlin1                   *> row
             if wCol1  > 40 move  3 to wCol1 end-if
             if wCol1  <  4 move 40 to wCol1 end-if
             if wlin1  > 20 move  4 to wlin1 end-if
             if wlin1  <  3 move  9 to wlin1 end-if
             move     0      to FlipFlop
          else
             add Timehh2 Timess2 to wCol1                   *> column
             subtract Timess2 from wlin1                    *> row
             if wCol1  > 40 move 07 to wCol1 end-if
             if wCol1  <  4 move 31 to wCol1 end-if
             if wlin1  > 20 move 13 to wlin1 end-if
             if wlin1  <  3 move 19 to wlin1 end-if
             add 1 to FlipFlop
          end-if

          move wCol1 to wCol
          compute wlin2 = wlin1 + 1
          compute wlin3 = wlin1 + 2

          perform DisplayBox    thru DisplayBoxEx
          perform DisplayTme    thru DisplayTmeEx

          *> change colors to clock and/or to scrolling string if requested
          if SSChangeCol  = 'Y' add 1 to SSbackcol  SSforecol  end-if
          if SSChangeColT = 'Y' add 1 to SSbackcolT SSforecolT end-if
          if SSbackcol  > 7 move 1 to SSbackcol  end-if
          if SSforecol  > 7 move 1 to SSforecol  end-if
          if SSbackcolT > 7 move 1 to SSbackcolT end-if
          if SSforecolT > 7 move 1 to SSforecolT end-if
     else
        perform DisplayBox thru DisplayBoxEx
        perform DisplayTme thru DisplayTmeEx
        add 1 to wCount
        move wCol1 to wCol
     end-if
     .
DisplayClockEx. exit.

DisplayBox.
   compute box-r1 = wlin1 - 1
   compute box-c1 = wCol  - 2
   compute box-r2 = wlin3 + 1
   compute box-c2 = wCol  + 36
   move SSbackcol to Box-bco
   move SSforecol to Box-fco
   CALL GC01BOX USING BY CONTENT BOX-AREA
   .
DisplayBoxEx. exit.

DisplayTme.

   string kEle2(Timehh1 + 1, 1) kEle2(Timehh2 + 1, 1) '   '
          kEle2(Timemm1 + 1, 1) kEle2(Timemm2 + 1, 1) '   '
          kEle2(Timess1 + 1, 1) kEle2(Timess2 + 1, 1)
          delimited by size into wClockRow1
   string kEle2(Timehh1 + 1, 2) kEle2(Timehh2 + 1, 2) ' : '
          kEle2(Timemm1 + 1, 2) kEle2(Timemm2 + 1, 2) ' : '
          kEle2(Timess1 + 1, 2) kEle2(Timess2 + 1, 2)
          delimited by size into wClockRow2
   string kEle2(Timehh1 + 1, 3) kEle2(Timehh2 + 1, 3) '   '
          kEle2(Timemm1 + 1, 3) kEle2(Timemm2 + 1, 3) '   '
          kEle2(Timess1 + 1, 3) kEle2(Timess2 + 1, 3)
          delimited by size into wClockRow3

   display wClockRow1 line wlin1 column wCol with background-color SSbackcol foreground-color SSforecol highlight
   display wClockRow2 line wlin2 column wCol with background-color SSbackcol foreground-color SSforecol highlight
   display wClockRow3 line wlin3 column wCol with background-color SSbackcol foreground-color SSforecol highlight
   continue.
DisplayTmeEx. exit.


DisplayScrollingString.
    if SStitle1 = 'Y'
       if i >= 80
          move 2 to i
       else
          add 1 to i
       end-if
       move wScr (1      : 81 - i) to wRow (i : 81 - i)
       move wScr (81 - i : i     ) to wRow (1 :      i)
       display wRow at 001001
               with background-color SSbackcolt foreground-color SSforecolt highlight end-display
    end-if
    .
DisplayScrollingStringEx. exit.

InitialSettings.
   move SStitle2 to wScr

   set Box-bco to SSbackcol
   set Box-fco to SSforecol
   *> calculate random initial clock position
   compute wCol1 = Timemm2 + Timess1 + Timehh2   *> column
   if wCol1  > 40 move  4 to  wCol1 end-if
   if wCol1  <  4 move 40 to  wCol1 end-if
   move wCol1 to wCol
   compute wlin1 = Timess2 + Timemm1            *> line
   if wlin1 > 20 move  4 to wlin1 end-if
   if wlin1 <  3 move 20 to wlin1 end-if
   compute wlin2 = wlin1 + 1
   compute wlin3 = wlin1 + 2
   .
InitialSettingsEx. exit.

End Program GC58SAVERCLOCK.
