*>******************************************************************************
*>  This file is part of cobjapi.
*>
*>  internalframe1.cob is free software: you can redistribute it and/or 
*>  modify it under the terms of the GNU Lesser General Public License as 
*>  published by the Free Software Foundation, either version 3 of the License,
*>  or (at your option) any later version.
*>
*>  internalframe1.cob is distributed in the hope that it will be useful, 
*>  but WITHOUT ANY WARRANTY; without even the implied warranty of 
*>  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
*>  See the GNU Lesser General Public License for more details.
*>
*>  You should have received a copy of the GNU Lesser General Public License 
*>  along with internalframe1.cob.
*>  If not, see <http://www.gnu.org/licenses/>.
*>******************************************************************************

*>******************************************************************************
*> Program:      internalframe1.cob
*>
*> Purpose:      Example GnuCOBOL program for JAPI
*>
*> Author:       Laszlo Erdos - https://www.facebook.com/wortfee
*>
*> Date-Written: 2020.12.22
*>
*> Tectonics:    Example for static link.
*>               cobc -x -free internalframe1.cob cobjapi.o \
*>                                                japilib.o \
*>                                                imageio.o \
*>                                                fileselect.o
*>
*> Usage:        ./internalframe1.exe
*>
*>******************************************************************************
*> Date       Name / Change description 
*> ========== ==================================================================
*> 2003.02.26 This comment is only for History. The latest Version (V1.0.6) of 
*>            JAPI was released on 02/26/2003. Homepage: http://www.japi.de 
*>------------------------------------------------------------------------------
*> 2020.12.22 Laszlo Erdos: 
*>            - button.cob converted into internalframe1.cob. 
*>******************************************************************************

 IDENTIFICATION DIVISION.
 PROGRAM-ID. internalframe1.

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
 01 WS-DESKTOPPANE                     BINARY-LONG.
 01 WS-INTERNALFRAME-1                 BINARY-LONG.
 01 WS-INTERNALFRAME-2                 BINARY-LONG.
 01 WS-LABEL                           BINARY-LONG.
 01 WS-BUTTON                          BINARY-LONG.
 01 WS-OBJ                             BINARY-LONG.
 
*> function args 
 01 WS-DEBUG-LEVEL                     BINARY-LONG.
 01 WS-WIDTH                           BINARY-LONG.
 01 WS-HEIGHT                          BINARY-LONG.
 01 WS-XPOS                            BINARY-LONG.
 01 WS-YPOS                            BINARY-LONG.
 01 WS-RESIZABLE                       BINARY-LONG.
 01 WS-CLOSABLE                        BINARY-LONG.
 01 WS-MAXIMIZABLE                     BINARY-LONG.
 01 WS-ICONIFIABLE                     BINARY-LONG.
 
 PROCEDURE DIVISION.

*>------------------------------------------------------------------------------
 MAIN-INTERNALFRAME1 SECTION.
*>------------------------------------------------------------------------------

*>    MOVE 5 TO WS-DEBUG-LEVEL
*>    MOVE J-SETDEBUG(WS-DEBUG-LEVEL) TO WS-RET
 
    MOVE J-START() TO WS-RET
    IF WS-RET = ZEROES
    THEN
       DISPLAY "can't connect to server"
       STOP RUN
    END-IF

*>  Generate GUI Objects    
    MOVE J-FRAME("InternalFrame1")      TO WS-FRAME  
    MOVE 800 TO WS-WIDTH
    MOVE 600 TO WS-HEIGHT
    MOVE J-SETSIZE(WS-FRAME, WS-WIDTH, WS-HEIGHT)  TO WS-RET

*>  Set desktoppane    
    MOVE J-DESKTOPPANE(WS-FRAME)        TO WS-DESKTOPPANE
    MOVE J-SETNAMEDCOLORBG(WS-DESKTOPPANE, J-CYAN) TO WS-RET
                                       
    MOVE J-MENUBAR(WS-FRAME)            TO WS-MENUBAR
    MOVE J-MENU(WS-MENUBAR, "File")     TO WS-FILE
    MOVE J-MENUITEM(WS-FILE, "Quit")    TO WS-QUIT

*>  Internal Frame 1
    MOVE J-TRUE TO WS-RESIZABLE  
    MOVE J-TRUE TO WS-CLOSABLE   
    MOVE J-TRUE TO WS-MAXIMIZABLE
    MOVE J-TRUE TO WS-ICONIFIABLE
    MOVE J-INTERNALFRAME(WS-FRAME, "Internal-Frame Test 1", 
         WS-RESIZABLE, WS-CLOSABLE, WS-MAXIMIZABLE, WS-ICONIFIABLE) TO WS-INTERNALFRAME-1
    MOVE 200 TO WS-WIDTH
    MOVE 200 TO WS-HEIGHT
    MOVE J-SETSIZE(WS-INTERNALFRAME-1, WS-WIDTH, WS-HEIGHT) TO WS-RET
    MOVE 30 TO WS-XPOS
    MOVE 30 TO WS-YPOS
    MOVE J-SETPOS(WS-INTERNALFRAME-1, WS-XPOS, WS-YPOS)     TO WS-RET

    MOVE J-LABEL(WS-INTERNALFRAME-1, "Test Label 1") TO WS-LABEL
    MOVE 30 TO WS-XPOS
    MOVE 30 TO WS-YPOS
    MOVE J-SETPOS(WS-LABEL, WS-XPOS, WS-YPOS)   TO WS-RET

    MOVE J-BUTTON(WS-INTERNALFRAME-1, "Test 1") TO WS-BUTTON
    MOVE 30 TO WS-XPOS
    MOVE 60 TO WS-YPOS
    MOVE J-SETPOS(WS-BUTTON, WS-XPOS, WS-YPOS)  TO WS-RET

*>  Internal Frame 2
    MOVE J-TRUE TO WS-RESIZABLE  
    MOVE J-TRUE TO WS-CLOSABLE   
    MOVE J-TRUE TO WS-MAXIMIZABLE
    MOVE J-TRUE TO WS-ICONIFIABLE
    MOVE J-INTERNALFRAME(WS-FRAME, "Internal-Frame Test 2", 
         WS-RESIZABLE, WS-CLOSABLE, WS-MAXIMIZABLE, WS-ICONIFIABLE) TO WS-INTERNALFRAME-2
    MOVE 200 TO WS-WIDTH
    MOVE 200 TO WS-HEIGHT
    MOVE J-SETSIZE(WS-INTERNALFRAME-2, WS-WIDTH, WS-HEIGHT) TO WS-RET
    MOVE 60 TO WS-XPOS
    MOVE 60 TO WS-YPOS
    MOVE J-SETPOS(WS-INTERNALFRAME-2, WS-XPOS, WS-YPOS)     TO WS-RET

    MOVE J-LABEL(WS-INTERNALFRAME-2, "Test Label 2") TO WS-LABEL
    MOVE 30 TO WS-XPOS
    MOVE 30 TO WS-YPOS
    MOVE J-SETPOS(WS-LABEL, WS-XPOS, WS-YPOS)   TO WS-RET

    MOVE J-BUTTON(WS-INTERNALFRAME-2, "Test 2") TO WS-BUTTON
    MOVE 30 TO WS-XPOS
    MOVE 60 TO WS-YPOS
    MOVE J-SETPOS(WS-BUTTON, WS-XPOS, WS-YPOS)  TO WS-RET
    
    MOVE J-SHOW(WS-FRAME) TO WS-RET
    MOVE J-SHOW(WS-INTERNALFRAME-1) TO WS-RET
    MOVE J-SHOW(WS-INTERNALFRAME-2) TO WS-RET

*>  Waiting for actions
    PERFORM FOREVER
       MOVE J-NEXTACTION() TO WS-OBJ

       IF (WS-OBJ = WS-QUIT) OR (WS-OBJ = WS-FRAME)
       THEN
          EXIT PERFORM
       END-IF
    END-PERFORM
    
    MOVE J-QUIT() TO WS-RET

    STOP RUN
    
    .
 MAIN-INTERNALFRAME1-EX.
    EXIT.
 END PROGRAM internalframe1.
