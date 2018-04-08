       >>SOURCE FORMAT IS FREE
       REPLACE ==:BCOL:== BY ==with BACKGROUND-COLOR==
               ==:FCOL:== BY ==FOREGROUND-COLOR== .
IDENTIFICATION DIVISION.
program-id. GC76TABLIST.
*> ***********************************************************************************
*> GnuCOBOL TT (TUI TOOLS) COLLECTION
*> Purpose:    list a TABLE FILE on SCREEN (to verify its CONTENT)
*> Tectonics:  cobc -x GC76TABLIST.COB  (use GnuCOBOL 2.0 or greater)
*> Usage:      GC76TABLIST
*> Author:     Eugenio Di Lorenzo - Italia (DILO)
*> License:    Copyright 2018 E.Di Lorenzo - LGPL, 3.0 (or greater)
*> Version:    1.1 2018.03.12
*> Changelog:  1.0 first release.
*>             1.1 small bug fix
*> ***********************************************************************************
ENVIRONMENT DIVISION.
Configuration Section.
Special-Names.
   CRT STATUS IS wKeyPressed
   Currency Sign is '€'
   Decimal-Point is Comma.
REPOSITORY.
    FUNCTION ALL INTRINSIC.
Input-Output  Section.
File-Control.
   select TABE
          assign       to TABEFSPEC
          access mode  is dynamic
          organization is indexed
          record key   is Tabe-key
          file status  is Tabe-fs.

*> **************************************************************
*>           D A T A     D I V I S I O N
*> **************************************************************
DATA DIVISION.
FILE SECTION.

 fd  TABE. *>      label records are standard.
 01  Tabe-Rec.
     05 Tabe-key.
        07 Tabe-ktip                pic x(001).
        07 Tabe-ktab                pic x(003).
        07 Tabe-kcod                pic x(003).
     05 Tabe-data                   pic x(093).

Working-Storage Section.

01 black   constant as 0.
01 blue    constant as 1.
01 green   constant as 2.
01 cyan    constant as 3.
01 red     constant as 4.
01 magenta constant as 5.
01 yellow  constant as 6.  *> or Brown
01 white   constant as 7.

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
78  K-F1          VALUE 1001.
78  K-SHIFT-F1    VALUE 1013.
78  K-F2          VALUE 1002.
78  K-SHIFT-F2    VALUE 1014.
01  wKeyPressed       PIC  9(04) VALUE 9999.

01  TimeBackCol       pic s9(04) value white.
01  TimeForeCol       pic s9(04) value blue.
01  wOra.
    03 wOrahh         pic  9(2).
    03 wOramm         pic  9(2).
    03 wOrass         pic  9(2).
    03 wOracc         pic  9(2).
01  wOrax             pic  x(8).


01  pic  x.
   88 eof-lista            value '*'.
01  lin3         pic s9(04) value   0.
01  i            pic s9(04) value   0.
01  k            pic s9(02) value   0.
01  Ptr          pic s9(02) value   0.
01  PtrMax       pic s9(02) value   0.
01  wrk1         pic s9(04) value   0.
01  penult       pic s9(02) value   0.
01  flip-flop    pic s9(02) value   0.
01  flip-flop2   pic s9(02) value   2.
01  sw-display   pic s9(02) value   0.
01  bco          pic s9(04) value +15.
01  wInt         BINARY-SHORT SIGNED.
01  PrimaVolta   pic  x(01) value 'Y'.

*> SAVE/RESTORE SCREEN VARIABLES
01  wScreenName        PIC X(256).
01  wiScrOk            BINARY-LONG.

01  curr-row     pic  x(03) value 'bot'.
01  eof1         pic  x(01) value space.
    88 Eof    value 'Y'.
    88 NoEof  value 'N'.
01  bof1         pic  x(01) value space.
    88 Bof    value 'Y'.
    88 NoBof  value 'N'.

01  t1.
    03 t1-max          pic s9(04).
    03 t1-tab.
       05 t1-el        occurs 50.
          07 t1-riga   pic  x(450).
01  limite             pic  9(009) value 450.
01  limite1            pic  9(009) value 450.

01  Riga.
   03            pic x(01)    value '³'.
   03 rTabe-Key  pic x(07).
   03            pic x(01)    value '³'.
   03 rTabe-Data pic x(75).
   03            pic x(01)    value '³'.
   03 rTabe-Fill pic x(18).
   03            pic x(01)    value '³'.

01  RigaT.
    03 pic x(01)    value '³'.
    03 pic x(07)    value 'Key'.
    03 pic x(01)    value '³'.
    03 pic x(75)    value 'Data'.
    03 pic x(01)    value '³'.
    03 pic x(18)    value 'Filler'.
    03 pic x(01)    value '³'.
    03 pic x(33)    value ' <== end of data'.
    03 pic x(400)    value space.

01  Testata pic x(080) value space.
01  ruler.
    05 pic x(450) value
      '1...+....1....+....2....+....3....+....4....+....5' &
      '0...+....6....+....7....+....8....+....9....+....1' &
      '00..+....1....+....2....+....3....+....4....+....5' &
      '0...+....6....+....7....+....8....+....9....+....2' &
      '00..+....1....+....2....+....3....+....4....+....5' &
      '0...+....6....+....7....+....8....+....9....+....3' &
      '00..+....1....+....2....+....3....+....4....+....5' &
      '0...+....6....+....7....+....8....+....9....+....4' &
      '00..+....1....+....2....+....3....+....4....+....5' .
01  top-of-list.
    03  pic x(100) value
    '****** top of file ***    *** top of file ***     ' &
    '   *** top of file ***    *** top of file ***     '.

01  end-of-list.
    03  pic x(100) value
    '****** end of file ***    *** end of file ***     ' &
    '   *** end of file ***    *** end of file ***     '.

 01  menu.
     03           pic  x(80) value
         ' F1= Help; F2= Ruler; TAB; BACKTAB;                                   Scroll:xx '.

 COPY 'GC76TABCOPY.CPY'.
 COPY 'GC01BOX.CPY'.
 COPY 'GC02BOXMEX.CPY'.
 COPY 'GC09BUTTONS.CPY'.
 COPY 'GC98KEYCODE.CPY'.

01  Lista-Area.
   05  li-righe    pic  9(04) value  25.
   05  li-scroll   pic  9(02) value  10.
   05  li-start    pic s9(04) value  +1.
   05  li-back1    pic s9(04) value +01. *> blu
   05  li-fore     pic s9(04) value +14. *> giallo

*> colori testata
01  t-back         pic s9(04) value +07. *> bianco
01  t-fore         pic s9(04) value +00. *> nero
*> colori della riga col cursore
01  c-back         pic s9(04) value +03. *> ciano
01  c-fore         pic s9(04) value +14. *> giallo


*> **************************************************************
*>           P R O C E D U R E   D I V I S I O N
*> **************************************************************
PROCEDURE DIVISION. *> using LnkFileName.

*> sets in order to detect the PgUp, PgDn, PrtSc(screen print), Esc keys,
set environment 'COB_SCREEN_EXCEPTIONS' TO 'Y'.
set environment 'COB_SCREEN_ESC'        TO 'Y'.

Start-program.
   perform TableFileSelection thru TableFileSelectionEx
   if bu-Key = Key-Escape go End-Program end-if
   move    wTabeFilename to TABEFSPEC

   move 01       to li-start
   compute t1-max = li-righe - 3
   compute penult = li-righe - 1

   perform DisplayHeader   thru DisplayHeaderEx
   perform DisplayPF-Row   thru DisplayPF-RowEx
   perform InitializeTable thru InitializeTableEx
   perform DisplayTable    thru DisplayTableEx
   perform HideCursor      thru HideCursorEx.
*> *************************************************************
*> WAIT FOR USER INPUT
*> *************************************************************
Loop-Accept-A-Key.
  perform Accept-a-Key thru Accept-a-KeyEx

  *> which key was pressed ?
  evaluate TRUE

   WHEN wKeyPressed = K-ESCAPE
        close TABE
        move space to T1-Tab
        go Start-program

   *> *************************************************************
   *> CURSOR DOWN: shows next row (sroll up)
   *> *************************************************************
   WHEN wKeyPressed = K-DOWN
      if Ptr = 22
         if Bof set NoBof to true end-if
         if not Eof
          *> in su la tabella di work
          compute limite1 = limite + 1
          move t1-tab (limite1:) to t1-tab
          compute wrk1 = ((t1-max - 1) * limite)
          move space to t1-tab(wrk1:limite)

          move 1 to sw-display

          *> se il puntatore di lettura sul file era sul record
          *> della prima riga del video lo porta sull'ultima
          if curr-row = 'top' *> posiziona il puntatore delle read
             perform varying i from 1 by 1 until i = t1-max
                     perform ReadNext thru ReadNextEx
             end-perform
             move 'bot' to curr-row
          end-if

          perform ReadNext thru ReadNextEx
          if Tabe-FS = '10'
             move end-of-list to t1-riga(t1-max)
             set Eof to true
          else
             perform Prepare-Row thru Prepare-RowEx
             move riga to t1-riga(t1-max)
          end-if
          display t1-riga (t1-max) (li-start:80) at line penult column 01 :BCOL: bco :FCOL: li-fore
         end-if
        else
           if ptr < PtrMax
              compute Ptr = Ptr + 1
           end-if
           move 1 to sw-display
      end-if

   *> *************************************************************
   *> CURSOR DOWN: shows previous row (sroll down)
   *> *************************************************************
   WHEN wKeyPressed = K-UP
    if Ptr = 1
     if Eof set NoEof to true end-if
     if not Bof
      *> sposta le righe della tabella
      compute wrk1 = t1-max - 1
      perform varying i from wrk1 by -1 until i < 1
         move t1-riga(i) to t1-riga(i + 1)
      end-perform
      move 1 to sw-display

      *> se il puntatore di lettura sul file era sul record
      *> della ultima riga del video lo porta sulla prima
      if curr-row = 'bot' *> posiziona il puntatore delle read
       perform varying i from 1 by 1 until i = t1-max
        perform ReadPrior thru ReadPriorEx
*>        if Tabe-FS = '10'
*>         move t1-max to i
*>        end-if
       end-perform
       move 'top' to curr-row
      end-if
      perform ReadPrior thru ReadPriorEx
      if Tabe-FS = '10' or  = '46'
       move top-of-list to t1-riga(1)
       set Bof to true
       if Tabe-Fs = '46'
        add 1 to PtrMax
       end-if
      else
       perform Prepare-Row thru Prepare-RowEx
       move riga to t1-riga(1)
      end-if

      *> show the row
      display t1-riga (1) (li-start:80) at 0301 :BCOL: bco :FCOL: li-fore
     end-if
    else
     compute Ptr = Ptr - 1
     move 1 to sw-display
    end-if

   *> *************************************************************
   *> PAGE UP
   *> *************************************************************
   WHEN wKeyPressed = K-PAGEUP
    if Eof set NoEof to true end-if
    if not Bof
     if curr-row = 'bot' *> posiziona il puntatore delle read
      perform varying i from 1 by 1 until i = t1-max
       perform ReadPrior thru ReadPriorEx
      end-perform
      move 'top' to curr-row
     end-if
     perform varying i from t1-max by -1 until i < 1 or Bof
      perform ReadPrior thru ReadPriorEx
      if Tabe-FS = '10'
       move top-of-list to t1-riga(1)
       set Bof to true
      else
       perform Prepare-Row thru Prepare-RowEx
       move riga to t1-riga(i)
      end-if
     end-perform
     *> se si e' a inizio file ma la videata e' piena solo
     *> in parte allora si visualizza una videata piena
     if Bof and i not = 0
      perform FirstPage thru FirstPageEx
      move 'bot' to curr-row
     end-if
     move 1 to sw-display
    end-if

   *> *************************************************************
   *> PAGE DOWN OR ENTER
   *> *************************************************************
   WHEN wKeyPressed = K-PAGEDOWN
    if Bof set NoBof to true end-if
    if not Eof
     if curr-row = 'top' *> posiziona il puntatore delle read
      perform varying i from 1 by 1 until i = t1-max
       perform ReadNext thru ReadNextEx
      end-perform
      move 'bot' to curr-row
     end-if
     perform varying i from 1 by 1 until i > t1-max or Eof
      perform ReadNext thru ReadNextEx
      if Tabe-Fs = '10'
      *> si potrebbe fare subito la perform a 'ultima-pagina' ?
       perform Prepare-Row thru Prepare-RowEx
       move riga to t1-riga(i)
       if i < t1-max
        move end-of-list to t1-riga(i + 1)
       end-if
       set Eof to true
      else
       perform Prepare-Row thru Prepare-RowEx
       move riga to t1-riga(i)
      end-if
     end-perform

     *> se si e' a fine file ma la videata e' piena solo
     *> in parte allora si visualizza una videata piena
     *> si potrebbe fare sempre appena raggionta Eof ?
     if Eof
      perform LastPage thru LastPageEx
      move 'top' to curr-row
     end-if
     move 1 to sw-display
    end-if

   *> *************************************************************
   *> TAB OR CURSORE A DESTRA   ->
   *> *************************************************************
   WHEN wKeyPressed = K-RIGHT or K-TAB
    if li-start <= (length of t1-riga(1) - 80)
     add li-scroll to li-start
     if li-start > length of t1-riga(1) - 80 + 1
      compute li-start = length of t1-riga(1) - 80  + 1
     end-if
     move 1 to sw-display
    else
     perform beeppa thru beeppa-ex
    end-if

   *> *************************************************************
   *> CURSORE A SINISTRA  <-
   *> *************************************************************
   WHEN wKeyPressed = K-LEFT or K-BACKTAB
    if li-start not = 1
     subtract li-scroll from li-start
     if li-start < 1
      move 1 to li-start
     end-if
     move 1 to sw-display
    else
     perform beeppa thru beeppa-ex
    end-if

   *> *************************************************************
   *> F1 = HELP
   *> *************************************************************
      when wKeyPressed = K-F1 or wKeyPressed = K-SHIFT-F1
         perform HelpWindow thru HelpWindowEx
         perform HideCursor thru HideCursorEx

   *> *************************************************************
   *> ALT-R = display/hide ruler
   *> *************************************************************
   when wKeyPressed = K-F2 or wKeyPressed = K-SHIFT-F2
    if flip-flop = 0
     move 1 to flip-flop
     display ruler(li-start:80) at line li-righe column 01 :BCOL: t-back :FCOL: t-fore
    else
     move 0 to flip-flop
     perform DisplayPF-Row thru DisplayPF-RowEx
    end-if

   end-evaluate

   if SW-DISPLAY = 1
      perform DisplayTable   thru DisplayTableEx
      perform DisplayHeader  thru DisplayHeaderEx
      move 0 to sw-display
      if flip-flop = 1
       display ruler(li-start:80) at line li-righe column 01 :BCOL: t-back :FCOL: t-fore
      end-if
   end-if
   perform HideCursor thru HideCursorEx

   go Loop-Accept-A-Key.

End-Program.
   DISPLAY  ' ' AT 0101 with blank screen END-DISPLAY

   perform ShowCursor thru ShowCursorEx

   close TABE
   GOBACK.

*> *************************************************************
*> ROUTINES
*> *************************************************************
 DisplayTable.
     move 2 to k
     perform varying i from 1 by 1 until i > t1-max
      add 1 to k
      display t1-riga (i) (li-start:80) at line k column 01 :BCOL: bco :FCOL: li-fore
     end-perform
     *> change colors to the "cursor row"
     compute k = Ptr + 2
     display t1-riga (Ptr) (li-start:80) at line k column 01 :BCOL: c-back :FCOL: c-fore
     continue.
 DisplayTableEx. EXIT.

 DisplayHeader.
     string ' TABLE LIST MANAGEMENT - File: '  wTabeFilename ' -' delimited by size into Testata
     display Testata line 01 column 01 :BCOL: t-back :FCOL: 00
     *> intestazione di campi della riga
     display RigaT(li-start:80) at 0201 :BCOL: 04 :FCOL: 14           .
 DisplayHeaderEx. exit.

 DisplayPF-Row.
     move li-scroll to menu(78:2)
     display menu   at line li-righe column 01 :BCOL: t-back :FCOL: t-fore.
 DisplayPF-RowEx. exit.

 InitializeTable.
     move   0   to PtrMax
     Open input TABE
     if Tabe-FS not = '35' *> test if file exist
        if PrimaVolta = 'Y' *> alla prima chiamata parte da in.file
           move low-value to Tabe-Rec
           set NoEof to true
        end-if

        Start TABE Key >= Tabe-Key end-start

        *> *********************************************************
        *> fills table containing screen rows
        *> *********************************************************
        if Tabe-Fs = '00'
           perform varying i from 1 by 1 until (i > t1-max or eof)
              perform ReadNext thru ReadNextEx
              if Tabe-FS = '10'
                 move end-of-list to t1-riga(i)
                 set Eof to true
              else
                 add 1 to PtrMax
                 perform Prepare-Row thru Prepare-RowEx
                 move riga to t1-riga(i)
              end-if
           end-perform
        else
           move end-of-list to t1-riga(i)
           set Eof to true
        end-if
     else *> if File does not exist
         display '> FILE DOES NOT EXIST ! '  at 0146 :BCOL: t-back :FCOL: red highlight
         move end-of-list to t1-riga(1)
         set Eof to true
         perform beeppa thru beeppa-ex
     end-if

     move 'bot' to curr-row
     move li-back1 to bco
     move 1 to Ptr.
 InitializeTableEx. EXIT.

 Prepare-Row.
      move wTabe-Key     to rTabe-Key
      move wTabe-Data    to rTabe-Data
      move wTabe-Fill    to rTabe-Fill
      continue.
 Prepare-RowEx. exit.

 ImpostaPrimaDellaCall.
     perform ShowCursor thru ShowCursorEx
     perform ScreenSave thru ScreenSaveEx
     Close TABE
     move T1-riga(ptr)  to riga
     move 'N'           to PrimaVolta
     perform InitializeTable thru InitializeTableEx
     if Eof
        perform LastPage thru LastPageEx
        move 'top' to curr-row
     end-if
     perform DisplayPF-Row thru DisplayPF-RowEx
     move 1 to sw-display
     perform ScreenRestore thru ScreenRestoreEx .
 ImpostaPrimaDellaCallEx. exit.

 FirstPage.
     move top-of-list to t1-riga(1)
     perform varying i from 2 by 1 until i > t1-max or Eof
        perform ReadNext thru ReadNextEx
        if Tabe-FS = '10' *> finefile
           move end-of-list to t1-riga(i)
           set Eof to true
        else
           perform Prepare-Row thru Prepare-RowEx
           move riga to t1-riga(i)
        end-if
     end-perform.
 FirstPageEx. EXIT.

 LastPage.
    move 1 to ptrMax
    *> per leggere il file a partire dall'ultimo record all'indietro

     Start TABE Key > Tabe-Key end-start

     move end-of-list to t1-riga(t1-max)
     compute wrk1 = t1-max - 1
     perform varying i from wrk1 by -1 until i < 1 or Bof
        perform ReadPrior thru ReadPriorEx
        if Tabe-FS = '10'
           move top-of-list to t1-riga(1)
           set Bof to true
        else
           add 1 to PtrMax
           perform Prepare-Row thru Prepare-RowEx
           move riga to t1-riga(i)
        end-if
     end-perform.
 LastPageEx. EXIT.

Accept-a-Key.
    compute lin3 = 01
    accept wOra from time
    string wOra(1:2) ':' wOra(3:2) ':' wOra(5:2) delimited by size into wOrax
    display ' '   at line lin3 column 71  :BCOL: TimeBackCol :FCOL: TimeForeCol
    display wOrax at line lin3 column 72  :BCOL: TimeBackCol :FCOL: TimeForeCol highlight
    display ' '   at line lin3 column 80  :BCOL: TimeBackCol :FCOL: TimeForeCol

   *> loop to diaplay time until a key is pressed
   perform forever
        accept omitted with AUTO TIMEOUT 1 end-accept
        IF wKeyPressed = K-TIMEOUT
           *> after a timeout, accept returns 8001
              accept wOra from time
              string wOra(1:2) ':' wOra(3:2) ':' wOra(5:2) delimited by size into wOrax
              display ' '   at line lin3 column 71 :BCOL: TimeBackCol :FCOL: TimeForeCol
              display wOrax at line lin3 column 72 :BCOL: TimeBackCol :FCOL: TimeForeCol highlight
              display ' '   at line lin3 column 80 :BCOL: TimeBackCol :FCOL: TimeForeCol
          else
              EXIT PERFORM
          END-IF
   end-perform.
Accept-a-KeyEx.

 BEEPPA.
   CALL X'E5'
   perform HideCursor thru HideCursorEx.
 BEEPPA-EX. exit.

 HideCursor.
    move 0 to wInt
    call static "curs_set" using by value wInt end-call.
    continue.
 HideCursorEx. EXIT.

 ShowCursor.
    move 2 to wInt
    call static "curs_set" using by value wInt end-call.
    continue.
 ShowCursorEx. EXIT.

 *> **************************************************************
 *> READS ON FILE
 *> **************************************************************
 ReadNext.
     read TABE next into wTabe-Rec.
 ReadNextEx. exit.

 ReadPrior.
     read TABE previous into wTabe-Rec.
 ReadPriorEx. exit.

 HelpWindow.
       perform ScreenSave thru ScreenSaveEx
       move low-value to bxm-tabmex
       move 04 to Bxm-r1 move 39 to Bxm-c1
       move 22 to Bxm-r2 move 75 to Bxm-c2
       move 'N' to Bxm-fcoMH
       move '                                   ' & x'00' to bxm-mex(01)
       move ' > CURSOR UP/DOWN scroll one line  ' & x'00' to bxm-mex(02)
       move ' >                                 ' & x'00' to bxm-mex(03)
       move ' > PAGE UP / DOWN scroll one page  ' & x'00' to bxm-mex(04)
       move ' >                                 ' & x'00' to bxm-mex(05)
       move ' > TAB / BACKTAB scroll horizontal ' & x'00' to bxm-mex(06)
       move ' >                                 ' & x'00' to bxm-mex(07)
       move ' > F2= Display or Hide a ruler     ' & x'00' to bxm-mex(08)
       move ' >                                 ' & x'00' to bxm-mex(09)
       move ' > ESCAPE = exit                   ' & x'00' to bxm-mex(10)
       move ' >                                 ' & x'00' to bxm-mex(11)
       move ' >                                 ' & x'00' to bxm-mex(12)
       move ' >                                 ' & x'00' to bxm-mex(13)
       move ' >                                 ' & x'00' to bxm-mex(14)
       move ' >                                 ' & x'00' to bxm-mex(15)
       move ' >                                 ' & x'00' to bxm-mex(16)
       move ' >                                 ' & x'00' to bxm-mex(17)
       CALL GC02BOXMEX USING BY REFERENCE BOXMEX-AREA

       perform ScreenRestore thru ScreenRestoreEx .
 HelpWindowEx. exit.

 ScreenSave.
     move Z'BOXMEX.SCR' to wScreenName
     call static 'scr_dump' using by reference wScreenName returning wiScrOk end-call.
 ScreenSaveEx. Exit.

 ScreenRestore.
    call static 'scr_restore' using by reference wScreenName returning wiScrOk end-call
    CALL 'CBL_DELETE_FILE' USING wScreenName.
 ScreenRestoreEx. Exit.


 TableFileSelection.
   *> background box
   move '002001024080' to Box-rc
   set Box-bco to green Move 'N' to Box-3D
   CALL GC01BOX USING BY CONTENT BOX-AREA

   display ' TABLE LIST MANAGEMENT                                                          '
                  at 0101 :BCOL: green Foreground-Color white highlight
   display  ' Enter=Select CursorKeys PgUp/Dn Tab/Backtab Spacebar ESC=Exit                  '
 *>          12345678901234567890123456789012345678901234567890123456789012345678901234567890
 *>                   1         2         3         4         5         6         7
          at 2501 with background-color green foreground-color white highlight
   *> ********************************************************
   *> SELECTION OF A FILE
   *> ********************************************************
   move '004017023065' to Box-rc
   set Box-bco to white
   CALL GC01BOX USING BY CONTENT BOX-AREA

   move 'E'   to box-3d
   move 'Y' to Bu-Click bu-Shadow
   display '   SELECT A TABLE FILE ' at 005031 :BCOL: white foreground-Color red
   move '104007031   1  TABLE FILE 001     '  & x'00' to Bu-Ele(01)
   move ' 04009031   2  TABLE FILE 002     '  & x'00' to Bu-Ele(02)
   move ' 04011031   3  TABLE FILE 003     '  & x'00' to Bu-Ele(03)
   move ' 04013031   4  TABLE FILE 004     '  & x'00' to Bu-Ele(04)
   move ' 04015031   5  TABLE FILE 005     '  & x'00' to Bu-Ele(05)
   move ' 04017031   6  TABLE FILE 006     '  & x'00' to Bu-Ele(06)
   move ' 04019031   7  TABLE FILE 007     '  & x'00' to Bu-Ele(07)
   move ' 04021031   8  TABLE FILE 008     '  & x'00' to Bu-Ele(08)
   CALL GC09BUTTONS using Buttons-Area

   evaluate Bu-selected
       when 1 move '001' to wTabeFilename(6:3)
       when 2 move '002' to wTabeFilename(6:3)
       when 3 move '003' to wTabeFilename(6:3)
       when 4 move '004' to wTabeFilename(6:3)
       when 5 move '005' to wTabeFilename(6:3)
       when 6 move '006' to wTabeFilename(6:3)
       when 7 move '007' to wTabeFilename(6:3)
       when 8 move '008' to wTabeFilename(6:3)
   end-evaluate
   continue.
TableFileSelectionEx. exit.
