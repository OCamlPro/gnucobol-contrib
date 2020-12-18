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
*>------------------------------------------------------------------------------
*> 2020.05.23 Laszlo Erdos: 
*>            - BINARY-INT replaced with BINARY-LONG.
*>******************************************************************************

 IDENTIFICATION DIVISION.
 PROGRAM-ID. cursor.

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
 01 WS-MENUBAR                         BINARY-LONG.
 01 WS-FILE                            BINARY-LONG.
 01 WS-QUIT                            BINARY-LONG.
 01 WS-OBJ                             BINARY-LONG.
*> cursor type
 01 WS-CURSOR                          BINARY-LONG.
 01 WS-DEF                             BINARY-LONG.
 01 WS-CROSS                           BINARY-LONG.
 01 WS-HAND                            BINARY-LONG.
 01 WS-MOVE                            BINARY-LONG.
 01 WS-TEXT                            BINARY-LONG.
 01 WS-WAIT                            BINARY-LONG.
*> cursor resize
 01 WS-RESIZE                          BINARY-LONG.
 01 WS-NR                              BINARY-LONG.
 01 WS-NER                             BINARY-LONG.
 01 WS-ER                              BINARY-LONG.
 01 WS-SER                             BINARY-LONG.
 01 WS-SR                              BINARY-LONG.
 01 WS-SWR                             BINARY-LONG.
 01 WS-WR                              BINARY-LONG.
 01 WS-NWR                             BINARY-LONG.
 
*> function args 
 01 WS-DEBUG-LEVEL                     BINARY-LONG.
 
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
