*>******************************************************************************
*>  This file is part of cobjapi.
*>
*>  radiobutton.cob is free software: you can redistribute it and/or 
*>  modify it under the terms of the GNU Lesser General Public License as 
*>  published by the Free Software Foundation, either version 3 of the License,
*>  or (at your option) any later version.
*>
*>  radiobutton.cob is distributed in the hope that it will be useful, 
*>  but WITHOUT ANY WARRANTY; without even the implied warranty of 
*>  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
*>  See the GNU Lesser General Public License for more details.
*>
*>  You should have received a copy of the GNU Lesser General Public License 
*>  along with radiobutton.cob.
*>  If not, see <http://www.gnu.org/licenses/>.
*>******************************************************************************

*>******************************************************************************
*> Program:      radiobutton.cob
*>
*> Purpose:      Example GnuCOBOL program for JAPI
*>
*> Author:       Laszlo Erdos - https://www.facebook.com/wortfee
*>
*> Date-Written: 2014.12.24
*>
*> Tectonics:    Example for static link.
*>               cobc -x -free radiobutton.cob cobjapi.o \
*>                                             japilib.o \
*>                                             imageio.o \
*>                                             fileselect.o
*>
*> Usage:        ./radiobutton.exe
*>
*>******************************************************************************
*> Date       Name / Change description 
*> ========== ==================================================================
*> 2003.02.26 This comment is only for History. The latest Version (V1.0.6) of 
*>            JAPI was released on 02/26/2003. Homepage: http://www.japi.de 
*>------------------------------------------------------------------------------
*> 2014.12.24 Laszlo Erdos: 
*>            - GnuCOBOL support for JAPI added. 
*>            - radiobutton.c converted into radiobutton.cob. 
*>------------------------------------------------------------------------------
*> 2020.05.23 Laszlo Erdos: 
*>            - BINARY-INT replaced with BINARY-LONG.
*>******************************************************************************

 IDENTIFICATION DIVISION.
 PROGRAM-ID. radiobutton.

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
 01 WS-RADIO                           BINARY-LONG.
 01 WS-ENABLE                          BINARY-LONG.
 01 WS-MIDDLE                          BINARY-LONG.
 01 WS-DISABLE                         BINARY-LONG.
 01 WS-OBJ                             BINARY-LONG.

*> FUNCTION ARGS 
 01 WS-DEBUG-LEVEL                     BINARY-LONG.
 01 WS-XPOS                            BINARY-LONG.
 01 WS-YPOS                            BINARY-LONG.
 
 PROCEDURE DIVISION.

*>------------------------------------------------------------------------------
 MAIN-RADIOBUTTON SECTION.
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
    MOVE J-FRAME("Radiobuttons") TO WS-FRAME  

    MOVE J-RADIOGROUP(WS-FRAME)  TO WS-RADIO

    MOVE J-RADIOBUTTON(WS-RADIO, "Enable middle Button") TO WS-ENABLE  
    MOVE 120 TO WS-XPOS
    MOVE  80 TO WS-YPOS
    MOVE J-SETPOS(WS-ENABLE, WS-XPOS, WS-YPOS) TO WS-RET

    MOVE J-RADIOBUTTON(WS-RADIO, "Middle Button") TO WS-MIDDLE  
    MOVE 120 TO WS-XPOS
    MOVE 120 TO WS-YPOS
    MOVE J-SETPOS(WS-MIDDLE, WS-XPOS, WS-YPOS) TO WS-RET

    MOVE J-RADIOBUTTON(WS-RADIO, "Disable middle Button") TO WS-DISABLE  
    MOVE 120 TO WS-XPOS
    MOVE 160 TO WS-YPOS
    MOVE J-SETPOS(WS-DISABLE, WS-XPOS, WS-YPOS) TO WS-RET

    MOVE J-SETSTATE(WS-ENABLE, J-TRUE) TO WS-RET
    
    MOVE J-SHOW(WS-FRAME) TO WS-RET

*>  Waiting for actions
    PERFORM FOREVER
       MOVE J-NEXTACTION() TO WS-OBJ

       IF WS-OBJ = WS-FRAME
       THEN
          EXIT PERFORM
       END-IF
       
       IF (WS-OBJ = WS-ENABLE) 
       THEN
          MOVE J-ENABLE(WS-MIDDLE)  TO WS-RET
       END-IF

       IF (WS-OBJ = WS-DISABLE) 
       THEN
          MOVE J-DISABLE(WS-MIDDLE) TO WS-RET
       END-IF
    END-PERFORM
    
    MOVE J-QUIT() TO WS-RET

    STOP RUN
    
    .
 MAIN-RADIOBUTTON-EX.
    EXIT.
 END PROGRAM radiobutton.
