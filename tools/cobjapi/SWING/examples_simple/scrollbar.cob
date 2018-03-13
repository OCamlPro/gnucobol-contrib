*>******************************************************************************
*>  This file is part of cobjapi.
*>
*>  scrollbar.cob is free software: you can redistribute it and/or 
*>  modify it under the terms of the GNU Lesser General Public License as 
*>  published by the Free Software Foundation, either version 3 of the License,
*>  or (at your option) any later version.
*>
*>  scrollbar.cob is distributed in the hope that it will be useful, 
*>  but WITHOUT ANY WARRANTY; without even the implied warranty of 
*>  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
*>  See the GNU Lesser General Public License for more details.
*>
*>  You should have received a copy of the GNU Lesser General Public License 
*>  along with scrollbar.cob.
*>  If not, see <http://www.gnu.org/licenses/>.
*>******************************************************************************

*>******************************************************************************
*> Program:      scrollbar.cob
*>
*> Purpose:      Example GnuCOBOL program for JAPI
*>
*> Author:       Laszlo Erdos - https://www.facebook.com/wortfee
*>
*> Date-Written: 2014.12.24
*>
*> Tectonics:    Example for static link.
*>               cobc -x -free scrollbar.cob cobjapi.o \
*>                                           japilib.o \
*>                                           imageio.o \
*>                                           fileselect.o
*>
*> Usage:        ./scrollbar.exe
*>
*>******************************************************************************
*> Date       Name / Change description 
*> ========== ==================================================================
*> 2003.02.26 This comment is only for History. The latest Version (V1.0.6) of 
*>            JAPI was released on 02/26/2003. Homepage: http://www.japi.de 
*>------------------------------------------------------------------------------
*> 2014.12.24 Laszlo Erdos: 
*>            - GnuCOBOL support for JAPI added. 
*>            - scrollbar.c converted into scrollbar.cob. 
*>******************************************************************************

 IDENTIFICATION DIVISION.
 PROGRAM-ID. scrollbar.
 AUTHOR.     Laszlo Erdos.

 ENVIRONMENT DIVISION.
 CONFIGURATION SECTION.
 REPOSITORY.
    FUNCTION J-SETDEBUG
    FUNCTION J-START
    FUNCTION J-FRAME
    FUNCTION J-HSCROLLBAR
    FUNCTION J-SETSIZE
    FUNCTION J-SETPOS
    FUNCTION J-SETMIN
    FUNCTION J-SETMAX
    FUNCTION J-SETSLIDESIZE
    FUNCTION J-SETUNITINC
    FUNCTION J-SETBLOCKINC
    FUNCTION J-SETVALUE
    FUNCTION J-GETVALUE
    FUNCTION J-SHOW
    FUNCTION J-PACK
    FUNCTION J-NEXTACTION
    FUNCTION J-BEEP
    FUNCTION J-SETFOCUS
    FUNCTION J-QUIT
    FUNCTION ALL INTRINSIC.

 DATA DIVISION.

 WORKING-STORAGE SECTION.
*> function return value 
 01 WS-RET                             BINARY-INT.

*> GUI elements
 01 WS-FRAME                           BINARY-INT.
 01 WS-SCROLL                          BINARY-INT.
 01 WS-OBJ                             BINARY-INT.

*> FUNCTION ARGS 
 01 WS-DEBUG-LEVEL                     BINARY-INT.
 01 WS-WIDTH                           BINARY-INT.
 01 WS-HEIGHT                          BINARY-INT.
 01 WS-XPOS                            BINARY-INT.
 01 WS-YPOS                            BINARY-INT.
 01 WS-MIN-VAL                         BINARY-INT.
 01 WS-MAX-VAL                         BINARY-INT.
 01 WS-SLIDE-SIZE                      BINARY-INT.
 01 WS-UNIT-INCREMENT-AMOUNT           BINARY-INT.
 01 WS-BLOCK-INCREMENT-AMOUNT          BINARY-INT. 
 01 WS-CURRENT-VALUE                   BINARY-INT.

*> Constants for the cobjapi wrapper 
 COPY "cobjapi.cpy".
 
 PROCEDURE DIVISION.

*>------------------------------------------------------------------------------
 MAIN-SCROLLBAR SECTION.
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
    MOVE J-FRAME("Scrollbar Demo") TO WS-FRAME  

    MOVE J-HSCROLLBAR(WS-FRAME) TO WS-SCROLL
    MOVE 300 TO WS-WIDTH
    MOVE  20 TO WS-HEIGHT
    MOVE J-SETSIZE(WS-SCROLL, WS-WIDTH, WS-HEIGHT) TO WS-RET

    MOVE  10 TO WS-XPOS
    MOVE  60 TO WS-YPOS
    MOVE J-SETPOS(WS-SCROLL, WS-XPOS, WS-YPOS) TO WS-RET

    MOVE 10 TO WS-MIN-VAL
    MOVE J-SETMIN(WS-SCROLL, WS-MIN-VAL) TO WS-RET

    MOVE 150 TO WS-MAX-VAL
    MOVE J-SETMAX(WS-SCROLL, WS-MAX-VAL) TO WS-RET

    MOVE 28 TO WS-SLIDE-SIZE
    MOVE J-SETSLIDESIZE(WS-SCROLL, WS-SLIDE-SIZE) TO WS-RET

    MOVE 2 TO WS-UNIT-INCREMENT-AMOUNT
    MOVE J-SETUNITINC(WS-SCROLL, WS-UNIT-INCREMENT-AMOUNT) TO WS-RET

    MOVE 12 TO WS-BLOCK-INCREMENT-AMOUNT
    MOVE J-SETBLOCKINC(WS-SCROLL, WS-BLOCK-INCREMENT-AMOUNT) TO WS-RET
    
    MOVE 50 TO WS-CURRENT-VALUE
    MOVE J-SETVALUE(WS-SCROLL, WS-CURRENT-VALUE) TO WS-RET
    
    MOVE J-PACK(WS-FRAME) TO WS-RET
    MOVE J-SHOW(WS-FRAME) TO WS-RET
    
*>  Waiting for actions
    PERFORM FOREVER
       MOVE J-NEXTACTION() TO WS-OBJ

       IF WS-OBJ = WS-FRAME
       THEN
          EXIT PERFORM
       END-IF

       MOVE J-BEEP() TO WS-RET

       IF WS-OBJ = WS-SCROLL
       THEN
          MOVE J-GETVALUE(WS-SCROLL) TO WS-CURRENT-VALUE
          DISPLAY "Scrollbar value: " WS-CURRENT-VALUE END-DISPLAY
*>        because of blinking focus...          
          MOVE J-SETFOCUS(WS-FRAME) TO WS-RET
       END-IF
    END-PERFORM
    
    MOVE J-QUIT() TO WS-RET

    STOP RUN
    
    .
 MAIN-SCROLLBAR-EX.
    EXIT.
 END PROGRAM scrollbar.
