IDENTIFICATION DIVISION.
PROGRAM-ID. GC56DATEPICKER is initial.
*> ***********************************************************************************
*> GnuCOBOL TT (TUI TOOLS) COLLECTION
*> Purpose:    DATEPICKER: DISPLAY A CALENDAR & LET THE USER PICK UP A DATE - RETURNS DATE TO CALLER
*> Tectonics:  cobc -m GC56DATEPICKER.COB  (use GnuCOBOL 2.0 or greater)
*> Usage:      call GC56DATEPICKER using DatePicker-Area
*> Parameters: look at GC56DATEPICKER.cpy  (use with copy Version: 1.0 2016.06.15)
*> Author:     Eugenio Di Lorenzo - Italia (DILO)  - baseed on jrls (John Ellis) 05-Sept-2008 program
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

01  w3D       pic x(03)  value 'NRE'.
01  w3        pic 9(01)  value 0.
01  wBorder   pic x(07)  value 'SD123NC'.
01  wB        pic 9(01) value 0.
01  wFlipFlop pic 9(01) value 0.
01  wR        pic 9(01).
01  wInd      pic 9(03).
01  wlin      pic 9(03).
01  wcol      pic 9(03).
01  wDate.
    05 wDateAAAA       pic 9(4).
    05 wDateMM         pic 99.
    05 wDateGG         pic 99.
01 wDateGGx.
   05 filler             pic x(01) value space.
   05 wDateGG2           pic zz.

01  wBar             Pic x(28) value ALL X"C4".
01  result           usage binary-long.
01  wresult          pic S9(8).
01  wVisibilityNew   BINARY-SHORT . *> SIGNED.
01  wVisibilityOld   BINARY-SHORT . *> SIGNED.
01  wVisibilityNew9  pic 9(8).
01  wVisibilityOld9  pic 9(8).

01  date-a pic 9(08)  value zero.
01  date-aR redefines date-a.
    05 date-aRAAAA    pic 9(4).
    05 date-aRMM      pic 9(2).
    05 date-aRGG      pic 9(2).

01  date-s.
    05 date-s-ym    pic 9(06).
    05 filler       pic 9(02) value 1.
01  startdate redefines date-s pic 9(8).
01  date-s2   redefines date-s.
    05 ds-year        pic 9(4).
    05 ds-month       pic 99.
    05 ds-day         pic 99.

01  daysub pic 99.  *> from 1 to 42
01  wksub  pic 9.   *> from 1 to 6
01  date-c pic 9(08).
01  day-s  pic 99.

01  wscurrent.
    05 cdate    pic 9(8).
    05 filler   pic x(20).

*> ***********************************************************************************************
*> Table of 6 rows (weeks) x 7 cols (days of the week)
*> ***********************************************************************************************
01  calendar.
    05 cmonth.
       10  mday        pic 9(8) value zero occurs 42 times indexed by i.
    05 cweek redefines cmonth occurs 6.
       10  cday        pic 9(8) occurs  7 times.
    05 cdays redefines cmonth   occurs 42 times.
       10 cdays-ym     pic 9(6).
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
       10 weekday2      pic zzz value zero.
       *> 10 filler     pic x   value space.

01  months.
    05 filler        pic x(15) value "January".
    05 filler        pic x(15) value "February".
    05 filler        pic x(15) value "March".
    05 filler        pic x(15) value "April".
    05 filler        pic x(15) value "May".
    05 filler        pic x(15) value "June".
    05 filler        pic x(15) value "July".
    05 filler        pic x(15) value "August".
    05 filler        pic x(15) value "September".
    05 filler        pic x(15) value "October".
    05 filler        pic x(15) value "November".
    05 filler        pic x(15) value "December".
01  months2 redefines months.
    05 wmonth        pic x(15) occurs 12 times.

01  months-IT.
    05 filler        pic x(15) value "Gennaio".
    05 filler        pic x(15) value "Febbraio".
    05 filler        pic x(15) value "Marzo".
    05 filler        pic x(15) value "Aprile".
    05 filler        pic x(15) value "Maggio".
    05 filler        pic x(15) value "Giugno".
    05 filler        pic x(15) value "Luglio".
    05 filler        pic x(15) value "Agosto".
    05 filler        pic x(15) value "Settembre".
    05 filler        pic x(15) value "Ottobre".
    05 filler        pic x(15) value "Novembre".
    05 filler        pic x(15) value "Dicembre".

01  months-EN.
    05 filler        pic x(15) value "January".
    05 filler        pic x(15) value "February".
    05 filler        pic x(15) value "March".
    05 filler        pic x(15) value "April".
    05 filler        pic x(15) value "May".
    05 filler        pic x(15) value "June".
    05 filler        pic x(15) value "July".
    05 filler        pic x(15) value "August".
    05 filler        pic x(15) value "September".
    05 filler        pic x(15) value "October".
    05 filler        pic x(15) value "November".
    05 filler        pic x(15) value "December".

01  wDayDes     Pic x(28) value "Sun Mon Tue Wed Thu Fri Sat ".
01  wDayDes-EN  Pic x(28) value "Sun Mon Tue Wed Thu Fri Sat ".
01  wDayDes-IT  Pic x(28) value "Dom Lun Mar Mer Gio Ven Sab ".
01  wDayDesS     Pic x(21) value " Su Mo Tu We Th Fr Sa".
01  wDayDesS-EN  Pic x(21) value " Su Mo Tu We Th Fr Sa".
01  wDayDesS-IT  Pic x(21) value " Do Lu Ma Me Gi Ve Sa".

COPY 'GC01BOX.CPY'.

LINKAGE SECTION.
COPY 'GC56DATEPICKER.CPY'.

*> ***********************************************************************************
*>           P R O C E D U R E   D I V I S I O N
*> ***********************************************************************************
PROCEDURE DIVISION using DatePicker-Area.
*> sets in order to detect the PgUp, PgDn, PrtSc(screen print), Esc keys,
set environment 'COB_SCREEN_EXCEPTIONS' TO 'Y'.
set environment 'COB_SCREEN_ESC'        TO 'Y'.



if Dtp-DateSel = space
   move function current-date to wscurrent
else
   move Dtp-DateSel to cdate
end-if

move cdate to date-a.

0100-start.
*> ***********************************************************************************
*> Display fixed data on screen
*> ***********************************************************************************
    initialize Box-area ALL TO VALUE
    move Dtp-r1c1     to Box-r1c1
    compute Box-r2 = Box-r1 + 11
    evaluate true
       when Dtp-Dim = 'N' compute Box-c2 = Box-c1 + 29
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

    compute wCol = Box-c1 + 1
    compute wlin = Box-r1 + 2
    evaluate true
       when Dtp-Dim = 'N' DISPLAY wBar       at line wLin col wCol with background-color Box-Bco foreground-color Box-Fco highlight end-display
       when Dtp-Dim = 'S' DISPLAY wBar(1:21) at line wLin col wCol with background-color Box-Bco foreground-color Box-Fco highlight end-display
    end-evaluate

    compute wlin = Box-r1 + 3
    evaluate true
       when Dtp-Dim = 'N' display wDayDes  at line wLin col wCol with background-color Box-Bco foreground-color Box-Fco highlight end-display
       when Dtp-Dim = 'S' display wDayDesS at line wLin col wCol with background-color Box-Bco foreground-color Box-Fco highlight end-display
    end-evaluate

    compute wlin = Box-r1 + 4
    evaluate true
       when Dtp-Dim = 'N' DISPLAY wBar       at line wLin col wCol with background-color Box-Bco foreground-color Box-Fco highlight end-display
       when Dtp-Dim = 'S' DISPLAY wBar(1:21) at line wLin col wCol with background-color Box-Bco foreground-color Box-Fco highlight end-display
    end-evaluate

    *> hide the cursor
    move 0 to wVisibilityNew
    call static "curs_set" using by value wVisibilityNew returning wVisibilityOld end-call

    *> display "Enter date AAAAMMGG or 0 to get current day>>" with no advancing.
    *> accept date-a.
    *> if date-a = 0
       *> move function current-date to wscurrent
       *> move cdate to date-a
       *>  end-if
       .
0100-start2.

    initialize calendar all to value
    compute date-s-ym = date-a / 100.
    compute date-c = function integer-of-date(startdate).
    compute day-s  = function mod(date-c,7).
    perform 0110-loadCalendar  thru 0110-loadCalendarEx
    perform 0120-writeCalendar thru 0120-writeCalendarEx

*> ***********************************************************************************
*> DISPLAY "CURSOR " ON CALENDAR DATE
*> ***********************************************************************************
    set i to 1
    search mday  varying i
           at end
                *> display wresult
                if wresult = 77  *>  --> cursor right
                   compute date-aRGG = 1
                   compute date-aRMM = date-aRMM + 1
                   if date-aRMM > 12
                      compute date-aRAAAA = date-aRAAAA + 1
                      move 1 to date-aRMM
                   end-if
                end-if

                if wresult = 75  *> <-- curso left
                   compute date-aRMM = date-aRMM - 1
                   if date-aRMM < 1
                      compute date-aRAAAA = date-aRAAAA - 1
                      move 12 to date-aRMM
                   end-if
                   evaluate true
                           when date-aRMM = 1 or 3 or 5 or 7 or 8 or 10 or 12
                                 compute date-aRGG = 31
                           when date-aRMM = 4 or 6 or 9 or 11
                                 compute date-aRGG = 30
                           when date-aRMM = 2
                                 compute date-aRGG = 28
                   end-evaluate
                end-if

                go to 0100-start2

           when mday(i) = date-a
                go to end-search1

    end-search
    .
end-search1.
    move i to wInd

    *> mday(i) contains the date "active"
    move mday(i)  to wDate
    move wDateGG  to wDateGG2
    divide i by 7
           giving    wLin rounded mode is truncation
           remainder wCol end-divide

    *> if remainder = 0
    if wCol = 0
       compute wCol = 7
       compute wLin = wLin - 1
    end-if

    *> ************************************************************************************************************
    *> DISPLAY THE "CURSOR" ON CALENDAR
    *> ************************************************************************************************************
    compute wLin = Box-r1 + 4 + wLin + 1
    evaluate true
       when Dtp-Dim = 'N' compute wCol = Box-c1 + ( (4 * wCol) - 3)
                          display wDateGGx at line wLin col wCol with background-color Box-Fco foreground-color red highlight end-display
       when Dtp-Dim = 'S' compute wCol = Box-c1 + ( (3 * wCol) - 3) + 1
                          display wDateGGx(1:3) at line wLin col wCol with background-color Box-Fco foreground-color red highlight end-display
    end-evaluate

*> ***********************************************************************************
*> WAIT FOR A KEY
*> ***********************************************************************************
    call static "getch" returning result end-call
    move result to wresult.

    *> display "key pressed: "  at 2501 with background-color 01 foreground-color 07 end-display
    *> display     wresult      at 2515 with background-color 01 foreground-color 07 end-display

    EVALUATE TRUE

    *> 81=PgDn or 32=Space Bar or Tab
    when wresult = 81 or 32 or 09
         compute date-aRMM = date-aRMM + 1
         if date-aRMM > 12
            compute date-aRAAAA = date-aRAAAA + 1
            move 1 to date-aRMM
         end-if

     *> 73=PgUp
     when wresult = 73
         compute date-aRMM = date-aRMM - 1
         if date-aRMM < 1
            compute date-aRAAAA = date-aRAAAA - 1
            move 12 to date-aRMM
         end-if

     *> 77=Cursor right -->
     when wresult = 77
          if mday(i) = 0
             set i to 1
             compute date-aRMM = date-aRMM + 1
             if date-aRMM > 12
                compute date-aRAAAA = date-aRAAAA + 1
                move 1 to date-aRMM
             end-if
          else
             compute date-aRGG = date-aRGG + 1
          end-if

     *> 77=Cursor left  <--
     when wresult = 75
         compute date-aRGG = date-aRGG - 1

     *> 80= Cursor down
     when wresult = 80
            set i up by 7
            move i to Wind
            if i > 42 or mday(i) = 0
             set i to 1
             compute date-aRMM = date-aRMM + 1
             if date-aRMM > 12
                compute date-aRAAAA = date-aRAAAA + 1
                move 1 to date-aRMM
             end-if
             if date-aRGG = 31 and date-aRMM = 04 or 06 or 09 or 11 move 30 to date-aRGG end-if
             if (date-aRGG = 31 or 30 or 29) and date-aRMM = 02                   move 28 to date-aRGG end-if
          else
             compute date-aRGG = date-aRGG + 7
          end-if

     *> 72= Cursor up
     when wresult = 72
          set i down by 7
          if i < 0 or mday(i) = 0
             set i to 1
             compute date-aRMM = date-aRMM - 1
             if date-aRMM < 1
                compute date-aRAAAA = date-aRAAAA - 1
                move 12 to date-aRMM
             end-if
           else
              compute date-aRGG = date-aRGG - 7
           end-if

    *> + = next year
    when wresult = 43
            compute date-aRAAAA = date-aRAAAA + 1

    *> - = previous year
    when wresult = 45
            compute date-aRAAAA = date-aRAAAA - 1

     *> 71= Home - do to pick up current date
     when wresult = 71
          move function current-date to wscurrent
          move cdate to date-a

     *> 84= F1 change Fore Color
     when wresult = 84
         add 1 to Dtp-Fco Dtp-titFco
         If Dtp-Fco > 7 move 0 to Dtp-Fco Dtp-titFco end-if
         go to 0100-start

     *> 85= F2 change Back Color
     when wresult = 85
         add 1 to Dtp-Bco Dtp-titBco
         If Dtp-Bco > 7 move 0 to Dtp-Bco Dtp-titBco end-if
         go to 0100-start

     *> 86= F3 change borders
     when wresult = 86
         add 1 to wB  if wB > 6 move 1 to wB end-if
         move wBorder (wB:1) to Dtp-Style
         go to 0100-start

     *> 87= F4 toggle title
     when wresult = 87
         if wFlipFlop = 0
            move 1 to wFlipFlop
            move "N" to Dtp-tit
         else
            move 0 to wFlipFlop
            move "Y" to Dtp-tit
         end-if
         go to 0100-start

     *> 88= F5 toggle shadow
     *> (warning to eliminate shadow you have to restore backgroud after saved !)
     when wresult = 88
         if wFlipFlop = 0
            move 1 to wFlipFlop
            move "N" to Dtp-shadow
         else
            move 0 to wFlipFlop
            move "Y" to Dtp-shadow
         end-if
         go to 0100-start

     *> 89= F6 toggle Language EN / IT
     when wresult = 89
         compute wlin = Box-r1 + 3
         compute wCol = Box-c1 + 1
         if wFlipFlop = 0
            move 1 to wFlipFlop
            move months-IT   to months
            evaluate true
               when Dtp-Dim = 'N' move wDayDes-IT  to wDayDes
               when Dtp-Dim = 'S' move wDayDesS-IT to wDayDesS
            end-evaluate
         else
            move 0 to wFlipFlop
            move months-EN   to months
            evaluate true
               when Dtp-Dim = 'N' move wDayDes-EN   to wDayDes
               when Dtp-Dim = 'S' move wDayDesS-EN  to wDayDesS
            end-evaluate
         end-if

         evaluate true
            when Dtp-Dim = 'N' display wDayDes  at line wLin col wCol with background-color Box-Bco foreground-color Box-Fco highlight end-display
            when Dtp-Dim = 'S' display wDayDesS at line wLin col wCol with background-color Box-Bco foreground-color Box-Fco highlight end-display
         end-evaluate

         go to 0100-start2

     *> 90= F7 toggle 3D
     when wresult = 90
         add 1 to w3  if w3 > 3 move 1 to w3 end-if
         move w3D(w3:1) to Dtp-3D
         go to 0100-start

     *> 27= Escape
     when wresult = 27
         move wDate   to Dtp-DateSel
         move wResult to Dtp-Key
         go to End-Program

     *> 13= Enter
     when wresult = 13
         move wDate   to Dtp-DateSel
         move wResult to Dtp-Key
         *> display ' Date Selected = ' Dtp-DateSel accept omitted
         go to End-Program

     END-EVALUATE.

     *> loop to display new day / new month
     go to 0100-start2.

End-Program.
    *> show the cursor
    move 2 to wVisibilityNew
    call static "curs_set" using by value wVisibilityNew returning wVisibilityOld end-call
  goback.


*> ***************************************************************************************************
0110-loadCalendar.
    compute daysub = day-s + 1.
    perform varying daysub from daysub by 1 until daysub > 42
       compute mday(daysub) = function date-of-integer(date-c)
       if cdays-ym(daysub) <> date-s-ym
          move 0     to mday(daysub)
          move 43    to daysub
       end-if
       add 1         to date-c
    end-perform.
0110-loadCalendarEx. exit.

0120-writeCalendar.
*> ***********************************************************************************
*> Display variable data on screen
*> ***********************************************************************************
    compute wlin = Box-r1 + 1
    compute wCol = Box-c1 + 1
    display wmonth(ds-month)    at line wLin col wCol with background-color Box-Bco foreground-color Box-Fco highlight
    compute wCol = Box-c2 - 4
    display ds-year             at line wLin col wCol with background-color Box-Bco foreground-color Box-Fco highlight end-display
    perform varying wksub from 1 by 1 until wksub > 6
        perform varying daysub from 1 by 1 until daysub > 7
                if cday(wksub, daysub) = 0
                   move zero    to weekday(daysub)
                else
                   compute weekday(daysub) = function mod (cday(wksub, daysub), 100)
                end-if
        end-perform
        compute wlin = Box-r1 +  wksub  + 4
        compute wcol = Box-c1 + (daysub * 2) - 15
        *> display out-week  at line wLin col wCol with background-color Box-Bco foreground-color Box-Fco highlight end-display

       perform  varying wR from 1 by 1 until wR >  7
            move owday(wR) to owday2(wR)
       end-perform

        evaluate true
           when Dtp-Dim = 'N' display out-week  at line wLin col wCol with background-color Box-Bco foreground-color Box-Fco highlight end-display
           when Dtp-Dim = 'S'
                perform  varying wR from 1 by 1 until wR = 7
                    move owday(wR) to owday2(wR)
                end-perform
                display out-week2 at line wLin col wCol with background-color Box-Bco foreground-color Box-Fco highlight end-display
        end-evaluate

    end-perform.

        evaluate true
           when Dtp-Dim = 'N' compute wCol = Box-C2 - 8
           when Dtp-Dim = 'S' compute wCol = Box-C2 - 7
        end-evaluate
*>     compute wCol = Box-C2 - 8
    display 'PgUp/Dn' at line wLin col wCol with background-color Box-Bco foreground-color Box-Fco highlight end-display
    *> display 'daysub ' daysub
    *> display 'cmonth' at 2101
            *> cmonth   at 2109 with background-color 01 foreground-color 07 end-display
    .
0120-writeCalendarEx. exit.

End Program GC56DATEPICKER.
