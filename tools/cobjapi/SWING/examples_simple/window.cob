*>******************************************************************************
*>  This file is part of cobjapi.
*>
*>  window.cob is free software: you can redistribute it and/or 
*>  modify it under the terms of the GNU Lesser General Public License as 
*>  published by the Free Software Foundation, either version 3 of the License,
*>  or (at your option) any later version.
*>
*>  window.cob is distributed in the hope that it will be useful, 
*>  but WITHOUT ANY WARRANTY; without even the implied warranty of 
*>  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
*>  See the GNU Lesser General Public License for more details.
*>
*>  You should have received a copy of the GNU Lesser General Public License 
*>  along with window.cob.
*>  If not, see <http://www.gnu.org/licenses/>.
*>******************************************************************************

*>******************************************************************************
*> Program:      window.cob
*>
*> Purpose:      Example GnuCOBOL program for JAPI
*>
*> Author:       Laszlo Erdos - https://www.facebook.com/wortfee
*>
*> Date-Written: 2014.12.24
*>
*> Tectonics:    Example for static link.
*>               cobc -x -free window.cob cobjapi.o \
*>                                        japilib.o \
*>                                        imageio.o \
*>                                        fileselect.o
*>
*> Usage:        ./window.exe
*>
*>******************************************************************************
*> Date       Name / Change description 
*> ========== ==================================================================
*> 2003.02.26 This comment is only for History. The latest Version (V1.0.6) of 
*>            JAPI was released on 02/26/2003. Homepage: http://www.japi.de 
*>------------------------------------------------------------------------------
*> 2014.12.24 Laszlo Erdos: 
*>            - GnuCOBOL support for JAPI added. 
*>            - window.c converted into window.cob. 
*>------------------------------------------------------------------------------
*> 2020.05.23 Laszlo Erdos: 
*>            - BINARY-INT replaced with BINARY-LONG.
*>******************************************************************************

 IDENTIFICATION DIVISION.
 PROGRAM-ID. window.

 ENVIRONMENT DIVISION.
 CONFIGURATION SECTION.
 REPOSITORY.
    FUNCTION ALL INTRINSIC
    COPY "CobjapiFunctions.cpy".

 DATA DIVISION.

 WORKING-STORAGE SECTION.
 COPY "CobjapiConstants.cpy".
 
*> function return value 
 01 WS-RET                             BINARY-LONG.

*> GUI elements
 01 WS-FRAME                           BINARY-LONG.
 01 WS-LABEL                           BINARY-LONG.
 01 WS-WINDOW                          BINARY-LONG.
 01 WS-RELEASED                        BINARY-LONG.
 01 WS-PRESSED                         BINARY-LONG.
 01 WS-OBJ                             BINARY-LONG.
 
*> function args 
 01 WS-DEBUG-LEVEL                     BINARY-LONG.
 01 WS-XPOS                            BINARY-LONG.
 01 WS-YPOS                            BINARY-LONG.
 01 WS-X                               BINARY-LONG.
 01 WS-Y                               BINARY-LONG.
 01 WS-FX                              BINARY-LONG.
 01 WS-FY                              BINARY-LONG.
 01 WS-X-DISP                          PIC 9(4).
 01 WS-Y-DISP                          PIC 9(4).
 01 WS-FX-DISP                         PIC 9(4).
 01 WS-FY-DISP                         PIC 9(4).
 01 WS-MESSAGE                         PIC X(256).
 
 PROCEDURE DIVISION.

*>------------------------------------------------------------------------------
 MAIN-WINDOW SECTION.
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
    MOVE J-FRAME("Window Demo, press the mouse") TO WS-FRAME  
                                      
    MOVE J-WINDOW(WS-FRAME) TO WS-WINDOW
    MOVE J-SETFLOWLAYOUT(WS-WINDOW, J-HORIZONTAL) TO WS-RET

    MOVE J-LABEL(WS-WINDOW, " ") TO WS-LABEL
    MOVE J-SETNAMEDCOLORBG(WS-LABEL, J-YELLOW) TO WS-RET

    MOVE J-MOUSELISTENER(WS-FRAME, J-PRESSED)  TO WS-PRESSED
    MOVE J-MOUSELISTENER(WS-FRAME, J-RELEASED) TO WS-RELEASED

    MOVE J-SHOW(WS-FRAME) TO WS-RET
    
*>  Waiting for actions
    PERFORM FOREVER
       MOVE J-NEXTACTION() TO WS-OBJ

       IF WS-OBJ = WS-PRESSED
       THEN
          MOVE J-GETPOS(WS-FRAME, WS-FX, WS-FY) TO WS-RET
          MOVE WS-FX TO WS-FX-DISP
          MOVE WS-FY TO WS-FY-DISP
          DISPLAY "Framepos = " WS-FX-DISP " : " WS-FY-DISP END-DISPLAY

          MOVE J-GETMOUSEPOS(WS-PRESSED, WS-X, WS-Y) TO WS-RET
          MOVE WS-X TO WS-X-DISP
          MOVE WS-Y TO WS-Y-DISP
          MOVE SPACES TO WS-MESSAGE
          STRING "Mouse pressed at " DELIMITED BY SIZE
                 WS-X-DISP           DELIMITED BY SIZE
                 " : "               DELIMITED BY SIZE
                 WS-Y-DISP           DELIMITED BY SIZE 
            INTO WS-MESSAGE
          END-STRING  
          
          MOVE J-SETTEXT(WS-LABEL, WS-MESSAGE)  TO WS-RET
          COMPUTE WS-XPOS = WS-FX + WS-X END-COMPUTE
          COMPUTE WS-YPOS = WS-FY + WS-Y END-COMPUTE
          MOVE J-SETPOS(WS-WINDOW, WS-XPOS, WS-YPOS)     TO WS-RET

          MOVE J-PACK(WS-WINDOW) TO WS-RET
          MOVE J-SHOW(WS-WINDOW) TO WS-RET
       END-IF

       IF WS-OBJ = WS-RELEASED
       THEN
          MOVE J-HIDE(WS-WINDOW) TO WS-RET
       END-IF
       
       IF WS-OBJ = WS-FRAME
       THEN
          EXIT PERFORM
       END-IF
    END-PERFORM
    
    MOVE J-QUIT() TO WS-RET

    STOP RUN
    
    .
 MAIN-WINDOW-EX.
    EXIT.
 END PROGRAM window.
