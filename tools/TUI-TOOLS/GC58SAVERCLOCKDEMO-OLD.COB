       >>SOURCE FORMAT IS FREE
ID DIVISION.
program-id. GC58SAVERCLOCKDEMO.
*> ***********************************************************************************
*> GnuCOBOL TT (TUI TOOLS) COLLECTION
*> Purpose:    DEMO OF GC58SAVERCLOCK -  SCREEN SAVER WITH A BIG CLOCK
*> Tectonics:  cobc -x GC58SAVERCLOCKDEMO.COB (use GnuCOBOL 2.0 or greater)
*> Usage:      GC58SAVERCLOCKDEMO
*> Parameters: none
*> Author:     Eugenio Di Lorenzo - Italia (DILO)
*> License:    Copyright 2016 E.Di Lorenzo - GNU Lesser General Public License, 3.0 (or greater)
*> Version:    1.0 2016.06.15
*> Changelog:  1.0 first release.
*> ***********************************************************************************
ENVIRONMENT DIVISION.
CONFIGURATION SECTION.
SPECIAL-NAMES.  CRT STATUS IS wCRT-STATUS.
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

01  TimeX              pic  x(15).

01  wTime.
   03 wTimehh         pic  9(2).
   03 wTimemm         pic  9(2).
   03 wTimess         pic  9(2).
   03 wTimecc         pic  9(2).
01 wTimeR  redefines wTime pic 9(8) .
01  wTime2.
   03 wTimehh         pic  9(2).
   03 wTimemm         pic  9(2).
   03 wTimess         pic  9(2).
   03 wTimecc         pic  9(2).
01 wTime2R  redefines wTime2 pic 9(8) .
01  wDiff             pic  9(8).

copy   'GC02BOXMEX.CPY'.
copy      'GC01BOX.CPY'.
copy   'GC58SAVERCLOCK.CPY'.

01 wDummy        pic x(01) VALUE ' '.
01 GnuCOBOLdemo pic x(480) value
   "   ____               ____ ___  ____   ___  _           _                       " &
   "  / ___|_ __  _   _  / ___/ _ \| __ ) / _ \| |       __| | ___ _ __ ___   ___   " &
   " | |  _| '_ \| | | || |  | | | |  _ \| | | | |      / _` |/ _ \ '_ ` _ \ / _ \  " &
   " | |_| | | | | |_| || |__| |_| | |_) | |_| | |___  | (_| |  __/ | | | | | (_) | " &
   "  \____|_| |_|\__,_| \____\___/|____/ \___/|_____|  \__,_|\___|_| |_| |_|\___/  ".
01 GnuCOBOLdemoR redefines GnuCOBOLdemo.
   03 rGnu PIC X(80) occurs 6.

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
   accept wTime2 from time

   *> ***************************************************************************
   *> loop to display time every 1 sec
   *> ***************************************************************************
   PERFORM FOREVER
     accept wDummy at 025080 with AUTO TIMEOUT 1 end-accept
     *> accept whitout value returns 8001 to CRT-STATUS
     IF wCRT-STATUS NOT = 8001 EXIT PERFORM END-IF
     accept wTime from time
     string ' Time ' wTime(1:2) ':' wTime(3:2) ':' wTime(5:2) delimited by size into TimeX end-string
     display TimeX at 002066 with foreground-color white background-color Red end-display

     *> ***************************************************************************
     *> after 10 seconds start the SCREEN SAVER
     *> ***************************************************************************
     compute wDiff = wTimeR - wTime2R
     if wDiff > 1000
        call GC58SAVERCLOCK using Saver-Area
        go to Main
     end-if

   END-PERFORM

   *> which key was pressed ?
   EVALUATE wCRT-STATUS
    WHEN  K-ENTER
          Perform About thru AboutEx
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
   ACCEPT wDUMMY with NO-ECHO
   GOBACK.

*> ****************************************************************************
Display-Cover.
    set  Box-fco Box-bco to Red
    move '002001024080'  to Box-rc
    move 'N'             to Box-style Box-3D
    call GC01BOX using BOX-AREA.

    display rGnu(1) at 010001 with background-color Red foreground-color White highlight
    display rGnu(2) at 011001 with background-color Red foreground-color White highlight
    display rGnu(3) at 012001 with background-color Red foreground-color White highlight
    display rGnu(4) at 013001 with background-color Red foreground-color White highlight
    display rGnu(5) at 014001 with background-color Red foreground-color White highlight
    display rGnu(6) at 015001 with background-color Red foreground-color White highlight

    DISPLAY "GnuCOBOL 2.0 TEXT USER INTERFACE TOOLS COLLECTION " AT 017016
             with foreground-color white background-color red.

    DISPLAY "wait ten seconds and SCREEN SAVER will be started " AT 018016
             with foreground-color white background-color red.
    DISPLAY "------------------------------------------------- " AT 019016
             with foreground-color white background-color red.
    ACCEPT wUserName FROM USER NAME end-accept.
    STRING " User: " wUserName into wSTRING.
    DISPLAY wSTRING AT 002001 with foreground-color white background-color red.
    ACCEPT wLINES   from LINES; ACCEPT wCOLUMNS from COLUMNS
    STRING " Screen of " wLINES " x " wCOLUMNS  " - Press a key to Enter, ESCAPE to EXIT. " into wSTRING.
    DISPLAY wSTRING AT 023001 with foreground-color white background-color red.
Display-CoverEx. Exit.

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

Move '37YSabcdefghiYYRNN37YYYN77Y' to Bxm-Parameters
move '004005021073'                to Bxm-rc
call GC02BOXMEX using BOXMEX-AREA.
AboutEx. Exit.

End Program GC58SAVERCLOCKDEMO.
