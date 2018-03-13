*>******************************************************************************
*>  This file is part of cobjapi.
*>
*>  filedialog.cob is free software: you can redistribute it and/or 
*>  modify it under the terms of the GNU Lesser General Public License as 
*>  published by the Free Software Foundation, either version 3 of the License,
*>  or (at your option) any later version.
*>
*>  filedialog.cob is distributed in the hope that it will be useful, 
*>  but WITHOUT ANY WARRANTY; without even the implied warranty of 
*>  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
*>  See the GNU Lesser General Public License for more details.
*>
*>  You should have received a copy of the GNU Lesser General Public License 
*>  along with filedialog.cob.
*>  If not, see <http://www.gnu.org/licenses/>.
*>******************************************************************************

*>******************************************************************************
*> Program:      filedialog.cob
*>
*> Purpose:      Example GnuCOBOL program for JAPI
*>
*> Author:       Laszlo Erdos - https://www.facebook.com/wortfee
*>
*> Date-Written: 2014.12.24
*>
*> Tectonics:    Example for static link.
*>               cobc -x -free filedialog.cob cobjapi.o \
*>                                            japilib.o \
*>                                            imageio.o \
*>                                            fileselect.o
*>
*> Usage:        ./filedialog.exe
*>
*>******************************************************************************
*> Date       Name / Change description 
*> ========== ==================================================================
*> 2003.02.26 This comment is only for History. The latest Version (V1.0.6) of 
*>            JAPI was released on 02/26/2003. Homepage: http://www.japi.de 
*>------------------------------------------------------------------------------
*> 2014.12.24 Laszlo Erdos: 
*>            - GnuCOBOL support for JAPI added. 
*>            - filedialog.c converted into filedialog.cob. 
*>******************************************************************************

 IDENTIFICATION DIVISION.
 PROGRAM-ID. filedialog.
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
    FUNCTION J-FILEDIALOG
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
 01 WS-OPEN                            BINARY-INT.
 01 WS-SAVE                            BINARY-INT.
 01 WS-OBJ                             BINARY-INT.
 
*> function args 
 01 WS-DEBUG-LEVEL                     BINARY-INT.

*> vars
 01 WS-FILENAME                        PIC X(1024).
 
 PROCEDURE DIVISION.

*>------------------------------------------------------------------------------
 MAIN-FILEDIALOG SECTION.
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
    MOVE J-FRAME("Filedialog Demo")  TO WS-FRAME  
                                     
    MOVE J-MENUBAR(WS-FRAME)         TO WS-MENUBAR
    MOVE J-MENU(WS-MENUBAR, "File")  TO WS-FILE
    MOVE J-MENUITEM(WS-FILE, "Open") TO WS-OPEN
    MOVE J-MENUITEM(WS-FILE, "Save") TO WS-SAVE
    MOVE J-MENUITEM(WS-FILE, "Quit") TO WS-QUIT

    MOVE J-SHOW(WS-FRAME) TO WS-RET

*>  Waiting for actions
    PERFORM FOREVER
       MOVE J-NEXTACTION() TO WS-OBJ

       IF WS-OBJ = WS-OPEN
       THEN
          MOVE J-FILEDIALOG(WS-FRAME, "Open File", "..", WS-FILENAME) 
            TO WS-RET
          DISPLAY "Open File: " TRIM(WS-FILENAME)
       END-IF

       IF WS-OBJ = WS-SAVE
       THEN
          MOVE J-FILEDIALOG(WS-FRAME, "Save File", ".", WS-FILENAME) 
            TO WS-RET
          DISPLAY "Save File: " TRIM(WS-FILENAME)
       END-IF
       
       IF (WS-OBJ = WS-QUIT) OR (WS-OBJ = WS-FRAME)
       THEN
          EXIT PERFORM
       END-IF
    END-PERFORM
    
    MOVE J-QUIT() TO WS-RET

    STOP RUN
    
    .
 MAIN-FILEDIALOG-EX.
    EXIT.
 END PROGRAM filedialog.
