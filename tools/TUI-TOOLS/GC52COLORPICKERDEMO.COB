       >>SOURCE FORMAT IS FREE
ID DIVISION.
PROGRAM-ID. GC52COLORPICKERDEMO.
*> ***********************************************************************************
*> GnuCOBOL TT (TUI TOOLS) COLLECTION
*> Purpose:    DEMO OF GC52COLORPICKER USAGE
*> Tectonics:  cobc -x GC52COLORPICKERDEMO.COB (use GnuCOBOL 2.0 or greater)
*> Usage:      GC52COLORPICKERDEMO
*> Parameters: none
*> Author:     Eugenio Di Lorenzo - Italia (DILO)
*> License:    Copyright 2017 E.Di Lorenzo - GNU Lesser General Public License, LGPL, 3.0 (or greater)
*> Version:    1.0 2017.12.12
*> Changelog:  1.0 first release.
*> ***********************************************************************************
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
01 wDummy            pic x(01) VALUE     ' '.
01  i    pic 999.
01  j    pic 999.
01  wR   pic 999 value zero.
01  wC   pic 999 value zero.
01 wInt        BINARY-SHORT . *>  SIGNED.

01 wFirst-Time Pic X value 'Y'.
*> SAVE/RESTORE SCREEN VARIABLES
01 wScreenName        PIC X(256).
01 wiScrOk            BINARY-LONG.


01 wCursorHide  BINARY-SHORT value 0. *>  SIGNED.
01 wCursorShow  BINARY-SHORT value 2. *>  SIGNED.
01 wVisibility  BINARY-SHORT.         *>  SIGNED.

copy 'GC01BOX.CPY'.
copy 'GC02BOXMEX.CPY'.
copy 'GC52COLORPICKER.CPY'.
COPY 'GC09BUTTONS.CPY'.
COPY 'GC98KEYCODE.CPY'.
*> ***********************************************************************************
*>           P R O C E D U R E   D I V I S I O N
*> ***********************************************************************************
PROCEDURE DIVISION.
    *> sets in order to detect the PgUp, PgDn, PrtSc(screen print), Esc keys,
    set environment 'COB_SCREEN_EXCEPTIONS' TO 'Y'.
    set environment 'COB_SCREEN_ESC'        TO 'Y'.

    *> clear screen
    display wDummy at 2579 with blank screen end-display
    *> hide the cursor (use always a display or an accept at .... before to have a call to "initscr"
    call static 'curs_set' using by value wCursorHide returning wVisibility end-call
    continue.

loop0.
    move green          to Box-bco
    move white          to Box-fco

    move '001001025080' to Box-rc
    move 'S'            to Box-style
    call GC01BOX using Box-Area
    display ' GnuCOBOL TUI TOOL to pick up a "color pair".'
          at 2103 with foreground-color white background-color green
    display ' See the GC52COLORPICKER at work.'
          at 2203 with foreground-color white background-color green
    display ' press F1 to activate the "Color pair Picker" and change colors of message.'
          at 2303 with foreground-color white background-color green
    display ' press ESC to exit.'
          at 2403 with foreground-color white background-color green

    initialize Boxmex-Area ALL TO VALUE
    continue.

*> ***********************************************************************************
*>
*> ***********************************************************************************
loop1.
    move low-value to Bxm-tabmex

    move ' *** GnuCOBOL GnuCOBOL GnuCOBOL *** ' & x'00'       to Bxm-titDes
    move z' GnuCOBOL is an open-source COBOL compiler and runtime environment.      ' to Bxm-mex(01)
    move z' The GnuCOBOL compiler generates C code which is automatically compiled  ' to Bxm-mex(02)
    move z' and linked. While originally developed for UNIX operating systems,      ' to Bxm-mex(03)
    move z' GnuCOBOL has also been successfully built for OSX computers or Windows  ' to Bxm-mex(04)
    move z' computers utilizing the UNIX-emulation features of such tools as Cygwin ' to Bxm-mex(05)
    move z' and MinGW. It has also been built as a truly native Windows application ' to Bxm-mex(06)
    move z' utilizing Microsoft"s freely-downloadable Visual Studio Express package ' to Bxm-mex(07)
    move z' to provide the C compiler and linker/loader.The principal developers of ' to Bxm-mex(08)
    move z' GnuCOBOL are Keisuke Nishida and Roger While.                           ' to Bxm-mex(09)
    move space & x'00' to Bxm-mex(10)

    move '004003015077' to Bxm-rc
    if wFirst-Time = "Y"
       continue
       move red    to Bxm-bco Bxm-titBco
       move white  to Bxm-fco Bxm-titFco
       move red    to Bxm-bcoM
       move yellow to Bxm-fcoM
    else
       if Cop-Key = Key-Enter
          move Cop-BackCol to Bxm-bco Bxm-bcoM Bxm-titBco
          move Cop-ForeCol to Bxm-fco Bxm-fcoM Bxm-titFco
       end-if
    end-if

    move 'Y' to Bxm-tit         Bxm-titFcoH
    move 'Y' to Bxm-fcoMH       Bxm-fcoH
    move 'N' to Bxm-Shadow      Bxm-click
    move 'N' to Bxm-3D Bxm-wait Bxm-OkButton
    move 'D' to Bxm-Style
    call GC02BOXMEX using BOXMEX-AREA.

    continue.

loop2.
   *> ***********************************************************************************
   *> WAIT FOR USER INPUT
   *> ***********************************************************************************
   *> (use always a "display ...at ..."  or an "accept ... at ..." before to have a call to "initscr"
   call static "getch" returning Key-Pressed end-call

   EVALUATE TRUE
      when Key-Pressed = Key-F1
            perform ColorPicker thru ColorPickerEx
            move 'N' to wFirst-Time
            go to loop1
      when Other
            continue
   END-EVALUATE

   *> test if the user pressed Escape key
   IF Key-Pressed = Key-Escape go to End-Program else go to loop2 end-if
   continue.

End-Program.

    *> clear screen
    display wDummy at 2579 with blank screen end-display
    display ' GnuCOBOL TUI TOOL to pick up a "color pair" - END OF DEMO.'
          at 0301 with foreground-color white background-color green
    *> DISPLAY ITALIAN FLAG
     move '009036014049' to Box-rc
     move black to Box-bco
     move 'S' to Box-style
     call  GC01BOX using BOX-AREA

     display '    ' at 010037 with       background-color Green end-display
     display '    ' at 011037 with       background-color Green end-display
     display '    ' at 012037 with       background-color Green end-display
     display '    ' at 013037 with       background-color Green end-display
     display '    ' at 010041 with blink background-color white end-display
     display '    ' at 011041 with blink background-color white end-display
     display '    ' at 012041 with blink background-color white end-display
     display '    ' at 013041 with blink background-color white end-display
     display '    ' at 010045 with blink background-color red   end-display
     display '    ' at 011045 with blink background-color red   end-display
     display '    ' at 012045 with blink background-color red   end-display
     display '    ' at 013045 with blink background-color red   end-display

     goback.

ColorPicker.
   perform ScreenSave thru ScreenSaveEx
   call GC52COLORPICKER  using ColorPicker-Area cancel GC52COLORPICKER
   perform ScreenRestore thru ScreenRestoreEx.
ColorPickerEx. exit.

ScreenSave.
   move Z'SCRDUMP.SCR' to wScreenName
   call static 'scr_dump' using by reference wScreenName returning wiScrOk end-call.
ScreenSaveEx. exit.

ScreenRestore.
   call static 'scr_restore' using by reference wScreenName returning wiScrOk end-call
   CALL 'CBL_DELETE_FILE' USING wScreenName.
ScreenRestoreEx. exit.


End Program GC52COLORPICKERDEMO.
