*>******************************************************************************
*>  This file is part of cobjapi.
*>
*>  menu.cob is free software: you can redistribute it and/or 
*>  modify it under the terms of the GNU Lesser General Public License as 
*>  published by the Free Software Foundation, either version 3 of the License,
*>  or (at your option) any later version.
*>
*>  menu.cob is distributed in the hope that it will be useful, 
*>  but WITHOUT ANY WARRANTY; without even the implied warranty of 
*>  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
*>  See the GNU Lesser General Public License for more details.
*>
*>  You should have received a copy of the GNU Lesser General Public License 
*>  along with menu.cob.
*>  If not, see <http://www.gnu.org/licenses/>.
*>******************************************************************************

*>******************************************************************************
*> Program:      menu.cob
*>
*> Purpose:      Example GnuCOBOL program for JAPI
*>
*> Author:       Laszlo Erdos - https://www.facebook.com/wortfee
*>
*> Date-Written: 2014.12.24
*>
*> Tectonics:    Example for static link.
*>               cobc -x -free menu.cob cobjapi.o \
*>                                      japilib.o \
*>                                      imageio.o \
*>                                      fileselect.o
*>
*> Usage:        ./menu.exe
*>
*>******************************************************************************
*> Date       Name / Change description 
*> ========== ==================================================================
*> 2003.02.26 This comment is only for History. The latest Version (V1.0.6) of 
*>            JAPI was released on 02/26/2003. Homepage: http://www.japi.de 
*>------------------------------------------------------------------------------
*> 2014.12.24 Laszlo Erdos: 
*>            - GnuCOBOL support for JAPI added. 
*>            - menu.c converted into menu.cob. 
*>******************************************************************************

 IDENTIFICATION DIVISION.
 PROGRAM-ID. menu.
 AUTHOR.     Laszlo Erdos.

 ENVIRONMENT DIVISION.
 CONFIGURATION SECTION.
 REPOSITORY.
    FUNCTION J-SETDEBUG
    FUNCTION J-START
    FUNCTION J-FRAME
    FUNCTION J-MENUBAR
    FUNCTION J-MENU
    FUNCTION J-HELPMENU
    FUNCTION J-MENUITEM    
    FUNCTION J-SEPERATOR
    FUNCTION J-DISABLE
    FUNCTION J-ENABLE
    FUNCTION J-SETSHORTCUT
    FUNCTION J-CHECKMENUITEM
    FUNCTION J-SHOW
    FUNCTION J-NEXTACTION
    FUNCTION J-GETSTATE
    FUNCTION J-GETTEXT
    FUNCTION J-SETTEXT
    FUNCTION J-QUIT
    FUNCTION ALL INTRINSIC.

 DATA DIVISION.

 WORKING-STORAGE SECTION.
*> function return value 
 01 WS-RET                             BINARY-INT.

*> GUI elements
 01 WS-FRAME                           BINARY-INT.
 01 WS-MENUBAR                         BINARY-INT.
 01 WS-SUBMENU                         BINARY-INT.
 01 WS-FILE                            BINARY-INT.
 01 WS-EDIT                            BINARY-INT.
 01 WS-OPTIONS                         BINARY-INT.
 01 WS-HELP                            BINARY-INT.
 01 WS-OPEN                            BINARY-INT.
 01 WS-SAVE                            BINARY-INT.
 01 WS-QUIT                            BINARY-INT.
 01 WS-ABOUT                           BINARY-INT.
 01 WS-CUT                             BINARY-INT.
 01 WS-COPY                            BINARY-INT.
 01 WS-PASTE                           BINARY-INT.
 01 WS-ENABLE                          BINARY-INT.
 01 WS-SETTINGS                        BINARY-INT.
 01 WS-OBJ                             BINARY-INT.
 
*> function args 
 01 WS-DEBUG-LEVEL                     BINARY-INT.
 01 WS-SHORTCUT-CHAR                   BINARY-CHAR.
 01 WS-CONTENT                         PIC X(1024).
     
*> Constants for the cobjapi wrapper 
 COPY "cobjapi.cpy".
 
 PROCEDURE DIVISION.

*>------------------------------------------------------------------------------
 MAIN-MENU SECTION.
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
    MOVE J-FRAME("Menu Demo") TO WS-FRAME  
                                       
    MOVE J-MENUBAR(WS-FRAME)            TO WS-MENUBAR
    MOVE J-MENU(WS-MENUBAR, "File")     TO WS-FILE
    MOVE J-MENU(WS-MENUBAR, "Edit")     TO WS-EDIT
    MOVE J-MENU(WS-MENUBAR, "Options")  TO WS-OPTIONS
    MOVE J-MENU(WS-MENUBAR, "Settings") TO WS-SUBMENU
    MOVE J-HELPMENU(WS-MENUBAR, "Help") TO WS-HELP

    MOVE J-MENUITEM(WS-FILE, "Open")    TO WS-OPEN
    MOVE J-MENUITEM(WS-FILE, "Save")    TO WS-SAVE
    MOVE J-SEPERATOR(WS-FILE)           TO WS-RET
    MOVE J-MENUITEM(WS-FILE, "Quit")    TO WS-QUIT
    MOVE J-DISABLE(WS-SAVE)             TO WS-RET
*>  Q --> 81    
    MOVE 81 TO WS-SHORTCUT-CHAR
    MOVE J-SETSHORTCUT(WS-QUIT, WS-SHORTCUT-CHAR) TO WS-RET

    MOVE J-MENUITEM(WS-EDIT, "Cut")     TO WS-CUT
    MOVE J-MENUITEM(WS-EDIT, "Copy")    TO WS-COPY
    MOVE J-MENUITEM(WS-EDIT, "Paste")   TO WS-PASTE

    MOVE J-MENUITEM(WS-HELP, "About")   TO WS-ABOUT
    
    MOVE J-CHECKMENUITEM(WS-SUBMENU, "Enable Settings") TO WS-ENABLE
    MOVE J-MENUITEM(WS-SUBMENU, "Settings") TO WS-SETTINGS
    MOVE J-DISABLE(WS-SETTINGS)             TO WS-RET
    
    MOVE J-SHOW(WS-FRAME) TO WS-RET

*>  Waiting for actions
    PERFORM FOREVER
       MOVE J-NEXTACTION() TO WS-OBJ

       IF (WS-OBJ = WS-QUIT) OR (WS-OBJ = WS-FRAME)
       THEN
          EXIT PERFORM
       END-IF

       IF WS-OBJ = WS-ENABLE
       THEN
          IF J-GETSTATE(WS-ENABLE) = J-FALSE
          THEN
             MOVE J-DISABLE(WS-SETTINGS) TO WS-RET
          ELSE
             MOVE J-ENABLE(WS-SETTINGS)  TO WS-RET
          END-IF
       END-IF

       IF WS-OBJ = WS-CUT
       THEN
          MOVE J-GETTEXT(WS-CUT, WS-CONTENT) TO WS-RET
          DISPLAY "WS-CONTENT: " TRIM(WS-CONTENT)

          IF TRIM(WS-CONTENT) = "Cut"
          THEN
             MOVE J-SETTEXT(WS-CUT, "Ausschneiden") TO WS-RET
          ELSE
             MOVE J-SETTEXT(WS-CUT, "Cut")          TO WS-RET
          END-IF
       END-IF

       IF WS-OBJ = WS-COPY
       THEN
          MOVE J-GETTEXT(WS-COPY, WS-CONTENT) TO WS-RET
          DISPLAY "WS-CONTENT: " TRIM(WS-CONTENT)

          IF TRIM(WS-CONTENT) = "Copy"
          THEN
             MOVE J-SETTEXT(WS-COPY, "Kopieren") TO WS-RET
          ELSE
             MOVE J-SETTEXT(WS-COPY, "Copy")     TO WS-RET
          END-IF
       END-IF

       IF WS-OBJ = WS-PASTE
       THEN
          MOVE J-GETTEXT(WS-PASTE, WS-CONTENT) TO WS-RET
          DISPLAY "WS-CONTENT: " TRIM(WS-CONTENT)

          IF TRIM(WS-CONTENT) = "Paste"
          THEN
             MOVE J-SETTEXT(WS-PASTE, "Einfuegen") TO WS-RET
          ELSE
             MOVE J-SETTEXT(WS-PASTE, "Paste")     TO WS-RET
          END-IF
       END-IF
    END-PERFORM
    
    MOVE J-QUIT() TO WS-RET

    STOP RUN
    
    .
 MAIN-MENU-EX.
    EXIT.
 END PROGRAM menu.
