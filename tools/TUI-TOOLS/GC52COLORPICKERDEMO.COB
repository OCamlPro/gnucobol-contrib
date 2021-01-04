       >>SOURCE FORMAT IS FREE
REPLACE ==:BCOL:== BY ==BACKGROUND-COLOR== ==:FCOL:== BY ==FOREGROUND-COLOR==.
ID DIVISION.
PROGRAM-ID. GC52COLORPICKERDEMO.
*> ***********************************************************************************
*> GnuCOBOL TT (TUI TOOLS) COLLECTION
*> Purpose:    DEMO OF GC52COLORPICKER TUI TOOL - DISPLAYS A MESSAGE ON SCREEN THEN
*>             WHIT F1 YOU CAN ACTIVATE THE COLORPICKER TO CHANGE MESSAGE BACK & FORE COLORS
*> Tectonics:  cobc -x GC52COLORPICKERDEMO.COB -lpdcurses (compile with GnuCOBOL 3.1 or greater)
*> Usage:      GC52COLORPICKERDEMO
*> Parameters: none
*> Author:     Eugenio Di Lorenzo - Italia (DILO)
*> License:    Copyright 2017 E.Di Lorenzo - GNU Lesser General Public License, LGPL, 3.0 (or greater)
*> Version:    2.0 2021.01.01
*> Changelog:  1.0 first release.
*>             1.1 added F1 = help
*>             2.0 demo enhanced with mouse management
*> ***********************************************************************************
ENVIRONMENT DIVISION.
CONFIGURATION SECTION.
*> source-computer. WINDOWS10 64bit WITH DEBUGGING MODE.
special-names.
   Currency Sign is '€'.
   Decimal-Point is Comma.
   CRT STATUS    is wCRT-STATUS.   *> Return Code (es. PF, Arrows, TAB, Mouse Keys)
   CURSOR        is wCursorRowCol. *> Cursor Position

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

01  wBco        PIC 9  value cyan.
01 wDummy  pic x(01) VALUE     ' '.
01 i       pic 999.
01 j       pic 999.
01 wR      pic 999 value zero.
01 wC      pic 999 value zero.
01 wInt    BINARY-SHORT .

01  wCRT-STATUS         PIC 9(04) VALUE 9999.  *> CRT-STATUS codes
01  wCursorRowCol       PIC 9(6) value 0.      *> from CURSOR IS ...
01  redefines wCursorRowCol .
    05 wCursorRow       Pic 9(3).
    05 wCursorCol       Pic 9(3).

01 wFirst-Time Pic X value 'Y'.
*> SAVE/RESTORE SCREEN VARIABLES
01 wScreenName PIC X(256).
01 wiScrOk     BINARY-LONG.

*> 01 wCursorHide  BINARY-SHORT value 0.
*> 01 wCursorShow  BINARY-SHORT value 2.
*> 01 wVisibility  BINARY-SHORT.


01  wVisibilityNot   BINARY-SHORT  value 0.  *> 0 = hide cursor
01  wVisibilityYes   BINARY-SHORT  value 2.  *> 2 = cursor visible full
01  wVisibilityNew   BINARY-SHORT .
01  wVisibilityOld   BINARY-SHORT .

*>  mouse mask, apply to COB_MOUSE_FLAGS
78  COB-AUTO-MOUSE-HANDLING          VALUE 1.
78  COB-ALLOW-LEFT-DOWN              VALUE 2.
78  COB-ALLOW-LEFT-UP                VALUE 4.
78  COB-ALLOW-LEFT-DOUBLE            VALUE 8.
78  COB-ALLOW-MIDDLE-DOWN            VALUE 16.
78  COB-ALLOW-MIDDLE-UP              VALUE 32.
78  COB-ALLOW-MIDDLE-DOUBLE          VALUE 64.
78  COB-ALLOW-RIGHT-DOWN             VALUE 128.
78  COB-ALLOW-RIGHT-UP               VALUE 256.
78  COB-ALLOW-RIGHT-DOUBLE           VALUE 512.
78  COB-ALLOW-MOUSE-MOVE             VALUE 1024.
01  COB-MOUSE-FLAGS                  PIC 9(04).

copy         'GC01BOX.CPY'.
copy      'GC02BOXMEX.CPY'.
copy 'GC52COLORPICKER.CPY'.
*> COPY     'GC98KEYCODE.CPY'.
COPY 'GC97KEYCODEGC.CPY'   suppress.

*> ***********************************************************************************
*>           P R O C E D U R E   D I V I S I O N
*> ***********************************************************************************
PROCEDURE DIVISION.
  perform InitialSettings thru InitialSettingsEx
  display wDummy at 2579 with blank screen end-display  *> clear screen
  perform CursorHide thru CursorHideEx
  display ' GnuCOBOL GC52COLORPICKER TUI TOOL at work. F1= HELP, ENTER= Continue.' at 0303 with :FCOL: white :BCOL: wBco
  display ' GnuCOBOL GC52COLORPICKER TUI TOOL at work.                           ' at 2103 with :FCOL: white :BCOL: wBco
  display ' CursorKey or left single click on a colormap item to activate.       ' at 2203 with :FCOL: white :BCOL: wBco
  display ' Enter or left double click on a colormap item to select it.          ' at 2303 with :FCOL: white :BCOL: wBco
  display ' ESC or right mouse key click to exit from color picker.              ' at 2403 with :FCOL: white :BCOL: wBco
  accept wDummy at 2479 with auto no-echo size 0  :FCOL: white :BCOL: cyan end-accept
  if wCRT-STATUS = K-F1
      perform DisplayHelp thru DisplayHelpEx
  end-if
  continue.

Display-Title.
  move green          to Box-bco     move white to Box-fco
  move '001001025080' to Box-rc      move 'S'   to Box-style
  perform callGC01BOX thru callGC01BOX-ex
  display 'GnuCOBOL TUI-TOOLS (from DILO - Italy): GC52COLORPICKER at work.            ' at 0203 with :FCOL: white :BCOL: green
  display 'GnuCOBOL TUI TOOL to pick up a "color pair".                                ' at 2103 with :FCOL: white :BCOL: green
  display 'Use left mouse key click or press F1 to activate the "Color Pair Picker"    ' at 2203 with :FCOL: white :BCOL: green
  display 'Use the "Color Pair Picker" in this sample,to change colors of above message' at 2303 with :FCOL: white :BCOL: green
  display 'Use ESC or or right mouse key click to exit                                 ' at 2403 with :FCOL: white :BCOL: green
  continue.

*> ***********************************************************************************
*>
*> ***********************************************************************************
DisplayTheMessage.

  initialize Boxmex-Area ALL TO VALUE
  move low-value to Bxm-tabmex
  move ' ***  GnuCOBOL  GnuCOBOL  GnuCOBOL *** ' & x'00'       to Bxm-titDes
  move z' GnuCOBOL (formerly OpenCOBOL) is a free COBOL compiler. cobc translates ' to Bxm-mex(01)
  move z' COBOL source to executable using intermediate C, C compiler and linker. ' to Bxm-mex(02)
  move z' GnuCOBOL 2.2 has been released and is the current version.              ' to Bxm-mex(03)
  move z' A programmer"s guide, by Gary Cutler, and other documentation,          ' to Bxm-mex(04)
  move z' is indexed at http://open-cobol.sourceforge.net/                        ' to Bxm-mex(05)
  move z' OpenCOBOL was written by K.Nishida and Roger While, from 2001 to 2012.  ' to Bxm-mex(06)
  move z' GnuCOBOL is also authored by S.Sobisch, R.Norman, E.Hart, S.Kashyrin,   ' to Bxm-mex(07)
  move z' D.Pitts and B.Tiffin. Others listed in the AUTHORS and THANKS files.    ' to Bxm-mex(08)
  move z' Copyright 2001-2017 Free Software Foundation, Inc.                      ' to Bxm-mex(09)
  move space & x'00' to Bxm-mex(10)
  move '004003015077' to Bxm-rc
  if wFirst-Time = "Y" *> or Cop-Key not = K-ENTER
      move red    to Bxm-bco Bxm-titBco  move white  to Bxm-fco Bxm-titFco
      move red    to Bxm-bcoM            move yellow to Bxm-fcoM
  else
      *> if Cop-Key = K-ENTER or Cop-Key = K-LEFT-DBL-CLICK
        move Cop-BackCol to Bxm-bco Bxm-bcoM Bxm-titBco
        move Cop-ForeCol to Bxm-fco Bxm-fcoM Bxm-titFco
      *> end-if
  end-if

  move 'Y' to Bxm-tit    Bxm-titFcoH Bxm-fcoMH Bxm-fcoH
  move 'N' to Bxm-Shadow Bxm-click   Bxm-3D    Bxm-wait Bxm-OkButton
  move 'D' to Bxm-Style
  call GC02BOXMEX using BOXMEX-AREA.
  continue.

Accept-a-Key.
   *> ***********************************************************************************
   *> WAIT FOR USER ACTION
   *> ***********************************************************************************
   *> (use always a "display ...at ..."  or an "accept ... at ..." before to have a call to "initscr"
   *> call static "getch" returning Key-Pressed end-call
   accept wDummy at 2479 with auto-skip :BCOL: white :FCOL: green

   EVALUATE TRUE
       when wCRT-STATUS = K-F1 or wCRT-STATUS = K-LEFT-PRESSED
            perform ScreenSave thru ScreenSaveEx
            *> move x'B4' & ' Color Pair Picker '  & x'C3' & x'00' to Cop-titDes
            call   GC52COLORPICKER  using ColorPicker-Area
            cancel GC52COLORPICKER
            perform ScreenRestore thru ScreenRestoreEx
            move 'N' to wFirst-Time
            go to Display-Title
        when wCRT-STATUS = K-ESCAPE or wCRT-STATUS = K-RIGHT-PRESSED
             go to End-Program
       when Other
            go to Accept-a-Key
   END-EVALUATE

   continue.
End-Program.

*> ***********************************************************************************************
*> DISPLAY THE ITALIAN FLAG
*> ***********************************************************************************************

  perform DisplayItalianFlag thru DisplayItalianFlagEx
  accept wDummy at 2479

  if wCRT-STATUS = K-RIGHT-RELEASED
    perform DisplayItalianFlag thru DisplayItalianFlagEx
    accept wDummy at 2479
  end-if

  continue.
END-OF-PROGRAM.
  GOBACK.


*> ***********************************************************************************
*>
*> ***********************************************************************************
ColorPicker.
   perform ScreenSave thru ScreenSaveEx
   *> move x'B4' & ' Color Pair Picker '  & x'C3' & x'00' to Cop-titDes
   call GC52COLORPICKER  using ColorPicker-Area cancel GC52COLORPICKER
   perform ScreenRestore thru ScreenRestoreEx.
ColorPickerEx. exit.

callGC01BOX.
    call GC01BOX using by content BOX-AREA
         on exception     display ' CALL GC01BOX error. Module GC01BOX not Found !' at 0501
                          display ' type Enter to continue without boxes ...      ' at 0601
                          accept OMITTED
         not on exception continue
    end-call
    continue.
callGC01BOX-ex. exit.

DisplayHelp.
    perform ScreenSave thru ScreenSaveEx
    *> DISPLAY THE FRAME AND THE HELP TEXT
    initialize Boxmex-Area ALL TO VALUE
    move low-value to Bxm-tabmex
    move z'                               ' to Bxm-mex(01)
    move z' Use left mouse button         ' to Bxm-mex(02)
    move z' (singleclick)                 ' to Bxm-mex(03)
    move z' or cursor,tab,page,space keys ' to Bxm-mex(04)
    move z' to activate a colormap item   ' to Bxm-mex(05)
    move z'                               ' to Bxm-mex(06)
    move z'                               ' to Bxm-mex(07)
    move z'                               ' to Bxm-mex(08)
    move z' Enter, left mouse button      ' to Bxm-mex(09)
    move z' (doubleclick) to select       ' to Bxm-mex(10)
    move z'                               ' to Bxm-mex(11)
    move z' ESC or right mouse button     ' to Bxm-mex(12)
    move z' to exit from color picker     ' to Bxm-mex(13)
    move z'                               ' to Bxm-mex(14)
    move z'                               ' to Bxm-mex(15)
    move z' eugenio.dilo@gmail.com   2020 ' to Bxm-mex(16)
    move z'                               ' to Bxm-mex(17)
    move z' hit <enter> to continue ...   ' to Bxm-mex(18)

    move cyan     to Bxm-bco    Bxm-titBco Bxm-bcoM
    move white    to Bxm-fco    Bxm-titFco Bxm-fcoM
    move 'Y'      to Bxm-Click  Bxm-tit
    move 'N'      to Bxm-3D     Bxm-OkButton
    move 'S'      to Bxm-style
    move x'B4' & ' GnuCOBOL Color Picker - HELP '  & x'C3' & x'00' to Bxm-titDes
   compute Bxm-r1 = 05             compute Bxm-c1 = 10
   compute Bxm-r2 = Bxm-r1 + 19    compute Bxm-c2 = Bxm-c1 + 32
   call GC02BOXMEX using by content BOXMEX-AREA
        on exception display 'CALL GC02BOXMEX error. Module GC02BOXMEX not Found.'
        accept OMITTED
   end-call
   perform ScreenRestore thru ScreenRestoreEx.
DisplayHelpEx. exit.

InitialSettings.
  *> sets in order to detect the PgUp, PgDn, PrtSc(screen print), Esc keys,
  set environment 'COB_SCREEN_EXCEPTIONS' TO 'Y'.
  set environment 'COB_SCREEN_ESC'        TO 'Y'.

  *> make mouse active
  COMPUTE COB-MOUSE-FLAGS = COB-AUTO-MOUSE-HANDLING
                      + COB-ALLOW-LEFT-DOWN   + COB-ALLOW-MIDDLE-DOWN   + COB-ALLOW-RIGHT-DOWN
                      + COB-ALLOW-LEFT-UP     + COB-ALLOW-MIDDLE-UP     + COB-ALLOW-RIGHT-UP
                      + COB-ALLOW-LEFT-DOUBLE + COB-ALLOW-MIDDLE-DOUBLE + COB-ALLOW-RIGHT-DOUBLE
                      + COB-ALLOW-MOUSE-MOVE
  SET environment     "COB_MOUSE_FLAGS"         to COB-MOUSE-FLAGS

  continue.
InitialSettingsEx. exit.

ScreenSave.
   move Z'GC52COLORPICKERDEMO.SCR' to wScreenName
   call static 'scr_dump' using by reference wScreenName returning wiScrOk end-call.
ScreenSaveEx. exit.

ScreenRestore.
   call static 'scr_restore' using by reference wScreenName returning wiScrOk end-call
   CALL 'CBL_DELETE_FILE' USING wScreenName.
ScreenRestoreEx. exit.


CursorHide.
    *> save cursor state and hide the cursor
    *> (use always a "display ...at ..."  or an "accept ... at ..." before to have a call to "initscr"
    move wVisibilityNot to wVisibilityNew
    call static "curs_set" using by value wVisibilityNew returning wVisibilityOld end-call
    continue.
CursorHideEx. exit.

CursorShow.
    *> show the cursor - reset to its saved previous state
    move wVisibilityOld to wVisibilityNew
    call static "curs_set" using by value wVisibilityNew returning wVisibilityOld end-call
    continue.
CursorShowEx. exit.

DisplayItalianFlag.
  initialize Box-area ALL TO VALUE
  *> display a big box as background
  move cyan     to Box-bco   set Box-fco   to white
  move '001001' to Box-r1c1  move '025080' to Box-r2c2
  move 'D'      to Box-style move 'N'      to Box-3D
  perform callGC01BOX thru callGC01BOX-ex

  display ' GnuCOBOL TUI-TOOLS (from DILO - Italy): GC52COLORPICKER at work.' at 003003 with :FCOL: white :BCOL: cyan
  display ' < End of Demo > ... Enter to exit ...'                            at 023003 with :FCOL: white :BCOL: cyan

  move '009035014048' to Box-rc
  move black          to Box-bco  move 'S' to Box-style
  perform callGC01BOX thru callGC01BOX-ex
  display '    ' at 010036 with foreground-color white background-color Green end-display
  display '    ' at 011036 with foreground-color white background-color Green end-display
  display '    ' at 012036 with foreground-color white background-color Green end-display
  display '    ' at 013036 with foreground-color white background-color Green end-display
  display '    ' at 010040 with blink foreground-color white background-color white end-display
  display '    ' at 011040 with blink foreground-color white background-color white end-display
  display '    ' at 012040 with blink foreground-color white background-color white end-display
  display '    ' at 013040 with blink foreground-color white background-color white end-display
  display '    ' at 010044 with blink foreground-color white background-color red   end-display
  display '    ' at 011044 with blink foreground-color white background-color red   end-display
  display '    ' at 012044 with blink foreground-color white background-color red   end-display
  display '    ' at 013044 with blink foreground-color white background-color red   end-display
  continue.
DisplayItalianFlagEx. exit.

End Program GC52COLORPICKERDEMO.
