*>******************************************************************************
*>  This file is part of cobjapi.
*>
*>  font.cob is free software: you can redistribute it and/or 
*>  modify it under the terms of the GNU Lesser General Public License as 
*>  published by the Free Software Foundation, either version 3 of the License,
*>  or (at your option) any later version.
*>
*>  font.cob is distributed in the hope that it will be useful, 
*>  but WITHOUT ANY WARRANTY; without even the implied warranty of 
*>  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
*>  See the GNU Lesser General Public License for more details.
*>
*>  You should have received a copy of the GNU Lesser General Public License 
*>  along with font.cob.
*>  If not, see <http://www.gnu.org/licenses/>.
*>******************************************************************************

*>******************************************************************************
*> Program:      font.cob
*>
*> Purpose:      Example GnuCOBOL program for JAPI
*>
*> Author:       Laszlo Erdos - https://www.facebook.com/wortfee
*>
*> Date-Written: 2014.12.24
*>
*> Tectonics:    Example for static link.
*>               cobc -x -free font.cob cobjapi.o \
*>                                      japilib.o \
*>                                      imageio.o \
*>                                      fileselect.o
*>
*> Usage:        ./font.exe
*>
*>******************************************************************************
*> Date       Name / Change description 
*> ========== ==================================================================
*> 2003.02.26 This comment is only for History. The latest Version (V1.0.6) of 
*>            JAPI was released on 02/26/2003. Homepage: http://www.japi.de 
*>------------------------------------------------------------------------------
*> 2014.12.24 Laszlo Erdos: 
*>            - GnuCOBOL support for JAPI added. 
*>            - font.c converted into font.cob. 
*>******************************************************************************

 IDENTIFICATION DIVISION.
 PROGRAM-ID. font.
 AUTHOR.     Laszlo Erdos.

 ENVIRONMENT DIVISION.
 CONFIGURATION SECTION.
 REPOSITORY.
    FUNCTION J-SETDEBUG
    FUNCTION J-START
    FUNCTION J-FRAME
    FUNCTION J-MENUBAR
    FUNCTION J-MENU
    FUNCTION J-MENUITEM    
    FUNCTION J-CHECKMENUITEM    
    FUNCTION J-LABEL
    FUNCTION J-SETSIZE
    FUNCTION J-SETPOS
    FUNCTION J-SETFONT
    FUNCTION J-PACK
    FUNCTION J-SHOW
    FUNCTION J-NEXTACTION
    FUNCTION J-SETFONTNAME
    FUNCTION J-SETFONTSIZE
    FUNCTION J-SETSTATE
    FUNCTION J-GETSTATE
    FUNCTION J-SETFONTSTYLE
    FUNCTION J-GETSTRINGWIDTH
    FUNCTION J-GETFONTHEIGHT
    FUNCTION J-GETFONTASCENT
    FUNCTION J-SETTEXT
    FUNCTION J-QUIT
    FUNCTION ALL INTRINSIC.

 DATA DIVISION.

 WORKING-STORAGE SECTION.
*> function return value 
 01 WS-RET                             BINARY-INT.

*> GUI elements
 01 WS-FRAME                           BINARY-INT.
 01 WS-MENUBAR                         BINARY-INT.
 01 WS-FILE                            BINARY-INT.
 01 WS-QUIT                            BINARY-INT.
 01 WS-OBJ                             BINARY-INT.
 01 WS-LABEL                           BINARY-INT.
*> font type
 01 WS-FONT                            BINARY-INT.
 01 WS-COURIER                         BINARY-INT.
 01 WS-HELVETIA                        BINARY-INT.
 01 WS-TIMES                           BINARY-INT.
 01 WS-DIALOGIN                        BINARY-INT.
 01 WS-DIALOGOUT                       BINARY-INT.
*> font style
 01 WS-STYLE                           BINARY-INT.
 01 WS-NORMAL                          BINARY-INT.
 01 WS-BOLD                            BINARY-INT.
 01 WS-ITALIC                          BINARY-INT.
*> font size
 01 WS-SIZE                            BINARY-INT.
 01 WS-F10                             BINARY-INT.
 01 WS-F12                             BINARY-INT.
 01 WS-F14                             BINARY-INT.
 01 WS-F18                             BINARY-INT.
 
*> function args 
 01 WS-DEBUG-LEVEL                     BINARY-INT.
 01 WS-WIDTH                           BINARY-INT.
 01 WS-HEIGHT                          BINARY-INT.
 01 WS-XPOS                            BINARY-INT.
 01 WS-YPOS                            BINARY-INT.
 01 WS-FONTSTYLE                       BINARY-INT.
 01 WS-FONTSIZE                        BINARY-INT.
 01 WS-STR                             PIC X(256).
 
*> vars
 01 WS-STRING-WIDTH                    PIC 9(5).
 01 WS-FONT-HEIGHT                     PIC 9(5).
 01 WS-FONT-ASCENT                     PIC 9(5).
 
*> Constants for the cobjapi wrapper 
 COPY "cobjapi.cpy".
 
 PROCEDURE DIVISION.

*>------------------------------------------------------------------------------
 MAIN-FONT SECTION.
*>------------------------------------------------------------------------------

*>  MOVE 5 TO WS-DEBUG-LEVEL
*>  MOVE J-SETDEBUG(WS-DEBUG-LEVEL) TO WS-RET

    MOVE J-START() TO WS-RET
    IF WS-RET = ZEROES
    THEN
       DISPLAY "can't connect to server"
       STOP RUN
    END-IF

*>  Generate GUI Objects    
    MOVE J-FRAME("Font Demo")                TO WS-FRAME  
    MOVE J-MENUBAR(WS-FRAME)                 TO WS-MENUBAR
    MOVE J-MENU(WS-MENUBAR, "File")          TO WS-FILE
    MOVE J-MENUITEM(WS-FILE, "Quit")         TO WS-QUIT

*>  font type
    MOVE J-MENU(WS-MENUBAR, "Font type")     TO WS-FONT
    MOVE J-MENUITEM(WS-FONT, "Courier")      TO WS-COURIER
    MOVE J-MENUITEM(WS-FONT, "Helvetia")     TO WS-HELVETIA
    MOVE J-MENUITEM(WS-FONT, "Times")        TO WS-TIMES
    MOVE J-MENUITEM(WS-FONT, "DialogIn")     TO WS-DIALOGIN
    MOVE J-MENUITEM(WS-FONT, "DialogOut")    TO WS-DIALOGOUT
                                             
*>  font style                               
    MOVE J-MENU(WS-MENUBAR, "Font style")    TO WS-STYLE
    MOVE J-MENUITEM(WS-STYLE, "Plain")       TO WS-NORMAL
    MOVE J-CHECKMENUITEM(WS-STYLE, "Bold")   TO WS-BOLD
    MOVE J-CHECKMENUITEM(WS-STYLE, "Italic") TO WS-ITALIC
    
*>  font size
    MOVE J-MENU(WS-MENUBAR, "Font size")     TO WS-SIZE
    MOVE J-MENUITEM(WS-SIZE, "10 pt")        TO WS-F10
    MOVE J-MENUITEM(WS-SIZE, "12 pt")        TO WS-F12
    MOVE J-MENUITEM(WS-SIZE, "14 pt")        TO WS-F14
    MOVE J-MENUITEM(WS-SIZE, "18 pt")        TO WS-F18

    MOVE J-LABEL(WS-FRAME, "abcdefghijklmnopqrstuvwxyzüöäßÜÖÄ") TO WS-LABEL
    MOVE 400 TO WS-WIDTH
    MOVE 120 TO WS-HEIGHT
    MOVE J-SETSIZE(WS-LABEL, WS-WIDTH, WS-HEIGHT) TO WS-RET
    MOVE   5 TO WS-XPOS
    MOVE  60 TO WS-YPOS
    MOVE J-SETPOS(WS-LABEL, WS-XPOS, WS-YPOS)     TO WS-RET

    MOVE J-PLAIN TO WS-FONTSTYLE
    MOVE 12      TO WS-FONTSIZE    
    MOVE J-SETFONT(WS-FRAME, J-HELVETIA, J-PLAIN, WS-FONTSIZE) TO WS-RET
    
    MOVE J-PACK(WS-FRAME) TO WS-RET
    MOVE J-SHOW(WS-FRAME) TO WS-RET

    MOVE -1 TO WS-OBJ
    
*>  Waiting for actions
    PERFORM FOREVER
       MOVE J-NEXTACTION() TO WS-OBJ

       IF (WS-OBJ = WS-QUIT) OR (WS-OBJ = WS-FRAME)
       THEN
          EXIT PERFORM
       END-IF
       
       EVALUATE TRUE
*>        font type       
          WHEN WS-OBJ = WS-COURIER 
               MOVE J-SETFONTNAME(WS-LABEL, J-COURIER)   TO WS-RET
          WHEN WS-OBJ = WS-HELVETIA 
               MOVE J-SETFONTNAME(WS-LABEL, J-HELVETIA)  TO WS-RET
          WHEN WS-OBJ = WS-TIMES 
               MOVE J-SETFONTNAME(WS-LABEL, J-TIMES)     TO WS-RET
          WHEN WS-OBJ = WS-DIALOGIN 
               MOVE J-SETFONTNAME(WS-LABEL, J-DIALOGIN)  TO WS-RET
          WHEN WS-OBJ = WS-DIALOGOUT 
               MOVE J-SETFONTNAME(WS-LABEL, J-DIALOGOUT) TO WS-RET

*>        font style
          WHEN WS-OBJ = WS-NORMAL 
               MOVE J-PLAIN TO WS-FONTSTYLE
               MOVE J-SETSTATE(WS-BOLD, J-FALSE)           TO WS-RET
               MOVE J-SETSTATE(WS-ITALIC, J-FALSE)         TO WS-RET
               MOVE J-SETFONTSTYLE(WS-LABEL, WS-FONTSTYLE) TO WS-RET

          WHEN WS-OBJ = WS-BOLD 
               IF J-GETSTATE(WS-BOLD) = J-TRUE
               THEN
                  COMPUTE WS-FONTSTYLE = WS-FONTSTYLE + J-BOLD END-COMPUTE
               ELSE
                  COMPUTE WS-FONTSTYLE = WS-FONTSTYLE - J-BOLD END-COMPUTE
               END-IF  
               MOVE J-SETFONTSTYLE(WS-LABEL, WS-FONTSTYLE) TO WS-RET

          WHEN WS-OBJ = WS-ITALIC 
               IF J-GETSTATE(WS-ITALIC) = J-TRUE
               THEN
                  COMPUTE WS-FONTSTYLE = WS-FONTSTYLE + J-ITALIC END-COMPUTE
               ELSE
                  COMPUTE WS-FONTSTYLE = WS-FONTSTYLE - J-ITALIC END-COMPUTE
               END-IF  
               MOVE J-SETFONTSTYLE(WS-LABEL, WS-FONTSTYLE) TO WS-RET
               
*>        font size
          WHEN WS-OBJ = WS-F10 
               MOVE 10 TO WS-FONTSIZE
               MOVE J-SETFONTSIZE(WS-LABEL, WS-FONTSIZE) TO WS-RET
          WHEN WS-OBJ = WS-F12 
               MOVE 12 TO WS-FONTSIZE
               MOVE J-SETFONTSIZE(WS-LABEL, WS-FONTSIZE) TO WS-RET
          WHEN WS-OBJ = WS-F14 
               MOVE 14 TO WS-FONTSIZE
               MOVE J-SETFONTSIZE(WS-LABEL, WS-FONTSIZE) TO WS-RET
          WHEN WS-OBJ = WS-F18 
               MOVE 18 TO WS-FONTSIZE
               MOVE J-SETFONTSIZE(WS-LABEL, WS-FONTSIZE) TO WS-RET
       END-EVALUATE      

       MOVE J-GETSTRINGWIDTH(WS-LABEL, "abcdefghijklmnopqrstuvwxyzüöäßÜÖÄ") 
         TO WS-STRING-WIDTH
       MOVE J-GETFONTHEIGHT(WS-LABEL) TO WS-FONT-HEIGHT 
       MOVE J-GETFONTASCENT(WS-LABEL) TO WS-FONT-ASCENT 
       
       MOVE ALL x"00" TO WS-STR
       STRING "String Width = "  DELIMITED BY SIZE
              WS-STRING-WIDTH 
              " Font Height = "           
              WS-FONT-HEIGHT
              " Font Ascent = " 
              WS-FONT-ASCENT 
         INTO WS-STR
       END-STRING
       MOVE J-SETTEXT(WS-FRAME, WS-STR) TO WS-RET
    END-PERFORM
    
    MOVE J-QUIT() TO WS-RET

    STOP RUN
    
    .
 MAIN-FONT-EX.
    EXIT.
 END PROGRAM font.
