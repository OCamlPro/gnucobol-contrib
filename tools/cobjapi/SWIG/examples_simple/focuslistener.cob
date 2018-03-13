*>******************************************************************************
*>  This file is part of cobjapi.
*>
*>  focuslistener.cob is free software: you can redistribute it and/or 
*>  modify it under the terms of the GNU Lesser General Public License as 
*>  published by the Free Software Foundation, either version 3 of the License,
*>  or (at your option) any later version.
*>
*>  focuslistener.cob is distributed in the hope that it will be useful, 
*>  but WITHOUT ANY WARRANTY; without even the implied warranty of 
*>  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
*>  See the GNU Lesser General Public License for more details.
*>
*>  You should have received a copy of the GNU Lesser General Public License 
*>  along with focuslistener.cob.
*>  If not, see <http://www.gnu.org/licenses/>.
*>******************************************************************************

*>******************************************************************************
*> Program:      focuslistener.cob
*>
*> Purpose:      Example GnuCOBOL program for JAPI
*>
*> Author:       Laszlo Erdos - https://www.facebook.com/wortfee
*>
*> Date-Written: 2014.12.24
*>
*> Tectonics:    Example for static link.
*>               cobc -x -free focuslistener.cob cobjapi.o \
*>                                               japilib.o \
*>                                               imageio.o \
*>                                               fileselect.o
*>
*> Usage:        ./focuslistener.exe
*>
*>******************************************************************************
*> Date       Name / Change description 
*> ========== ==================================================================
*> 2003.02.26 This comment is only for History. The latest Version (V1.0.6) of 
*>            JAPI was released on 02/26/2003. Homepage: http://www.japi.de 
*>------------------------------------------------------------------------------
*> 2014.12.24 Laszlo Erdos: 
*>            - GnuCOBOL support for JAPI added. 
*>            - focuslistener.c converted into focuslistener.cob. 
*>******************************************************************************

 IDENTIFICATION DIVISION.
 PROGRAM-ID. focuslistener.
 AUTHOR.     Laszlo Erdos.

 ENVIRONMENT DIVISION.
 CONFIGURATION SECTION.
 REPOSITORY.
    FUNCTION J-SETDEBUG
    FUNCTION J-START
    FUNCTION J-FRAME
    FUNCTION J-SETFLOWLAYOUT
    FUNCTION J-BUTTON
    FUNCTION J-FOCUSLISTENER
    FUNCTION J-PACK
    FUNCTION J-SHOW
    FUNCTION J-NEXTACTION
    FUNCTION J-HASFOCUS    
    FUNCTION J-SETFOCUS
    FUNCTION J-QUIT
    FUNCTION ALL INTRINSIC.

 DATA DIVISION.

 WORKING-STORAGE SECTION.
*> function return value 
 01 WS-RET                             BINARY-INT.

*> GUI elements
 01 WS-FRAME                           BINARY-INT.
 01 WS-OBJ                             BINARY-INT.
 01 WS-BUTTON-1                        BINARY-INT.
 01 WS-BUTTON-2                        BINARY-INT.
 01 WS-BUTTON-3                        BINARY-INT.
 01 WS-FOCUSLST                        BINARY-INT.
 
*> function args 
 01 WS-DEBUG-LEVEL                     BINARY-INT.

*> Constants for the cobjapi wrapper 
 COPY "cobjapi.cpy".
 
 PROCEDURE DIVISION.

*>------------------------------------------------------------------------------
 MAIN-FOCUSLISTENER SECTION.
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
    MOVE J-FRAME("Watch the focus") TO WS-FRAME  
        
    MOVE J-SETFLOWLAYOUT(WS-FRAME, J-HORIZONTAL) TO WS-RET
                               
    MOVE J-BUTTON(WS-FRAME, "Button 1") TO WS-BUTTON-1
    MOVE J-BUTTON(WS-FRAME, "Button 2") TO WS-BUTTON-2
    MOVE J-BUTTON(WS-FRAME, "Button 3") TO WS-BUTTON-3

    MOVE J-FOCUSLISTENER(WS-BUTTON-3)   TO WS-FOCUSLST
    
    MOVE J-PACK(WS-FRAME) TO WS-RET
    MOVE J-SHOW(WS-FRAME) TO WS-RET

*>  Waiting for actions
    PERFORM FOREVER
       MOVE J-NEXTACTION() TO WS-OBJ

       IF WS-OBJ = WS-FRAME
       THEN
          EXIT PERFORM
       END-IF
       
       MOVE J-HASFOCUS(WS-FOCUSLST) TO WS-RET
       IF WS-RET = J-TRUE
       THEN
          DISPLAY "HASFOCUS WS-RET: " WS-RET
          MOVE J-SETFOCUS(WS-BUTTON-2) TO WS-RET
       END-IF       

*>     You can also test this.    
*>     IF WS-OBJ = WS-FOCUSLST
*>     THEN
*>        MOVE J-HASFOCUS(WS-FOCUSLST) TO WS-RET
*>        DISPLAY "HASFOCUS WS-RET: " WS-RET
*>        MOVE J-SETFOCUS(WS-BUTTON-2) TO WS-RET
*>     END-IF       
    END-PERFORM
    
    MOVE J-QUIT() TO WS-RET

    STOP RUN
    
    .
 MAIN-FOCUSLISTENER-EX.
    EXIT.
 END PROGRAM focuslistener.
