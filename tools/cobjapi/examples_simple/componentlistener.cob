*>******************************************************************************
*>  This file is part of cobjapi.
*>
*>  componentlistener.cob is free software: you can redistribute it and/or 
*>  modify it under the terms of the GNU Lesser General Public License as 
*>  published by the Free Software Foundation, either version 3 of the License,
*>  or (at your option) any later version.
*>
*>  componentlistener.cob is distributed in the hope that it will be useful, 
*>  but WITHOUT ANY WARRANTY; without even the implied warranty of 
*>  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
*>  See the GNU Lesser General Public License for more details.
*>
*>  You should have received a copy of the GNU Lesser General Public License 
*>  along with componentlistener.cob.
*>  If not, see <http://www.gnu.org/licenses/>.
*>******************************************************************************

*>******************************************************************************
*> Program:      componentlistener.cob
*>
*> Purpose:      Example GnuCOBOL program for JAPI
*>
*> Author:       Laszlo Erdos - https://www.facebook.com/wortfee
*>
*> Date-Written: 2014.12.24
*>
*> Tectonics:    Example for static link.
*>               cobc -x -free componentlistener.cob cobjapi.o \
*>                                                   japilib.o \
*>                                                   imageio.o \
*>                                                   fileselect.o
*>
*> Usage:        ./componentlistener.exe
*>
*>******************************************************************************
*> Date       Name / Change description 
*> ========== ==================================================================
*> 2003.02.26 This comment is only for History. The latest Version (V1.0.6) of 
*>            JAPI was released on 02/26/2003. Homepage: http://www.japi.de 
*>------------------------------------------------------------------------------
*> 2014.12.24 Laszlo Erdos: 
*>            - GnuCOBOL support for JAPI added. 
*>            - componentlistener.c converted into componentlistener.cob. 
*>******************************************************************************

 IDENTIFICATION DIVISION.
 PROGRAM-ID. componentlistener.
 AUTHOR.     Laszlo Erdos.

 ENVIRONMENT DIVISION.
 CONFIGURATION SECTION.
 REPOSITORY.
    FUNCTION J-SETDEBUG
    FUNCTION J-START
    FUNCTION J-FRAME
    FUNCTION J-SETGRIDLAYOUT
    FUNCTION J-TEXTAREA
    FUNCTION J-COMPONENTLISTENER
    FUNCTION J-SHOW
    FUNCTION J-PACK
    FUNCTION J-NEXTACTION
    FUNCTION J-GETROWS
    FUNCTION J-GETCOLUMNS
    FUNCTION J-APPENDTEXT
    FUNCTION J-ISVISIBLE
    FUNCTION J-SETTEXT
    FUNCTION J-HIDE
    FUNCTION J-QUIT
    FUNCTION ALL INTRINSIC.

 DATA DIVISION.

 WORKING-STORAGE SECTION.
*> function return value 
 01 WS-RET                             BINARY-INT.

*> GUI elements
 01 WS-FRAME                           BINARY-INT.
 01 WS-TEXT                            BINARY-INT.
 01 WS-RESIZED                         BINARY-INT.
 01 WS-MOVED                           BINARY-INT.
 01 WS-HIDDEN                          BINARY-INT.
 01 WS-SHOWN                           BINARY-INT.
 01 WS-OBJ                             BINARY-INT.
 
*> function args 
 01 WS-DEBUG-LEVEL                     BINARY-INT.
 01 WS-ROW                             BINARY-INT.
 01 WS-COL                             BINARY-INT.

*> vars
 01 WS-STR                             PIC X(256).
 01 WS-ROW-DISP                        PIC 9(5).
 01 WS-COL-DISP                        PIC 9(5).
 
*> Constants for the cobjapi wrapper 
 COPY "cobjapi.cpy".
 
 PROCEDURE DIVISION.

*>------------------------------------------------------------------------------
 MAIN-COMPONENTLISTENER SECTION.
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
    MOVE J-FRAME("Component Listener") TO WS-FRAME  
                      
    MOVE 1 TO WS-ROW                      
    MOVE 1 TO WS-COL                      
    MOVE J-SETGRIDLAYOUT(WS-FRAME, WS-ROW, WS-COL) TO WS-RET

    MOVE 80 TO WS-ROW                      
    MOVE 25 TO WS-COL                      
    MOVE J-TEXTAREA(WS-FRAME, WS-ROW, WS-COL) TO WS-TEXT

    MOVE J-COMPONENTLISTENER(WS-TEXT, J-RESIZED) TO WS-RESIZED 
    MOVE J-COMPONENTLISTENER(WS-FRAME, J-MOVED)  TO WS-MOVED   
    MOVE J-COMPONENTLISTENER(WS-TEXT, J-HIDDEN)  TO WS-HIDDEN  
    MOVE J-COMPONENTLISTENER(WS-TEXT, J-SHOWN)   TO WS-SHOWN   
    
    MOVE J-SHOW(WS-FRAME) TO WS-RET
    MOVE J-PACK(WS-FRAME) TO WS-RET

*>  Waiting for actions
    PERFORM FOREVER
       MOVE J-NEXTACTION() TO WS-OBJ

       IF WS-OBJ = WS-FRAME
       THEN
          EXIT PERFORM
       END-IF

       IF WS-OBJ = WS-RESIZED
       THEN
          MOVE J-GETROWS(WS-TEXT)    TO WS-ROW-DISP
          MOVE J-GETCOLUMNS(WS-TEXT) TO WS-COL-DISP

          MOVE x"00" TO WS-STR
          STRING "resized to " DELIMITED BY SIZE
                 WS-ROW-DISP   DELIMITED BY SIZE  
                 " rows "      DELIMITED BY SIZE 
                 WS-COL-DISP   DELIMITED BY SIZE
                 " columns"    DELIMITED BY SIZE
                 x"0A"         DELIMITED BY SIZE
            INTO WS-STR
          END-STRING       

          MOVE J-APPENDTEXT(WS-TEXT, WS-STR) TO WS-RET
       END-IF
       
       IF WS-OBJ = WS-MOVED
       THEN
          MOVE J-APPENDTEXT(WS-TEXT, "Frame moved" & x"0A") TO WS-RET

          MOVE J-ISVISIBLE(WS-TEXT) TO WS-RET
          IF WS-RET = J-TRUE
          THEN
             MOVE J-SETTEXT(WS-FRAME, "Move again to see the text!") TO WS-RET
             MOVE J-HIDE(WS-TEXT) TO WS-RET
          ELSE
             MOVE J-SETTEXT(WS-FRAME, "Component Listener") TO WS-RET
             MOVE J-SHOW(WS-TEXT) TO WS-RET
          END-IF
       END-IF
       
       IF WS-OBJ = WS-HIDDEN
       THEN
          MOVE J-APPENDTEXT(WS-TEXT, "Text hidden" & x"0A") TO WS-RET
       END-IF
       
       IF WS-OBJ = WS-SHOWN
       THEN
          MOVE J-APPENDTEXT(WS-TEXT, "Text shown" & x"0A") TO WS-RET
       END-IF
    END-PERFORM
    
    MOVE J-QUIT() TO WS-RET

    STOP RUN
    
    .
 MAIN-COMPONENTLISTENER-EX.
    EXIT.
 END PROGRAM componentlistener.
