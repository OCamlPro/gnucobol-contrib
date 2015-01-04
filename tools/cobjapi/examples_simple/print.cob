*>******************************************************************************
*>  This file is part of cobjapi.
*>
*>  print.cob is free software: you can redistribute it and/or 
*>  modify it under the terms of the GNU Lesser General Public License as 
*>  published by the Free Software Foundation, either version 3 of the License,
*>  or (at your option) any later version.
*>
*>  print.cob is distributed in the hope that it will be useful, 
*>  but WITHOUT ANY WARRANTY; without even the implied warranty of 
*>  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
*>  See the GNU Lesser General Public License for more details.
*>
*>  You should have received a copy of the GNU Lesser General Public License 
*>  along with print.cob.
*>  If not, see <http://www.gnu.org/licenses/>.
*>******************************************************************************

*>******************************************************************************
*> Program:      print.cob
*>
*> Purpose:      Example GnuCOBOL program for JAPI
*>
*> Author:       Laszlo Erdos - https://www.facebook.com/wortfee
*>
*> Date-Written: 2014.12.24
*>
*> Tectonics:    Example for static link.
*>               cobc -x -free print.cob cobjapi.o \
*>                                       japilib.o \
*>                                       imageio.o \
*>                                       fileselect.o
*>
*> Usage:        ./print.exe
*>
*>******************************************************************************
*> Date       Name / Change description 
*> ========== ==================================================================
*> 2003.02.26 This comment is only for History. The latest Version (V1.0.6) of 
*>            JAPI was released on 02/26/2003. Homepage: http://www.japi.de 
*>------------------------------------------------------------------------------
*> 2014.12.24 Laszlo Erdos: 
*>            - GnuCOBOL support for JAPI added. 
*>            - print.c converted into print.cob. 
*>******************************************************************************

 IDENTIFICATION DIVISION.
 PROGRAM-ID. print.
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
    FUNCTION J-LOADIMAGE
    FUNCTION J-GETWIDTH
    FUNCTION J-GETHEIGHT
    FUNCTION J-CANVAS
    FUNCTION J-SETPOS
    FUNCTION J-SHOW
    FUNCTION J-PACK
    FUNCTION J-DRAWIMAGE
    FUNCTION J-NEXTACTION
    FUNCTION J-PRINT
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
 01 WS-PRINTFRAME                      BINARY-INT.
 01 WS-PRINTCANVAS                     BINARY-INT.
 01 WS-QUIT                            BINARY-INT.
 01 WS-OBJ                             BINARY-INT.
 01 WS-CANVAS                          BINARY-INT.
 01 WS-IMAGE                           BINARY-INT.

*> function args 
 01 WS-DEBUG-LEVEL                     BINARY-INT.
 01 WS-WIDTH                           BINARY-INT.
 01 WS-HEIGHT                          BINARY-INT.
 01 WS-XPOS                            BINARY-INT.
 01 WS-YPOS                            BINARY-INT.
 01 WS-X                               BINARY-INT.
 01 WS-Y                               BINARY-INT.

*> vars
 01 WS-WIDTH-DISP                      PIC 9(5).
 01 WS-HEIGHT-DISP                     PIC 9(5).
 
 PROCEDURE DIVISION.

*>------------------------------------------------------------------------------
 MAIN-PRINT SECTION.
*>------------------------------------------------------------------------------

*>  MOVE 5 TO WS-DEBUG-LEVEL
*>  MOVE J-SETDEBUG(WS-DEBUG-LEVEL) TO WS-RET

    MOVE J-START() TO WS-RET
    IF WS-RET = ZEROES
    THEN
       DISPLAY "can't connect to server"
       STOP RUN
    END-IF

    MOVE J-LOADIMAGE("images/mandel.gif") TO WS-IMAGE
    MOVE J-GETWIDTH(WS-IMAGE)  TO WS-WIDTH
    MOVE J-GETHEIGHT(WS-IMAGE) TO WS-HEIGHT
    MOVE WS-WIDTH  TO WS-WIDTH-DISP
    MOVE WS-HEIGHT TO WS-HEIGHT-DISP
    DISPLAY "image width  : "   WS-WIDTH-DISP
            ", image height : " WS-HEIGHT-DISP
    END-DISPLAY

*>  Generate GUI Objects    
    MOVE J-FRAME("Print Demo")               TO WS-FRAME  
    MOVE J-MENUBAR(WS-FRAME)                 TO WS-MENUBAR
    MOVE J-MENU(WS-MENUBAR, "File")          TO WS-FILE
    MOVE J-MENUITEM(WS-FILE, "Print Frame")  TO WS-PRINTFRAME
    MOVE J-MENUITEM(WS-FILE, "Print Canvas") TO WS-PRINTCANVAS
    MOVE J-MENUITEM(WS-FILE, "Quit")         TO WS-QUIT

    MOVE J-CANVAS(WS-FRAME, WS-WIDTH, WS-HEIGHT) TO WS-CANVAS  
    MOVE 10 TO WS-XPOS
    MOVE 60 TO WS-YPOS
    MOVE J-SETPOS(WS-CANVAS, WS-XPOS, WS-YPOS)   TO WS-RET
    
    MOVE J-SHOW(WS-FRAME) TO WS-RET
    MOVE J-PACK(WS-FRAME) TO WS-RET

    MOVE 0 TO WS-X
    MOVE 0 TO WS-Y
    MOVE J-DRAWIMAGE(WS-CANVAS, WS-IMAGE, WS-X, WS-Y) TO WS-RET
    
*>  Waiting for actions
    PERFORM FOREVER
       MOVE J-NEXTACTION() TO WS-OBJ

       IF (WS-OBJ = WS-QUIT) OR (WS-OBJ = WS-FRAME)
       THEN
          EXIT PERFORM
       END-IF
       
       IF (WS-OBJ = WS-PRINTFRAME) 
       THEN
          MOVE J-PRINT(WS-FRAME)  TO WS-RET
       END-IF

       IF (WS-OBJ = WS-PRINTCANVAS) 
       THEN
          MOVE J-PRINT(WS-CANVAS) TO WS-RET
       END-IF
    END-PERFORM
    
    MOVE J-QUIT() TO WS-RET

    STOP RUN
    
    .
 MAIN-PRINT-EX.
    EXIT.
 END PROGRAM print.
