       >>SOURCE FORMAT IS FREE
IDENTIFICATION DIVISION.
program-id. GC71CRUDEBRO is INITIAL program.
*> ***********************************************************************************
*> GnuCOBOL TT (TUI TOOLS) COLLECTION
*> Purpose:    CRUDE APPLICATION - LIST OF DATA RECORDS
*> Tectonics:  cobc -m GC71CRUDELST.COB  (use GnuCOBOL 2.0 or greater)
*> Usage:      call GC71CRUDELST using LnkFileName
*> Parameters: LnkFilename
*> Author:     Eugenio Di Lorenzo - Italia (DILO)
*> License:    Copyright 2017 E.Di Lorenzo - GNU Lesser General Public License, LGPL, 3.0 (or greater)
*> Version:    1.1 2017.05.28
*> Changelog:  1.0 first release.
*>             1.1 little enhancements
*> ***********************************************************************************
ENVIRONMENT DIVISION.
Configuration Section.
Special-Names.
   CRT STATUS IS wKeyPressed.
   Currency Sign is '€'
   Decimal-Point is Comma.

Input-Output  Section.
File-Control.
   select ANAGE
          assign to  AnageFSPEC
          access mode  is dynamic
          organization is indexed
          record key             is FdAnageKey
          alternate record key   is FdAnageCodAge
          alternate record key   is FdAnageCodFis
          alternate record key   is FdAnageRagSoc
          file status            is AnageFS.

*> **************************************************************
*>           D A T A     D I V I S I O N
*> **************************************************************
DATA DIVISION.
File Section.

fd  ANAGE label records are standard.
01  FdAnageRec.
   03 FdAnageKey    pic 9(009). *> chiave del file
   03 FdAnageCodAge pic x(010). *> codice agente nella divisione
   03 FdAnageCodFis pic x(016). *> cod.fis age o P.IVA societa
   03 FdAnageRagSoc pic x(030). *> ragione sociale agente o societa
   03               pic x(335).

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

01  wVisibilityNew   BINARY-SHORT .
01  wVisibilityOld   BINARY-SHORT .

01  wKeyPressed       PIC  9(04) VALUE 9999.
01  wChar             pic X value space.
01  wAnaNumber        pic 9(6).
01  wTime.
    03 wTimehh         pic  9(2).
    03 wTimemm         pic  9(2).
    03 wTimess         pic  9(2).
    03 wTimecc         pic  9(2).
01  wTimex             pic  x(8).
01  lin3              pic s9(04) comp-5 value   0.

01 GC71CRUDECUD PIC X(12) VALUE 'GC71CRUDECUD'. *> Create, Update, delete of data records
01 GC71CRUDEBRO PIC X(12) VALUE 'GC71CRUDEBRO'. *> Read / Browse

01  AnageFS           pic x(02).
01  AnageFSPEC        pic x(30) value 'ANAGE---.DAT'.

01  wAnageRec.
    03 wAnageKey      pic 9(009). *> chiave del file
    03 wAnageCtr      pic 9(009). *> contatore progressivo delle chiavi
    03                pic x(382).

01  pic  x.
    88 eof-lista            value '*'.
01  i            pic s9(04) comp-5 value   0.
01  k            pic s9(02) comp-5 value   0.
01  Ptr          pic s9(02) comp-5 value   0.
01  PtrMax       pic s9(02) comp-5 value   0.
01  wrk1         pic s9(04) comp-5 value   0.
01  penult       pic s9(02) comp-5 value   0.
01  flip-flop    pic s9(02) comp-5 value   0.
01  sw-display   pic  9(03)        value   0.
01  bco          pic s9(04) comp-5 value +15.
01  KeyActive    pic  9(01)        value   3.
01  DescrKey1    pic  x(14) value ' CODE)        '.
01  DescrKey2    pic  x(14) value ' FISCAL CODE) '.
01  DescrKey3    pic  x(14) value ' NAME)        '.
01  FirstTime    pic  x(01) value 'Y'.
01  SalvaCodAge  pic  x(10).
01  SalvaCodFis  pic  x(16).
01  SalvaRagSoc  pic  x(30).
*> SAVE/RESTORE SCREEN VARIABLES
01  wScreenName        PIC X(256).
01  wiScrOk            BINARY-LONG.

01  jj           pic s9(04) comp-5 value   0.
01  Stringa      pic  x(20)        value   space.

01  curr-row     pic  x(03) value 'bot'.
01  eof1         pic  x(01) value space.
    88 Eof       value 'Y'.
    88 NoEof     value 'N'.
01  bof1         pic  x(01) value space.
    88 Bof       value 'Y'.
    88 NoBof     value 'N'.

01  t1.
    03 t1-max          pic s9(04) comp-5.
    03 t1-tab.
       05 t1-el        occurs 50.
          07 t1-row    pic  x(450).
01  limite             pic  9(009) value 450.
01  limite1            pic  9(009) value 450.

01  wRow.
   03            pic x(01)    value '³'.
   03 rAnaKey    pic 999999999.
   03            pic x(01)    value '³'.
   03 rAnaNumber pic zzzzz9.
   03            pic x(01)    value '³'.
   03 rAnaRagSoc pic x(30).
   03            pic x(01)    value '³'.
   03 rAnaCodAge pic x(10).
   03            pic x(01)    value '³'.
   03 rAnaCodFis pic x(16).
   03            pic x(01)    value '³'.
   03 rAnaParIVA pic x(11).
   03            pic x(01)    value '³'.
   03 rAnaMatEna pic x(08).
   03            pic x(01)    value '³'.
   03 rAnaTelCas pic x(14).
   03            pic x(01)    value '³'.
   03 rAnaTelCel pic x(14).
   03            pic x(01)    value '³'.
   03 rAnaTelFax pic x(14).
   03            pic x(02)    value '³ '.
   03 rAnaTipCon pic x(01).
   03            pic x(01)    value ' '.
   03 rAnaDesTco pic x(10).
   03            pic x(03)    value ' ³ '.
   03 rAnaTipSog pic x(01).
   03            pic x(01)    value ' '.
   03 rAnaDesTso pic x(11).
   03            pic x(03)    value ' ³ '.
   03 rAnaSesso  pic x(01).
   03            pic x(03)    value ' ³ '.
   03 rAnaTipLiq pic x(01).
   03            pic x(03)    value ' ³ '.
   03 rAnaNumAut pic x(01).
   03            pic x(03)    value ' ³ '.
   03 rAnaSubage pic x(01).
   03            pic x(03)    value ' ³ '.
   03 rAnaPerIva pic 9(02).
   03            pic x(01)    value '³'.
   03 rAnaIndiri pic x(30).
   03            pic x(01)    value '³'.
   03 rAnaCAP    pic x(05).
   03            pic x(01)    value '³'.
   03 rAnaLocali pic x(30).
   03            pic x(01)    value '³'.
   03 rAnaProv   pic x(02).
   03            pic x(01)    value '³'.
   03 rAnaDataIn pic 9999.99.99 BLANK WHEN ZERO.
   03            pic x(01)    value '³'.
   03 rAnaDataCe pic 9999.99.99 BLANK WHEN ZERO.
   03            pic x(01)    value '³'.
   03 rAnaTipoCe pic BxB.
   03            pic x(01)    value '³'.
   03 rAnaAntici pic -----.--9,99.
   03            pic x(01)    value '³'.
   03 rAnaTraSin pic -----.--9,99.
   03            pic x(01)    value '³'.
   03 rAnaConSpe pic -----.--9,99.
   03            pic x(01)    value '³'.
   03 rAnaAssicu pic     ---.--9,99.
   03            pic x(01)    value '³'.
   03 rAnaReteVe pic x(06).
   03            pic x(01)    value '³'.
   03 rAnaZonaVe pic x(06).
   03            pic x(01)    value '³'.
   03 rAnaCamCom pic x(09).
   03            pic x(01)    value '³'.
   03 rAnaNumRuo pic x(06).
   03            pic x(01)    value '³'.
   03 rAnaIscRim pic x(18).
   03            pic x(01)    value '³'.
   03 rAnaCodFor pic x(06).
   03            pic x(01)    value '³'.
   03 rAnaCodcdc pic x(06).
   03            pic x(01)    value '³'.
   03 rAnaSetCon pic x(04).
   03            pic x(01)    value '³'.
   03 rAnaProvvi pic x(14).
   03            pic x(01)    value '³'.

01  wRowT.
     03 pic x(01)    value '³'.
     03 pic x(09)    value '**RECID**'.
     03 pic x(01)    value '³'.
     03 pic x(06)    value ' NUM. '.
     03 pic x(01)    value '³'.
     03 pic x(30)    value 'Name                          '.
     03 pic x(01)    value '³'.
     03 pic x(10)    value 'Code      '.
     03 pic x(01)    value '³'.
     03 pic x(16)    value 'Fiscal Code     '.
     03 pic x(01)    value '³'.
     03 pic x(11)    value 'VAT code   '.
     03 pic x(01)    value '³'.
     03 pic x(08)    value 'Matric  '.
     03 pic x(01)    value '³'.
     03 pic x(14)    value 'Phone   '.
     03 pic x(01)    value '³'.
     03 pic x(14)    value 'Mobile phone'.
     03 pic x(01)    value '³'.
     03 pic x(14)    value 'Fax'.
     03 pic x(01)    value '³'.
     03 pic x(14)    value 'Contract type'.
     03 pic x(01)    value '³'.
     03 pic x(15)    value 'Tipo soggetto'.
     03 pic x(01)    value '³'.
     03 pic x(03)    value 'sex'.
     03 pic x(01)    value '³'.
     03 pic x(03)    value 'Liq'.
     03 pic x(01)    value '³'.
     03 pic x(03)    value 'num'.
     03 pic x(01)    value '³'.
     03 pic x(03)    value 'sub'.
     03 pic x(01)    value '³'.
     03 pic x(03)    value 'VAT'.
     03 pic x(01)    value '³'.
     03 pic x(30)    value 'Address  '.
     03 pic x(01)    value '³'.
     03 pic x(05)    value 'ZIP'.
     03 pic x(01)    value '³'.
     03 pic x(30)    value 'City'.
     03 pic x(01)    value '³'.
     03 pic x(02)    value 'Pr'.
     03 pic x(01)    value '³'.
     03 pic x(10)    value 'Start Date'.
     03 pic x(01)    value '³'.
     03 pic x(10)    value '  End Date'.
     03 pic x(01)    value '³'.
     03 pic x(03)    value 'Tip'.
     03 pic x(01)    value '³'.
     03 pic x(12)    value '  M.Payment'.
     03 pic x(01)    value '³'.
     03 pic x(12)    value ' Union Ret.'.
     03 pic x(01)    value '³'.
     03 pic x(12)    value ' Conc.Spese'.
     03 pic x(01)    value '³'.
     03 pic x(10)    value 'Insurance'.
     03 pic x(01)    value '³'.
     03 pic x(06)    value 'Rete'.
     03 pic x(01)    value '³'.
     03 pic x(06)    value 'S.Area'.
     03 pic x(01)    value '³'.
     03 pic x(09)    value 'CCIAA '.
     03 pic x(01)    value '³'.
     03 pic x(06)    value 'RegDit'.
     03 pic x(01)    value '³'.
     03 pic x(18)    value 'Iscr.Reg.Imprese'.
     03 pic x(01)    value '³'.
     03 pic x(06)    value 'Vendor'.
     03 pic x(01)    value '³'.
     03 pic x(06)    value 'CostC'.
     03 pic x(01)    value '³'.
     03 pic x(04)    value 'SeCo'.
     03 pic x(01)    value '³'.
     03 pic x(14)    value 'Commission'.
     03 pic x(01)    value '³'.
     03 pic x(26)    value ' <== end of data'.
     03 pic x(10)    value space.

 01  wHeader pic x(080) value space.
 01  ruler.
     05 pic x(100) value
        '1...+....1....+....2....+....3....+....4....+....50...+....6....+....7....+....8....+....9....+....1'.
     05 pic x(100) value
        '00..+....1....+....2....+....3....+....4....+....150..+....6....+....7....+....8....+....9....+....2'.
     05 pic x(100) value
        '00..+....1....+....2....+....3....+....4....+....250..+....6....+....7....+....8....+....9....+....3'.
     05 pic x(100) value
        '00..+....1....+....2....+....3....+....4....+....350..+....6....+....7....+....8....+....9....+....4'.
     05 pic x(050) value
        '00..+....1....+....2....+....3....+....4....+....5'.
 01  top-of-list.
     03  pic x(100) value
     '****** top of file ***    *** top of file ***        *** top of file ***    *** top of file ***     '.
     03  pic x(100) value
     '   *** top of file ***    *** top of file ***        *** top of file ***    *** top of file ***     '.
     03  pic x(100) value
     '   *** top of file ***    *** top of file ***        *** top of file ***    *** top of file ***     '.
     03  pic x(100) value
     '   *** top of file ***    *** top of file ***        *** top of file ***    *** top of file ***     '.
     03 pic x(050) value
        '   *** top of file ***    *** top of file ***     '.
 01  end-of-list.
     03  pic x(100) value
     '****** end of file ***    *** end of file ***        *** end of file ***    *** end of file ***     '.
     03  pic x(100) value
     '   *** end of file ***    *** end of file ***        *** end of file ***    *** end of file ***     '.
     03  pic x(100) value
     '   *** end of file ***    *** end of file ***        *** end of file ***    *** end of file ***     '.
     03  pic x(100) value
     '   *** end of file ***    *** end of file ***        *** end of file ***    *** end of file ***     '.
     03  pic x(050) value
        '   *** end of file ***    *** end of file ***     '.

 01  wMenu1 pic  x(80) value
 *>      ' F1-<Help>                                                          Scroll: XXX '.
         ' F1=Help Enter ESC CursorKeys PgUp/Dn Home Ctrl-C/E/D/R Ctrl-F1/2/3  Scroll:XXX '.
 *>       12345678901234567890123456789012345678901234567890123456789012345678901234567890
 *>                1         2         3         4         5         6         7

01  Lista-Area.
    *> li-righe  25, 43, 50 righe da visualizzare a video
    *> li-scroll valore iniziale di scroll ad ogni tasto -> o <-
    *> li-start  colonna iniziale di visualizzazione del tabulato
    *>           DEFAULT = 1
    *> li-lett-fac se = 'Y' allora si visualizza il tabulato su
    *>             "carta a lettura facilitata" usando i duefun
    *>             colori che seguono. Altrimenti si usa solo il
    *>             colore li-back1 per lo sfondo.
    *> li-back1/2 colori da alternare per rendere l'effetto della
    *>            carta a lettura facilitata.
    *> li-fore   colore di foreground per i caratteri del tabulato
    05  li-righe    pic  9(04) value  25.
    05  li-scroll   pic  9(03) value  05.
    05  li-start    pic s9(04) value  +1.
    *> 05  li-lett-fac pic  x(01) value 'Y'.
    05  li-back1    pic s9(04) comp-5 value +01. *> blu
    05  li-fore     pic s9(04) comp-5 value +14. *> giallo

*> Header colors
 01  t-back         pic s9(04) comp-5 value green.
 01  t-fore         pic s9(04) comp-5 value black.
*> cursor row colors
 01  c-back         pic s9(04) comp-5 value cyan .
 01  c-fore         pic s9(04) comp-5 value white.

 01  LnkFunction     pic x(001).
 01  LnkKey          pic 9(009).
 01  LnkKeyActive    pic x(001).

 copy 'GC71CRUDEREC.CPY' .

 COPY 'GC09BUTTONS.CPY'.
 COPY 'GC01BOX.CPY'.
 COPY 'GC02BOXMEX.CPY'.
 COPY 'GC98KEYCODE.CPY'.


 LINKAGE SECTION.
 01  LnkFileName     pic x(012).

*> **************************************************************
*>           P R O C E D U R E   D I V I S I O N
*> **************************************************************
PROCEDURE DIVISION using LnkFileName.

    *> sets in order to detect the PgUp, PgDn, PrtSc(screen print), Esc keys,
    set environment 'COB_SCREEN_EXCEPTIONS' TO 'Y'.
    set environment 'COB_SCREEN_ESC'        TO 'Y'.

     move LnkFileName to AnageFSPEC

     move 11       to li-start
     compute t1-max = li-righe - 3
     compute penult = li-righe - 1

     perform DisplayHeader     thru DisplayHeaderEx
     perform DisplayMenu       thru DisplayMenuEx

     perform Initialization    thru InitializationEx
     perform DisplayTable      thru DisplayTableEx
     perform CursorHide        thru CursorHideEx.

*> *************************************************************
*> WAIT for User input - Execute the command
*> *************************************************************
 Loop-Accept-a-Key.
  perform Accept-a-Key thru Accept-a-KeyEx

  EVALUATE TRUE

     *> *************************************************************
     *> CURSOR DOWN - show next row - scroll up
     *> *************************************************************
     WHEN Key-Pressed = Key-CursDn
          if Ptr = 22
             if Bof set NoBof to true end-if
             if not Eof
                *> set 1 row up the table
                compute limite1 = limite + 1
                move t1-tab (limite1:) to t1-tab
                compute wrk1 = ((t1-max - 1) * limite)
                move space to t1-tab(wrk1:limite)
                move 1 to sw-display
                *> se il puntatore di lettura sul file era sul record
                *> della prima riga del video lo porta sull'ultima
                *> posiziona il puntatore delle read
                if curr-row = 'top'
                   perform varying i from 1 by 1 until i = t1-max
                           perform ReadNext thru ReadNextEx
                   end-perform
                   move 'bot' to curr-row
                end-if
                perform ReadNext thru ReadNextEx
               if AnageFS = '10'
                  move end-of-list to t1-row(t1-max)
                  set Eof to true
               else
                  perform RowSetting thru RowSettingEx
                  move wRow to t1-row(t1-max)
               end-if
               display t1-row (t1-max) (li-start:80)
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
     *> CCURSOR UP - show previous row - scroll down
     *> *************************************************************
     WHEN Key-Pressed = Key-CursUp
          if Ptr = 1
             if Eof set NoEof to true end-if
             if not Bof
                *> move table rows
                compute wrk1 = t1-max - 1
                perform varying i from wrk1 by -1 until i < 1
                        move t1-row(i) to t1-row(i + 1)
                end-perform
                move 1 to sw-display
                *> se il puntatore di lettura sul file era sul record
                *> della ultima riga del video lo porta sulla prima
                *> posiziona il puntatore delle read
                if curr-row = 'bot'
                   perform varying i from 1 by 1 until i = t1-max
                           perform ReadPrevious thru ReadPreviousEx
                           *> if AnageFS = '10'
                           *>    move t1-max to i
                           *> end-if
                           end-perform
                   move 'top' to curr-row
                end-if
                perform ReadPrevious thru ReadPreviousEx
                if AnageFS = '10' or AnageFS = '46'
                   move top-of-list to t1-row(1)
                   set Bof to true
                   if AnageFS = '46' add 1 to PtrMax end-if
                else
                   perform RowSetting thru RowSettingEx
                   move wRow to t1-row(1)
                end-if
                *> visualizza la riga
                display t1-row (1) (li-start:80) at line 03 column 01
                    with background-color bco foreground-color li-fore
             end-if
          else
             compute Ptr = Ptr - 1
             move 1 to sw-display
          end-if

     *> *************************************************************
     *> PAGE UP
     *> *************************************************************
     WHEN Key-Pressed = Key-PgUp
          if Eof set NoEof to true end-if
          if not Bof
             *> set the "read pointer"
             if curr-row = 'bot'
                perform varying i from 1 by 1 until i = t1-max
                        perform ReadPrevious thru ReadPreviousEx
                end-perform
                move 'top' to curr-row
             end-if
             perform varying i from t1-max by -1 until i < 1 or Bof
                     perform ReadPrevious thru ReadPreviousEx
                     if AnageFS = '10'
                        move top-of-list to t1-row(1)
                        set Bof to true
                     else
                        perform RowSetting thru RowSettingEx
                        move wRow to t1-row(i)
                     end-if
             end-perform
             *> se si e' a Start-Program file ma la videata e' piena solo
             *> in parte allora si visualizza una videata piena
             if Bof and i not = 0
                perform FirstPage thru FirstPageEx
                move 'bot' to curr-row
             end-if
             move 1 to sw-display
          end-if

     *> *************************************************************
     *> PAGE DOWN
     *> *************************************************************
     WHEN Key-Pressed = Key-PgDn
          if Bof set NoBof to true end-if
          if not Eof
             *> set the "read pointer"
             if curr-row = 'top'
                perform varying i from 1 by 1 until i = t1-max
                        perform ReadNext thru ReadNextEx
                end-perform
                move 'bot' to curr-row
             end-if
             perform varying i from 1 by 1 until i > t1-max or Eof
                     perform ReadNext thru ReadNextEx
                     if AnageFS = '10'
                        *> si potrebbe fare subito la perform a 'ultima-pagina' ?
                         perform RowSetting thru RowSettingEx
                         move wRow to t1-row(i)
                         if i < t1-max
                            move end-of-list to t1-row(i + 1)
                         end-if
                         *>  move end-of-list to t1-row(i)
                        set Eof to true
                     else
                        perform RowSetting thru RowSettingEx
                        move wRow to t1-row(i)
                     end-if
             end-perform
           *> if reached the end of file but the screen is not entirely filled
           *> then the program set to display a filled screen
           *> (si potrebbe fare sempre appena raggionta Eof ?)
           *> if Eof and i not = t1-max + 1
             if Eof
                perform LastPage thru LastPageEx
                move 'top' to curr-row
             end-if
             move 1 to sw-display
          end-if

     *> *************************************************************
     *> CURSOR RIGHT  ->  OR "TAB KEY" (scroll right by "li-scroll" columns)
     *> *************************************************************
      WHEN  Key-Pressed = Key-CursRight or Key-Tab
          if li-start <= (length of t1-row(1) - 80)    *> 132-80=52
             add li-scroll to li-start
             if li-start > length of t1-row(1) - 80 + 1
                compute li-start = length of t1-row(1) - 80  + 1
             end-if
             move 1 to sw-display
          else
             perform Beepp thru Beepp-ex
          end-if

     *> *************************************************************
     *> CURSOR LEFT  <-  (scroll left by "li-scroll" columns)
     *> *************************************************************
     WHEN Key-Pressed = Key-CursLeft
          if li-start not = 1
             subtract li-scroll from li-start
             if li-start < 1
                move 1 to li-start
             end-if
             move 1 to sw-display
          else
             perform Beepp thru Beepp-ex
          end-if

     *> *************************************************************
     *> HOME = display the file from the first record of the order selected
     *> *************************************************************
     WHEN Key-Pressed = Key-Home
        Close ANAGE
        set NoEof to true
        set NoBof to true
        move 'Y' to FirstTime
        perform Initialization thru InitializationEx
        move 1 to sw-display

     *> *************************************************************
     *> F1 = DISPLAY A HELP WINDOW
     *> *************************************************************
        WHEN Key-Pressed = Key-F1
             perform Help thru HelpEx
             move 1 to sw-display
             *> perform CursorHide thru CursorHideEx

     *> *************************************************************
     *> + = Increases the horizontal scroll
     *> *************************************************************
     WHEN Key-Pressed = Key-plus
          add 1 to li-scroll
          if flip-flop = 0
           display li-scroll at line li-righe column 77
            with background-color t-back foreground-color white highlight
          end-if
     *> *************************************************************
     *> - = Decreases the horizontal scroll
     *> *************************************************************
     WHEN Key-Pressed = Key-minus
          subtract 1 from li-scroll
          if flip-flop = 0
           display li-scroll at line li-righe column 77
             with background-color t-back foreground-color white highlight
          end-if
     *> *************************************************************
     *> CTRL-R = display/hide a ruler
     *> *************************************************************
     WHEN Key-Pressed = Key-Ctrl-r
          if flip-flop = 0
             move 1 to flip-flop
             display ruler(li-start:80) at line li-righe column 01
                 with background-color t-back foreground-color t-fore
          else
             move 0 to flip-flop
             perform DisplayMenu thru DisplayMenuEx
          end-if

     *> *************************************************************
     *> CTRL F2 = select CODE as ALTERNATE KEY active SORT SCREEN LIST BY CODE
     *> *************************************************************
     WHEN Key-Pressed = Key-Ctrl-F2
        move 1   to KeyActive
        move 'Y' to FirstTime
        perform  Initialization thru InitializationEx
        move 1   to sw-display
        perform  DisplayMenu thru DisplayMenuEx

     *> *************************************************************
     *> CTRL F3 = select FISCAL CODE as ALTERNATE KEY active & SORT SCREEN LIST BY FISCAL CODE
     *> *************************************************************
     WHEN Key-Pressed = Key-Ctrl-F3
        move 2   to KeyActive
        move 'Y' to FirstTime
        perform  Initialization thru InitializationEx
        move 1   to sw-display
        perform  DisplayMenu thru DisplayMenuEx

     *> *************************************************************
     *> CTRL F1 = = select NAME as ALTERNATE KEY active & SORT SCREEN LIST BY NAME
     *> *************************************************************
     WHEN Key-Pressed = Key-Ctrl-F1
        move 3   to KeyActive
        move 'Y' to FirstTime
        perform  Initialization thru InitializationEx
        move 1   to sw-display
        perform  DisplayMenu thru DisplayMenuEx

     *> *************************************************************
     *> CTRL-C = call GC71CRUDECUD to Create a new record
     *> *************************************************************
     WHEN Key-Pressed = Key-Ctrl-c
          move 'C' to LnkFunction
          perform Call-to-InsertUpdateDelete thru Call-to-InsertUpdateDeleteEx

     *> *************************************************************
     *> CTRL-U or ENTER = call GC71CRUDECUD to update/modify the record
     *> - when return the program list records starting froma the edited
     *>   record that became the first record on screen
     *> *************************************************************
     WHEN Key-Pressed = Key-Enter or Key-Ctrl-u
          if t1-row(ptr)(1:3) not = '***' *> scarta top/end of file
             move 'U' to LnkFunction
             perform Call-to-InsertUpdateDelete thru Call-to-InsertUpdateDeleteEx
          end-if

     *> *************************************************************
     *> CTRL-D = call GC71CRUDECUD to delete the record
     *> *************************************************************
     WHEN Key-Pressed = Key-Ctrl-d
        if t1-row(ptr)(1:3) not = '***' *> scarta top/end of file
         move 'D' to LnkFunction
         perform Call-to-InsertUpdateDelete thru Call-to-InsertUpdateDeleteEx
        end-if


     *> *************************************************************
     *> ESCAPE - EXIT
     *> *************************************************************
     When Key-Pressed = Key-Escape
          go End-Program

     *> *************************************************************
     *> Altro tasto = posiziona sul record
     *> *************************************************************
     *> WHEN other
        *> add 1 to jj
        *> inspect oAL converting
        *> 'abcdefghijklmnopqrstuvwxyz' to 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
        *> move oAL to stringa(jj:1)
        *> evaluate KeyActive
         *> when 1 move stringa to FdAnageCodAge
         *> when 2 move stringa to FdAnageCodFis
         *> when 3 move stringa to FdAnageRagSoc
        *> end-evaluate
        *> move 'N' to FirstTime
        *> perform Initialization thru InitializationEx
        *> if Eof
         *> perform LastPage thru LastPageEx
         *> move 'top' to curr-row
        *> end-if
        *> perform DisplayMenu thru DisplayMenuEx
        *> move 1 to sw-display
    *> WHEN OTHER
         *> evaluate Key-Pressed
             *> when 097 move 'a' to wChar
             *> when 098 move 'b' to wChar
             *> when 099 move 'c' to wChar
             *> when 100 move 'd' to wChar
         *> end-evaluate

        *> add 1 to jj
        *> inspect wChar converting 'abcdefghijklmnopqrstuvwxyz' to 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
        *> move wChar to stringa(jj:1)
        *> evaluate KeyActive
           *> when 1 move stringa to FdAnageCodAge
           *> when 2 move stringa to FdAnageCodFis
           *> when 3 move stringa to FdAnageRagSoc
        *> end-evaluate
        *> move 'N' to FirstTime
        *> perform Initialization thru InitializationEx
        *> if Eof
           *> perform LastPage thru LastPageEx
           *> move 'top' to curr-row
        *> end-if
        *> perform DisplayMenu thru DisplayMenuEx
        *> move 1 to sw-display

   END-EVALUATE

   if SW-DISPLAY = 1
      perform DisplayHeader  thru DisplayHeaderEx
      perform DisplayTable   thru DisplayTableEx
      perform DisplayMenu    thru DisplayMenuEx
      move 0 to sw-display
      if flip-flop = 1
         display ruler(li-start:80) at line li-righe column 01
                 with background-color t-back foreground-color t-fore
      end-if
   end-if
   perform CursorHide thru CursorHideEx

   go Loop-Accept-a-Key.

 End-Program.
   DISPLAY  ' ' AT 0101 with blank screen END-DISPLAY
   perform CursorShow thru CursorShowEx
   close ANAGE
   GOBACK.


*> *************************************************************
*> SUBROUTINES AREA
*> *************************************************************
 DisplayTable.
     move 2 to k
     perform varying i from 1 by 1 until i > t1-max
        add 1 to k
        display t1-row (i) (li-start:80) at line k column 01
           with background-color bco foreground-color li-fore
     end-perform

     *> chancge colors attribute of the "cursor" row
     compute k = Ptr + 2
     display t1-row (Ptr) (li-start:80) at line k column 01
        with background-color c-back foreground-color c-fore .
 DisplayTableEx. EXIT.

DisplayHeader.
    string  ' C.R.U.DE. APPLICATION (File: ' LnkFileName ' sorted by: '
            delimited by size into wHeader
    display wHeader at 0101 with  Background-Color t-back Foreground-Color white highlight
    evaluate KeyActive
        when 1 display DescrKey1 at 0154 with background-color t-back foreground-color white highlight
        when 2 display DescrKey2 at 0154 with background-color t-back foreground-color white highlight
        when 3 display DescrKey3 at 0154 with background-color t-back foreground-color white highlight
     end-evaluate
     display GC71CRUDEBRO at 0168 with background-color t-back foreground-color white highlight
   *> header of rows
    display wRowT(li-start:80) at 0201 with background-color red foreground-color white highlight.
DisplayHeaderEx. exit.

DisplayMenu.
     move li-scroll to wMenu1(77:3)
     display wMenu1 at line li-righe column 01
        with background-color t-back foreground-color white highlight.
DisplayMenuEx. exit.

Initialization.
     *> initial filling of table: done first time & at return from edit or delete
     move   0           to PtrMax wAnaNumber
     move   LnkFileName to AnageFSPEC
     Open Input ANAGE

     *> test if file eexist
     if AnageFS not = '35'
         *> at first exceution it starts from first file record
         if FirstTime = 'Y'
            move low-value to FdAnageRec
            set NoEof to true
         end-if
         evaluate KeyActive
            when 1 Start ANAGE Key >= FdAnageCodAge end-start
            when 2 Start ANAGE Key >= FdAnageCodFis end-start
            when 3 Start ANAGE Key >= FdAnageRagSoc end-start
         end-evaluate
         set NoEof to true               *> if deleted last record
         if AnageFS = '23'               *> the start is not ok so the program
            move low-value to FdAnageRec *> display from first file record
            evaluate KeyActive
               when 1 Start ANAGE Key >= FdAnageCodAge end-start
               when 2 Start ANAGE Key >= FdAnageCodFis end-start
               when 3 Start ANAGE Key >= FdAnageRagSoc end-start
            end-evaluate
         end-if
         *> *********************************************************
         *> fill the table with screen rows
         *> *********************************************************
         if AnageFS = '00'
            perform varying i from 1 by 1 until (i > t1-max or eof)
               perform ReadNext thru ReadNextEx
               if AnageFS = '10'
                  move end-of-list to t1-row(i)
                  set Eof to true
               else
                  add 1 to PtrMax
                  perform RowSetting thru RowSettingEx
                  move wRow        to t1-row(i)
               end-if
            end-perform
         else
            move end-of-list to t1-row(i)
            set Eof to true
         end-if

     else
         *> if file does not exist
         move end-of-list to t1-row(1)
         set Eof to true
     end-if

     move 'bot' to curr-row
     move li-back1 to bco
     move 1 to Ptr.
InitializationEx. EXIT.

RowSetting.
    move AnageKey  to rAnaKey
    move wAnanumber  to rAnaNumber
    move AnageCodAge to rAnaCodAge
    move AnageMatEna to rAnaMatEna
    move AnageCodFis to rAnaCodFis
    move AnageRagSoc to rAnaRagSoc
    move AnageParIVA to rAnaParIVA
    move AnageIndLeg to rAnaIndiri
    move AnageCAPLeg to rAnaCAP
    move AnageLocLeg to rAnaLocali
    move AnageProLeg to rAnaProv
    move AnageTipCon to rAnaTipCon
    move AnageTipSog to rAnaTipSog

    evaluate AnageTipCon
     when 'M' move 'MONO ' to rAnaDesTco
     when 'P' move 'PLURI' to rAnaDesTco
    end-evaluate

    evaluate AnageTipSog
     when 'A' move 'AGENT          ' to rAnaDesTso
     when 'P' move 'PEOPLE COMPANY ' to rAnaDesTso
     when 'C' move 'CAPITAL COMPANY' to rAnaDesTso
    end-evaluate

    move AnageSesso  to rAnaSesso
    move AnageDataIn to rAnaDataIn
    move AnageDataCe to rAnaDataCe
    move AnageTipoCe to rAnaTipoCe
    move AnageTelCas to rAnaTelCas
    move AnageTelCel to rAnaTelCel
    move AnageTelFax to rAnaTelFax
    move AnageTipLiq to rAnaTipLiq
    move AnageNumAut to rAnaNumAut
    move AnageSubAge to rAnaSubage
    move AnagePerIVA to rAnaPerIva
    move AnageAntici to rAnaAntici
    move AnageTraSin to rAnaTraSin
    move AnageConSpe to rAnaConSpe
    move AnageReteVe to rAnaReteVe
    move AnageZonaVe to rAnaZonaVe
    move AnageCamCom to rAnaCamCom
    move AnageNumRuo to rAnaNumRuo
    move AnageIscRim to rAnaIscRim
    move AnageCodFor to rAnaCodFor
    move AnageCodcdc to rAnaCodcdc
    move AnageProvvi to rAnaProvvi
    move AnageSetCon to rAnaSetCon
    move AnageAssicu to rAnaAssicu.
RowSettingEx. exit.

Call-to-InsertUpdateDelete.
   perform CursorShow thru CursorShowEx
   perform ScreenSave thru ScreenSaveEx
   Close ANAGE

*> salva le varie key alternative
*>   move t1-row(ptr) (012:10) to SalvaCodAge
*>   move t1-row(ptr) (023:16) to SalvaCodFis
*>   move t1-row(ptr) (040:30) to SalvaRagSoc

   move t1-row(ptr)           to wRow
   move rAnaCodAge            to SalvaCodAge
   move rAnaCodFis            to SalvaCodFis
   move rAnaRagSoc            to SalvaRagSoc

   *> *********************************************************************************
   *> CALL TO CREATE/UPDATE/DELETE A RECORD
   *> *********************************************************************************
   move t1-row(ptr) (2:9) to LnkKey
   move KeyActive         to LnkKeyActive
   call   GC71CRUDECUD using LnkFileName LnkFunction LnkKey LnkKeyActive
   cancel GC71CRUDECUD

   *> ricarica in Fd le varie key alternative
*>   Open Input ANAGE
*>   move LnkKey to FdAnageKey
*>   Read ANAGE
   move SalvaCodAge to FdAnageCodAge
   move SalvaCodFis to FdAnageCodFis
   move SalvaRagSoc to FdAnageRagSoc

   move 'N' to FirstTime
   perform Initialization thru InitializationEx
   if Eof
      perform LastPage thru LastPageEx
      move 'top' to curr-row
   end-if
   perform DisplayMenu thru DisplayMenuEx
   move 1 to sw-display

   perform ScreenRestore thru ScreenRestoreEx.
Call-to-InsertUpdateDeleteEx. exit.


FirstPage.
   move top-of-list to t1-row(1)
   perform varying i from 2 by 1 until i > t1-max or Eof
      perform ReadNext thru ReadNextEx
      if AnageFS = '10' *> finefile
         move end-of-list to t1-row(i)
         set Eof to true
      else
         perform RowSetting thru RowSettingEx
         move wRow to t1-row(i)
      end-if
   end-perform.
FirstPageEx. EXIT.

LastPage.
   move 1 to ptrMax
   *> read backward from last record
   evaluate KeyActive
      when 1 Start ANAGE Key > FdAnageCodAge end-start
      when 2 Start ANAGE Key > FdAnageCodFis end-start
      when 3 Start ANAGE Key > FdAnageRagSoc end-start
   end-evaluate

   move end-of-list to t1-row(t1-max)
   compute wrk1 = t1-max - 1
   perform varying i from wrk1 by -1 until i < 1 or Bof
      perform ReadPrevious thru ReadPreviousEx
      if AnageFS = '10'
         move top-of-list to t1-row(1)
         set Bof to true
      else
         add 1 to PtrMax
         perform RowSetting thru RowSettingEx
         move wRow to t1-row(i)
      end-if
   end-perform.
LastPageEx. EXIT.

Accept-a-Key.

   *> *********************************************************************************
   *> compute lin3 = 25
    *> accept wTime from time
    *> string wTime(1:2) ':' wTime(3:2) ':' wTime(5:2) delimited by size into wTimex
    *> display ' '   at line 01 column 71
            *> with background-color green foreground-color white highlight
    *> display wTimex at line 01 column 72
            *> with background-color green foreground-color white highlight
    *> display ' '   at line 01 column 80
            *> with background-color green foreground-color white highlight

   *> *> loop to diaplay time until a key is pressed
   *> perform forever

        *> accept omitted with AUTO TIMEOUT 1 end-accept

        *> IF wKeyPressed = K-TIMEOUT
           *> *> after a timeout, accept returns 8001
              *> accept wTime from time
              *> string wTime(1:2) ':' wTime(3:2) ':' wTime(5:2) delimited by size into wTimex
              *> display ' '   at line 01 column 71
                      *> with background-color green foreground-color white highlight
              *> display wTimex at line 01 column 72
                      *> with background-color green foreground-color white highlight
              *> display ' '   at line 01 column 80
                      *> with background-color green foreground-color white highlight
          *> else
              *> EXIT PERFORM
          *> END-IF
   *> end-perform.

   perform CursorHide thru CursorHideEx
   call static "getch" returning Key-Pressed end-call.
Accept-a-KeyEx.

Beepp.
    CALL X'E5'
    perform CursorHide thru CursorHideEx.
Beepp-EX. exit.

CursorHide.
  *> hide the cursor and save its previous state
  *> (use always a display or an accept at .... before to have a call to "initscr"
  move 0 to wVisibilityNew
  call static "curs_set" using by value wVisibilityNew returning wVisibilityOld end-call.
CursorHideEx. EXIT.

CursorShow.
  *> reset (show) the cursor to its previous state
  move wVisibilityOld to wVisibilityNew
  call static "curs_set" using by value wVisibilityNew returning wVisibilityOld end-call.
CursorShowEx. EXIT.

*> **************************************************************
*>  READ RECORDS
*> **************************************************************
ReadNext.
   read ANAGE next into AnageRec
   *> skip the record with key counter
   if FdAnageKey = 999999999
      read ANAGE next into AnageRec
   end-if.
   compute wAnaNumber = wAnanumber + 1.
ReadNextEx. exit.

ReadPrevious.
   read ANAGE previous into AnageRec
   *> skip the record with key counter
   if FdAnageKey = 999999999
      read ANAGE previous into AnageRec
   end-if.
   compute wAnaNumber = wAnanumber - 1.
ReadPreviousEx. exit.

Help.
    perform ScreenSave thru ScreenSaveEx

    move 03 to Bxm-r1 move 39 to Bxm-c1
    move 23 to Bxm-r2 move 75 to Bxm-c2
    move 'N' to Bxm-fcoMH
    move '                                   ' & x'00' to bxm-mex(01)
    move ' > CursUp/Down/Right/Left PgUp/Dn  ' & x'00' to bxm-mex(02)
    move ' > Home: go to top of file         ' & x'00' to bxm-mex(03)
    move ' > ESC:  exit                      ' & x'00' to bxm-mex(04)
    move '                                   ' & x'00' to bxm-mex(05)
    move ' > Enter:  update of record        ' & x'00' to bxm-mex(06)
    move ' > Ctrl-C: create a new record     ' & x'00' to bxm-mex(07)
    move ' > Ctrl-U: update of record        ' & x'00' to bxm-mex(08)
    move ' > Ctrl-D: delete of record        ' & x'00' to bxm-mex(09)
    move '                                   ' & x'00' to bxm-mex(10)
    move ' > Ctrl-F1: sort by NAME           ' & x'00' to bxm-mex(11)
    move ' > Ctrl-F2: sort by CODE           ' & x'00' to bxm-mex(12)
    move ' > Ctrl-F3: sort by FISCAL CODE    ' & x'00' to bxm-mex(13)
    move '                                   ' & x'00' to bxm-mex(14)
    move ' > Ctrl-R: display/hide a ruler    ' & x'00' to bxm-mex(15)
    move ' > +/- : modify horiz.scroll value ' & x'00' to bxm-mex(16)
    move '                                   ' & x'00' to bxm-mex(17)
    move '                                   ' & x'00' to bxm-mex(18)
    move '                                   ' & x'00' to bxm-mex(19)
    CALL GC02BOXMEX USING BY REFERENCE BOXMEX-AREA

    perform ScreenRestore thru ScreenRestoreEx.
HelpEx. exit.

ScreenSave.
   move Z'BOXMEX.SCR' to wScreenName
   call static 'scr_dump' using by reference wScreenName returning wiScrOk end-call.
ScreenSaveEx. Exit.

ScreenRestore.
  call static 'scr_restore' using by reference wScreenName returning wiScrOk end-call
  CALL 'CBL_DELETE_FILE' USING wScreenName.
ScreenRestoreEx. Exit.
