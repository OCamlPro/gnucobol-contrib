*>******************************************************************************
*>  This file is part of cobjapi.
*>
*>  tabbedpane.cob is free software: you can redistribute it and/or 
*>  modify it under the terms of the GNU Lesser General Public License as 
*>  published by the Free Software Foundation, either version 3 of the License,
*>  or (at your option) any later version.
*>
*>  tabbedpane.cob is distributed in the hope that it will be useful, 
*>  but WITHOUT ANY WARRANTY; without even the implied warranty of 
*>  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
*>  See the GNU Lesser General Public License for more details.
*>
*>  You should have received a copy of the GNU Lesser General Public License 
*>  along with tabbedpane.cob.
*>  If not, see <http://www.gnu.org/licenses/>.
*>******************************************************************************

*>******************************************************************************
*> Program:      tabbedpane.cob
*>
*> Purpose:      Example GnuCOBOL program for JAPI
*>
*> Author:       Laszlo Erdos - https://www.facebook.com/wortfee
*>
*> Date-Written: 2020.05.21
*>
*> Tectonics:    Example for static link.
*>               cobc -x -free tabbedpane.cob cobjapi.o \
*>                                            japilib.o \
*>                                            imageio.o \
*>                                            fileselect.o
*>
*> Usage:        ./tabbedpane.exe
*>
*>******************************************************************************
*> Date       Name / Change description 
*> ========== ==================================================================
*> 2003.02.26 This comment is only for History. The latest Version (V1.0.6) of 
*>            JAPI was released on 02/26/2003. Homepage: http://www.japi.de 
*>------------------------------------------------------------------------------
*> 2020.05.21 Laszlo Erdos: 
*>            - panel.cob converted into tabbedpane.cob. 
*>------------------------------------------------------------------------------
*> 2020.05.23 Laszlo Erdos: 
*>            - BINARY-INT replaced with BINARY-LONG.
*>------------------------------------------------------------------------------
*> 2020.05.30 Laszlo Erdos: 
*>            - J-ADDTABWITHICON.
*>******************************************************************************

 IDENTIFICATION DIVISION.
 PROGRAM-ID. tabbedpane.
 AUTHOR.     Laszlo Erdos.

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
 01 WS-PANEL                           BINARY-LONG.
 01 WS-TABBEDPANE-1                    BINARY-LONG.
 01 WS-TABBEDPANE-2                    BINARY-LONG.
 01 WS-TAB-PANEL-1                     BINARY-LONG.
 01 WS-TAB-PANEL-2                     BINARY-LONG.
 01 WS-TAB-PANEL-3                     BINARY-LONG.
 01 WS-TAB-PANEL-31                    BINARY-LONG.
 01 WS-TAB-PANEL-32                    BINARY-LONG.
 01 WS-TAB-PANEL-33                    BINARY-LONG.
 01 WS-LABEL                           BINARY-LONG.
 01 WS-OBJ                             BINARY-LONG.
 
*> function args 
 01 WS-DEBUG-LEVEL                     BINARY-LONG.
 01 WS-XPOS                            BINARY-LONG.
 01 WS-YPOS                            BINARY-LONG.
 01 WS-TOP                             BINARY-LONG.
 01 WS-BOTTOM                          BINARY-LONG.
 01 WS-LEFT                            BINARY-LONG.
 01 WS-RIGHT                           BINARY-LONG.

 PROCEDURE DIVISION.

*>------------------------------------------------------------------------------
 MAIN-TABBEDPANE SECTION.
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
    MOVE J-FRAME("TabbedPane demo") TO WS-FRAME  
                                      
    MOVE J-MENUBAR(WS-FRAME)          TO WS-MENUBAR
    MOVE J-MENU(WS-MENUBAR, "File")   TO WS-FILE
    MOVE J-MENUITEM(WS-FILE, "Quit")  TO WS-QUIT
    
    MOVE J-SETBORDERLAYOUT(WS-FRAME)  TO WS-RET
    MOVE J-TABBEDPANE(WS-FRAME)       TO WS-TABBEDPANE-1
    MOVE 30 TO WS-TOP   
    MOVE 30 TO WS-BOTTOM
    MOVE 30 TO WS-LEFT  
    MOVE 30 TO WS-RIGHT 
    MOVE J-SETINSETS(WS-TABBEDPANE-1, WS-TOP, WS-BOTTOM, WS-LEFT, WS-RIGHT) TO WS-RET

*>  add tabs with icon
    MOVE J-ADDTABWITHICON(WS-TABBEDPANE-1, "Tab #1", "images/open.gif") TO WS-TAB-PANEL-1
    MOVE J-ADDTABWITHICON(WS-TABBEDPANE-1, "Tab #2", "images/new.gif") TO WS-TAB-PANEL-2
    MOVE J-ADDTABWITHICON(WS-TABBEDPANE-1, "Tab #3", "images/save.gif") TO WS-TAB-PANEL-3

    MOVE J-LABEL(WS-TAB-PANEL-1, "This is Tab-Panel #1") TO WS-LABEL
    MOVE 40 TO WS-XPOS
    MOVE 40 TO WS-YPOS
    MOVE J-SETPOS(WS-LABEL, WS-XPOS, WS-YPOS) TO WS-RET

    MOVE J-LABEL(WS-TAB-PANEL-2, "This is Tab-Panel #2") TO WS-LABEL
    MOVE 40 TO WS-XPOS
    MOVE 40 TO WS-YPOS
    MOVE J-SETPOS(WS-LABEL, WS-XPOS, WS-YPOS) TO WS-RET

    MOVE J-SETBORDERLAYOUT(WS-TAB-PANEL-3) TO WS-RET
    MOVE J-LABEL(WS-TAB-PANEL-3, "This is Tab-Panel #3") TO WS-LABEL
    MOVE J-SETBORDERPOS(WS-LABEL, J-TOP) TO WS-RET

*>  Embed TabbedPane in a TabbedPane Panel
    MOVE J-TABBEDPANE(WS-TAB-PANEL-3) TO WS-TABBEDPANE-2
    MOVE 30 TO WS-TOP   
    MOVE 10 TO WS-BOTTOM
    MOVE 10 TO WS-LEFT  
    MOVE 10 TO WS-RIGHT 
    MOVE J-SETINSETS(WS-TABBEDPANE-2, WS-TOP, WS-BOTTOM, WS-LEFT, WS-RIGHT) TO WS-RET
*>  add tabs without icon
    MOVE J-ADDTAB(WS-TABBEDPANE-2, "Tab #31") TO WS-TAB-PANEL-31
    MOVE J-ADDTAB(WS-TABBEDPANE-2, "Tab #32") TO WS-TAB-PANEL-32
    MOVE J-ADDTAB(WS-TABBEDPANE-2, "Tab #33") TO WS-TAB-PANEL-33
    MOVE J-SETBORDERPOS(WS-TABBEDPANE-2, J-CENTER) TO WS-RET

    MOVE J-LABEL(WS-TAB-PANEL-31, "Embedded Tab-Panel #31") TO WS-LABEL
    MOVE 40 TO WS-XPOS
    MOVE 40 TO WS-YPOS
    MOVE J-SETPOS(WS-LABEL, WS-XPOS, WS-YPOS) TO WS-RET
    
    MOVE J-LABEL(WS-TAB-PANEL-32, "Embedded Tab-Panel #32") TO WS-LABEL
    MOVE 40 TO WS-XPOS
    MOVE 40 TO WS-YPOS
    MOVE J-SETPOS(WS-LABEL, WS-XPOS, WS-YPOS) TO WS-RET
    
    MOVE J-LABEL(WS-TAB-PANEL-33, "Embedded Tab-Panel #33") TO WS-LABEL
    MOVE 40 TO WS-XPOS
    MOVE 40 TO WS-YPOS
    MOVE J-SETPOS(WS-LABEL, WS-XPOS, WS-YPOS) TO WS-RET

    MOVE J-SHOW(WS-FRAME) TO WS-RET

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
 MAIN-TABBEDPANE-EX.
    EXIT.
 END PROGRAM tabbedpane.
