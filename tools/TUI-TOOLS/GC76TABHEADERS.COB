       >>SOURCE FORMAT IS FREE
       REPLACE ==:BCOL:== BY ==with BACKGROUND-COLOR==
               ==:FCOL:== BY ==FOREGROUND-COLOR==.
IDENTIFICATION DIVISION.
program-id. GC76TABHEADERS.
*> ***********************************************************************************
*> GnuCOBOL TT (TUI TOOLS) COLLECTION
*> Purpose:    Select a Table File and insert, display, modify, delete Table headers
*> Tectonics:  cobc -x GC76TABHEADERS.COB  (use GnuCOBOL 2.2 or greater)
*> Usage:      GC76TABHEADERS
*> Parameters:
*> Author:     Eugenio Di Lorenzo - Italia (DILO)
*> License:    Copyright 2017 E.Di Lorenzo - LGPL, 3.0 (or greater)
*> Version:    1.0 2018.01.01
*> Changelog:  1.0 first release.
*> ************************************************************************************
ENVIRONMENT DIVISION.
CONFIGURATION SECTION.
SPECIAL-NAMES.
   CRT STATUS IS ws-KEY.
   Currency Sign is '€'.
   Decimal-Point is Comma.
REPOSITORY.
    FUNCTION ALL INTRINSIC.
INPUT-OUTPUT SECTION.
FILE-CONTROL.
   select Tabe
          assign       to TABEFSPEC
          access mode  is dynamic
          organization is indexed
          record key   is Tabe-key
          file status  is Tabe-fs.

DATA DIVISION.
FILE SECTION.
*>****************************************************************
*> SYSTEM TABLES     LREC = 100 Key = 7 data = 93 (75 + 18 filler)
*>****************************************************************
fd  Tabe. *> label records are standard.
   *> H001 - H020
01  Tabe-record.
   05 Tabe-key.
      07 Tabe-ktip                pic x(001).
      07 Tabe-ktab                pic x(003).
      07 Tabe-kcod                pic x(003).
   05                             pic x(093).

*>*****************************************************************
*>                   W O R K I N G   S T O R A G E
*>*****************************************************************
WORKING-STORAGE SECTION.

77  riga-pf       pic x(78).
77  riga          pic x(80) value all "Ä".
77  abort         pic x(01).
77  sw-gfx        pic x(01).
77  Password1     pic x(08) value space.
01  wCtr          pic 9(03) value zero.
01  wInt          BINARY-SHORT SIGNED.

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
78  K-F9          VALUE 1009.
78  K-F10         VALUE 1010.
78  K-NO-FIELD    VALUE 8000.  *> NO DATA FROM ACCEPT ex. a timeout is passed (also 8001)

01  ws-KEY        PIC 9(04) VALUE 9999.
01  wFco          PIC 9(02) VALUE green.
01  wBco          PIC 9(02) VALUE black.

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

COPY 'GC76TABCOPY.CPY'.

COPY 'GC01BOX.CPY'.
copy 'GC02BOXMEX.CPY'.
copy 'GC03YESNO.CPY'.
COPY 'GC09BUTTONS.CPY'.
COPY 'GC98KEYCODE.CPY'.

*>****************************************************************
SCREEN SECTION.

01 Screen-clear.
   03 blank screen foreground-color is 0 background-color is 7.

01 Screen1 auto foreground-color is 7 highlight background-color is 2.
   03 line 01.
   03 col 01          value " ".
   03  Testata pic x(080) value space.

01 Screen2 foreground-color is 0 background-color is 7.
   03 line 02.
   03 col  02 value "                                       ".
   03         value "                                       ".

01 Screen3 foreground-color is 0 background-color is 7 auto.
   03 line 03.
   03 col  01 value "TAB 1...+....10...+....20...+....30...".
   03         value "+....40...+....50...+....60...+....70...+.".

*> 01 Screen4 foreground-color 00 background-color 03 auto.
01 Screen4 foreground-color wFco background-color wBco auto.
   03 line 04 col 01        pic x(03) from  wScrCod01.
   03         col + 2       pic x(75) using wScrRec01.
   03 line 05 col 01        pic x(03) from  wScrCod02.
   03         col + 2       pic x(75) using wScrRec02.
   03 line 06 col 01        pic x(03) from  wScrCod03.
   03         col + 2       pic x(75) using wScrRec03.
   03 line 07 col 01        pic x(03) from  wScrCod04.
   03         col + 2       pic x(75) using wScrRec04.
   03 line 08 col 01        pic x(03) from  wScrCod05.
   03         col + 2       pic x(75) using wScrRec05.
   03 line 09 col 01        pic x(03) from  wScrCod06.
   03         col + 2       pic x(75) using wScrRec06.
   03 line 10 col 01        pic x(03) from  wScrCod07.
   03         col + 2       pic x(75) using wScrRec07.
   03 line 11 col 01        pic x(03) from  wScrCod08.
   03         col + 2       pic x(75) using wScrRec08.
   03 line 12 col 01        pic x(03) from  wScrCod09.
   03         col + 2       pic x(75) using wScrRec09.
   03 line 13 col 01        pic x(03) from  wScrCod10.
   03         col + 2       pic x(75) using wScrRec10.
   03 line 14 col 01        pic x(03) from  wScrCod11.
   03         col + 2       pic x(75) using wScrRec11.
   03 line 15 col 01        pic x(03) from  wScrCod12.
   03         col + 2       pic x(75) using wScrRec12.
   03 line 16 col 01        pic x(03) from  wScrCod13.
   03         col + 2       pic x(75) using wScrRec13.
   03 line 17 col 01        pic x(03) from  wScrCod14.
   03         col + 2       pic x(75) using wScrRec14.
   03 line 18 col 01        pic x(03) from  wScrCod15.
   03         col + 2       pic x(75) using wScrRec15.
   03 line 19 col 01        pic x(03) from  wScrCod16.
   03         col + 2       pic x(75) using wScrRec16.
   03 line 20 col 01        pic x(03) from  wScrCod17.
   03         col + 2       pic x(75) using wScrRec17.
   03 line 21 col 01        pic x(03) from  wScrCod18.
   03         col + 2       pic x(75) using wScrRec18.
   03 line 22 col 01        pic x(03) from  wScrCod19.
   03         col + 2       pic x(75) using wScrRec19.
   03 line 23 col 01        pic x(03) from  wScrCod20.
   03         col + 2       pic x(75) using wScrRec20.

01 Screen4b foreground-color is 0 background-color is 7 auto.
   03 line 24.
   03 col  01 value "TAB 1...+....10...+....20...+....30...".
   03         value "+....40...+....50...+....60...+....70...+.".

01 Screen5 foreground-color is 7 highlight background-color is 2.
   03 line 25.
   03 col 01 pic x(80) from riga-pf.

*>*****************************************************************
*>              P R O C E D U R E   D I V I S I O N
*>*****************************************************************
PROCEDURE DIVISION.

Start-Program.
  *> sets in order to detect the PgUp, PgDn, PrtSc(screen print), Esc keys,
  set environment 'COB_SCREEN_EXCEPTIONS' TO 'Y'.
  set environment 'COB_SCREEN_ESC'        TO 'Y'.

  perform TableFileSelection thru TableFileSelectionEx
  If bu-Key = Key-Escape go End-Program end-if
  move    wFileName to TABEFSPEC

  display ' ' at 0101 :BCOL: 07 :FCOL: 00

   open i-o Tabe.
   if Tabe-fs not = '00'
      DISPLAY "  Open File Error...: "        AT 002005  :BCOL: red :FCOL: white
      DISPLAY Tabe-FS                         AT 002026  :BCOL: red :FCOL: white
      DISPLAY " press Enter to continue ... " AT 002038  :BCOL: red :FCOL: white
      accept omitted
      perform Create-Tabe thru Create-TabeEx
      open i-o Tabe
      DISPLAY "  File Created......:   "      AT 003005  :BCOL: red :FCOL: white
      DISPLAY wFileName                       AT 003026  :BCOL: red :FCOL: white
      DISPLAY " press Enter to continue ... " AT 003038  :BCOL: red :FCOL: white
      accept omitted
   end-if
   continue.

    move space to wTabe-rec.
    move 0     to wTabe-ktab9.
    move  " F1=Help F2/F3=chgFore/BackCol Enter=Update ESC=Exit " to riga-pf.
    perform fill-Screen thru fill-Screen-ex.

 DisplayScreen.
     display Screen-clear.
     perform ShowCursor thru ShowCursor-ex

     string ' TABLE HEADERS MANAGEMENT - File: '  wFileName ' -' delimited by size into Testata
     display Screen1.
     display Screen2.
     display Screen3.
     display Screen4.
     display Screen4b.
     display Screen5.

     accept  Screen4.
     if ws-KEY = K-ESCAPE close Tabe go to Start-Program end-if
     if ws-KEY = K-F1     perform DisplayHelp thru DisplayHelp-ex go to DisplayScreen.
     if ws-KEY = K-F2     add 1 to wFco if wFco > 7 move 0 to wFco end-if go to DisplayScreen.
     if ws-KEY = K-F3     add 1 to wBco if wBco > 7 move 0 to wBco end-if go to DisplayScreen.
     if ws-KEY = K-ENTER
        continue *> next sentence
     else
        go to DisplayScreen.

     move 09 to Yn-r1
     move '       Confirm the update ?       ' to Yn-mess
     call GC03YESNO using YESNO-AREA
     if   Yn-Yesno = "Y"
          perform Rewrite-File  thru Rewrite-File-ex
          go to DisplayScreen
     else
          go to DisplayScreen
     end-if
     continue.

End-Program.
     close Tabe.
     GOBACK.
*>****************************************************************
*>                       R O U T I N E S
*>****************************************************************

fill-Screen.
     move 'H001' to Tabe-key.  read Tabe into wTabe-rec. move wTabe-ktab to wScrCod01. move wTabe-data to wScrRec01.
     move 'H002' to Tabe-key.  read Tabe into wTabe-rec. move wTabe-ktab to wScrCod02. move wTabe-data to wScrRec02.
     move 'H003' to Tabe-key.  read Tabe into wTabe-rec. move wTabe-ktab to wScrCod03. move wTabe-data to wScrRec03.
     move 'H004' to Tabe-key.  read Tabe into wTabe-rec. move wTabe-ktab to wScrCod04. move wTabe-data to wScrRec04.
     move 'H005' to Tabe-key.  read Tabe into wTabe-rec. move wTabe-ktab to wScrCod05. move wTabe-data to wScrRec05.
     move 'H006' to Tabe-key.  read Tabe into wTabe-rec. move wTabe-ktab to wScrCod06. move wTabe-data to wScrRec06.
     move 'H007' to Tabe-key.  read Tabe into wTabe-rec. move wTabe-ktab to wScrCod07. move wTabe-data to wScrRec07.
     move 'H008' to Tabe-key.  read Tabe into wTabe-rec. move wTabe-ktab to wScrCod08. move wTabe-data to wScrRec08.
     move 'H009' to Tabe-key.  read Tabe into wTabe-rec. move wTabe-ktab to wScrCod09. move wTabe-data to wScrRec09.
     move 'H010' to Tabe-key.  read Tabe into wTabe-rec. move wTabe-ktab to wScrCod10. move wTabe-data to wScrRec10.
     move 'H011' to Tabe-key.  read Tabe into wTabe-rec. move wTabe-ktab to wScrCod11. move wTabe-data to wScrRec11.
     move 'H012' to Tabe-key.  read Tabe into wTabe-rec. move wTabe-ktab to wScrCod12. move wTabe-data to wScrRec12.
     move 'H013' to Tabe-key.  read Tabe into wTabe-rec. move wTabe-ktab to wScrCod13. move wTabe-data to wScrRec13.
     move 'H014' to Tabe-key.  read Tabe into wTabe-rec. move wTabe-ktab to wScrCod14. move wTabe-data to wScrRec14.
     move 'H015' to Tabe-key.  read Tabe into wTabe-rec. move wTabe-ktab to wScrCod15. move wTabe-data to wScrRec15.
     move 'H016' to Tabe-key.  read Tabe into wTabe-rec. move wTabe-ktab to wScrCod16. move wTabe-data to wScrRec16.
     move 'H017' to Tabe-key.  read Tabe into wTabe-rec. move wTabe-ktab to wScrCod17. move wTabe-data to wScrRec17.
     move 'H018' to Tabe-key.  read Tabe into wTabe-rec. move wTabe-ktab to wScrCod18. move wTabe-data to wScrRec18.
     move 'H019' to Tabe-key.  read Tabe into wTabe-rec. move wTabe-ktab to wScrCod19. move wTabe-data to wScrRec19.
     move 'H020' to Tabe-key.  read Tabe into wTabe-rec. move wTabe-ktab to wScrCod20. move wTabe-data to wScrRec20.
fill-Screen-ex. exit.

Rewrite-File.
     move 'H      ' to wTabe-rec
     move wScrCod01 to wTabe-ktab. move wScrRec01 to wTabe-data. rewrite Tabe-record from wTabe-rec.
     move wScrCod02 to wTabe-ktab. move wScrRec02 to wTabe-data. rewrite Tabe-record from wTabe-rec.
     move wScrCod03 to wTabe-ktab. move wScrRec03 to wTabe-data. rewrite Tabe-record from wTabe-rec.
     move wScrCod04 to wTabe-ktab. move wScrRec04 to wTabe-data. rewrite Tabe-record from wTabe-rec.
     move wScrCod05 to wTabe-ktab. move wScrRec05 to wTabe-data. rewrite Tabe-record from wTabe-rec.
     move wScrCod06 to wTabe-ktab. move wScrRec06 to wTabe-data. rewrite Tabe-record from wTabe-rec.
     move wScrCod07 to wTabe-ktab. move wScrRec07 to wTabe-data. rewrite Tabe-record from wTabe-rec.
     move wScrCod08 to wTabe-ktab. move wScrRec08 to wTabe-data. rewrite Tabe-record from wTabe-rec.
     move wScrCod09 to wTabe-ktab. move wScrRec09 to wTabe-data. rewrite Tabe-record from wTabe-rec.
     move wScrCod10 to wTabe-ktab. move wScrRec10 to wTabe-data. rewrite Tabe-record from wTabe-rec.
     move wScrCod11 to wTabe-ktab. move wScrRec11 to wTabe-data. rewrite Tabe-record from wTabe-rec.
     move wScrCod12 to wTabe-ktab. move wScrRec12 to wTabe-data. rewrite Tabe-record from wTabe-rec.
     move wScrCod13 to wTabe-ktab. move wScrRec13 to wTabe-data. rewrite Tabe-record from wTabe-rec.
     move wScrCod14 to wTabe-ktab. move wScrRec14 to wTabe-data. rewrite Tabe-record from wTabe-rec.
     move wScrCod15 to wTabe-ktab. move wScrRec15 to wTabe-data. rewrite Tabe-record from wTabe-rec.
     move wScrCod16 to wTabe-ktab. move wScrRec16 to wTabe-data. rewrite Tabe-record from wTabe-rec.
     move wScrCod17 to wTabe-ktab. move wScrRec17 to wTabe-data. rewrite Tabe-record from wTabe-rec.
     move wScrCod18 to wTabe-ktab. move wScrRec18 to wTabe-data. rewrite Tabe-record from wTabe-rec.
     move wScrCod19 to wTabe-ktab. move wScrRec19 to wTabe-data. rewrite Tabe-record from wTabe-rec.
     move wScrCod20 to wTabe-ktab. move wScrRec20 to wTabe-data. rewrite Tabe-record from wTabe-rec.

     move low-value to Bxm-tabmex
     move '                              ' & x'00' to bxm-mex(1)
     move '                              ' & x'00' to bxm-mex(2)
     move '     Table headers UPDATED    ' & x'00' to bxm-mex(3)
     move '                              ' & x'00' to bxm-mex(4)
     move '                              ' & x'00' to bxm-mex(5)
     move '                              ' & x'00' to bxm-mex(6)
     move '                              ' & x'00' to bxm-mex(7)
     perform DisplayMessage thru DisplayMessageEx
     continue.
Rewrite-File-ex. exit.

*>****************************************************************
*>                                F 1
*>****************************************************************
DisplayHelp.
   perform HideCursor thru HideCursor-ex
   move low-value to bxm-tabmex
   move 05 to Bxm-r1
   move 40 to Bxm-c1
   move 22 to Bxm-r2
   move 76 to Bxm-c2
   move 'N' to Bxm-fcoMH
   move "                                   " & x'00' to bxm-mex(01)
   move "             H E L P               " & x'00' to bxm-mex(02)
   move "             -------               " & x'00' to bxm-mex(03)
   move "  You can manage up to 20 tables   " & x'00' to bxm-mex(04)
   move " Each table has a three digit code " & x'00' to bxm-mex(05)
   move " from 001 to 020 and a description " & x'00' to bxm-mex(06)
   move "                                   " & x'00' to bxm-mex(07)
   move "    With this function you can     " & x'00' to bxm-mex(08)
   move "    set a description (header) to  " & x'00' to bxm-mex(09)
   move "  each one to describe its content " & x'00' to bxm-mex(10)
   move "                                   " & x'00' to bxm-mex(11)
   move "   Use corresponding function to   " & x'00' to bxm-mex(12)
   move "    manage table records (items)   " & x'00' to bxm-mex(13)
   CALL GC02BOXMEX USING BY REFERENCE BOXMEX-AREA
   perform ShowCursor thru ShowCursor-ex
   move '1' to sw-gfx.
DisplayHelp-ex. exit.

Create-Tabe.
  Open Output Tabe
  move space  to wTabe-Rec
  move "H"    to wTabe-ktip
  perform varying wCtr from 1 by 1 until wCtr > 20
          move    wCtr        to   wTabe-ktab9
          string ' please insert here your TABLE HEADER ' wCtr  into wTabe-data
          write   Tabe-Record from wTabe-Rec
  end-perform
  close Tabe.
Create-TabeEx. exit.

DisplayMessage.
   move 'Y' to Bxm-click
   move '010020019051' to Bxm-rc
   move red to Bxm-bco Bxm-bcoM move white to Bxm-fco Bxm-fcoM
   move 'Y' to Bxm-fcoH
   move 'S' to Bxm-style
   call GC02BOXMEX using BOXMEX-AREA
   initialize Bxm-tabmex all to value.
DisplayMessageEx. exit.

TableFileSelection.
   *> background box
   move '002001025080' to Box-rc
   set Box-bco to green Move 'N' to Box-3D
   CALL GC01BOX USING BY CONTENT BOX-AREA
   display ' TABLE HEADERS MANAGEMENT                                                       '
                  at 0101 :BCOL: green Foreground-Color white highlight

   *> ********************************************************
   *> SELECTION OF A TABLE FILE
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

HideCursor. *> hide the cursor
    move 0 to wInt
    call static "curs_set" using by value wInt end-call.
HideCursor-ex. exit.

ShowCursor. *> re-show the cursor
    move 2 to wInt
    call static "curs_set" using by value wInt end-call.
ShowCursor-ex. exit.
