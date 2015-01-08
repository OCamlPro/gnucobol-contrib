*>******************************************************************************
*>  This file is part of cobjapi.
*>
*>  digits.cob is free software: you can redistribute it and/or 
*>  modify it under the terms of the GNU Lesser General Public License as 
*>  published by the Free Software Foundation, either version 3 of the License,
*>  or (at your option) any later version.
*>
*>  digits.cob is distributed in the hope that it will be useful, 
*>  but WITHOUT ANY WARRANTY; without even the implied warranty of 
*>  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
*>  See the GNU Lesser General Public License for more details.
*>
*>  You should have received a copy of the GNU Lesser General Public License 
*>  along with digits.cob.
*>  If not, see <http://www.gnu.org/licenses/>.
*>******************************************************************************

*>******************************************************************************
*> Program:      digits.cob
*>
*> Purpose:      Example GnuCOBOL program for JAPI
*>
*> Author:       Laszlo Erdos - https://www.facebook.com/wortfee
*>
*> Date-Written: 2014.12.24
*>
*> Tectonics:    Example for static link.
*>               cobc -x -free digits.cob cobjapi.o \
*>                                        japilib.o \
*>                                        imageio.o \
*>                                        fileselect.o
*>
*> Usage:        ./digits.exe
*>
*>******************************************************************************
*> Date       Name / Change description 
*> ========== ==================================================================
*> 2003.02.26 This comment is only for History. The latest Version (V1.0.6) of 
*>            JAPI was released on 02/26/2003. Homepage: http://www.japi.de 
*>------------------------------------------------------------------------------
*> 2015.01.08 Laszlo Erdos: 
*>            - GnuCOBOL support for JAPI added. 
*>            - digits.c converted into digits.cob. 
*>******************************************************************************

 IDENTIFICATION DIVISION.
 PROGRAM-ID. digits.
 AUTHOR.     Laszlo Erdos.

 ENVIRONMENT DIVISION.
 CONFIGURATION SECTION.
 REPOSITORY.
*> Functions for the cobjapi wrapper 
 COPY "cobjapifn.cpy".

 DATA DIVISION.

 WORKING-STORAGE SECTION.
*> Constants for the cobjapi wrapper 
 COPY "cobjapi.cpy".
 
*> function return value 
 01 WS-RET                             BINARY-INT.

*> GUI elements
 01 WS-FRAME                           BINARY-INT.
 01 WS-PANEL                           BINARY-INT.
 01 WS-SEVEN                           BINARY-INT.
 01 WS-OBJ                             BINARY-INT.

 01 WS-MOUSE-TAB.
   02 WS-MOUSE-TAB-LINES OCCURS 4 TIMES.
     03 WS-MOUSE-TAB-LINE              BINARY-INT.
 01 WS-LED-TAB.
   02 WS-LED-TAB-LINES   OCCURS 4 TIMES.
     03 WS-LED-TAB-LINE                BINARY-INT.
 
*> function args 
 01 WS-DEBUG-LEVEL                     BINARY-INT.
 01 WS-TOP                             BINARY-INT.
 01 WS-BOTTOM                          BINARY-INT.
 01 WS-LEFT                            BINARY-INT.
 01 WS-RIGHT                           BINARY-INT.
 01 WS-HGAP                            BINARY-INT.
 01 WS-VGAP                            BINARY-INT.
 01 WS-WIDTH                           BINARY-INT.
 01 WS-HEIGHT                          BINARY-INT.
 01 WS-VALUE                           BINARY-INT.

*> vars
 01 WS-IND                             BINARY-INT.
 
 PROCEDURE DIVISION.

*>------------------------------------------------------------------------------
 MAIN-DIGITS SECTION.
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
    MOVE J-FRAME("Digits") TO WS-FRAME  
    MOVE J-SETBORDERLAYOUT(WS-FRAME) TO WS-RET
    COMPUTE WS-TOP = J-GETINSETS(WS-FRAME, J-TOP) + 10 END-COMPUTE
    MOVE 10 TO WS-BOTTOM
    MOVE 10 TO WS-LEFT
    MOVE 10 TO WS-RIGHT
    MOVE J-SETINSETS(WS-FRAME, WS-TOP, WS-BOTTOM, WS-LEFT, WS-RIGHT) TO WS-RET
    MOVE 10 TO WS-VGAP
    MOVE J-SETVGAP(WS-FRAME, WS-VGAP) TO WS-RET    
    
    MOVE J-PANEL(WS-FRAME)                       TO WS-PANEL
    MOVE J-SETBORDERPOS(WS-PANEL, J-BOTTOM)      TO WS-RET
    MOVE J-SETFLOWLAYOUT(WS-PANEL, J-HORIZONTAL) TO WS-RET
    MOVE 10 TO WS-HGAP
    MOVE J-SETHGAP(WS-PANEL, WS-HGAP)            TO WS-RET    
    
    PERFORM VARYING WS-IND FROM 4 BY -1 UNTIL WS-IND < 1
       MOVE J-LED(WS-PANEL, J-ROUND, J-RED) 
         TO WS-LED-TAB-LINE(WS-IND)
       MOVE J-MOUSELISTENER(WS-LED-TAB-LINE(WS-IND), J-RELEASED) 
         TO WS-MOUSE-TAB-LINE(WS-IND)
    END-PERFORM    

    MOVE J-SEVENSEGMENT(WS-FRAME, J-GREEN) TO WS-SEVEN
    
    MOVE 150 TO WS-WIDTH
    MOVE 250 TO WS-HEIGHT
    MOVE J-SETSIZE(WS-FRAME, WS-WIDTH, WS-HEIGHT) TO WS-RET
    MOVE J-SHOW(WS-FRAME) TO WS-RET
    
*>  Waiting for actions
    PERFORM FOREVER
       MOVE J-NEXTACTION() TO WS-OBJ

       IF WS-OBJ = WS-FRAME
       THEN
          EXIT PERFORM
       END-IF

       PERFORM VARYING WS-IND FROM 1 BY 1 UNTIL WS-IND > 4
          IF WS-OBJ = WS-MOUSE-TAB-LINE(WS-IND)
          THEN
             MOVE J-GETSTATE(WS-LED-TAB-LINE(WS-IND)) TO WS-RET
             IF WS-RET = J-TRUE
             THEN
                MOVE J-SETSTATE(WS-LED-TAB-LINE(WS-IND), J-FALSE) TO WS-RET
             ELSE
                MOVE J-SETSTATE(WS-LED-TAB-LINE(WS-IND), J-TRUE)  TO WS-RET
             END-IF
          END-IF    
       END-PERFORM    

       COMPUTE WS-VALUE = J-GETSTATE(WS-LED-TAB-LINE(4)) * 8
                        + J-GETSTATE(WS-LED-TAB-LINE(3)) * 4
                        + J-GETSTATE(WS-LED-TAB-LINE(2)) * 2
                        + J-GETSTATE(WS-LED-TAB-LINE(1))
       END-COMPUTE
       MOVE J-SETVALUE(WS-SEVEN, WS-VALUE) TO WS-RET
    END-PERFORM
    
    MOVE J-QUIT() TO WS-RET

    STOP RUN
    
    .
 MAIN-DIGITS-EX.
    EXIT.
 END PROGRAM digits.
