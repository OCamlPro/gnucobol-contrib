ID DIVISION.
program-id. GC22MENUDEMO2.
*> ***********************************************************************************
*> GnuCOBOL TT (TUI TOOLS) COLLECTION
*> Purpose:    DEMO OF GC22MENU -  BAR & DROPDOWN MENU MANAGEMENT WITH DEMO OF HOT KEY OF MENU ITEMS
*> Tectonics:  cobc -x GC22MENUDEMO2
*> Usage:      GC22MENUDEMO2
*> Parameters: none
*> Author:     Eugenio Di Lorenzo - Italia (DILO)
*> License:    Copyright 2017 E.Di Lorenzo - GNU Lesser General Public License 3.0 (or greater)
*> Version:    1.0 2017.07.20
*> Changelog:  1.0 first release.
*> ***********************************************************************************
ENVIRONMENT DIVISION.
CONFIGURATION SECTION.
SPECIAL-NAMES.
   CRT STATUS IS wCRT-STATUS.

DATA DIVISION.
File Section.
WORKING-STORAGE SECTION.

01 black   constant as 0.
01 blue    constant as 1.
01 green   constant as 2.
01 cyan    constant as 3.
01 red     constant as 4.
01 magenta constant as 5.
01 yellow  constant as 6.  *> or Brown
01 white   constant as 7.
01 result     usage binary-long.
01 wresult    pic S9(8).
01 riga80     pic x(80) value space.

01  CmdLine           pic x(121) VALUE SPACE.
01  i                 pic s9(4) comp-5.
01  Sel-BarMenuItem   pic s9(2) comp-5.
01  TimeX              pic  x(15).
01  wTime.
   03 wTimehh         pic  9(2).
   03 wTimemm         pic  9(2).
   03 wTimess         pic  9(2).
   03 wTimecc         pic  9(2).


copy     'GC22MENU.CPY'.
copy      'GC01BOX.CPY'.
copy    'GC03YESNO.CPY'.
copy   'GC02BOXMEX.CPY'.
COPY  'GC98KEYCODE.CPY'.

01  wDummy        pic x(01) VALUE ' '.
*> 01  GnuCOBOLdemo1 pic x(480) value
   *> '    ______             __________  ____  ____  __         __                    ' &
   *> '   / ____/___  __  __ / ____/ __ \/ __ )/ __ \/ /    ____/ /__  ____ ___  ____  ' &
   *> '  / / __/ __ \/ / / // /   / / / / __  / / / / /    / __  / _ \/ __ `__ \/ __ \ ' &
   *> ' / /_/ / / / / /_/ // /___/ /_/ / /_/ / /_/ / /___ / /_/ /  __/ / / / / / /_/ / ' &
   *> ' \____/_/ /_/\__,_/ \____/\____/_____/\____/_____/ \__,_/\___/_/ /_/ /_/\____/  ' &
   *> '                                                                                '.
*> *>  12345678901234567890123456789012345678901234567890123456789012345678901234567890
*> 01 GnuCOBOLdemoR1 redefines GnuCOBOLdemo1.
   *> 03 rGnu1 PIC X(80) occurs 6.

01 GnuCOBOLdemo2 pic x(480) value
   "   ____               ____ ___  ____   ___  _           _                       " &
   "  / ___|_ __  _   _  / ___/ _ \| __ ) / _ \| |       __| | ___ _ __ ___   ___   " &
   " | |  _| '_ \| | | || |  | | | |  _ \| | | | |      / _` |/ _ \ '_ ` _ \ / _ \  " &
   " | |_| | | | | |_| || |__| |_| | |_) | |_| | |___  | (_| |  __/ | | | | | (_) | " &
   "  \____|_| |_|\__,_| \____\___/|____/ \___/|_____|  \__,_|\___|_| |_| |_|\___/  ".
*>  12345678901234567890123456789012345678901234567890123456789012345678901234567890
01 GnuCOBOLdemoR2 redefines GnuCOBOLdemo2.
   03 rGnu2 PIC X(80) occurs 6.

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
78  K-NO-FIELD    VALUE 8000.  *> NO DATA FROM ACCEPT (also 8001)

01  wCRT-STATUS  PIC  9(04) VALUE 9999.
01  wCOMMAND     pic  X(40) value space.
01  wSTRING      pic  X(60) value space.
01  wLINES       pic  9(03).
01  wCOLUMNS     pic  9(03).
01  wLINES2      pic  9(03).
01  wCOLUMNS2    pic  9(03).
01  wUserName    pic  x(16) value space.
01  wMn-Selected-MenuDrDn   PIC 9(02) value 01.
01  wMn-Selected-MenuBar    PIC 9(02) value zero.
01  wSaved-Menu-Area        pic x(8000) value space.
01  wFirstTime              pic x(01)   value 'Y'.


PROCEDURE DIVISION.
*> **************************************************************
*>           P R O C E D U R E   D I V I S I O N
*> **************************************************************
Initial-Settings.
   *> sets in order to detect the PgUp, PgDn, PrtSc(screen print), Esc keys,
   set environment 'COB_SCREEN_EXCEPTIONS' TO 'Y'.
   set environment 'COB_SCREEN_ESC'        TO 'Y'.
   display ' ' at 0101 with blank screen end-display.

Main.
   perform Display-Cover thru Display-CoverEx.
   *> ***************************************************************************
   *> loop to display time every 1 sec
   *> ***************************************************************************
   PERFORM FOREVER
     accept wDummy at 025080 with AUTO TIMEOUT 1 end-accept
     IF wCRT-STATUS NOT = 8001 EXIT PERFORM END-IF *> accept whitout value returns 8001 to CRT-STATUS
     accept wTime from time
     string ' Time ' wTime(1:2) ':' wTime(3:2) ':' wTime(5:2) delimited by size into TimeX end-string
     display TimeX at 002066 with foreground-color white background-color Red end-display
   END-PERFORM.

   EVALUATE wCRT-STATUS   *> which key was pressed ?
    WHEN  K-ENTER
      Perform DisplayBackground thru DisplayBackgroundEx
      PERFORM MenuManager       THRU MenuManagerEx
    WHEN  K-ESCAPE
      go to MainEx
   END-EVALUATE

   go to Main.
MainEx.

   display ' ' at 0101 with blank screen end-display
   DISPLAY ' ...OK ! End of work.                          '
            at 0401 with foreground-color white background-color red
   DISPLAY ' ----------------------------------------------'
            at 0501 with foreground-color white background-color red
   *> ACCEPT OMITTED
   ACCEPT wDUMMY with NO-ECHO
   GOBACK.

*> *************************************************************
*> MENU MANAGER
*> *************************************************************
MenuManager.
     perform DisplayBackGround thru DisplayBackgroundEx
     perform DisplayMenuBar    thru DisplayMenuBarEx
     move    mn-selected       to   wMn-Selected-MenuBar

     *> **************************************************************
     *> evaluate selection on menu bar
     *> **************************************************************
     EVALUATE true

         *> when pressed enter on menu bar: activate a drop down menu
         WHEN mn-Key = Key-Enter
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
                 when Key-Enter
                     perform RunChoice thru RunChoiceEx
                     go to MenuManager
                 when Key-Escape
                      go to MenuManager
                 when Key-CursRight
                      go to MenuManager
                      *> perform MoveDropDownMenu thru MoveDropDownMenu-Ex
                 when Key-CursLeft
                      go to MenuManager
                      *> perform MoveDropDownMenu thru MoveDropDownMenu-Ex
                 continue
               END-EVALUATE

         *> when pressed escape on menu bar ask if to exit
         WHEN mn-Key = Key-Escape
           move 09 to Yn-r1
           move '        Confirm the exit ?       ' to Yn-mess
           call GC03YESNO using YESNO-AREA
           if   Yn-Yesno = "Y"
                go to MainEx
           else
                go to MenuManager
           end-if
     END-EVALUATE

   .
MenuManagerEx. exit.

DisplayMenuBar.
   if wFirstTime = 'Y'
      move 'N' to wFirstTime
      initialize menu-area ALL TO VALUE
      move low-value to mn-tab
      move z'12001001 Boxes       '      to mn-ele(1)
      move z' 3001014 Buttons    '       to mn-ele(2)
      move z' 2001026 Menu         '     to mn-ele(3)
      move z' 2001040 Calendar    '      to mn-ele(4)
      move z' 2001053 Other      '       to mn-ele(5)
      move z' 2001065 Exit           '   to mn-ele(6)

      move ' Demo of Boxes                            ' to mn-mess(1)
      move ' Demo of Buttons                          ' to mn-mess(2)
      move ' Demo of Menus                            ' to mn-mess(3)
      move ' Some kind of calendars                   ' to mn-mess(4)
      move ' Other options and miscellaneous functions' to mn-mess(5)
      move ' Exit from GnuCOBOL DEMO                  ' to mn-mess(6)
   else
      *> restore the Active Item
      move wSaved-Menu-Area to Menu-Area
   end-if

   CALL GC22MENU USING BY REFERENCE MENU-AREA

   *> save configuration of MenuArea and "active" tem
   move Menu-Area to wSaved-Menu-Area.
DisplayMenuBarEx. exit.


*> *************************************************************
*> RUN MENU CHOICE
*> *************************************************************
RunChoice.
   EVALUATE wMn-Selected-MenuBar
    *> **********************************************************
    *> BOX MENU
    *> **********************************************************
    when 1
     EVALUATE wMn-Selected-MenuDrDn
      when 1 DISPLAY ' ITEM 1 - ITEM 1 ' at 018040 END-DISPLAY ACCEPT wDUMMY with NO-ECHO
      when 2 DISPLAY ' ITEM 1 - ITEM 2 ' at 018040 END-DISPLAY ACCEPT wDUMMY with NO-ECHO
      when 3 DISPLAY ' ITEM 1 - ITEM 3 ' at 018040 END-DISPLAY ACCEPT wDUMMY with NO-ECHO
      when 4
      when 5
      when 6
      when 7
      when 8
      when 9
      move 09 to Yn-r1
           move '        Confirm the exit ?       ' to Yn-mess
           call GC03YESNO using YESNO-AREA
           if   Yn-Yesno = "Y" go to MainEx
           else                go to MenuManager
           end-if
     END-EVALUATE

    *> **********************************************************
    *> BUTTONS
    *> **********************************************************
    when 2
     EVALUATE wMn-Selected-MenuDrDn
      when 1 DISPLAY ' ITEM 2 - ITEM 1 ' at 018040 END-DISPLAY ACCEPT wDUMMY with NO-ECHO
      when 2 continue
      when 3 continue
      when 4 continue
      when 5 continue
      when 6 continue
      when 7 continue
      when 8 continue
      when 9 continue
     END-EVALUATE

    *> **********************************************************
    *> MENU
    *> **********************************************************
    when 3
     EVALUATE wMn-Selected-MenuDrDn
      when  1 DISPLAY ' ITEM 3 - ITEM 1 ' at 018040 END-DISPLAY ACCEPT wDUMMY with NO-ECHO
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
      when 16 continue
     END-EVALUATE

    *> **********************************************************
    *> CALENDAR
    *> **********************************************************
    when 4
     EVALUATE wMn-Selected-MenuDrDn
      when 1 DISPLAY ' ITEM 4 - sub ITEM 1 ' at 018040 END-DISPLAY ACCEPT wDUMMY with NO-ECHO
      when 2 DISPLAY ' ITEM 4 - sub ITEM 2 ' at 018040 END-DISPLAY ACCEPT wDUMMY with NO-ECHO
      when 3 DISPLAY ' ITEM 4 - sub ITEM 3 ' at 018040 END-DISPLAY ACCEPT wDUMMY with NO-ECHO
      when 4 DISPLAY ' ITEM 4 - sub ITEM 4 ' at 018040 END-DISPLAY ACCEPT wDUMMY with NO-ECHO
      when 5
      when 6
      when 7
      when 8
      when 9
      when 10  continue
     END-EVALUATE
    *> **********************************************************
    *> OTHERS
    *> **********************************************************
    when 5
     EVALUATE wMn-Selected-MenuDrDn
      when 1 continue
      when 2 continue
      when 3 DISPLAY ' ITEM 5 - ITEM 3 ' at 018040 END-DISPLAY ACCEPT wDUMMY with NO-ECHO
      when 4 continue
      when 5 continue
      when 6 continue
      when 7 continue
      when 8 continue
      when 9 continue
      when 10 continue
     END-EVALUATE
    *> **********************************************************
    *> EXIT & HELP
    *> **********************************************************
    when 6
     EVALUATE wMn-Selected-MenuDrDn
      when 1  continue
      when 2  continue
      when 3
       *> exit to DOS
       DISPLAY ' ' with blank screen
       DISPLAY '                                                     '
               at 0301 with foreground-color yellow background-color red highlight
       DISPLAY ' ... OK ! you are going to a temporary DOS window    '
               at 0401 with foreground-color yellow background-color red highlight
       DISPLAY '     (type ''EXIT'' to return to application)          '
               at 0501 with foreground-color yellow background-color red highlight
       DISPLAY ' ----------------------------------------------------'
               at 0601 with foreground-color yellow background-color red highlight
       DISPLAY '                                                     '
               at 0701 with foreground-color yellow background-color red highlight
       *> ACCEPT OMITTED
       ACCEPT wDUMMY with NO-ECHO
       move 'CLS' & X'00' TO CmdLine
       CALL 'SYSTEM'   using CmdLine
       move 'CMD' & X'00' TO CmdLine
       CALL 'SYSTEM'   using CmdLine
      when 4 perform About thru AboutEx  *> ABOUT (a message BOX .....)
      when 5 go MainEx                   *> END OF WORK
     END-EVALUATE
   END-EVALUATE
   .
RunChoiceEx. exit.

*> *************************************************************
*>                   ROUTINES DA NON TOCCARE
*> *************************************************************
MoveDropDownMenu.
   *> call 'display_restore_window' using w-buff w-block
   *> move x'01' to iCH *> codice scansione tasto escape
   *> move x'1B' to iCL *> codice ASCII tasto escape
   *> move x'05' to iAH *> serv.x write in buffer tastiera
   *> call 'mli_int16' using input-regs
   *> move x'E0' to iCH     *> codice scansione tasto -> o <-
   *> move mn-tasto to iCL9 *> codice ASCII tasto -> o <-
   *> move x'05' to iAH     *> serv.x write in buffer tastiera
   *> call 'mli_int16' using input-regs
   *> move x'1C' to iCH *> codice scansione tasto enter
   *> move x'0D' to iCL *> codice ASCII tasto enter
   *> move x'05' to iAH *> serv.x write in buffer tastiera
   *> call 'mli_int16' using input-regs
   DISPLAY "MOVE MENU" AT 009004 with foreground-color white background-color red
   *> ACCEPT OMITTED
   ACCEPT wDUMMY with NO-ECHO
   .
MoveDropDownMenu-Ex. exit.

DropDownMenu1.
   perform InitializeDropDownMenu thru InitializeDropDownMenuEx
   move '12003002 Menu item 1               ' & x'00' to mn-ele(1)
   move ' 2004002 BOXDEMO                   ' & x'00' to mn-ele(2)
   move ' 2005002 Option number 3           ' & x'00' to mn-ele(3)
   move ' 2006002 Archivi saldi trimestrali ' & x'00' to mn-ele(4)
   move ' 2007002 Duplica saldi trimestrali ' & x'00' to mn-ele(5)
   move ' 9008002 Carica imponib.e ENASARCO ' & x'00' to mn-ele(6)
   move ' 2009002 Ripresa saldi trimestrali ' & x'00' to mn-ele(7)
   move ' 5010002 Crea floppy-disk x sede   ' & x'00' to mn-ele(8)
   move ' 2011002 End of Work               ' & x'00' to mn-ele(9)

   move '  First option descrition - message  ' to mn-mess(1)
   move '  Some Boxes Demo                    '  to mn-mess(2)
   move '  Message for option numer 3 xxxxxxx xxxxxxxxxxx xxxxxxxxx  ' to mn-mess(3)
   move '  Elenco archivi xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx        ' to mn-mess(4)
   move '  Duplicazione dati xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx        ' to mn-mess(5)
   move '  Caricamento cccccccccccccc cccccccccccccccc ccccccccccc   ' to mn-mess(6)
   move '  Ripresa dati trimestrali xxxxxxxxxxxxxx nnnnnnnnnnnnnnnn  ' to mn-mess(7)
   move '  Scarica su dioscoccccccccc cccccccccc ccccccccccc         ' to mn-mess(8)
   move '  Exit from this demo                                       '        to mn-mess(9)
   CALL GC22MENU USING BY REFERENCE MENU-AREA
   Move Mn-Selected to wMn-Selected-MenuDrDn
   .
DropDownMenu1Ex. exit.

DropDownMenu2.
   perform InitializeDropDownMenu thru InitializeDropDownMenuEx
   move '17003015 Demo Buttons              ' & x'00' to mn-ele(1)
   move ' 2004015 Controllo archivio saldi  ' & x'00' to mn-ele(2)
   move ' 2005015 Dist.Versamenti XXXXXXX   ' & x'00' to mn-ele(3)
   move ' 2006015 Allegato alla distinta    ' & x'00' to mn-ele(4)
   move ' 2007015 Individua Agenti comuni   ' & x'00' to mn-ele(5)
   move ' 6008015 Sit.Versamenti xxxxxxxxxx ' & x'00' to mn-ele(6)
   move ' 2009015 Sit.Imponibili ccccc      ' & x'00' to mn-ele(7)
   move ' 3010015 Ind.Suplettiva Clientela  ' & x'00' to mn-ele(8)
   move ' 3011015 Nuova Dist.Vers.cccccc    ' & x'00' to mn-ele(9)

   move ' Demo Buttons '    to mn-mess(1)
   move ' Controllo dati ccccccccccc trimestrale ed elenco degli errori trovati          ' to mn-mess(2)
   move ' Stampa della distinta versamenti x trimestre                                   ' to mn-mess(3)
   move ' Stampa dati anagrafici e fiscali degli agenti nuovi del trimestre.             ' to mn-mess(4)
   move ' Individua agenti comuni a + divisioni totalizzando le tratt.fino al trimestre. ' to mn-mess(5)
   move ' Sit.ENASARCO per agente nei vari trimestri e controllo minimali e massimali.   ' to mn-mess(6)
   move ' Calcolo del FONDO INDENNITA'' RISOLUZIONE RAPPORTO (sul singolo esercizio)     ' to mn-mess(7)
   move ' Calcolo INDENNITA'' SUPLETTIVA DI CLIENTELA (sul singolo esercizio).           ' to mn-mess(8)
   move ' Stampa della distinta versamenti ENASARCO (nuova versione - rifatta)           ' to mn-mess(9)
   CALL GC22MENU USING BY REFERENCE MENU-AREA
   Move Mn-Selected to wMn-Selected-MenuDrDn
   .
DropDownMenu2ex. exit.

DropDownMenu3.
   perform InitializeDropDownMenu thru InitializeDropDownMenuEx
   move '19003027 Menu Demo                 ' & x'00' to mn-ele(1)
   move ' 2004027 Inserisce nuovo Agente    ' & x'00' to mn-ele(2)
   move ' 2005027 Stampa Anagrafica Agenti  ' & x'00' to mn-ele(3)
   move ' 9006027 Elenco Movimenti          ' & x'00' to mn-ele(4)
   move ' 2007027 Registrazione Movimenti   ' & x'00' to mn-ele(5)
   move ' 3008027 Stampa Movimenti          ' & x'00' to mn-ele(6)
   move ' 2009027 Posizione agente          ' & x'00' to mn-ele(7)
   move ' 1010027 ------------------------- ' & x'00' to mn-ele(8)
   move ' 2011027 Ripresa provvigioni       ' & x'00' to mn-ele(9)
   move ' 2012027 Fatturazione agenti       ' & x'00' to mn-ele(10)
   move ' 4013027 Stampa modulo assunzione  ' & x'00' to mn-ele(11)
   move ' 5014027 Stampa modulo cessazione  ' & x'00' to mn-ele(12)
   move ' 3015027 Sit.agenti alfabetica     ' & x'00' to mn-ele(13)
   move ' 6016027 Sit.agenti per CDC        ' & x'00' to mn-ele(14)
   move ' 1017027 ------------------------- ' & x'00' to mn-ele(15)
   move ' 3018027 Movim.di solo ENASARCO    ' & x'00' to mn-ele(16)
   move ' Menu demo ... some options .....                                       '  to mn-mess(1)
   move ' Caricamento di una nuova anagrafica  agente                              '  to mn-mess(2)
   move ' Stampa delle anagrafiche agenti                                          '  to mn-mess(3)
   move ' Elenco movimenti agenti in ordine di numero registrazione.                ' to mn-mess(4)
   move ' Registrazione movimenti su scheda agente.                                 ' to mn-mess(5)
   move ' Stampa le registrazioni effettuate sulle posizioni degli agenti          ' to mn-mess(6)
   move ' Visualizza una scheda agente con i movimenti riepilogati per tipologia.   ' to mn-mess(7)
   move '                                                                          ' to mn-mess(8)
   move ' Ripresa dati provvigionali da floppy-disk generato da altre procedure     ' to mn-mess(9)
   move ' Stampa fatture effettive e/o fatture pro-forma da trasmettere agli agenti ' to mn-mess(10)
   move ' Stampa del modulo di Main attivita'' agente da trasmettere a ENASARCO  ' to mn-mess(11)
   move ' Stampa del modulo di cessazione attivita'' agente da trasmettere a ENASARCO' to mn-mess(12)
   move ' Stampa sit.agenti alfabetica con i movimenti totalizzati per tipologia    ' to mn-mess(13)
   move ' Stampa sit.agenti per centro di costo (cioe'' rete di vendita)              ' to mn-mess(14)
   move '                                                                           ' to mn-mess(15)
   move ' Registrazione movimenti di solo ENASARCO (senza imponibile).              ' to mn-mess(16)
   CALL GC22MENU USING BY REFERENCE MENU-AREA
   Move Mn-Selected to wMn-Selected-MenuDrDn
   .
DropDownMenu3ex. exit.

DropDownMenu4.
   perform InitializeDropDownMenu thru InitializeDropDownMenuEx
   move ' 2003041 1 Calendar Year           ' & x'00' to mn-ele(1)
   move ' 2004041 2 Calendar2               ' & x'00' to mn-ele(2)
   move '12005041 3 Calendar3  (one month)  ' & x'00' to mn-ele(3)
   move ' 2006041 Date Picker               ' & x'00' to mn-ele(4)
   move ' 2007041 e) option avalialble      ' & x'00' to mn-ele(5)
   move ' 2008041 f) option avalialble      ' & x'00' to mn-ele(6)
   move ' 2009041 g) option avalialble      ' & x'00' to mn-ele(7)
   move ' 2010041 h) option avalialble      ' & x'00' to mn-ele(8)
   move ' 2011041 i) option avalialble      ' & x'00' to mn-ele(9)
   move ' 2012041 j) option avalialble      ' & x'00' to mn-ele(10)

   move ' A one year Calendar. Scroll days/months/years and select a date               ' to mn-mess(1)
   move ' A one year Calendar. Just to display                                          ' to mn-mess(2)
   move ' A one month Calendar. Just to display                                         ' to mn-mess(3)
   move ' Display a one month calendar & let the User pick up a date                    ' to mn-mess(4)
   move ' available option e eeeee eeeeeeeeee eeeeeeee ee eeeeeeeeeeeeeeeeeeeeeeeeeeee  ' to mn-mess(5)
   move ' available option F FFFFFFFFFFFFFFFFFFFFFFFFFF FFFFFFFFFFFFF FFFF FFF          ' to mn-mess(6)
   move ' available option gggggggggggggggggggggggggggggggggg gggggggggggggggggggggggg  ' to mn-mess(7)
   move ' available option HHHHHHHHHHHHHHHH                 <<<<<                       ' to mn-mess(8)
   move ' available option iii iiii iiii iiiii iiiii iiii i i i i i i i i               '   to mn-mess(9)
   move ' available option J                                                            '   to mn-mess(10)
   CALL GC22MENU USING BY REFERENCE MENU-AREA
   Move Mn-Selected to wMn-Selected-MenuDrDn
   .
DropDownMenu4ex. exit.

DropDownMenu5.
   perform InitializeDropDownMenu thru InitializeDropDownMenuEx
   move '12003054 Dettagli Tabelle       ' & x'00'  to mn-ele(1)
   move ' 2004054 Testate  Tabelle       ' & x'00'  to mn-ele(2)
   move ' 2005054 Screen Saver           ' & x'00'  to mn-ele(3)
   move ' 2006054>Backup                 ' & x'00'  to mn-ele(4)
   move ' 2007054>Riorganizzazione       ' & x'00'  to mn-ele(5)
   move ' 2008054 1. Crea file ASCII TXT ' & x'00'  to mn-ele(6)
   move ' 2009054 2. Crea file ASCII TXT ' & x'00'  to mn-ele(7)
   move ' 2010054 3. Crea file ASCII TXT ' & x'00'  to mn-ele(8)
   move ' 2011054 Quadratura imponibili  ' & x'00'  to mn-ele(9)
   move ' 2012054ðStampa etichette       ' & x'00'  to mn-ele(10)

   move ' Gestione dettagli di una tabella  '     to mn-mess(1)
   move ' Gestione testate tabelle          '     to mn-mess(2)
   move ' a BIG CLOCK that move ramndomly on screen '     to mn-mess(3)
   move ' Salvataggio dati su floppy        '     to mn-mess(4)
   move ' Riorganizzazione e compressione degli archivi di dati.              '      to mn-mess(5)
   move ' Scarica dati trimestrali (ordine di Cod.Agente, x uso su dBASE, EXCEL, etc...)'        to mn-mess(6)
   move ' Scarica dati trimestrali (ordine di Cod.Fiscale, x uso su dBASE, EXCEL, etc...)'        to mn-mess(7)
   move ' Scarica dati trimestrali (ordine di Rag.Sociale, x uso su dBASE, EXCEL, etc...)'        to mn-mess(8)
   move ' Confronta saldo imponibili su file di sistema (ANSYS) con sommatoria movimenti '        to mn-mess(9)
   move ' Stampa delle etichette con gli indirizzi degli agenti                          '        to mn-mess(10)
   CALL GC22MENU USING BY REFERENCE MENU-AREA
   Move Mn-Selected to wMn-Selected-MenuDrDn
   .
DropDownMenu5ex. exit.

DropDownMenu6.
   perform InitializeDropDownMenu thru InitializeDropDownMenuEx
   move '12003066 Help        ' & x'00' to mn-ele(1)
   move ' 2004066 Print help  ' & x'00' to mn-ele(2)
   move ' 2005066 DOS         ' & x'00' to mn-ele(3)
   move ' 2006066 About       ' & x'00' to mn-ele(4)
   move ' 2007066 End of work ' & x'00' to mn-ele(5)
   move ' Display the documentation manual' to mn-mess(1)
   move ' Print a manual    ' to mn-mess(2)
   move ' Temporary exit to DOS (type ''EXIT'' to return this menu).' to mn-mess(3)
   move ' About this application                ' to mn-mess(4)
   move ' Exit                           ' to mn-mess(5)
   CALL GC22MENU USING BY REFERENCE MENU-AREA
   Move Mn-Selected to wMn-Selected-MenuDrDn
   .
DropDownMenu6ex. exit.

InitializeDropDownMenu.
   Initialize menu-area ALL TO VALUE
   move low-value to mn-tab

   move 'V' to Mn-Arrow  *> user can use only vertical cursors (Up or Down) movement
   move 'Y' to Mn-Return *> return to caller if used horizontal cursor movements  (Left or Right)
   move 'Y' to Mn-Box
   move 'Y' to Mn-Box-Shadow
   move 'S' to Mn-Box-style
   move black to Mn-Box-fco
   move 'N'   to Mn-Box-fcoH
  *>  move 'N' to Mn-Box-Fill
   .
InitializeDropDownMenuEx. exit.

*> ****************************************************************************
Display-Cover.
*> move red to Box-bco
set  Box-fco Box-bco to Red
move '002001024080' to Box-rc
move 'N'      to Box-style Box-3D
call GC01BOX using BOX-AREA.

display rGnu2(1) at 010001 with background-color Red foreground-color White highlight
display rGnu2(2) at 011001 with background-color Red foreground-color White highlight
display rGnu2(3) at 012001 with background-color Red foreground-color White highlight
display rGnu2(4) at 013001 with background-color Red foreground-color White highlight
display rGnu2(5) at 014001 with background-color Red foreground-color White highlight
display rGnu2(6) at 015001 with background-color Red foreground-color White highlight

 DISPLAY "GnuCOBOL 2.0 TEXT USER INTERFACE TOOLS COLLECTION " AT 017016
         with foreground-color white background-color red.

 ACCEPT wUserName FROM USER NAME end-accept.
 STRING " User: " wUserName into wSTRING.
 DISPLAY wSTRING AT 002001 with foreground-color white background-color red.
 ACCEPT wLINES   from LINES; ACCEPT wCOLUMNS from COLUMNS
 STRING " Screen of " wLINES " x " wCOLUMNS  " - Press a key to Enter, ESCAPE to EXIT. " into wSTRING.
 DISPLAY wSTRING AT 023001 with foreground-color white background-color red.
Display-CoverEx. Exit.

*> ****************************************************************************
DisplayBackground.
  set  Box-bco to green
  set  Box-fco to white
  move '002001024080' to Box-rc
  move 'D'      to Box-style
  move 'N'      to Box-3D
  call  GC01BOX using BOX-AREA.
  display "[" & X"FE" & "]" at 002076 with background-color green foreground-color white highlight.
DisplayBackgroundEx. Exit.


About.
set  Box-bco        to white
set  Box-fco        to white
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

*> Move '37YSabcdefghiYYRNN37YYYN77Y' to Bxm-Parameters
*> move '004005021073'                to Bxm-rc

    Move '37YSabcdefghiYYRNN37YYYYNN77Y' to Bxm-Parameters
    move '004005021073'                  to Bxm-rc


call GC02BOXMEX using BOXMEX-AREA.
AboutEx. Exit.

End Program GC22MENUDEMO2.
