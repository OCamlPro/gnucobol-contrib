       >>SOURCE FORMAT IS FREE
IDENTIFICATION DIVISION.
program-id. GC74HELPVIEW.
*> ***********************************************************************************
*> GnuCOBOL TT (TUI TOOLS) COLLECTION
*> Purpose:    GC74 TUI HELP SYSTEM: UTILITY TO DISPLAY A HELP TEXT WINDOW
*> Tectonics:  cobc -m GC74HEPVIEW.COB  (use GnuCOBOL 2.0 or greater)
*> Usage:      call GC74HELPVIEW using Help01-Area
*> Parameters: look at GC74HELPVIEW.cpy (use with copy Version: 1.0 2016.06.15)
*> Author:     Eugenio Di Lorenzo - Italia (DILO)
*> License:    Copyright 2017 E.Di Lorenzo - LGPL, 3.0 (or greater)
*> Version:    1.0 2017.01.31
*> Changelog:  1.0 first release.
*> ***********************************************************************************
*>  the help window will be displayed as following
*>
*>  |<---------------------------------- 74 chars ----------------------------------->|
*>
*>  +------------------------------| XXXXXXXXXXXXXXXXXX |-----------------------------+    -
*>  |yyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyy|    ^
*>  |yyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyy|    |
*>  |yyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyy|    |
*>  |yyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyy|    |
*>  |yyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyy|   12 rows
*>  |yyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyy|   you can scroll
*>  |yyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyy|    |
*>  |yyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyy|    |
*>  |yyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyy|    v
*>  +---------------------------------------------------------------- hh:mm:ss -------+
*>
*>
*> *******************************************************************************************

ENVIRONMENT DIVISION.
configuration section.
SPECIAL-NAMES.
   CRT STATUS IS wKeyPressed.

input-output  section.
file-control.
   select HELP
      assign to Filespec
      access mode  is dynamic
      organization is indexed
      record key   is HelpKey
      file status  is HelpFs.

DATA DIVISION.
File Section.

Fd  HELP label record standard.
01  HelpRec.
    03 HelpKey.
       05 HelpKcod pic x(08).
       05 HelpKnum pic 9(04).
    03 HelpData    pic x(72).

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

*>  The following exception keys are currently *only* returned on ACCEPT OMITTED
78  COB-SCR-INSERT      VALUE 2011.
78  COB-SCR-DELETE      VALUE 2012.
78  COB-SCR-BACKSPACE   VALUE 2013.
78  COB-SCR-KEY-HOME    VALUE 2014.
78  COB-SCR-KEY-END     VALUE 2015.

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

01  FILESPEC     pic  x(80) value ' '.
01  HelpFs       pic  x(02) value space.
01  i            pic s9(02) comp-5 value   0.
01  li           pic s9(02) comp-5 value   0.
01  co           pic s9(02) comp-5 value   0.
01  sw-display   pic s9(02) comp-5 value   0.
01  bco          pic s9(04) comp-5 value +15.

77  EnterKey     pic s9(02) value +13.
77  CursorDown   pic s9(02) value +80.
77  EscapeKey    pic s9(02) value +27.
77  cursor-up    pic s9(02) value +72.

01   wTime.
     03 wTimehh         pic  9(2).
     03 wTimemm         pic  9(2).
     03 wTimess         pic  9(2).
     03 wTimecc         pic  9(2).
01  wTimex              pic  x(8).

01  curr-row     pic  x(03) value 'bot'.

01  pic x   value space.
    88 eof       value 'Y'.
    88 no-eof    value 'N'.
01  pic x        value space.
    88 bof       value 'Y'.
    88 no-bof    value 'N'.
01  pic x        value space.
    88 DisabCurs value 'Y'.

 01  NumRows      pic  9(03)        value 012.
 01  lin0         pic s9(04) comp-5 value  10.
 01  linT         pic s9(04) comp-5 value  10.
 01  col0         pic s9(04) comp-5 value   4.
 01  col1         pic s9(04) comp-5 value   0.
 01  lin1         pic s9(04) comp-5 value   0.
 01  lin3         pic s9(04) comp-5 value   0.

 01  wrk1         pic s9(04) comp-5 value   0.
 01  TopOfHelp    pic  x(72) value
     '                                       *** top of help ***'.
 01  EndOfHelp    pic  x(72) value
     '                                       *** end of help ***'.
 01  .
     03 t1-max pic s9(04) comp-5.
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

LINKAGE SECTION.
COPY   'GC74HELPVIEW.CPY'.

*> *********************************************************************************
*>                         P R O C E D U R E   D I V I S I O N
*> *********************************************************************************
PROCEDURE DIVISION USING HELP-AREA.
    *> sets in order to detect the PgUp, PgDn, PrtSc(screen print), Esc keys,
    set environment 'COB_SCREEN_EXCEPTIONS' TO 'Y'.
    set environment 'COB_SCREEN_ESC'        TO 'Y'.

    *> save the screen before display help message
    move Z'BOXMEX.SCR' to szScreenName
    call static 'scr_dump' using by reference szScreenName returning iScrOk end-call

    compute t1-max = NumRows - 1

    perform InitialSettings  thru InitialSettingsEx
    perform DisplayTable     thru DisplayTableEx
    perform HideCursor       thru HideCursorEx.

*> *************************************************************
*> WAIT FOR USER INPUT AND EXECUTE COMMANDS
*> *************************************************************
LoopMain.
   perform Accept-a-Key thru Accept-a-KeyEx

   EVALUATE TRUE

      WHEN wKeyPressed = K-ENTER
        go end-of-program

    *> *************************************************************
    *> CURSOR DOWN (= SCROLL ROWS UP)
    *> *************************************************************
     WHEN wKeyPressed = K-DOWN and not DisabCurs
          if bof set no-bof to true end-if
          if not eof
             move t1-tab (257:) to t1-tab *> in su la tabella di work
             compute wrk1 = ((t1-max - 1) * 256)
             move space  to t1-tab (wrk1:256)

             *> if read file pointer was on first screen row it will be set on last screen row
             *> set the read file pointer
               if curr-row = 'top'
                  perform varying i from 1 by 1 until i = t1-max
                          read HELP next at end continue
                  end-perform
                  move 'bot' to curr-row
               end-if

               read HELP next into t1-line (t1-max)
                    at end move EndofHelp to t1-line(t1-max), set eof to true
               end-read
               if Helpkcod not = HeKey
                  move EndofHelp to t1-line(t1-max), set eof to true
               end-if
           end-if

           perform DisplayTable   thru DisplayTableEx
    *> *************************************************************
    *> CURSOR UP  (= SCROLL ROWS DOWN)
    *> *************************************************************
     WHEN wKeyPressed = K-UP and not DisabCurs
          if eof set no-eof to true end-if
          if not bof
             compute wrk1 = t1-max - 1
             perform varying i from wrk1 by -1 until i < 1
                 move t1-line(i) to t1-line(i + 1)
             end-perform

             *> if read pointer was on last screen row it is moved on first screen row
             *> set the read file pointer
             if curr-row = 'bot'
                perform varying i from 1 by 1 until i = t1-max
                    read HELP previous
                end-perform
                move 'top' to curr-row
             end-if
             read HELP previous into t1-line (1)
                  at end move TopOfHelp to t1-line(1) set bof to true
             end-read
             if Helpkcod not = HeKey or Helpknum = zero
                move TopOfHelp to t1-line(1)
                set bof to true
             end-if

             perform DisplayTable   thru DisplayTableEx
          end-if

    *> *************************************************************
    *> PAGE UP
    *> *************************************************************
      WHEN wKeyPressed = K-PAGEUP and not DisabCurs
         if eof set no-eof to true end-if
         if not bof
            *> set the read file pointer
            if curr-row = 'bot'
               perform varying i from 1 by 1 until i = t1-max or bof
                      read HELP previous
                           at end move TopOfHelp to t1-line(1) set bof to true
                      end-read
                      if Helpkcod not = HeKey or Helpknum = zero
                         move TopOfHelp to t1-line(1) set bof to true
                      end-if
               end-perform
               move 'top' to curr-row
            end-if

            perform varying i from t1-max by -1 until i < 1 or bof
                   read HELP previous into t1-line (i)
                        at end move TopOfHelp to t1-line(1) set bof to true
                   end-read
                   if Helpkcod not = HeKey or Helpknum = zero
                      move TopOfHelp to t1-line(1) set bof to true
                   end-if
            end-perform
            *> if we are at pirst file record and the screen is partialli filled
            *> then we fill all the screen rows
            if bof and i not = 0
               perform FirstPage thru FirstPageEx
               move 'bot' to curr-row
            end-if
            move 1 to sw-display
         end-if

    *> *************************************************************
    *> PAGE DOWN
    *> *************************************************************
    WHEN wKeyPressed = K-PAGEDOWN and not DisabCurs
         if bof set no-bof to true end-if
         if not eof
            if curr-row = 'top' *> posiziona il puntatore delle read
               perform varying i from 1 by 1 until i = t1-max
                read HELP
               end-perform
               move 'bot' to curr-row
            end-if
            perform varying i from 1 by 1 until i > t1-max or eof
               read HELP next into t1-line (i)
                    at end move EndOfHelp to t1-line(i) set eof to true
               end-read
               if Helpkcod not = HeKey
                  move EndofHelp to t1-line(i) set eof to true
               end-if
            end-perform

            *> if we are at end of file but screen is partialli filled
            *> then we show an entire filled screen
            if eof and i not = t1-max + 1
               perform LastPage thru LastPageEx
               move 'top' to curr-row
            end-if
            move 1 to sw-display
         end-if

    *> *************************************************************
    *> HOME --> ESCAPE = TOP OF FILE
    *> *************************************************************
    WHEN wKeyPressed = K-ESCAPE and not DisabCurs
         close HELP
         perform InitialSettings thru InitialSettingsEx
         move 1 to sw-display

    WHEN other CONTINUE

   END-EVALUATE

   if sw-display = 1
      perform DisplayTable   thru DisplayTableEx
      move 0 to sw-display
   end-if
   perform HideCursor thru HideCursorEx

   go to LoopMain .

end-of-program.
   Close HELP
   *> reset cursor setting
   perform ShowCursor thru ShowCursorEx
   *> restore the screen as it was before we display the help message

   call static 'scr_restore' using by reference szScreenName returning iScrOk end-call
   accept omitted
   goback.


*> *************************************************************
*> ROUTINES AREA
*> *************************************************************
Accept-a-Key.
   compute lin3 = lin0 + t1-max + 1 - 1

    accept wTime from time
    string wTime(1:2) ':' wTime(3:2) ':' wTime(5:2) delimited by size into wTimex
    display ' '   at line lin3 column 66
            with background-color HeBoxBack foreground-color HeBoxFore
    display wTimex at line lin3 column 67
            with background-color HeBoxBack foreground-color HeBoxFore highlight
    display ' '   at line lin3 column 75
            with background-color HeBoxBack foreground-color HeBoxFore
    display ' CurUp/Dn PgUp/Dn Esc=Top Enter=Exit ' at line lin3 column 06
            with background-color HeBoxBack foreground-color HeBoxFore highlight

   *> loop to diaplay time until a key is pressed
   perform forever
        accept omitted with AUTO TIMEOUT 1 end-accept
        IF wKeyPressed = K-TIMEOUT
           *> after a timeout, accept returns 8001
              accept wTime from time
              string wTime(1:2) ':' wTime(3:2) ':' wTime(5:2) delimited by size into wTimex
              display ' '   at line lin3 column 66
                      with background-color HeBoxBack foreground-color HeBoxFore
              display wTimex at line lin3 column 67
                      with background-color HeBoxBack foreground-color HeBoxFore highlight
              display ' '   at line lin3 column 75
                      with background-color HeBoxBack foreground-color HeBoxFore
          else
              EXIT PERFORM
          END-IF
   end-perform.
Accept-a-KeyEx.

DisplayTable.
   compute col1 = col0 + 2 - 1
   perform varying i from 1 by 1 until i > t1-max
        compute lin1 = lin0 + i - 1
        display t1-line(i) (13:72) at line lin1 column col1
                with background-color HeBack foreground-color HeFore
   end-perform .
DisplayTableEx. EXIT.

InitialSettings.
   compute box-r1 = lin0 - 1       compute box-c1 = col0
   compute box-r2 = lin0 + t1-max  compute box-c2 = col0 + 72 + 1
   move HeBoxBack    to Box-bco
   move HeBoxFore    to Box-fco
   move HeBoxShadow  to Box-shadow
   CALL GC01BOX USING BY CONTENT BOX-AREA

   move HeFile to filespec
   open input HELP
   if HelpFs = '35' *> se non esiste il file di help
      move ' ... Warning ! help file not found ========> ' to t1-line(6) (13:72)
      move Filespec to t1-line(6)(58:15)
      set DisabCurs to true
      go InitialSettingsEx
   end-if

   set  no-eof to true
   move HeKey  to Helpkcod
   move zero   to Helpknum
   read HELP
   invalid key
      perform varying i from 1 by 1 until i > t1-max
          move all '?' to t1-line(i)
      end-perform
      set DisabCurs to true
      go InitialSettingsEx
   end-read

   *> display the box title
   move 0 to tally
   inspect HelpData tallying tally for characters before initial '   '
   compute col1 = (74 / 2) - ((tally - 3) / 2) + 1 + 1
   compute linT = lin0 - 1

   display '|' at line linT column col1
           with background-color HeBoxBack foreground-color HeBoxFore
   compute col1 = col1 + 1
   display HelpData (1:tally + 1) at line linT column col1
           with background-color HeTitBack foreground-color HeTitFore highlight
   compute col1 = col1 +  tally + 1
   display '|'  at line linT column col1
           with background-color HeBoxBack foreground-color HeBoxFore

   *> initial fill the table from help file
   perform varying i from 1 by 1 until i > t1-max or eof
        read HELP next into t1-line(i)
             at end set eof to true end-read
        if Helpkcod not = HeKey or eof
           move EndofHelp to t1-line(i) set eof to true
           *> if initial filling of table does not fill a help page
           *> set disable cursor up, cursor down and home key
           set DisabCurs to true
        end-if
   end-perform
   move 'bot' to curr-row.
InitialSettingsEx. EXIT.

FirstPage.
   Close       HELP
   Open  input HELP
   move HeKey to Helpkcod
   move zero  to Helpknum

   *> initial positioning
   read Help invalid key
        perform varying i from 1 by 1 until i > t1-max
             move all '?' to t1-line(i) set DisabCurs to true
        end-perform
        go FirstPageEx
   end-read
   move TopOfHelp to t1-line(1)
   perform varying i from 2 by 1 until i > t1-max or eof
        read HELP next into t1-line(i)
             at end move EndOfHelp to t1-line(i) set eof to true
        end-read
        *> skip the title record
        if Helpkcod = HeKey and Helpknum = 0
           read HELP next into t1-line(i)
        end-if
        if Helpkcod not = HeKey
           move EndofHelp to t1-line(i) set eof to true
        end-if
   end-perform.
FirstPageEx. EXIT.

LastPage.
   move EndOfHelp to t1-line(t1-max)
   compute wrk1 = t1-max - 1
   perform varying i from wrk1 by -1 until i < 1 or bof
      read HELP previous into t1-line (i)
           at end move TopOfHelp to t1-line(1) set bof to true
      end-read
      if Helpkcod not = HeKey
         move TopofHelp to t1-line(1) set bof to true
      end-if
   end-perform.
LastPageEx. EXIT.

HideCursor.
  *> hide the cursor
  move 0 to wVisibilityNew
  call static "curs_set" using by value wVisibilityNew returning wVisibilityOld end-call.
HideCursorEx. exit.

ShowCursor.
  *> reset (reshow) the cursor
  move wVisibilityOld to wVisibilityNew
  move 2 to wVisibilityNew
  call static "curs_set" using by value wVisibilityNew returning wVisibilityOld end-call.
ShowCursorEx. exit.
