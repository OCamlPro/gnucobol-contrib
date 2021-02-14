       >> SOURCE FORMAT IS FREE
REPLACE ==:BCOL:== BY ==BACKGROUND-COLOR== ==:FCOL:== BY ==FOREGROUND-COLOR==.
ID DIVISION.
PROGRAM-ID. GC03YESNODEMO.
*> ***********************************************************************************
*> GnuCOBOL TT (TUI TOOLS) COLLECTION
*> Purpose:    DEMO OF GC03YESNO -  DISPLAYS A YES & NO BOX
*> Tectonics:  cobc -x GC03YESNODEMO.COB -lpdcurses (compile with GnuCOBOL 3.1 or greater)
*> Usage:      GC03YESNODEMO
*> Parameters: none
*> Author:     Eugenio Di Lorenzo - Italia (DILO)
*> License:    (c)2021.02.02 E.Di Lorenzo - GNU Lesser General Public License, LGPL, 3.0 (or greater)
*> Version:    2.0 20210202
*> Changelog:  1.0 first release.
*>             2.0 mouse management added
*> ***********************************************************************************
ENVIRONMENT DIVISION.
CONFIGURATION SECTION.
SPECIAL-NAMES.
    CRT STATUS IS wCRT-STATUS.    *> Return Code from Accept (ex.PF Keys, Mouse Keys)
    CURSOR     IS wCursorRowCol.  *> Cursor Position
DATA DIVISION.
WORKING-STORAGE SECTION.
copy GC00COLORS.CPY.

*>  mouse mask, apply to COB_MOUSE_FLAGS
78  COB-AUTO-MOUSE-HANDLING   VALUE 1.
78  COB-ALLOW-LEFT-DOWN       VALUE 2.
78  COB-ALLOW-LEFT-UP         VALUE 4.
78  COB-ALLOW-LEFT-DOUBLE     VALUE 8.
78  COB-ALLOW-MIDDLE-DOWN     VALUE 16.
78  COB-ALLOW-MIDDLE-UP       VALUE 32.
78  COB-ALLOW-MIDDLE-DOUBLE   VALUE 64.
78  COB-ALLOW-RIGHT-DOWN      VALUE 128.
78  COB-ALLOW-RIGHT-UP        VALUE 256.
78  COB-ALLOW-RIGHT-DOUBLE    VALUE 512.
78  COB-ALLOW-MOUSE-MOVE      VALUE 1024.
01  COB-MOUSE-FLAGS           PIC 9(04).

01  wDummy              PIC X(01) VALUE SPACE.
01  wCRT-STATUS         PIC 9(04) VALUE 9999.

01  wCursorRowCol       PIC 9(06) value 0000.
01  redefines wCursorRowCol .
    05 wCursorRow       Pic 9(03).
    05 wCursorCol       Pic 9(03).

01  wColorCode         pic 9(02).
01  wColorDes          pic x(12).
01  wYn-BcoNonSelDes   pic x(12).
01  wYn-FcoNonSelDes   pic x(12).
01  wYn-BcoSelDes      pic x(12).
01  wYn-FcoSelDes      pic x(12).

COPY 'GC01BOX.CPY'.
COPY 'GC03YESNO.CPY'.
copy 'GC97KEYCODEGC.CPY'  suppress.

*> **************************************************************
*>           P R O C E D U R E   D I V I S I O N
*> **************************************************************
PROCEDURE DIVISION.

perform InitialSettings thru InitialSettingsEx
*> clear the screen
*> display wDummy at 2579 with blank screen end-display

*> BIG BOX as BACKGROUD
move red   to Box-bco
move white to Box-fco
move 'S'   to Box-style
move 'N'   to Yn-Shadow
move '001001025080' to Box-rc
call GC01BOX using BOX-AREA

Display ' GnuCOBOL TUI-TOOLS: GC02YESNO at work.'
        at 003002 :BCOL: red :FCOL: yellow highlight end-display
Display " use cursor keys,mouse left singleclcik,tab/backtab,pgup/dn to change button"
        at 018002 :BCOL: red :FCOL: yellow highlight end-display
Display " use Enter or mouse left doubleclick to select and exit"
        at 019002 :BCOL: red :FCOL: yellow highlight end-display
Display " use ESC or other char or mouse right single or doubleclick to to exit"
        at 020002 :BCOL: red :FCOL: yellow highlight end-display
Display " to change colors: ALT-F2/F3 back/foreground of TOOL "
        at 021002 :BCOL: red :FCOL: yellow highlight end-display
Display " to change colors: ALT-F4/F5 back/foreground of active button "
        at 022002 :BCOL: red :FCOL: yellow highlight end-display
Display " to reset colors: ALT-F9 "
        at 023002 :BCOL: red :FCOL: yellow highlight end-display

*> **************************************************************
*>          CALL THE  YESNO  TOOL
*> **************************************************************
set Yn-BcoNonSel to Yellow
set Yn-FcoNonSel to LightRed
set Yn-BcoSel    to LightMagenta
set Yn-FcoSel    to LightWhite
move '006033' to Yn-rc
call GC03YESNO using YESNO-AREA

move  Yn-BcoNonSel to wColorCode
perform DecodeColor thru DecodeColorEx
move wColorDes to wYn-BcoNonSelDes
display "BcoNonSel"  at 006003 Yn-BcoNonSel at 006013 wYn-BcoNonSelDes at 006016
move  Yn-FcoNonSel to wColorCode
perform DecodeColor thru DecodeColorEx
move wColorDes to wYn-FcoNonSelDes
display "FcoNonSel"  at 007003 Yn-FcoNonSel at 007013 wYn-FcoNonSelDes at 007016

move  Yn-BcoSel to wColorCode
perform DecodeColor thru DecodeColorEx
move wColorDes to wYn-BcoSelDes
display "BcoSel"  at 008003 Yn-BcoSel at 008013 wYn-BcoSelDes at 008016
move  Yn-FcoSel to wColorCode
perform DecodeColor thru DecodeColorEx
move wColorDes to wYn-FcoSelDes
display "FcoSel"  at 009003 Yn-FcoSel at 009013 wYn-FcoSelDes at 009016

display "return value = "  at 011003  Yn-YESNO  at 011019
display "return Key   = "  at 012003  Yn-Key    at 012019
accept omitted

*> ***********************************************************************************************
*> DISPLAY END OF PROGRAM SCREEN
*> ***********************************************************************************************
    initialize Box-area ALL TO VALUE
    *> display a big box as background
    move cyan     to Box-bco   set Box-fco to white
    move '001001' to Box-r1c1  move '025080' to Box-r2c2
    move 'D'      to Box-style move 'N'      to Box-3D
    perform callGC01BOX thru callGC01BOX-ex

    display ' GnuCOBOL TUI-TOOLS (from DILO - Italy): GC02YESNO at work.'
             at 003003 with      :FCOL: white :BCOL: cyan
    display ' < End of Demo > ... Enter to exit ...'
             at 023003 with      :FCOL: white :BCOL: cyan
    move '009035014048' to Box-rc
    move black to Box-bco
    move 'S' to Box-style
    perform callGC01BOX thru callGC01BOX-ex

   *> DISPLAY ITALIAN FLAG
   display '    ' at 010036 with       :FCOL: white :BCOL: Green end-display
   display '    ' at 011036 with       :FCOL: white :BCOL: Green end-display
   display '    ' at 012036 with       :FCOL: white :BCOL: Green end-display
   display '    ' at 013036 with       :FCOL: white :BCOL: Green end-display
   display '    ' at 010040 with blink :FCOL: white :BCOL: white end-display
   display '    ' at 011040 with blink :FCOL: white :BCOL: white end-display
   display '    ' at 012040 with blink :FCOL: white :BCOL: white end-display
   display '    ' at 013040 with blink :FCOL: white :BCOL: white end-display
   display '    ' at 010044 with blink :FCOL: white :BCOL: red   end-display
   display '    ' at 011044 with blink :FCOL: white :BCOL: red   end-display
   display '    ' at 012044 with blink :FCOL: white :BCOL: red   end-display
   display '    ' at 013044 with blink :FCOL: white :BCOL: red   end-display
   accept wDummy at 2479

   goback.


*> ***********************************************************************************************
*>
*> ***********************************************************************************************
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


callGC01BOX.
    call GC01BOX using by reference BOX-AREA
         on exception     display ' CALL GC01BOX error. Module GC01BOX not Found !' at 0501
                          display ' type Enter to continue without boxes ...      ' at 0601
                          accept OMITTED
         not on exception continue
    end-call
    continue.
callGC01BOX-ex. exit.


DecodeColor.
   evaluate true
        when wColorCode = Black        move "Black       "      to wColorDes
        when wColorCode = Blue         move "Blue        "      to wColorDes
        when wColorCode = Green        move "Green       "      to wColorDes
        when wColorCode = Cyan         move "Cyan        "      to wColorDes
        when wColorCode = Red          move "Red         "      to wColorDes
        when wColorCode = Magenta      move "Magenta     "      to wColorDes
        when wColorCode = Brown        move "Brown       "      to wColorDes
        when wColorCode = White        move "White       "      to wColorDes
        when wColorCode = Grey         move "Grey        "      to wColorDes
        when wColorCode = LightBlue    move "LightBlue   "      to wColorDes
        when wColorCode = LightGreen   move "LightGreen  "      to wColorDes
        when wColorCode = LightCyan    move "LightCyan   "      to wColorDes
        when wColorCode = LightRed     move "LightRed    "      to wColorDes
        when wColorCode = LightMagenta move "LightMagenta"      to wColorDes
        when wColorCode = Yellow       move "Yellow      "      to wColorDes
        when wColorCode = LightWhite   move "LightWhite  "      to wColorDes
   end-evaluate
   continue.
DecodeColorEx. exit.

End Program GC03YESNODEMO.
