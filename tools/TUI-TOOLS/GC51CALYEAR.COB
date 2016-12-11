       >>SOURCE FORMAT IS FREE
IDENTIFICATION DIVISION.
program-id. GC51CALYEAR.
*> ***********************************************************************************
*> GnuCOBOL TT (TUI TOOLS)
*> Purpose:   DISPLAY A YEAR CALENDAR AND LET THE USER PICK UP A DATE
*>  - display an entire year calendar on screen
*>  - position a cursor on date received from caller or date of the day
*>  - return date selected to caller
*> set the "cursor" on the date specified in the fields of this copy.
*> if in these fields there is zero then it positions on current day.
*> Allows the selection of a date by moving the cursor.
*> Key up / down scroll 1 day, Key left / Right scroll 1 month,
*> Page up / down scroll 1 year.
*> <enter>, <space>, <esc> return to the caller the the selected date.
*> Tectonics:  cobc -m GC51CALYEAR.COB
*> Usage:      call "GC51CALYEAR" using CALENDAR-AREA
*> Parameters: look at GC51CALYEAR.cpy
*> Author:     Eugenio Di Lorenzo - Italia
*> Date:       20160210 Modified: 2016-09-25/07:33-0400
*> License:    Copyright 2015 E.Di Lorenzo - GNU General Public License, 3.0 (or greater)
*> ***********************************************************************************
*> WARNING.
*> This program displays 50 rows and 77 cols on screen so the screen size must be
*> changed from standard size of 25rows x 80 cols to a size of 50 rows x 80 cols.
*> In a windows OS use following command "MODE CON: COLS=80 LINES=50"
*> ***********************************************************************************
ENVIRONMENT DIVISION.
CONFIGURATION SECTION.
    SPECIAL-NAMES.
    CRT STATUS IS W-KEY.
DATA DIVISION.
Working-Storage Section.

01 black   constant as 0.
01 blue    constant as 1.
01 green   constant as 2.
01 cyan    constant as 3.
01 red     constant as 4.
01 magenta constant as 5.
01 yellow  constant as 6.  *> or Brown
01 white   constant as 7.

*> Values that may be returned in CRT STATUS filed (or in COB-CRT-STATUS)
01  K-ENTER    constant as 0.
01  K-UP       constant as 2003.
01  K-DOWN     constant as 2004.
01  K-LEFT     constant as 2009.
01  K-RIGHT    constant as 2010.
01  K-ESC      constant as 2005.
01  K-PRINT    constant as 2006.
01  K-TAB      constant as 2007.
01  K-BACKTAB  constant as 2008.
01  K-PAGEUP   constant as 2001.
01  K-PAGEDOWN constant as 2002.

01  W-KEY PIC 9(4) VALUE 9999.

01  DD           pic  9(01).
01  dummy        pic  X(01) value space.
01  WS-YEAR.
   03               pic x(4) value "  > ".
   03 comodo-YYYY   pic 9(4).
   03               pic x(4) value " <  ".
01  dos-date.
   03 dos-YY    pic S9(4) comp-5.
   03 dos-MM    pic S9(4) comp-5.
   03 dos-DD    pic S9(4) comp-5.
01  dataCur.
   03 aaCur      pic S9(4) comp-5.
   03 mmCur      pic S9(4) comp-5.
   03 ddCur      pic S9(4) comp-5.

01  ddCom      pic S9(4) comp-5.

01  wCmdLine     pic x(121) VALUE SPACE.
01  wCOMMAND     pic  X(40) value space.
01  wSTRING      pic  X(60) value space.
01  wLINES       pic  9(03).
01  wCOLUMNS     pic  9(03).
01  wLINES2      pic  9(03).
01  wCOLUMNS2    pic  9(03).
01  wLINES3      pic  9(03).
01  wCOLUMNS3    pic  9(03).
01  ll           pic  9(03).
01  cc           pic  9(03).
01  bco0    pic 9(01) value white. *> bgr.col numbers calend
01  fco0    pic 9(01) value black. *> for.col numbers calend
01  bco1    pic 9(01) value white. *> bgr.col frame e dd
01  fco1    pic 9(01) value blue.  *> for.col frame e dd
01  bco2    pic 9(14) value white. *> bgr.col sunday & saturday
01  fco2    pic 9(01) value red.   *> bgr.col sunday & saturday
01  bco4    pic 9(01) value white. *> bgr.col titolo anno e legenda tasti
01  fco4    pic 9(01) value red.   *> for.col titolo anno e legenda tasti
01  bco5    pic 9(01) value green. *> bgr.col cursor position
01  fco5    pic 9(01) value white. *> for.col cursor position

01  tb.                                          *> a table with all one year calendar
   03 tb-mesi  occurs 12 indexed by iMM.
      05 tb-DD occurs 42 indexed by iDD pic 99. *> 42 litle boxes x the days
01 DDdx.
  03              pic  x value space.
  03 DDd          pic z9 blank when zero.
  03              pic  x value space.

01 wVisibilityNew  BINARY-SHORT . *> SIGNED.
01 wVisibilityOld  BINARY-SHORT . *> SIGNED.
01 wVisibilityNew9  pic 9(8).
01 wVisibilityOld9  pic 9(8).
01 wResult     BINARY-SHORT.
01 wResult9     pic -9(4).
01  iKK pic s9(02) comp-5 value  0.
01  i   pic s9(02) comp-5 value  0.
01  j   pic s9(02) comp-5 value  0.
01  wInt           pic 9(02) value 0.
01  wInd           pic 9(02) value 0.
01  wkCom          pic 9(07)v9(03).
01  wkDay          pic 9(01).
01  wkP1           pic 9(02).
01  wkP2           pic 9(02).
01  wDesDate       pic x(32).
01  wkDate.
   05 wkDD         pic 9(02).
   05 wkMM         pic 9(02).
   05 wkYY         pic 9(02).


01 wkDIV   pic 9(9) value zero.
01 wkREM   pic 9(9) value zero.

01  value "144025036146".
   03 wkV          pic 9(01) occurs 12.
01  value "312831303130313130313031".
   03 wkGmax       pic 9(02) occurs 12.
01  WGIORNI1             value "Lunedi   Martedi  MercolediGiovedi  Venerdi  Sabato   Domenica ".
   03 wkNomeG      pic x(09) occurs 07.
01  WGIORNI1EN PIC X(63) value "Monday   Tuesday  WednesdayThursday Friday   Saturday Sunday   ".
01  WGIORNI value "LunMarMerGioVenSabDom".
   03 wkNomeGA                  pic x(03) occurs 07.
01  WGIORNIEN PIC X(21) value "MonTueThuWedFriSatSun".

01  WMESIL               value "Gennaio  Febbraio Marzo    Aprile   " &
                              "Maggio   Giugno   Luglio   Agosto   " &
                              "SettembreOttobre  Novembre Dicembre ".
   03 wkNomeM                   pic x(09) occurs 12.
01  WMESILEN  PIC X(108) value "January  February March    April    " &
                              "May      June     July     August   " &
                              "SeptemberOctober  November December ".

01  WMESIC  value "GENFEBMARAPRMAGGIULUGAGOSETOTTNOVDIC".
   03 wkNomeMA                  pic x(03) occurs 12.

*> **************************************************************
01  wkDate.
   05 wkDateYYYY  pic 9(04).
   05 redefines wkDateYYYY.
      07          pic 9(02).
      07 wkDateYY pic 9(02).
   05 wkDateMM    pic 9(02).
   05 wkDateDD    pic 9(02).
01  wkDateR redefines wkDate PIC 9(8).

01 wCaleDate.
   05 wCaleYY           pic  9(04) value 0.
   05 wCaleMM           pic  9(02) value 0.
   05 wCaleDD           pic  9(02) value 0.

01  Row01 pic x(74) value "ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿".
01  Row02 pic x(74) value "³                                                                        ³".
01  Row03 pic x(74) value "ÃÄÄÄÄÄ" & X"C2" & "ÄÄÄÄÄ" & X"C2" & "ÄÄÄÄ" & X"C2" & "ÄÄÄÄ" & X"C2" & "ÄÄÄÄ"
                                   & X"C2" & "ÄÄÄÄ"  & X"C2" & "ÄÄÄÄ" & X"C2" & "ÄÄÄÄ" & X"C2" & "ÄÄÄÄ"
                                   & X"C2" & "ÄÄÄÄ"  & X"C2" & "ÄÄÄÄ" & X"C2" & "ÄÄÄÄ" & X"C2" & "ÄÄÄÄ"
                                   & X"C2" & "ÄÄÄÄÄ´".
01  Row04 pic x(74) value "³ gg  ³ GEN ³FEB ³MAR ³APR ³MAG ³GIU ³LUG ³AGO ³SET ³OTT ³NOV ³DIC ³ gg  ³".
01  Row05 pic x(74) value "ÃÄÄÄÄÄÅÄÄÄÄÄÅÄÄÄÄÅÄÄÄÄÅÄÄÄÄÅÄÄÄÄÅÄÄÄÄÅÄÄÄÄÅÄÄÄÄÅÄÄÄÄÅÄÄÄÄÅÄÄÄÄÅÄÄÄÄÅÄÄÄÄÄ´".
01  Row06 pic x(74) value "³     ³     ³    ³    ³    ³    ³    ³    ³    ³    ³    ³    ³    ³     ³".
01  Row07 pic x(74) value "ÀÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÁÄÄÄÄÁÄÄÄÄÁÄÄÄÄÁÄÄÄÄÁÄÄÄÄÁÄÄÄÄÁÄÄÄÄÁÄÄÄÄÁÄÄÄÄÁÄÄÄÄÁÄÄÄÄÄÙ".

01  Row04EN pic x(74) value "³ day ³ JAN ³FEB ³MAR ³APR ³MAY ³JUN ³JUL ³AUG ³SEP ³OCT ³NOV ³DEC ³ day ³".


LINKAGE SECTION.
COPY "GC51CALYEAR.CPY".

*> **************************************************************
*>           P R O C E D U R E   D I V I S I O N
*> **************************************************************
PROCEDURE DIVISION using CALENDAR-AREA.
*> sets in order to detect the PgUp, PgDn, PrtSc(screen print), Esc keys,
set environment 'COB_SCREEN_EXCEPTIONS' TO 'Y'.
set environment 'COB_SCREEN_ESC'        TO 'Y'.

INIZIO.
   *> ACCEPT wLINES   from LINES
   *> ACCEPT wCOLUMNS from COLUMNS
   *> STRING "1.INITIAL SCREEN SIZE - LINES=" wLINES " COLS=" wCOLUMNS into wSTRING.
   *> DISPLAY wSTRING AT 0101.
   *> ACCEPT OMITTED.

*> ***********************************************************************************
*> This program displays 50 rows and 77 cols on screen so the screen size must be
*> changed from standard size of 25rows x 80 cols to a size of 50 rows x 80 cols.
*> ***********************************************************************************
       *> move "MODE CON: LINES=60 COLS=90 " & X"00" TO wCmdLine
       *> *> DISPLAY "wCmdLine=     " AT 0101 wCmdLine AT 0115
       *> *> ACCEPT OMITTED
       *> CALL "SYSTEM"   using wCmdLine

       CALL "SYSTEM" USING "mode con: lines=50 cols=80"

    *> call static 'resize_term' using by value 50 80 returning wResult end-call

   *> ACCEPT wLINES   from LINES
   *> ACCEPT wCOLUMNS from COLUMNS
   *> STRING "2.SETTLED SCREEN SIZE - LINES=" wLINES " COLS=" wCOLUMNS into wSTRING.
   *> DISPLAY wSTRING AT 0501.
   *> ACCEPT OMITTED.


   move "EN" To CaleLan
   IF CaleLan = "EN"
      move WGIORNIEN  TO WGIORNI
      move WGIORNI1EN TO WGIORNI1
      move WMESILEN   TO WMESIL
      move Row04EN   to Row04
    END-IF

   perform DisplayConstants thru DisplayConstantsEx

   *> set "cursor" on that DATE
   if CaleDate = zero or CaleDate not numeric
    accept wCaleDate from DATE YYYYMMDD end-accept
    move wCaleYY to CaleYY move wCaleMM to CaleMM move wCaleDD to CaleDD
   end-if
   move CaleDD   to dos-DD
   move CaleMM   to dos-MM
   move CaleYY   to dos-YY
   move dos-date to dataCur           *> save the date
   .
LOOP-MAIN.
   *> DISPLAY THE YEAR TITLE
   move dos-YY to Comodo-YYYY
   display WS-YEAR line 2 column 33 with foreground-color fco4 background-color bco4
   move 1     to dos-MM
   move space to tb

   *> ********************************************************
   *> 12 MOTNTHS LOOP TO DISPLAY A ONE YEAR CALENDAR
   *> ********************************************************
   perform varying dos-MM from 1 by 1 until dos-MM > 12
      move 1      to dos-DD
      move dos-DD to wkDateDD
      move dos-MM to wkDateMM
      move dos-YY to wkDateYYYY
      perform Find-TheDay thru Find-TheDayEx
      move wkDay  to DD
      *> fill month elements = a screen column with calendar numbers
      compute cc = 6 + (5 * dos-MM) - 1
      *> load the table and display day of the month
      perform varying i from 1 by 1 until i > 42
          if i < DD or (i - DD) >= wkGmax(dos-MM)
             move zero  to tb-DD(dos-MM, i)
          else
             if i = 1                                                  *> if january the first is monday
                move 1 to tb-DD(dos-MM, i)
             else
                compute tb-DD(dos-MM, i) = tb-DD(dos-MM, i - 1) + 1
             end-if
          end-if

          compute ll = i + 6                                           *> line to display
          move    tb-DD(dos-MM i) to DDd
          perform DisplayCursor thru DisplayCursorEx
       end-perform
   end-perform
   *> ********************************************************
   *> END OF LOOP OF 12 MOTNTHS TO DISPLAY ALL CALENDAR

   *> DISPLAY A BOX WITH CONTROLS INSTRUCTIONS
    display "ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿" line 46 column 17
            with foreground-color fco4 background-color bco4 highlight
    display "³  Cursor up/dn/left/right PageUp/Dn Enter  ³" line 47 column 17
            with foreground-color fco4 background-color bco4 highlight
    display "ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ" line 48 column 17
            with foreground-color fco4 background-color bco4 highlight

   *> postioning cursor on the day of the date - posiziona il "cursore" sulla data del giorno
   perform SetCursorPosition thru SetCursorPositionEx
   perform HideCursor        thru HideCursorEx
   .
loop-ACCEPT.
   *> ********************************************************
   *> WAIT FOR A KEY AND PROCESSES ACTIONS
   *> ********************************************************
   accept dummy at 0101 with no-echo auto size 0 end-accept

   *> Warning ! before 1.1.1970 it doesn"t works (?!?)
   *> restores back and foreground of previous cursor position
   perform DisplayCursor thru DisplayCursorEx

   EVALUATE TRUE
    WHEN W-KEY = K-UP   *> cursor up
         compute ddCur = ddCur - 1
         if ddCur < 1
            compute mmCur = mmCur - 1
            if mmCur < 1
               move 12 to dos-MM mmCur
               perform SearchDD thru SearchDDex
               compute dos-YY = dos-YY - 1 go loop-main
            end-if
            perform SearchDD thru SearchDDex
         end-if
         perform SetCursorPosition thru SetCursorPositionEx
         go loop-ACCEPT

   WHEN W-KEY = K-DOWN   *> cursor down
        compute ddCur = ddCur + 1
        perform SearchDD2 thru SearchDD2ex
        if ddCur > ddCom
           compute mmCur = mmCur + 1
           move  1 to dos-DD ddCur
           if mmCur > 12
              move  1 to dos-MM mmCur
              compute dos-YY = dos-YY + 1 go loop-main
           end-if
        end-if
        perform SetCursorPosition thru SetCursorPositionEx
        go loop-ACCEPT

   WHEN W-KEY = K-RIGHT  *> cursor right ->
        compute mmCur = mmCur + 1
        if mmCur > 12
           move  1 to dos-MM mmCur
           compute dos-YY = dos-YY + 1 go loop-main
        end-if
        perform SetCursorPosition thru SetCursorPositionEx
        go loop-ACCEPT

   WHEN W-KEY = K-LEFT  *> cursor left <-
        compute mmCur = mmCur - 1
        if mmCur < 1
           move  12 to dos-MM mmCur
           compute dos-YY = dos-YY - 1 go loop-main
        end-if
        perform SetCursorPosition thru SetCursorPositionEx
        go loop-ACCEPT

   WHEN W-KEY = K-PAGEDOWN OR K-TAB                                *> Pg Down = next year
        compute dos-YY = dos-YY + 1  go loop-main

   WHEN W-KEY = K-PAGEUP OR K-BACKTAB                              *> Pg Up   = previous year
        compute dos-YY = dos-YY - 1  go loop-main

   WHEN W-KEY = K-ENTER OR K-ESC go END-PROGRAM

   WHEN OTHER   go loop-main

   END-EVALUATE
   .
END-PROGRAM.

   *> STRING "3.SCREEN SIZE ON EXIT - LINES=" wLINES " COLS=" wCOLUMNS into wSTRING.
   *> DISPLAY wSTRING AT 0301 WITH BLANK SCREEN
   *> ACCEPT OMITTED.


   *> RESTORE PREVIOUS SCREEN SIZE
   STRING "MODE CON: COLS=" wCOLUMNS " LINES=" wLINES into wCOMMAND.
        *> DISPLAY "wCOMMAND=     " AT 0101 wCOMMAND AT 0115
        *> ACCEPT OMITTED.
   call "SYSTEM" USING wCOMMAND.

   *> ACCEPT wLINES3   from LINES
   *> ACCEPT wCOLUMNS3 from COLUMNS
   *> STRING "4.RESTORED SCREEN SIZE- LINES=" wLINES3 " COLS=" wCOLUMNS3 into wSTRING.
   *> DISPLAY wSTRING AT 0401.
   *> ACCEPT OMITTED.

   *> display
              *> "Calendar Area: " at line 15 col 02 with bell
              *> Calendar-Area     at line 16 col 02

   perform ShowCursor thru ShowCursorEx
   goback.

*> **************************************************************
*>                 INTERNAL FUNCTIONS AREA
*> **************************************************************
*> DISPLAY SCREEN
DisplayConstants.
   display Row01 at line 01 col 02 with foreground-color fco1 background-color bco1
   display Row02 at line 02 col 02 with foreground-color fco1 background-color bco1
   display Row03 at line 03 col 02 with foreground-color fco1 background-color bco1
   display Row04 at line 04 col 02 with foreground-color fco1 background-color bco1
   display Row05 at line 05 col 02 with foreground-color fco1 background-color bco1
   display Row06 at line 06 col 02 with foreground-color fco1 background-color bco1

   perform varying i from 7 by 7 until i > 42 after j from 1 by 1 until j > 07
    move wkNomeGA(j) to Row06(3:3) Row06(70:3)
    compute ll = (i - 1) + j
    if j = 7 or j = 6      *> vertical lines saturday or sunday
       display Row06       line ll col 02 with foreground-color fco1 background-color bco1
       display wkNomeGA(j) line ll col 04 with foreground-color fco2 background-color bco2 highlight
       display wkNomeGA(j) line ll col 71 with foreground-color fco2 background-color bco2 highlight
    else                   *> vertical line non sunday . monday, tuesday, ....
       display Row06      line ll col 02 with foreground-color fco1 background-color bco1
    end-if
   end-perform
   *> penultimate line of the screen
   add 1 to ll
   initialize Row06 alphanumeric to value
   display Row06 at line ll col 02 with foreground-color fco1 background-color bco1
   *> last line of the screen
   add 1 to ll
   display Row07 line ll column 02 with foreground-color fco1 background-color bco1
   .
DisplayConstantsEx. exit.

SearchDD.                     *> how many days in the month ?
   evaluate mmCur
    when 02
         move dos-DD   to wkDateDD
         move dos-MM   to wkDateMM
         move dos-YY   to wkDateYYYY
         move wkDateYY to wkYY
         move wkDateMM to wkMM
         move wkDateDD to wkDD
         divide wkYY by 4 giving wkcom   *> picture with decimals
         divide wkYY by 4 giving wkP1    *> picture without decimals (only integers)
         if wkP1 = wkCom
            move 29 to ddCur dos-DD
         else
            move 28 to ddCur dos-DD
         end-if
    when 01 when 03 when 05 when 07 when 08 when 10 when 12
         move 31 to ddCur dos-DD
    when 04 when 06 when 09 when 11
         move 30 to ddCur dos-DD
   end-evaluate
   .
SearchDDex. exit.

SearchDD2.
   evaluate mmCur
    when 02
         move dos-DD to wkDateDD
         move dos-MM to wkDateMM
         move dos-YY to wkDateYYYY
         move wkDateYY        to wkYY
         move wkDateMM        to wkMM
         move wkDateDD        to wkDD
         divide wkYY by 4 giving wkcom   *> picture with decimals
         divide wkYY by 4 giving wkP1    *> picture without decimals
         if wkP1 = wkCom
            move 29 to ddCom dos-DD
         else
            move 28 to ddCom dos-DD
         end-if
    when 01 when 03 when 05 when 07 when 08 when 10 when 12
         move 31 to ddCom dos-DD
    when 04 when 06 when 09 when 11
         move 30 to ddCom dos-DD
   end-evaluate
   .
SearchDD2ex. exit.

*> ******************************************************************************
*> Display selected date, move selected date to field return to caller
*> ******************************************************************************
SetCursorPosition.
    set iDD to 1
    search tb-DD varying iDD
     at end                     *> happens when cursor is on 29 FEB & press pgup/down
        compute ddCur = ddCur - 1 go SetCursorPosition
     when tb-DD(mmCur, iDD) = ddCur
          set iKK to iDD
          move tb-DD(mmCur, iKK) to DDd
          compute ll = iKK + 6
          compute cc = 6 + (5 * mmCur) - 1
          display DDdx line ll column cc
                  with foreground-color fco5 background-color bco5 highlight
          move ddCur            to CaleDD
          move mmCur            to CaleMM
          move dos-YY           to CaleYY
          divide iKK by 7 giving wInt remainder wInd
          if wInd = 0    move 7 to wInd end-if
          move wkNomeG(wInd)    to CaleDay
          move wkNomeM(mmCur)   to CaleMonth
          *> display the selected day
          move space to wDesDate
          string "(" CaleDD "." CaleMM "." CaleYY " " CaleDay " " CaleMonth ")" delimited by "  " into wDesDate end-string
          display wDesDate line 45 column 25
                  with foreground-color fco4 background-color bco4
     end-search.
SetCursorPositionEx. exit.

*> ******************************************************************************
*> Find which day of the week with the "ZELLER FORMULA"
*> called every 1 of the month (12 times x year)
*> ******************************************************************************
Find-TheDay.
   *> move wkDateYY        to wkYY
   *> move wkDateMM        to wkMM
   *> move wkDateDD        to wkDD

   *> perform
      *> divide wkYY by 4 giving wkcom   *> picture with decimals
      *> divide wkYY by 4 giving wkP1    *> picture without decimals
      *> if wkP1 = wkCom
         *> move 29 to wkGmax(2) *> leap year - anno bisestile
      *> else
         *> move 28 to wkGmax(2) *> non leap year - anno non bisestile
      *> end-if

      *> add wkV(wkMM) wkDD wkYY  to wkP1
      *> if wkGmax(2) = 29 and (wkMM = 1 or wkMM = 2)
         *> subtract 1 from wkP1
      *> end-If
      *> divide wkP1 by 7 giving wkP2
      *> compute wkDay = wkP1 - (wkP2 * 7) + 1 *> 1=lun,2=mar...7=Dom

      *> *> warning ZELLER FORMULA gives tuesday=2 for 1.1.2000 instead of saturday(6)! how come ?
      *> if wkDateYYYY > 1999
         *> evaluate wkDay
           *> when 1 move 5 to wkDay
           *> when 2 move 6 to wkDay
           *> when 3 move 7 to wkDay
           *> when 4 move 1 to wkDay
           *> when 5 move 2 to wkDay
           *> when 6 move 3 to wkDay
           *> when 7 move 4 to wkDay
         *> end-evaluate
      *> end-if
   *> end-perform


*> This function converts date (a numeric integer data item or literal)
*> – presumed to be a Gregorian calendar form
*> standard date (YYYYMMDD) - to integer date form – that is,
*> the number of days that have transpired since 1600/12/31.

     DIVIDE FUNCTION INTEGER-OF-DATE(wkDateR) BY 7
            GIVING wkDIV REMAINDER wkREM
     EVALUATE wkREM
               WHEN 0 ADD 7 to wkREM *> 'SUN'
               WHEN 1          *> DISPLAY 'MON'
               WHEN 2          *> DISPLAY 'TUE'
               WHEN 3          *> DISPLAY 'WED'
               WHEN 4          *> DISPLAY 'THU'
               WHEN 5          *> DISPLAY 'FRI'
               WHEN 6 CONTINUE *> DISPLAY 'SAT'
       END-EVALUATE
       move wkREM to wkDay
   .
Find-TheDayEx. exit.

HideCursor.
   *> hide the cursor
    move 0 to wVisibilityNew
    call static "curs_set" using by value wVisibilityNew returning wVisibilityOld end-call
    move wVisibilityNew to wVisibilityNew9
    move wVisibilityOld to wVisibilityOld9
    .
HideCursorEx. EXIT.

ShowCursor.
   *> show the cursor
    move 2 to wVisibilityNew
    call static "curs_set" using by value wVisibilityNew returning wVisibilityOld end-call
   .
ShowCursorEx. EXIT.

DisplayCursor.
  *> display a logical "cursor" on calendar dates
  if i = 7 or 14 or 21 or 28 or 35 or 42                  *> sundays
      or 6 or 13 or 20 or 27 or 34 or 41                  *> saturdays
   display DDdx line ll column cc
    with foreground-color fco2 background-color bco2 highlight   *> red
  else
   display DDdx line ll column cc                         *> other days
    with foreground-color fco0 background-color bco0
  end-if
  .
DisplayCursorEx. EXIT.
