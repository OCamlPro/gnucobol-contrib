*>******************************************************************************
*>  This file is part of cobjapi.
*>
*>  mouselistener.cob is free software: you can redistribute it and/or 
*>  modify it under the terms of the GNU Lesser General Public License as 
*>  published by the Free Software Foundation, either version 3 of the License,
*>  or (at your option) any later version.
*>
*>  mouselistener.cob is distributed in the hope that it will be useful, 
*>  but WITHOUT ANY WARRANTY; without even the implied warranty of 
*>  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
*>  See the GNU Lesser General Public License for more details.
*>
*>  You should have received a copy of the GNU Lesser General Public License 
*>  along with mouselistener.cob.
*>  If not, see <http://www.gnu.org/licenses/>.
*>******************************************************************************

*>******************************************************************************
*> Program:      mouselistener.cob
*>
*> Purpose:      Example GnuCOBOL program for JAPI
*>
*> Author:       Laszlo Erdos - https://www.facebook.com/wortfee
*>
*> Date-Written: 2014.12.24
*>
*> Tectonics:    Example for static link.
*>               cobc -x -free mouselistener.cob cobjapi.o \
*>                                               japilib.o \
*>                                               imageio.o \
*>                                               fileselect.o
*>
*> Usage:        ./mouselistener.exe
*>
*>******************************************************************************
*> Date       Name / Change description 
*> ========== ==================================================================
*> 2003.02.26 This comment is only for History. The latest Version (V1.0.6) of 
*>            JAPI was released on 02/26/2003. Homepage: http://www.japi.de 
*>------------------------------------------------------------------------------
*> 2014.12.24 Laszlo Erdos: 
*>            - GnuCOBOL support for JAPI added. 
*>            - mouselistener.c converted into mouselistener.cob. 
*>******************************************************************************

 IDENTIFICATION DIVISION.
 PROGRAM-ID. mouselistener.
 AUTHOR.     Laszlo Erdos.

 ENVIRONMENT DIVISION.
 CONFIGURATION SECTION.
 REPOSITORY.
    FUNCTION J-SETDEBUG
    FUNCTION J-START
    FUNCTION J-FRAME
    FUNCTION J-SETSIZE
    FUNCTION J-SETNAMEDCOLORBG
    FUNCTION J-CANVAS
    FUNCTION J-SETPOS
    FUNCTION J-MOUSELISTENER
    FUNCTION J-SHOW
    FUNCTION J-NEXTACTION
    FUNCTION J-GETMOUSEPOS
    FUNCTION J-DRAWRECT
    FUNCTION J-DRAWLINE
    FUNCTION J-QUIT
    FUNCTION ALL INTRINSIC.

 DATA DIVISION.

 WORKING-STORAGE SECTION.
*> function return value 
 01 WS-RET                             BINARY-INT.

*> GUI elements
 01 WS-FRAME                           BINARY-INT.
 01 WS-OBJ                             BINARY-INT.
 01 WS-CANVAS-1                        BINARY-INT.
 01 WS-CANVAS-2                        BINARY-INT.
 01 WS-PRESSED                         BINARY-INT.
 01 WS-RELEASED                        BINARY-INT.
 01 WS-MOVED                           BINARY-INT.
 01 WS-DRAGGED                         BINARY-INT.
 01 WS-ENTERED                         BINARY-INT.
 01 WS-EXITED                          BINARY-INT.
 
*> function args 
 01 WS-DEBUG-LEVEL                     BINARY-INT.
 01 WS-WIDTH                           BINARY-INT.
 01 WS-HEIGHT                          BINARY-INT.
 01 WS-XPOS                            BINARY-INT.
 01 WS-YPOS                            BINARY-INT.
 01 WS-START-X                         BINARY-INT VALUE 0.
 01 WS-START-Y                         BINARY-INT VALUE 0.
 01 WS-X                               BINARY-INT.
 01 WS-Y                               BINARY-INT.
 01 WS-DX                              BINARY-INT.
 01 WS-DY                              BINARY-INT.
 
*> Constants for the cobjapi wrapper 
 COPY "cobjapi.cpy".
 
 PROCEDURE DIVISION.

*>------------------------------------------------------------------------------
 MAIN-MOUSELISTENER SECTION.
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
    MOVE 430 TO WS-WIDTH
    MOVE 240 TO WS-HEIGHT
    MOVE J-SETSIZE(WS-FRAME, WS-WIDTH, WS-HEIGHT)  TO WS-RET
    MOVE J-SETNAMEDCOLORBG(WS-FRAME, J-LIGHT-GRAY) TO WS-RET

    MOVE 200 TO WS-WIDTH
    MOVE 200 TO WS-HEIGHT
    MOVE J-CANVAS(WS-FRAME, WS-WIDTH, WS-HEIGHT) TO WS-CANVAS-1  
    MOVE J-CANVAS(WS-FRAME, WS-WIDTH, WS-HEIGHT) TO WS-CANVAS-2  

    MOVE  10 TO WS-XPOS
    MOVE  30 TO WS-YPOS
    MOVE J-SETPOS(WS-CANVAS-1, WS-XPOS, WS-YPOS) TO WS-RET
    MOVE 220 TO WS-XPOS
    MOVE  30 TO WS-YPOS
    MOVE J-SETPOS(WS-CANVAS-2, WS-XPOS, WS-YPOS) TO WS-RET

    MOVE J-MOUSELISTENER(WS-CANVAS-1, J-PRESSED)  TO WS-PRESSED  
    MOVE J-MOUSELISTENER(WS-CANVAS-1, J-DRAGGED)  TO WS-DRAGGED  
    MOVE J-MOUSELISTENER(WS-CANVAS-1, J-RELEASED) TO WS-RELEASED 
    MOVE J-MOUSELISTENER(WS-CANVAS-2, J-ENTERERD) TO WS-ENTERED  
    MOVE J-MOUSELISTENER(WS-CANVAS-2, J-MOVED)    TO WS-MOVED    
    MOVE J-MOUSELISTENER(WS-CANVAS-2, J-EXITED)   TO WS-EXITED   

    MOVE J-SHOW(WS-FRAME) TO WS-RET
    
*>  Waiting for actions    
    PERFORM FOREVER
       MOVE J-NEXTACTION() TO WS-OBJ

       IF WS-OBJ = WS-FRAME
       THEN
          EXIT PERFORM
       END-IF
       
       IF WS-OBJ = WS-PRESSED
       THEN
          MOVE J-GETMOUSEPOS(WS-PRESSED, WS-X, WS-Y) TO WS-RET
          MOVE WS-X TO WS-START-X
          MOVE WS-Y TO WS-START-Y
          DISPLAY "Mouse Pressed in Canvas 1 at " 
                  WS-X 
                  "  " 
                  WS-Y
          END-DISPLAY
       END-IF

       IF WS-OBJ = WS-DRAGGED
       THEN
          MOVE J-GETMOUSEPOS(WS-DRAGGED, WS-X, WS-Y) TO WS-RET
          COMPUTE WS-DX = WS-X - WS-START-X END-COMPUTE
          COMPUTE WS-DY = WS-Y - WS-START-Y END-COMPUTE
          MOVE J-DRAWRECT(WS-CANVAS-1, 
                          WS-START-X, WS-START-Y, 
                          WS-DX, WS-DY) TO WS-RET         
          DISPLAY "Mouse Dragged in Canvas 1 to " 
                  WS-X 
                  "  " 
                  WS-Y
          END-DISPLAY
       END-IF

       IF WS-OBJ = WS-RELEASED
       THEN
          MOVE J-GETMOUSEPOS(WS-RELEASED, WS-X, WS-Y) TO WS-RET
          COMPUTE WS-DX = WS-X - WS-START-X END-COMPUTE
          COMPUTE WS-DY = WS-Y - WS-START-Y END-COMPUTE
          MOVE J-DRAWRECT(WS-CANVAS-1, 
                          WS-START-X, WS-START-Y, 
                          WS-DX, WS-DY) TO WS-RET         
          DISPLAY "Mouse Released in Canvas 1 at " 
                  WS-X 
                  "  " 
                  WS-Y
          END-DISPLAY
       END-IF

       IF WS-OBJ = WS-ENTERED
       THEN
          MOVE J-GETMOUSEPOS(WS-ENTERED, WS-X, WS-Y) TO WS-RET
          MOVE WS-X TO WS-START-X
          MOVE WS-Y TO WS-START-Y
          DISPLAY "Mouse Entered in Canvas 2 at " 
                  WS-X 
                  "  " 
                  WS-Y
          END-DISPLAY
       END-IF

       IF WS-OBJ = WS-MOVED
       THEN
          MOVE J-GETMOUSEPOS(WS-MOVED, WS-X, WS-Y) TO WS-RET
          MOVE J-DRAWLINE(WS-CANVAS-2, 
                          WS-START-X, WS-START-Y, 
                          WS-X, WS-Y) TO WS-RET         
          MOVE WS-X TO WS-START-X
          MOVE WS-Y TO WS-START-Y
          DISPLAY "Mouse Moved in Canvas 2 to " 
                  WS-X 
                  "  " 
                  WS-Y
          END-DISPLAY
       END-IF

       IF WS-OBJ = WS-EXITED
       THEN
          MOVE J-GETMOUSEPOS(WS-MOVED, WS-X, WS-Y) TO WS-RET
          MOVE J-DRAWLINE(WS-CANVAS-2, 
                          WS-START-X, WS-START-Y, 
                          WS-X, WS-Y) TO WS-RET         
          DISPLAY "Mouse Exited in Canvas 2 to " 
                  WS-X 
                  "  " 
                  WS-Y
          END-DISPLAY
       END-IF
    END-PERFORM
    
    MOVE J-QUIT() TO WS-RET

    STOP RUN
    
    .
 MAIN-MOUSELISTENER-EX.
    EXIT.
 END PROGRAM mouselistener.
