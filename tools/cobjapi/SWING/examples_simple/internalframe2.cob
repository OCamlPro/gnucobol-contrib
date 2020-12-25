*>******************************************************************************
*>  This file is part of cobjapi.
*>
*>  internalframe2.cob is free software: you can redistribute it and/or 
*>  modify it under the terms of the GNU Lesser General Public License as 
*>  published by the Free Software Foundation, either version 3 of the License,
*>  or (at your option) any later version.
*>
*>  internalframe2.cob is distributed in the hope that it will be useful, 
*>  but WITHOUT ANY WARRANTY; without even the implied warranty of 
*>  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
*>  See the GNU Lesser General Public License for more details.
*>
*>  You should have received a copy of the GNU Lesser General Public License 
*>  along with internalframe2.cob.
*>  If not, see <http://www.gnu.org/licenses/>.
*>******************************************************************************

*>******************************************************************************
*> Program:      internalframe2.cob
*>
*> Purpose:      Example GnuCOBOL program for JAPI
*>
*> Author:       Laszlo Erdos - https://www.facebook.com/wortfee
*>
*> Date-Written: 2020.12.22
*>
*> Tectonics:    Example for static link.
*>               cobc -x -free internalframe2.cob cobjapi.o \
*>                                                japilib.o \
*>                                                imageio.o \
*>                                                fileselect.o
*>
*> Usage:        ./internalframe2.exe
*>
*>******************************************************************************
*> Date       Name / Change description 
*> ========== ==================================================================
*> 2003.02.26 This comment is only for History. The latest Version (V1.0.6) of 
*>            JAPI was released on 02/26/2003. Homepage: http://www.japi.de 
*>------------------------------------------------------------------------------
*> 2020.12.22 Laszlo Erdos: 
*>            - button.cob converted into internalframe2.cob. 
*>******************************************************************************

 IDENTIFICATION DIVISION.
 PROGRAM-ID. internalframe2.

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
 01 WS-FRAME-DUMMY                     BINARY-LONG.
 01 WS-MENUBAR                         BINARY-LONG.
 01 WS-FILE                            BINARY-LONG.
 01 WS-QUIT                            BINARY-LONG.
 01 WS-DESKTOPPANE                     BINARY-LONG.
 01 WS-SP                              BINARY-LONG.
 01 WS-INTERNALFRAME                   BINARY-LONG.
 01 WS-BUTTON-ADD-FRAME                BINARY-LONG.
 01 WS-BUTTON                          BINARY-LONG.
 01 WS-LABEL                           BINARY-LONG.
 01 WS-PANEL-1                         BINARY-LONG.
 01 WS-PANEL-2                         BINARY-LONG.
 01 WS-ICON                            BINARY-LONG.
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
 01 WS-POS                             BINARY-LONG.
 
 PROCEDURE DIVISION.

*>------------------------------------------------------------------------------
 MAIN-INTERNALFRAME2 SECTION.
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
    MOVE J-FRAME("InternalFrame2") TO WS-FRAME  

    MOVE 800 TO WS-WIDTH
    MOVE 600 TO WS-HEIGHT
    MOVE J-SETSIZE(WS-FRAME, WS-WIDTH, WS-HEIGHT) TO WS-RET

    MOVE J-MENUBAR(WS-FRAME)         TO WS-MENUBAR
    MOVE J-MENU(WS-MENUBAR, "File")  TO WS-FILE
    MOVE J-MENUITEM(WS-FILE, "Quit") TO WS-QUIT

    MOVE J-LOADIMAGE("images/new.gif") TO WS-ICON  
    MOVE J-SETICON(WS-FRAME, WS-ICON)  TO WS-RET

    MOVE J-SETBORDERLAYOUT(WS-FRAME)   TO WS-RET
    
    MOVE 142 TO WS-POS
    MOVE J-SPLITPANE(WS-FRAME, J-HORIZONTAL, WS-POS) TO WS-SP
    MOVE J-SETBORDERPOS(WS-SP, J-CENTER)             TO WS-RET
    
    MOVE J-PANEL(WS-SP) TO WS-PANEL-1

*>  Add desktop-pane to a dummy frame, you need this for internal frame
    MOVE J-FRAME("Dummy-Frame") TO WS-FRAME-DUMMY  
    MOVE J-DESKTOPPANE(WS-FRAME-DUMMY) TO WS-DESKTOPPANE
    
    MOVE J-SETSPLITPANELEFT(WS-SP, WS-PANEL-1)      TO WS-RET
    MOVE J-SETSPLITPANERIGHT(WS-SP, WS-DESKTOPPANE) TO WS-RET

    MOVE J-SETFLOWLAYOUT(WS-PANEL-1, J-VERTICAL) TO WS-RET        
    MOVE J-SETALIGN(WS-PANEL-1, J-TOP)           TO WS-RET                               
    MOVE J-LABEL(WS-PANEL-1, "Left Panel")       TO WS-LABEL
    MOVE J-BUTTON(WS-PANEL-1, "Add Frame")       TO WS-BUTTON-ADD-FRAME

    MOVE J-SHOW(WS-FRAME) TO WS-RET

*>  Waiting for actions
    PERFORM FOREVER
       MOVE J-NEXTACTION() TO WS-OBJ

       IF WS-OBJ = WS-BUTTON-ADD-FRAME
       THEN
*>         Add new internal frame
          PERFORM ADD-INTERNAL-FRAME
       END-IF

       IF (WS-OBJ = WS-QUIT) OR (WS-OBJ = WS-FRAME)
       THEN
          EXIT PERFORM
       END-IF
    END-PERFORM
    
    MOVE J-QUIT() TO WS-RET

    STOP RUN
    
    .
 MAIN-INTERNALFRAME2-EX.
    EXIT.
    
*>------------------------------------------------------------------------------
 ADD-INTERNAL-FRAME SECTION.
*>------------------------------------------------------------------------------
    
    MOVE J-TRUE TO WS-RESIZABLE  
    MOVE J-TRUE TO WS-CLOSABLE   
    MOVE J-TRUE TO WS-MAXIMIZABLE
    MOVE J-TRUE TO WS-ICONIFIABLE
    MOVE J-INTERNALFRAME(WS-DESKTOPPANE, "Internal-Frame Test", 
         WS-RESIZABLE, WS-CLOSABLE, WS-MAXIMIZABLE, WS-ICONIFIABLE) TO WS-INTERNALFRAME

    MOVE J-SETICON(WS-INTERNALFRAME, WS-ICON) TO WS-RET
         
    MOVE 200 TO WS-WIDTH
    MOVE 200 TO WS-HEIGHT
    MOVE J-SETSIZE(WS-INTERNALFRAME, WS-WIDTH, WS-HEIGHT) TO WS-RET
    MOVE 30 TO WS-XPOS
    MOVE 30 TO WS-YPOS
    MOVE J-SETPOS(WS-INTERNALFRAME, WS-XPOS, WS-YPOS)     TO WS-RET
    MOVE J-SETBORDERLAYOUT(WS-INTERNALFRAME)              TO WS-RET

    MOVE J-PANEL(WS-INTERNALFRAME) TO WS-PANEL-2

    MOVE J-LABEL(WS-PANEL-2, "Test Label")     TO WS-LABEL
    MOVE 30 TO WS-XPOS
    MOVE 30 TO WS-YPOS
    MOVE J-SETPOS(WS-LABEL, WS-XPOS, WS-YPOS)  TO WS-RET

    MOVE J-BUTTON(WS-PANEL-2, "Test Button")   TO WS-BUTTON
    MOVE 30 TO WS-XPOS
    MOVE 60 TO WS-YPOS
    MOVE J-SETPOS(WS-BUTTON, WS-XPOS, WS-YPOS) TO WS-RET
    
    MOVE J-SHOW(WS-INTERNALFRAME) TO WS-RET

    EXIT SECTION.
    
 END PROGRAM internalframe2.
