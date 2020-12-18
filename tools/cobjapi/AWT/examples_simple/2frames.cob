*>******************************************************************************
*>  This file is part of cobjapi.
*>
*>  2frames.cob is free software: you can redistribute it and/or 
*>  modify it under the terms of the GNU Lesser General Public License as 
*>  published by the Free Software Foundation, either version 3 of the License,
*>  or (at your option) any later version.
*>
*>  2frames.cob is distributed in the hope that it will be useful, 
*>  but WITHOUT ANY WARRANTY; without even the implied warranty of 
*>  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
*>  See the GNU Lesser General Public License for more details.
*>
*>  You should have received a copy of the GNU Lesser General Public License 
*>  along with 2frames.cob.
*>  If not, see <http://www.gnu.org/licenses/>.
*>******************************************************************************

*>******************************************************************************
*> Program:      2frames.cob
*>
*> Purpose:      Example GnuCOBOL program for JAPI
*>
*> Author:       Laszlo Erdos - https://www.facebook.com/wortfee
*>
*> Date-Written: 2018.03.13
*>
*> Tectonics:    Example for static link.
*>               cobc -x -free 2frames.cob cobjapi.o \
*>                                         japilib.o \
*>                                         imageio.o \
*>                                         fileselect.o
*>
*> Usage:        ./2frames.exe
*>
*>******************************************************************************
*> Date       Name / Change description 
*> ========== ==================================================================
*> 2003.02.26 This comment is only for History. The latest Version (V1.0.6) of 
*>            JAPI was released on 02/26/2003. Homepage: http://www.japi.de 
*>------------------------------------------------------------------------------
*> 2018.03.13 Laszlo Erdos: 
*>            - GnuCOBOL support for JAPI added. 
*>            - 2frames.c converted into 2frames.cob. 
*>******************************************************************************

 IDENTIFICATION DIVISION.
 PROGRAM-ID. 2frames.

 ENVIRONMENT DIVISION.
 CONFIGURATION SECTION.
 REPOSITORY.
    FUNCTION J-SETDEBUG
    FUNCTION J-START
    FUNCTION J-FRAME
    FUNCTION J-SHOW
    FUNCTION J-LOADIMAGE
    FUNCTION J-SETSIZE
    FUNCTION J-SETICON
    FUNCTION J-NEXTACTION
    FUNCTION J-QUIT
    FUNCTION ALL INTRINSIC.

 DATA DIVISION.

 WORKING-STORAGE SECTION.
*> function return value 
 01 WS-RET                             BINARY-LONG.

*> GUI elements
 01 WS-FRAME-1                         BINARY-LONG.
 01 WS-FRAME-2                         BINARY-LONG.
 01 WS-ICON                            BINARY-LONG.
 
*> function args 
 01 WS-DEBUG-LEVEL                     BINARY-LONG.
 01 WS-WIDTH                           BINARY-LONG.
 01 WS-HEIGHT                          BINARY-LONG.
 
 PROCEDURE DIVISION.

*>------------------------------------------------------------------------------
 MAIN-2FRAMES SECTION.
*>------------------------------------------------------------------------------

*>  MOVE 5 TO WS-DEBUG-LEVEL
*>  MOVE J-SETDEBUG(WS-DEBUG-LEVEL) TO WS-RET
 
    MOVE J-START() TO WS-RET
    IF WS-RET = ZEROES
    THEN
       DISPLAY "can't connect to server"
       STOP RUN
    END-IF

    MOVE J-LOADIMAGE("images/new.gif") TO WS-ICON  
    
*>  Generate GUI Objects    
    MOVE J-FRAME("Frame Demo1") TO WS-FRAME-1  
    MOVE 300 TO WS-WIDTH 
    MOVE 400 TO WS-HEIGHT 
    MOVE J-SETSIZE(WS-FRAME-1, WS-WIDTH, WS-HEIGHT) TO WS-RET
    MOVE J-SHOW(WS-FRAME-1) TO WS-RET
    MOVE J-SETICON(WS-FRAME-1, WS-ICON) TO WS-RET

    MOVE J-FRAME("Frame Demo2") TO WS-FRAME-2  
    MOVE 300 TO WS-WIDTH 
    MOVE 200 TO WS-HEIGHT 
    MOVE J-SETSIZE(WS-FRAME-2, WS-WIDTH, WS-HEIGHT) TO WS-RET
    MOVE J-SHOW(WS-FRAME-2) TO WS-RET
    MOVE J-SETICON(WS-FRAME-2, WS-ICON) TO WS-RET

*>  Waiting for actions
    PERFORM FOREVER
       MOVE J-NEXTACTION() TO WS-RET
       IF WS-RET = WS-FRAME-1
       THEN
          EXIT PERFORM
       END-IF
    END-PERFORM
    
    MOVE J-QUIT() TO WS-RET

    STOP RUN
    
    .
 MAIN-2FRAMES-EX.
    EXIT.
 END PROGRAM 2frames.
