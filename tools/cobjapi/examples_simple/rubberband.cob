*>******************************************************************************
*>  This file is part of cobjapi.
*>
*>  rubberband.cob is free software: you can redistribute it and/or 
*>  modify it under the terms of the GNU Lesser General Public License as 
*>  published by the Free Software Foundation, either version 3 of the License,
*>  or (at your option) any later version.
*>
*>  rubberband.cob is distributed in the hope that it will be useful, 
*>  but WITHOUT ANY WARRANTY; without even the implied warranty of 
*>  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
*>  See the GNU Lesser General Public License for more details.
*>
*>  You should have received a copy of the GNU Lesser General Public License 
*>  along with rubberband.cob.
*>  If not, see <http://www.gnu.org/licenses/>.
*>******************************************************************************

*>******************************************************************************
*> Program:      rubberband.cob
*>
*> Purpose:      Example GnuCOBOL program for JAPI
*>
*> Author:       Laszlo Erdos - https://www.facebook.com/wortfee
*>
*> Date-Written: 2014.12.24
*>
*> Tectonics:    Example for static link.
*>               cobc -x -free rubberband.cob cobjapi.o \
*>                                            japilib.o \
*>                                            imageio.o \
*>                                            fileselect.o
*>
*> Usage:        ./rubberband.exe
*>
*>******************************************************************************
*> Date       Name / Change description 
*> ========== ==================================================================
*> 2003.02.26 This comment is only for History. The latest Version (V1.0.6) of 
*>            JAPI was released on 02/26/2003. Homepage: http://www.japi.de 
*>------------------------------------------------------------------------------
*> 2014.12.24 Laszlo Erdos: 
*>            - GnuCOBOL support for JAPI added. 
*>            - rubberband.c converted into rubberband.cob. 
*>******************************************************************************

 IDENTIFICATION DIVISION.
 PROGRAM-ID. rubberband.
 AUTHOR.     Laszlo Erdos.

 ENVIRONMENT DIVISION.
 CONFIGURATION SECTION.
 REPOSITORY.
    FUNCTION J-SETDEBUG
    FUNCTION J-START
    FUNCTION J-FRAME
    FUNCTION J-SETSIZE
    FUNCTION J-SETNAMEDCOLOR
    FUNCTION J-CANVAS
    FUNCTION J-SETPOS
    FUNCTION J-MOUSELISTENER
    FUNCTION J-SHOW
    FUNCTION J-PACK
    FUNCTION J-FILLRECT
    FUNCTION J-NEXTACTION
    FUNCTION J-GETMOUSEPOS
    FUNCTION J-DRAWRECT
    FUNCTION J-DRAWPIXEL
    FUNCTION J-SETXOR
    FUNCTION J-QUIT
    FUNCTION ALL INTRINSIC.

 DATA DIVISION.

 WORKING-STORAGE SECTION.
*> function return value 
 01 WS-RET                             BINARY-INT.

*> GUI elements
 01 WS-FRAME                           BINARY-INT.
 01 WS-OBJ                             BINARY-INT.
 01 WS-CANVAS                          BINARY-INT.
 01 WS-PRESSED                         BINARY-INT.
 01 WS-DRAGGED                         BINARY-INT.
 
*> function args 
 01 WS-DEBUG-LEVEL                     BINARY-INT.
 01 WS-WIDTH                           BINARY-INT.
 01 WS-HEIGHT                          BINARY-INT.
 01 WS-XPOS                            BINARY-INT.
 01 WS-YPOS                            BINARY-INT.
 01 WS-START-X                         BINARY-INT.
 01 WS-START-Y                         BINARY-INT.
 01 WS-X                               BINARY-INT.
 01 WS-Y                               BINARY-INT.
 01 WS-DX                              BINARY-INT.
 01 WS-DY                              BINARY-INT.
 
*> Constants for the cobjapi wrapper 
 COPY "cobjapi.cpy".
 
 PROCEDURE DIVISION.

*>------------------------------------------------------------------------------
 MAIN-RUBBERBAND SECTION.
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
    MOVE J-FRAME("Move and drag the Mouse") TO WS-FRAME  

    MOVE 230 TO WS-WIDTH
    MOVE 220 TO WS-HEIGHT
    MOVE J-CANVAS(WS-FRAME, WS-WIDTH, WS-HEIGHT) TO WS-CANVAS  
    MOVE  10 TO WS-XPOS
    MOVE  30 TO WS-YPOS
    MOVE J-SETPOS(WS-CANVAS, WS-XPOS, WS-YPOS)   TO WS-RET

    MOVE J-SHOW(WS-FRAME) TO WS-RET
    MOVE J-PACK(WS-FRAME) TO WS-RET
    
    MOVE J-MOUSELISTENER(WS-CANVAS, J-PRESSED) TO WS-PRESSED  
    MOVE J-MOUSELISTENER(WS-CANVAS, J-DRAGGED) TO WS-DRAGGED  

    MOVE J-SETNAMEDCOLOR(WS-CANVAS, J-BLUE) TO WS-RET
    MOVE   0 TO WS-X
    MOVE   0 TO WS-Y
    MOVE 230 TO WS-WIDTH
    MOVE 110 TO WS-HEIGHT
    MOVE J-FILLRECT(WS-CANVAS, WS-X, WS-Y, WS-WIDTH, WS-HEIGHT) TO WS-RET

    MOVE J-SETNAMEDCOLOR(WS-CANVAS, J-YELLOW) TO WS-RET
    MOVE   0 TO WS-X
    MOVE 110 TO WS-Y
    MOVE 230 TO WS-WIDTH
    MOVE 110 TO WS-HEIGHT
    MOVE J-FILLRECT(WS-CANVAS, WS-X, WS-Y, WS-WIDTH, WS-HEIGHT) TO WS-RET
    
    MOVE J-SETNAMEDCOLOR(WS-CANVAS, J-RED) TO WS-RET

    MOVE 0 TO WS-START-X 
    MOVE 0 TO WS-START-Y
    MOVE 0 TO WS-X      
    MOVE 0 TO WS-Y      
    
*>  Waiting for actions    
    PERFORM FOREVER
       MOVE J-NEXTACTION() TO WS-OBJ

       IF WS-OBJ = WS-FRAME
       THEN
          EXIT PERFORM
       END-IF
       
       IF WS-OBJ = WS-PRESSED
       THEN
          DISPLAY "PRESSED"
          MOVE J-SETXOR(WS-CANVAS, J-TRUE) TO WS-RET
          COMPUTE WS-DX = WS-X - WS-START-X END-COMPUTE
          COMPUTE WS-DY = WS-Y - WS-START-Y END-COMPUTE
          MOVE J-DRAWRECT(WS-CANVAS, 
                          WS-START-X, WS-START-Y, 
                          WS-DX, WS-DY) TO WS-RET         
          MOVE J-DRAWPIXEL(WS-CANVAS,                           
                           WS-START-X, WS-START-Y) TO WS-RET
          MOVE J-GETMOUSEPOS(WS-PRESSED, WS-X, WS-Y) TO WS-RET
          COMPUTE WS-START-X = WS-X END-COMPUTE
          COMPUTE WS-START-Y = WS-Y END-COMPUTE
          MOVE J-SETXOR(WS-CANVAS, J-FALSE) TO WS-RET
       END-IF

       IF WS-OBJ = WS-DRAGGED
       THEN
          DISPLAY "DRAGGED"
          MOVE J-SETXOR(WS-CANVAS, J-TRUE) TO WS-RET
          COMPUTE WS-DX = WS-X - WS-START-X END-COMPUTE
          COMPUTE WS-DY = WS-Y - WS-START-Y END-COMPUTE
          MOVE J-DRAWRECT(WS-CANVAS, 
                          WS-START-X, WS-START-Y, 
                          WS-DX, WS-DY) TO WS-RET         
          MOVE J-GETMOUSEPOS(WS-DRAGGED, WS-X, WS-Y) TO WS-RET
          COMPUTE WS-DX = WS-X - WS-START-X END-COMPUTE
          COMPUTE WS-DY = WS-Y - WS-START-Y END-COMPUTE
          MOVE J-DRAWRECT(WS-CANVAS, 
                          WS-START-X, WS-START-Y, 
                          WS-DX, WS-DY) TO WS-RET         
          MOVE J-SETXOR(WS-CANVAS, J-FALSE) TO WS-RET
       END-IF
    END-PERFORM
    
    MOVE J-QUIT() TO WS-RET

    STOP RUN
    
    .
 MAIN-RUBBERBAND-EX.
    EXIT.
 END PROGRAM rubberband.
