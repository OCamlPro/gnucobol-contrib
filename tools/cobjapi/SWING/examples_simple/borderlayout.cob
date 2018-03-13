*>******************************************************************************
*>  This file is part of cobjapi.
*>
*>  borderlayout.cob is free software: you can redistribute it and/or 
*>  modify it under the terms of the GNU Lesser General Public License as 
*>  published by the Free Software Foundation, either version 3 of the License,
*>  or (at your option) any later version.
*>
*>  borderlayout.cob is distributed in the hope that it will be useful, 
*>  but WITHOUT ANY WARRANTY; without even the implied warranty of 
*>  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
*>  See the GNU Lesser General Public License for more details.
*>
*>  You should have received a copy of the GNU Lesser General Public License 
*>  along with borderlayout.cob.
*>  If not, see <http://www.gnu.org/licenses/>.
*>******************************************************************************

*>******************************************************************************
*> Program:      borderlayout.cob
*>
*> Purpose:      Example GnuCOBOL program for JAPI
*>
*> Author:       Laszlo Erdos - https://www.facebook.com/wortfee
*>
*> Date-Written: 2014.12.24
*>
*> Tectonics:    Example for static link.
*>               cobc -x -free borderlayout.cob cobjapi.o \
*>                                              japilib.o \
*>                                              imageio.o \
*>                                              fileselect.o
*>
*> Usage:        ./borderlayout.exe
*>
*>******************************************************************************
*> Date       Name / Change description 
*> ========== ==================================================================
*> 2003.02.26 This comment is only for History. The latest Version (V1.0.6) of 
*>            JAPI was released on 02/26/2003. Homepage: http://www.japi.de 
*>------------------------------------------------------------------------------
*> 2014.12.24 Laszlo Erdos: 
*>            - GnuCOBOL support for JAPI added. 
*>            - borderlayout.c converted into borderlayout.cob. 
*>******************************************************************************

 IDENTIFICATION DIVISION.
 PROGRAM-ID. borderlayout.
 AUTHOR.     Laszlo Erdos.

 ENVIRONMENT DIVISION.
 CONFIGURATION SECTION.
 REPOSITORY.
    FUNCTION J-SETDEBUG
    FUNCTION J-START
    FUNCTION J-FRAME
    FUNCTION J-SETBORDERLAYOUT
    FUNCTION J-BUTTON
    FUNCTION J-SETBORDERPOS
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
 01 WS-LEFT                            BINARY-INT.
 01 WS-RIGHT                           BINARY-INT.
 01 WS-BOTTOM                          BINARY-INT.
 01 WS-TOP                             BINARY-INT.
 01 WS-CENTER                          BINARY-INT.

*> function args 
 01 WS-DEBUG-LEVEL                     BINARY-INT.
 
*> Constants for the cobjapi wrapper 
 COPY "cobjapi.cpy".
 
 PROCEDURE DIVISION.

*>------------------------------------------------------------------------------
 MAIN-BORDERLAYOUT SECTION.
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
    MOVE J-FRAME("Border Layout") TO WS-FRAME  

    MOVE J-SETBORDERLAYOUT(WS-FRAME) TO WS-RET

    MOVE J-BUTTON(WS-FRAME, "RIGHT")  TO WS-RIGHT  
    MOVE J-BUTTON(WS-FRAME, "LEFT")   TO WS-LEFT   
    MOVE J-BUTTON(WS-FRAME, "BOTTOM") TO WS-BOTTOM 
    MOVE J-BUTTON(WS-FRAME, "TOP")    TO WS-TOP    
    MOVE J-BUTTON(WS-FRAME, "CENTER") TO WS-CENTER 

    MOVE J-SETBORDERPOS(WS-RIGHT, J-RIGHT)   TO WS-RET
    MOVE J-SETBORDERPOS(WS-LEFT, J-LEFT)     TO WS-RET
    MOVE J-SETBORDERPOS(WS-BOTTOM, J-BOTTOM) TO WS-RET
    MOVE J-SETBORDERPOS(WS-TOP, J-TOP)       TO WS-RET

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
 MAIN-BORDERLAYOUT-EX.
    EXIT.
 END PROGRAM borderlayout.
