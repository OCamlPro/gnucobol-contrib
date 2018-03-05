            >>SOURCE FORMAT IS FREE
IDENTIFICATION DIVISION.
PROGRAM-ID.  GC53CALENDAR.
*> ***********************************************************************************
*> GnuCOBOL TT (TUI TOOLS) COLLECTION
*> Purpose:    DISPLAY A CALENDAR ON SCREEN
*> Tectonics:  cobc -x GC53CALENDAR.COB  (use GnuCOBOL 2.0 or greater)
*> Usage:      call GC53CALENDAR using Calendar-Area
*> Parameters: none
*> Author:     Eugenio Di Lorenzo - Italia (DILO) and source from Rosetta Code
*> License:    Copyright 2017 E.Di Lorenzo
*>             GNU Lesser General Public License, LGPL, 3.0 (or greater)
*> Version:    1.1 2018.03.10
*> Changelog:  1.0 first release.
*>             1.1 enhancements of color management
*> ***********************************************************************************
ENVIRONMENT DIVISION.
INPUT-OUTPUT SECTION.

DATA DIVISION.
WORKING-STORAGE SECTION.
*> Values that may be returned in CRT STATUS (or COB-CRT-STATUS)
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
78  K-NO-DATA     VALUE 8000.
78  K-TIMEOUT     VALUE 8001.

01  WS-DAY-NAMES-DEF.
    03 FILLER PIC X(09) VALUE 'SUNDAY   '.
    03 FILLER PIC X(09) VALUE 'MONDAY   '.
    03 FILLER PIC X(09) VALUE 'TUESDAY  '.
    03 FILLER PIC X(09) VALUE 'WEDNESDAY'.
    03 FILLER PIC X(09) VALUE 'THURSDAY '.
    03 FILLER PIC X(09) VALUE 'FRIDAY   '.
    03 FILLER PIC X(09) VALUE 'SATURDAY '.
01  FILLER REDEFINES WS-DAY-NAMES-DEF.
    03  WS-DAY-NAME       PIC X(09) OCCURS 07 TIMES.

01  WS-MTH-INFO-DEF.
    03 FILLER PIC X(11) VALUE 'JANUARY  31'.
    03 FILLER PIC X(11) VALUE 'FEBRUARY 28'.
    03 FILLER PIC X(11) VALUE 'MARCH    31'.
    03 FILLER PIC X(11) VALUE 'APRIL    30'.
    03 FILLER PIC X(11) VALUE 'MAY      31'.
    03 FILLER PIC X(11) VALUE 'JUNE     30'.
    03 FILLER PIC X(11) VALUE 'JULY     31'.
    03 FILLER PIC X(11) VALUE 'AUGUST   31'.
    03 FILLER PIC X(11) VALUE 'SEPTEMBER30'.
    03 FILLER PIC X(11) VALUE 'OCTOBER  31'.
    03 FILLER PIC X(11) VALUE 'NOVEMBER 30'.
    03 FILLER PIC X(11) VALUE 'DECEMBER 31'.
01  FILLER REDEFINES WS-MTH-INFO-DEF.
    03  WS-MTH-INFO-TABLE OCCURS 12 TIMES.
        05  WS-MTH-INFO-NAME   PIC X(09).
        05  WS-MTH-INFO-DAYS   PIC 9(02).

01  WS-MTH-AREA.
   03  WS-MTH-DD         PIC S99.
   03  WS-DAY1           PIC   9.
   03  WS-DAYS           PIC  99.
   03  WS-DD             PIC   9.
   03  WS-WK             PIC   9.
   03  WS-MM             PIC  99.
   03  WS-QQ             PIC  99.

   03  WS-MTH-MONTH        OCCURS 12 TIMES.
       05  WS-MTH-WEEK     OCCURS 6 TIMES.   *> 6 WEEKS FOR EACH MONTH
           07  WS-DAY-FLD  OCCURS 7 TIMES.
               09  WS-DAY  PIC ZZ.

01  INPDATE-RECORD.
    05  INPD-YEAR          PIC 9(04).
    05  FILLER             PIC X(01).
    05  INPD-MONTH         PIC 9(02).
    05  FILLER             PIC X(01).
    05  INPD-DAY           PIC 9(02).

01  WINPDATE-RECORD.
    05  WINPD-YEAR          PIC 9(04).
    05  WINPD-MONTH         PIC 9(02).
    05  WINPD-DAY           PIC 9(02).

01  WMS-DOW                PIC 9(01).
01  WS-PRT                 PIC X(132).
01  WS-COL                 PIC 9(03) VALUE 0.
01  WS-PP                  PIC 9(03) VALUE 0.
01  WS-CFGN.
    03  FILLER               PIC  9(03) VALUE  80.
    03  FILLER               PIC  9(02) VALUE  5.
    03  FILLER               PIC  9(01) VALUE  1.
    03  FILLER               PIC  9(02) VALUE  5.
    03  FILLER               PIC  9(01) VALUE  2.
01  WS-CFGW.
    03  FILLER               PIC  9(03) VALUE 120.
    03  FILLER               PIC  9(02) VALUE  10.
    03  FILLER               PIC  9(01) VALUE   2.
    03  FILLER               PIC  9(02) VALUE  10.
    03  FILLER               PIC  9(01) VALUE   3.
01  WS-CFG.
    03  WS-LS                PIC  9(03) VALUE 120.
    03  WS-LMAR              PIC  9(02) VALUE  10.
    03  WS-SPBD              PIC  9(01) VALUE   2.
    03  WS-SPBC              PIC  9(02) VALUE  10.
    03  WS-DNMW              PIC  9(01) VALUE   3.

01 I PIC 999 VALUE ZERO.
01 WS-TABLE-TEXT GLOBAL.
   03 WS-TABLE-TEXT-LINE OCCURS 100 PIC X(80).

01 W-KEY PIC 9999.


LINKAGE SECTION.
copy 'GC53CALENDAR.CPY'.


*> ***********************************************************************************
*>           P R O C E D U R E   D I V I S I O N
*> ***********************************************************************************
PROCEDURE DIVISION using Calendar-Area.

     ACCEPT WINPDATE-RECORD FROM DATE YYYYMMDD
     MOVE WINPD-YEAR  TO INPD-YEAR
     MOVE WINPD-MONTH TO INPD-MONTH
     MOVE WINPD-DAY   TO INPD-DAY
     .
INIZIO.

     MOVE WS-CFGN   TO WS-CFG
     IF  (FUNCTION MOD ( INPD-YEAR , 400 ) = 0
     OR  (FUNCTION MOD ( INPD-YEAR , 4   ) = 0
     AND  FUNCTION MOD ( INPD-YEAR , 100 ) NOT = 0))
          MOVE 29  TO WS-MTH-INFO-DAYS (02)
     ELSE
          MOVE 28  TO WS-MTH-INFO-DAYS (02)
     END-IF

     *> FILLS A TRHEE DIMENSION TABLE WITH NUMBERS OF DAYS OR ZERO.
     PERFORM VARYING WS-MM FROM 1 BY +1 UNTIL WS-MM > 12
             MOVE WS-MM TO INPD-MONTH
             CALL 'GC53DATE2DOW' USING INPDATE-RECORD, WMS-DOW END-CALL

             COMPUTE WS-MTH-DD = 1 - WMS-DOW
             COMPUTE WS-DAYS   = WS-MTH-INFO-DAYS (INPD-MONTH)
             *> 6 WEEK EACH MONTH
             PERFORM VARYING WS-WK FROM 1 BY +1 UNTIL WS-WK > 6
                     PERFORM VARYING WS-DD FROM 1 BY +1 UNTIL WS-DD > 7
                             COMPUTE WS-MTH-DD = WS-MTH-DD + 1
                             IF (WS-MTH-DD < 1) OR (WS-MTH-DD > WS-DAYS)
                                 MOVE 0         TO WS-DAY (WS-MM, WS-WK, WS-DD)
                             ELSE
                                 MOVE WS-MTH-DD TO WS-DAY (WS-MM, WS-WK, WS-DD)
                             END-IF
                     END-PERFORM
             END-PERFORM
     END-PERFORM

     ADD 1 TO I
     MOVE SPACE TO WS-TABLE-TEXT-LINE(I)

     *> *********************************************************************************
     *> LOOP FOR 4 QUARTERS (EACH OF TRHREE MONTHS)
     *> *********************************************************************************
     COMPUTE WS-MM = 0
     PERFORM VARYING WS-QQ FROM 1 BY +1 UNTIL WS-QQ > 4
             INITIALIZE WS-PRT
             COMPUTE WS-PP = 1

             *> *************************************************************************
             *> SET A ROW WITH DESCRIPTION OF THREE MONTHS
             *> *************************************************************************
             PERFORM VARYING WS-COL FROM 1 BY +1 UNTIL WS-COL > 3
                     COMPUTE WS-MM = 3 * (WS-QQ - 1) + WS-COL
                     IF WS-COL = 1
                        COMPUTE WS-PP = WS-PP + WS-LMAR + 2 - WS-DNMW
                     ELSE
                        COMPUTE WS-PP = WS-PP + WS-SPBC + 2 - WS-DNMW
                     END-IF
                     *> SET MONTHS DESCRIPTION
                     MOVE WS-MTH-INFO-NAME (WS-MM) TO WS-PRT(WS-PP:9)
                     COMPUTE WS-PP = WS-PP + ( 2 * 7 + WS-SPBD * 6 + WS-SPBD - 1) - 4
                     *> SET YEAR NUMBER
                     MOVE INPD-YEAR TO WS-PRT (WS-PP:4)
                     COMPUTE WS-PP = WS-PP + 4
             END-PERFORM
             ADD 1 TO I
             STRING 'M' WS-PRT (1:WS-LS) INTO WS-TABLE-TEXT-LINE(I)

             *> *************************************************************************
             *> SET A ROW WITH 7 DAYS DESCRIPTION  - (THREE MONTHS ON ONE ROW)
             *> *************************************************************************
             INITIALIZE WS-PRT
             COMPUTE WS-PP = 1
             PERFORM VARYING WS-COL FROM 1 BY +1 UNTIL WS-COL > 3
                     COMPUTE WS-MM = 3 * (WS-QQ - 1) + WS-COL
                     IF WS-COL = 1
                        COMPUTE WS-PP = WS-PP + WS-LMAR + 2 - WS-DNMW
                     ELSE
                        COMPUTE WS-PP = WS-PP + WS-SPBC + 2 - WS-DNMW
                     END-IF
                     *> SET 7 DAY DESCRIPTION THREE TIME ON ONE ROW
                     PERFORM VARYING WS-DD FROM 1 BY +1 UNTIL WS-DD > 7
                             IF WS-DD > 1
                                COMPUTE WS-PP = WS-PP + WS-SPBD + 2 - WS-DNMW
                             END-IF
                             MOVE WS-DAY-NAME (WS-DD) (1:WS-DNMW) TO WS-PRT (WS-PP:WS-DNMW)
                             COMPUTE WS-PP = WS-PP + WS-DNMW
                     END-PERFORM
             END-PERFORM
             ADD 1 TO I
             STRING 'W' WS-PRT (1:WS-LS) INTO WS-TABLE-TEXT-LINE(I)

             *> *************************************************************************
             *> LOOP OF 6 ROWS TO SET DAY NUMBERS
             *> *************************************************************************
             PERFORM VARYING WS-WK FROM 1 BY +1 UNTIL WS-WK > 6
                     INITIALIZE WS-PRT
                     COMPUTE WS-PP = 1
                     *> NUMBERS OF 7 DAYS - THREE MONTHS/YEAR ON ONE ROW
                     PERFORM VARYING WS-COL FROM 1 BY +1 UNTIL WS-COL > 3
                             COMPUTE WS-MM = 3 * (WS-QQ - 1) + WS-COL
                             IF WS-COL = 1
                                COMPUTE WS-PP = WS-PP + WS-LMAR
                             ELSE
                                COMPUTE WS-PP = WS-PP + WS-SPBC
                             END-IF
                             PERFORM VARYING WS-DD FROM 1 BY +1 UNTIL WS-DD > 7
                                     IF WS-DD > 1
                                        COMPUTE WS-PP = WS-PP + WS-SPBD
                                     END-IF
                                     MOVE WS-DAY (WS-MM, WS-WK, WS-DD) TO WS-PRT (WS-PP:2)
                                     COMPUTE WS-PP = WS-PP + 2
                             END-PERFORM
                     END-PERFORM
                     ADD 1 TO I
                     STRING 'D' WS-PRT (1:WS-LS) INTO WS-TABLE-TEXT-LINE(I)
                     *> DISPLAY WS-PRT (1:WS-LS)
             END-PERFORM
             ADD 1 TO I
             MOVE SPACE TO WS-TABLE-TEXT-LINE(I)

     END-PERFORM

     CALL 'GC53CALEVIEW' USING WS-TABLE-TEXT W-KEY END-CALL

     IF W-KEY = K-PAGEDOWN
        COMPUTE INPD-YEAR = INPD-YEAR + 1
        MOVE 1 TO INPD-MONTH  INPD-DAY
        INITIALIZE WS-MTH-AREA WS-TABLE-TEXT I
        GO INIZIO
     END-IF
     IF W-KEY = K-PAGEUP
        COMPUTE INPD-YEAR = INPD-YEAR - 1
        MOVE 1 TO INPD-MONTH  INPD-DAY
         INITIALIZE WS-MTH-AREA WS-TABLE-TEXT I
        GO INIZIO
     END-IF

     GOBACK.

END PROGRAM GC53CALENDAR.


*> ***********************************************************************************
*> GnuCOBOL TT (TUI TOOLS) COLLECTION
*> Purpose:    DISPLAY TEXT TABLE ON A SCREEN WINDOW
*> ***********************************************************************************
IDENTIFICATION DIVISION.
program-id. GC53CALEVIEW.

ENVIRONMENT DIVISION.
configuration section.
SPECIAL-NAMES.
   CRT STATUS IS wKeyPressed.

DATA DIVISION.
WORKING-STORAGE SECTION.

*> Values that may be returned in CRT STATUS (or COB-CRT-STATUS)
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
78  K-NO-DATA     VALUE 8000.
78  K-TIMEOUT     VALUE 8001.

01  wKeyPressed  PIC  9(04) VALUE 9999.

01 black   constant as 0.
01 blue    constant as 1.
01 green   constant as 2.
01 cyan    constant as 3.
01 red     constant as 4.
01 magenta constant as 5.
01 yellow  constant as 6.  *> or Brown
01 white   constant as 7.

01 wDummy PIC X.

01  J            pic 999 VALUE ZERO.
01  i-ini        pic 999.
01  i            pic 999.
01  li           pic s9(02) comp-5 value   0.
01  co           pic s9(02) comp-5 value   0.
01  sw-display   pic s9(02) comp-5 value   0.
01  bco          pic s9(04) comp-5 value +15.

77  EnterKey     pic s9(02) value +13.
77  CursorDown   pic s9(02) value +80.
77  EscapeKey    pic s9(02) value +27.
77  cursor-up    pic s9(02) value +72.

01   wOra.
     03 wOrahh         pic  9(2).
     03 wOramm         pic  9(2).
     03 wOrass         pic  9(2).
     03 wOracc         pic  9(2).
01  wOrax              pic  x(8).

 01  NumRows      pic 9(03)  value 20.
 01  lin-top      pic 9(04)  value  3.  *> first line of window
 01  col0         pic 9(04)  value  3.  *> first col of window
 01  col1         pic 9(04).
 01  lin-table    pic 9(04).
 01  lin-bot      pic 9(04).

 01  wrk1         pic 9(04) value   0.

 01  .
     03 t1-max pic 9(04).
     03 t1-tab.
        05 occurs 50.
           07 t1-line  pic x(0256).

01    szScreenName        PIC X(256).
01    iScrOk              BINARY-LONG.

01  wVisibilityNew   BINARY-SHORT . *> SIGNED.
01  wVisibilityOld   BINARY-SHORT . *> SIGNED.
01  wVisibilityNew9  pic 9(8).
01  wVisibilityOld9  pic 9(8).

COPY      'GC01BOX.CPY'.
COPY      'GC53CALENDAR.CPY'.

LINKAGE SECTION.
01 WS-TABLE-TEXT.
   03 WS-TABLE-TEXT-LINE OCCURS 100 PIC X(80).
01 W-KEY                            PIC 9999.

*> *********************************************************************************
*>                         P R O C E D U R E   D I V I S I O N
*> *********************************************************************************
PROCEDURE DIVISION USING WS-TABLE-TEXT W-KEY.
*> sets in order to detect the PgUp, PgDn, PrtSc(screen print), Esc keys,
set environment 'COB_SCREEN_EXCEPTIONS' TO 'Y'.
set environment 'COB_SCREEN_ESC'        TO 'Y'.

compute t1-max = NumRows - 1
move 0 to i-ini
perform InitialSettings  thru InitialSettingsEx
perform DisplayTable     thru DisplayTableEx

*> hide the cursor
move 0 to wVisibilityNew
call static "curs_set" using by value wVisibilityNew returning wVisibilityOld end-call
    .
*> *************************************************************
*> WAIT FOR USER INPUT WHILE DISPLAYING TIME, AND EXECUTE COMMANDS
*> *************************************************************
LoopMain.
    accept  wOra from time
    string  wOra(1:2) ':' wOra(3:2) ':' wOra(5:2) delimited by size into wOrax
    display wOrax at line lin-bot column 67
            with background-color Cn-BoxBack foreground-color Cn-BoxFore highlight
    *> loop to diaplay time until a key is pressed
    perform forever
         accept omitted with auto timeout 1 end-accept
         IF wKeyPressed = K-TIMEOUT
               *> after a timeout, accept returns 8001
               accept wOra from time
               string wOra(1:2) ':' wOra(3:2) ':' wOra(5:2) delimited by size into wOrax
               display wOrax at line lin-bot column 67
                       with background-color Cn-BoxBack foreground-color Cn-BoxFore highlight
         else
               exit perform
         end-if
    end-perform

   EVALUATE TRUE
      *> *************************************************************
      *> CURSOR DOWN (= SCROLL ROWS UP)
      *> *************************************************************
       WHEN wKeyPressed = K-DOWN
            if i-ini <= 17
              compute i-ini = i-ini + 1
              perform DisplayTable   thru DisplayTableEx
            end-if
      *> *************************************************************
      *> CURSOR UP  (= SCROLL ROWS DOWN)
      *> *************************************************************
       WHEN wKeyPressed = K-UP
            if i-ini > 0
              compute i-ini = i-ini - 1
              perform DisplayTable   thru DisplayTableEx
            end-if

      *> *************************************************************
      *>
      *> *************************************************************
       WHEN wKeyPressed = K-ENTER OR K-ESCAPE OR K-PAGEDOWN OR K-PAGEUP
            go end-of-program

       WHEN other CONTINUE

   END-EVALUATE

   go to LoopMain
   .
end-of-program.

  *> reset (reshow) the cursor
  move wVisibilityOld to wVisibilityNew
  call static "curs_set" using by value wVisibilityNew returning wVisibilityOld end-call.

  MOVE wKeyPressed to W-KEY

  GOBACK.


*> *************************************************************
*> ROUTINES AREA
*> *************************************************************
DisplayTable.
   perform varying i from 1 by +1 until i > t1-max
           compute lin-table = lin-top + i - 1

           EVALUATE WS-TABLE-TEXT-LINE(i + i-ini) (01:01)

           WHEN "M"    *> DISPLAY MONTH AND YEAR
           display WS-TABLE-TEXT-LINE(i + i-ini) (06:72) at line lin-table column col1
                   with background-color Cn-Back foreground-color Cn-ForeMonth highlight
           WHEN "W"    *> DISPLAY DAYS OF THE WEEK
           display WS-TABLE-TEXT-LINE(i + i-ini) (06:72) at line lin-table column col1
                   with background-color Cn-Back foreground-color Cn-ForeWeekDays highlight
           WHEN "D"    *> DISPLAY DAYS NUMBERS
           display WS-TABLE-TEXT-LINE(i + i-ini) (06:72) at line lin-table column col1
                   with background-color Cn-Back foreground-color Cn-ForeDaysNumber highlight
           WHEN OTHER
           display WS-TABLE-TEXT-LINE(i + i-ini) (06:72) at line lin-table column col1
                   with background-color Cn-Back foreground-color Cn-Fore

           END-EVALUATE
   end-perform .
DisplayTableEx. EXIT.

InitialSettings.
   compute box-r1 = lin-top - 1       compute box-c1 = col0
   compute box-r2 = lin-top + t1-max  compute box-c2 = col0 + 72 + 1
   move Cn-BoxBack    to Box-bco
   move Cn-BoxFore    to Box-fco
   move Cn-BoxShadow  to Box-shadow
   CALL 'GC01BOX' USING BY CONTENT BOX-AREA

   compute col1 = col0 + 2 - 1
   compute lin-bot = lin-top + t1-max + 1 - 1
   display ' CurUp/Dn PgUp/Dn Esc/Enter=Exit ' at line lin-bot column 06
            with background-color Cn-BoxBack foreground-color Cn-BoxFore highlight
   display ' '   at line lin-bot column 66
            with background-color Cn-BoxBack foreground-color Cn-BoxFore
   display ' '   at line lin-bot column 75
            with background-color Cn-BoxBack foreground-color Cn-BoxFore
   .
InitialSettingsEx. EXIT.

END PROGRAM GC53CALEVIEW.


*> ***********************************************************************************
*> GnuCOBOL TT (TUI TOOLS) COLLECTION
*> Purpose: CONVERT DATE TO DAY OF WEEK
*> ***********************************************************************************
IDENTIFICATION DIVISION.
PROGRAM-ID. GC53DATE2DOW.

DATA DIVISION.
WORKING-STORAGE SECTION.
01  WMS-WORK-AREA.
    03  WMS-YEAR       PIC 9(04).
    03  WMS-MONTH      PIC 9(02).
    03  WMS-CSYS       PIC 9(01) VALUE 1.
    03  WMS-SUM        pic 9(04).
LINKAGE SECTION.
01  INPDATE-RECORD.
    05  INPD-YEAR          PIC 9(04).
    05  FILLER             PIC X(01).
    05  INPD-MONTH         PIC 9(02).
    05  FILLER             PIC X(01).
    05  INPD-DAY           PIC 9(02).
01  WMS-DOW                PIC 9(01).

PROCEDURE DIVISION USING INPDATE-RECORD, WMS-DOW.

IF INPD-MONTH < 3
   COMPUTE WMS-MONTH = INPD-MONTH + 12
   COMPUTE WMS-YEAR  = INPD-YEAR - 1
ELSE
   COMPUTE WMS-MONTH = INPD-MONTH
   COMPUTE WMS-YEAR  = INPD-YEAR
END-IF

COMPUTE WMS-SUM  =
       ( INPD-DAY + 2 * WMS-MONTH + WMS-YEAR
       + FUNCTION INTEGER (6 * (WMS-MONTH + 1) / 10)
       + FUNCTION INTEGER ( WMS-YEAR / 4   )
       - FUNCTION INTEGER ( WMS-YEAR / 100 )
       + FUNCTION INTEGER ( WMS-YEAR / 400 )
       + WMS-CSYS )

COMPUTE WMS-DOW = FUNCTION MOD (WMS-SUM, 7) + 1

GOBACK.
END PROGRAM GC53DATE2DOW.
