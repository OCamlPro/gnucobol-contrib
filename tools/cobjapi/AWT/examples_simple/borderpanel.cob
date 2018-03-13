*>******************************************************************************
*>  This file is part of cobjapi.
*>
*>  borderpanel.cob is free software: you can redistribute it and/or 
*>  modify it under the terms of the GNU Lesser General Public License as 
*>  published by the Free Software Foundation, either version 3 of the License,
*>  or (at your option) any later version.
*>
*>  borderpanel.cob is distributed in the hope that it will be useful, 
*>  but WITHOUT ANY WARRANTY; without even the implied warranty of 
*>  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
*>  See the GNU Lesser General Public License for more details.
*>
*>  You should have received a copy of the GNU Lesser General Public License 
*>  along with borderpanel.cob.
*>  If not, see <http://www.gnu.org/licenses/>.
*>******************************************************************************

*>******************************************************************************
*> Program:      borderpanel.cob
*>
*> Purpose:      Example GnuCOBOL program for JAPI
*>
*> Author:       Laszlo Erdos - https://www.facebook.com/wortfee
*>
*> Date-Written: 2014.12.24
*>
*> Tectonics:    Example for static link.
*>               cobc -x -free borderpanel.cob cobjapi.o \
*>                                             japilib.o \
*>                                             imageio.o \
*>                                             fileselect.o
*>
*> Usage:        ./borderpanel.exe
*>
*>******************************************************************************
*> Date       Name / Change description 
*> ========== ==================================================================
*> 2003.02.26 This comment is only for History. The latest Version (V1.0.6) of 
*>            JAPI was released on 02/26/2003. Homepage: http://www.japi.de 
*>------------------------------------------------------------------------------
*> 2014.12.24 Laszlo Erdos: 
*>            - GnuCOBOL support for JAPI added. 
*>            - borderpanel.c converted into borderpanel.cob. 
*>******************************************************************************

 IDENTIFICATION DIVISION.
 PROGRAM-ID. borderpanel.
 AUTHOR.     Laszlo Erdos.

 ENVIRONMENT DIVISION.
 CONFIGURATION SECTION.
 REPOSITORY.
    FUNCTION J-SETDEBUG
    FUNCTION J-START
    FUNCTION J-FRAME
    FUNCTION J-SETCOLORBG
    FUNCTION J-SETCOLOR
    FUNCTION J-SETGRIDLAYOUT
    FUNCTION J-SETHGAP
    FUNCTION J-BORDERPANEL
    FUNCTION J-SETFLOWLAYOUT
    FUNCTION J-LABEL
    FUNCTION J-PACK
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
 01 WS-PANEL                           BINARY-INT.
 01 WS-LABEL                           BINARY-INT.

*> Constants for the cobjapi wrapper 
 COPY "cobjapi.cpy".

*> function args 
 01 WS-DEBUG-LEVEL                     BINARY-INT.
 01 WS-R                               BINARY-INT.
 01 WS-G                               BINARY-INT.
 01 WS-B                               BINARY-INT.
 01 WS-ROW                             BINARY-INT.
 01 WS-COL                             BINARY-INT.
 01 WS-HGAP                            BINARY-INT.
 
 PROCEDURE DIVISION.

*>------------------------------------------------------------------------------
 MAIN-BORDERPANEL SECTION.
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
    MOVE J-FRAME("j-borderpanel")                  TO WS-FRAME  

    MOVE 220 TO WS-R
    MOVE 220 TO WS-G
    MOVE 220 TO WS-B
	MOVE J-SETCOLORBG(WS-FRAME, WS-R, WS-G, WS-B)  TO WS-RET

	MOVE 1 TO WS-ROW
    MOVE 4 TO WS-COL
    MOVE J-SETGRIDLAYOUT(WS-FRAME, WS-ROW, WS-COL) TO WS-RET

    MOVE 10 TO WS-HGAP
	MOVE J-SETHGAP(WS-FRAME, WS-HGAP)              TO WS-RET 

	MOVE J-BORDERPANEL(WS-FRAME, J-LINEDOWN)       TO WS-PANEL
    MOVE J-SETFLOWLAYOUT(WS-PANEL, J-HORIZONTAL)   TO WS-RET
    MOVE J-LABEL(WS-PANEL, "LINEDOWN")             TO WS-LABEL
    
    MOVE J-BORDERPANEL(WS-FRAME, J-LINEUP)         TO WS-PANEL
    MOVE J-SETFLOWLAYOUT(WS-PANEL, J-HORIZONTAL)   TO WS-RET
    MOVE J-LABEL(WS-PANEL, "LINEUP")               TO WS-LABEL
    
    MOVE J-BORDERPANEL(WS-FRAME, J-AREADOWN)       TO WS-PANEL
    MOVE J-SETFLOWLAYOUT(WS-PANEL, J-HORIZONTAL)   TO WS-RET
    MOVE J-LABEL(WS-PANEL, "AREADOWN")             TO WS-LABEL
                                                   
    MOVE J-BORDERPANEL(WS-FRAME, J-AREAUP)         TO WS-PANEL
    MOVE J-SETFLOWLAYOUT(WS-PANEL, J-HORIZONTAL)   TO WS-RET
    MOVE J-LABEL(WS-PANEL, "AREAUP")               TO WS-LABEL

	MOVE J-PACK(WS-FRAME) TO WS-RET
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
 MAIN-BORDERPANEL-EX.
    EXIT.
 END PROGRAM borderpanel.
