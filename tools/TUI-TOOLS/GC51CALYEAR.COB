       >>SOURCE FORMAT IS FREE
IDENTIFICATION DIVISION.
program-id. GC51CALYEAR.
*> ***********************************************************************************
*> GnuCOBOL TT (TUI TOOLS)
*> Purpose:   DISPLAY CALENDAR AND LET THE USER PICK UP A DATE
*>  - display an entire year calendar on screen (12 months)
*>  - position a cursor on date received from caller or date of the day
*>  - return to caller the date selected by the user
*> set the "cursor" on the date specified in the fields of this copy.
*> if in these fields there is zero then it positions on current day.
*> Allows the selection of a date by moving the cursor.
*> Key up / down scroll 1 day, Key left / Right scroll 1 month,
*> Page up / down scroll 1 year.
*> <enter>, <space>, <esc> return to the caller the the selected date.
*>
*> Tectonics:  cobc -m GC51CALYEAR.COB
*> Usage:      call "GC51CALYEAR" using CALENDAR-AREA
*> Parameters: look at GC51CALYEAR.cpy
*> Author:     Eugenio Di Lorenzo - Italia
*> License:    Copyright 2016 E.Di Lorenzo - GNU General Public License, 3.0 (or greater)
*> Version:    1.2 20.02.2017
*> Changelog:  1.1 extended to manage 6 languages EN IT FR ES DE NL
*>             1.2 colors moved to copy, addeda F1 F2 F6
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
01  K-ENTER    constant as 0000.
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
01  K-F1       constant as 1001.
01  K-F2       constant as 1002.
01  K-F6       constant as 1006.

01  W-KEY PIC 9(4) VALUE 9999.

01  DD           pic  9(01).
01  dummy        pic  X(01) value space.
01  WS-YEAR.
   03               pic x(4) value "  > ".
   03 comodo-YYYY   pic 9(4).
   03               pic x(4) value " <  ".
01  WS-LANG.
   03               pic x(1) value "(".
   03 comodo-LANG   pic X(2).
   03               pic x(1) value ")".

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

*> a table with all one year calendar
01  tb.
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

01  iKK            pic s9(02) comp-5 value  0.
01  i              pic s9(02) comp-5 value  0.
01  j              pic s9(02) comp-5 value  0.
01  wInt           pic 9(02) value 0.
01  wInd           pic 9(02) value 0.
01  wkCom          pic 9(07)v9(03).
01  wkDay          pic 9(01).
01  wkP1           pic 9(02).
01  wkP2           pic 9(02).

01  wDesDate       pic x(32).


01 wkDIV   pic 9(9) value zero.
01 wkREM   pic 9(9) value zero.

01  value "312831303130313130313031".
   03 wkGmax       pic 9(02) occurs 12.

01  WGIORNI1      . *> value "Lunedi    Martedi   Mercoledi Giovedi   Venerdi   Sabato    Domenica  ".
    03 wkNomeG    pic x(10) occurs 07.
01  WGIORNI       . *> value "LunMarMerGioVenSabDom".
    03 wkNomeGA   pic x(03) occurs 07.
01  WMESIL        . *> value "Gennaio   Febbraio  Marzo     Aprile    " &
                    *>    "Maggio    Giugno    Luglio    Agosto    " &
                    *>     "Settembre Ottobre   Novembre  Dicembre  " .
    03 wkNomeM    pic x(10) occurs 12.

01  WGIORNIEN  PIC X(021) value "MonTueThuWedFriSatSun".
01  WGIORNI1EN PIC X(070) value "Monday    Tuesday   Wednesday "           &
                                "Thursday  Friday    Saturday  Sunday   ".
01  WMESILEN   PIC X(120) value "January   February  March     April     " &
                                "May       June      July      August    " &
                                "September October   November  December  ".

01  WGIORNIIT  PIC X(021) value "LunMarMerGioVenSabDom".
01  WGIORNI1IT PIC X(070) value "Lunedi    Martedi   Mercoledi "          &
                                "Giovedi   Venerdi   Sabato    Domenica  ".
01  WMESILIT   PIC X(120) value "Gennaio   Febbraio  Marzo     Aprile   " &
                                "Maggio    Giugno    Luglio    Agosto   " &
                                "Settembre Ottobre   Novembre  Dicembre ".

01  WGIORNIFR  PIC X(021) value "LunMarMerJeuVenSamDim".
01  WGIORNI1FR PIC X(070) value "Lundi     Mardi     Mercredi  "           &
                                "Jeudi     Vendredi  Samedi    Dimanche  ".
01  WMESILFR   PIC X(120) value "Janvier   Fevrier   Mars      Avril     " &
                                "Mai       Juin      Juillet   Aout      " &
                                "Septembre Octobre   Novembre  Decembre  ".

01  WGIORNIES  PIC X(021) value "LunMarMieJueVieSabDom".
01  WGIORNI1ES PIC X(070) value "Lunes     Martes    Miercoles "           &
                                "Jueves    Viernes   Sabado    Domingo   ".
01  WMESILES   PIC X(120) value "Enero     Febrero   Marzo     Abril     " &
                                "Mayo      Junio     Julio     Agosto    " &
                                "SeptiembreOctubre   Noviembre Diciembre ".

01  WGIORNIDE  PIC X(021) value "MonDieMitDonFreSamSon".
01  WGIORNI1DE PIC X(070) value "Montag    Dienstag  Mittwoch  "           &
                                "DonnerstagFreitag   Samstag   Sonntag   ".
01  WMESILDE   PIC X(120) value "Januar    Februar   Marz      April     " &
                                "Mai       Juni      Juli      August    " &
                                "September Oktober   November  Dezember  ".

01  WGIORNINL  PIC X(021) value "MaaDinWoeDonVriZatZon".
01  WGIORNI1NL PIC X(070) value "Maandag   Dinsdag   Woensdag  "           &
                                "Donderdag Vrijdag   Zaterdag  Zondag    ".
01  WMESILNL   PIC X(120) value "Januari   Februari  Maart     April     " &
                                "Mei       Juni      Juli      Augustus  " &
                                "September Oktober   November  December  ".

*> 01  WMESIC  value "GENFEBMARAPRMAGGIULUGAGOSETOTTNOVDIC".
   *> 03 wkNomeMA                  pic x(03) occurs 12.

*> **************************************************************
01  wkDate1.
   05 wkDD         pic 9(02).
   05 wkMM         pic 9(02).
   05 wkYY         pic 9(02).

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

01  Row01 pic x(74) value "??????????????????????????????????????????????????????????????????????????".
01  Row02 pic x(74) value "?                                                                        ?".
01  Row03 pic x(74) value "??????" & X"C2" & "?????" & X"C2" & "????" & X"C2" & "????" & X"C2" & "????"
                                   & X"C2" & "????"  & X"C2" & "????" & X"C2" & "????" & X"C2" & "????"
                                   & X"C2" & "????"  & X"C2" & "????" & X"C2" & "????" & X"C2" & "????"
                                   & X"C2" & "??????".
01  Row04 pic x(74) value "? gg  ? GEN ?FEB ?MAR ?APR ?MAG ?GIU ?LUG ?AGO ?SET ?OTT ?NOV ?DIC ? gg  ?".
01  Row05 pic x(74) value "??????????????????????????????????????????????????????????????????????????".
01  Row06 pic x(74) value "?     ?     ?    ?    ?    ?    ?    ?    ?    ?    ?    ?    ?    ?     ?".
01  Row07 pic x(74) value "??????????????????????????????????????????????????????????????????????????".

01  Row04EN pic x(74) value "? day ? JAN ?FEB ?MAR ?APR ?MAY ?JUN ?JUL ?AUG ?SEP ?OCT ?NOV ?DEC ? day ?".
01  Row04IT pic x(74) value "? gio ? GEN ?FEB ?MAR ?APR ?MAG ?GIU ?LUG ?AGO ?SET ?OTT ?NOV ?DIC ? gio ?".
01  Row04FR pic x(74) value "? jour? JAN ?FEV ?MAR ?AVR ?MAI ?JUI ?JUI ?AOU ?SEP ?OCT ?NOV ?DEC ? jour?".
01  Row04ES pic x(74) value "? dia ? ENE ?FEB ?MAR ?ABR ?MAY ?JUN ?JUL ?AGO ?SEP ?OCT ?NOV ?DIC ? dia ?".
01  Row04DE pic x(74) value "? tag ? JAN ?FEB ?MAR ?APR ?MAI ?JUN ?JUL ?AUG ?SEP ?OKT ?NOV ?DEZ ? tag ?".
01  Row04NL pic x(74) value "? dag ? JAN ?FEB ?MAA ?APR ?MEI ?JUN ?JUL ?AUG ?SEP ?OKT ?NOV ?DEC ? dag ?".


LINKAGE SECTION.
COPY "GC51CALYEAR.CPY".

*> **************************************************************
*>           P R O C E D U R E   D I V I S I O N
*> **************************************************************
PROCEDURE DIVISION using CALENDAR-AREA.
*> sets in order to detect the PgUp, PgDn, PrtSc(screen print), Esc keys,
set environment 'COB_SCREEN_EXCEPTIONS' TO 'Y'.
set environment 'COB_SCREEN_ESC'        TO 'Y'.

INIT.
*> ***********************************************************************************
*> This program displays 50 rows and 77 cols on screen so the screen size must be
*> changed from standard size of 25rows x 80 cols to a size of 50 rows x 80 cols.
*> ***********************************************************************************
  CALL "SYSTEM" USING "mode con: lines=50 cols=80"
  *> call static 'resize_term' using by value 50 80 returning wResult end-call

   *> perform DisplayConstants thru DisplayConstantsEx

   *> set "cursor" on that DATE
   if CaleDate = zero or CaleDate not numeric
      accept wCaleDate from DATE YYYYMMDD end-accept
      move wCaleYY to CaleYY
      move wCaleMM to CaleMM
      move wCaleDD to CaleDD
   end-if

   move CaleDD   to dos-DD
   move CaleMM   to dos-MM
   move CaleYY   to dos-YY
   *> save the date
   move dos-date to dataCur
   .
LOOP-MAIN1.
   perform DisplayConstants thru DisplayConstantsEx
   .
LOOP-MAIN.
   *> DISPLAY THE YEAR TITLE
   move dos-YY to Comodo-YYYY
   display WS-YEAR line 2 column 33 with foreground-color Calefco4 background-color Calebco4
   move 1     to dos-MM
   move space to tb
   *> DISPLAY LANGUAGE
   evaluate CaleLan
      when 1 move "EN" to comodo-LANG
      when 2 move "IT" to comodo-LANG
      when 3 move "FR" to comodo-LANG
      when 4 move "ES" to comodo-LANG
      when 5 move "DE" to comodo-LANG
      when 6 move "NL" to comodo-LANG
   end-evaluate
   display WS-LANG line 2 column 70 with foreground-color Calefco4 background-color Calebco4
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
    display "?????????????????????????????????????????????" line 46 column 17
            with foreground-color Calefco4 background-color Calebco4 highlight
    display "?  Cursor up/dn/left/right PageUp/Dn Enter  ?" line 47 column 17
            with foreground-color Calefco4 background-color Calebco4 highlight
    display "?????????????????????????????????????????????" line 48 column 17
            with foreground-color Calefco4 background-color Calebco4 highlight

   *> postioning cursor on the day of the date - posiziona il "cursore" sulla data del giorno
   perform SetCursorPosition thru SetCursorPositionEx
   perform HideCursor        thru HideCursorEx
   .
loop-ACCEPT.
   *> ********************************************************
   *> WAIT FOR A KEY AND PROCESSES ACTIONS
   *> ********************************************************
   accept dummy at 0101 with no-echo auto size 0 end-accept
   *> accept omitted with auto end-accept
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

   *> Pg Down = next year
   WHEN W-KEY = K-PAGEDOWN OR K-TAB
        compute dos-YY = dos-YY + 1  go loop-main

   *> Pg Up   = previous year
   WHEN W-KEY = K-PAGEUP OR K-BACKTAB
        compute dos-YY = dos-YY - 1  go loop-main

   *> F1 change background color
   WHEN W-KEY = K-F1
         add 1 to Calebco0 Calebco1 Calebco2 Calebco4
         if Calebco0 > 7 move 0 to Calebco0 Calebco1 Calebco2 Calebco4 end-if
         go loop-main1
   *> F2 change foreground color
   WHEN W-KEY = K-F2
         add 1 to Calefco1
         if Calefco1 > 7 move 0 to Calefco1 end-if
         go loop-main1
   *> F6 change language
   WHEN W-KEY = K-F6
         add 1 to Calelan
         if Calelan > 6 move 1 to Calelan end-if
         go loop-main1



   WHEN W-KEY = K-ENTER OR K-ESC go END-PROGRAM

   WHEN OTHER   go loop-main

   END-EVALUATE
   .
END-PROGRAM.


   *> RESTORE PREVIOUS SCREEN SIZE
   *> STRING "MODE CON: COLS=" wCOLUMNS " LINES=" wLINES into wCOMMAND.
   *> call "SYSTEM" USING wCOMMAND.

   perform ShowCursor thru ShowCursorEx
   goback.

*> **************************************************************
*>                 INTERNAL FUNCTIONS AREA
*> **************************************************************
*> DISPLAY SCREEN
DisplayConstants.

  EVALUATE CaleLan
      when 001
      move WGIORNIEN  TO WGIORNI
      move WGIORNI1EN TO WGIORNI1
      move WMESILEN   TO WMESIL
      move Row04EN    to Row04
      when 002
      move WGIORNIIT  TO WGIORNI
      move WGIORNI1IT TO WGIORNI1
      move WMESILIT   TO WMESIL
      move Row04IT    to Row04
      when 003
      move WGIORNIFR  TO WGIORNI
      move WGIORNI1FR TO WGIORNI1
      move WMESILFR   TO WMESIL
      move Row04FR    to Row04
      when 004
      move WGIORNIES  TO WGIORNI
      move WGIORNI1ES TO WGIORNI1
      move WMESILES   TO WMESIL
      move Row04ES    to Row04
      when 005
      move WGIORNIDE  TO WGIORNI
      move WGIORNI1DE TO WGIORNI1
      move WMESILDE   TO WMESIL
      move Row04DE    to Row04
      when 006
      move WGIORNINL  TO WGIORNI
      move WGIORNI1NL TO WGIORNI1
      move WMESILNL   TO WMESIL
      move Row04NL    to Row04
  END-EVALUATE

   display Row01 at line 01 col 02 with foreground-color Calefco1 background-color Calebco1
   display Row02 at line 02 col 02 with foreground-color Calefco1 background-color Calebco1
   display Row03 at line 03 col 02 with foreground-color Calefco1 background-color Calebco1
   display Row04 at line 04 col 02 with foreground-color Calefco1 background-color Calebco1
   display Row05 at line 05 col 02 with foreground-color Calefco1 background-color Calebco1
   display Row06 at line 06 col 02 with foreground-color Calefco1 background-color Calebco1

   perform varying i from 7 by 7 until i > 42 after j from 1 by 1 until j > 07
    move wkNomeGA(j) to Row06(3:3) Row06(70:3)
    compute ll = (i - 1) + j
    if j = 7 or j = 6      *> vertical lines saturday or sunday
       display Row06       line ll col 02 with foreground-color Calefco1 background-color Calebco1
       display wkNomeGA(j) line ll col 04 with foreground-color Calefco2 background-color Calebco2 highlight
       display wkNomeGA(j) line ll col 71 with foreground-color Calefco2 background-color Calebco2 highlight
    else                   *> vertical line non sunday . monday, tuesday, ....
       display Row06      line ll col 02 with foreground-color Calefco1 background-color Calebco1
    end-if
   end-perform
   *> penultimate line of the screen
   add 1 to ll
   initialize Row06 alphanumeric to value
   display Row06 at line ll col 02 with foreground-color Calefco1 background-color Calebco1
   *> last line of the screen
   add 1 to ll
   display Row07 line ll column 02 with foreground-color Calefco1 background-color Calebco1
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
                  with foreground-color Calefco5 background-color Calebco5 highlight
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
                  with foreground-color Calefco4 background-color Calebco4
     end-search.
SetCursorPositionEx. exit.

*> ******************************************************************************
*> Find which day of the week
*> ******************************************************************************
Find-TheDay.

*> This function converts date (a numeric integer data item or literal)
*> ? presumed to be a Gregorian calendar form
*> standard date (YYYYMMDD) - to integer date form ? that is,
*> the number of days that have transpired since 1600/12/31.xx

     DIVIDE FUNCTION INTEGER-OF-DATE(wkDateR) BY 7
            GIVING wkDIV REMAINDER wkREM
     EVALUATE wkREM
               WHEN 0 ADD 7 to wkREM    *> 'SUN'
               WHEN 1                   *> DISPLAY 'MON'
               WHEN 2                   *> DISPLAY 'TUE'
               WHEN 3                   *> DISPLAY 'WED'
               WHEN 4                   *> DISPLAY 'THU'
               WHEN 5                   *> DISPLAY 'FRI'
               WHEN 6 CONTINUE          *> DISPLAY 'SAT'
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
   *> reshow the cursor
    move 2 to wVisibilityNew
    call static "curs_set" using by value wVisibilityNew returning wVisibilityOld end-call.
ShowCursorEx. EXIT.

DisplayCursor.
  *> display a logical "cursor" on calendar dates
  if i = 7 or 14 or 21 or 28 or 35 or 42                  *> sundays
      or 6 or 13 or 20 or 27 or 34 or 41                  *> saturdays
   display DDdx line ll column cc
    with foreground-color Calefco2 background-color Calebco2 highlight   *> red
  else
   display DDdx line ll column cc                                *> other days
    with foreground-color Calefco0 background-color Calebco0
  end-if.
DisplayCursorEx. EXIT.
