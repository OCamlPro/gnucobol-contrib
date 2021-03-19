       >> SOURCE FORMAT IS FREE
REPLACE ==:BCOL:== BY ==BACKGROUND-COLOR== ==:FCOL:== BY ==FOREGROUND-COLOR==.
IDENTIFICATION DIVISION.
PROGRAM-ID. GC56DATEPICKER is initial.
*> ***********************************************************************************
*> GnuCOBOL TT (TUI TOOLS) COLLECTION
*> Purpose:    DISPLAY A ONE MONTH CALENDAR, LET THE USER PICKUP A DATE - RETURNS DATE TO CALLER
*>             Cursor= change Day/Week, PgUp/Dn change Month, +/- = change YEAR, C = go current date
*>             F1 = Help, ALT-F1/F2= chg Fore/BackColor; ALT-F3=chgBorders type;
*>             ALT-F4/F5=Toggle Title/Shadow; ALT-F6=Chg Language;
*>             ALT-F7= togge 3D borders; ALT-F8= toggle Legend
*>             mouse click on month or on year. Left/right = next or previous
*>             mouse leftclick on a date. double click to exit.
*> Tectonics:  cobc -m GC56DATEPICKER.COB  (use GnuCOBOL 3.1 or greater)
*> Calls:      GC01BOX, GC02BOXMEX and curs_set, scr_dump, scr_restore from pdcurses library
*> Usage:      call GC56DATEPICKER using DatePicker-Area
*> Parameters: look at GC56DATEPICKER.cpy
*> Author:     Eugenio Di Lorenzo - Italia (DILO) - eugenio.dilo@gmail.com
*>             - based on jrls (John Ellis) program
*> License:    (c)2021 E.Di Lorenzo - GNU Lesser General Public License, LGPL, 3.0 (or greater)
*> Version:    2.1 2021.02.02
*> Changelog:  1.0 first release.
*>             1.1 small enhancement (new field in copy Dtp-legend, F8 to toggle legend)
*>             1.2 and 1.3 bug correction
*>             1.4 added Dtp-Lan to manage other 6 languages EN IT FR ES DE NL
*>             1.5 added Dtp-Wait management - just display calendar & exit
*>             2.0 changed from call getch to accept dummy to add mouse management
*>             2.1 click on arrows to browse months amd years, color codes from 08 to 15
*> ***********************************************************************************
*>
*>   Example   +------ Calendar -----+        +--------- Calendar ---------+
*>             /<   May   >  < 2016 >|        |< September >       < 2016 >|
*>             |---------------------|        |----------------------------|
*>             | Su Mo Tu We Th Fr Sa|        |Sun Mon Tue Wed Thu Fri Sat |
*>             |---------------------|        |----------------------------|
*>             |          01 02 03 04|        |             01  02  03  04 |
*>             | 05 06 07 08 09 10 11|        | 05  06  07  08  09  10  11 |
*>             | 12 13 14 15 16 17 18|        | 12  13  14  15  16  17  18 |
*>             | 19 29 21 22 23 24 25|        | 19  29  21  22  23  24  25 |
*>             | 26 27 28 29 30      |        | 26  27  28  29  30         |
*>             |       CurUpDn PgUpDn|        |         Cursor,PgUp/Dn,+/- |
*>             +---------------------+        +----------------------------+
*>             Small or Standard Size          Big Size
*>
ENVIRONMENT DIVISION.
CONFIGURATION SECTION.
SPECIAL-NAMES.
    CRT STATUS IS wCRT-STATUS.    *> Return Code from Accept (ex.PF Keys, Mouse Keys)
    CURSOR     IS wCursorRowCol.  *> Cursor Position

*> **********************************************************************************
*>                      D A T A   D I V I S I O N
*> **********************************************************************************
DATA DIVISION.
WORKING-STORAGE SECTION.
copy 'GC00COLORS.CPY'.

01  wCRT-STATUS         PIC 9(04) VALUE 9999.
01  wCursorRowCol       PIC 9(06) value 0000.
01  redefines wCursorRowCol .
    05 wCursorRow       Pic 9(03).
    05 wCursorCol       Pic 9(03).

01  wDummy       PIC X(01) VALUE SPACE.
01  wPrompt      PIC X(01) VALUE SPACE.

01 wDtp-r1   pic 9(03) value 000. *> for accept Dummy
01 wDtp-c1   pic 9(03) value 000. *> for accept Dummy
01 wMM-Row   pic 9(03) value 000.
01 wMM-Col1  pic 9(03) value 000.
01 wMM-Col2  pic 9(03) value 000.
01 wYY-Row   pic 9(03) value 000.
01 wYY-Col1  pic 9(03) value 000.
01 wYY-Col2  pic 9(03) value 000.

01 wMM-L-Arr-col pic 9(03) value 000.
01 wMM-R-Arr-col pic 9(03) value 000.
01 wYY-L-Arr-col pic 9(03) value 000.
01 wYY-R-Arr-col pic 9(03) value 000.

01 wCP-row   pic 9(03) value 000.
01 wCP-col   pic 9(03) value 000.
01 wCP-Ind   pic 9(03) value 000.
01 wCP-pos-table.
   05 wCP-pos-ele occurs 42.
      07 wCP-r  pic 9(03).
      07 wCP-c1 pic 9(03).
      07 wCP-c2 pic 9(03).

01 wBco pic 9(02) value zero.
01 wFco pic 9(02) value zero.

*> SAVE/RESTORE SCREEN VARIABLES
01 wScreenName        PIC X(256).
01 wiScrOk            BINARY-LONG.

01  y                   pic 999 value zero.
01  k                   PIC 9(3) value 0.

01  w3D       pic x(03) value 'NRE'.      *> to loop between 3D borders
01  w3        pic 9(01) value 0.
01  wBorder   pic x(07) value 'SD123NC'.  *> to loop between borders
01  wB        pic 9(01) value 0.
01  wFlipFlop pic 9(01) value 0.
01  wR        pic 9(01) value 0.
01  wInd      pic 9(03) value 0.
01  wlin      pic 9(03) value 0.
01  wcol      pic 9(03) value 0.
01  wcol1     pic 9(03) value 0.
01  wDate.
    05 wDateYYYY       pic 9(4).
    05 wDateMM         pic 99.
    05 wDateDD         pic 99.
01 wDateDDx.
   05 filler             pic x(01) value space.
   05 wDateDD2           pic zz.

01  wBar             Pic x(28) value ALL X"C4".
01  wVisibilityNew   BINARY-SHORT . *> SIGNED.
01  wVisibilityOld   BINARY-SHORT . *> SIGNED.
01  wVisibilityNew9  pic 9(8).
01  wVisibilityOld9  pic 9(8).

01  date-a            pic 9(08)  value zero.
01  date-aR redefines date-a.
    05 date-aRYYYY    pic 9(4).
    05 date-aRMM      pic 9(2).
    05 date-aRDD      pic 9(2).

01  date-s.
    05 date-s-ym      pic 9(06).
    05 filler         pic 9(02) value 1.
01  startdate redefines date-s pic 9(8).
01  date-s2   redefines date-s.
    05 ds-year        pic 9(4).
    05 ds-month       pic 99.
    05 ds-day         pic 99.

01 wDs-year  pic x(08) value space.

01  daysub pic 99.  *> from 1 to 42
01  wksub  pic 9.   *> from 1 to 6

01  date-c pic 9(08).
01  day-s  pic 99.

01  wscurrent.
    05 cdate    pic 9(8).
    05 filler   pic x(20).

*> ***********************************************************************************************
*> TABLE OF 42 DAYS = 6 ROWS (WEEKS OF THE MONTH) X 7 COLS (DAYS OF THE WEEK)
*> ***********************************************************************************************
01  wCalendar.
    05 wCmonth.
       10  mDay        pic 9(8) value zero occurs 42 times indexed by i.

    05 cWeek redefines wCmonth occurs 6.
       10  cDay        pic 9(8) occurs  7 times.

    05 cDays redefines wCmonth   occurs 42 times.
       10 cDays-ym     pic 9(6).
       10 filler       pic 99.

*> ***********************************************************************************************
*> Table of 7 cols (days of the week) to be displayed on screen
*> ***********************************************************************************************
01  out-week.
    05 owday occurs 7 times.
       10 weekday    pic zzz value zero.
       10 filler     pic x   value space.

01  out-week2.
    05 owday2 occurs 7 times.
       10 weekday2   pic zzz value zero.
    *> 10 filler     pic x   value space.

01  wMonths   pic x(180) value
     "< January >    <February >    <  March  >    <  April  >    <   May   >    <  June   >    " &
     "<  July   >    <  August >    <September>    < October >    <November >    <December >    ".
01  wMonths2 redefines wMonths.
    05 wmonth        pic x(15) occurs 12 times.

01  wMonths-IT pic x(180) value
     "< Gennaio >    <Febbraio >    <  Marzo  >    < Aprile  >    < Maggio  >    < Giugno  >    " &
     "< Luglio  >    < Agosto  >    <Settembre>    < Ottobre >    <Novembre >    <Dicembre >    ".
01  wMonths-EN pic x(180) value
     "< January >    <February >    <  March  >    <  April  >    <   May   >    <  June   >    " &
     "<  July   >    <  August >    <September>    < October >    <November >    <December >    ".
01  wMonths-FR pic x(180) value
     "< Janvier >    < Fevrier >    <  Mars   >    <  Avril  >    <   Mai   >    <  Juin   >    " &
     "< Juillet >    <  Aout   >    <Septembre>    < Octobre >    <Novembre >    <Decembre >    ".
01  wMonths-ES pic x(180) value
     "<  Enero  >    < Febrero >    <  Marzo  >    <  Abril  >    <  Mayo   >    <  Junio  >    " &
     "<  Julio  >    < Agosto  >    <Septiembr>    < Octubre >    <Noviembre>    <Diciembre>    ".
01  wMonths-DE pic x(180) value
     "< Januar  >    < Februar >    <  Marz   >    <  April  >    <   Mai   >    <  Juni   >    " &
     "<  Juli   >    < August  >    <September>    < Oktober >    <November >    <Dezember >    ".
01  wMonths-NL pic x(180) value
     "< Januari >    <Februari >    <  Maart  >    <  April  >    <   Mei   >    <  Juni   >    " &
     "<  Juli   >    <Augustus >    <September>    < Oktober >    <November >    <December >    ".
*> Day description
01  wDayDes     Pic x(28) value "Sun Mon Tue Wed Thu Fri Sat ".
01  wDayDes-EN  Pic x(28) value "Sun Mon Tue Wed Thu Fri Sat ".
01  wDayDes-IT  Pic x(28) value "Dom Lun Mar Mer Gio Ven Sab ".
01  wDayDes-FR  Pic x(28) value "Dim Lun Mar Mer Jeu Ven Sam ".
01  wDayDes-ES  Pic x(28) value "Dom Lun Mar Mie Jue Vie Sab ".
01  wDayDes-DE  Pic x(28) value "Son Mon Die Mit Don Fre Sam ".
01  wDayDes-NL  Pic x(28) value "Zon Maa Din Woe Don Vri Zat ".
*> Day short description
01  wDayDesS     Pic x(21) value " Su Mo Tu We Th Fr Sa".
01  wDayDesS-EN  Pic x(21) value " Su Mo Tu We Th Fr Sa".
01  wDayDesS-IT  Pic x(21) value " Do Lu Ma Me Gi Ve Sa".
01  wDayDesS-FR  Pic x(21) value " Di Lu Ma Me Je Ve Sa".
01  wDayDesS-ES  Pic x(21) value " Do Lu Ma Mi Ju Vi Sa".
01  wDayDesS-DE  Pic x(21) value " So Mo Di Mi Do Fr Sa".
01  wDayDesS-NL  Pic x(21) value " Zo Ma Di Wo Do Vr Za".

COPY 'GC01BOX.CPY'        suppress.
copy 'GC02BOXMEX.CPY'     suppress.
copy 'GC97KEYCODEGC.CPY'  suppress.

LINKAGE SECTION.
COPY 'GC56DATEPICKER.CPY'.

*> ***********************************************************************************
*>           P R O C E D U R E   D I V I S I O N
*> ***********************************************************************************
PROCEDURE DIVISION using DatePicker-Area.

  perform InitialSettings thru InitialSettingsEx
  perform HideCursor      thru HideCursorEx

  compute wDtp-r1 = Dtp-r1 + 10  *> for accept Dummy
  compute wDtp-c1 = Dtp-c1 +  1  *> for accept Dummy

  *> compute month and year "arrows" position to detect mouse click on it
  compute wMM-L-Arr-col = Dtp-c1 + 1
  compute wMM-R-Arr-col = Dtp-c1 + 11
  evaluate true
    when Dtp-Dim = 'B' compute wYY-R-Arr-col = Dtp-c1 + 28
    when Dtp-Dim = 'S' compute wYY-R-Arr-col = Dtp-c1 + 21
  end-evaluate
  compute wYY-L-Arr-col = wYY-R-Arr-col - 7

  *> compute month and year string postions to detect mouse click on it
  compute wMM-Row  = Dtp-r1   + 1
  compute wMM-Col1 = Dtp-c1   + 2
  compute wMM-Col2 = wMM-Col1 + 8
  compute wYY-Row  = Dtp-r1   + 1
  evaluate true
    when Dtp-Dim = 'B' compute wYY-Col2 = Dtp-c1 + 27
    when Dtp-Dim = 'S' compute wYY-Col2 = Dtp-c1 + 20
  end-evaluate
  compute wYY-Col1 = wYY-Col2 - 5

  perform Load-CalendarPositions thru Load-CalendarPositionsEx

  if Dtp-DateSel = space
     move function current-date to wscurrent
  else
     *> cdate is a subfield of wscurrent
     move Dtp-DateSel to cdate
  end-if

  move cdate to date-a.

*> box frame and day labels
Display-Fixed-Data.
  perform Perf-Display-Fixed-Data thru Perf-Display-Fixed-DataEx
  continue.

Display-Variable-Data.
     perform Perf-Display-Variable-Data thru Perf-Display-Variable-DataEx
     perform Display-Cursor-on-Calendar thru Display-Cursor-on-CalendarEx
     continue.
Accept-User-Action.
    *> ***********************************************************************************
    *> WAIT FOR USER ACTION
    *> ***********************************************************************************
    if Dtp-Wait  = 'Y'
      *> after displayed calendar on screen, wait for user action
       move space to wDummy
      *> use same forecolor  as backcolor to have invisible Accept
       perform AcceptDummy thru AcceptDummyEx
       *> accept wDummy at line wDtp-r1 col wDtp-c1
              *> auto-skip prompt character is wPrompt :BCOL: Dtp-bco :FCOL: Dtp-bco
    else
       *> after displayed calendar on screen, return to caller without waiting for user action
       *> useful when you have just to display a one month calendar on screen
       go to End-Program
    end-if

    EVALUATE TRUE
    *> if the mouse was on a calendar DAY set that day
    when ( wCRT-STATUS = K-LEFT-PRESSED or wCRT-STATUS = K-LEFT-DBL-CLICK )
     and ( wCursorRow >= wCP-r(1)   and wCursorRow <= wCP-r(42)  )
     and ( wCursorCol >= wCP-c1(1)  and wCursorRow <= wCP-c2(42) )
            *> search which day has been clicked
            perform varying k from 1 by 1 until k > 42
                if  ( wCursorRow = wCP-r(k) )
                and ( wCursorCol >= wCP-c1(k) and wCursorCol <= wCP-c2(k) )
                    if mDay(k) not = zero
                       move mDay(k) to cdate date-a
                       *> go to Display-Variable-Data
                    end-if
                end-if
            end-perform

           *> if Doubleclick select the day and return to caller
           if wCRT-STATUS = K-LEFT-DBL-CLICK
           and ( wCursorRow >= wCP-r(1)   and wCursorRow <= wCP-r(42)  )
           and ( wCursorCol >= wCP-c1(1)  and wCursorRow <= wCP-c2(42) )
               perform Perf-Display-Variable-Data thru Perf-Display-Variable-DataEx
               perform Display-Cursor-on-Calendar thru Display-Cursor-on-CalendarEx
               *> small delay to show the "Cursor"
               call "CBL_GC_NANOSLEEP" USING 250000000 end-call *> pause 0.5 sec
               move wDate       to Dtp-DateSel
               move wCRT-STATUS to Dtp-Key
               go to End-Program
            end-if

    *> set the cursor on next month
    when wCRT-STATUS  = K-PAGEDOWN
      or wCRT-STATUS  = K-TAB
      or (wCRT-STATUS = K-RIGHT-PRESSED *> if clicked on  month
           and ( wCursorRow = wMM-Row and ( wCursorCol >= wMM-Col1 and wCursorCol <= wMM-Col2) ) )
      or (wCRT-STATUS = K-RIGHT-PRESSED *> if right clicked on  Right MM arrow
           and ( wCursorRow = wMM-Row and ( wCursorCol = wMM-R-Arr-col) ) )
      or (wCRT-STATUS = K-LEFT-PRESSED *> if left clicked on  Right MM arrow
           and ( wCursorRow = wMM-Row and ( wCursorCol = wMM-R-Arr-col) ) )
      *> or wDummy = space
         compute date-aRMM = date-aRMM + 1
         if date-aRMM > 12
            compute date-aRYYYY = date-aRYYYY + 1
            move 1 to date-aRMM
         end-if
    *> set the cursor on previous month
    when wCRT-STATUS  = K-PAGEUP
      or wCRT-STATUS  = K-BACKTAB
      or (wCRT-STATUS = K-LEFT-PRESSED *> if clicked on  month
           and ( wCursorRow = wMM-Row and ( wCursorCol >= wMM-Col1 and wCursorCol <= wMM-Col2) ) )
      or (wCRT-STATUS = K-RIGHT-PRESSED *> if right clicked on  Left MM arrow
           and ( wCursorRow = wMM-Row and ( wCursorCol = wMM-L-Arr-col) ) )
      or (wCRT-STATUS = K-LEFT-PRESSED *> if left clicked on  Left MM arrow
           and ( wCursorRow = wMM-Row and ( wCursorCol = wMM-L-Arr-col) ) )
         compute date-aRMM = date-aRMM - 1
         if date-aRMM < 1
            compute date-aRYYYY = date-aRYYYY - 1
            move 12 to date-aRMM
         end-if
     *> set cursor on next day
     when wCRT-STATUS = K-RIGHT
          if mDay(i) = 0
             set i to 1
             compute date-aRMM = date-aRMM + 1
             if date-aRMM > 12
                compute date-aRYYYY = date-aRYYYY + 1
                move 1 to date-aRMM
             end-if
          else
             compute date-aRDD = date-aRDD + 1
          end-if
     *> set cursor on previous day
     when wCRT-STATUS = K-LEFT
         compute date-aRDD = date-aRDD - 1
     *> set cursor on next week
     when wCRT-STATUS = K-DOWN
          set i up by 7
          move i to wInd
          if i > 42 or mDay(i) = 0
             set i to 1
             compute date-aRMM = date-aRMM + 1
             if date-aRMM > 12
                compute date-aRYYYY = date-aRYYYY + 1
                move 1 to date-aRMM
             end-if
             if  date-aRDD = 31              and (date-aRMM = 04 or 06 or 09 or 11) move 30 to date-aRDD end-if
             if (date-aRDD = 31 or 30 or 29) and  date-aRMM = 02                    move 28 to date-aRDD end-if
          else
             compute date-aRDD = date-aRDD + 7
          end-if
      *> set cursor on previous week
     when wCRT-STATUS = K-UP
          set i down by 7
          if i < 0 or mDay(i) = 0
             set i to 1
             compute date-aRMM = date-aRMM - 1
             if date-aRMM < 1
                compute date-aRYYYY = date-aRYYYY - 1
                move 12 to date-aRMM
             end-if
           else
              compute date-aRDD = date-aRDD - 7
           end-if

     *> set cursor on next year
     when wDummy = '+'
      *> if clicked on  year
      or  ( wCRT-STATUS = K-RIGHT-PRESSED
      and ( wCursorRow = wYY-Row and ( wCursorCol >= wYY-Col1 and wCursorCol <= wYY-Col2) ) )
      *> if right clicked on  Left YY arrow
       or (wCRT-STATUS = K-RIGHT-PRESSED
           and ( wCursorRow = wYY-Row and ( wCursorCol = wYY-R-Arr-col) ) )
       *> if left clicked on  Left YY arrow
       or (wCRT-STATUS = K-LEFT-PRESSED
           and ( wCursorRow = wYY-Row and ( wCursorCol = wYY-R-Arr-col) ) )

             compute date-aRYYYY = date-aRYYYY + 1

     *> set cursor on previous year
     when wDummy = '-'
      *> if clicked on  year
      or  ( wCRT-STATUS = K-LEFT-PRESSED
      and ( wCursorRow = wYY-Row and ( wCursorCol >= wYY-Col1 and wCursorCol <= wYY-Col2) ) )
      *> if right clicked on  Left YY arrow
      or  (wCRT-STATUS = K-RIGHT-PRESSED
           and ( wCursorRow = wYY-Row and ( wCursorCol = wYY-L-Arr-col) ) )
      *> if left clicked on  Left YY arrow
      or  (wCRT-STATUS = K-LEFT-PRESSED
           and ( wCursorRow = wYY-Row and ( wCursorCol = wYY-L-Arr-col) ) )

             compute date-aRYYYY = date-aRYYYY - 1

     *> "C" - set cursor on current date
     when wDummy = 'C' or 'c'
          move function current-date to wscurrent
          move cdate to date-a
     when wCRT-STATUS = K-F1              *> F1 HELP
            perform DisplayHelp thru DisplayHelpEx
            go to Display-Fixed-Data

     *> ALT-F1 change Foreground Color of calendar
     when wCRT-STATUS = K-ALT-F1
         add 1 to Dtp-Fco Dtp-titFco
         If Dtp-Fco > 15 move 0 to Dtp-Fco Dtp-titFco end-if
         go to Display-Fixed-Data

     *> ALT-F2 change Background Color of calendar
     when wCRT-STATUS = K-ALT-F2
         add 1 to Dtp-Bco Dtp-titBco
         If Dtp-Bco > 15 move 0 to Dtp-Bco Dtp-titBco end-if
         go to Display-Fixed-Data

     *> ALT-F3 change calendar border's type
     when wCRT-STATUS = K-ALT-F3
         add 1 to wB  if wB > 6 move 1 to wB end-if
         move wBorder (wB:1) to Dtp-Style
         go to Display-Fixed-Data

     *> ALT-F4 toggle on/off the calendar title
     when wCRT-STATUS = K-ALT-F4
         move Dtp-Bco to Dtp-titBco
         move Dtp-Fco to Dtp-titFco
         if wFlipFlop = 0
            move 1 to wFlipFlop
            move "N" to Dtp-tit
         else
            move 0 to wFlipFlop
            move "Y" to Dtp-tit
         end-if
         go to Display-Fixed-Data

     *> ALT-F5 toggle calendar shadow.
     *> (warning: not complete, to eliminate shadow you have to restore backgroud after saved !)
     when wCRT-STATUS = K-ALT-F5
         if wFlipFlop = 0
            move 1 to wFlipFlop
            move "N" to Dtp-shadow
         else
            move 0 to wFlipFlop
            move "Y" to Dtp-shadow
         end-if
         go to Display-Fixed-Data

     *> ALT-F6 switch and rotation between Languages: EN IT FR ES DE NL
     when wCRT-STATUS = K-ALT-F6
         add 1 to Dtp-Lan
         if Dtp-Lan > 6
            move 1 to Dtp-Lan
         end-if
         compute wlin = Box-r1 + 3
         compute wCol = Box-c1 + 1
         perform Set-Language thru Set-LanguageEx
         go to Display-Fixed-Data
         *> evaluate true
            *> when Dtp-Dim = 'B' perform Display-wDayDes  thru Display-wDayDesEx
            *> when Dtp-Dim = 'S' perform Display-wDayDesS thru Display-wDayDesSEx
         *> end-evaluate
         *> go to Display-Variable-Data

     *> ALT-F7 toggle 3D box calendar borders
     when wCRT-STATUS = K-ALT-F7
         add 1 to w3  if w3 > 3 move 1 to w3 end-if
         move w3D(w3:1) to Dtp-3D
         go to Display-Fixed-Data

     *> ALT-F8 toggle on/off the calendar legend
     when wCRT-STATUS = K-ALT-F8
         if Dtp-legend = 'Y'
            move 'N' to Dtp-legend
         else
            move 'Y' to Dtp-legend
         end-if
         go to Display-Fixed-Data

     when wCRT-STATUS = K-ESCAPE
         move wDate       to Dtp-DateSel
         move wCRT-STATUS to Dtp-Key
         go to End-Program

     *> select the date an return to caller
     *> if user type a letter wCRT-STATUS is = Enter  = 0000 !
     when wCRT-STATUS = K-ENTER and wDummy = space
         move wDate       to Dtp-DateSel
         move wCRT-STATUS to Dtp-Key
         go to End-Program

     *> when other
         *> continue
         *> go to Accept-User-Action
     END-EVALUATE

     *> loop to display cursor on new day / new week / new month / new year
     go to Display-Variable-Data
     continue.

End-Program.
    perform ShowCursor thru ShowCursorEx
    goback.

*> ***************************************************************************************************
*>
*> ***************************************************************************************************
InitialSettings.
  *> sets in order to detect the PgUp, PgDn, PrtSc(screen print), Esc keys,
  set environment 'COB_SCREEN_EXCEPTIONS' TO 'Y'.
  set environment 'COB_SCREEN_ESC'        TO 'Y'.

  *> make mouse active
  COMPUTE SET-MOUSE-FLAGS = SET-AUTO-MOUSE-HANDLING
                      + SET-LEFT-DOWN   + SET-MIDDLE-DOWN   + SET-RIGHT-DOWN
                      + SET-LEFT-UP     + SET-MIDDLE-UP     + SET-RIGHT-UP
                      + SET-LEFT-DOUBLE + SET-MIDDLE-DOUBLE + SET-RIGHT-DOUBLE
                      + SET-MOUSE-MOVE
  SET environment     "COB_MOUSE_FLAGS"         to SET-MOUSE-FLAGS
  continue.
InitialSettingsEx. exit.

Set-Language.
     Evaluate Dtp-Lan
     when = 1
        move wMonths-EN   to wMonths
        *> Big Size or Small Size calendar
        evaluate true
           when Dtp-Dim = 'B' move wDayDes-EN   to wDayDes
           when Dtp-Dim = 'S' move wDayDesS-EN  to wDayDesS
        end-evaluate
     when = 2
        move wMonths-IT   to wMonths
        evaluate true
           when Dtp-Dim = 'B' move wDayDes-IT  to wDayDes
           when Dtp-Dim = 'S' move wDayDesS-IT to wDayDesS
        end-evaluate
    when = 3
        move wMonths-FR   to wMonths
        evaluate true
           when Dtp-Dim = 'B' move wDayDes-FR   to wDayDes
           when Dtp-Dim = 'S' move wDayDesS-FR  to wDayDesS
        end-evaluate
    when = 4
        move wMonths-ES   to wMonths
        evaluate true
           when Dtp-Dim = 'B' move wDayDes-ES   to wDayDes
           when Dtp-Dim = 'S' move wDayDesS-ES  to wDayDesS
        end-evaluate
    when = 5
        move wMonths-DE   to wMonths
        evaluate true
           when Dtp-Dim = 'B' move wDayDes-DE   to wDayDes
           when Dtp-Dim = 'S' move wDayDesS-DE  to wDayDesS
        end-evaluate
    when = 6
        move wMonths-NL   to wMonths
        evaluate true
           when Dtp-Dim = 'B' move wDayDes-NL   to wDayDes
           when Dtp-Dim = 'S' move wDayDesS-NL  to wDayDesS
        end-evaluate
     when other
        move wMonths-EN   to wMonths
        evaluate true
           when Dtp-Dim = 'B' move wDayDes-EN   to wDayDes
           when Dtp-Dim = 'S' move wDayDesS-EN  to wDayDesS
        end-evaluate
     end-evaluate
     continue.
Set-LanguageEx. Exit.


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

Perf-Display-Fixed-Data.
    *> ***********************************************************************************
    *> Display fixed data on screen
    *> ***********************************************************************************
    initialize Box-area ALL TO VALUE
    move Dtp-r1c1     to Box-r1c1
    compute Box-r2 = Box-r1 + 11
    evaluate true
       when Dtp-Dim = 'B' compute Box-c2 = Box-c1 + 29
       when Dtp-Dim = 'S' compute Box-c2 = Box-c1 + 22
    end-evaluate
    move Dtp-Bco      to Box-Bco
    move Dtp-Fco      to Box-Fco
    move Dtp-FcoH     to Box-FcoH
    move Dtp-style    to Box-style
    move Dtp-custom   to Box-custom
    move dtp-fill     to Box-fill
    move Dtp-Shadow   to Box-shadow
    move Dtp-3D       to Box-3D
    move Dtp-add1c    to Box-add1c
    move Dtp-beep     to Box-beep
    move Dtp-tit      to Box-tit
    move Dtp-titBco   to Box-titBco
    move Dtp-titFco   to Box-titFco
    move Dtp-titFcoH  to Box-titFcoH
    move Dtp-titDes   to Box-titDes
    call GC01BOX using BOX-AREA

    *> upper bar
    compute wCol = Box-c1 + 1
    compute wlin = Box-r1 + 2
    evaluate true
       when Dtp-Dim = 'B' perform Display-wBarB thru Display-wBarBEx
       when Dtp-Dim = 'S' perform Display-wBarS thru Display-wBarSEx
    end-evaluate

    *> Days description
    perform Set-Language thru Set-LanguageEx
    compute wlin = Box-r1 + 3
    evaluate true
      when Dtp-Dim = 'B' perform Display-wDayDes  thru Display-wDayDesEx
      when Dtp-Dim = 'S' perform Display-wDayDesS thru Display-wDayDesSEx
    end-evaluate

    *> lower bar
    compute wlin = Box-r1 + 4
    evaluate true
       when Dtp-Dim = 'B' perform Display-wBarB thru Display-wBarBEx
       when Dtp-Dim = 'S' perform Display-wBarS thru Display-wBarSEx
    end-evaluate

  continue.
Perf-Display-Fixed-DataEx. exit.

Perf-Display-Variable-Data.
    initialize wCalendar all to value
    compute date-s-ym = date-a / 100
    compute date-c = function integer-of-date(startdate)
    compute day-s  = function mod(date-c,7)
    perform 0110-loadCalendar    thru 0110-loadCalendarEx
    perform 0120-DisplayCalendar thru 0120-DisplayCalendarEx

    *> ***********************************************************************************
    *> DISPLAY "CURSOR " ON CALENDAR DATE
    *> ***********************************************************************************
    set i to 1
    search mDay  varying i
           at end

                if wCRT-STATUS = K-RIGHT
                   compute date-aRDD = 1
                   compute date-aRMM = date-aRMM + 1
                   if date-aRMM > 12
                      compute date-aRYYYY = date-aRYYYY + 1
                      move 1 to date-aRMM
                   end-if
                end-if

                if wCRT-STATUS = K-LEFT
                   compute date-aRMM = date-aRMM - 1
                   if date-aRMM < 1
                      compute date-aRYYYY = date-aRYYYY - 1
                      move 12 to date-aRMM
                   end-if
                   evaluate true
                           when date-aRMM = 1 or 3 or 5 or 7 or 8 or 10 or 12
                                 compute date-aRDD = 31
                           when date-aRMM = 4 or 6 or 9 or 11
                                 compute date-aRDD = 30
                           when date-aRMM = 2
                                 compute date-aRDD = 28
                   end-evaluate
                end-if

                *> 20161018 bug correction ***********************************
                *> 20161018 when you are on 31 and next month have < 31 days !
                if wCRT-STATUS = K-PAGEDOWN or K-TAB  *>or Key-space
                   if date-aRMM = 12
                      compute date-aRYYYY = date-aRYYYY + 1
                      move  1 to date-aRMM
                   end-if
                   evaluate true
                           when date-aRMM = 1 or 3 or 5 or 7 or 8 or 10 or 12
                                 compute date-aRDD = 31
                           when date-aRMM = 4 or 6 or 9 or 11
                                 compute date-aRDD = 30
                           when date-aRMM = 2
                                 compute date-aRDD = 28
                   end-evaluate
                end-if
                *> 20161018 end of bug correction ********************************

                *> 20161019 bug correction ***************************************
                *> 20161019 when you are on 31 and previous month have < 31 days !
                if wCRT-STATUS = K-PAGEUP
                   if date-aRMM = 01
                      compute date-aRYYYY = date-aRYYYY - 1
                      move 12 to date-aRMM
                   end-if
                   evaluate true
                           when date-aRMM = 1 or 3 or 5 or 7 or 8 or 10 or 12
                                 compute date-aRDD = 31
                           when date-aRMM = 4 or 6 or 9 or 11
                                 compute date-aRDD = 30
                           when date-aRMM = 2
                                 compute date-aRDD = 28
                   end-evaluate
                end-if
                *> 20161019 end of bug correction ********************************

                *> 20161026 bug correction ****************************************
                *> 20161026 when you are on 29 february and next year has 28 days !
                if wDummy = '+'
                   evaluate true
                           when date-aRMM = 1 or 3 or 5 or 7 or 8 or 10 or 12
                                 compute date-aRDD = 31
                           when date-aRMM = 4 or 6 or 9 or 11
                                 compute date-aRDD = 30
                           when date-aRMM = 2
                                 compute date-aRDD = 28
                   end-evaluate
                end-if
                *> 20161026 end of bug correction ************************************

                *> 20161026 bug correction ********************************************
                *> 20161026 when you are on 29 february and previous year has 28 days !
                if wDummy = '-'
                   evaluate true
                           when date-aRMM = 1 or 3 or 5 or 7 or 8 or 10 or 12
                                 compute date-aRDD = 31
                           when date-aRMM = 4 or 6 or 9 or 11
                                 compute date-aRDD = 30
                           when date-aRMM = 2
                                 compute date-aRDD = 28
                   end-evaluate
                end-if
                *> 20161026 end of bug correction *************************************

                go to Display-Variable-Data

           when mDay(i) = date-a
                go to end-search1

    end-search
    continue.

end-search1.
    move i to wInd
    *> mDay(i) contains the date "active"
    move mDay(i)  to wDate
    move wDateDD  to wDateDD2
    divide i by 7
        giving    wLin
        rounded   mode is truncation
        remainder wCol
    end-divide
    *> if remainder = 0
    if wCol = 0
       compute wCol = 7
       compute wLin = wLin - 1
    end-if
  continue.
Perf-Display-Variable-DataEx. exit.

*> ***************************************************************************************************
*> LOAD CALENDAR TABLE (42 YYYYMMDD ELEMENTS)
*> ***************************************************************************************************
0110-loadCalendar.
    compute daysub = day-s + 1.
    perform varying daysub from daysub by 1 until daysub > 42
       compute mDay(daysub) = function date-of-integer(date-c)
       if cDays-ym(daysub) <> date-s-ym
          move 0     to mDay(daysub)
          move 43    to daysub
       end-if
       add 1         to date-c
    end-perform

    continue.
0110-loadCalendarEx. exit.

0120-DisplayCalendar.
*> ***********************************************************************************
*> Display variable data on screen
*> ***********************************************************************************

    *> display month descritpion string
    compute wlin = Box-r1 + 1
    compute wCol = Box-c1 + 1
    perform Display-wMonth thru Display-wMonthEx

    *> display year number string
    compute wCol = Box-c2 - 8
    string '< ' ds-year ' >' into wDs-year
    perform Display-wDs-year thru Display-wDs-yearEx

    *> ********************************************************************************
    *> display 6 rows (weeks)
    *> ********************************************************************************
    perform varying wksub from 1 by 1 until wksub > 6

        *> prepare 7 columns (days)
        perform varying daysub from 1 by 1 until daysub > 7
                if cDay(wksub, daysub) = 0
                   move zero    to weekday(daysub)
                else
                   compute weekday(daysub) = function mod (cDay(wksub, daysub), 100)
                end-if
        end-perform

        compute wLin = Box-r1 +  wksub  + 4
        compute wCol = Box-c1 + (daysub * 2) - 15

        perform  varying wR from 1 by 1 until wR >  7
             move owday(wR) to owday2(wR)
        end-perform

        *> DISPLAY 6 ROWS
        evaluate true
           when Dtp-Dim = 'B'
                perform Display-out-week thru Display-out-weekEx
           when Dtp-Dim = 'S'
                perform varying wR from 1 by 1 until wR = 7
                    move owday(wR) to owday2(wR)
                end-perform
                perform Display-out-week2 thru Display-out-week2Ex
        end-evaluate

    end-perform

    if Dtp-legend = 'Y'
      evaluate true
      when Dtp-Dim = 'B' *> Big size
            compute wCol = Box-C2 - 19
            perform Display-LegendB thru Display-LegendBEx
            *> display 'Cursor,PgUP/Dn,+/-' at line wLin col wCol :BCOL: Box-Bco :FCOL: Box-Fco highlight
      when Dtp-Dim = 'S'  *> Small Size
            compute wCol = Box-C2 - 14
            perform Display-LegendS thru Display-LegendSEx
            *> display 'Cur,PgUpDn,+/-'     at line wLin col wCol :BCOL: Box-Bco :FCOL: Box-Fco highlight
      end-evaluate
    end-if
    continue.
0120-DisplayCalendarEx. exit.

DisplayHelp.
   perform ScreenSave thru ScreenSaveEx

    initialize Boxmex-Area ALL TO VALUE
    move low-value to Bxm-tabmex
    move blue     to Bxm-bco    Bxm-titBco Bxm-bcoM
    move white    to Bxm-fco    Bxm-titFco Bxm-fcoM
    move 'Y'      to Bxm-Click  Bxm-tit
    move 'N'      to Bxm-3D     Bxm-OkButton
    move 'S'      to Bxm-style
    compute Bxm-r1 = Dtp-r1
    compute Bxm-c1 = Dtp-c1
    compute Bxm-r2 = Dtp-r1 + 11
    move 1 to y

    evaluate true
      when Dtp-Dim = 'B'
            compute Bxm-c2 = Dtp-c1 + 29
            move z' Curs right/left  day +1/-1 ' to Bxm-mex(y) add 1 to y
            move z' Curs down/up    week +1/-1 ' to Bxm-mex(y) add 1 to y
            move z' Page down/up   month +1/-1 ' to Bxm-mex(y) add 1 to y
            move z' + / -           year +1/-1 ' to Bxm-mex(y) add 1 to y
            move z' On month on year or arrows ' to Bxm-mex(y) add 1 to y
            move z' left/right click to browse.' to Bxm-mex(y) add 1 to y
            move z' C : goto current date      ' to Bxm-mex(y) add 1 to y
            move z' Enter/left dbleclk to exit ' to Bxm-mex(y) add 1 to y
            move z' (c)eugenio.dilo@gmail.com  ' to Bxm-mex(y) add 1 to y
            move z' enter/mouseclick: continue ' to Bxm-mex(y) add 1 to y
            move x'B4' & ' DATEPICKER - HELP '  & x'C3' & x'00' to Bxm-titDes
       when Dtp-Dim = 'S'
            compute Bxm-c2 = Dtp-c1 + 22
            move z'Curs rgt/lft day +/-1' to Bxm-mex(y) add 1 to y
            move z'Curs dn/up  week +/-1' to Bxm-mex(y) add 1 to y
            move z'PageDn/Up  month +/-1' to Bxm-mex(y) add 1 to y
            move z'+ / -       year +/-1' to Bxm-mex(y) add 1 to y
            move z'On month/year/arrows ' to Bxm-mex(y) add 1 to y
            move z'lft/rgt clk to browse' to Bxm-mex(y) add 1 to y
            move z'C : go current date  ' to Bxm-mex(y) add 1 to y
            move z'Entr/lft dbleclk exit' to Bxm-mex(y) add 1 to y
            move z'eugenio.dilo@gmail.com' to Bxm-mex(y) add 1 to y
            move z'ent/mouseclk continue' to Bxm-mex(y) add 1 to y
            move x'B4' & ' DATEPICKER - HELP '  & x'C3' & x'00' to Bxm-titDes
    end-evaluate

    call GC02BOXMEX using by content BOXMEX-AREA
         on exception display 'CALL GC02BOXMEX error. Module GC02BOXMEX not Found.'
         accept OMITTED
    end-call
    perform ScreenRestore thru ScreenRestoreEx.
DisplayHelpEx. exit.

ScreenSave.
   move Z'GC56DATEPICKER.TMP' to wScreenName
   call static 'scr_dump' using by reference wScreenName returning wiScrOk end-call.
ScreenSaveEx. exit.

ScreenRestore.
   call static 'scr_restore' using by reference wScreenName returning wiScrOk end-call
   CALL 'CBL_DELETE_FILE' USING wScreenName.
ScreenRestoreEx. exit.


*> load a table with day positions on screen to detect mouse click on them
Load-CalendarPositions.
      move 1 to  wCP-Ind
    evaluate true
       when Dtp-Dim = 'B'
            perform varying wCP-row from 1 by 1 until wCP-row > 6
                  perform varying wCP-col from 1 by 1 until wCP-col > 7
                      compute wCP-r (wCP-Ind) = Dtp-r1 + 4 + wCP-row
                      compute wCP-c2(wCP-Ind) = Dtp-c1 + (wCP-col * 4)
                      if k = 1 or 8 or 15 or 22 or 29 or 35
                         compute wCP-c2(wCP-Ind) = wCP-c2(wCP-Ind) - 1
                      end-if
                      compute wCP-c1(wCP-Ind) = wCP-c2(wCP-Ind) - 3
                      add 1 to  wCP-Ind
                  end-perform
            end-perform
       when Dtp-Dim = 'S'
            perform varying wCP-row from 1 by 1 until wCP-row > 6
                  perform varying wCP-col from 1 by 1 until wCP-col > 7
                      compute wCP-r (wCP-Ind) = Dtp-r1 + 4 + wCP-row
                      compute wCP-c2(wCP-Ind) = Dtp-c1 + (wCP-col * 3)
                      compute wCP-c1(wCP-Ind) = wCP-c2(wCP-Ind) - 2
                      add 1 to  wCP-Ind
                  end-perform
            end-perform
    end-evaluate

    continue.
Load-CalendarPositionsEx. exit.

Display-Cursor-on-Calendar.
  *> ************************************************************************************************************
  *> DISPLAY THE "CURSOR" ON CALENDAR
  *> ************************************************************************************************************
  compute wLin = Box-r1 + 4 + wLin + 1
  evaluate true
      when Dtp-Dim = 'B'
          compute wCol = Box-c1 + ( (4 * wCol) - 3)
          display wDateDDx      at line wLin col wCol :BCOL: Box-Fco :FCOL: red highlight
      when Dtp-Dim = 'S'
          compute wCol = Box-c1 + ( (3 * wCol) - 3) + 1
          display wDateDDx(1:3) at line wLin col wCol :BCOL: Box-Fco :FCOL: red highlight
  end-evaluate
  continue.
Display-Cursor-on-CalendarEx. exit.

Display-wDayDes.
  evaluate true
     when Box-bco > 7 and Box-fco >  7
         compute wBco = Box-bco - 8
         compute wFco = Box-fco - 8
         display wDayDes at line wlin col wcol :BCOL: wBco :FCOL: wFco blink highlight
      when Box-bco > 7 and Box-fco <= 7
         compute wBco = Box-bco - 8
         compute wFco = Box-fco
         display wDayDes at line wlin col wcol :BCOL: wBco :FCOL: wFco blink
     when Box-bco <= 7 and Box-fco >  7
         compute wBco = Box-bco
         compute wFco = Box-fco - 8
         display wDayDes at line wlin col wcol :BCOL: wBco :FCOL: wFco highlight
     when Box-bco <= 7 and Box-fco <= 7
         compute wBco = Box-bco
         compute wFco = Box-fco
         display wDayDes at line wlin col wcol :BCOL: wBco :FCOL: wFco
  end-evaluate
  continue.
Display-wDayDesEx. exit.

Display-wDayDesS.
  evaluate true
     when Box-bco > 7 and Box-fco >  7
         compute wBco = Box-bco - 8
         compute wFco = Box-fco - 8
         display wDayDesS at line wlin col wcol :BCOL: wBco :FCOL: wFco blink highlight
      when Box-bco > 7 and Box-fco <= 7
         compute wBco = Box-bco - 8
         compute wFco = Box-fco
         display wDayDesS at line wlin col wcol :BCOL: wBco :FCOL: wFco blink
     when Box-bco <= 7 and Box-fco >  7
         compute wBco = Box-bco
         compute wFco = Box-fco - 8
         display wDayDesS at line wlin col wcol :BCOL: wBco :FCOL: wFco highlight
     when Box-bco <= 7 and Box-fco <= 7
         compute wBco = Box-bco
         compute wFco = Box-fco
         display wDayDesS at line wlin col wcol :BCOL: wBco :FCOL: wFco
  end-evaluate
  continue.
Display-wDayDesSEx. exit.

Display-wMonth.
  evaluate true
     when Box-bco > 7 and Box-fco >  7
         compute wBco = Box-bco - 8
         compute wFco = Box-fco - 8
         display wmonth(ds-month) at line wlin col wcol :BCOL: wBco :FCOL: wFco blink highlight
      when Box-bco > 7 and Box-fco <= 7
         compute wBco = Box-bco - 8
         compute wFco = Box-fco
         display wmonth(ds-month) at line wlin col wcol :BCOL: wBco :FCOL: wFco blink
     when Box-bco <= 7 and Box-fco >  7
         compute wBco = Box-bco
         compute wFco = Box-fco - 8
         display wmonth(ds-month) at line wlin col wcol :BCOL: wBco :FCOL: wFco highlight
     when Box-bco <= 7 and Box-fco <= 7
         compute wBco = Box-bco
         compute wFco = Box-fco
         display wmonth(ds-month) at line wlin col wcol :BCOL: wBco :FCOL: wFco
  end-evaluate
  continue.
Display-WMonthEx. exit.

Display-wDs-year.
  evaluate true
     when Box-bco > 7 and Box-fco >  7
         compute wBco = Box-bco - 8
         compute wFco = Box-fco - 8
         display wDs-year at line wlin col wcol :BCOL: wBco :FCOL: wFco blink highlight
      when Box-bco > 7 and Box-fco <= 7
         compute wBco = Box-bco - 8
         compute wFco = Box-fco
         display wDs-year at line wlin col wcol :BCOL: wBco :FCOL: wFco blink
     when Box-bco <= 7 and Box-fco >  7
         compute wBco = Box-bco
         compute wFco = Box-fco - 8
         display wDs-year at line wlin col wcol :BCOL: wBco :FCOL: wFco highlight
     when Box-bco <= 7 and Box-fco <= 7
         compute wBco = Box-bco
         compute wFco = Box-fco
         display wDs-year at line wlin col wcol :BCOL: wBco :FCOL: wFco
  end-evaluate
  continue.
Display-wDs-yearEx. exit.

Display-out-week.
  evaluate true
     when Box-bco > 7 and Box-fco >  7
         compute wBco = Box-bco - 8
         compute wFco = Box-fco - 8
         display out-week at line wlin col wcol :BCOL: wBco :FCOL: wFco blink highlight
      when Box-bco > 7 and Box-fco <= 7
         compute wBco = Box-bco - 8
         compute wFco = Box-fco
         display out-week at line wlin col wcol :BCOL: wBco :FCOL: wFco blink
     when Box-bco <= 7 and Box-fco >  7
         compute wBco = Box-bco
         compute wFco = Box-fco - 8
         display out-week at line wlin col wcol :BCOL: wBco :FCOL: wFco highlight
     when Box-bco <= 7 and Box-fco <= 7
         compute wBco = Box-bco
         compute wFco = Box-fco
         display out-week at line wlin col wcol :BCOL: wBco :FCOL: wFco
  end-evaluate
  continue.
Display-out-weekEx. exit.

Display-out-week2.
  evaluate true
     when Box-bco > 7 and Box-fco >  7
         compute wBco = Box-bco - 8
         compute wFco = Box-fco - 8
         display out-week2 at line wlin col wcol :BCOL: wBco :FCOL: wFco blink highlight
      when Box-bco > 7 and Box-fco <= 7
         compute wBco = Box-bco - 8
         compute wFco = Box-fco
         display out-week2 at line wlin col wcol :BCOL: wBco :FCOL: wFco blink
     when Box-bco <= 7 and Box-fco >  7
         compute wBco = Box-bco
         compute wFco = Box-fco - 8
         display out-week2 at line wlin col wcol :BCOL: wBco :FCOL: wFco highlight
     when Box-bco <= 7 and Box-fco <= 7
         compute wBco = Box-bco
         compute wFco = Box-fco
         display out-week2 at line wlin col wcol :BCOL: wBco :FCOL: wFco
  end-evaluate
  continue.
Display-out-week2Ex. exit.

Display-wBarB.
  evaluate true
     when Box-bco > 7 and Box-fco >  7
         compute wBco = Box-bco - 8
         compute wFco = Box-fco - 8
         display wBar at line wlin col wcol :BCOL: wBco :FCOL: wFco blink highlight
      when Box-bco > 7 and Box-fco <= 7
         compute wBco = Box-bco - 8
         compute wFco = Box-fco
         display wBar at line wlin col wcol :BCOL: wBco :FCOL: wFco blink
     when Box-bco <= 7 and Box-fco >  7
         compute wBco = Box-bco
         compute wFco = Box-fco - 8
         display wBar at line wlin col wcol :BCOL: wBco :FCOL: wFco highlight
     when Box-bco <= 7 and Box-fco <= 7
         compute wBco = Box-bco
         compute wFco = Box-fco
         display wBar at line wlin col wcol :BCOL: wBco :FCOL: wFco
  end-evaluate
  continue.
Display-wBarBEx. exit.

Display-wBarS.
  evaluate true
     when Box-bco > 7 and Box-fco >  7
         compute wBco = Box-bco - 8
         compute wFco = Box-fco - 8
         display wBar(1:21) at line wlin col wcol :BCOL: wBco :FCOL: wFco blink highlight
      when Box-bco > 7 and Box-fco <= 7
         compute wBco = Box-bco - 8
         compute wFco = Box-fco
         display wBar(1:21) at line wlin col wcol :BCOL: wBco :FCOL: wFco blink
     when Box-bco <= 7 and Box-fco >  7
         compute wBco = Box-bco
         compute wFco = Box-fco - 8
         display wBar(1:21) at line wlin col wcol :BCOL: wBco :FCOL: wFco highlight
     when Box-bco <= 7 and Box-fco <= 7
         compute wBco = Box-bco
         compute wFco = Box-fco
         display wBar(1:21) at line wlin col wcol :BCOL: wBco :FCOL: wFco
  end-evaluate
  continue.
Display-wBarSEx. exit.

Display-LegendB.
  evaluate true
     when Box-bco > 7 and Box-fco >  7
         compute wBco = Box-bco - 8
         compute wFco = Box-fco - 8
         display 'Cursor,PgUP/Dn,+/-' at line wlin col wcol :BCOL: wBco :FCOL: wFco blink highlight
      when Box-bco > 7 and Box-fco <= 7
         compute wBco = Box-bco - 8
         compute wFco = Box-fco
         display 'Cursor,PgUP/Dn,+/-' at line wlin col wcol :BCOL: wBco :FCOL: wFco blink
     when Box-bco <= 7 and Box-fco >  7
         compute wBco = Box-bco
         compute wFco = Box-fco - 8
         display 'Cursor,PgUP/Dn,+/-' at line wlin col wcol :BCOL: wBco :FCOL: wFco highlight
     when Box-bco <= 7 and Box-fco <= 7
         compute wBco = Box-bco
         compute wFco = Box-fco
         display 'Cursor,PgUP/Dn,+/-' at line wlin col wcol :BCOL: wBco :FCOL: wFco
  end-evaluate
  continue.
Display-LegendBEx. exit.

Display-LegendS.
  evaluate true
     when Box-bco > 7 and Box-fco >  7
         compute wBco = Box-bco - 8
         compute wFco = Box-fco - 8
         display 'Cur,PgUpDn,+/-' at line wlin col wcol :BCOL: wBco :FCOL: wFco blink highlight
      when Box-bco > 7 and Box-fco <= 7
         compute wBco = Box-bco - 8
         compute wFco = Box-fco
         display 'Cur,PgUpDn,+/-' at line wlin col wcol :BCOL: wBco :FCOL: wFco blink
     when Box-bco <= 7 and Box-fco >  7
         compute wBco = Box-bco
         compute wFco = Box-fco - 8
         display 'Cur,PgUpDn,+/-' at line wlin col wcol :BCOL: wBco :FCOL: wFco highlight
     when Box-bco <= 7 and Box-fco <= 7
         compute wBco = Box-bco
         compute wFco = Box-fco
         display 'Cur,PgUpDn,+/-' at line wlin col wcol :BCOL: wBco :FCOL: wFco
  end-evaluate
  continue.
Display-LegendSEx. exit.

AcceptDummy.
   *> use same fore & back color
   evaluate true
     when Dtp-bco > 7 and Dtp-fco >  7
         compute wBco = Dtp-Bco - 8
         compute wFco = Dtp-Fco - 8
         accept wDummy at line wDtp-r1 col wDtp-c1
              auto-skip prompt character is wPrompt :BCOL: wBco :FCOL: wBco blink highlight
     when Dtp-bco > 7 and Dtp-fco <= 7
         compute wBco = Dtp-Bco - 8
         compute wFco = Dtp-Fco
         accept wDummy at line wDtp-r1 col wDtp-c1
              auto-skip prompt character is wPrompt :BCOL: wBco :FCOL: wBco blink
     when Dtp-bco <= 7 and Dtp-fco > 7
         compute wBco = Dtp-Bco
         compute wFco = Dtp-Fco - 8
         accept wDummy at line wDtp-r1 col wDtp-c1
              auto-skip prompt character is wPrompt :BCOL: wBco :FCOL: wBco highlight
     when Dtp-bco <= 7 and Dtp-fco <= 7
         compute wBco = Dtp-Bco
         compute wFco = Dtp-Fco
         accept wDummy at line wDtp-r1 col wDtp-c1
              auto-skip prompt character is wPrompt :BCOL: wBco :FCOL: wBco
  end-evaluate
  continue.
AcceptDummyEx. exit.

End Program GC56DATEPICKER.
