*>******************************************************************************
*>  This file is part of cobjapi.
*>
*>  cursor.cob is free software: you can redistribute it and/or 
*>  modify it under the terms of the GNU Lesser General Public License as 
*>  published by the Free Software Foundation, either version 3 of the License,
*>  or (at your option) any later version.
*>
*>  cursor.cob is distributed in the hope that it will be useful, 
*>  but WITHOUT ANY WARRANTY; without even the implied warranty of 
*>  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
*>  See the GNU Lesser General Public License for more details.
*>
*>  You should have received a copy of the GNU Lesser General Public License 
*>  along with cursor.cob.
*>  If not, see <http://www.gnu.org/licenses/>.
*>******************************************************************************

*>******************************************************************************
*> Program:      cursor.cob
*>
*> Purpose:      Example GnuCOBOL program for JAPI
*>
*> Author:       Laszlo Erdos - https://www.facebook.com/wortfee
*>
*> Date-Written: 2014.12.24
*>
*> Tectonics:    Example for static link.
*>               cobc -x -free cursor.cob cobjapi.o \
*>                                        japilib.o \
*>                                        imageio.o \
*>                                        fileselect.o
*>
*> Usage:        ./cursor.exe
*>
*>******************************************************************************
*> Date       Name / Change description 
*> ========== ==================================================================
*> 2003.02.26 This comment is only for History. The latest Version (V1.0.6) of 
*>            JAPI was released on 02/26/2003. Homepage: http://www.japi.de 
*>------------------------------------------------------------------------------
*> 2014.12.24 Laszlo Erdos: 
*>            - GnuCOBOL support for JAPI added. 
*>            - cursor.c converted into cursor.cob. 
*>******************************************************************************

 IDENTIFICATION DIVISION.
 PROGRAM-ID. cursor.
 AUTHOR.     Laszlo Erdos.

 ENVIRONMENT DIVISION.
 CONFIGURATION SECTION.
 REPOSITORY.
    FUNCTION J-SETDEBUG
    FUNCTION J-START
    FUNCTION J-FRAME
    FUNCTION J-MENUBAR
    FUNCTION J-MENU
    FUNCTION J-MENUITEM    
    FUNCTION J-SETNAMEDCOLORBG
    FUNCTION J-SETCURSOR
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
 01 WS-MENUBAR                         BINARY-INT.
 01 WS-FILE                            BINARY-INT.
 01 WS-QUIT                            BINARY-INT.
 01 WS-OBJ                             BINARY-INT.
*> cursor type
 01 WS-CURSOR                          BINARY-INT.
 01 WS-DEF                             BINARY-INT.
 01 WS-CROSS                           BINARY-INT.
 01 WS-HAND                            BINARY-INT.
 01 WS-MOVE                            BINARY-INT.
 01 WS-TEXT                            BINARY-INT.
 01 WS-WAIT                            BINARY-INT.
*> cursor resize
 01 WS-RESIZE                          BINARY-INT.
 01 WS-NR                              BINARY-INT.
 01 WS-NER                             BINARY-INT.
 01 WS-ER                              BINARY-INT.
 01 WS-SER                             BINARY-INT.
 01 WS-SR                              BINARY-INT.
 01 WS-SWR                             BINARY-INT.
 01 WS-WR                              BINARY-INT.
 01 WS-NWR                             BINARY-INT.
 
*> function args 
 01 WS-DEBUG-LEVEL                     BINARY-INT.
 
*> Constants for the cobjapi wrapper 
 COPY "cobjapi.cpy".
 
 PROCEDURE DIVISION.

*>------------------------------------------------------------------------------
 MAIN-CURSOR SECTION.
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
    MOVE J-FRAME("Cursor Demo")                     TO WS-FRAME  
    MOVE J-MENUBAR(WS-FRAME)                        TO WS-MENUBAR
    MOVE J-MENU(WS-MENUBAR, "File")                 TO WS-FILE
    MOVE J-MENUITEM(WS-FILE, "Quit")                TO WS-QUIT
*> cursor type
    MOVE J-MENU(WS-MENUBAR, "Cursor")               TO WS-CURSOR
    MOVE J-MENUITEM(WS-CURSOR, "Default")           TO WS-DEF
    MOVE J-MENUITEM(WS-CURSOR, "Crosshair")         TO WS-CROSS
    MOVE J-MENUITEM(WS-CURSOR, "Text")              TO WS-TEXT
    MOVE J-MENUITEM(WS-CURSOR, "Wait")              TO WS-WAIT
    MOVE J-MENUITEM(WS-CURSOR, "Hand")              TO WS-HAND
    MOVE J-MENUITEM(WS-CURSOR, "Move")              TO WS-MOVE
*> cursor resize
    MOVE J-MENU(WS-MENUBAR, "Resize")               TO WS-RESIZE
    MOVE J-MENUITEM(WS-RESIZE, "North Resize")      TO WS-NR
    MOVE J-MENUITEM(WS-RESIZE, "North East Resize") TO WS-NER
    MOVE J-MENUITEM(WS-RESIZE, "East Resize")       TO WS-ER
    MOVE J-MENUITEM(WS-RESIZE, "South East Resize") TO WS-SER
    MOVE J-MENUITEM(WS-RESIZE, "South Resize")      TO WS-SR
    MOVE J-MENUITEM(WS-RESIZE, "South West Resize") TO WS-SWR
    MOVE J-MENUITEM(WS-RESIZE, "West Resize")       TO WS-WR
    MOVE J-MENUITEM(WS-RESIZE, "North West Resize") TO WS-NWR
    
    MOVE J-SHOW(WS-FRAME) TO WS-RET
    MOVE J-SETNAMEDCOLORBG(WS-FRAME, J-WHITE) TO WS-RET

    MOVE -1 TO WS-OBJ
    
*>  Waiting for actions
    PERFORM FOREVER
       MOVE J-NEXTACTION() TO WS-OBJ

       IF (WS-OBJ = WS-QUIT) OR (WS-OBJ = WS-FRAME)
       THEN
          EXIT PERFORM
       END-IF
       
       EVALUATE TRUE
*>        cursor type
          WHEN WS-OBJ = WS-DEF 
               MOVE J-SETCURSOR(WS-FRAME, J-DEFAULT-CURSOR)   TO WS-RET
          WHEN WS-OBJ = WS-CROSS 
               MOVE J-SETCURSOR(WS-FRAME, J-CROSSHAIR-CURSOR) TO WS-RET
          WHEN WS-OBJ = WS-HAND 
               MOVE J-SETCURSOR(WS-FRAME, J-HAND-CURSOR)      TO WS-RET
          WHEN WS-OBJ = WS-MOVE 
               MOVE J-SETCURSOR(WS-FRAME, J-MOVE-CURSOR)      TO WS-RET
          WHEN WS-OBJ = WS-TEXT 
               MOVE J-SETCURSOR(WS-FRAME, J-TEXT-CURSOR)      TO WS-RET
          WHEN WS-OBJ = WS-WAIT 
               MOVE J-SETCURSOR(WS-FRAME, J-WAIT-CURSOR)      TO WS-RET
*>        cursor resize
          WHEN WS-OBJ = WS-NR 
               MOVE J-SETCURSOR(WS-FRAME, J-N-RESIZE-CURSOR)  TO WS-RET
          WHEN WS-OBJ = WS-NER 
               MOVE J-SETCURSOR(WS-FRAME, J-NE-RESIZE-CURSOR) TO WS-RET
          WHEN WS-OBJ = WS-ER 
               MOVE J-SETCURSOR(WS-FRAME, J-E-RESIZE-CURSOR)  TO WS-RET
          WHEN WS-OBJ = WS-SER 
               MOVE J-SETCURSOR(WS-FRAME, J-SE-RESIZE-CURSOR) TO WS-RET
          WHEN WS-OBJ = WS-SR 
               MOVE J-SETCURSOR(WS-FRAME, J-S-RESIZE-CURSOR)  TO WS-RET
          WHEN WS-OBJ = WS-SWR 
               MOVE J-SETCURSOR(WS-FRAME, J-SW-RESIZE-CURSOR) TO WS-RET
          WHEN WS-OBJ = WS-WR 
               MOVE J-SETCURSOR(WS-FRAME, J-W-RESIZE-CURSOR)  TO WS-RET
          WHEN WS-OBJ = WS-NWR 
               MOVE J-SETCURSOR(WS-FRAME, J-NW-RESIZE-CURSOR) TO WS-RET
       END-EVALUATE      
    END-PERFORM
    
    MOVE J-QUIT() TO WS-RET

    STOP RUN
    
    .
 MAIN-CURSOR-EX.
    EXIT.
 END PROGRAM cursor.
