*>******************************************************************************
*>  This file is part of cobjapi.
*>
*>  textfield.cob is free software: you can redistribute it and/or 
*>  modify it under the terms of the GNU Lesser General Public License as 
*>  published by the Free Software Foundation, either version 3 of the License,
*>  or (at your option) any later version.
*>
*>  textfield.cob is distributed in the hope that it will be useful, 
*>  but WITHOUT ANY WARRANTY; without even the implied warranty of 
*>  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
*>  See the GNU Lesser General Public License for more details.
*>
*>  You should have received a copy of the GNU Lesser General Public License 
*>  along with textfield.cob.
*>  If not, see <http://www.gnu.org/licenses/>.
*>******************************************************************************

*>******************************************************************************
*> Program:      textfield.cob
*>
*> Purpose:      Example GnuCOBOL program for JAPI
*>
*> Author:       Laszlo Erdos - https://www.facebook.com/wortfee
*>
*> Date-Written: 2014.12.24
*>
*> Tectonics:    Example for static link.
*>               cobc -x -free textfield.cob cobjapi.o \
*>                                           japilib.o \
*>                                           imageio.o \
*>                                           fileselect.o
*>
*> Usage:        ./textfield.exe
*>
*>******************************************************************************
*> Date       Name / Change description 
*> ========== ==================================================================
*> 2003.02.26 This comment is only for History. The latest Version (V1.0.6) of 
*>            JAPI was released on 02/26/2003. Homepage: http://www.japi.de 
*>------------------------------------------------------------------------------
*> 2014.12.24 Laszlo Erdos: 
*>            - GnuCOBOL support for JAPI added. 
*>            - textfield.c converted into textfield.cob. 
*>******************************************************************************

 IDENTIFICATION DIVISION.
 PROGRAM-ID. textfield.
 AUTHOR.     Laszlo Erdos.

 ENVIRONMENT DIVISION.
 CONFIGURATION SECTION.
 REPOSITORY.
    FUNCTION J-SETDEBUG
    FUNCTION J-START
    FUNCTION J-FRAME
    FUNCTION J-TEXTFIELD
    FUNCTION J-SETECHOCHAR
    FUNCTION J-SETPOS
    FUNCTION J-GETTEXT
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
 01 WS-LOGIN                           BINARY-INT.
 01 WS-PASSWD                          BINARY-INT.
 01 WS-OBJ                             BINARY-INT.
 
*> function args 
 01 WS-DEBUG-LEVEL                     BINARY-INT.
 01 WS-COLUMNS                         BINARY-INT.
 01 WS-XPOS                            BINARY-INT.
 01 WS-YPOS                            BINARY-INT.
 01 WS-CONTENT                         PIC X(256).
 
 PROCEDURE DIVISION.

*>------------------------------------------------------------------------------
 MAIN-TEXTFIELD SECTION.
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
    MOVE J-FRAME("Login with name and password") TO WS-FRAME  

    MOVE 35 TO WS-COLUMNS    
    MOVE J-TEXTFIELD(WS-FRAME, WS-COLUMNS) TO WS-LOGIN
    MOVE J-TEXTFIELD(WS-FRAME, WS-COLUMNS) TO WS-PASSWD

    MOVE 10 TO WS-XPOS
    MOVE 40 TO WS-YPOS
    MOVE J-SETPOS(WS-LOGIN, WS-XPOS, WS-YPOS)  TO WS-RET
    MOVE 10 TO WS-XPOS
    MOVE 70 TO WS-YPOS
    MOVE J-SETPOS(WS-PASSWD, WS-XPOS, WS-YPOS) TO WS-RET
    
    MOVE J-SETECHOCHAR(WS-PASSWD, "*") TO WS-RET
    
    MOVE J-SHOW(WS-FRAME) TO WS-RET
    MOVE J-PACK(WS-FRAME) TO WS-RET

*>  Waiting for actions
    PERFORM FOREVER
       MOVE J-NEXTACTION() TO WS-OBJ

       IF WS-OBJ = WS-FRAME
       THEN
          EXIT PERFORM
       END-IF
       
       IF WS-OBJ = WS-LOGIN
       THEN
          MOVE J-GETTEXT(WS-LOGIN, WS-CONTENT) TO WS-RET
          DISPLAY "Your name is " TRIM(WS-CONTENT) END-DISPLAY
       END-IF
       
       IF WS-OBJ = WS-PASSWD
       THEN
          MOVE J-GETTEXT(WS-LOGIN, WS-CONTENT) TO WS-RET
          DISPLAY "Your name is " TRIM(WS-CONTENT) END-DISPLAY
          
          MOVE J-GETTEXT(WS-PASSWD, WS-CONTENT) TO WS-RET
          DISPLAY "Your password is " TRIM(WS-CONTENT) END-DISPLAY
       END-IF

       IF WS-CONTENT = "exit"
       THEN
          EXIT PERFORM
       END-IF
    END-PERFORM
    
    MOVE J-QUIT() TO WS-RET

    STOP RUN
    
    .
 MAIN-TEXTFIELD-EX.
    EXIT.
 END PROGRAM textfield.
