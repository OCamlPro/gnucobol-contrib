       >> SOURCE FORMAT IS FREE
REPLACE ==:BCOL:== BY ==BACKGROUND-COLOR== ; ==:FCOL:== BY ==FOREGROUND-COLOR==.
ID DIVISION.
PROGRAM-ID. GC56DATEPICKERDEMO.
*> ***********************************************************************************
*> GnuCOBOL TT (TUI TOOLS) COLLECTION
*> Purpose:    DEMO OF GC56DATEPICKER
*> Tectonics:  cobc -x GC56DATEPICKERDEMO.COB (use GnuCOBOL 3.1 or greater)
*> Usage:      GC56DATEPICKERDEMO
*> Parameters: none
*> Author:     Eugenio Di Lorenzo - Italia (DILO) - eugenio.dilo@gmail.com
*> License:    (C) 2021 E.Di Lorenzo - GNU Lesser General Public License, LGPL, 3.0 (or greater)
*> Version:    1.1 2016.10.14
*> Changelog:  1.0 first release.
*>             1.1 small enhancement (legend , toggle legend)
*>             1.4 ALT-F6 change language, set language on 2nd call
*>             2.0 from call getch to accept dummy, added mouse management
*> ***********************************************************************************
ENVIRONMENT DIVISION.
CONFIGURATION SECTION.
SPECIAL-NAMES.
    CRT STATUS IS wCRT-STATUS.    *> Return Code from Accept (ex.PF Keys, Mouse Keys)
    CURSOR     IS wCursorRowCol.  *> Cursor Position
DATA DIVISION.
WORKING-STORAGE SECTION.
copy 'GC00COLORS.CPY'.

01  i    pic 999.
01  j    pic 999.
01  wR   pic 999 value zero.
01  wC   pic 999 value zero.
01 wInt  BINARY-SHORT . *> SIGNED.

01  wDummy              PIC X(01) VALUE SPACE.
01  wCRT-STATUS         PIC 9(04) VALUE 9999.

01  wCursorRowCol       PIC 9(06) value 0000.
01  redefines wCursorRowCol .
    05 wCursorRow       Pic 9(03).
    05 wCursorCol       Pic 9(03).

copy 'GC01BOX.CPY'         suppress.
copy 'GC56DATEPICKER.CPY'  suppress.
COPY 'GC97KEYCODEGC.CPY'   suppress.

*> ***********************************************************************************
*>           P R O C E D U R E   D I V I S I O N
*> ***********************************************************************************
PROCEDURE DIVISION.

perform InitialSettings thru InitialSettingsEx

initialize Box-area ALL TO VALUE
set  Box-bco  to white
set  Box-fco  to green
move '001001' to Box-r1c1
move '025080' to Box-r2c2
move 'S'      to Box-style
*> move "R" to Box-3D
move 'Y' to Box-tit
    move green   to Box-titBco
    move white   to Box-titFco
    move 'Y'     to Box-titFcoH
move z' Date Picker DEMO (version with MOUSE MANAGEMENT) ' to Box-titDES
perform callGC01BOX thru callGC01BOX-ex

display 'Use cursor right/left to next/prev day, cursor down/up to next/prev week   ' at 1603 :BCOL:  Box-Bco :FCOL: blue highlight
display 'Page Down, Tab = next month; Page Up, Backtab = previous month             ' at 1703 :BCOL:  Box-Bco :FCOL: blue highlight
display '+ = next year; - = previuos year; C = jump to current date                 ' at 1803 :BCOL:  Box-Bco :FCOL: blue highlight
display 'ALT-F1/F2= change fore/backcolor: ALT-F3= chg borders; ALT-F4= toggle title' at 1903 :BCOL:  Box-Bco :FCOL: blue highlight
display 'ALT-F5= toggle shadow; ALT-F6= lang.EN/IT/FR/ES/DE/NL ALT-F7=chg 3D borders' at 2003 :BCOL:  Box-Bco :FCOL: blue highlight
display 'ALT-F8= toggle legend, Enter= select date,return to caller; Esc= exit      ' at 2103 :BCOL:  Box-Bco :FCOL: blue highlight
display 'F1= Help; mouse click on month or on year: left = next, right = previous   ' at 2203 :BCOL:  green   :FCOL: white highlight

*> first calendar. small size, start from currente date
initialize DatePicker-Area ALL TO VALUE
Move 'S' to Dtp-style
move 'S' to Dtp-dim      *> Standard Size Calendar
move '003013' to Dtp-r1c1
call   GC56DATEPICKER  using DatePicker-Area
cancel GC56DATEPICKER

display 'Date selected....: '  at 2303 :BCOL:  Box-Bco :FCOL: red highlight
display  Dtp-DateSel           at 2322 :BCOL:  Box-Bco :FCOL: red highlight
display ' - With key: '        at 2331 :BCOL:  Box-Bco :FCOL: red highlight
display   Dtp-Key              at 2344 :BCOL:  Box-Bco :FCOL: red highlight
accept wDummy at 2479

*> second calendar. big size, set a date from start the calendar (not using current date)
initialize Box-area ALL TO VALUE
initialize DatePicker-Area ALL TO VALUE
move '20190907' to Dtp-DateSel
MOVE 'N' to Dtp-shadow
Move 'N' to Dtp-style
MOVE 'B' to Dtp-dim      *> Big Size Calendar
move 4 to Dtp-Lan        *> display in spanish
move red  to Dtp-bco
move brown to Dtp-fco
Move 'N' to Dtp-tit
move x'B4' & ' Calendar '  & x'C3' & x'00' to Dtp-titDes
move '003042' to Dtp-r1c1
call   GC56DATEPICKER  using DatePicker-Area
cancel GC56DATEPICKER

display 'Date selected....: '  at 2403 :BCOL:  Box-Bco :FCOL: red highlight
display Dtp-DateSel            at 2422 :BCOL:  Box-Bco :FCOL: red highlight
display ' - With key: '        at 2431 :BCOL:  Box-Bco :FCOL: red highlight
display Dtp-Key                at 2444 :BCOL:  Box-Bco :FCOL: red highlight
accept wDummy at 2479

*> ***********************************************************************************************
*> DISPLAY THE CLOSING SCREEN
*> ***********************************************************************************************
perform DisplayClosingScreen thru DisplayClosingScreenEx
accept wDummy at 2479

if wCRT-STATUS = K-RIGHT-RELEASED
  perform DisplayClosingScreen thru DisplayClosingScreenEx
  accept wDummy at 2479
end-if

goback.

*> ***********************************************************************************************
*>
*> ***********************************************************************************************
InitialSettings.
  *> sets in order to detect the PgUp, PgDn, PrtSc(screen print), Esc keys,
  set environment 'COB_SCREEN_EXCEPTIONS' TO 'Y'.
  set environment 'COB_SCREEN_ESC'        TO 'Y'.

  *> make mouse active
  COMPUTE SET-MOUSE-FLAGS = SET-AUTO-MOUSE-HANDLING
                      + SET-LEFT-DOWN   + SET-MIDDLE-DOWN   + SET-RIGHT-DOWN
                      + SET-LEFT-UP     + SET-MIDDLE-UP     + SET-RIGHT-UP
                      + SET-LEFT-DOUBLE + SET-MIDDLE-DOUBLE + SET-RIGHT-DOUBLE
                      + SET-MOUSE-MOVE
  SET environment     "COB_MOUSE_FLAGS"         to SET-MOUSE-FLAGS
  continue.
InitialSettingsEx. exit.

DisplayClosingScreen.
  initialize Box-area ALL TO VALUE
  *> display a big box as background
  move cyan     to Box-bco   set Box-fco   to white
  move '001001' to Box-r1c1  move '025080' to Box-r2c2
  move 'D'      to Box-style move 'N'      to Box-3D
  perform callGC01BOX thru callGC01BOX-ex

  display ' GnuCOBOL TUI-TOOLS (from DILO - Italy): GC56DATEPICKER at work.' at 003003 with :FCOL: white :BCOL: cyan
  display ' < End of Demo > ... Enter to exit ...'                           at 023003 with :FCOL: white :BCOL: cyan

  move '009035014048' to Box-rc
  move black          to Box-bco  move 'S' to Box-style
  perform callGC01BOX thru callGC01BOX-ex
  *> Italian Flag
  display '    ' at 010036 :BCOL: Green :FCOL:  white
  display '    ' at 011036 :BCOL: Green :FCOL: white
  display '    ' at 012036 :BCOL: Green :FCOL: white
  display '    ' at 013036 :BCOL: Green :FCOL: white
  display '    ' at 010040 :BCOL: white :FCOL: white blink
  display '    ' at 011040 :BCOL: white :FCOL: white blink
  display '    ' at 012040 :BCOL: white :FCOL: white blink
  display '    ' at 013040 :BCOL: white :FCOL: white blink
  display '    ' at 010044 :BCOL: red   :FCOL: white blink
  display '    ' at 011044 :BCOL: red   :FCOL: white blink
  display '    ' at 012044 :BCOL: red   :FCOL: white blink
  display '    ' at 013044 :BCOL: red   :FCOL: white blink
  continue.
DisplayClosingScreenEx. exit.

callGC01BOX.
    call GC01BOX using by content BOX-AREA
         on exception     display ' CALL GC01BOX error. Module GC01BOX not Found !' at 0501
                          display ' type Enter to continue without boxes ...      ' at 0601
                          accept OMITTED
         not on exception continue
    end-call
    continue.
callGC01BOX-ex. exit.

End Program GC56DATEPICKERDEMO.
