*>******************************************************************************
*>  This file is part of cobjapi.
*>
*>  splitpane.cob is free software: you can redistribute it and/or 
*>  modify it under the terms of the GNU Lesser General Public License as 
*>  published by the Free Software Foundation, either version 3 of the License,
*>  or (at your option) any later version.
*>
*>  splitpane.cob is distributed in the hope that it will be useful, 
*>  but WITHOUT ANY WARRANTY; without even the implied warranty of 
*>  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
*>  See the GNU Lesser General Public License for more details.
*>
*>  You should have received a copy of the GNU Lesser General Public License 
*>  along with splitpane.cob.
*>  If not, see <http://www.gnu.org/licenses/>.
*>******************************************************************************

*>******************************************************************************
*> Program:      splitpane.cob
*>
*> Purpose:      Example GnuCOBOL program for JAPI
*>
*> Author:       Laszlo Erdos - https://www.facebook.com/wortfee
*>
*> Date-Written: 2018.03.13
*>
*> Tectonics:    Example for static link.
*>               cobc -x -free splitpane.cob cobjapi.o \
*>                                           japilib.o \
*>                                           imageio.o \
*>                                           fileselect.o
*>
*> Usage:        ./splitpane.exe
*>
*>******************************************************************************
*> Date       Name / Change description 
*> ========== ==================================================================
*> 2003.02.26 This comment is only for History. The latest Version (V1.0.6) of 
*>            JAPI was released on 02/26/2003. Homepage: http://www.japi.de 
*>------------------------------------------------------------------------------
*> 2018.03.13 Laszlo Erdos: 
*>            - GnuCOBOL support for JAPI added. 
*>            - splitpane.c converted into splitpane.cob. 
*>------------------------------------------------------------------------------
*> 2020.05.23 Laszlo Erdos: 
*>            - BINARY-INT replaced with BINARY-LONG.
*>******************************************************************************

 IDENTIFICATION DIVISION.
 PROGRAM-ID. splitpane.

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
 01 WS-PANEL-1                         BINARY-LONG.
 01 WS-PANEL-2                         BINARY-LONG.
 01 WS-SP                              BINARY-LONG.
 01 WS-LABEL                           BINARY-LONG.
 
*> function args 
 01 WS-DEBUG-LEVEL                     BINARY-LONG.
 01 WS-POS                             BINARY-LONG.
 01 WS-R                               BINARY-LONG.
 01 WS-G                               BINARY-LONG.
 01 WS-B                               BINARY-LONG.

 PROCEDURE DIVISION.

*>------------------------------------------------------------------------------
 MAIN-SPLITPANE SECTION.
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
    MOVE J-FRAME("Split Pane Demo")  TO WS-FRAME  
    MOVE J-SETBORDERLAYOUT(WS-FRAME) TO WS-RET
    
    MOVE 142 TO WS-POS
    MOVE J-SPLITPANE(WS-FRAME, J-HORIZONTAL, WS-POS) TO WS-SP
    MOVE J-SETBORDERPOS(WS-SP, J-CENTER) TO WS-RET
    
    MOVE J-PANEL(WS-SP) TO WS-PANEL-1
    MOVE 255 TO WS-R
    MOVE   0 TO WS-G
    MOVE   0 TO WS-B
	MOVE J-SETCOLORBG(WS-PANEL-1, WS-R, WS-G, WS-B)  TO WS-RET
    MOVE J-LABEL(WS-PANEL-1, "Left Panel") TO WS-LABEL
    
    MOVE J-PANEL(WS-SP) TO WS-PANEL-2
    MOVE 255 TO WS-R
    MOVE 255 TO WS-G
    MOVE   0 TO WS-B
	MOVE J-SETCOLORBG(WS-PANEL-2, WS-R, WS-G, WS-B)  TO WS-RET
    MOVE J-LABEL(WS-PANEL-2, "Right Panel") TO WS-LABEL
    
    MOVE J-SETSPLITPANELEFT(WS-SP, WS-PANEL-1)  TO WS-RET
    MOVE J-SETSPLITPANERIGHT(WS-SP, WS-PANEL-2) TO WS-RET
    
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
 MAIN-SPLITPANE-EX.
    EXIT.
 END PROGRAM splitpane.
