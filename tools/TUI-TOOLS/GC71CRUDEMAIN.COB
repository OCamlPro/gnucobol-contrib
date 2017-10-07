       >>SOURCE FORMAT IS FREE
ID DIVISION.
PROGRAM-ID. GC71CRUDEMAIN.
*> ***********************************************************************************
*> GnuCOBOL TT (TUI TOOLS) COLLECTION
*> Purpose:    CRUDE APPLICATION - MAIN PROGRAM & MENU TO SELECT CRUDE FUNCTIONS
*> Tectonics:  cobc -x GC71CRUDEMAIN.COB  (use GnuCOBOL 2.0 or greater)
*> Usage:      GC71CRUDEMAIN
*> Parameters: none
*> Author:     Eugenio Di Lorenzo - Italia (DILO)
*> License:    Copyright 2017 E.Di Lorenzo - LGPL, 3.0 (or greater)
*> Version:    1.0 2017.03.01
*> Changelog:  1.0 first release.
*> ********************************************************************************************
*>                    GnuCOBOL C.R.U.DE APPLICATION (CREATE READ UPDATE DELETE)
*>                    ---------------------------------------------------------
*>                                                                 call
*>                 .--- BROWSE Func= R ---.                   .--> GC71CRUDEBRO ---. <--.
*>                 |                      |    call           |      (browse)      |    |
*> GC71CRUDEMAIN --+                      |--> GC71CRUDESEL --|                  C/U/D  |goback
*> (cover & menu)  |                      |  (select a file)  |    call            |    |
*>                 '--- CREATE Func= C ---'                   '--> GC71CRUDECUD <--' ---'
*>                                                            (create/update/delete)
*>
*> Menu is used by the user to select Read(Browse) function or Create function
*> before calling Read(Browse) or Create function user have to select a FILE
*> different files should be used to represent differents Company, Divisions, ...
*> if Read(Browse) is selected , user will have a list of FILE records to browse on
*> Read(Browse) program allows selection of one record to update/modify or delete.
*> it allows also to call same program but to Create(insert) a new record. xx
*>
*> ********************************************************************************************
ENVIRONMENT DIVISION.
CONFIGURATION SECTION.
SPECIAL-NAMES. CRT STATUS IS ws-KEY.
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
78  K-NO-FIELD    VALUE 8000.  *> NO DATA FROM ACCEPT ex. a timeout is passed (also 8001)

01  ws-KEY            PIC 9(04) VALUE 9999.
01  ws-Item-Selected  PIC 9(04) VALUE 9999.
01  wDummy            pic x(01) VALUE     ' '.
01  wMn-Selected-MenuDrDn   PIC 9(02) value 01.
01  wMn-Selected-MenuBar    PIC 9(02) value zero.
01  CmdLine                 pic x(121) VALUE SPACE.
01  wSaved-Menu-Area        pic x(8000) value space.

01  LnkFileName       pic x(12) value '--------.DAT'.
01  LnkFunction       pic x(01).
01  LnkKey            pic 9(09) value zero.
01  LnkKeyAttiva      pic x(01) value '1'.

01 GC71CRUDEMAIN PIC X(13) VALUE 'GC71CRUDEMAIN'. *> Main Program & Menu for CRUDE application
01 GC71CRUDESEL  PIC X(12) VALUE 'GC71CRUDESEL'.  *> Selection of a FILE (Company, Division ...)
01 GC71CRUDEBRO  PIC X(12) VALUE 'GC71CRUDEBRO'.  *> Browse a list of data records
01 GC71CRUDECUD  PIC X(12) VALUE 'GC71CRUDECUD'.  *> Create, Upfate, delete of a data record


01 wCOVER1 pic x(480) value
      "     ________              _________  ________ __________ ________  .____       " &
      "    /  _____/  ____  __ __ \_   ___ \ \_____  \\______   \\_____  \ |    |      " &
      "   /   \  ___ /    \|  |  \/    \  \/  /   |   \|    |  _/ /   |   \|    |      " &
      "   \    \_\  \   |  \  |  /\     \____/    |    \    |   \/    |    \    |___   " &
      "    \______  /___|  /____/  \______  /\_______  /______  /\_______  /_______ \  " &
      "           \/     \/               \/         \/       \/         \/        \/  " .
01 wCOVER1R redefines wCOVER1.
   03 wCOVER-R1 PIC X(80) occurs 6.

01 wCOVER2 pic x(480) value
      "         _________     __________      ____ ___   ________  ___________         " &
      "         \_   ___ \    \______   \    |    |   \  \______ \ \_   _____/         " &
      "         /    \  \/     |       _/    |    |   /   |    |  \ |    __)_          " &
      "         \     \____    |    |   \    |    |  /    |    `   \|        \         " &
      "          \______  / /\ |____|_  / /\ |______/ /\ /_______  /_______  / /\      " &
      "                 \/  \/        \/  \/          \/         \/        \/  \/      " .
01 wCOVER2R redefines wCOVER2.
   03 wCOVER-R2 PIC X(80) occurs 6.


01  wSTRING      pic X(60) value space.
01  wLINES       pic 9(03).
01  wCOLUMNS     pic 9(03).
01  wUserName    pic x(16) value space.
01  wFirstTime   pic x(01) value 'Y'.

01  TimeX              pic  x(15).
01  wTime.
   03 wTimehh         pic  9(2).
   03 wTimemm         pic  9(2).
   03 wTimess         pic  9(2).
   03 wTimecc         pic  9(2).

COPY 'GC01BOX.CPY'   .
COPY 'GC21MENU.CPY'  .
copy 'GC02BOXMEX.CPY'.
copy 'GC03YESNO.CPY'.

*> ***************************************************************************************
*>                         P R O C E D U R E   D I V I S I O N
*> ***************************************************************************************
PROCEDURE DIVISION.

InitialSettings.
  *> sets in order to detect the PgUp, PgDn, PrtSc(screen print), Esc keys,
  set environment 'COB_SCREEN_EXCEPTIONS' TO 'Y'.
  set environment 'COB_SCREEN_ESC'        TO 'Y'.

  display ' ' at 0101 with blank screen end-display.

DisplayCoverScreen.
   perform DisplayCover thru DisplayCoverEx.

   *> ***************************************************************************
   *> loop on cover to display time every 1 sec
   *> ***************************************************************************
   PERFORM FOREVER
     accept wDummy at 025080 with auto timeout 1 end-accept
     *> accept whitout value returns 8001 to CRT-STATUS
     if ws-KEY not = 8001 exit perform end-if
     accept wTime from time
     string ' Time ' wTime(1:2) ':' wTime(3:2) ':' wTime(5:2) delimited by size into TimeX
     display TimeX at 024066 with foreground-color white background-color red end-display
   END-PERFORM

   *> which key was pressed on cover Screen ?
   EVALUATE ws-KEY
     WHEN  K-ESCAPE
           go to EndProgram
     WHEN  OTHER
           Perform DisplayBackground thru DisplayBackgroundEx
           Perform MenuManager       thru MenuManagerEx
   END-EVALUATE

   go to DisplayCoverScreen.

EndProgram.
   move 09 to Yn-r1
   move '        Confirm the exit ?       ' to Yn-mess
   call GC03YESNO using YESNO-AREA
   if   Yn-Yesno = "Y"
        continue
   else
        go to MenuManager
   end-if

   display ' ' at 0101 with blank screen end-display
   DISPLAY ' ...OK ! End of C.R.U.DE. Application.                          '
            at 0401 with foreground-color white background-color red
   DISPLAY ' ...GnuCOBOL TUI TOOLS COLLECTION (DILO).                       '
            at 0501 with foreground-color white background-color red
   DISPLAY ' ---------------------------------------------------------------'
            at 0601 with foreground-color white background-color red

  *> Italian Flag
  display '  ' at 008002 with  foreground-color white background-color Green end-display
  display '  ' at 008004 with  foreground-color white background-color white end-display
  display '  ' at 008006 with  foreground-color white background-color red   end-display
  display '  ' at 009002 with  foreground-color white background-color Green end-display
  display '  ' at 009004 with  foreground-color white background-color white end-display
  display '  ' at 009006 with  foreground-color white background-color red   end-display

  STOP RUN.

*> ***************************************************************************************
*>                           M E N U    M A N A G E R
*> ***************************************************************************************
MenuManager.
     perform DisplayBackGround thru DisplayBackgroundEx
     perform DisplayMenuBar    thru DisplayMenuBarEx
     move    mn-selected       to   wMn-Selected-MenuBar

     *> **************************************************************
     *> evaluate selection on menu bar
     *> **************************************************************
     EVALUATE true
         *> when pressed enter on menu bar: activate a drop down menu
         WHEN mn-Key = K-ENTER
               EVALUATE wMn-Selected-MenuBar
                   when  1 perform DropDownMenu1 thru DropDownMenu1ex
                   when  2 perform DropDownMenu2 thru DropDownMenu2ex
                   when  3 perform DropDownMenu3 thru DropDownMenu3ex
                   when  4 perform DropDownMenu4 thru DropDownMenu4ex
                   when  5 perform DropDownMenu5 thru DropDownMenu5ex
                   when  6 perform DropDownMenu6 thru DropDownMenu6ex
               END-EVALUATE
               *> evaluate on drop down menu ****************************
               EVALUATE mn-Key
                   when K-ENTER
                       perform RunChoice thru RunChoiceEx
                       go to MenuManager
                   when K-ESCAPE
                        go to MenuManager
                   when K-RIGHT
                        go to MenuManager
                        *> perform DropDownMenuMove thru DropDownMenuMove-Ex
                   when K-LEFT
                        go to MenuManager
                        *> perform DropDownMenuMove thru DropDownMenuMove-Ex
                 continue
               END-EVALUATE

         *> when pressed escape on menu bar ask if to exit
         WHEN mn-Key = K-ESCAPE
              go to EndProgram

     END-EVALUATE.
MenuManagerEx. exit.


*> **************************************************************************************
*>                       R U N   M E N U   C H O I C E
*> **************************************************************************************
RunChoice.
   EVALUATE wMn-Selected-MenuBar
    *> **********************************************************
    *> MASTER FILE MANAGEMENT - CRUDE
    *> **********************************************************
    when 1
     EVALUATE wMn-Selected-MenuDrDn
        when 1
             *> ************************************
             *> CALL TO CRUDE: with Create
             *> ************************************
             move   'C'     to   LnkFunction
             call   GC71CRUDESEL using LnkFunction
             cancel GC71CRUDESEL
        when 2
             *> ************************************
             *> CALL TO CRUDE: with Read (Browse)
             *> ************************************
             move   'R'     to   LnkFunction
             call   GC71CRUDESEL using LnkFunction
             cancel GC71CRUDESEL
        when 3
               DISPLAY 'Bar Menu 1 - DropDownMenu 3 ' at 020002 with background-color green foreground-color white end-display
               ACCEPT OMITTED AT 2580
        when 4
               DISPLAY 'Bar Menu 1 - DropDownMenu 4 ' at 020002 with background-color green foreground-color white end-display
               ACCEPT OMITTED AT 2580
        when 5
               DISPLAY 'Bar Menu 1 - DropDownMenu 5 ' at 020002 with background-color green foreground-color white end-display
               ACCEPT OMITTED AT 2580
        when 6
               DISPLAY 'Bar Menu 1 - DropDownMenu 6 ' at 020002 with background-color green foreground-color white end-display
               ACCEPT OMITTED AT 2580
        when 7
               DISPLAY 'Bar Menu 1 - DropDownMenu 7 ' at 020002 with background-color green foreground-color white end-display
               ACCEPT OMITTED AT 2580
        when 8
               DISPLAY 'Bar Menu 1 - DropDownMenu 8 ' at 020002 with background-color green foreground-color white end-display
               ACCEPT OMITTED AT 2580
        when 9
             go to EndProgram
     END-EVALUATE

    *> **********************************************************
    *> CHART OF ACCOUNTS (TO BE DONE empty menu items)
    *> **********************************************************
    when 2
     EVALUATE wMn-Selected-MenuDrDn
      when 1
            DISPLAY 'Bar Menu 2 - DropDownMenu 1 '
                     at 020002 with background-color green foreground-color white end-display
             ACCEPT OMITTED AT 2580
      when 2 continue
      when 3 continue
      when 4 continue
      when 5 continue
      when 6 continue
      when 7 continue
      when 8 continue
      when 9  go to EndProgram
     END-EVALUATE

    *> **********************************************************
    *> POSTING ACCOUNTING TRANSACTIONS (TO BE DONE)
    *> **********************************************************
    when 3
     EVALUATE wMn-Selected-MenuDrDn
      when  1
             DISPLAY  'Bar Menu 3 - DropDownMenu 1 '
                     at 020002 with background-color green foreground-color white end-display
             ACCEPT OMITTED AT 2580
      when  2 continue
      when  3 continue
      when  4 continue
      when  5 continue
      when  6 continue
      when  7 continue
      when  8 continue
      when  9 continue
      when 10 continue
      when 11 continue
      when 12 continue
      when 13 continue
      when 14 continue
      when 15 continue
      when 16  go to EndProgram
     END-EVALUATE

    *> **********************************************************
    *> SYSTEM DATA (TO BE DONE)
    *> **********************************************************
    when 4
     EVALUATE wMn-Selected-MenuDrDn
      when  1 continue
      when  2 continue
      when  3 continue
      when  4 continue
      when  5 continue
      when  6 continue
      when  7 continue
      when  8 continue
      when  9 continue
      when 10 go to EndProgram
     END-EVALUATE
    *> **********************************************************
    *> OTHERS (TO BE DONE)
    *> **********************************************************
    when 5
     EVALUATE wMn-Selected-MenuDrDn
      when  1 continue
      when  2 continue
      when  3 continue
      when  4 continue
      when  5 continue
      when  6 continue
      when  7 continue
      when  8 continue
      when  9 continue
      when 10 go to EndProgram
     END-EVALUATE
    *> **********************************************************
    *> EXIT
    *> **********************************************************
    when 6
     EVALUATE wMn-Selected-MenuDrDn
      when 1
             DISPLAY  'Bar Menu 6 - DropDownMenu 1 '
                     at 020002 with background-color green foreground-color white end-display
             ACCEPT OMITTED AT 2580
      when 2  go to DisplayCoverScreen
      when 3
       *> exit to DOS
       DISPLAY ' ' with blank screen
       DISPLAY '                                                     '
               at 0301 with foreground-color yellow background-color red highlight
       DISPLAY ' ... OK ! you are going to a temporary DOS window    '
               at 0401 with foreground-color yellow background-color red highlight
       DISPLAY '     (type ''EXIT'' to return to this application)     '
               at 0501 with foreground-color yellow background-color red highlight
       DISPLAY ' ----------------------------------------------------'
               at 0601 with foreground-color yellow background-color red highlight
       DISPLAY '                                                     '
               at 0701 with foreground-color yellow background-color red highlight
       ACCEPT OMITTED
       move 'CLS' & X'00' TO CmdLine
       CALL 'SYSTEM'   using CmdLine
       move 'CMD' & X'00' TO CmdLine
       CALL 'SYSTEM'   using CmdLine
      when 4
           *> DISPLAY "ABOUT" INFO
           perform About thru AboutEx
      when 5
           go EndProgram
   END-EVALUATE .
RunChoiceEx. exit.

*> *************************************************************************************
*>              D I S P L A Y    T H E     M A I N    M E N U    B A R
*> *************************************************************************************
DisplayMenuBar.
   if wFirstTime = 'Y'
      move 'N' to wFirstTime
      initialize menu-area ALL TO VALUE
      move low-value to mn-tab
      move z'12001001 Master File '      to mn-ele(1)
      move z' 2001014 CoA        '       to mn-ele(2)
      move z' 2001026 Postings     '     to mn-ele(3)
      move z' 3001040 System      '      to mn-ele(4)
      move z' 2001053 Other      '       to mn-ele(5)
      move z' 2001065 Exit     '         to mn-ele(6)

      move ' C.R.U.DE. Application                    ' to mn-mess(1)
      move ' Chart of Account                         ' to mn-mess(2)
      move ' Managemnt of Accounting transactions     ' to mn-mess(3)
      move ' Manage System data records               ' to mn-mess(4)
      move ' Other options and miscellaneous functions' to mn-mess(5)
      move ' Exit from this C.R.U.DE. application     ' to mn-mess(6)
   else
      *> restore the Active Item
      move wSaved-Menu-Area to Menu-Area
   end-if
   CALL GC21MENU USING BY REFERENCE MENU-AREA
   *> save configuration of MenuArea and "active" tem
   move Menu-Area to wSaved-Menu-Area.
DisplayMenuBarEx. exit.

*> *************************************************************************************
*>                 D I S P L A Y    D R O P    D O W N     M E N U S
*> *************************************************************************************
DropDownMenu1.
   perform DropDownMenuInitialize thru DropDownMenuInitializeEx
   move ' 2003002 Create              ' & x'00' to mn-ele(1)
   move '12004002 Read (Browse)       ' & x'00' to mn-ele(2)
   move ' 2005002 Option number 3     ' & x'00' to mn-ele(3)
   move ' 3006002 Option number 4     ' & x'00' to mn-ele(4)
   move ' 4007002 Option number 5     ' & x'00' to mn-ele(5)
   move ' 5008002 Option number 6     ' & x'00' to mn-ele(6)
   move ' 6009002 Option number 7     ' & x'00' to mn-ele(7)
   move ' 7010002 Option number 8     ' & x'00' to mn-ele(8)
   move ' 2011002 End of Work         ' & x'00' to mn-ele(9)

   move ' Create a data record on Master File' to mn-mess(1)
   move ' Browse a list of data records, next you can edit and/or delete records'  to mn-mess(2)
   move ' Message for option numer 3 3 3 3 3 3 3 3 3 3              ' to mn-mess(3)
   move ' Message for option numer 4  4  4  4  4  4  4  4  4  4     ' to mn-mess(4)
   move ' Message for option numer 5 555555555555555555555          ' to mn-mess(5)
   move ' Message for option numer 6                                ' to mn-mess(6)
   move ' Message for option numer 7                                ' to mn-mess(7)
   move ' Message for option numer 8                                ' to mn-mess(8)
   move ' Exit from this C.R.U.DE. application                      ' to mn-mess(9)
   CALL GC21MENU USING BY REFERENCE MENU-AREA
   Move Mn-Selected to wMn-Selected-MenuDrDn.
DropDownMenu1Ex. exit.

DropDownMenu2.
   perform DropDownMenuInitialize thru DropDownMenuInitializeEx
   move '17003015 Option number 1           ' & x'00' to mn-ele(1)
   move ' 2004015 Option number 2           ' & x'00' to mn-ele(2)
   move ' 2005015 Option number 3           ' & x'00' to mn-ele(3)
   move ' 2006015 Option number 4           ' & x'00' to mn-ele(4)
   move ' 2007015 Option number 5           ' & x'00' to mn-ele(5)
   move ' 6008015 Option number 6           ' & x'00' to mn-ele(6)
   move ' 2009015 Option number 7           ' & x'00' to mn-ele(7)
   move ' 3010015 Option number 8           ' & x'00' to mn-ele(8)
   move ' 3011015 End of work               ' & x'00' to mn-ele(9)

   move ' Message for option number 1          ' to mn-mess(1)
   move ' Message for option number 2          ' to mn-mess(2)
   move ' Message for option number 3          ' to mn-mess(3)
   move ' Message for option number 4          ' to mn-mess(4)
   move ' Message for option number 5          ' to mn-mess(5)
   move ' Message for option number 6          ' to mn-mess(6)
   move ' Message for option number 7          ' to mn-mess(7)
   move ' Message for option number 8          ' to mn-mess(8)
   move ' Exit from this C.R.U.DE. application ' to mn-mess(9)
   CALL GC21MENU USING BY REFERENCE MENU-AREA
   Move Mn-Selected to wMn-Selected-MenuDrDn.
DropDownMenu2ex. exit.

DropDownMenu3.
   perform DropDownMenuInitialize thru DropDownMenuInitializeEx
   move '19003027 Option number 1           ' & x'00' to mn-ele(1)
   move ' 2004027 Option number 2           ' & x'00' to mn-ele(2)
   move ' 2005027 Option number 3           ' & x'00' to mn-ele(3)
   move ' 9006027 Option number 4           ' & x'00' to mn-ele(4)
   move ' 2007027 Option number 5           ' & x'00' to mn-ele(5)
   move ' 3008027 Option number 6           ' & x'00' to mn-ele(6)
   move ' 2009027 Option number 7           ' & x'00' to mn-ele(7)
   move ' 1010027 ------------------------- ' & x'00' to mn-ele(8)
   move ' 2011027 Option number 8           ' & x'00' to mn-ele(9)
   move ' 2012027 Option number 9           ' & x'00' to mn-ele(10)
   move ' 4013027 Option number 10          ' & x'00' to mn-ele(11)
   move ' 5014027 Option number 11          ' & x'00' to mn-ele(12)
   move ' 3015027 Option number 12          ' & x'00' to mn-ele(13)
   move ' 6016027 Option number 13          ' & x'00' to mn-ele(14)
   move ' 1017027 ------------------------- ' & x'00' to mn-ele(15)
   move ' 3018027 End of work               ' & x'00' to mn-ele(16)
   move ' Message for option number 1                                     ' to mn-mess(1)
   move ' Message for option number 2                                     ' to mn-mess(2)
   move ' Message for option number 3                                     ' to mn-mess(3)
   move ' Message for option number 4                                     ' to mn-mess(4)
   move ' Message for option number 5                                     ' to mn-mess(5)
   move ' Message for option number 6                                     ' to mn-mess(6)
   move ' Message for option number 7                                     ' to mn-mess(7)
   move ' not available                                                   ' to mn-mess(8)
   move ' Message for option number 8                                     ' to mn-mess(9)
   move ' Message for option number 9                                     ' to mn-mess(10)
   move ' Message for option number 10                                    ' to mn-mess(11)
   move ' Message for option number 11                                    ' to mn-mess(12)
   move ' Message for option number 12                                    ' to mn-mess(13)
   move ' Message for option number 13                                    ' to mn-mess(14)
   move ' not available                                                   ' to mn-mess(15)
   move ' Exit from this C.R.U.DE. application                            ' to mn-mess(16)
   CALL GC21MENU USING BY REFERENCE MENU-AREA
   Move Mn-Selected to wMn-Selected-MenuDrDn.
DropDownMenu3ex. exit.

DropDownMenu4.
   perform DropDownMenuInitialize thru DropDownMenuInitializeEx
   move ' 2003041 a) Option a               ' & x'00' to mn-ele(1)
   move ' 2004041 b) Option b               ' & x'00' to mn-ele(2)
   move '12005041 c) Option c               ' & x'00' to mn-ele(3)
   move ' 2006041 d) Option d               ' & x'00' to mn-ele(4)
   move ' 2007041 e) Option e               ' & x'00' to mn-ele(5)
   move ' 2008041 f) Option f               ' & x'00' to mn-ele(6)
   move ' 2009041 g) Option g               ' & x'00' to mn-ele(7)
   move ' 2010041 h) Option h               ' & x'00' to mn-ele(8)
   move ' 2011041 i) Option i               ' & x'00' to mn-ele(9)
   move ' 2012041 End of work               ' & x'00' to mn-ele(10)

   move ' Message for option a                                                 ' to mn-mess(1)
   move ' Message for option b                                                 ' to mn-mess(2)
   move ' Message for option c                                                 ' to mn-mess(3)
   move ' Message for option d                                                 ' to mn-mess(4)
   move ' Message for option e                                                 ' to mn-mess(5)
   move ' Message for option f                                                 ' to mn-mess(6)
   move ' Message for option g                                                 ' to mn-mess(7)
   move ' Message for option h                                                 ' to mn-mess(8)
   move ' Message for option i                                                 ' to mn-mess(9)
   move ' Exit from this C.R.U.DE. application                                 ' to mn-mess(10)
   CALL GC21MENU USING BY REFERENCE MENU-AREA
   Move Mn-Selected to wMn-Selected-MenuDrDn.
DropDownMenu4ex. exit.

DropDownMenu5.
   perform DropDownMenuInitialize thru DropDownMenuInitializeEx
   move '12003054 1.Option number 1      ' & x'00'  to mn-ele(1)
   move ' 2004054 2.Option number 2      ' & x'00'  to mn-ele(2)
   move ' 2005054 3.Option number 3      ' & x'00'  to mn-ele(3)
   move ' 2006054>4.Option number 4      ' & x'00'  to mn-ele(4)
   move ' 2007054>5.Option number 5      ' & x'00'  to mn-ele(5)
   move ' 2008054 6.Option number 6      ' & x'00'  to mn-ele(6)
   move ' 2009054 7.Option number 7      ' & x'00'  to mn-ele(7)
   move ' 2010054 8.Option number 8      ' & x'00'  to mn-ele(8)
   move ' 2011054 9.Option number 9      ' & x'00'  to mn-ele(9)
   move ' 2012054 End of work            ' & x'00'  to mn-ele(10)

   move ' Message for option number 1  '     to mn-mess(1)
   move ' Message for option number 2  '     to mn-mess(2)
   move ' Message for option number 3  '     to mn-mess(3)
   move ' Message for option number 4  '     to mn-mess(4)
   move ' Message for option number 5  '     to mn-mess(5)
   move ' Message for option number 6  '     to mn-mess(6)
   move ' Message for option number 7  '     to mn-mess(7)
   move ' Message for option number 8  '     to mn-mess(8)
   move ' Message for option number 9  '     to mn-mess(9)
   move ' Exit from this C.R.U.DE. application                '     to mn-mess(10)
   CALL GC21MENU USING BY REFERENCE MENU-AREA
   Move Mn-Selected to wMn-Selected-MenuDrDn.
DropDownMenu5ex. exit.

DropDownMenu6.
   perform DropDownMenuInitialize thru DropDownMenuInitializeEx
   move ' 2003066 Item 1      ' & x'00' to mn-ele(1)
   move '12004066 Cover       ' & x'00' to mn-ele(2)
   move ' 2005066 Exit to DOS ' & x'00' to mn-ele(3)
   move ' 2006066 About       ' & x'00' to mn-ele(4)
   move ' 2007066 End of work ' & x'00' to mn-ele(5)
   move ' Go to Cover Screen               ' to mn-mess(1)
   move ' Message item 2                   ' to mn-mess(2)
   move ' Temporary exit to DOS (type ''EXIT'' to return this menu).' to mn-mess(3)
   move ' About this application           ' to mn-mess(4)
   move ' Exit                             ' to mn-mess(5)
   CALL GC21MENU USING BY REFERENCE MENU-AREA
   Move Mn-Selected to wMn-Selected-MenuDrDn.
DropDownMenu6ex. exit.


DropDownMenuInitialize.
   Initialize menu-area ALL TO VALUE
   move low-value to mn-tab
   move 'Y' to Mn-Box
   move 'Y' to Mn-Shadow
   *> user can use only vertical cursors (Up or Down) movement
   move 'V' to Mn-Arrow
   *> return to caller if used horizontal cursor movements  (Left or Right)
   move 'Y' to Mn-Return.
DropDownMenuInitializeEx. exit.

DropDownMenuMove.
   DISPLAY "MOVE MENU" AT 009004 with foreground-color white background-color red
   ACCEPT OMITTED.
DropDownMenuMove-Ex. exit.

*> ****************************************************************************************
*>                               D I S P L A Y   C O V E R
*> ****************************************************************************************
DisplayCover.
    set  Box-fco Box-bco to Red
    move '001001025080'  to Box-rc
    move 'N'             to Box-style Box-3D
    call GC01BOX using BOX-AREA end-call

    ACCEPT wUserName FROM USER NAME end-accept
    STRING " User: " wUserName into wSTRING
    DISPLAY wSTRING AT 002001 with foreground-color white background-color red

   display GC71CRUDEMAIN at 002067 with background-color red foreground-color white highlight

    display wCOVER-R1(1) at 005001 with background-color Red foreground-color White highlight
    display wCOVER-R1(2) at 006001 with background-color Red foreground-color White highlight
    display wCOVER-R1(3) at 007001 with background-color Red foreground-color White highlight
    display wCOVER-R1(4) at 008001 with background-color Red foreground-color White highlight
    display wCOVER-R1(5) at 009001 with background-color Red foreground-color White highlight
    display wCOVER-R1(6) at 010001 with background-color Red foreground-color White highlight

    display wCOVER-R2(1) at 011001 with background-color Red foreground-color White highlight
    display wCOVER-R2(2) at 012001 with background-color Red foreground-color White highlight
    display wCOVER-R2(3) at 013001 with background-color Red foreground-color White highlight
    display wCOVER-R2(4) at 014001 with background-color Red foreground-color White highlight
    display wCOVER-R2(5) at 015001 with background-color Red foreground-color White highlight
    display wCOVER-R2(6) at 016001 with background-color Red foreground-color White highlight

    DISPLAY "        GnuCOBOL 2.0 TUI TOOLS COLLECTION         " AT 019016
             with foreground-color white background-color red.
    DISPLAY "C.R.U.DE. APPLICATION - CREATE READ UPDATE DELETE " AT 021016
             with foreground-color Yellow highlight background-color red
    DISPLAY "------------------------------------------------- " AT 022016
             with foreground-color Yellow highlight background-color red

    *> Italian Flag
    display ' ' at 021011 with       foreground-color white background-color Green
    display ' ' at 021012 with blink foreground-color white background-color white
    display ' ' at 021013 with blink foreground-color white background-color red

    display ' ' at 021067 with       foreground-color white background-color Green
    display ' ' at 021068 with blink foreground-color white background-color white
    display ' ' at 021069 with blink foreground-color white background-color red

    ACCEPT wLINES   from LINES; ACCEPT wCOLUMNS from COLUMNS
    STRING " Screen of " wLINES " x " wCOLUMNS  " - Press a key to Enter, ESCAPE to EXIT. " into wSTRING
    DISPLAY wSTRING AT 024001 with foreground-color white background-color red.

DisplayCoverEx. Exit.

DisplayBackground.
  set  Box-bco to green
  set  Box-fco to white
  move '002001024080' to Box-rc
  move 'D'      to Box-style
  move 'N'      to Box-3D
  call  GC01BOX using BOX-AREA
  display '                                                                                '
         at 0101  with background-color white.
  display "[" & X"FE" & "]" at 002076 with background-color green foreground-color white highlight.
  display 'Select ''Master File'' item to access the sample C.R.U.DE. application  '
          at 2302  with background-color green foreground-color white highlight.
DisplayBackgroundEx. Exit.

About.
    move white to Box-bco Box-fco
    move '001001025080' to Box-rc
    move 'S'            to Box-style
    call GC01BOX using Box-Area

    move space & x'00' to Bxm-mex(01)
    move '                              ''''~``                          '  & x'00' to Bxm-mex(02)
    move '                             ( o o )                         '  & x'00' to Bxm-mex(03)
    move '     +------------------.oooO--(_)--Oooo.------------------+ '  & x'00' to Bxm-mex(04)
    move '     |                                                     | '  & x'00' to Bxm-mex(05)
    move '     |       GnuCOBOL 2.0 TUI TOOLS COLLECTION (DILO)      | '  & x'00' to Bxm-mex(06)
    move '     |                                                     | '  & x'00' to Bxm-mex(07)
    move '     |                    .oooO                            | '  & x'00' to Bxm-mex(08)
    move '     |                    (   )   Oooo.                    | '  & x'00' to Bxm-mex(09)
    move '     +---------------------\ (----(   )--------------------+ '  & x'00' to Bxm-mex(10)
    move '                            \_)    ) /                       '  & x'00' to Bxm-mex(11)
    move '                                  (_/                        '  & x'00' to Bxm-mex(12)
    move space & x'00' to Bxm-mex(13)
    move space & x'00' to Bxm-mex(14)

    Move '37YSabcdefghiYYRNN37YYYN77Y' to Bxm-Parameters
    move '004005021073'                to Bxm-rc
    call GC02BOXMEX using BOXMEX-AREA.
AboutEx. Exit.
