       >>SOURCE FORMAT IS FREE
IDENTIFICATION DIVISION.
program-id. GC74HELPLIST.
*> ***********************************************************************************
*> GnuCOBOL TT (TUI TOOLS) COLLECTION
*> Purpose:    GC74 TUI HELP SYSTEM: list a help file on SCREEN (to verify its CONTENT)
*> Tectonics:  cobc -x GC74HELPLIST.COB  (use GnuCOBOL 2.0 or greater)
*> Usage:      GC74HELPLIST
*> Parameters: none
*> Author:     Eugenio Di Lorenzo - Italia (DILO)
*> License:    Copyright 2017 E.Di Lorenzo - LGPL, 3.0 (or greater)
*> Version:    1.0 2017.01.31
*> Changelog:  1.0 first release.
*> ***********************************************************************************
ENVIRONMENT DIVISION.
Configuration Section.
Special-Names.
   CRT STATUS IS wKeyPressed.
   Currency Sign is '€'.
   Decimal-Point is Comma.

Input-Output  Section.
File-Control.

   select HELP
      assign to HelpFSPEC
      access mode  is dynamic
      organization is indexed
      record key   is FdHelpKey
      file status  is HelpFs.

*> **************************************************************
*>           D A T A     D I V I S I O N
*> **************************************************************
DATA DIVISION.
File Section.

Fd  HELP label record standard.
01  FdHelpRec.
    03 FdHelpKey.
       05 FdHelpKcod pic x(08).
       05 FdHelpKnum pic 9(04).
    03 FdHelpData    pic x(72).

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
01  HeBoxBack       pic s9(04) comp-5 value white.
01  HeBoxFore       pic s9(04) comp-5 value red.

01  wKeyPressed       PIC  9(04) VALUE 9999.
01  wOra.
    03 wOrahh         pic  9(2).
    03 wOramm         pic  9(2).
    03 wOrass         pic  9(2).
    03 wOracc         pic  9(2).
01  wOrax             pic  x(8).
01  lin3              pic s9(04) comp-5 value   0.

77  HelpFS           pic x(02).
77  HelpFSPEC        pic x(30) value 'ANAGE---.DAT'.


01  HelpRec.
    03 HelpKey.
       05 HelpKcod pic x(08).
       05 HelpKnum pic 9(04).
    03 HelpData    pic x(72).

01  pic  x.
   88 eof-lista            value '*'.
01  i            pic s9(04) comp-5 value   0.
01  k            pic s9(02) comp-5 value   0.
01  Ptr          pic s9(02) comp-5 value   0.
01  PtrMax       pic s9(02) comp-5 value   0.
01  wrk1         pic s9(04) comp-5 value   0.
01  penult       pic s9(02) comp-5 value   0.
01  flip-flop    pic s9(02) comp-5 value   0.
01  flip-flop2   pic s9(02) comp-5 value   2.
01  sw-display   pic s9(02) comp-5 value   0.
01  bco          pic s9(04) comp-5 value +15.

01  PrimaVolta   pic  x(01) value 'Y'.

*> SAVE/RESTORE SCREEN VARIABLES
01    wScreenName        PIC X(256).
01    wiScrOk            BINARY-LONG.


01  jj           pic s9(04) comp-5 value   0.
01  Stringa      pic  x(20)        value   space.

01  curr-row     pic  x(03) value 'bot'.
01  eof1         pic  x(01) value space.
    88 Eof    value 'Y'.
    88 NoEof  value 'N'.
01  bof1         pic  x(01) value space.
    88 Bof    value 'Y'.
    88 NoBof  value 'N'.

01  t1.
    03 t1-max          pic s9(04) comp-5.
    03 t1-tab.
       05 t1-el        occurs 50.
          07 t1-riga   pic  x(450).
01  limite             pic  9(009) value 450.
01  limite1            pic  9(009) value 450.

01  Riga.
   03            pic x(01)    value '³'.
   03 rHelpKey   pic x(12).
   03            pic x(01)    value '³'.
   03 rHelpData  pic x(72).
   03            pic x(01)    value '³'.

       01  RigaT.
           03 pic x(01)    value '³'.
           03 pic x(12)    value 'HelpKey     '.
           03 pic x(01)    value '³'.
           03 pic x(72)    value 'HelpData'.
           03 pic x(01)    value '³'.
           03 pic x(33)    value ' <== end of data'.
           03 pic x(10)    value space.

       01  Testata pic x(080) value space.
       01  ruler.
           05 pic x(100) value
              '1...+....1....+....2....+....3....+....4....+....5' &
              '0...+....6....+....7....+....8....+....9....+....1'.

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
  *>     ' F1= Help;                                             Scroll:xx                '.
         ' F1= Help; TAB; BACKTAB;                               Scroll:xx                '.
01  wAnswer      pic  x(01) value space.

COPY      'GC02BOXMEX.CPY'.
COPY      'GC01BOX.CPY'.


01  Lista-Area.
*> li-righe  25, 43, 50 righe da visualizzare a video
*> li-scroll valore iniziale di scroll ad ogni tasto -> o <-
*> li-start  colonna iniziale di visualizzazione del tabulato
*>           DEFAULT = 1
*> li-lett-fac se = 'Y' allora si visualizza il tabulato su
*>             "carta a lettura facilitata" usando i due
*>             colori che seguono. Altrimenti si usa solo il
*>             colore li-back1 per lo sfondo.
*> li-back1/2 colori da alternare per rendere l'effetto della
*>            carta a lettura facilitata.
*> li-fore   colore di foreground per i caratteri del tabulato
   05  li-righe    pic  9(04) value  25.
   05  li-scroll   pic  9(02) value  10.
   05  li-start    pic s9(04) value  +1.
   *> 05  li-lett-fac pic  x(01) value 'Y'.
   05  li-back1    pic s9(04) comp-5 value +01. *> blu
   05  li-fore     pic s9(04) comp-5 value +14. *> giallo

*> colori testata
01  t-back         pic s9(04) comp-5 value +07. *> bianco
01  t-fore         pic s9(04) comp-5 value +00. *> nero
*> colori della riga col cursore
01  c-back         pic s9(04) comp-5 value +03. *> ciano
01  c-fore         pic s9(04) comp-5 value +14. *> giallo

*> 01  LnkOperazione   pic x(001).
01  wHelpKey          pic 9(009).
*> 01  wHelpKeyAttiva    pic x(001).
01  HelpFileName     pic x(030).

LINKAGE SECTION.


*> **************************************************************
*>           P R O C E D U R E   D I V I S I O N
*> **************************************************************
PROCEDURE DIVISION.


*> sets in order to detect the PgUp, PgDn, PrtSc(screen print), Esc keys,
set environment 'COB_SCREEN_EXCEPTIONS' TO 'Y'.
set environment 'COB_SCREEN_ESC'        TO 'Y'.

inizio.

   display 'Input Filename (default [.DAT]) ............: ' with no advancing
   accept HelpFileName *> FilespecI
   if HelpFileName = space go to inizio end-if
   inspect HelpFileName tallying tally for all '.'
   if tally = 0
      inspect HelpFileName replacing first '    ' by '.DAT'
   end-if


   display space
   display 'Input Filename ...........: ' HelpFileName(1:30)
   display 'continue (Y/N) ? .....: ' with no advancing
   accept  wAnswer
   if wAnswer = 'Y' or 'y' or space
      continue
   else
      display space
      display '... Processing stopped by user.' with no advancing
      display space
      stop run
   end-if

   move HelpFileName to HelpFSPEC

   move 01       to li-start
   compute t1-max = li-righe - 3
   compute penult = li-righe - 1

   perform DisplayHeader   thru DisplayHeaderEx
   perform DisplayMenu      thru DisplayMenuEx

   perform Inizializza    thru InizializzaEx
   perform DisplayTabella thru DisplayTabellaEx
   perform HideCursor       thru HideCursorEx.
*> *************************************************************
*> ACCETTA L'INPUT DELLA TASTIERA ED ESEGUE COMANDI
*> *************************************************************
loop-tasti.
  perform Accept-a-Key thru Accept-a-KeyEx

  *> controllo quale tasto e' stato digitato
  evaluate TRUE

   WHEN wKeyPressed = K-ESCAPE go esci

   *> *************************************************************
   *> CURSORE GIU: visualizza la riga seguente (scroll in su)
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
      if HelpFS = '10'
       move end-of-list to t1-riga(t1-max)
       set Eof to true
      else
       perform FormattaRiga thru FormattaRigaEx
       move riga to t1-riga(t1-max)
      end-if
      display t1-riga (t1-max) (li-start:80)
       at line penult column 01
       with background-color bco foreground-color li-fore
     end-if
    else
     if ptr < PtrMax
      compute Ptr = Ptr + 1
     end-if
     move 1 to sw-display
    end-if

   *> *************************************************************
   *> CURSORE SU: visualizza la riga preced. (scroll in giu)
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
*>        if HelpFS = '10'
*>         move t1-max to i
*>        end-if
       end-perform
       move 'top' to curr-row
      end-if
      perform ReadPrior thru ReadPriorEx
      if HelpFS = '10' or HelpFS = '46'
       move top-of-list to t1-riga(1)
       set Bof to true
       if HelpFS = '46'
        add 1 to PtrMax
       end-if
      else
       perform FormattaRiga thru FormattaRigaEx
       move riga to t1-riga(1)
      end-if

      *> visualizza la riga
      display t1-riga (1) (li-start:80) at line 03 column 01
        with background-color bco foreground-color li-fore
     end-if
    else
     compute Ptr = Ptr - 1
     move 1 to sw-display
    end-if

   *> *************************************************************
   *> PAGINA SU
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
      if HelpFS = '10'
       move top-of-list to t1-riga(1)
       set Bof to true
      else
       perform FormattaRiga thru FormattaRigaEx
       move riga to t1-riga(i)
      end-if
     end-perform
     *> se si e' a inizio file ma la videata e' piena solo
     *> in parte allora si visualizza una videata piena
     if Bof and i not = 0
      perform PrimaPagina thru PrimaPaginaEx
      move 'bot' to curr-row
     end-if
     move 1 to sw-display
    end-if

   *> *************************************************************
   *> PAGINA GIU (oppure ENTER)
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
      if HelpFS = '10'
      *> si potrebbe fare subito la perform a 'ultima-pagina' ?
       perform FormattaRiga thru FormattaRigaEx
       move riga to t1-riga(i)
       if i < t1-max
        move end-of-list to t1-riga(i + 1)
       end-if
       set Eof to true
      else
       perform FormattaRiga thru FormattaRigaEx
       move riga to t1-riga(i)
      end-if
     end-perform

     *> se si e' a fine file ma la videata e' piena solo
     *> in parte allora si visualizza una videata piena
     *> si potrebbe fare sempre appena raggionta Eof ?
     if Eof
      perform UltimaPagina thru UltimaPaginaEx
      move 'top' to curr-row
     end-if
     move 1 to sw-display
    end-if

   *> *************************************************************
   *> CURSORE A DESTRA   ->
   *> *************************************************************
   WHEN wKeyPressed = K-RIGHT or K-TAB
    if li-start <= (length of t1-riga(1) - 80)    *> 132-80=52
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
     display ruler(li-start:80) at line li-righe column 01
      with background-color t-back foreground-color t-fore
    else
     move 0 to flip-flop
     perform DisplayMenu thru DisplayMenuEx
    end-if

   end-evaluate

   if SW-DISPLAY = 1
      perform DisplayTabella   thru DisplayTabellaEx
      perform DisplayHeader   thru DisplayHeaderEx
      move 0 to sw-display
      if flip-flop = 1
       display ruler(li-start:80) at line li-righe column 01
        with background-color t-back foreground-color t-fore
      end-if
   end-if
   perform HideCursor thru HideCursorEx

   go loop-tasti.

ESCI.
   DISPLAY  ' ' AT 0101 with blank screen END-DISPLAY

   perform ShowCursor thru ShowCursorEx

   close HELP
   GOBACK.

*> *************************************************************
*> AREA DELLE ROUTINES
*> *************************************************************
 DisplayTabella.
     move 2 to k
     perform varying i from 1 by 1 until i > t1-max
      add 1 to k
      display t1-riga (i) (li-start:80) at line k column 01
       with background-color bco foreground-color li-fore
     end-perform

     *> cambia l'attributo alla riga del "cursore"
     compute k = Ptr + 2
     display t1-riga (Ptr) (li-start:80) at line k column 01
      with background-color c-back foreground-color c-fore
     .
 DisplayTabellaEx. EXIT.

 DisplayHeader.
     string  ' LIST HELP FILE     (File: '
      HelpFileName ')' delimited by size into Testata
     display Testata line 01 column 01
      with  background-Color t-back foreground-Color 00
     *> intestazione di campi della riga
     display RigaT(li-start:80) at line 2 column 01
      with background-color 04 foreground-color 14           .
 DisplayHeaderEx. exit.

 DisplayMenu.
     move li-scroll to menu(63:2)

     display menu   at line li-righe column 01
       with background-color t-back foreground-color t-fore.
 DisplayMenuEx. exit.

 Inizializza.
     *> riempimento iniziale della tabella: viene eseguito sia
     *> alla prima chiamata che al ritorno da edit/delete
     move   0           to PtrMax
     move   HelpFileName to HelpFSPEC
     Open input HELP
     if HelpFS not = '35' *> test se il file esiste
        if PrimaVolta = 'Y' *> alla prima chiamata parte da in.file
           move low-value to FdHelpRec
           set NoEof to true
        end-if

        Start HELP Key >= FdHelpKey end-start

        *> *********************************************************
        *> riempimento della tabella contenente le righe del video
        *> *********************************************************
        if HelpFS = '00'
           perform varying i from 1 by 1 until (i > t1-max or eof)
              perform ReadNext thru ReadNextEx
              if HelpFS = '10'
                 move end-of-list to t1-riga(i)
                 set Eof to true
              else
                 add 1 to PtrMax
                 perform FormattaRiga thru FormattaRigaEx
                 move riga to t1-riga(i)
              end-if
           end-perform
        else
           move end-of-list to t1-riga(i)
           set Eof to true
        end-if
     else *> se il file non esiste
         move end-of-list to t1-riga(1)
         set Eof to true
     end-if

     move 'bot' to curr-row
     move li-back1 to bco
     move 1 to Ptr.
 InizializzaEx. EXIT.

 FormattaRiga.
      move HelpKey     to rHelpKey
      move HelpData    to rHelpData  .
 FormattaRigaEx. exit.

 ImpostaPrimaDellaCall.
     perform ShowCursor thru ShowCursorEx

     perform ScreenSave thru ScreenSaveEx
     Close HELP

     move T1-riga(ptr)          to riga

     move T1-riga(ptr) (2:9) to wHelpKey

     move 'N' to PrimaVolta
     perform Inizializza thru InizializzaEx
     if Eof
        perform UltimaPagina thru UltimaPaginaEx
        move 'top' to curr-row
     end-if
     perform DisplayMenu thru DisplayMenuEx
     move 1 to sw-display

     perform ScreenRestore thru ScreenRestoreEx .
 ImpostaPrimaDellaCallEx. exit.


 PrimaPagina.
     move top-of-list to t1-riga(1)
     perform varying i from 2 by 1 until i > t1-max or Eof
        perform ReadNext thru ReadNextEx
        if HelpFS = '10' *> finefile
           move end-of-list to t1-riga(i)
           set Eof to true
        else
           perform FormattaRiga thru FormattaRigaEx
           move riga to t1-riga(i)
        end-if
     end-perform.
 PrimaPaginaEx. EXIT.

 UltimaPagina.
     move 1 to ptrMax
     *> per leggere il file a partire dall'ultimo record all'indietro

      Start HELP Key > FdHelpKey end-start

     move end-of-list to t1-riga(t1-max)
     compute wrk1 = t1-max - 1
     perform varying i from wrk1 by -1 until i < 1 or Bof
        perform ReadPrior thru ReadPriorEx
        if HelpFS = '10'
           move top-of-list to t1-riga(1)
           set Bof to true
        else
           add 1 to PtrMax
           perform FormattaRiga thru FormattaRigaEx
           move riga to t1-riga(i)
        end-if
     end-perform.
 UltimaPaginaEx. EXIT.

Accept-a-Key.
   *> perform DisplayMenu thru DisplayMenuEx
    compute lin3 = 25
    accept wOra from time
    string wOra(1:2) ':' wOra(3:2) ':' wOra(5:2) delimited by size into wOrax
    display ' '   at line lin3 column 71
            with background-color HeBoxBack foreground-color HeBoxFore
    display wOrax at line lin3 column 72
            with background-color HeBoxBack foreground-color HeBoxFore highlight
    display ' '   at line lin3 column 80
            with background-color HeBoxBack foreground-color HeBoxFore

   *> loop to diaplay time until a key is pressed
   perform forever
        accept omitted with AUTO TIMEOUT 1 end-accept
        IF wKeyPressed = K-TIMEOUT
           *> after a timeout, accept returns 8001
              accept wOra from time
              string wOra(1:2) ':' wOra(3:2) ':' wOra(5:2) delimited by size into wOrax
              display ' '   at line lin3 column 71
                      with background-color HeBoxBack foreground-color HeBoxFore
              display wOrax at line lin3 column 72
                      with background-color HeBoxBack foreground-color HeBoxFore highlight
              display ' '   at line lin3 column 80
                      with background-color HeBoxBack foreground-color HeBoxFore
          else
              EXIT PERFORM
          END-IF
   end-perform.
Accept-a-KeyEx.


 BEEPPA.
          CALL X'E5'
          perform HideCursor thru HideCursorEx.
 BEEPPA-EX. exit.

 HideCursor. *> rende invisibile il cursore
     *> set hide-cursor to true
     *> call 'display_set_cursor_type' using cur-type.
     .
 HideCursorEx. EXIT.

 ShowCursor. *> rende visibile il cursore
     *> move cur-type2 to cur-type
     *> call 'display_set_cursor_type' using cur-type.
     .
 ShowCursorEx. EXIT.

 *> **************************************************************
 *> letture sul file
 *> **************************************************************
 ReadNext.
     read HELP next into HelpRec .
 ReadNextEx. exit.

 ReadPrior.
     read HELP previous into HelpRec.
 ReadPriorEx. exit.

 HelpWindow.
 perform ScreenSave thru ScreenSaveEx

 move 03 to Bxm-r1 move 39 to Bxm-c1
 move 23 to Bxm-r2 move 75 to Bxm-c2
 move '                                   ' & x'00' to bxm-mex(01)
 move ' > Cursor UP/DOWN                  ' & x'00' to bxm-mex(02)
 move ' > TAB / BACKTAB                   ' & x'00' to bxm-mex(03)
 move '                                   ' & x'00' to bxm-mex(04)
 move ' > ESCAPE                          ' & x'00' to bxm-mex(05)
 move '                                   ' & x'00' to bxm-mex(06)
 move ' > F2 = display a ruler            ' & x'00' to bxm-mex(07)
 move ' > PAGE UP / DOWN                  ' & x'00' to bxm-mex(08)
 move ' >                                 ' & x'00' to bxm-mex(09)
 move ' >                                 ' & x'00' to bxm-mex(10)
 move '                                   ' & x'00' to bxm-mex(11)
 move ' >                                 ' & x'00' to bxm-mex(12)
 move ' >                                 ' & x'00' to bxm-mex(13)
 move ' >                                 ' & x'00' to bxm-mex(14)
 move ' >                                 ' & x'00' to bxm-mex(15)
 move ' >                                 ' & x'00' to bxm-mex(16)
 move '                                   ' & x'00' to bxm-mex(17)
 move '                                   ' & x'00' to bxm-mex(18)
 move '                                   ' & x'00' to bxm-mex(19)
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
