*>******************************************************************************
*>  This file is part of cobjapi.
*>
*>  windowlistener.cob is free software: you can redistribute it and/or 
*>  modify it under the terms of the GNU Lesser General Public License as 
*>  published by the Free Software Foundation, either version 3 of the License,
*>  or (at your option) any later version.
*>
*>  windowlistener.cob is distributed in the hope that it will be useful, 
*>  but WITHOUT ANY WARRANTY; without even the implied warranty of 
*>  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
*>  See the GNU Lesser General Public License for more details.
*>
*>  You should have received a copy of the GNU Lesser General Public License 
*>  along with windowlistener.cob.
*>  If not, see <http://www.gnu.org/licenses/>.
*>******************************************************************************

*>******************************************************************************
*> Program:      windowlistener.cob
*>
*> Purpose:      Example GnuCOBOL program for JAPI
*>
*> Author:       Laszlo Erdos - https://www.facebook.com/wortfee
*>
*> Date-Written: 2014.12.24
*>
*> Tectonics:    Example for static link.
*>               cobc -x -free windowlistener.cob cobjapi.o \
*>                                                japilib.o \
*>                                                imageio.o \
*>                                                fileselect.o
*>
*> Usage:        ./windowlistener.exe
*>
*>******************************************************************************
*> Date       Name / Change description 
*> ========== ==================================================================
*> 2003.02.26 This comment is only for History. The latest Version (V1.0.6) of 
*>            JAPI was released on 02/26/2003. Homepage: http://www.japi.de 
*>------------------------------------------------------------------------------
*> 2014.12.24 Laszlo Erdos: 
*>            - GnuCOBOL support for JAPI added. 
*>            - windowlistener.c converted into windowlistener.cob. 
*>******************************************************************************

 IDENTIFICATION DIVISION.
 PROGRAM-ID. windowlistener.
 AUTHOR.     Laszlo Erdos.

 ENVIRONMENT DIVISION.
 CONFIGURATION SECTION.
 REPOSITORY.
    FUNCTION J-SETDEBUG
    FUNCTION J-START
    FUNCTION J-FRAME
    FUNCTION J-SETGRIDLAYOUT
    FUNCTION J-TEXTAREA
    FUNCTION J-WINDOWLISTENER
    FUNCTION J-SHOW
    FUNCTION J-PACK
    FUNCTION J-NEXTACTION
    FUNCTION J-APPENDTEXT
    FUNCTION J-DISPOSE
    FUNCTION J-QUIT
    FUNCTION ALL INTRINSIC.

 DATA DIVISION.

 WORKING-STORAGE SECTION.
*> function return value 
 01 WS-RET                             BINARY-INT.

*> GUI elements
 01 WS-FRAME                           BINARY-INT.
 01 WS-TEXT                            BINARY-INT.
 01 WS-OBJ                             BINARY-INT.
 01 WS-ACTIVATED                       BINARY-INT.
 01 WS-DEACTIVATED                     BINARY-INT.
 01 WS-OPENED                          BINARY-INT.
 01 WS-CLOSED                          BINARY-INT.
 01 WS-ICONIFIED                       BINARY-INT.
 01 WS-DEICONIFIED                     BINARY-INT.
 
*> function args 
 01 WS-DEBUG-LEVEL                     BINARY-INT.
 01 WS-WIDTH                           BINARY-INT.
 01 WS-HEIGHT                          BINARY-INT.
 01 WS-ROW                             BINARY-INT.
 01 WS-COL                             BINARY-INT.
 
*> Constants for the cobjapi wrapper 
 COPY "cobjapi.cpy".
 
 PROCEDURE DIVISION.

*>------------------------------------------------------------------------------
 MAIN-WINDOWLISTENER SECTION.
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
    MOVE J-FRAME("Window Listener") TO WS-FRAME  
	MOVE 1 TO WS-ROW
    MOVE 1 TO WS-COL
    MOVE J-SETGRIDLAYOUT(WS-FRAME, WS-ROW, WS-COL) TO WS-RET

    MOVE 80 TO WS-ROW                      
    MOVE 25 TO WS-COL                      
    MOVE J-TEXTAREA(WS-FRAME, WS-ROW, WS-COL) TO WS-TEXT

    MOVE J-WINDOWLISTENER(WS-FRAME, J-OPENED)      TO WS-OPENED
    MOVE J-WINDOWLISTENER(WS-FRAME, J-CLOSED)      TO WS-CLOSED
    MOVE J-WINDOWLISTENER(WS-FRAME, J-ACTIVATED)   TO WS-ACTIVATED
    MOVE J-WINDOWLISTENER(WS-FRAME, J-DEACTIVATED) TO WS-DEACTIVATED
    MOVE J-WINDOWLISTENER(WS-FRAME, J-ICONIFIED)   TO WS-ICONIFIED
    MOVE J-WINDOWLISTENER(WS-FRAME, J-DEICONIFIED) TO WS-DEICONIFIED

    MOVE J-SHOW(WS-FRAME) TO WS-RET
    MOVE J-PACK(WS-FRAME) TO WS-RET

*>  Waiting for actions
    PERFORM FOREVER
       MOVE J-NEXTACTION() TO WS-OBJ
       
       IF WS-OBJ = WS-FRAME
       THEN
          EXIT PERFORM
       END-IF
       
       IF WS-OBJ = WS-OPENED
       THEN
          MOVE J-APPENDTEXT(WS-TEXT, "Frame opened" & X"0A") TO WS-RET
       END-IF
       
       IF WS-OBJ = WS-CLOSED
       THEN
          MOVE J-APPENDTEXT(WS-TEXT, "Frame closed" & X"0A") TO WS-RET
       END-IF
       
       IF WS-OBJ = WS-ACTIVATED
       THEN
          MOVE J-APPENDTEXT(WS-TEXT, "Frame activated" & X"0A") TO WS-RET
       END-IF

       IF WS-OBJ = WS-DEACTIVATED
       THEN
          MOVE J-APPENDTEXT(WS-TEXT, "Frame deactivated" & X"0A") TO WS-RET
       END-IF

       IF WS-OBJ = WS-ICONIFIED
       THEN
          MOVE J-APPENDTEXT(WS-TEXT, "Frame iconfied" & X"0A") TO WS-RET
       END-IF

       IF WS-OBJ = WS-DEICONIFIED
       THEN
          MOVE J-APPENDTEXT(WS-TEXT, "Frame deiconfied" & X"0A") TO WS-RET
       END-IF
    END-PERFORM

    MOVE J-APPENDTEXT(WS-TEXT, "Frame closing, press again closing icon" & X"0A") TO WS-RET

    PERFORM FOREVER
       MOVE J-NEXTACTION() TO WS-OBJ
       
       IF WS-OBJ = WS-FRAME
       THEN
          EXIT PERFORM
       END-IF
    END-PERFORM
    
    MOVE J-DISPOSE(WS-FRAME) TO WS-RET

    PERFORM FOREVER
       MOVE J-NEXTACTION() TO WS-OBJ
       
       IF WS-OBJ = WS-CLOSED
       THEN
          EXIT PERFORM
       END-IF
    END-PERFORM
    
    DISPLAY "Frame closed" END-DISPLAY
    
    MOVE J-QUIT() TO WS-RET

    STOP RUN
    
    .
 MAIN-WINDOWLISTENER-EX.
    EXIT.
 END PROGRAM windowlistener.
