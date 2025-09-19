       >>SOURCE FREE
REPLACE ==:BC== BY ==BACKGROUND-COLOR==  ==:FC== BY ==FOREGROUND-COLOR==.
ID DIVISION.
PROGRAM-ID. GC99SCREENPAINTER.
*> ***********************************************************************************
*> GnuCOBOL TT (TUI TOOLS) COLLECTION
*> Purpose:    SCREEN PAINTER
*> Tectonics:  cobc -x GC99SCREENPAINTER.COB -lpdcurses (compile with GnuCOBOL 3.2 or greater)
*> Usage:      GC99SCREENPAINTER
*> Parameters: none
*> Author:     Eugenio Di Lorenzo - Italia (DILO) - eugenio.dilo@gmail.com
*> License:    (c)2025 E.Di Lorenzo - GNU Lesser General Public License, LGPL, 3.0 (or greater)
*> Version:    1.0 2025.02.01
*> Changelog:  1.0 first release.
*> ***********************************************************************************
*> This program allows you to draw a 25x80 screen layout based on your needs, by setting
*> constants, variable alphanumeric or numeric fields and back/foreground colors.
*> Upon user request it saves the screen layout to a TXT file of 25 records where each record
*> contains an entire 80 chars screen line with back and foreground color codes.
*> Upon user request this program, from the TXT file:
*> - automatically generates the copy for the SCREEN SECTION and for WORKING-STORAGE SECTION
*>   the color of a string (of spaces, constants or variables) is taken from its 1st character
*> - automatically generates, compile and execute a simple GnuCOBOL program to test the new SCREEN
*>   (you need the GnuCOBOL 3.2 or greater compiler available)
*> Note: at the moment a screen of 25 rows and 80 columns is supported.
*>
*> This GnuCOBOL source file contains 4 programs.
*> GC99SCREENPAINTER: to draw your screen layout, save layout on a TXT file, run other programs
*> GC99SCREENCOPY:    to create a SCREEN SECTION and a WORKING-STORAGE SECTION copy file .CPY
*> GC99SCREENTEST:    to create, compile and execute a test GnuCOBOL program .COB
*> GC99RAIN:          rain effect, just for aesthetics
*> ***********************************************************************************
ENVIRONMENT DIVISION.
INPUT-OUTPUT SECTION.
FILE-CONTROL.
   select ScreenFILE
          assign       to ScreenFILE-FSPEC
          organization is line sequential
          file status  is ScreenFILE-FS.

DATA DIVISION.
FILE SECTION.
FD ScreenFILE label records are standard.
01 FD-ScreenFILE.
   03 FD-ScreenFILE-NUM   pic 9(003).
   03 FD-ScreenFILE-S     pic x(001).
   03 FD-ScreenFILE-CHARS pic x(081).
   03 FD-ScreenFILE-ATTRS pic x(480).

WORKING-STORAGE SECTION.
01 Black      constant 00. 01 Blue       constant 01. 01 Green      constant 02. 01 Cyan       constant 03.
01 Red        constant 04. 01 Magenta    constant 05. 01 Brown      constant 06. 01 LightGrey  constant 07.
01 DarkGrey   constant 08. 01 LightBlue  constant 09. 01 LightGreen constant 10. 01 LightCyan  constant 11.
01 LightRed   constant 12. 01 Pink       constant 13. 01 Yellow     constant 14. 01 White      constant 15.
78 K-ENTER     VALUE 0000. 78 K-ESCAPE    VALUE 2005. 78 K-UP        VALUE 2003. 78 K-DOWN      VALUE 2004.
78 K-LEFT      VALUE 2009. 78 K-RIGHT     VALUE 2010. 78 K-TIMEOUT   VALUE 8001.
78 K-F1        VALUE 1001. 78 K-F2        VALUE 1002. 78 K-F3        VALUE 1003. 78 K-F4        VALUE 1004.
78 K-F5        VALUE 1005. 78 K-F6        VALUE 1006. 78 K-F7        VALUE 1007. 78 K-F8        VALUE 1008.
78 K-F9        VALUE 1009. 78 K-F10       VALUE 1010. 78 K-F11       VALUE 1011. 78 K-F12       VALUE 1012.

78  K-LEFT-PRESSED    VALUE  2041.
78  K-LEFT-DBL-CLICK  VALUE  2043.
78  K-MID-PRESSED     VALUE  2044.
78  K-MID-DBL-CLICK   VALUE  2046.
78  K-RIGHT-PRESSED   VALUE  2047.
78  K-RIGHT-DBL-CLICK VALUE  2049.

78 COB-AUTO-MOUSE-HANDLING VALUE   1. 78 COB-ALLOW-LEFT-DOWN   VALUE    2. 78 COB-ALLOW-LEFT-UP   VALUE   4.
78 COB-ALLOW-LEFT-DOUBLE   VALUE   8. 78 COB-ALLOW-MIDDLE-DOWN VALUE   16. 78 COB-ALLOW-MIDDLE-UP VALUE  32.
78 COB-ALLOW-MIDDLE-DOUBLE VALUE  64. 78 COB-ALLOW-RIGHT-DOWN  VALUE  128. 78 COB-ALLOW-RIGHT-UP  VALUE 256.
78 COB-ALLOW-RIGHT-DOUBLE  VALUE 512. 78 COB-ALLOW-MOUSE-MOVE  VALUE 1024.
01 COB-MOUSE-FLAGS         PIC 9(04).

01 ScreenPainter-Area.
   03 FilespecTXT         pic x(60) value space.
   03 FileSpecCPY         pic x(60) value space.
   03 FileSpecCPW         pic x(60) value space.
   03 wScreenWidth.
      05 wScreenWidth9    pic 999.
   03 wNumScreenRow       pic 9(03) value zero.
   03 wNumSourceRowCPY    pic 9(03) value zero.
   03 wNumSourceRowCPW    pic 9(03) value zero.

01 FilespecTXT2           pic x(60) value space.

01 ScreenTest-Area.
   03 tFileSpecCPY         pic x(60) value ' '. *> CPY filename with screen section copy source
   03 tFileSpecCPW         pic x(60) value ' '. *> CPY filename with working-storage copy source
   03 tFileSpecCOB         pic x(60) value ' '. *> COB filename with cobol source to test the screen

01 wWidth            pic 9(03) value 080.
01 wAnswer           pic x(01) value space.
01 wCommandClicked   pic 9(4) value 0.
01 wKeyPressed    pic 9(4) IS SPECIAL-NAMES CRT STATUS.
01 wCursorRowCol           IS SPECIAL-NAMES CURSOR.
    05 wCursorRow pic 9(03).
    05 wCursorCol pic 9(03).
01 ScreenFILE-FS    PIC XX.
01 ScreenFILE-FSPEC PIC X(30) VALUE 'SCREEN-101.TXT'.
01 wLine          PIC 999 VALUE  0.
01 wLpopup        PIC 999 VALUE  3. *> popupmenu window start line
01 wCpopup        PIC 999 VALUE 15. *> popupmenu window start col
01 wLcolors       PIC 999 VALUE  5.
01 wCcolors       PIC 999 VALUE 11.
01 wLmessage      pic 999 value 14. *> messages window start line
01 wCmessage      pic 999 value 39. *> messages window start col
01 wLmessageGen   pic 999 value 14. *> copy generated message window start line
01 wCmessageGen   pic 999 value 23. *> copy generated message window start col
01 wLhelp         pic 999 value  2. *> help window start line
01 wChelp         pic 999 value 15. *> help window start col
01 wL             pic 999 value  0. *> screen line coordinate
01 wC             pic 999 value  0. *> screen col coordinate
01 wLc            pic 999 value  0. *> screen line for cover
01 wLinDT         pic 999 value  0. *> Line for Date-Time
01 wColDT         pic 999 value  0. *> Col  for Date-Time
01 wRULER         PIC X(80) VALUE '....+....1....+....2....+....3....+....4....+....5....+....6....+....7....+....8'.
01 wBCm           pic 99 value cyan.       *> messages and cover background color
01 wFCm           pic 99 value white.      *> messages and cover foreground color
01 wBCc           pic 99 value cyan.       *> colors subscreen - background color
01 wFCc           pic 99 value white.      *> colors subscreen - foreground color
01 wBCsample           pic 99 value black.      *> colors subscreen - & sample background color
01 wFCsample           pic 99 value black.      *> colors subscreen - & sample foreground color
01 wBCa           pic 99 value Black.      *> ACCEPT background color
01 wFCa           pic 99 value Cyan.       *> ACCEPT foreground color
01 wDay           pic 9(08).
01 wTime          pic 9(08).
01 wDateTime      pic x(20).
01 wScreenName    PIC X(256)  value "GC99SCREENPAINTER.TMP" & x"00".
01 wScrOk         BINARY-LONG value zero.
01 wMESSAGE       pic x(80) value " ** Screen NOT SAVED **".
01 wFlagNewColor  pic 9    value zero.
01 wRETURN-CODE   pic 9(9) value zero.
01 wSCREEN.
   03 wSCR-LINE-CHARS occurs 25.
      07 wSCR-CHAR     pic  X occurs 81 value space.
   03 wSCR-LINE-ATTRS occurs 25.
      07 wSCR-BGCOL    pic 99 occurs 80 value 02. *> default BG color is Green
      07 wSCR-FGCOL    pic 99 occurs 80 value 15. *> default FG color is White
      07 wSCR-HIGH     pic  9 occurs 80 value 0.
      07 wSCR-REVERSE  pic  9 occurs 80 value 0.

01 wSCR-CHAR-MEM          PIC X VALUE SPACE.
01 wSCR-BGCOL-MEM         pic 99 value zero.
01 wSCR-FGCOL-MEM         pic 99 value zero.

01 wNewColor-B        PIC XX     value '00'.
01 wNewColor-F        PIC XX     value '00'.
01 wSample1           pic x(051) value ' xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx '.
01 wSample2           pic x(051) value ' xx   GnuCOBOL Screen Painter - actual colors   xx '.
01 wSample3           pic x(051) value ' xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx '.
01 wDummy             PIC X(001) VALUE SPACE.
01 wSwitchColorAccept pic x(020) value space.
01 wSysCommand        pic x(200) value space.
01 wFile-info.
  05 File-Size-In-Bytes PIC 9(18) COMP.
  05 Mod-DD   PIC 9(2) COMP. *> Modification Date
  05 Mod-MO   PIC 9(2) COMP.
  05 Mod-YYYY PIC 9(4) COMP.
  05 Mod-HH   PIC 9(2) COMP. *> Modification Time
  05 Mod-MM   PIC 9(2) COMP.
  05 Mod-SS   PIC 9(2) COMP.
  05 FILLER   PIC 9(2) COMP. *> Always 00

01 eFile-info.
  05 File-Size-In-Bytes PIC 9(18).
  05 Mod-DD   PIC 9(2) . *> Modification Date
  05 Mod-MO   PIC 9(2) .
  05 Mod-YYYY PIC 9(4) .
  05 Mod-HH   PIC 9(2) . *> Modification Time
  05 Mod-MM   PIC 9(2) .
  05 Mod-SS   PIC 9(2) .
  05 FILLER   PIC 9(2) . *> Always 00

PROCEDURE DIVISION.

  Perform AcceptParameters thru AcceptParameters-Ex

  *> CALL STATIC 'raw_output' USING 1  *> to enable display of ASCII symbols from x"00" to x"1F"
  set environment 'COB_SCREEN_EXCEPTIONS' TO 'Y'
  set environment 'COB_SCREEN_ESC'        TO 'Y'
  set environment 'COB_LEGACY'            TO '1' *> use also color codes from 8 to 15
  set environment 'COB_TIMEOUT_SCALE'     TO '1' *> timeout 1 means 100 millisec
  COMPUTE COB-MOUSE-FLAGS = COB-AUTO-MOUSE-HANDLING  *> make mouse active,
          + COB-ALLOW-LEFT-DOWN   + COB-ALLOW-MIDDLE-DOWN   + COB-ALLOW-RIGHT-DOWN
       *> + COB-ALLOW-LEFT-UP     + COB-ALLOW-MIDDLE-UP     + COB-ALLOW-RIGHT-UP      *> UP events must not be active
          + COB-ALLOW-LEFT-DOUBLE + COB-ALLOW-MIDDLE-DOUBLE + COB-ALLOW-RIGHT-DOUBLE
       *> + COB-ALLOW-MOUSE-MOVE
  SET environment "COB_MOUSE_FLAGS" to COB-MOUSE-FLAGS

  display ' ' with blank screen :BC wBCm :FC wFCm *> activate extended screenio (load pdcurses library)
  call static 'raw'   *> pdcurses function to disable F11 that set fullscreen mode in windows cmd console mode

  set environment 'COB_HIDE_CURSOR'    TO 'TRUE'
  perform DisplayCoverScreen thru DisplayCoverScreenEx
  accept omitted *> continue after 1 seconds
  call "GC99RAIN" end-call
  set environment 'COB_HIDE_CURSOR'    TO 'FALSE'

  perform Load-From-File thru Load-From-FileEx     *> load screen layout from file if exist
  perform varying wL from 1 by 1 until wL > 25     *> display screen layout from file to screen
    perform varying wC from 1 by 1 until wC > 80
      display wSCR-CHAR(wL wC) line wL col wC :BC wSCR-BGCOL(wL wC) :FC wSCR-FGCOL(wL wC)
    end-perform
  end-perform

  *> set all '0' to column 81
  perform varying wL from 1 by 1 until wL > 25
      move '0' to wSCR-CHAR(wL 81)
  end-perform

  MOVE 1 TO wL wC
  continue.

AcceptChar.
    if wFlagNewColor = 1  *> if colors are changed
       move wNewColor-B to wSCR-BGCOL(wL wC)
       move wNewColor-F to wSCR-FGCOL(wL wC)
    end-if

    ACCEPT wSCR-CHAR(wL wC) at line wL col wC :BC wSCR-BGCOL(wL wC) :FC wSCR-FGCOL(wL wC) update auto
    evaluate TRUE
      when wKeyPressed = K-UP
            IF wL =  1 compute wL = 25 else compute wL = wL - 1 end-if
      when wKeyPressed = K-DOWN
            IF wL = 25 compute wL =  1 else compute wL = wL + 1 end-if
      when wKeyPressed = K-RIGHT or K-ENTER
            compute wC = wC + 1
            if wC > 80 move 1 to wC compute wL = wL + 1 end-if
            IF wL > 25 move 1 to wL end-if
      when wKeyPressed = K-LEFT
            compute wC = wC - 1
            if wC < 1 move 80 to wC compute wL = wL - 1 end-if
            IF wL < 1 move 25 to wL                     end-if
      when wKeyPressed = K-F1
            perform DisplayHelpScreen thru DisplayHelpScreenEx
      when wKeyPressed = K-F2
            perform DisplayPopupMenu thru DisplayPopupMenuEx
      when wKeyPressed = K-F3
            perform ChangeColors thru ChangeColorsEx
      when wKeyPressed = K-F4
            perform Dump-To-File thru Dump-To-FileEx
      when wKeyPressed = K-F5
            perform ScreenSectionCopyGenerate thru ScreenSectionCopyGenerateEx
      when wKeyPressed = K-F6
            perform ScreenSectionCopyTest thru ScreenSectionCopyTestEx
      when wKeyPressed = K-F7
            perform ColorsCopy thru ColorsCopyEx
      when wKeyPressed = K-F8
            perform ColorsPaste thru ColorsPasteEx
      when wKeyPressed = K-F10
            perform DisplayHorizontalRuler thru DisplayHorizontalRulerEx
      when wKeyPressed = K-F11
            perform DisplayVerticalRuler thru DisplayVerticalRulerEx
      when wKeyPressed = K-F12
            perform DisplayAboutScreen thru DisplayAboutScreenEx
      when wKeyPressed = K-LEFT-PRESSED *> set cursor position
            move wCursorRow to wL
            move wCursorCol to wC
      when wKeyPressed = K-RIGHT-PRESSED
            perform DisplayPopupMenu thru DisplayPopupMenuEx
      when wKeyPressed = K-MID-PRESSED
            perform DisplayPopupMenuEdit thru DisplayPopupMenuEditEx
      when wKeyPressed = K-ESCAPE
            display ' ' line 1 col 1 with erase screen
            move space TO wMESSAGE
            go to end-of-job
      when other
            continue
    end-evaluate

    go to AcceptChar.

end-of-job.
  perform varying wL from 1 by 1 until wL > 25    *> re-display characters on screen
     perform varying wC from 1 by 1 until wC > 80
       display wSCR-CHAR(wL wC) line wL col wC :BC wSCR-BGCOL(wL wC) :FC wSCR-FGCOL(wL wC)
     end-perform
  end-perform
  call "GC99RAIN" end-call

  display wMESSAGE                                          at 0201 :BC black :FC wFCm
  display ' ** GnuCOBOL TUI-TOOLS SCREEN PAINTER - end-of-job **' at 0301 :BC black :FC wFCm
  stop run with normal status.

*> ********************************************************
*>          P R O G R A M   R O U T I N E S
*> ********************************************************
Load-From-File.
  move FilespecTXT to ScreenFILE-FSPEC
  open input ScreenFILE
  if ScreenFILE-FS = '35' go to Load-From-FileEx end-if *> 35 = file not found
  perform varying wLINE from 1 by 1 until wLINE > 25
       read ScreenFILE
       move FD-ScreenFILE-CHARS to wSCR-LINE-CHARS(wLINE)
       move FD-ScreenFILE-ATTRS to wSCR-LINE-ATTRS(wLINE)
  end-perform
  close ScreenFILE.
Load-From-FileEx. exit.

Dump-To-File.
  open output ScreenFILE
  perform varying wLINE from 1 by 1 until wLINE > 25
        move wLINE       to FD-ScreenFILE-NUM
        move space       to FD-ScreenFILE-S
        move wSCR-LINE-CHARS(wLINE) to FD-ScreenFILE-CHARS
        move wSCR-LINE-ATTRS(wLINE) to FD-ScreenFILE-ATTRS
        write FD-ScreenFILE
  end-perform
  close ScreenFILE
  move " ** Screen SAVED **" TO wMESSAGE
  call "CBL_GC_SCR_DUMP" using by reference wScreenName returning wScrOk end-call
  move wLmessage to wLinDT
  compute wColDT = wCmessage + 18
  display "                                       "                      at line wLmessage     col wCmessage :BC wBCm :FC wFCm
  display "                                       "                      at line wLmessage + 1 col wCmessage :BC wBCm :FC wFCm
  display function concat(" Screen saved on file " FilespecTXT(1:15) "  ") at line wLmessage + 2 col wCmessage :BC wBCm :FC wFCm
  display "                                       "                      at line wLmessage + 3 col wCmessage :BC wBCm :FC wFCm
  display "                                       "                      at line wLmessage + 4 col wCmessage :BC wBCm :FC wFCm
  display "                                       "                      at line wLmessage + 5 col wCmessage :BC wBCm :FC wFCm
  perform with test after until wKeyPressed <> K-TIMEOUT
          accept omitted timeout 1
              on exception perform DisplayDateTime thru DisplayDateTimeEx
  end-perform

  call "CBL_GC_SCR_RESTORE" using by reference wScreenName returning wScrOk end-call
  CALL "CBL_DELETE_FILE" USING wScreenName
  continue.
Dump-To-FileEx. exit.

DisplayPopupMenu.
   call "CBL_GC_SCR_DUMP" using by reference wScreenName returning wScrOk end-call
   set environment 'COB_HIDE_CURSOR'    TO 'TRUE'
   display '                                                   ' at Line wLpopup      col wCpopup :BC wBCm :FC wFCm
   display '         * GnuCOBOL SCREEN PAINTER MENU *          ' at Line wLpopup +  1 col wCpopup :BC wBCm :FC wFCm
   display '                                                   ' at Line wLpopup +  2 col wCpopup :BC wBCm :FC wFCm
   display ' Display help screen                          (F1) ' at Line wLpopup +  3 col wCpopup :BC wBCm :FC wFCm
   display ' Change back/foreground colors                (F3) ' at Line wLpopup +  4 col wCpopup :BC wBCm :FC wFCm
   display ' Save the screen layout to disk               (F4) ' at Line wLpopup +  5 col wCpopup :BC wBCm :FC wFCm
   display ' Generate SCREEN SECTION (and W-S) copy       (F5) ' at Line wLpopup +  6 col wCpopup :BC wBCm :FC wFCm
   display ' Test your Screen                             (F6) ' at Line wLpopup +  7 col wCpopup :BC wBCm :FC wFCm
   display '                                                   ' at Line wLpopup +  8 col wCpopup :BC wBCm :FC wFCm
   display ' Copy FG/BG colors at cursor position         (F7) ' at Line wLpopup +  9 col wCpopup :BC wBCm :FC wFCm
   display ' Paste FG/BG colors at cursor position        (F8) ' at Line wLpopup + 10 col wCpopup :BC wBCm :FC wFCm
   display ' Settings (*)                                 (F9) ' at Line wLpopup + 11 col wCpopup :BC wBCm :FC wFCm
   display ' Display horizontal ruler at cursor position (F10) ' at Line wLpopup + 12 col wCpopup :BC wBCm :FC wFCm
   display ' Display vertical ruler at cursor position   (F11) ' at Line wLpopup + 13 col wCpopup :BC wBCm :FC wFCm
   display ' Display the ''About'' screen                  (F12) ' at Line wLpopup + 14 col wCpopup :BC wBCm :FC wFCm
   display ' Exit program                                (ESC) ' at Line wLpopup + 15 col wCpopup :BC wBCm :FC wFCm
   display '                                                   ' at Line wLpopup + 16 col wCpopup :BC wBCm :FC wFCm
   display ' left-click to select an item                      ' at Line wLpopup + 17 col wCpopup :BC wBCm :FC wFCm
   display function concat(' Screen layout filename: ' FilespecTXT(1:15) '           ') at line wLpopup + 18 col wCpopup :BC wBCm :FC wFCm
   display ' (*) = not yet available                           ' at Line wLpopup + 19 col wCpopup :BC wBCm :FC wFCm
   display '                                                   ' at Line wLpopup + 20 col wCpopup :BC wBCm :FC wFCm

   accept wDummy at line 05 col wCpopup :BC wBCm :FC wFCm auto
   evaluate TRUE
     when (wKeyPressed = K-LEFT-PRESSED) and (wCursorCol >= wCpopup and <= wCpopup + 50) and wCursorRow = wLpopup +  3
          display 'Display help screen                          (F1)' at Line wLpopup +  3 col wCpopup + 1 :BC wBCm :FC wFCm REVERSE
          continue after 1 seconds
          call "CBL_GC_SCR_RESTORE" using by reference wScreenName returning wScrOk end-call
          CALL "CBL_DELETE_FILE" USING wScreenName
          perform DisplayHelpScreen thru DisplayHelpScreenEx
     when (wKeyPressed = K-LEFT-PRESSED) and (wCursorCol >= wCpopup and <= wCpopup + 50) and wCursorRow = wLpopup +  4
          display 'Change back/foreground colors                (F3)' at Line wLpopup +  4 col wCpopup + 1 :BC wBCm :FC wFCm REVERSE
          continue after 1 seconds
          call "CBL_GC_SCR_RESTORE" using by reference wScreenName returning wScrOk end-call
          CALL "CBL_DELETE_FILE" USING wScreenName
          set environment 'COB_HIDE_CURSOR'    TO 'FALSE'
          perform ChangeColors thru ChangeColorsEx
      when (wKeyPressed = K-LEFT-PRESSED) and (wCursorCol >= wCpopup and <= wCpopup + 50) and wCursorRow = wLpopup +  5
          display 'Save the screen layout to disk               (F4)' at Line wLpopup +  5 col wCpopup + 1 :BC wBCm :FC wFCm REVERSE
          continue after 1 seconds
          call "CBL_GC_SCR_RESTORE" using by reference wScreenName returning wScrOk end-call
          CALL "CBL_DELETE_FILE" USING wScreenName
          perform Dump-To-File thru Dump-To-FileEx
     when (wKeyPressed = K-LEFT-PRESSED) and (wCursorCol >= wCpopup and <= wCpopup + 50) and wCursorRow = wLpopup +  6
          display 'Generate SCREEN SECTION (and W-S) copy       (F5)' at Line wLpopup +  6 col wCpopup + 1 :BC wBCm :FC wFCm REVERSE
          continue after 1 seconds
          call "CBL_GC_SCR_RESTORE" using by reference wScreenName returning wScrOk end-call
          CALL "CBL_DELETE_FILE" USING wScreenName
          perform ScreenSectionCopyGenerate thru ScreenSectionCopyGenerateEx
     when (wKeyPressed = K-LEFT-PRESSED) and (wCursorCol >= wCpopup and <= wCpopup + 50) and wCursorRow = wLpopup +  7
          display 'Test your Screen                             (F6)' at Line wLpopup +  7 col wCpopup + 1 :BC wBCm :FC wFCm REVERSE
          continue after 1 seconds
          call "CBL_GC_SCR_RESTORE" using by reference wScreenName returning wScrOk end-call
          CALL "CBL_DELETE_FILE" USING wScreenName
          set environment 'COB_HIDE_CURSOR'    TO 'FALSE'
          perform ScreenSectionCopyTest thru ScreenSectionCopyTestEx
     when (wKeyPressed = K-LEFT-PRESSED) and (wCursorCol >= wCpopup and <= wCpopup + 50) and wCursorRow = wLpopup +  8
          display '                                                 ' at Line wLpopup +  8 col wCpopup + 1 :BC wBCm :FC wFCm REVERSE
          continue after 1 seconds
          call "CBL_GC_SCR_RESTORE" using by reference wScreenName returning wScrOk end-call
          CALL "CBL_DELETE_FILE" USING wScreenName
          perform NotAvailable thru NotAvailableEx
     when (wKeyPressed = K-LEFT-PRESSED) and (wCursorCol >= wCpopup and <= wCpopup + 50) and wCursorRow = wLpopup +  9
          display 'Copy FG/BG colors at cursor position         (F7)' at Line wLpopup +  9 col wCpopup + 1 :BC wBCm :FC wFCm REVERSE
          continue after 1 seconds
          call "CBL_GC_SCR_RESTORE" using by reference wScreenName returning wScrOk end-call
          CALL "CBL_DELETE_FILE" USING wScreenName
          perform ColorsCopy thru ColorsCopyEx
     when (wKeyPressed = K-LEFT-PRESSED) and (wCursorCol >= wCpopup and <= wCpopup + 50) and wCursorRow = wLpopup + 10
          display 'Paste FG/BG colors at cursor position        (F8)' at Line wLpopup + 10 col wCpopup + 1 :BC wBCm :FC wFCm REVERSE
          continue after 1 seconds
          call "CBL_GC_SCR_RESTORE" using by reference wScreenName returning wScrOk end-call
          CALL "CBL_DELETE_FILE" USING wScreenName
          perform ColorsPaste thru ColorsPasteEx
     when (wKeyPressed = K-LEFT-PRESSED) and (wCursorCol >= wCpopup and <= wCpopup + 50) and wCursorRow = wLpopup + 11
          display 'Settings (*)                                 (F9)' at Line wLpopup + 11 col wCpopup + 1 :BC wBCm :FC wFCm REVERSE
          continue after 1 seconds
          call "CBL_GC_SCR_RESTORE" using by reference wScreenName returning wScrOk end-call
          CALL "CBL_DELETE_FILE" USING wScreenName
          perform NotAvailable thru NotAvailableEx
     when (wKeyPressed = K-LEFT-PRESSED) and (wCursorCol >= wCpopup and <= wCpopup + 50) and wCursorRow = wLpopup + 12
          display 'Display horizontal ruler at cursor position (F10)' at Line wLpopup + 12 col wCpopup + 1 :BC wBCm :FC wFCm REVERSE
          continue after 1 seconds
          call "CBL_GC_SCR_RESTORE" using by reference wScreenName returning wScrOk end-call
          CALL "CBL_DELETE_FILE" USING wScreenName
          perform DisplayHorizontalRuler thru DisplayHorizontalRulerEx
     when (wKeyPressed = K-LEFT-PRESSED) and (wCursorCol >= wCpopup and <= wCpopup + 50) and wCursorRow = wLpopup + 13
          display 'Display vertical ruler at cursor position   (F11)' at Line wLpopup + 13 col wCpopup + 1 :BC wBCm :FC wFCm REVERSE
          continue after 1 seconds
          call "CBL_GC_SCR_RESTORE" using by reference wScreenName returning wScrOk end-call
          CALL "CBL_DELETE_FILE" USING wScreenName
          perform DisplayVerticalRuler thru DisplayVerticalRulerEx
     when (wKeyPressed = K-LEFT-PRESSED) and (wCursorCol >= wCpopup and <= wCpopup + 50) and wCursorRow = wLpopup + 14
          display 'Display the ''About'' screen                  (F12)' at Line wLpopup + 14 col wCpopup + 1 :BC wBCm :FC wFCm REVERSE
          continue after 1 seconds
          call "CBL_GC_SCR_RESTORE" using by reference wScreenName returning wScrOk end-call
          CALL "CBL_DELETE_FILE" USING wScreenName
          perform DisplayAboutScreen thru DisplayAboutScreenEx
     when (wKeyPressed = K-LEFT-PRESSED) and (wCursorCol >= wCpopup and <= wCpopup + 50) and wCursorRow = wLpopup + 15
          display 'Exit program                                (ESC)' at Line wLpopup + 15 col wCpopup + 1 :BC wBCm :FC wFCm REVERSE
          continue after 1 seconds
          call "CBL_GC_SCR_RESTORE" using by reference wScreenName returning wScrOk end-call
          CALL "CBL_DELETE_FILE" USING wScreenName
          go to end-of-job
     when other
          call "CBL_GC_SCR_RESTORE" using by reference wScreenName returning wScrOk end-call
          CALL "CBL_DELETE_FILE" USING wScreenName
          continue
   end-evaluate
   set environment 'COB_HIDE_CURSOR'    TO 'FALSE'
   continue.
DisplayPopupMenuEx. exit.

DisplayPopupMenuEdit.
   call "CBL_GC_SCR_DUMP" using by reference wScreenName returning wScrOk end-call
   set environment 'COB_HIDE_CURSOR'    TO 'TRUE'
   display '                                                   ' at Line wLpopup      col wCpopup :BC wBCm :FC wFCm
   display '      * GnuCOBOL SCREEN PAINTER EDIT MENU *        ' at Line wLpopup +  1 col wCpopup :BC wBCm :FC wFCm
   display '  (functions on this menu are not yet available)   ' at Line wLpopup +  2 col wCpopup :BC wBCm :FC wFCm
   display ' Copy a Screen Row at cursor position              ' at Line wLpopup +  3 col wCpopup :BC wBCm :FC wFCm
   display ' Paste a Screen row at cursor position             ' at Line wLpopup +  4 col wCpopup :BC wBCm :FC wFCm
   display ' Undo last Paste Screen Row                        ' at Line wLpopup +  5 col wCpopup :BC wBCm :FC wFCm
   display ' (left-click on one of previous item)              ' at Line wLpopup +  6 col wCpopup :BC wBCm :FC wFCm
   display '                                                   ' at Line wLpopup +  7 col wCpopup :BC wBCm :FC wFCm
   display '             BOX GRAPHIC SYMBOLS                   ' at Line wLpopup +  8 col wCpopup :BC wBCm :FC wFCm
   display '                                                   ' at Line wLpopup +  9 col wCpopup :BC wBCm :FC wFCm
   display '     ' & x'DA' & '   ' & x'C4' & '   ' & x'C2' & '   ' & x'BF' & '             ' & x'C9' & '   ' & x'CD' & '   ' & x'CB' & '   ' & x'BB' & '       ' at Line wLpopup + 10 col wCpopup :BC wBCm :FC wFCm
   display '                                                   ' at Line wLpopup + 11 col wCpopup :BC wBCm :FC wFCm
   display '     ' & x'B3' & '   ' & x'20' & '   ' & x'B3' & '   ' & x'B3' & '             ' & x'BA' & '   ' & x'20' & '   ' & x'BA' & '   ' & x'BA' & '       ' at Line wLpopup + 12 col wCpopup :BC wBCm :FC wFCm
   display '                                                   ' at Line wLpopup + 13 col wCpopup :BC wBCm :FC wFCm
   display '     ' & x'C3' & '   ' & x'C4' & '   ' & x'C5' & '   ' & x'B4' & '             ' & x'CC' & '   ' & x'CD' & '   ' & x'CE' & '   ' & x'B9' & '       ' at Line wLpopup + 14 col wCpopup :BC wBCm :FC wFCm
   display '                                                   ' at Line wLpopup + 15 col wCpopup :BC wBCm :FC wFCm
   display '     ' & x'C0' & '   ' & x'C4' & '   ' & x'C1' & '   ' & x'D9' & '             ' & x'C8' & '   ' & x'CD' & '   ' & x'CA' & '   ' & x'BC' & '       ' at Line wLpopup + 16 col wCpopup :BC wBCm :FC wFCm
   display '                                                   ' at Line wLpopup + 17 col wCpopup :BC wBCm :FC wFCm
   display ' (left-double-click on a symbol to copy and exit)  ' at Line wLpopup + 18 col wCpopup :BC wBCm :FC wFCm
   display ' (left-double-click on the screen layout to paste) ' at line wLpopup + 19 col wCpopup :BC wBCm :FC wFCm
   display '                                                   ' at Line wLpopup + 20 col wCpopup :BC wBCm :FC wFCm

   accept wDummy at line 05 col wCpopup :BC wBCm :FC wFCm auto
   evaluate TRUE
     when (wKeyPressed = K-LEFT-PRESSED) and (wCursorCol >= wCpopup and <= wCpopup + 50) and wCursorRow = wLpopup +  3
          display 'Copy a Screen Row at cursor position             ' at Line wLpopup +  3 col wCpopup + 1 :BC wBCm :FC wFCm REVERSE
          continue after 1 seconds
          call "CBL_GC_SCR_RESTORE" using by reference wScreenName returning wScrOk end-call
          CALL "CBL_DELETE_FILE" USING wScreenName
          perform NotAvailable thru NotAvailableEx
     when (wKeyPressed = K-LEFT-PRESSED) and (wCursorCol >= wCpopup and <= wCpopup + 50) and wCursorRow = wLpopup +  4
          display 'Paste a Screen row at cursor position            ' at Line wLpopup +  4 col wCpopup + 1 :BC wBCm :FC wFCm REVERSE
          continue after 1 seconds
          call "CBL_GC_SCR_RESTORE" using by reference wScreenName returning wScrOk end-call
          CALL "CBL_DELETE_FILE" USING wScreenName
          set environment 'COB_HIDE_CURSOR'    TO 'FALSE'
          perform NotAvailable thru NotAvailableEx
      when (wKeyPressed = K-LEFT-PRESSED) and (wCursorCol >= wCpopup and <= wCpopup + 50) and wCursorRow = wLpopup +  5
          display 'Undo last Paste Screen Row                       ' at Line wLpopup +  5 col wCpopup + 1 :BC wBCm :FC wFCm REVERSE
          continue after 1 seconds
          call "CBL_GC_SCR_RESTORE" using by reference wScreenName returning wScrOk end-call
          CALL "CBL_DELETE_FILE" USING wScreenName
          perform NotAvailable thru NotAvailableEx
     when other
          call "CBL_GC_SCR_RESTORE" using by reference wScreenName returning wScrOk end-call
          CALL "CBL_DELETE_FILE" USING wScreenName
          continue
   end-evaluate
   set environment 'COB_HIDE_CURSOR'    TO 'FALSE'
   continue.
DisplayPopupMenuEditEx. exit.

ChangeColors.
    call "CBL_GC_SCR_DUMP" using by reference wScreenName returning wScrOk end-call
    perform ChangeColorsDisplayScreen thru ChangeColorsDisplayScreenEx
    move wSCR-BGCOL(wL wC) to wBCsample
    move wSCR-FGCOL(wL wC) to wFCsample

    display wBCsample at line wLcolors + 9 col wCcolors + 24 :BC wBCc :FC wFCc
    display wFCsample at line wLcolors + 9 col wCcolors + 51 :BC wBCc :FC wFCc
    display wSample1  at Line wLcolors + 11 col wCcolors + 2 :BC wBCsample :FC wFCsample
    display wSample2  at Line wLcolors + 12 col wCcolors + 2 :BC wBCsample :FC wFCsample
    display wSample3  at Line wLcolors + 13 col wCcolors + 2 :BC wBCsample :FC wFCsample
    continue.
ChangeColors-Loop.
    accept wBCsample line wLcolors + 9 col wCcolors + 24 auto update prompt '_' :BC wBCc :FC wFCc
    move 'ColorBack' to wSwitchColorAccept
    perform ChangeColorsEvaluate thru ChangeColorsEvaluateEx
    if wKeyPressed     = K-ESCAPE or K-F3                           go to ChangeColorsEnd end-if
    if wCommandClicked = K-ESCAPE or K-F3 move 0 to wCommandClicked go to ChangeColorsEnd end-if

    accept wFCsample line wLcolors + 9 col wCcolors + 51 auto update prompt '_' :BC wBCc :FC wFCc
    move 'ColorFore' to wSwitchColorAccept
    perform ChangeColorsEvaluate thru ChangeColorsEvaluateEx
    if wKeyPressed     = K-ESCAPE or K-F3                           go to ChangeColorsEnd end-if
    if wCommandClicked = K-ESCAPE or K-F3 move 0 to wCommandClicked go to ChangeColorsEnd end-if

    go to ChangeColors-Loop
    continue.
ChangeColorsEnd.
    call "CBL_GC_SCR_RESTORE" using by reference wScreenName returning wScrOk end-call
    CALL "CBL_DELETE_FILE" USING wScreenName
    move ' xx   GnuCOBOL Screen Painter - actual colors   xx ' to wSample2
    move 0 to wKeyPressed
    continue.
ChangeColorsEx. exit.

ChangeColorsDisplayScreen.
  perform with test after varying wLINE from 3 by 1 until wLINE > 22
    display '                                                        ' at Line wLINE col wCcolors :BC wBCc :FC wFCc
  end-perform
  display '* Change Screen Colors *' at Line wLcolors - 2 col wCcolors + 15 :BC cyan      :FC white

  display ' 00 black               ' at Line wLcolors     col wCcolors + 2  :BC black     :FC white
  display ' 01 blue                ' at Line wLcolors + 1 col wCcolors + 2  :BC blue      :FC white
  display ' 02 green               ' at Line wLcolors + 2 col wCcolors + 2  :BC green     :FC white
  display ' 03 cyan                ' at Line wLcolors + 3 col wCcolors + 2  :BC cyan      :FC white
  display ' 04 red                 ' at Line wLcolors + 4 col wCcolors + 2  :BC red       :FC white
  display ' 05 magenta             ' at Line wLcolors + 5 col wCcolors + 2  :BC magenta   :FC white
  display ' 06 brown               ' at Line wLcolors + 6 col wCcolors + 2  :BC brown     :FC white
  display ' 07 lightgrey           ' at Line wLcolors + 7 col wCcolors + 2  :BC lightgrey :FC white

  display ' 08 darkgrey            ' at Line wLcolors     col wCcolors + 29 :BC darkgrey   :FC white
  display ' 09 lightblue           ' at Line wLcolors + 1 col wCcolors + 29 :BC lightblue  :FC white
  display ' 10 lightgreen          ' at Line wLcolors + 2 col wCcolors + 29 :BC lightgreen :FC black
  display ' 11 lightcyan           ' at Line wLcolors + 3 col wCcolors + 29 :BC lightcyan  :FC black
  display ' 12 lightred            ' at Line wLcolors + 4 col wCcolors + 29 :BC lightred   :FC black
  display ' 13 pink                ' at Line wLcolors + 5 col wCcolors + 29 :BC pink       :FC black
  display ' 14 yellow              ' at Line wLcolors + 6 col wCcolors + 29 :BC yellow     :FC black
  display ' 15 white               ' at Line wLcolors + 7 col wCcolors + 29 :BC white      :FC black

  display 'new Background Color: '   at Line wLcolors + 9 col wCcolors + 2  :BC wBcc       :FC wFCc
  display 'new Foreground Color: '   at Line wLcolors + 9 col wCcolors + 29 :BC wBcc       :FC wFCc
  display 'Enter a color code or left-click on a color sample,   ' at Line wLcolors + 15 col wCcolors + 2 :BC wBcc :FC wFCc
  display 'then use or left-click on one of following commands:  ' at Line wLcolors + 16 col wCcolors + 2 :BC wBcc :FC wFCc
  display '[Enter=Show new colors] [F3=Save] [ESC=Exit no change]' at Line wLcolors + 17 col wCcolors + 1 :BC wBcc :FC wFCc
      continue.
ChangeColorsDisplayScreenEx. exit.

ChangeColorsEvaluate.
    evaluate TRUE
        when wKeyPressed = K-ENTER *> show sample subscreen with new colors
             continue
        when wKeyPressed = K-F3   *> exit with new colors
             move wBCsample to wNewColor-B
             move wFCsample to wNewColor-F
             move 1 to wFlagNewColor
             go to ChangeColorsEvaluateEx
        when wKeyPressed = K-LEFT-PRESSED
             perform ChangeColorsLeftButton thru ChangeColorsLeftButtonEx
             display wBCsample line wLcolors + 9 col wCcolors + 24 :BC wBCc :FC wFCc
             display wFCsample line wLcolors + 9 col wCcolors + 51 :BC wBCc :FC wFCc

             *> if user clicked on a command:
             *> display '[Enter=Show new colors] [F3=Save] [ESC=Exit no change]' at Line wLcolors + 16 col wCcolors + 2 :BC wBcc :FC white
             *>                   1         2         3         4         5
             *>          12345678901234567890123 567890123 5678901234567890123
             if wCursorRow = wLcolors + 17 and (wCursorCol >= (wCcolors + 1     ) and <= (wCcolors + 1 + 22) )
                move K-ENTER   to wCommandClicked
                set environment 'COB_HIDE_CURSOR'    TO 'TRUE'
                display '[Enter=Show new colors]' at Line wLcolors + 17 col (wCcolors + 1) :BC wBcc :FC wFCc REVERSE
                continue after 1 seconds
                display '[Enter=Show new colors]' at Line wLcolors + 17 col (wCcolors + 1) :BC wBcc :FC wFCc
                set environment 'COB_HIDE_CURSOR'    TO 'FALSE'
             end-if
             if wCursorRow = wLcolors + 17 and (wCursorCol >= (wCcolors + 1 + 24) and <= (wCcolors + 1 + 32) )
                move wBCsample to wNewColor-B
                move wFCsample to wNewColor-F
                move 1         to wFlagNewColor
                move K-F3      to wCommandClicked
                set environment 'COB_HIDE_CURSOR'    TO 'TRUE'
                display '[F3=Save]' at Line wLcolors + 17 col (wCcolors + 1 + 24) :BC wBcc :FC wFCc REVERSE
                continue after 1 seconds
                set environment 'COB_HIDE_CURSOR'    TO 'FALSE'
                go to ChangeColorsEvaluateEx
             end-if
             if wCursorRow = wLcolors + 17 and (wCursorCol >= (wCcolors + 2 + 33) and <= (wCcolors + 1 + 53) )
                move K-ESCAPE  to wCommandClicked
                set environment 'COB_HIDE_CURSOR'    TO 'TRUE'
                display '[ESC=Exit no change]' at Line wLcolors + 17 col (wCcolors + 2 + 33) :BC wBcc :FC wFCc REVERSE
                continue after 1 seconds
                set environment 'COB_HIDE_CURSOR'    TO 'FALSE'
                go to ChangeColorsEvaluateEx
             end-if

        when wKeyPressed = K-ESCAPE
             go to ChangeColorsEvaluateEx
    end-evaluate
    move ' xx    GnuCOBOL Screen Painter - new colors     xx ' to wSample2
    display wSample1 at Line wLcolors + 11 col wCcolors + 2 :BC wBCsample :FC wFCsample
    display wSample2 at Line wLcolors + 12 col wCcolors + 2 :BC wBCsample :FC wFCsample
    display wSample3 at Line wLcolors + 13 col wCcolors + 2 :BC wBCsample :FC wFCsample
    continue.
ChangeColorsEvaluateEx. exit.

ChangeColorsLeftButton.
  if wCursorRow = wLcolors     and (wCursorCol >= wCcolors + 2 and <= wCcolors + 24)
    if wSwitchColorAccept = 'ColorBack' move 00 to wBCsample end-if
    if wSwitchColorAccept = 'ColorFore' move 00 to wFCsample end-if end-if
  if wCursorRow = wLcolors + 1 and (wCursorCol >= wCcolors + 2 and <= wCcolors + 24)
    if wSwitchColorAccept = 'ColorBack' move 01 to wBCsample end-if
    if wSwitchColorAccept = 'ColorFore' move 01 to wFCsample end-if end-if
  if wCursorRow = wLcolors + 2 and (wCursorCol >= wCcolors + 2 and <= wCcolors + 24)
    if wSwitchColorAccept = 'ColorBack' move 02 to wBCsample end-if
    if wSwitchColorAccept = 'ColorFore' move 02 to wFCsample end-if end-if
  if wCursorRow = wLcolors + 3 and (wCursorCol >= wCcolors + 2 and <= wCcolors + 24)
    if wSwitchColorAccept = 'ColorBack' move 03 to wBCsample end-if
    if wSwitchColorAccept = 'ColorFore' move 03 to wFCsample end-if end-if
  if wCursorRow = wLcolors + 4 and (wCursorCol >= wCcolors + 2 and <= wCcolors + 24)
    if wSwitchColorAccept = 'ColorBack' move 04 to wBCsample end-if
    if wSwitchColorAccept = 'ColorFore' move 04 to wFCsample end-if end-if
  if wCursorRow = wLcolors + 5 and (wCursorCol >= wCcolors + 2 and <= wCcolors + 24)
    if wSwitchColorAccept = 'ColorBack' move 05 to wBCsample end-if
    if wSwitchColorAccept = 'ColorFore' move 05 to wFCsample end-if end-if
  if wCursorRow = wLcolors + 6 and (wCursorCol >= wCcolors + 2 and <= wCcolors + 24)
    if wSwitchColorAccept = 'ColorBack' move 06 to wBCsample end-if
    if wSwitchColorAccept = 'ColorFore' move 06 to wFCsample end-if end-if
  if wCursorRow = wLcolors + 7 and (wCursorCol >= wCcolors + 2 and <= wCcolors + 24)
    if wSwitchColorAccept = 'ColorBack' move 07 to wBCsample end-if
    if wSwitchColorAccept = 'ColorFore' move 07 to wFCsample end-if end-if

  if wCursorRow = wLcolors     and (wCursorCol >= wCcolors + 29 and <= wCcolors + 51)
    if wSwitchColorAccept = 'ColorBack' move 08 to wBCsample end-if
    if wSwitchColorAccept = 'ColorFore' move 08 to wFCsample end-if end-if
  if wCursorRow = wLcolors + 1 and (wCursorCol >= wCcolors + 29 and <= wCcolors + 51)
    if wSwitchColorAccept = 'ColorBack' move 09 to wBCsample end-if
    if wSwitchColorAccept = 'ColorFore' move 09 to wFCsample end-if end-if
  if wCursorRow = wLcolors + 2 and (wCursorCol >= wCcolors + 29 and <= wCcolors + 51)
    if wSwitchColorAccept = 'ColorBack' move 10 to wBCsample end-if
    if wSwitchColorAccept = 'ColorFore' move 10 to wFCsample end-if end-if
  if wCursorRow = wLcolors + 3 and (wCursorCol >= wCcolors + 29 and <= wCcolors + 51)
    if wSwitchColorAccept = 'ColorBack' move 11 to wBCsample end-if
    if wSwitchColorAccept = 'ColorFore' move 11 to wFCsample end-if end-if
  if wCursorRow = wLcolors + 4 and (wCursorCol >= wCcolors + 29 and <= wCcolors + 51)
    if wSwitchColorAccept = 'ColorBack' move 12 to wBCsample end-if
    if wSwitchColorAccept = 'ColorFore' move 12 to wFCsample end-if end-if
  if wCursorRow = wLcolors + 5 and (wCursorCol >= wCcolors + 29 and <= wCcolors + 51)
    if wSwitchColorAccept = 'ColorBack' move 13 to wBCsample end-if
    if wSwitchColorAccept = 'ColorFore' move 13 to wFCsample end-if end-if
  if wCursorRow = wLcolors + 6 and (wCursorCol >= wCcolors + 29 and <= wCcolors + 51)
    if wSwitchColorAccept = 'ColorBack' move 14 to wBCsample end-if
    if wSwitchColorAccept = 'ColorFore' move 14 to wFCsample end-if end-if
  if wCursorRow = wLcolors + 7 and (wCursorCol >= wCcolors + 29 and <= wCcolors + 51)
    if wSwitchColorAccept = 'ColorBack' move 15 to wBCsample end-if
    if wSwitchColorAccept = 'ColorFore' move 15 to wFCsample end-if end-if
    continue.
ChangeColorsLeftButtonEx. exit.

ColorsCopy.
  move wSCR-BGCOL(wL wC) to wSCR-BGCOL-MEM
  move wSCR-FGCOL(wL wC) to wSCR-FGCOL-MEM
  call "CBL_GC_SCR_DUMP" using by reference wScreenName returning wScrOk end-call
  move wLmessage to wLinDT
  compute wColDT = wCmessage + 18
  display "                                       " at line wLmessage     col wCmessage :BC wBCm :FC wFCm beep
  display "                                       " at line wLmessage + 1 col wCmessage :BC wBCm :FC wFCm
  display " Ok! FG and BG colors copy executed.   " at line wLmessage + 2 col wCmessage :BC wBCm :FC wFCm
  display " Now you can position cursor on screen " at line wLmessage + 3 col wCmessage :BC wBCm :FC wFCm
  display " and use F8 to paste FG and BG colors. " at line wLmessage + 4 col wCmessage :BC wBCm :FC wFCm
  display "                                       " at line wLmessage + 5 col wCmessage :BC wBCm :FC wFCm
  perform with test after until wKeyPressed <> K-TIMEOUT
          accept omitted timeout 1
              on exception perform DisplayDateTime thru DisplayDateTimeEx
  end-perform
  call "CBL_GC_SCR_RESTORE" using by reference wScreenName returning wScrOk end-call
  CALL "CBL_DELETE_FILE" USING wScreenName
  continue.
ColorsCopyEx. exit.

ColorsPaste.
  move wSCR-BGCOL-MEM to wSCR-BGCOL(wL wC)
  move wSCR-FGCOL-MEM to wSCR-FGCOL(wL wC)
  display wSCR-CHAR(wL wC) line wL col wC :BC wSCR-BGCOL(wL wC) :FC wSCR-FGCOL(wL wC)
  compute wC = wC + 1
  if wC > 80 move 1 to wC compute wL = wL + 1 end-if
  IF wL > 25 move 1 to wL end-if
  continue.
ColorsPasteEx. exit.

ScreenSectionCopyGenerate.
  CALL "CBL_CHECK_FILE_EXIST" USING  FilespecTXT wFile-info
  move RETURN-CODE to wRETURN-CODE   *> display wRETURN-CODE accept omitted
  move corresponding wFile-info to eFile-info
  move wLmessage to wLinDT
  compute wColDT = wCmessage + 18

  if wRETURN-CODE = 35       *> 35 = screen layout .TXT file does not exist
      call "CBL_GC_SCR_DUMP" using by reference wScreenName returning wScrOk end-call
      display "                                       " at line wLmessage     col wCmessage :BC wBCm :FC wFCm beep
      display "                                       " at line wLmessage + 1 col wCmessage :BC wBCm :FC wFCm
      display function concat(" File " FilespecTXT(1:15) " does not exist.  ") at line wLmessage + 2 col wCmessage :BC wBCm :FC wFCm
      display " Save your screen layout (using F4)    " at line wLmessage + 3 col wCmessage :BC wBCm :FC wFCm
      display " before requesting COPY generation.    " at line wLmessage + 4 col wCmessage :BC wBCm :FC wFCm
      display "                                       " at line wLmessage + 5 col wCmessage :BC wBCm :FC wFCm
      perform with test after until wKeyPressed <> K-TIMEOUT
              accept omitted timeout 1
                  on exception perform DisplayDateTime thru DisplayDateTimeEx
      end-perform
      call "CBL_GC_SCR_RESTORE" using by reference wScreenName returning wScrOk end-call
      CALL "CBL_DELETE_FILE" USING wScreenName
      go to ScreenSectionCopyGenerateEx
  end-if

  call "GC99SCREENCOPY" using ScreenPainter-Area end-call
  call "CBL_GC_SCR_DUMP" using by reference wScreenName returning wScrOk end-call
  display "                                                       "                                   at line wLmessageGen     col wCmessageGen :BC wBCm :FC wFCm beep
  display "                                                       "                                   at line wLmessageGen + 1 col wCmessageGen :BC wBCm :FC wFCm
  display function concat(" Ok, files: " FileSpecCPY(1:15) " " FileSpecCPW(1:15) " generated. ")      at line wLmessageGen + 2 col wCmessageGen :BC wBCm :FC wFCm
  display function concat(" - The screen has " wNumScreenRow " rows.                            ")    at line wLmessageGen + 3 col wCmessageGen :BC wBCm :FC wFCm
  display function concat(" - Screen Section Copy has " wNumSourceRowCPY " rows.                   ") at line wLmessageGen + 4 col wCmessageGen :BC wBCm :FC wFCm
  display function concat(" - Working-Storage Copy has " wNumSourceRowCPW " rows.                  ") at line wLmessageGen + 5 col wCmessageGen :BC wBCm :FC wFCm
  display "                                                       "                                   at line wLmessageGen + 6 col wCmessageGen :BC wBCm :FC wFCm
  perform with test after until wKeyPressed <> K-TIMEOUT
          accept omitted timeout 1
              on exception perform DisplayDateTime thru DisplayDateTimeEx
  end-perform
  call "CBL_GC_SCR_RESTORE" using by reference wScreenName returning wScrOk end-call
  CALL "CBL_DELETE_FILE" USING wScreenName
  continue.
ScreenSectionCopyGenerateEx. exit.

ScreenSectionCopyTest.
  CALL "CBL_CHECK_FILE_EXIST" USING  FileSpecCPY wFile-info
  move RETURN-CODE to wRETURN-CODE   *> display wRETURN-CODE accept omitted
  move corresponding wFile-info to eFile-info
  move wLmessage to wLinDT
  compute wColDT = wCmessage + 18
  if wRETURN-CODE = 35            *> 35 = screen section COPY CPY file does not exist
     call "CBL_GC_SCR_DUMP" using by reference wScreenName returning wScrOk end-call
     display "                                       " at line wLmessage     col wCmessage :BC wBCm :FC wFCm beep
     display "                                       " at line wLmessage + 1 col wCmessage :BC wBCm :FC wFCm
     display function concat(" File " FileSpecCPY(1:15) " does not exist.  ") at line wLmessage + 2 col wCmessage :BC wBCm :FC wFCm
     display " Create Screen Section COPY (use F5)   " at line wLmessage + 3 col wCmessage :BC wBCm :FC wFCm
     display " before requesting a test execution.   " at line wLmessage + 4 col wCmessage :BC wBCm :FC wFCm
     display "                                       " at line wLmessage + 5 col wCmessage :BC wBCm :FC wFCm
     perform with test after until wKeyPressed <> K-TIMEOUT
             accept omitted timeout 1
                 on exception perform DisplayDateTime thru DisplayDateTimeEx
     end-perform
     call "CBL_GC_SCR_RESTORE" using by reference wScreenName returning wScrOk end-call
     CALL "CBL_DELETE_FILE" USING wScreenName
     go to ScreenSectionCopyTestEx
  end-if

  move FileSpecCPY to tFileSpecCPY

  call "CBL_GC_SCR_DUMP" using by reference wScreenName returning wScrOk end-call
  call "GC99SCREENTEST" using ScreenTest-Area end-call

  call "CBL_GC_SCR_RESTORE" using by reference wScreenName returning wScrOk end-call
  CALL "CBL_DELETE_FILE" USING wScreenName

  call "CBL_GC_SCR_DUMP" using by reference wScreenName returning wScrOk end-call
  display "                                       " at line wLmessage     col wCmessage :BC wBCm :FC wFCm beep
  display "                                       " at line wLmessage + 1 col wCmessage :BC wBCm :FC wFCm
  display function concat(" Ok, program " tFileSpecCOB(1:15) " executed, ") at line wLmessage + 2 col wCmessage :BC wBCm :FC wFCm
  display " now you are back to the ScreenPainter " at line wLmessage + 3 col wCmessage :BC wBCm :FC wFCm
  display "                                       " at line wLmessage + 4 col wCmessage :BC wBCm :FC wFCm
  display "                                       " at line wLmessage + 5 col wCmessage :BC wBCm :FC wFCm
  perform with test after until wKeyPressed <> K-TIMEOUT
          accept omitted timeout 1
              on exception perform DisplayDateTime thru DisplayDateTimeEx
  end-perform
  call "CBL_GC_SCR_RESTORE" using by reference wScreenName returning wScrOk end-call
  CALL "CBL_DELETE_FILE" USING wScreenName
  continue.
ScreenSectionCopyTestEx. exit.

DisplayCoverScreen.
  display ' ' with blank screen :BC wBCm :FC wFCm
  *> display '     ______            __________  ____  ____  __   ' at 0514 :BC wBCm :FC wFCm
  *> display '    / ____/___  __  __/ ____/ __ \/ __ )/ __ \/ /   ' at 0614 :BC wBCm :FC wFCm
  *> display '   / / __/ __ \/ / / / /   / / / / __  / / / / /    ' at 0714 :BC wBCm :FC wFCm
  *> display '  / /_/ / / / / /_/ / /___/ /_/ / /_/ / /_/ / /___  ' at 0814 :BC wBCm :FC wFCm
  *> display '  \____/_/ /_/\__,_/\____/\____/_____/\____/_____/  ' at 0914 :BC wBCm :FC wFCm
  *> display '           / ___/_____________  ___  ____           ' at 1014 :BC wBCm :FC wFCm
  *> display '           \__ \/ ___/ ___/ _ \/ _ \/ __ \          ' at 1114 :BC wBCm :FC wFCm
  *> display '          ___/ / /__/ /  /  __/  __/ / / /          ' at 1214 :BC wBCm :FC wFCm
  *> display '         /____/\___/_/   \___/\___/_/ /_/           ' at 1314 :BC wBCm :FC wFCm
  *> display '         / __ \____ _(_)___  / /____  _____         ' at 1414 :BC wBCm :FC wFCm
  *> display '        / /_/ / __ `/ / __ \/ __/ _ \/ ___/         ' at 1514 :BC wBCm :FC wFCm
  *> display '       / ____/ /_/ / / / / / /_/  __/ /             ' at 1614 :BC wBCm :FC wFCm
  *> display '      /_/    \__,_/_/_/ /_/\__/\___/_/              ' at 1714 :BC wBCm :FC wFCm

  move 4 to wLc
  display '     ______            _____,____  ____  ____  __   ' at line wLc     col 14 :BC wBCm :FC wFCm
  display '    / ____/___  __  __/ ____/ __ \/ __ )/ __ \/ /   ' at line wLc +  1 col 14 :BC wBCm :FC wFCm
  display '   / / __/ __ \/ / / / /   / / / / __  / / / / /    ' at line wLc +  2 col 14 :BC wBCm :FC wFCm
  display '  / /_/ / / / / /_/ / /___/ /_/ / /_/ / /_/ / /___  ' at line wLc +  3 col 14 :BC wBCm :FC wFCm
  display '  \____/_/ /_/\____/\____/\____/_____/\____/_____/  ' at line wLc +  4 col 14 :BC wBCm :FC wFCm
  display '            _____                                   ' at line wLc +  5 col 14 :BC wBCm :FC wFCm
  display '           / ___/____,____,___  ___  ____           ' at line wLc +  6 col 14 :BC wBCm :FC wFCm
  display '           \__ \/ ___/ ___/ _ \/ _ \/ __ \          ' at line wLc +  7 col 14 :BC wBCm :FC wFCm
  display '          ___/ / /__/ /  /  __/  __/ / / /          ' at line wLc +  8 col 14 :BC wBCm :FC wFCm
  display '         /____/\___/_/   \___/\___/_/ /_/           ' at line wLc +  9 col 14 :BC wBCm :FC wFCm
  display '          ____        _       __                    ' at line wLc + 10 col 14 :BC wBCm :FC wFCm
  display '         / __ \____ _(_)___  / /____  _____         ' at line wLc + 11 col 14 :BC wBCm :FC wFCm
  display '        / /_/ / __ `/ / __ \/ __/ _ \/ ___/         ' at line wLc + 12 col 14 :BC wBCm :FC wFCm
  display '       / ____/ /_/ / / / / / /_/  __/ /             ' at line wLc + 13 col 14 :BC wBCm :FC wFCm
  display '      /_/    \____/_/_/ /_/\__/\___/_/              ' at line wLc + 14 col 14 :BC wBCm :FC wFCm
  display '                                                    ' at line wLc + 17 col 14 :BC wBCm :FC wFCm
  display ' ... press Enter to continue then F1= HELP Screen.  ' at line wLc + 18 col 14 :BC wBCm :FC wFCm
  continue.
DisplayCoverScreenEx. exit.

DisplayAboutScreen.
  set environment 'COB_HIDE_CURSOR'    TO 'TRUE'
  call "CBL_GC_SCR_DUMP" using by reference wScreenName returning wScrOk end-call
  display ' ' with blank screen :BC wBCm :FC wFCm
  display '                                                                 ' at 0310 :BC wBCm :FC wFCm
  display '                             ''''~``                               ' at 0410 :BC wBCm :FC wFCm
  display '                            ( o o )                              ' at 0510 :BC wBCm :FC wFCm
  display '    +------------------.oooO--(_)--Oooo.------------------+      ' at 0610 :BC wBCm :FC wFCm
  display '    |                                                     |      ' at 0710 :BC wBCm :FC wFCm
  display '    |               GnuCOBOL SCREEN PAINTER               |      ' at 0810 :BC wBCm :FC wFCm
  display '    |                     release 1.0                     |      ' at 0910 :BC wBCm :FC wFCm
  display '    |           Author: eugenio.dilo@gmail.com            |      ' at 1010 :BC wBCm :FC wFCm
  display '    |                                                     |      ' at 1110 :BC wBCm :FC wFCm
  display '    |                    .oooO                            |      ' at 1210 :BC wBCm :FC wFCm
  display '    |                    (   )   Oooo.                    |      ' at 1310 :BC wBCm :FC wFCm
  display '    +---------------------\ (----(   )--------------------+      ' at 1410 :BC wBCm :FC wFCm
  display '                           \_)    ) /                            ' at 1510 :BC wBCm :FC wFCm
  display '                                  (_/                            ' at 1610 :BC wBCm :FC wFCm
  display '                                                                 ' at 1710 :BC wBCm :FC wFCm
  display '                                                                 ' at 1810 :BC wBCm :FC wFCm
  display ' a. Draw your screen layout with constant and variable field     ' at 1910 :BC wBCm :FC wFCm
  display ' b. Set the colors you want on the screen (use F3)               ' at 2010 :BC wBCm :FC wFCm
  display ' c. Save the screen layout and colors to disk (use F4)           ' at 2110 :BC wBCm :FC wFCm
  display ' d. Generate SCREEN and WORKING-STORAGE copy files (use F5)      ' at 2210 :BC wBCm :FC wFCm
  display ' e. Create, compile & run a program to test your screen (use F6) ' at 2310 :BC wBCm :FC wFCm
  move 1 to wLinDT move 60 to wColDT
  perform with test after until wKeyPressed <> K-TIMEOUT
          accept omitted timeout 1
              on exception perform DisplayDateTime thru DisplayDateTimeEx
  end-perform
  call "GC99RAIN" end-call
  call "CBL_GC_SCR_RESTORE" using by reference wScreenName returning wScrOk end-call
  CALL "CBL_DELETE_FILE" USING wScreenName
  set environment 'COB_HIDE_CURSOR'    TO 'FALSE'
  continue.
DisplayAboutScreenEx. exit.

DisplayHelpScreen.
    call "CBL_GC_SCR_DUMP" using by reference wScreenName returning wScrOk end-call
    compute wLinDT = wLhelp +  1
    compute wColDT = wChelp + 31
    set environment 'COB_HIDE_CURSOR'    TO 'TRUE'
    display "                                                     " at line wLhelp      col wChelp  :BC wBCm :FC wFCm
    display "  GnuCOBOL SCREEN PAINTER HELP                       " at line wLhelp +  1 col wChelp  :BC wBCm :FC wFCm
    display "                                                     " at line wLhelp +  2 col wChelp  :BC wBCm :FC wFCm
    display "  - Arrow keys or left-click mouse button: move      " at line wLhelp +  3 col wChelp  :BC wBCm :FC wFCm
    display "    cursor to draw your screen layout.               " at line wLhelp +  4 col wChelp  :BC wBCm :FC wFCm
    display "  - Use $ for PIC X field, use # for PIC 9 field.    " at line wLhelp +  5 col wChelp  :BC wBCm :FC wFCm
    display "  - Right mouse button to show a 'pop-up menu'.      " at line wLhelp +  6 col wChelp  :BC wBCm :FC wFCm
    display "  - Mid mouse button to show an 'edit pop-up menu'.  " at line wLhelp +  7 col wChelp  :BC wBCm :FC wFCm
    display "  - Use:                                             " at line wLhelp +  8 col wChelp  :BC wBCm :FC wFCm
    display "    F1 = HELP (this Screen)                          " at line wLhelp +  9 col wChelp  :BC wBCm :FC wFCm
    display "    F2 = Display a pop-up menu (or right mouse b.)   " at line wLhelp + 10 col wChelp  :BC wBCm :FC wFCm
    display "    F3 = Change back/foreground colors               " at line wLhelp + 11 col wChelp  :BC wBCm :FC wFCm
    display "    F4 = Save the screen layout to disk              " at line wLhelp + 12 col wChelp  :BC wBCm :FC wFCm
    display "    F5 = Generate SCREEN SECTION (and WS) copy       " at line wLhelp + 13 col wChelp  :BC wBCm :FC wFCm
    display "    F6 = Test your Screen                            " at line wLhelp + 14 col wChelp  :BC wBCm :FC wFCm
    display "    F7 = Copy FG/BG colors at cursor position        " at line wLhelp + 15 col wChelp  :BC wBCm :FC wFCm
    display "    F8 = Paste FG/BG colors at cursor position       " at line wLhelp + 16 col wChelp  :BC wBCm :FC wFCm
    display "    F9 = Settings (*)                                " at line wLhelp + 17 col wChelp  :BC wBCm :FC wFCm
    display "    F10= Display horizontal ruler at cursor line     " at line wLhelp + 18 col wChelp  :BC wBCm :FC wFCm
    display "    F11= Display vertical ruler at cursor column     " at line wLhelp + 19 col wChelp  :BC wBCm :FC wFCm
    display "    F12= About Screen                                " at line wLhelp + 20 col wChelp  :BC wBCm :FC wFCm
    display "                                                     " at line wLhelp + 21 col wChelp  :BC wBCm :FC wFCm
    perform with test after until wKeyPressed <> K-TIMEOUT
        accept omitted timeout 1
            on exception perform DisplayDateTime thru DisplayDateTimeEx
    end-perform
    set environment 'COB_HIDE_CURSOR'    TO 'FALSE'
    call "CBL_GC_SCR_RESTORE" using by reference wScreenName returning wScrOk end-call
    CALL "CBL_DELETE_FILE" USING wScreenName
    continue.
DisplayHelpScreenEx. exit.

DisplayHorizontalRuler.
    call "CBL_GC_SCR_DUMP" using by reference wScreenName returning wScrOk end-call
    set environment 'COB_HIDE_CURSOR'    TO 'TRUE'
    display wRULER at line  wL col 01  :BC lightred :FC white HIGHLIGHT
    accept omitted
    call "CBL_GC_SCR_RESTORE" using by reference wScreenName returning wScrOk end-call
    CALL "CBL_DELETE_FILE" USING wScreenName
    set environment 'COB_HIDE_CURSOR'    TO 'FALSE'
    continue.
DisplayHorizontalRulerEx. exit.

DisplayVerticalRuler.
    call "CBL_GC_SCR_DUMP" using by reference wScreenName returning wScrOk end-call
    set environment 'COB_HIDE_CURSOR'    TO 'TRUE'
    perform varying wLINE from 1 by 1 until wLINE > 25
        display wLINE(2:2) line wLINE col wC  :BC lightred :FC white HIGHLIGHT
    end-perform
    accept omitted
    call "CBL_GC_SCR_RESTORE" using by reference wScreenName returning wScrOk end-call
    CALL "CBL_DELETE_FILE" USING wScreenName
    set environment 'COB_HIDE_CURSOR'    TO 'FALSE'
    continue.
DisplayVerticalRulerEx. exit.

AcceptParameters.
  display '  '
  display 'Screen layout Filename (default [SCREEN-101.TXT]) ................: ' with no advancing
  accept FilespecTXT

  if FilespecTXT NOT = space
     move FilespecTXT to FilespecTXT2
     inspect FilespecTXT2 replacing ALL ' ' by '0'
     if FilespecTXT2 is numeric
        display 'Screen layout Filename must contain at least one letter ! ' with no advancing
        go to AcceptParameters
      end-if
   end-if

  if FilespecTXT = space move 'SCREEN-101.TXT' to FilespecTXT end-if
  inspect FilespecTXT tallying tally for all '.'
  if tally = 0
     inspect FilespecTXT replacing first '    ' by '.TXT'
  end-if

  display 'Screen Section copy Filename (default= ScreenLayoutfilename.CPY) .: ' with no advancing
  accept FileSpecCPY
  if FileSpecCPY = space
     move FilespecTXT to FileSpecCPY
     inspect FileSpecCPY replacing all 'TXT' by 'CPY' after initial '.'
  end-if
  inspect FileSpecCPY tallying tally for all '.'
  if tally = 0
     inspect FileSpecCPY replacing first '    ' by '.CPY'
  end-if

  move FilespecTXT to tFileSpecCPW  *> prepare working-storage copy filename
  inspect tFileSpecCPW replacing all '.TXT' by '    '
  move function concat(function trim(tFileSpecCPW) 'w.CPY') to tFileSpecCPW
  move tFileSpecCPW to FileSpecCPW

  if tFileSpecCOB = space  *> prepare COBOL test progam filename
     move FilespecTXT to tFileSpecCOB
     inspect tFileSpecCOB replacing all 'TXT' by 'COB' after initial '.'
  end-if

  *> tobe implemented !
  *> display 'Screen width (type 3 digit, default= 080 char) ...................: ' with no advancing
  *> accept wScreenWidth
  if wScreenwidth is not numeric or wScreenwidth = space or wScreenwidth = zero
     move '080' to wScreenWidth
  end-if
  move wScreenWidth9 to wWidth
  display space
  display '--------------------------------------------------------------  '
  display 'Screen layout Filename .......................................: '  FilespecTXT(1:30)
  display 'Screen Section copy Filename .................................: '  FileSpecCPY(1:30)
  display 'Working-Storage copy Filename ................................: ' tFileSpecCPW(1:30)
  display 'Source program to test the new screen ........................: ' tFileSpecCOB(1:30)
  display 'Screen width .................................................: ' wScreenWidth
  display 'Continue (y/n or r= Repeat) ? ................................: ' with no advancing

  accept  wAnswer
  if wAnswer = 'R' or 'r'
      display ' '
      display '... repeating ...'
      move space to FilespecTXT FileSpecCPY wScreenWidth
      move 0 to tally
      go to AcceptParameters
  end-if
  if wAnswer = 'Y' or 'y' or space
     continue
  else
      display space
      display '... Processing ended by the user !' with no advancing
      display space
      goback
  end-if.
AcceptParameters-Ex. exit.

DisplayDateTime.
  accept wDay  from date YYYYMMDD
  accept wTime from time
  string ' ' wDay(7:2)  '.' wDay(5:2)  '.' wDay(1:4) ' '
        wTime(1:2) ':' wTime(3:2) ':' wTime(5:2) delimited by size into wDateTime
  display wDateTime at line wLinDT col wColDT :BC wBCm :FC wFCm.
DisplayDateTimeEx. exit.

NotAvailable.
  call "CBL_GC_SCR_DUMP" using by reference wScreenName returning wScrOk end-call
  move wLmessage to wLinDT
  compute wColDT = wCmessage + 18
  display "                                       " at line wLmessage     col wCmessage :BC wBCm :FC wFCm beep
  display "                                       " at line wLmessage + 1 col wCmessage :BC wBCm :FC wFCm
  display " Sorry, function not yet available.    " at line wLmessage + 2 col wCmessage :BC wBCm :FC wFCm
  display "                                       " at line wLmessage + 3 col wCmessage :BC wBCm :FC wFCm
  display "                                       " at line wLmessage + 4 col wCmessage :BC wBCm :FC wFCm
  display "                                       " at line wLmessage + 5 col wCmessage :BC wBCm :FC wFCm
  perform with test after until wKeyPressed <> K-TIMEOUT
          accept omitted timeout 1
              on exception perform DisplayDateTime thru DisplayDateTimeEx
  end-perform
  call "CBL_GC_SCR_RESTORE" using by reference wScreenName returning wScrOk end-call
  CALL "CBL_DELETE_FILE" USING wScreenName
  continue.
NotAvailableEx. exit.

END PROGRAM GC99SCREENPAINTER.

*> ***********************************************************************************
*> PROGRAM FOR A FADE RAIN EFFECT
*> ***********************************************************************************
ID DIVISION.
PROGRAM-ID. GC99RAIN.
DATA DIVISION.
WORKING-STORAGE SECTION.
01  black         constant as 0.
01  wI            pic s9(04) comp-5 value +0.
01  wInd          pic s9(04) comp-5 value +0.
01  wRisult       pic s9(04) comp-5 value +0.
01  wTTT          pic 9(15) value 0.
01  wC            pic 9(04) value 0.
01  wR            pic 9(04) value 0.
01  wOffset       pic 9(04) value 0.
01  .
    05 wBuf       pic x occurs 2000 Value  space.
PROCEDURE DIVISION.
perform test after varying wI from 1 by 1 until wI = 2000
    compute wInd = wInd + 187
    divide 2000 into wInd giving wRisult remainder wInd
    divide   80 into wInd giving wR      remainder wC
    compute wC = wC + 1
    compute wR = wR + 1
    compute wOffset = (wInd * 2) + 1
    if wOffset > 2000 then compute wOffset = wOffset - 2000 end-if
    display wBuf(wOffset) at line wR column wC :BC black :FC black
    perform varying wTTT from 1 by 1 until wTTT = 1000 continue end-perform *> delay loop
end-perform
goback.
END PROGRAM GC99RAIN.


IDENTIFICATION DIVISION.
Program-Id. GC99SCREENCOPY is INITIAL.
*> ***********************************************************************************
*> GnuCOBOL TT (TUI TOOLS) COLLECTION
*> Purpose:    COBOL COPY GENERATOR FOR SCREEN SECTION and WORKING-STORAGE fields
*>             This program creates 2 files: XXXXXX.CPY for screen section; XXXXXXw.CPY for WS section
*>             Working-Storage fields are required and correspond to screen fields
*>             that accept user input and have the USING clause
*> Author:     Eugenio Di Lorenzo - Italia (DILO) - eugenio.dilo@gmail.com
*> License:    Copyright 2025 E.Di Lorenzo - GNU Lesser General Public License, LGPL, 3.0 (or greater)
*> Version:    1.0 2025.02.01
*> Changelog:  1.0 first release.
*> ***********************************************************************************
ENVIRONMENT   DIVISION.
INPUT-OUTPUT  SECTION.
FILE-CONTROL.
select FILETXT
    assign to FilespecTXT
    organization is line sequential
    file status  is FS-FILETXT.
select FILECPY  *> Copy file for Screen Section definition
    assign to FileSpecCPY
    organization is line sequential
    file status  is FS-FILECPY.

select FILECPW  *> Copy file for Working Storage fields
    assign to FileSpecCPW
    organization is line sequential
    file status  is FS-FILECPW.

DATA DIVISION.
FILE SECTION.
FD  FILETXT.
01 FD-ScreenFILE.
   03 FD-ScreenFILE-NUM      pic 9(003).
   03 FD-ScreenFILE-S        pic x(001).
   03 FD-ScreenFILE-LINE.
      05 FD-ScreenFILE-CHARS pic x occurs 81.
   03 FD-ScreenFILE-ATTRS    pic x(480).

FD  FILECPY. *> Copy file for Screen Section definition
01  CPY-rec    pic x(80).

FD  FILECPW. *> Copy file for Working Storage fields
01  CPW-rec    pic x(80).

WORKING-STORAGE SECTION.

01  FilespecTXT        pic x(60) value ' '.
01  FileSpecCPY        pic x(60) value ' '.
01  FileSpecCPW        pic x(60) value ' '.
01  nFilespecCPY       pic x(60) value ' '.
01  wScreenWidth.
    05  wScreenWidth9 pic 999.
77  FS-FILETXT       PIC XX    value space.
77  FS-FILECPY       PIC XX    value space.
77  FS-FILECPW       PIC XX    value space.
01  wAnswer          pic x(01) value space.

01  wWidth                pic 9(03) value 080.
01  wNumField             pic 9(03) value zero.
01  wNumRecInp            pic 9(03) value 1.
01  wNumChar              pic 9(03) value zero.
01  wNumScreenRow         pic 9(03) value 1.
01  wNumSourceRowCPY      pic 9(03) value zero.
01  wNumSourceRowCPW      pic 9(03) value zero.
01  i                     pic 9(03) value zero.
01  wInd                  pic 9(03) value zero.
01  wCol                  pic 9(03) value zero.
01  wPos                  pic 9(03) value 1.
01  wPicture              pic x(01) value space.
01  wVALUE2               pic x(13) value space.
01  wChar                 pic x(01) value space.
01  wChar2                pic x(01) value space.
01  wChar3                pic x(01) value space.
01  wValue                pic x(34) value space.
01  wend-of-file          pic x(01) value space.
    88 eof                value 'T'.
    88 not-eof            value 'F'.
01  wfind-table           pic x(01) value space.
    88 wend-table         value 'T'.
    88 not-wend-table     value 'F'.
01  wfind-equals          pic x(01) value space.
    88 w-all-equals       value 'T'.
    88 not-w-all-equals   value 'F'.

01  wCPYSourceRow         pic x(80).
01  wCPYSourceRowc  redefines wCPYSourceRow.
    03                    pic x(06).
    03 CPY-aster.
       05 CPY-ast1        pic x(02).
       05 CPY-comm        pic x(63).

01  wCPWSourceRow         pic x(80).
01  wCPWSourceRowc  redefines wCPWSourceRow.
    03                    pic x(06).
    03 CPW-aster.
       05 CPW-ast1        pic x(02).
       05 CPW-comm        pic x(63).

01 wSCREEN.
   03 wSCR-LINE-CHARS occurs 25.
      07 wSCR-CHAR     pic  X occurs 81 value space.
   03 wSCR-LINE-ATTRS occurs 25.
      07 wSCR-BGCOL    pic 99 occurs 80 value 02. *> default BG color is Green
      07 wSCR-FGCOL    pic 99 occurs 80 value 15. *> default FG color is White
      07 wSCR-HIGH     pic  9 occurs 80 value 0.
      07 wSCR-REVERSE  pic  9 occurs 80 value 0.

LINKAGE SECTION.
01 ScreenPainter-Area.
   03 lFilespecTXT         pic x(60) value ' '. *> TXT filename with screen template
   03 lFileSpecCPY         pic x(60) value ' '. *> CPY filename with SCREEN SECTION COPY
   03 lFileSpecCPW         pic x(60) value ' '. *> CPY filename with WORKING-STORAGE COPY
   03 lwScreenWidth.
      05 lwScreenWidth9    pic 999.
   03 lNumScreenRow        pic 9(03).
   03 lNumSourceRowCPY     pic 9(03).
   03 lNumSourceRowCPW     pic 9(03).

PROCEDURE DIVISION using ScreenPainter-Area.
move lFilespecTXT   to FilespecTXT
move lFileSpecCPY   to FileSpecCPY
move lFileSpecCPW   to FileSpecCPW
move lwScreenWidth  to wScreenWidth
move lwScreenWidth9 to wWidth

open input  FILETXT
if FS-FILETXT not = '00' display function concat('... error FS-FILETXT = ' FS-FILETXT) STOP RUN end-if
open output FILECPY
if FS-FILECPY not = '00' display function concat('... error FS-FILECPY = ' FS-FILECPY) STOP RUN end-if
open output FILECPW
if FS-FILECPW not = '00' display function concat('... error FS-FILECPW = ' FS-FILECPW) STOP RUN end-if

read FILETXT
  at end
     display 'FILETXT: "' FilespecTXT(1:15) '" is empty. File-Status= ' FS-FILECPY
     close FILETXT FILECPY FILECPW
     stop run

  not at end
    move FD-ScreenFILE-LINE  to wSCR-LINE-CHARS(wNumScreenRow)
    move FD-ScreenFILE-ATTRS to wSCR-LINE-ATTRS(wNumScreenRow)

    *> write a header for the copy
    move space      to wCPYSourceRow wCPWSourceRow
    move all '*'    to CPY-aster CPW-aster
    move '*>'       to CPY-ast1 CPW-ast1
    add 1 to wNumSourceRowCPY wNumSourceRowCPW
    write CPY-rec from wCPYSourceRow end-write
    write CPW-rec from wCPWSourceRow end-write

    move space      to CPY-comm CPW-comm
    move ' ------ GnuCOBOL SCREEN PAINTER - SCREEN SECTION --------' to CPY-comm
    add 1 to wNumSourceRowCPY
    write CPY-rec from wCPYSourceRow end-write
    move ' ------ GnuCOBOL SCREEN PAINTER - WORKING-STORAGE -------' to CPW-comm
    add 1 to wNumSourceRowCPW
    write CPW-rec from wCPWSourceRow end-write

    move space      to CPY-comm
    string '        SCREEN COD.XXXXXXXX  WIDTH= ' wWidth ' CHARS' into CPY-comm
    add 1 to wNumSourceRowCPY
    write CPY-rec from wCPYSourceRow end-write

    move space      to wCPYSourceRow wCPWSourceRow
    move all '*'    to CPY-aster CPW-aster
    move '*>'       to CPY-ast1 CPW-ast1
    add 1 to wNumSourceRowCPY wNumSourceRowCPW
    write CPY-rec from wCPYSourceRow end-write
    write CPW-rec from wCPWSourceRow end-write

    move space      to wCPYSourceRow
    *> prepare for 01 level name into the screen section copy
    move FilespecCPY to nFilespecCPY
    inspect nFilespecCPY replacing all '.CPY' by '    '
    move function concat('       01 SCR-' function trim(nFilespecCPY) ' blank screen auto-skip.') to wCPYSourceRow
    add 1 to wNumSourceRowCPY
    write CPY-rec from wCPYSourceRow end-write

    *> processes the individual rows read from file input
    set not-eof to true
    perform until eof

      *> write first row of the copy file (at 03 level).
      move 1         to i
      move space     to wCPYSourceRow
      string '          03 ROW' wNumRecInp '.' delimited by size into wCPYSourceRow end-string
      add 1 to wNumSourceRowCPY
      write CPY-rec from wCPYSourceRow end-write

      *> processes individual fields of the line read and write the lines of copy with fields (level 05)
      perform until i >= wWidth

        move FD-ScreenFILE-CHARS(i) to wChar
        move zero to wNumChar

        move i to wCol
        if FD-ScreenFILE-CHARS(i) = '$' or '#'
            move i to wInd  *> save position of first '$' or '#' char (to pick colors )
           *> *********************************************************************+
           *> treatment string with  '$' or '#' (these are input field pic x o pic 9)
           *> *********************************************************************+
            perform until FD-ScreenFILE-CHARS(i) not = wChar or i > wWidth
                    add 1 to i wNumChar
            end-perform

            add 1 to wNumField
            *> prepare for Working-storage copy
            if wChar = '$' move 'X' to wPicture move ' VALUE SPACE.' to wVALUE2 end-if
            if wChar = '#' move '9' to wPicture move ' VALUE ZERO.'  to wVALUE2 end-if

            *> write 2 Screen Section copy record
            move space to wCPYSourceRow
            string '             05 R' wNumRecInp '-F' wNumField ' line ' wNumRecInp ' col ' wCol ' PIC ' wPicture '(' wNumChar ') using wR' wNumRecInp '-F' wNumField
                  delimited by size into wCPYSourceRow end-string
            add 1 to wNumSourceRowCPY
            write CPY-rec from wCPYSourceRow end-write

            move space to wCPYSourceRow
            *> use colors of first position '$' or '#'
            string '                background-color ' wSCR-BGCOL(wNumScreenRow wInd) ' foreground-color ' wSCR-FGCOL(wNumScreenRow wInd)  '.'
                  delimited by size into wCPYSourceRow end-string
            add 1 to wNumSourceRowCPY
            write CPY-rec from wCPYSourceRow end-write

            *> write a Working-Storage Section copy record
            move space to wCPWSourceRow
            string '       01 wR' wNumRecInp '-F' wNumField ' PIC ' wPicture '(' wNumChar ') ' wVALUE2
                  delimited by size into wCPWSourceRow end-string
            add 1 to wNumSourceRowCPW
            write CPW-rec from wCPWSourceRow end-write

            add wNumChar to wPos

        else
            if FD-ScreenFILE-CHARS(i) not = space
                *> *********************************************************************+
                *> treatment string with only "constants" (no spaces no variables '$' or '#')
                *> *********************************************************************+
                move i to wInd *> save position of first chr not = space

                *> If there is only one space in the string then it is considered a single string that includes the space
                perform until (FD-ScreenFILE-CHARS(i) = space and (FD-ScreenFILE-CHARS(i + 1) = space or '$' or '#'))
                           or (FD-ScreenFILE-CHARS(i) = '$' or '#')
                           or wNumChar = 50
                           or i >  wWidth
                        add 1 to i wNumChar
                end-perform

                *> check if line contains all same character (to set VALUE ALL ... if the case
                set not-w-all-equals to true
                move FD-ScreenFILE-LINE(wPos:1) to wChar3
                move zero to tally
                inspect FD-ScreenFILE-LINE(wPos:wNumChar) tallying tally for all wChar3
                if tally = wNumChar set w-all-equals to true end-if

                if wNumChar > 20 and not w-all-equals
                  *> in order to write a line that does not go beyond column 72
                  *> the program writes 2 rows. the first one is with "PICTURE (PIC)"
                  move space to wCPYSourceRow
                  string '             05 line ' wNumRecInp ' col ' wCol ' PIC X(' wNumChar ')' delimited by size into wCPYSourceRow end-string
                  add 1 to wNumSourceRowCPY
                  write CPY-rec from wCPYSourceRow end-write

                  *> the second one is with "VALUE"
                  move space     to wCPYSourceRow
                  string '             VALUE ''' FD-ScreenFILE-LINE(wPos:wNumChar) ''' ' delimited by size into wCPYSourceRow end-string
                  add 1 to wNumSourceRowCPY
                  write CPY-rec from wCPYSourceRow end-write

                  *> use colors of first position not = space
                  move space to wCPYSourceRow
                  string '                background-color ' wSCR-BGCOL(wNumScreenRow wInd) ' foreground-color ' wSCR-FGCOL(wNumScreenRow wInd)  '.'
                        delimited by size into wCPYSourceRow end-string
                  add 1 to wNumSourceRowCPY
                  write CPY-rec from wCPYSourceRow end-write

                else
                  *> the program write only one source line in the copy as the line does not go beyond column 72
                  move space to wValue
                  if w-all-equals and tally not = 1
                    string ' VALUE ALL ''' FD-ScreenFILE-LINE(wPos:1) ''' ' delimited by size into wValue end-string
                  else
                    string ' VALUE ''' FD-ScreenFILE-LINE(wPos:wNumChar) ''' '  delimited by size into wValue end-string
                  end-if
                  move space     to wCPYSourceRow
                  string '             05 line ' wNumRecInp ' col ' wCol ' PIC X(' wNumChar ')' wValue delimited by size into wCPYSourceRow end-string
                  add 1 to wNumSourceRowCPY
                  write CPY-rec from wCPYSourceRow end-write

                  *> use colors of first position not = space
                  move space     to wCPYSourceRow
                  string '                background-color ' wSCR-BGCOL(wNumScreenRow wInd) ' foreground-color ' wSCR-FGCOL(wNumScreenRow wInd)  '.'
                        delimited by size into wCPYSourceRow end-string
                  add 1 to wNumSourceRowCPY
                  write CPY-rec from wCPYSourceRow end-write

                end-if
                add wNumChar to wPos

             else
                *> *********************************************************************+
                *> treatment string with only spaces
                *> *********************************************************************+
                move i to wInd *> save position of first char

                perform until (FD-ScreenFILE-CHARS(i) = '$' or '#') or FD-ScreenFILE-CHARS(i) not = space or wNumChar = 50 or i >  wWidth
                        add 1 to i wNumChar
                end-perform

                *> check if line contains all same character (to set VALUE ALL ... if the case
                set not-w-all-equals to true
                move FD-ScreenFILE-LINE(wPos:1) to wChar2
                move zero to tally
                inspect FD-ScreenFILE-LINE(wPos:wNumChar) tallying tally for all wChar2
                if tally = wNumChar set w-all-equals to true end-if

             *> if wNumChar > 24 and not w-all-equals
                if wNumChar > 20 and not w-all-equals
                  *> in order to write a line that does not go beyond column 72
                  *> the program writes 2 rows. the first one is with "PICTURE (PIC)"
                  move space to wCPYSourceRow
                  string '             05 line ' wNumRecInp ' col ' wCol ' PIC X(' wNumChar ')' delimited by size into wCPYSourceRow end-string
                  add 1 to wNumSourceRowCPY
                  write CPY-rec from wCPYSourceRow end-write

                  *> the second one is with "VALUE"
                  move space     to wCPYSourceRow
                  string '             VALUE ''' FD-ScreenFILE-LINE(wPos:wNumChar) ''' ' delimited by size into wCPYSourceRow end-string
                  add 1 to wNumSourceRowCPY
                  write CPY-rec from wCPYSourceRow end-write

                  *> use colors of first position not = space
                  move space to wCPYSourceRow
                  string '                background-color ' wSCR-BGCOL(wNumScreenRow wInd) ' foreground-color ' wSCR-FGCOL(wNumScreenRow wInd)  '.'
                        delimited by size into wCPYSourceRow end-string
                  add 1 to wNumSourceRowCPY
                  write CPY-rec from wCPYSourceRow end-write

                else
                  *> the program write only one source line in the copy as the line does not go beyond column 72
                  move space to wValue
                  if FD-ScreenFILE-LINE(wPos:wNumChar) = space
                     string ' VALUE SPACE ' delimited by size into wValue end-string
                  else
                      if w-all-equals and tally not = 1
                        string ' VALUE ALL ''' FD-ScreenFILE-LINE(wPos:1) ''' ' delimited by size into wValue end-string
                      else
                        string ' VALUE ''' FD-ScreenFILE-LINE(wPos:wNumChar) ''' '  delimited by size into wValue end-string
                      end-if
                  end-if
                  move space to wCPYSourceRow
                  string '             05 line ' wNumRecInp ' col ' wCol ' PIC X(' wNumChar ')' wValue delimited by size into wCPYSourceRow end-string
                  add 1 to wNumSourceRowCPY
                  write CPY-rec from wCPYSourceRow end-write

                  *> use colors of first position not = space
                  move space to wCPYSourceRow
                  string '                background-color ' wSCR-BGCOL(wNumScreenRow wInd) ' foreground-color ' wSCR-FGCOL(wNumScreenRow wInd)  '.'
                        delimited by size into wCPYSourceRow end-string
                  add 1 to wNumSourceRowCPY
                  write CPY-rec from wCPYSourceRow end-write

                end-if
                add wNumChar to wPos

           end-if
        end-if
      end-perform

      move 1 to i wPos
      move 0 to wNumField
      add  1 to wNumScreenRow

      *> read next record (next screen row)
      set not-wend-table to true
      perform until eof or wend-table
        read FILETXT
          at end set eof to true
          not at end
              add 1 to wNumRecInp
              set wend-table to true
              move FD-ScreenFILE-LINE  to wSCR-LINE-CHARS(wNumScreenRow)
              move FD-ScreenFILE-ATTRS to wSCR-LINE-ATTRS(wNumScreenRow)
        end-read
      end-perform

    end-perform
end-read

subtract 1 from wNumScreenRow

*> write a footer for the copy
add 1           to wNumSourceRowCPY wNumSourceRowCPW
move space      to wCPYSourceRow wCPWSourceRow
move all '*'    to CPY-aster CPW-aster
move '*>'       to CPY-ast1 CPW-ast1
write CPY-rec from wCPYSourceRow end-write
write CPW-rec from wCPWSourceRow end-write

add 1      to wNumSourceRowCPY
move space to  CPY-comm
string '     THIS SCREEN HAS: ' wNumScreenRow  ' screen rows.' into CPY-comm
write CPY-rec from wCPYSourceRow end-write

add 2      to wNumSourceRowCPY wNumSourceRowCPW
move space to  CPY-comm CPW-comm
string '     THIS COPY   HAS: ' wNumSourceRowCPY  ' source rows.' into CPY-comm
string '     THIS COPY   HAS: ' wNumSourceRowCPW  ' source rows.' into CPW-comm
write CPY-rec from wCPYSourceRow end-write
write CPW-rec from wCPWSourceRow end-write

*> add 1 to wNumSourceRowCPY wNumSourceRowCPW
move space      to wCPYSourceRow wCPWSourceRow
move all '*'    to CPY-aster CPW-aster
move '*>'       to CPY-ast1 CPW-ast1
write CPY-rec from wCPYSourceRow end-write
write CPW-rec from wCPWSourceRow end-write

move wNumScreenRow to lNumScreenRow
move wNumSourceRowCPY to lNumSourceRowCPY
move wNumSourceRowCPW to lNumSourceRowCPW
close FILETXT FILECPY FILECPW
goback.

END PROGRAM GC99SCREENCOPY.

IDENTIFICATION DIVISION.
Program-Id. GC99SCREENTEST is INITIAL.
*> ***********************************************************************************
*> GnuCOBOL TT (TUI TOOLS) COLLECTION
*> Purpose:    COBOL SOURCE GENERATOR FOR TESTING THE NEW SCREEN
*>             this program create and save a new .COB file, then compile and execute the test program
*> Author:     Eugenio Di Lorenzo - Italia (DILO) - eugenio.dilo@gmail.com
*> License:    Copyright 2025 E.Di Lorenzo - GNU Lesser General Public License, LGPL, 3.0 (or greater)
*> Version:    1.0 2025.02.01
*> Changelog:  1.0 first release.
*> ***********************************************************************************
ENVIRONMENT   DIVISION.
INPUT-OUTPUT  SECTION.
File-Control.
select FILECOB
    assign to tFileSpecCOB
    organization is line sequential
    file status  is FS-FILECOB.

DATA DIVISION.
FILE SECTION.
FD  FILECOB.
01  COB-rec    pic x(80).

WORKING-STORAGE SECTION.
77  FS-FILECOB            PIC XX    value space.
01  wNumSourceRowCOB      pic 9(03) value zero.
01  wSourceRow            pic x(80).
01  wSourceRowc  redefines wSourceRow.
    03                    pic x(06).
    03 O-aster.
       05 O-ast1          pic x(02).
       05 O-comm          pic x(63).
01 wCommand               pic x(200) value space.
01 ScreenTest-Area.
   03 tFileSpecCPY         pic x(60) value ' '. *> CPY filename with screen section copy source
   03 tFileSpecCPW         pic x(60) value ' '. *> CPY filename with working-storage copy source
   03 tFileSpecCOB         pic x(60) value ' '. *> COB filename with cobol source to test the screen

01 nFileSpecCPY            pic x(60) value ' '. *> CPY filename with screen section copy source
01 pFileSpecCOB            pic x(60) value ' '. *> COB filename with cobol source

LINKAGE SECTION.
01 lScreenTest-Area.
   03 lFileSpecCPY         pic x(60) value ' '. *> CPY filename with screen section copy source
   03 lFileSpecCPW         pic x(60) value ' '. *> CPY filename with working-storage copy source
   03 lFileSpecCOB         pic x(60) value ' '. *> COB filename with cobol source to test the screen

PROCEDURE DIVISION using lScreenTest-Area.
move lFileSpecCPY     to tFileSpecCPY
move lFileSpecCPW     to tFileSpecCPW
move lFileSpecCOB     to tFileSpecCOB

open output FILECOB
if FS-FILECOB not = '00' display function concat('... error FS-FILE-TEST = ' FS-FILECOB) STOP RUN end-if

move '       >>SOURCE FIXED '  to wSourceRow
add 1 to wNumSourceRowCOB
write COB-rec from wSourceRow end-write

move '       ID DIVISION.'  to wSourceRow
add 1 to wNumSourceRowCOB
write COB-rec from wSourceRow end-write

move tFileSpecCOB to pFileSpecCOB
inspect pFileSpecCOB replacing all '.COB' by '    '
move function concat('       PROGRAM-ID. ' function trim(pFileSpecCOB) '.') to wSourceRow
add 1 to wNumSourceRowCOB
write COB-rec from wSourceRow end-write

add 1           to wNumSourceRowCOB
move space      to wSourceRow
move all '*'    to o-aster
move '*>'       to o-ast1
write COB-rec from wSourceRow end-write

add 1           to wNumSourceRowCOB
move space      to wSourceRow
move ' GnuCOBOL SCREEN PAINTER - TEST PROGRAM ' to o-comm
move '*>'       to o-ast1
write COB-rec from wSourceRow end-write

add 1           to wNumSourceRowCOB
move space      to wSourceRow
move all '*'    to o-aster
move '*>'       to o-ast1
write COB-rec from wSourceRow end-write

move '       ENVIRONMENT DIVISION.'  to wSourceRow
add 1 to wNumSourceRowCOB
write COB-rec from wSourceRow end-write
move '       DATA DIVISION.'  to wSourceRow
add 1 to wNumSourceRowCOB
write COB-rec from wSourceRow end-write

move '       WORKING-STORAGE SECTION.'  to wSourceRow
add 1 to wNumSourceRowCOB
write COB-rec from wSourceRow end-write

move function concat('           copy ''' function trim(tFileSpecCPW) '''.') to wSourceRow
add 1 to wNumSourceRowCOB
write COB-rec from wSourceRow end-write

move '       SCREEN SECTION.'  to wSourceRow
add 1 to wNumSourceRowCOB
write COB-rec from wSourceRow end-write

move function concat('           copy ''' function trim(tFileSpecCPY) '''.') to wSourceRow
add 1 to wNumSourceRowCOB
write COB-rec from wSourceRow end-write

move '       PROCEDURE DIVISION.'  to wSourceRow
add 1 to wNumSourceRowCOB
write COB-rec from wSourceRow end-write

move '           set environment ''COB_LEGACY'' TO ''1'' '  to wSourceRow *> use also color codes from 8 to 15
add 1 to wNumSourceRowCOB
write COB-rec from wSourceRow end-write

move space to wSourceRow
*> prepare for 01 level name = at acreen section copy name
move tFilespecCPY to nFilespecCPY
inspect nFilespecCPY replacing all '.CPY' by '    '
move function concat('           display SCR-' function trim(nFilespecCPY) ' ') to wSourceRow
*> move '       display SCREEN001 ' to  wSourceRow
add 1 to wNumSourceRowCOB
write COB-rec from wSourceRow end-write

move space to wSourceRow
move function concat('           accept  SCR-' function trim(nFilespecCPY) ' ') to wSourceRow
*> move '       accept SCREEN001 ' to  wSourceRow
add 1 to wNumSourceRowCOB
write COB-rec from wSourceRow end-write

move '           accept omitted ' to  wSourceRow  *> useful if the screen has no input fields
add 1 to wNumSourceRowCOB
write COB-rec from wSourceRow end-write

move '           stop run.'  to wSourceRow
add 1 to wNumSourceRowCOB
write COB-rec from wSourceRow end-write

close FILECOB

*> compile the test program
STRING "cobc " delimited by size tFileSpecCOB  " -x " DELIMITED BY SIZE  INTO wCommand
CALL "SYSTEM" using wCommand
*> execute the compiled test program
move pFileSpecCOB to wCommand
CALL "SYSTEM" using wCommand

call "GC99RAIN" end-call
goback.

END PROGRAM GC99SCREENTEST.
