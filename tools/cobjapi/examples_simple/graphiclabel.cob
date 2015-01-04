*>******************************************************************************
*>  This file is part of cobjapi.
*>
*>  graphiclabel.cob is free software: you can redistribute it and/or 
*>  modify it under the terms of the GNU Lesser General Public License as 
*>  published by the Free Software Foundation, either version 3 of the License,
*>  or (at your option) any later version.
*>
*>  graphiclabel.cob is distributed in the hope that it will be useful, 
*>  but WITHOUT ANY WARRANTY; without even the implied warranty of 
*>  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
*>  See the GNU Lesser General Public License for more details.
*>
*>  You should have received a copy of the GNU Lesser General Public License 
*>  along with graphiclabel.cob.
*>  If not, see <http://www.gnu.org/licenses/>.
*>******************************************************************************

*>******************************************************************************
*> Program:      graphiclabel.cob
*>
*> Purpose:      Example GnuCOBOL program for JAPI
*>
*> Author:       Laszlo Erdos - https://www.facebook.com/wortfee
*>
*> Date-Written: 2014.12.24
*>
*> Tectonics:    Example for static link.
*>               cobc -x -free graphiclabel.cob cobjapi.o \
*>                                              japilib.o \
*>                                              imageio.o \
*>                                              fileselect.o
*>
*> Usage:        ./graphiclabel.exe
*>
*>******************************************************************************
*> Date       Name / Change description 
*> ========== ==================================================================
*> 2003.02.26 This comment is only for History. The latest Version (V1.0.6) of 
*>            JAPI was released on 02/26/2003. Homepage: http://www.japi.de 
*>------------------------------------------------------------------------------
*> 2014.12.24 Laszlo Erdos: 
*>            - GnuCOBOL support for JAPI added. 
*>            - graphiclabel.c converted into graphiclabel.cob. 
*>******************************************************************************

 IDENTIFICATION DIVISION.
 PROGRAM-ID. graphiclabel.
 AUTHOR.     Laszlo Erdos.

 ENVIRONMENT DIVISION.
 CONFIGURATION SECTION.
 REPOSITORY.
    FUNCTION J-SETDEBUG
    FUNCTION J-START
    FUNCTION J-FRAME
    FUNCTION J-GRAPHICLABEL
    FUNCTION J-SETPOS
    FUNCTION J-SETSIZE
    FUNCTION J-SHOW
    FUNCTION J-PACK
    FUNCTION J-NEXTACTION
    FUNCTION J-QUIT
    FUNCTION ALL INTRINSIC.

 DATA DIVISION.

 WORKING-STORAGE SECTION.
*> function return value 
 01 WS-RET                             BINARY-INT.

*> GUI elements
 01 WS-FRAME                           BINARY-INT.
 01 WS-LABEL                           BINARY-INT.
 01 WS-OBJ                             BINARY-INT.
 
*> function args 
 01 WS-DEBUG-LEVEL                     BINARY-INT.
 01 WS-WIDTH                           BINARY-INT.
 01 WS-HEIGHT                          BINARY-INT.
 01 WS-XPOS                            BINARY-INT.
 01 WS-YPOS                            BINARY-INT.
 
 PROCEDURE DIVISION.

*>------------------------------------------------------------------------------
 MAIN-GRAPHICLABEL SECTION.
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
    MOVE J-FRAME("Graphic Labels") TO WS-FRAME  
                                       
    MOVE J-GRAPHICLABEL(WS-FRAME, "images/mandel.gif") TO WS-LABEL
    MOVE  10 TO WS-XPOS
    MOVE  30 TO WS-YPOS
    MOVE J-SETPOS(WS-LABEL, WS-XPOS, WS-YPOS)          TO WS-RET
    MOVE  50 TO WS-WIDTH
    MOVE  50 TO WS-HEIGHT
    MOVE J-SETSIZE(WS-LABEL, WS-WIDTH, WS-HEIGHT)      TO WS-RET

    MOVE J-GRAPHICLABEL(WS-FRAME, "images/mandel.gif") TO WS-LABEL
    MOVE  70 TO WS-XPOS
    MOVE  30 TO WS-YPOS
    MOVE J-SETPOS(WS-LABEL, WS-XPOS, WS-YPOS)          TO WS-RET
    MOVE 150 TO WS-WIDTH
    MOVE 240 TO WS-HEIGHT
    MOVE J-SETSIZE(WS-LABEL, WS-WIDTH, WS-HEIGHT)      TO WS-RET

    MOVE J-GRAPHICLABEL(WS-FRAME, "images/mandel.gif") TO WS-LABEL
    MOVE 230 TO WS-XPOS
    MOVE  30 TO WS-YPOS
    MOVE J-SETPOS(WS-LABEL, WS-XPOS, WS-YPOS)          TO WS-RET

    MOVE J-SHOW(WS-FRAME) TO WS-RET
    MOVE J-PACK(WS-FRAME) TO WS-RET

*>  Waiting for actions
    PERFORM FOREVER
       MOVE J-NEXTACTION() TO WS-OBJ

       IF WS-OBJ = WS-FRAME
       THEN
          EXIT PERFORM
       END-IF
    END-PERFORM
    
    MOVE J-QUIT() TO WS-RET

    STOP RUN
    
    .
 MAIN-GRAPHICLABEL-EX.
    EXIT.
 END PROGRAM graphiclabel.
