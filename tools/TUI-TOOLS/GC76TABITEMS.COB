       >>SOURCE FORMAT IS FREE
       REPLACE ==:BCOL:== BY ==with BACKGROUND-COLOR==
               ==:FCOL:== BY ==FOREGROUND-COLOR==.
IDENTIFICATION DIVISION.
Program-id. GC76TABITEMS.
*> ***********************************************************************************
*> GnuCOBOL TT (TUI TOOLS) COLLECTION
*> Purpose:    modify, delete, display of Table items (records)
*> Tectonics:  cobc -x GC76TABITEMS.COB  (use GnuCOBOL 2.0 or greater)
*> Usage:      GC76TABITEMS
*> Parameters:
*> Author:     Eugenio Di Lorenzo - Italia (DILO)
*> License:    Copyright 2017 E.Di Lorenzo - LGPL, 3.0 (or greater)
*> Version:    1.0 2017.07.01
*> Changelog:  1.0 first release.
*> ************************************************************************************
ENVIRONMENT DIVISION.
CONFIGURATION SECTION.
SPECIAL-NAMES.
   CRT STATUS IS ws-KEY.
   Currency Sign is '€'.
   Decimal-Point is Comma.
INPUT-OUTPUT SECTION.
File-Control.
   select Tabe
          assign       to TABEFSPEC
          access mode  is dynamic
          organization is indexed
          record key   is Tabe-key
          file status  is Tabe-fs.

 DATA DIVISION.

 file section.
*>****************************************************************
*> SYSTEM TABLES     LREC = 100 Key = 7 data = 93 (75 + 18 filler)
*>****************************************************************
 fd  Tabe. *>  label records are standard.
 01  Tabe-Rec.
     05 Tabe-key.
        07 Tabe-ktip                pic x(001).
        07 Tabe-ktab                pic x(003).
        07 Tabe-kcod                pic x(003).
     05 Tabe-data                   pic x(093).

*>*****************************************************************
*>                   W O R K I N G   S T O R A G E
*>*****************************************************************
 WORKING-STORAGE SECTION.

 77  campo         pic x(01) value space.
 77  riga-pf       pic x(80).
 77  numtab        pic 9(03).
 77  wDescrTable   pic x(55).
 77  num           pic 9(03)    value 0.
 77  ind           pic 9(03)    value 0.
 77 wPAGE          pic 9(03)    value 1.
 77  destab        pic x(65).
 01  wInt          BINARY-SHORT SIGNED.

 01  wString       pic x(75).

01 black   constant as 0.
01 blue    constant as 1.
01 green   constant as 2.
01 cyan    constant as 3.
01 red     constant as 4.
01 magenta constant as 5.
01 yellow  constant as 6.  *> or Brown
01 white   constant as 7.

*> Values that may be returned in CRT STATUS Fiedl (or COB-CRT-STATUS register)
78  K-ENTER       VALUE 0000.
78  K-UP          VALUE 2003.
78  K-DOWN        VALUE 2004.
78  K-LEFT        VALUE 2009.
78  K-RIGHT       VALUE 2010.
78  K-ESC         VALUE 2005.
78  K-TAB         VALUE 2007.
78  K-BACKTAB     VALUE 2008.
78  K-PAGEUP      VALUE 2001.
78  K-PAGEDOWN    VALUE 2002.
78  K-ESCAPE      VALUE 2005.
78  K-F1          VALUE 1001.
78  K-F2          VALUE 1002.
78  K-F3          VALUE 1003.
78  K-F7          VALUE 1007.

01  ws-KEY        PIC 9(04) VALUE 9999.

01  wFco          PIC 9(02) VALUE green.
01  wBco          PIC 9(02) VALUE black.
01  wRow          pic 9(03) value zero.
01  wNewPage      pic X value space.

 01  wScreen-Data.
     03 wScrCod01 pic x(03).
     03 wScrRec01 pic x(75).
     03 wScrCod02 pic x(03).
     03 wScrRec02 pic x(75).
     03 wScrCod03 pic x(03).
     03 wScrRec03 pic x(75).
     03 wScrCod04 pic x(03).
     03 wScrRec04 pic x(75).
     03 wScrCod05 pic x(03).
     03 wScrRec05 pic x(75).
     03 wScrCod06 pic x(03).
     03 wScrRec06 pic x(75).
     03 wScrCod07 pic x(03).
     03 wScrRec07 pic x(75).
     03 wScrCod08 pic x(03).
     03 wScrRec08 pic x(75).
     03 wScrCod09 pic x(03).
     03 wScrRec09 pic x(75).
     03 wScrCod10 pic x(03).
     03 wScrRec10 pic x(75).
     03 wScrCod11 pic x(03).
     03 wScrRec11 pic x(75).
     03 wScrCod12 pic x(03).
     03 wScrRec12 pic x(75).
     03 wScrCod13 pic x(03).
     03 wScrRec13 pic x(75).
     03 wScrCod14 pic x(03).
     03 wScrRec14 pic x(75).
     03 wScrCod15 pic x(03).
     03 wScrRec15 pic x(75).
     03 wScrCod16 pic x(03).
     03 wScrRec16 pic x(75).
     03 wScrCod17 pic x(03).
     03 wScrRec17 pic x(75).
     03 wScrCod18 pic x(03).
     03 wScrRec18 pic x(75).
     03 wScrCod19 pic x(03).
     03 wScrRec19 pic x(75).
     03 wScrCod20 pic x(03).
     03 wScrRec20 pic x(75).

*> ****************************************************************
*> table headers loaded in memory
*> ****************************************************************
 01 wTableHeaders.
    02 wTableHeaders-ele    occurs 20.
       03 wTableHeader-cod  pic x(03).
       03 wTableHeader-des.
          04 wDesc  pic x(55) value spaces.
          04        pic x(30) value spaces.

 01  wbuEle.
   03 wbuFlag      pic x(01).
   03 wbuHot       pic x(01).
   03 wbuRig       pic 9(03).
   03 wbuCol       pic 9(03).
   03              pic x(01) value space.
   03 wbuVoce      pic x(55) value space.
   03              pic x(01) value x'00'.

 COPY 'GC76TABCOPY.CPY'.
 COPY 'GC01BOX.CPY'.
 COPY 'GC02BOXMEX.CPY'.
 COPY 'GC09BUTTONS.CPY'.
 COPY 'GC98KEYCODE.CPY'.

*>****************************************************************
 SCREEN SECTION.
*>****************************************************************
 01  Screen-clear.
     03 blank screen foreground-color is 0 background-color is 7.

 01  Screen-clear1.
     03 blank screen.
*>   foreground-color is 0 background-color is 7.

 01  Screen0 foreground-color is 7 highlight background-color is 2.
     03 line 01 col 01           value ' '.
     03  Testata pic x(080) value space.
     03 line 02 col 01           value ' '.
     03  Testata2 pic x(080) value space.

 01  Screen1 foreground-color is 0 background-color is 7 auto.
     03 line 03.
     03 col 01 value "REC 1...+....10...+....20...+....30...".
     03        value "+....40...+....50...+....60...+....70...+.".

 01 Screen2 foreground-color wFco background-color wBco auto.
     03 line 04  col   01   pic x(03) from  wScrCod01.
     03          col + 02   pic x(75) using wScrRec01.
     03 line + 1 col   01   pic x(03) from  wScrCod02.
     03          col + 02   pic x(75) using wScrRec02.
     03 line + 1 col   01   pic x(03) from  wScrCod03.
     03          col + 02   pic x(75) using wScrRec03.
     03 line + 1 col   01   pic x(03) from  wScrCod04.
     03          col + 02   pic x(75) using wScrRec04.
     03 line + 1 col   01   pic x(03) from  wScrCod05.
     03          col + 02   pic x(75) using wScrRec05.
     03 line + 1 col   01   pic x(03) from  wScrCod06.
     03          col + 02   pic x(75) using wScrRec06.
     03 line + 1 col   01   pic x(03) from  wScrCod07.
     03          col + 02   pic x(75) using wScrRec07.
     03 line + 1 col   01   pic x(03) from  wScrCod08.
     03          col + 02   pic x(75) using wScrRec08.
     03 line + 1 col   01   pic x(03) from  wScrCod09.
     03          col + 02   pic x(75) using wScrRec09.
     03 line + 1 col   01   pic x(03) from  wScrCod10.
     03          col + 02   pic x(75) using wScrRec10.
     03 line + 1 col   01   pic x(03) from  wScrCod11.
     03          col + 02   pic x(75) using wScrRec11.
     03 line + 1 col   01   pic x(03) from  wScrCod12.
     03          col + 02   pic x(75) using wScrRec12.
     03 line + 1 col   01   pic x(03) from  wScrCod13.
     03          col + 02   pic x(75) using wScrRec13.
     03 line + 1 col   01   pic x(03) from  wScrCod14.
     03          col + 02   pic x(75) using wScrRec14.
     03 line + 1 col   01   pic x(03) from  wScrCod15.
     03          col + 02   pic x(75) using wScrRec15.
     03 line + 1 col   01   pic x(03) from  wScrCod16.
     03          col + 02   pic x(75) using wScrRec16.
     03 line + 1 col   01   pic x(03) from  wScrCod17.
     03          col + 02   pic x(75) using wScrRec17.
     03 line + 1 col   01   pic x(03) from  wScrCod18.
     03          col + 02   pic x(75) using wScrRec18.
     03 line + 1 col   01   pic x(03) from  wScrCod19.
     03          col + 02   pic x(75) using wScrRec19.
     03 line + 1 col   01   pic x(03) from  wScrCod20.
     03          col + 02   pic x(75) using wScrRec20.

 01  Screen2b foreground-color is 0 background-color is 7 auto.
     03 line 24.
     03 col 01 value "REC 1...+....10...+....20...+....30...".
     03        value "+....40...+....50...+....60...+....70...+.".

 01  Screen3 foreground-color 07 highlight background-color 02 auto.
     03 line 25.
     03 col 01 pic x(80) from riga-pf.

 01  ScreenF1 foreground-color is 15 background-color is 1 auto.
     03 line 06     col 35 value
        "ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿".
     03 line + 1    col 35 value
        "³      ********  H  E  L  P  ********      ³".
     03 line + 1    col 35 value
        "ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´".
     03 line + 1    col 35 value
        "³ This function manages 20 records for     ³".
     03 line + 1    col 35 value
        "³ each page/screen.                        ³".
     03 line + 1    col 35 value
        "³ Each item has a unique code of           ³".
     03 line + 1    col 35 value
        "³ three digits , from 001 to 999.          ³".
     03 line + 1    col 35 value
        "³                                          ³".
     03 line + 1    col 35 value
        "³ With this function you can enter into    ³".
     03 line + 1    col 35 value
        "³ each one of elements a free content.     ³".
     03 line + 1    col 35 value
        "³ The system does not have controls on     ³".
     03 line + 1    col 35 value
        "³ what you enter into the item.            ³".
     03 line + 1    col 35 value
        "ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´".
     03 line + 1    col 35 value
        "³ Use specific function to manage          ³".
     03 line + 1    col 35 value
        "³ table headers.                           ³".
     03 line + 1    col 35 value
        "ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ".
     03 pic x(01) to campo.

*>*****************************************************************
*>              P R O C E D U R E   D I V I S I O N
*>*****************************************************************
PROCEDURE DIVISION.
Start-Program.
  *> sets in order to detect the PgUp, PgDn, PrtSc(screen print), Esc keys,
  set environment 'COB_SCREEN_EXCEPTIONS' TO 'Y'.
  set environment 'COB_SCREEN_ESC'        TO 'Y'.

  *> select a File or EXIT
  perform TableFileSelection thru TableFileSelectionEx
  if bu-Key = Key-Escape
     go End-Program
  end-if

  move    wFileName to TABEFSPEC
  display ' ' at 0101 with Background-Color 07 Foreground-Color 00
  perform HideCursor thru HideCursor-ex

  open i-o Tabe.
  if Tabe-fs not = '00'
     if Tabe-fs = '35'
        move '                              ' & x'00' to bxm-mex(1)
        move '  The selected file does      ' & x'00' to bxm-mex(2)
        move '  not exist.                  ' & x'00' to bxm-mex(3)
        move '  Please use Table Headers    ' & x'00' to bxm-mex(4)
        move '  management if you want      ' & x'00' to bxm-mex(5)
        move '  to create it.               ' & x'00' to bxm-mex(6)
        perform DisplayErrorMessage thru DisplayErrorMessageEx
        go Start-program
     else
        display '* Table open error,  fs= ' at 0202 with Background-Color 07 Foreground-Color 00
        display Tabe-fs                     at 0230 with Background-Color 07 Foreground-Color 00
        accept omitted
        goback
     end-if
   end-if

    move space to wTabe-Rec.
    initialize wScreen-Data
    perform ReadHeaders thru ReadHeadersEx.  *> load table headers in memory

DisplayBackground.
   *> background box (clear screen)
   move '002001025080' to Box-rc
   set Box-bco to green Move 'N' to Box-3D
   CALL GC01BOX USING BY CONTENT BOX-AREA

   continue.

Select-A-Table.
     move space to wString
     string ' TABLE ITEMS MANAGEMENT - File: '  wFileName ' - SELECT A TABLE ' delimited by size into wString
     display wString at 0101 with Background-Color green Foreground-Color white highlight
     move space to wString
     string 'TAB DESCRIPTION ' delimited by size into wString
     display wString at 0303 with Background-Color green Foreground-Color white highlight
     move space to wString
     string '--- ----------------------------------------------------------------------' delimited by size into wString
     display wString at 0403 with Background-Color green Foreground-Color white highlight
    *> display buttons with table headers
     initialize Buttons-area ALL TO VALUE
     move '1'   to Bu-Act(1)
     move 5   to Bu-r(1) wRow
     move 3   to Bu-c(1)
     move ' ' to Bu-HotX(1)
     string wTableHeader-cod(1) ' ' wTableHeader-des (1) (1:70) x'00' into Bu-item(1)
     perform test before varying num from 1 by 1 until num > 19 or wTableHeader-des (num + 1) = spaces
        add  1    to wRow
        move ' '  to Bu-Act(num + 1) Bu-HotX(num + 1)
        move wRow to Bu-r(num + 1)
        move 3    to Bu-c(num +  1)
        string wTableHeader-cod(num + 1) ' ' wTableHeader-des (num + 1) (1:70) x'00' into Bu-item(num + 1)
     end-perform
     move black to Bu-bcoS
     move 'N'   to Bu-Shadow Bu-Arrow Bu-Click
     CALL GC09BUTTONS using Buttons-Area

     If bu-Key = Key-Escape  close Tabe go Start-Program end-if

     string wTableHeader-cod(Bu-selected) ' ' wTableHeader-des(Bu-selected)(1:50) into wDescrTable end-string

     move 1 to wPAGE
     display Screen-clear
     move Bu-selected to  numtab
     move  " F1=Help F2/F3=chgFore/BackCol PgUp/Dn=Prev/NextPg F7=DelPg Enter=UpdPg ESC=Exit" to riga-pf
    *> read table header
     move space  to wTabe-Rec
     move 'H'    to wTabe-ktip
     move numtab to wTabe-ktab
     move space  to wTabe-kcod.
     move wTabe-key to   Tabe-key
     read Tabe     into wTabe-Rec
     if   Tabe-fs not = "00"
          move all '?' to destab go DisplayBackground end-if
     move wTabe-data to destab
     continue.

DysplayItemsScreen.
    *> re-show the cursor
    perform ShowCursor thru ShowCursor-ex
    *> move 2 to wInt
    *> call static "curs_set" using by value wInt end-call

     string ' TABLE ITEMS MANAGEMENT - File: '  wFileName  delimited by size into Testata
     string ' Items of table...............: ' wDescrTable delimited by size into Testata2
     display Screen0.
     display Screen1.
     perform SetScreen thru SetScreenEx.
     display Screen2.
     display Screen2b.
     display Screen3.
     accept  Screen2.

     evaluate true
         when ws-KEY = K-ESCAPE  *> go to File selection
              close Tabe
              go to Start-Program
         when ws-KEY = K-F1
              perform DisplayHelp thru DisplayHelp-ex
         when ws-KEY = K-F2
              add 1 to wFco
              if wFco > 7 move 0 to wFco end-if
         when ws-KEY = K-F3
              add 1 to wBco
              if wBco > 7 move 0 to wBco end-if
         when ws-KEY = K-F7
              perform DeleteRecords thru DeleteRecordsEx
              compute wPAGE = wPAGE - 1
              if wPAGE = 0 move 1 to wPAGE End-if
         when ws-Key = K-ENTER
              perform RewriteRecords thru RewriteRecordsEx
         when ws-Key = K-PAGEDOWN
              compute wPAGE = wPAGE + 1
         when ws-Key = K-PAGEUP
              compute wPAGE = wPAGE - 1
              if wPAGE = 0 move 1 to wPAGE end-if
      end-evaluate

      go to DysplayItemsScreen
      continue.

End-Program.
     close Tabe.
     GOBACK.

*>****************************************************************
*>                       R O U T I N E S
*>****************************************************************
SetScreen.
   move 'I' to wTabe-ktip.
   Compute Num = (wPAGE - 1 ) * 20
   move space to Tabe-data.
   *> Read Tale Items (records) if exist else create the items (records)
   Add  1 to NUM move Num to wTabe-kcod. move wTabe-key to Tabe-key. read Tabe into wTabe-Rec.
   if Tabe-fs = "23"  move 'Y' to wNewPage end-if

   if Tabe-fs = "23"  perform WriteRec thru WriteRecEx. move wTabe-kcod to wScrCod01. move wTabe-data to wScrRec01.
   Add  1 to NUM move Num to wTabe-kcod. move wTabe-key to Tabe-key. read Tabe into wTabe-Rec.
   if Tabe-fs = "23"  perform WriteRec thru WriteRecEx. move wTabe-kcod to wScrCod02. move wTabe-data to wScrRec02.
   Add  1 to NUM move Num to wTabe-kcod. move wTabe-key to Tabe-key. read Tabe into wTabe-Rec.
   if Tabe-fs = "23"  perform WriteRec thru WriteRecEx. move wTabe-kcod to wScrCod03. move wTabe-data to wScrRec03.
   Add  1 to NUM move Num to wTabe-kcod. move wTabe-key to Tabe-key. read Tabe into wTabe-Rec.
   if Tabe-fs = "23"  perform WriteRec thru WriteRecEx. move wTabe-kcod to wScrCod04. move wTabe-data to wScrRec04.
   Add  1 to NUM move Num to wTabe-kcod. move wTabe-key to Tabe-key. read Tabe into wTabe-Rec.
   if Tabe-fs = "23"  perform WriteRec thru WriteRecEx. move wTabe-kcod to wScrCod05. move wTabe-data to wScrRec05.
   Add  1 to NUM move Num to wTabe-kcod. move wTabe-key to Tabe-key. read Tabe into wTabe-Rec.
   if Tabe-fs = "23"  perform WriteRec thru WriteRecEx. move wTabe-kcod to wScrCod06. move wTabe-data to wScrRec06.
   Add  1 to NUM move Num to wTabe-kcod. move wTabe-key to Tabe-key. read Tabe into wTabe-Rec.
   if Tabe-fs = "23"  perform WriteRec thru WriteRecEx. move wTabe-kcod to wScrCod07. move wTabe-data to wScrRec07.
   Add  1 to NUM move Num to wTabe-kcod. move wTabe-key to Tabe-key. read Tabe into wTabe-Rec.
   if Tabe-fs = "23"  perform WriteRec thru WriteRecEx. move wTabe-kcod to wScrCod08. move wTabe-data to wScrRec08.
   Add  1 to NUM move Num to wTabe-kcod. move wTabe-key to Tabe-key. read Tabe into wTabe-Rec.
   if Tabe-fs = "23"  perform WriteRec thru WriteRecEx. move wTabe-kcod to wScrCod09. move wTabe-data to wScrRec09.
   Add  1 to NUM move Num to wTabe-kcod. move wTabe-key to Tabe-key. read Tabe into wTabe-Rec.
   if Tabe-fs = "23"  perform WriteRec thru WriteRecEx. move wTabe-kcod to wScrCod10. move wTabe-data to wScrRec10.
   Add  1 to NUM move Num to wTabe-kcod. move wTabe-key to Tabe-key. read Tabe into wTabe-Rec.
   if Tabe-fs = "23"  perform WriteRec thru WriteRecEx. move wTabe-kcod to wScrCod11. move wTabe-data to wScrRec11.
   Add  1 to NUM move Num to wTabe-kcod. move wTabe-key to Tabe-key. read Tabe into wTabe-Rec.
   if Tabe-fs = "23"  perform WriteRec thru WriteRecEx. move wTabe-kcod to wScrCod12. move wTabe-data to wScrRec12.
   Add  1 to NUM move Num to wTabe-kcod. move wTabe-key to Tabe-key. read Tabe into wTabe-Rec.
   if Tabe-fs = "23"  perform WriteRec thru WriteRecEx. move wTabe-kcod to wScrCod13   move wTabe-data to wScrRec13.
   Add  1 to NUM move Num to wTabe-kcod. move wTabe-key to Tabe-key. read Tabe into wTabe-Rec.
   if Tabe-fs = "23"  perform WriteRec thru WriteRecEx. move wTabe-kcod to wScrCod14. move wTabe-data to wScrRec14.
   Add  1 to NUM move Num to wTabe-kcod. move wTabe-key to Tabe-key. read Tabe into wTabe-Rec.
   if Tabe-fs = "23"  perform WriteRec thru WriteRecEx. move wTabe-kcod to wScrCod15. move wTabe-data to wScrRec15.
   Add  1 to NUM move Num to wTabe-kcod. move wTabe-key to Tabe-key. read Tabe into wTabe-Rec.
   if Tabe-fs = "23"  perform WriteRec thru WriteRecEx. move wTabe-kcod to wScrCod16. move wTabe-data to wScrRec16.
   Add  1 to NUM move Num to wTabe-kcod. move wTabe-key to Tabe-key. read Tabe into wTabe-Rec.
   if Tabe-fs = "23"  perform WriteRec thru WriteRecEx. move wTabe-kcod to wScrCod17. move wTabe-data to wScrRec17.
   Add  1 to NUM move Num to wTabe-kcod. move wTabe-key to Tabe-key. read Tabe into wTabe-Rec.
   if Tabe-fs = "23"  perform WriteRec thru WriteRecEx. move wTabe-kcod to wScrCod18. move wTabe-data to wScrRec18.
   Add  1 to NUM move Num to wTabe-kcod. move wTabe-key to Tabe-key. read Tabe into wTabe-Rec.
   if Tabe-fs = "23"  perform WriteRec thru WriteRecEx. move wTabe-kcod to wScrCod19. move wTabe-data to wScrRec19.
   Add  1 to NUM move Num to wTabe-kcod. move wTabe-key to Tabe-key. read Tabe into wTabe-Rec.
   if Tabe-fs = "23"  perform WriteRec thru WriteRecEx. move wTabe-kcod to wScrCod20. move wTabe-data to wScrRec20.
   if wNewPage = 'Y'
      move space to wNewPage
      move '                              ' & x'00' to bxm-mex(1)
      move ' New Page created             ' & x'00' to bxm-mex(2)
   string ' from ' wScrCod01 ' to ' wScrCod20 '               '  x'00' into bxm-mex(3)
      move '                              ' & x'00' to bxm-mex(4)
      move '                              ' & x'00' to bxm-mex(5)
      move '                              ' & x'00' to bxm-mex(6)
      move '                              ' & x'00' to bxm-mex(7)
      perform DisplayMessage thru DisplayMessageEx
    end-if
    continue.
SetScreenEx. exit.

WriteRec.
   move space to wTabe-data
   write Tabe-Rec from wTabe-Rec.
WriteRecEx. exit.

RewriteRecords.
   move wScrCod01 to wTabe-kcod. move wScrRec01 to wTabe-data. perform RewriteRec thru RewriteRecEx
   move wScrCod02 to wTabe-kcod. move wScrRec02 to wTabe-data. perform RewriteRec thru RewriteRecEx
   move wScrCod03 to wTabe-kcod. move wScrRec03 to wTabe-data. perform RewriteRec thru RewriteRecEx
   move wScrCod04 to wTabe-kcod. move wScrRec04 to wTabe-data. perform RewriteRec thru RewriteRecEx
   move wScrCod05 to wTabe-kcod. move wScrRec05 to wTabe-data. perform RewriteRec thru RewriteRecEx
   move wScrCod06 to wTabe-kcod. move wScrRec06 to wTabe-data. perform RewriteRec thru RewriteRecEx
   move wScrCod07 to wTabe-kcod. move wScrRec07 to wTabe-data. perform RewriteRec thru RewriteRecEx
   move wScrCod08 to wTabe-kcod. move wScrRec08 to wTabe-data. perform RewriteRec thru RewriteRecEx
   move wScrCod09 to wTabe-kcod. move wScrRec09 to wTabe-data. perform RewriteRec thru RewriteRecEx
   move wScrCod10 to wTabe-kcod. move wScrRec10 to wTabe-data. perform RewriteRec thru RewriteRecEx
   move wScrCod11 to wTabe-kcod. move wScrRec11 to wTabe-data. perform RewriteRec thru RewriteRecEx
   move wScrCod12 to wTabe-kcod. move wScrRec12 to wTabe-data. perform RewriteRec thru RewriteRecEx
   move wScrCod13 to wTabe-kcod. move wScrRec13 to wTabe-data. perform RewriteRec thru RewriteRecEx
   move wScrCod14 to wTabe-kcod. move wScrRec14 to wTabe-data. perform RewriteRec thru RewriteRecEx
   move wScrCod15 to wTabe-kcod. move wScrRec15 to wTabe-data. perform RewriteRec thru RewriteRecEx
   move wScrCod16 to wTabe-kcod. move wScrRec16 to wTabe-data. perform RewriteRec thru RewriteRecEx
   move wScrCod17 to wTabe-kcod. move wScrRec17 to wTabe-data. perform RewriteRec thru RewriteRecEx
   move wScrCod18 to wTabe-kcod. move wScrRec18 to wTabe-data. perform RewriteRec thru RewriteRecEx
   move wScrCod19 to wTabe-kcod. move wScrRec19 to wTabe-data. perform RewriteRec thru RewriteRecEx
   move wScrCod20 to wTabe-kcod. move wScrRec20 to wTabe-data. perform RewriteRec thru RewriteRecEx

   move '                              ' & x'00' to bxm-mex(1)
   move ' Table records UPDATED        ' & x'00' to bxm-mex(2)
   string ' from ' wScrCod01 ' to ' wScrCod20 '               '  x'00' into bxm-mex(3)
   move '                              ' & x'00' to bxm-mex(4)
   move '                              ' & x'00' to bxm-mex(5)
   move '                              ' & x'00' to bxm-mex(6)
   move '                              ' & x'00' to bxm-mex(7)
   perform DisplayMessage thru DisplayMessageEx
   continue.
RewriteRecordsEx. exit.

RewriteRec.
   rewrite Tabe-Rec from wTabe-Rec.
RewriteRecEx. exit.

DeleteRecords.
   move wScrCod01 to Tabe-kcod. perform DeleteRec thru DeleteRecEx
   move wScrCod02 to Tabe-kcod. perform DeleteRec thru DeleteRecEx
   move wScrCod03 to Tabe-kcod. perform DeleteRec thru DeleteRecEx
   move wScrCod04 to Tabe-kcod. perform DeleteRec thru DeleteRecEx
   move wScrCod05 to Tabe-kcod. perform DeleteRec thru DeleteRecEx
   move wScrCod06 to Tabe-kcod. perform DeleteRec thru DeleteRecEx
   move wScrCod07 to Tabe-kcod. perform DeleteRec thru DeleteRecEx
   move wScrCod08 to Tabe-kcod. perform DeleteRec thru DeleteRecEx
   move wScrCod09 to Tabe-kcod. perform DeleteRec thru DeleteRecEx
   move wScrCod10 to Tabe-kcod. perform DeleteRec thru DeleteRecEx
   move wScrCod11 to Tabe-kcod. perform DeleteRec thru DeleteRecEx
   move wScrCod12 to Tabe-kcod. perform DeleteRec thru DeleteRecEx
   move wScrCod13 to Tabe-kcod. perform DeleteRec thru DeleteRecEx
   move wScrCod14 to Tabe-kcod. perform DeleteRec thru DeleteRecEx
   move wScrCod15 to Tabe-kcod. perform DeleteRec thru DeleteRecEx
   move wScrCod16 to Tabe-kcod. perform DeleteRec thru DeleteRecEx
   move wScrCod17 to Tabe-kcod. perform DeleteRec thru DeleteRecEx
   move wScrCod18 to Tabe-kcod. perform DeleteRec thru DeleteRecEx
   move wScrCod19 to Tabe-kcod. perform DeleteRec thru DeleteRecEx
   move wScrCod20 to Tabe-kcod. perform DeleteRec thru DeleteRecEx

   move '                              ' & x'00' to bxm-mex(1)
   move ' Page Deleted                 ' & x'00' to bxm-mex(2)
   string ' from ' wScrCod01 ' to ' wScrCod20 '               '  x'00' into bxm-mex(3)
   move '                              ' & x'00' to bxm-mex(4)
   move '                              ' & x'00' to bxm-mex(5)
   move '                              ' & x'00' to bxm-mex(6)
   move '                              ' & x'00' to bxm-mex(7)
   perform DisplayMessage thru DisplayMessageEx
   continue.
DeleteRecordsEx. exit.

DeleteRec.
   Delete Tabe.
DeleteRecEx. exit.

*> SetScreenHeader.
*> move 'H001' to Tabe-key. read Tabe into wTabe-Rec. move wTabe-ktab to wScrCod01. move wTabe-data to wScrRec01.
*> move 'H002' to Tabe-key. read Tabe into wTabe-Rec. move wTabe-ktab to wScrCod02. move wTabe-data to wScrRec02.
*> move 'H003' to Tabe-key. read Tabe into wTabe-Rec. move wTabe-ktab to wScrCod03. move wTabe-data to wScrRec03.
*> move 'H004' to Tabe-key. read Tabe into wTabe-Rec. move wTabe-ktab to wScrCod04. move wTabe-data to wScrRec04.
*> move 'H005' to Tabe-key. read Tabe into wTabe-Rec. move wTabe-ktab to wScrCod05. move wTabe-data to wScrRec05.
*> move 'H006' to Tabe-key. read Tabe into wTabe-Rec. move wTabe-ktab to wScrCod06. move wTabe-data to wScrRec06.
*> move 'H007' to Tabe-key. read Tabe into wTabe-Rec. move wTabe-ktab to wScrCod07. move wTabe-data to wScrRec07.
*> move 'H008' to Tabe-key. read Tabe into wTabe-Rec. move wTabe-ktab to wScrCod08. move wTabe-data to wScrRec08.
*> move 'H009' to Tabe-key. read Tabe into wTabe-Rec. move wTabe-ktab to wScrCod09. move wTabe-data to wScrRec09.
*> move 'H010' to Tabe-key. read Tabe into wTabe-Rec. move wTabe-ktab to wScrCod10. move wTabe-data to wScrRec10.
*> move 'H011' to Tabe-key. read Tabe into wTabe-Rec. move wTabe-ktab to wScrCod11. move wTabe-data to wScrRec11.
*> move 'H012' to Tabe-key. read Tabe into wTabe-Rec. move wTabe-ktab to wScrCod12. move wTabe-data to wScrRec12.
*> move 'H013' to Tabe-key. read Tabe into wTabe-Rec. move wTabe-ktab to wScrCod13. move wTabe-data to wScrRec13.
*> move 'H014' to Tabe-key. read Tabe into wTabe-Rec. move wTabe-ktab to wScrCod14. move wTabe-data to wScrRec14.
*> move 'H015' to Tabe-key. read Tabe into wTabe-Rec. move wTabe-ktab to wScrCod15. move wTabe-data to wScrRec15.
*> move 'H016' to Tabe-key. read Tabe into wTabe-Rec. move wTabe-ktab to wScrCod16. move wTabe-data to wScrRec16.
*> move 'H017' to Tabe-key. read Tabe into wTabe-Rec. move wTabe-ktab to wScrCod17. move wTabe-data to wScrRec17.
*> move 'H018' to Tabe-key. read Tabe into wTabe-Rec. move wTabe-ktab to wScrCod18. move wTabe-data to wScrRec18.
*> move 'H019' to Tabe-key. read Tabe into wTabe-Rec. move wTabe-ktab to wScrCod19. move wTabe-data to wScrRec19.
*> move 'H020' to Tabe-key. read Tabe into wTabe-Rec. move wTabe-ktab to wScrCod20. move wTabe-data to wScrRec20.
*> SetScreenHeaderEx. exit.

*>*****************************************************************
*>  TABLE HEADERS ARE LOADED IN MEMORY
*>*****************************************************************
ReadHeaders.
   move 'H'    to Tabe-key
   perform varying ind from 1 by 1 until ind > 20
          move ind        to   Tabe-kTab
          read Tabe       into wTabe-Rec
          move wTabe-ktab to   wTableHeader-cod (ind)
          move wTabe-data to   wTableHeader-des (ind)
   end-perform
   move 'H'       to wTabe-ktip
   move space     to Tabe-data
   continue.
ReadHeadersEx. exit.

*>****************************************************************
DisplayHelp.
     perform HideCursor thru HideCursor-ex
     display ScreenF1.
     accept  ScreenF1.
      perform ShowCursor thru ShowCursor-ex
   continue.
DisplayHelp-ex. exit.

HideCursor.
    *> hide the cursor
    move 0 to wInt
    call static "curs_set" using by value wInt end-call.
HideCursor-ex. exit.

ShowCursor.
    *> re-show the cursor
    move 2 to wInt
    call static "curs_set" using by value wInt end-call.
ShowCursor-ex. exit.

DisplayMessage.
   *> perform ScreenSave thru ScreenSaveEx
   move 'Y' to Bxm-click
   move '010020019051' to Bxm-rc
   move red   to Bxm-bco Bxm-bcoM
   move white to Bxm-fco Bxm-fcoM
   move 'Y' to Bxm-fcoH
   move 'S' to Bxm-style
   call GC02BOXMEX using BOXMEX-AREA
   initialize Bxm-tabmex all to value.
   *> perform ScreenRestore thru ScreenRestoreEx .
DisplayMessageEx. exit.

TableFileSelection.
   *> background box
   move '002001025080'  to Box-rc
   set Box-bco          to green
   Move 'N'             to Box-3D
   CALL GC01BOX USING BY CONTENT BOX-AREA
   display ' TABLE ITEMS MANAGEMENT                                                         '
                  at 0101 with Background-Color green Foreground-Color white highlight

   *> ********************************************************
   *> SELECTION OF A FILE
   *> ********************************************************
   move '004017023065' to Box-rc
   set Box-bco to white
   CALL GC01BOX USING BY CONTENT BOX-AREA

   move 'E'   to box-3d
   initialize Buttons-area ALL TO VALUE
   move 'Y' to Bu-Click bu-Shadow
   display '   SELECT A TABLE FILE ' at 005031 with  background-Color white foreground-Color red
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
       when 1 move '001' to wFileName(6:3)
       when 2 move '002' to wFileName(6:3)
       when 3 move '003' to wFileName(6:3)
       when 4 move '004' to wFileName(6:3)
       when 5 move '005' to wFileName(6:3)
       when 6 move '006' to wFileName(6:3)
       when 7 move '007' to wFileName(6:3)
       when 8 move '008' to wFileName(6:3)
   end-evaluate
   continue.
TableFileSelectionEx. exit.

DisplayErrorMessage.
   *> perform ScreenSave thru ScreenSaveEx
   move 'Y' to Bxm-click
   move '010020021051' to Bxm-rc
   move red to Bxm-bco Bxm-bcoM move white to Bxm-fco Bxm-fcoM
   move 'Y' to Bxm-fcoH
   move 'S' to Bxm-style
   call GC02BOXMEX using BOXMEX-AREA
   initialize Bxm-tabmex all to value.
   *> perform ScreenRestore thru ScreenRestoreEx .
DisplayErrorMessageEx. exit.
