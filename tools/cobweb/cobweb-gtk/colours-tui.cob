GnuCOB >>SOURCE FORMAT IS FIXED
      *>****S* cobweb/colours-tui
      *> Author:
      *>   Brian Tiffin
      *> Colophon:
      *>   Date       20141001
      *>   License    Public Domain
      *>   Documentation thanks to ROBODoc --cobol
      *> Purpose:
      *>   A terminal user interface in gtk-vte
      *>   For inclusion in a cobweb-gui gtk-vte demo widget
      *> Tectonics:
      *>   cobc -x colours-tui.cob
      *>   ./cobweb-gui
      *> Outline:
      *>   image:cobweb-gui11.png
      *> Source:
       identification division.
       program-id. colours-tui.

       data division.
       working-storage section.
       01 black   constant as 0.
       01 blue    constant as 1.
       01 green   constant as 2.
       01 cyan    constant as 3.
       01 red     constant as 4.
       01 magenta constant as 5.
       01 brown   constant as 6.
       01 white   constant as 7.

       01 anykey            pic x.
       01 a-field           pic x(16).

       screen section.
       01 gnucobol-colours.
        03 background-color white highlight.
          05 line 1 column 1 value "Black   0" foreground-color black.
          05 line 2 column 1 value "Blue    1" foreground-color blue.
          05 line 3 column 1 value "Green   2" foreground-color green.
          05 line 4 column 1 value "Cyan    3" foreground-color cyan.
          05 line 5 column 1 value "Red     4" foreground-color red.
          05 line 6 column 1 value "Magenta 5" foreground-color magenta.
          05 line 7 column 1 value "Brown   6" foreground-color brown.
          05 line 9 column 1 using a-field     background-color white.

      *> ***************************************************************
       procedure division.
       accept gnucobol-colours end-accept
       display a-field upon syserr end-display
       goback.

       end program colours-tui.
      *>****
