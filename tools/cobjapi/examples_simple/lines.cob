*>******************************************************************************
*>  This file is part of cobjapi.
*>
*>  lines.cob is free software: you can redistribute it and/or 
*>  modify it under the terms of the GNU Lesser General Public License as 
*>  published by the Free Software Foundation, either version 3 of the License,
*>  or (at your option) any later version.
*>
*>  lines.cob is distributed in the hope that it will be useful, 
*>  but WITHOUT ANY WARRANTY; without even the implied warranty of 
*>  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
*>  See the GNU Lesser General Public License for more details.
*>
*>  You should have received a copy of the GNU Lesser General Public License 
*>  along with lines.cob.
*>  If not, see <http://www.gnu.org/licenses/>.
*>******************************************************************************

*>******************************************************************************
*> Program:      lines.cob
*>
*> Purpose:      Example GnuCOBOL program for JAPI
*>
*> Author:       Laszlo Erdos - https://www.facebook.com/wortfee
*>
*> Date-Written: 2014.12.24
*>
*> Tectonics:    Example for static link.
*>               cobc -x -free lines.cob cobjapi.o \
*>                                       japilib.o \
*>                                       imageio.o \
*>                                       fileselect.o
*>
*> Usage:        ./lines.exe
*>
*>******************************************************************************
*> Date       Name / Change description 
*> ========== ==================================================================
*> 2003.02.26 This comment is only for History. The latest Version (V1.0.6) of 
*>            JAPI was released on 02/26/2003. Homepage: http://www.japi.de 
*>------------------------------------------------------------------------------
*> 2014.12.24 Laszlo Erdos: 
*>            - GnuCOBOL support for JAPI added. 
*>            - lines.c converted into lines.cob. 
*>******************************************************************************

 IDENTIFICATION DIVISION.
 PROGRAM-ID. lines.
 AUTHOR.     Laszlo Erdos.

 ENVIRONMENT DIVISION.
 CONFIGURATION SECTION.
 REPOSITORY.
    FUNCTION J-SETDEBUG
    FUNCTION J-START
    FUNCTION J-FRAME
    FUNCTION J-SETNAMEDCOLORBG
    FUNCTION J-LINE
    FUNCTION J-SETPOS
    FUNCTION J-SHOW
    FUNCTION J-NEXTACTION
    FUNCTION J-QUIT
    FUNCTION ALL INTRINSIC.

 DATA DIVISION.

 WORKING-STORAGE SECTION.
*> function return value 
 01 WS-RET                             BINARY-INT.

*> GUI elements
 01 WS-FRAME                           BINARY-INT.
 01 WS-LINE                            BINARY-INT.

*> function args 
 01 WS-DEBUG-LEVEL                     BINARY-INT.
 01 WS-LENGTH                          BINARY-INT.
 01 WS-XPOS                            BINARY-INT.
 01 WS-YPOS                            BINARY-INT.
 
*> Constants for the cobjapi wrapper 
 COPY "cobjapi.cpy".
 
 PROCEDURE DIVISION.

*>------------------------------------------------------------------------------
 MAIN-LINES SECTION.
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
    MOVE J-FRAME("Rulers") TO WS-FRAME  
    MOVE J-SETNAMEDCOLORBG(WS-FRAME, J-LIGHT-GRAY) TO WS-RET

    MOVE 200 TO WS-LENGTH
    MOVE J-LINE(WS-FRAME, J-HORIZONTAL, J-LINEDOWN, WS-LENGTH) TO WS-LINE
    MOVE 100 TO WS-XPOS
    MOVE 100 TO WS-YPOS
    MOVE J-SETPOS(WS-LINE, WS-XPOS, WS-YPOS) TO WS-RET    

    MOVE 200 TO WS-LENGTH
    MOVE J-LINE(WS-FRAME, J-HORIZONTAL, J-LINEUP, WS-LENGTH)   TO WS-LINE
    MOVE 100 TO WS-XPOS
    MOVE 200 TO WS-YPOS
    MOVE J-SETPOS(WS-LINE, WS-XPOS, WS-YPOS) TO WS-RET    

    MOVE 150 TO WS-LENGTH
    MOVE J-LINE(WS-FRAME, J-VERTICAL, J-LINEDOWN, WS-LENGTH)   TO WS-LINE
    MOVE  50 TO WS-XPOS
    MOVE  75 TO WS-YPOS
    MOVE J-SETPOS(WS-LINE, WS-XPOS, WS-YPOS) TO WS-RET    
    
    MOVE 150 TO WS-LENGTH
    MOVE J-LINE(WS-FRAME, J-VERTICAL, J-LINEUP, WS-LENGTH)     TO WS-LINE
    MOVE 350 TO WS-XPOS
    MOVE  75 TO WS-YPOS
    MOVE J-SETPOS(WS-LINE, WS-XPOS, WS-YPOS) TO WS-RET    
    
    MOVE J-SHOW(WS-FRAME) TO WS-RET

*>  Waiting for actions
    PERFORM FOREVER
       MOVE J-NEXTACTION() TO WS-RET
       IF WS-RET = WS-FRAME
       THEN
          EXIT PERFORM
       END-IF
    END-PERFORM
    
    MOVE J-QUIT() TO WS-RET

    STOP RUN
    
    .
 MAIN-LINES-EX.
    EXIT.
 END PROGRAM lines.
