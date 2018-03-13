*>******************************************************************************
*>  This file is part of cobjapi.
*>
*>  vumeter.cob is free software: you can redistribute it and/or 
*>  modify it under the terms of the GNU Lesser General Public License as 
*>  published by the Free Software Foundation, either version 3 of the License,
*>  or (at your option) any later version.
*>
*>  vumeter.cob is distributed in the hope that it will be useful, 
*>  but WITHOUT ANY WARRANTY; without even the implied warranty of 
*>  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
*>  See the GNU Lesser General Public License for more details.
*>
*>  You should have received a copy of the GNU Lesser General Public License 
*>  along with vumeter.cob.
*>  If not, see <http://www.gnu.org/licenses/>.
*>******************************************************************************

*>******************************************************************************
*> Program:      vumeter.cob
*>
*> Purpose:      Example GnuCOBOL program for JAPI
*>
*> Author:       Laszlo Erdos - https://www.facebook.com/wortfee
*>
*> Date-Written: 2014.12.24
*>
*> Tectonics:    Example for static link.
*>               cobc -x -free vumeter.cob cobjapi.o \
*>                                         japilib.o \
*>                                         imageio.o \
*>                                         fileselect.o
*>
*> Usage:        ./vumeter.exe
*>
*>******************************************************************************
*> Date       Name / Change description 
*> ========== ==================================================================
*> 2003.02.26 This comment is only for History. The latest Version (V1.0.6) of 
*>            JAPI was released on 02/26/2003. Homepage: http://www.japi.de 
*>------------------------------------------------------------------------------
*> 2014.12.24 Laszlo Erdos: 
*>            - GnuCOBOL support for JAPI added. 
*>            - vumeter.c converted into vumeter.cob. 
*>******************************************************************************

 IDENTIFICATION DIVISION.
 PROGRAM-ID. vumeter.
 AUTHOR.     Laszlo Erdos.

 ENVIRONMENT DIVISION.
 CONFIGURATION SECTION.
 REPOSITORY.
    FUNCTION J-SETDEBUG
    FUNCTION J-START
    FUNCTION J-FRAME
    FUNCTION J-SETBORDERLAYOUT
    FUNCTION J-GETINSETS
    FUNCTION J-SETINSETS
    FUNCTION J-SETVGAP
    FUNCTION J-PROGRESSBAR
    FUNCTION J-SETBORDERPOS
    FUNCTION J-METER
    FUNCTION J-SETSIZE
    FUNCTION J-SETMIN
    FUNCTION J-SETMAX
    FUNCTION J-SETDANGER
    FUNCTION J-GETACTION
    FUNCTION J-RANDOM
    FUNCTION J-SETVALUE
    FUNCTION J-SYNC
    FUNCTION J-SLEEP
    FUNCTION J-SHOW
    FUNCTION J-QUIT
    FUNCTION ALL INTRINSIC.

 DATA DIVISION.

 WORKING-STORAGE SECTION.
*> function return value 
 01 WS-RET                             BINARY-INT.

*> GUI elements
 01 WS-FRAME                           BINARY-INT.
 01 WS-PROGRESS                        BINARY-INT.
 01 WS-METER                           BINARY-INT.
 01 WS-OBJ                             BINARY-INT.

*> function args 
 01 WS-DEBUG-LEVEL                     BINARY-INT.
 01 WS-VALUE                           BINARY-INT VALUE 50.
 01 WS-VGAP                            BINARY-INT.
 01 WS-WIDTH                           BINARY-INT.
 01 WS-HEIGHT                          BINARY-INT.
 01 WS-MIN-VAL                         BINARY-INT.
 01 WS-MAX-VAL                         BINARY-INT.
 01 WS-DANGER-VAL                      BINARY-INT.
 01 WS-MSEC                            BINARY-INT. 
 01 WS-TOP                             BINARY-INT.
 01 WS-BOTTOM                          BINARY-INT.
 01 WS-LEFT                            BINARY-INT.
 01 WS-RIGHT                           BINARY-INT.
 
*> Constants for the cobjapi wrapper 
 COPY "cobjapi.cpy".
 
 PROCEDURE DIVISION.

*>------------------------------------------------------------------------------
 MAIN-VUMETER SECTION.
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
    MOVE J-FRAME("Meter") TO WS-FRAME  
    MOVE J-SETBORDERLAYOUT(WS-FRAME) TO WS-RET
    
    MOVE J-GETINSETS(WS-FRAME, J-TOP) TO WS-TOP
    COMPUTE WS-TOP = WS-TOP + 10 END-COMPUTE
    MOVE 10 TO WS-BOTTOM
    MOVE 10 TO WS-LEFT
    MOVE 10 TO WS-RIGHT
    MOVE J-SETINSETS(WS-FRAME, WS-TOP, WS-BOTTOM, WS-LEFT, WS-RIGHT) TO WS-RET

    MOVE 10 TO WS-VGAP
    MOVE J-SETVGAP(WS-FRAME, WS-VGAP) TO WS-RET

    MOVE J-PROGRESSBAR(WS-FRAME, J-HORIZONTAL) TO WS-PROGRESS
    MOVE J-SETBORDERPOS(WS-PROGRESS, J-BOTTOM) TO WS-RET
    MOVE J-METER(WS-FRAME, "Volt") TO WS-METER
   
    MOVE 150 TO WS-WIDTH
    MOVE 170 TO WS-HEIGHT
    MOVE J-SETSIZE(WS-FRAME, WS-WIDTH, WS-HEIGHT) TO WS-RET
    
    MOVE J-SHOW(WS-FRAME) TO WS-RET

    MOVE -100 TO WS-MIN-VAL
    MOVE J-SETMIN(WS-METER, WS-MIN-VAL) TO WS-RET
    MOVE 200  TO WS-MAX-VAL
    MOVE J-SETMAX(WS-METER, WS-MAX-VAL) TO WS-RET
    MOVE 100  TO WS-DANGER-VAL
    MOVE J-SETDANGER(WS-METER, WS-DANGER-VAL) TO WS-RET
    
*>  Waiting for actions
    PERFORM FOREVER
       MOVE J-GETACTION() TO WS-OBJ

       IF WS-OBJ = WS-FRAME
       THEN
          EXIT PERFORM
       END-IF

       COMPUTE WS-VALUE = WS-VALUE - 1 END-COMPUTE

       IF J-RANDOM() < (J-RANDMAX / 2)
       THEN
          COMPUTE WS-VALUE = WS-VALUE + 2 END-COMPUTE
       END-IF       

       MOVE J-SETVALUE(WS-METER, WS-VALUE)    TO WS-RET
       MOVE J-SETVALUE(WS-PROGRESS, WS-VALUE) TO WS-RET

       MOVE J-SYNC() TO WS-RET

       MOVE 50 TO WS-MSEC
       MOVE J-SLEEP(WS-MSEC) TO WS-RET
    END-PERFORM
    
    MOVE J-QUIT() TO WS-RET

    STOP RUN
    
    .
 MAIN-VUMETER-EX.
    EXIT.
 END PROGRAM vumeter.
