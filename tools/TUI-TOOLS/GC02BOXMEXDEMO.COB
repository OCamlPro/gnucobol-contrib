       >>SOURCE FORMAT IS FREE
ID DIVISION.
PROGRAM-ID. GC02BOXMEXDEMO.
*> ***********************************************************************************
*> GnuCOBOL TT (TUI TOOLS) COLLECTION
*> Purpose:    DEMO OF GC02BOXMEX -  DISPLAYS A MESSAGE IN A BOX ON SCREEN
*> Tectonics:  cobc -x GC01BOXDEMO.COB (use GnuCOBOL 2.0 or greater)
*> Usage:      GC02BOXMEXDEMO
*> Parameters: none
*> Author:     Eugenio Di Lorenzo - Italia (DILO)
*> License:    Copyright 2016 E.Di Lorenzo - GNU Lesser General Public License, LGPL, 3.0 (or greater)
*> Version:    1.0 2016.06.15
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

01 wCursorHide  BINARY-SHORT value 0. *>  SIGNED.
01 wCursorShow  BINARY-SHORT value 2. *>  SIGNED.
01 wVisibility  BINARY-SHORT.         *>  SIGNED.

copy 'GC01BOX.CPY'.
copy 'GC02BOXMEX.CPY'.
COPY 'GC09BUTTONS.CPY'.

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
    *> BELL
    if Bxm-beep = 'Y' CALL X"E5"  end-if.

message1.
    move green          to Box-bco
    move white          to Box-fco
    move '001001025080' to Box-rc
    move 'S'            to Box-style
    call GC01BOX using Box-Area
    display ' GnuCOBOL TUI TOOL to display messages on screen. '
          at 2203 with foreground-color white background-color green
    display ' See the GC02BOXMEX at work.                      '
          at 2303 with foreground-color white background-color green
    *> ***********************************************************************************
    *>      MESSAGE N.1
    *> ***********************************************************************************
    initialize Boxmex-Area ALL TO VALUE
    move low-value to Bxm-tabmex
    move '                                ' & x'00' to Bxm-mex(01)
    move '     GnuCOBOL TUI TOOLS DEMO    ' & x'00' to Bxm-mex(02)
    move '       Copyright (c) 2016       ' & x'00' to Bxm-mex(03)
    move '       ------------------       ' & x'00' to Bxm-mex(04)
    move '           GC02BOXMEX           ' & x'00' to Bxm-mex(05)
    move '           - Italia -           ' & x'00' to Bxm-mex(06)
    move '                                ' & x'00' to Bxm-mex(07)
    move ' move message with cursor keys  ' & x'00' to Bxm-mex(08)
    move '005020017055' to Bxm-rc
    move white to Bxm-bco
    move black to Bxm-fco
    move 'N' to Bxm-Shadow
    move 'N' to Bxm-3D
    move 'D' to Bxm-Style
    move 'N' to Bxm-fcoMH
    move 'Y' to Bxm-tit
    move ' First Message ' & x'00' to Bxm-titDes

    call GC02BOXMEX using BOXMEX-AREA.

    *> ***********************************************************************************
    *>      MESSAGE N.2
    *> ***********************************************************************************
message2.
      display ' See the click effect on the ''OK single button'' '
          at 2403 with foreground-color yellow background-color green  highlight
    initialize Boxmex-Area ALL TO VALUE
    move low-value to Bxm-tabmex
    move z' This message is to show some feature of the tools utilities on screen ' to Bxm-mex(01)
    move z' This message is to show some feature of the tools utilities on screen ' to Bxm-mex(02)
    move z' This message is to show some feature of the tools utilities on screen ' to Bxm-mex(03)
    move z' This message is to show some feature of the tools utilities on screen ' to Bxm-mex(04)
    move z' This message is to show some feature of the tools utilities on screen ' to Bxm-mex(05)
    move z' This message is to show some feature of the tools utilities on screen ' to Bxm-mex(06)
    move z'                                                                       ' to Bxm-mex(06)
    move '005003015075' to Bxm-rc
    move white to Bxm-bco
    move black to Bxm-fco
    move black to Bxm-fcoM
    move 'N' to Bxm-fcoMH
    move 'Y' to Bxm-Shadow Bxm-click
    move 'E' to Bxm-3D
    move 'S' to Bxm-Style

    call GC02BOXMEX using BOXMEX-AREA.


*> ***********************************************************************************
*>      MESSAGE N.3
*> ***********************************************************************************
message3.
        display ' GC02BOXMEX used with GC09BUTTONS ... message text and three buttons.'
          at 2403 with foreground-color yellow background-color green  highlight
    initialize Boxmex-Area ALL TO VALUE
    move low-value to Bxm-tabmex
    *>    123456789012345678901234567890123456789012345678901234567890123456789012
    move 'Y' to Bxm-tit Bxm-titFcoH
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
    move space & x'00' to Bxm-mex(11)
    move space & x'00' to Bxm-mex(12)
    move space & x'00' to Bxm-mex(13)
    move space & x'00' to Bxm-mex(14)

    move '003003018077' to Bxm-rc
    move red    to Bxm-bco Bxm-titBco
    move black  to Bxm-fco Bxm-titFco
    move red    to Bxm-bcoM
    move yellow to Bxm-fcoM
    move 'Y' to Bxm-fcoMH
    move 'N' to Bxm-Shadow Bxm-click
    move 'N' to Bxm-3D Bxm-wait Bxm-OkButton
    move 'D' to Bxm-Style
    call GC02BOXMEX using BOXMEX-AREA.


    *> DISPLAY BUTTONS
    initialize Buttons-area ALL TO VALUE
    move red       to Bu-bcoShadow
    move low-value to Bu-tab
    move green     to Bu-bcoN
    move white     to Bu-fcoN
    move blue      to Bu-bcoS
    move yellow    to Bu-fcoS
    move '1' to Bu-Arrow
    move "<" to Bu-Arrow-Char1
    move ">" to Bu-Arrow-Char2
    move 'Y' to Bu-Click

    Move '16015020  Continue   ' & x'00' to Bu-Ele(01)
    Move ' 5015035   Cancel    ' & x'00' to Bu-Ele(02)
    Move ' 6015050  Inspect    ' & x'00' to Bu-Ele(03)
    call GC09BUTTONS using BUTTONS-AREA
    .


*> ***********************************************************************************
*>      MESSAGE N.3.1
*> ***********************************************************************************
message3.
        display ' GC02BOXMEX used with GC09BUTTONS ... message text and vertical buttons.'
          at 2403 with foreground-color yellow background-color green  highlight
    initialize Boxmex-Area ALL TO VALUE
    move low-value to Bxm-tabmex
    *>    123456789012345678901234567890123456789012345678901234567890123456789012
    move 'Y' to Bxm-tit Bxm-titFcoH
    move ' *** GnuCOBOL GnuCOBOL GnuCOBOL *** ' & x'00'       to Bxm-titDes
    move z'                                                                         ' to Bxm-mex(01)
    move z' GnuCOBOL is an open-source COBOL compiler  and                          ' to Bxm-mex(02)
    move z' runtime environment. The GnuCOBOL compiler                              ' to Bxm-mex(03)
    move z' generates C code which is automatically compiled                        ' to Bxm-mex(04)
    move z' and linked. While originally developed for UNIX                         ' to Bxm-mex(05)
    move z' operating systems, GnuCOBOL has also been successfully                  ' to Bxm-mex(06)
    move z' built for OSX computers or Windows  computers utilizing                 ' to Bxm-mex(07)
    move z' the UNIX-emulation features of such tools as Cygwin and                 ' to Bxm-mex(08)
    move z' MinGW. It has also been built as a truly native Windows                 ' to Bxm-mex(09)
    move z' application utilizing Microsoft"s freely-downloadable                   ' to Bxm-mex(10)
    move z' Visual Studio Express package to provide the C compiler                 ' to Bxm-mex(11)
    move z' and linker/loader. The principal developers of GnuCOBOL                 ' to Bxm-mex(12)
    move z' are Keisuke Nishida and Roger While.                                    ' to Bxm-mex(13)
    move space & x'00' to Bxm-mex(14)
    move '003003019077' to Bxm-rc
    move red    to Bxm-bco Bxm-titBco
    move black  to Bxm-fco Bxm-titFco
    move red    to Bxm-bcoM
    move yellow to Bxm-fcoM
    move 'Y' to Bxm-fcoMH
    move 'N' to Bxm-Shadow Bxm-click Bxm-3D Bxm-wait Bxm-OkButton
    move 'D' to Bxm-Style
    call GC02BOXMEX using BOXMEX-AREA.


    *> DISPLAY BUTTONS
    initialize Buttons-area ALL TO VALUE
    move red       to Bu-bcoShadow
    move low-value to Bu-tab
    move green     to Bu-bcoN
    move white     to Bu-fcoN
    move blue      to Bu-bcoS
    move yellow    to Bu-fcoS
    move '1' to Bu-Arrow
    move "<" to Bu-Arrow-Char1
    move ">" to Bu-Arrow-Char2
    move 'Y' to Bu-Click

    Move ' 6005062     OK      ' & x'00' to Bu-Ele(01)
    Move '16007062  Continue   ' & x'00' to Bu-Ele(02)
    Move ' 5009062   Cancel    ' & x'00' to Bu-Ele(03)
    Move ' 6011062    Move     ' & x'00' to Bu-Ele(04)
    Move ' 6013062      ?      ' & x'00' to Bu-Ele(05)
    Move ' 6015062    Help     ' & x'00' to Bu-Ele(06)
    call GC09BUTTONS using BUTTONS-AREA
    .


*> ***********************************************************************************
*>      MESSAGE N.4
*> ***********************************************************************************
message4.
   *> CLEAR CREEN
    CALL X"E4"  .
    move white          to Box-bco
    set  Box-fco        to white
    move '002003024078' to Box-rc
    move 'S'            to Box-style
    call GC01BOX using Box-Area.


*> ***********************************************************************************
*>      MESSAGE N.5
*> ***********************************************************************************
message5.
    initialize Boxmex-Area ALL TO VALUE
    move low-value to Bxm-tabmex
    move space & x'00' to Bxm-mex(01)
    move '            __________________________________________         '  & x'00' to Bxm-mex(02)
    move '   ________|                                          |_______ '  & x'00' to Bxm-mex(03)
    move '   \       |               GnuCOBOL 2.0               |      / '  & x'00' to Bxm-mex(04)
    move '    \      |           TUI TOOLS COLLECTION           |     /  '  & x'00' to Bxm-mex(05)
    move '    /      |__________________________________________|     \  '  & x'00' to Bxm-mex(06)
    move '   /__________)                                    (_________\ '  & x'00' to Bxm-mex(07)
    move space & x'00' to Bxm-mex(08)
    move space & x'00' to Bxm-mex(09)

    move '005005017073' to Bxm-rc
    move blue    to Bxm-bco
    move black   to Bxm-fco
    move blue    to Bxm-bcoM
    move white   to Bxm-fcoM
    move 'Y' to Bxm-fcoMH
    move 'Y' to Bxm-Shadow
    move 'E' to Bxm-3D
    move 'S' to Bxm-Style
    move "R" to Bxm-3D
    call GC02BOXMEX using BOXMEX-AREA.

*> ***********************************************************************************
*>      MESSAGE N.6
*> ***********************************************************************************
message6.
  initialize Boxmex-Area ALL TO VALUE
  move low-value to Bxm-tabmex

  move '           __________________               '  & x'00' to Bxm-mex(01)
  move '          /\  ______________ \              '  & x'00' to Bxm-mex(02)
  move '         /::\ \ZZZZZZZZZZZZ/\ \             '  & x'00' to Bxm-mex(03)
  move '        /:/\.\ \        /:/\:\ \            '  & x'00' to Bxm-mex(04)
  move '       /:/Z/\:\ \      /:/Z/\:\ \           '  & x'00' to Bxm-mex(05)
  move '      /:/Z/__\:\ \____/:/Z/  \:\ \          '  & x'00' to Bxm-mex(06)
  move '     /:/Z/____\:\ \___\/Z/    \:\ \         '  & x'00' to Bxm-mex(07)
  move '     \:\ \ZZZZZ\:\ \ZZ/\ \     \:\ \        '  & x'00' to Bxm-mex(08)
  move '      \:\ \     \:\ \ \:\ \     \:\ \       '  & x'00' to Bxm-mex(09)
  move '       \:\ \     \:\ \_\;\_\_____\;\ \      '  & x'00' to Bxm-mex(10)
  move '        \:\ \     \:\_________________\     '  & x'00' to Bxm-mex(11)
  move '         \:\ \    /:/ZZZZZZZZZZZZZZZZZ/     '  & x'00' to Bxm-mex(12)
  move '          \:\ \  /:/Z/    \:\ \  /:/Z/      '  & x'00' to Bxm-mex(13)
  move '           \:\ \/:/Z/      \:\ \/:/Z/       '  & x'00' to Bxm-mex(14)
  move '            \:\/:/Z/________\;\/:/Z/        '  & x'00' to Bxm-mex(15)
  move '             \::/Z/____________\/Z/         '  & x'00' to Bxm-mex(16)
  move '              \/ZZZZZZZZZZZZZZZZZ/          '  & x'00' to Bxm-mex(17)

  move '002020023066' to Bxm-rc
  move red    to Bxm-bco
  move white  to Bxm-fco
  move red  to Bxm-bcoM
  move yellow   to Bxm-fcoM
  move 'Y' to Bxm-fcoMH
  move 'Y' to Bxm-Shadow Bxm-click
  move 'N' to Bxm-3D
  move 'D' to Bxm-Style
  call GC02BOXMEX using BOXMEX-AREA.


*> DISPLAY THE FLAG OF ITALY
     move '009036014049' to Box-rc
     move black to Box-bco
     move 'S' to Box-style
     call  GC01BOX using BOX-AREA
     display '    ' at 010037 with foreground-color white background-color Green end-display
     display '    ' at 011037 with foreground-color white background-color Green end-display
     display '    ' at 012037 with foreground-color white background-color Green end-display
     display '    ' at 013037 with foreground-color white background-color Green end-display
     display '    ' at 010041 with blink foreground-color white background-color white end-display
     display '    ' at 011041 with blink foreground-color white background-color white end-display
     display '    ' at 012041 with blink foreground-color white background-color white end-display
     display '    ' at 013041 with blink foreground-color white background-color white end-display
     display '    ' at 010045 with blink foreground-color white background-color red   end-display
     display '    ' at 011045 with blink foreground-color white background-color red   end-display
     display '    ' at 012045 with blink foreground-color white background-color red   end-display
     display '    ' at 013045 with blink foreground-color white background-color red   end-display
   ACCEPT OMITTED.

goback.

End Program GC02BOXMEXDEMO.
