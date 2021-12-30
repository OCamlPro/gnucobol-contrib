*>******************************************************************************
*>  This file is part of cobjapi.
*>
*>  tree_internal_frames.cob is free software: you can redistribute it and/or 
*>  modify it under the terms of the GNU Lesser General Public License as 
*>  published by the Free Software Foundation, either version 3 of the License,
*>  or (at your option) any later version.
*>
*>  tree_internal_frames.cob is distributed in the hope that it will be useful, 
*>  but WITHOUT ANY WARRANTY; without even the implied warranty of 
*>  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
*>  See the GNU Lesser General Public License for more details.
*>
*>  You should have received a copy of the GNU Lesser General Public License 
*>  along with tree_internal_frames.cob.
*>  If not, see <http://www.gnu.org/licenses/>.
*>******************************************************************************

*>******************************************************************************
*> Program:      tree_internal_frames.cob
*>
*> Purpose:      Example GnuCOBOL program for JAPI
*>
*> Author:       Laszlo Erdos - https://www.facebook.com/wortfee
*>
*> Date-Written: 2021.05.15
*>
*> Tectonics:    Example for static link.
*>               cobc -x -free tree_internal_frames.cob cobjapi.o \
*>                                                      japilib.o \
*>                                                      imageio.o \
*>                                                      fileselect.o
*>
*> Usage:        ./tree_internal_frames.exe
*>
*>******************************************************************************
*> Date       Name / Change description 
*> ========== ==================================================================
*> 2003.02.26 This comment is only for History. The latest Version (V1.0.6) of 
*>            JAPI was released on 02/26/2003. Homepage: http://www.japi.de 
*>------------------------------------------------------------------------------
*> 2021.05.15 Laszlo Erdos: 
*>            - first version.
*>******************************************************************************

 IDENTIFICATION DIVISION.
 PROGRAM-ID. tree_internal_frames.

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
 01 WS-OBJ                             BINARY-LONG.

*> GUI elements
 01 WS-FRAME                           BINARY-LONG.
 01 WS-FRAME-DUMMY                     BINARY-LONG.
 01 WS-MENUBAR                         BINARY-LONG.
 01 WS-FILE                            BINARY-LONG.
 01 WS-HELP                            BINARY-LONG.
 01 WS-QUIT                            BINARY-LONG.
 01 WS-ABOUT                           BINARY-LONG.
 01 WS-SCROLLPANE-1                    BINARY-LONG.
 01 WS-SCROLLPANE-2                    BINARY-LONG.
 01 WS-VSCROLL                         BINARY-LONG.
 01 WS-HSCROLL                         BINARY-LONG.
 01 WS-PANEL                           BINARY-LONG.
 01 WS-DESKTOPPANE                     BINARY-LONG.
 01 WS-SP                              BINARY-LONG.
 01 WS-TREE                            BINARY-LONG.
 01 WS-ICON                            BINARY-LONG.

*> function args 
 01 WS-DEBUG-LEVEL                     BINARY-LONG.
 01 WS-SHORTCUT-CHAR                   BINARY-CHAR.
 01 WS-WIDTH                           BINARY-LONG.
 01 WS-HEIGHT                          BINARY-LONG.
 01 WS-SCR-WIDTH                       BINARY-LONG.
 01 WS-SCR-HEIGHT                      BINARY-LONG.
 01 WS-XPOS                            BINARY-LONG.
 01 WS-YPOS                            BINARY-LONG.
 01 WS-POS                             BINARY-LONG.
 01 WS-MSEC                            BINARY-LONG.

*> RGB color
 01 WS-R                               BINARY-LONG.
 01 WS-G                               BINARY-LONG.
 01 WS-B                               BINARY-LONG.

 01 WS-NODE-SEARCH                     BINARY-LONG.
 01 WS-NODE-SEARCH-FLAG                PIC 9(1) VALUE 0.
    88 V-NODE-FOUND-NO                 VALUE 0.
    88 V-NODE-FOUND-YES                VALUE 1.

 01 WS-IND-1                           PIC 9(4). 

*> frames as nodes in cobol table 
 COPY "treeFrames.cpy".

 PROCEDURE DIVISION.

*>------------------------------------------------------------------------------
 MAIN-TREE-INTERNAL-FRAMES SECTION.
*>------------------------------------------------------------------------------

*>  MOVE 5 TO WS-DEBUG-LEVEL
*>  MOVE J-SETDEBUG(WS-DEBUG-LEVEL) TO WS-RET
 
    MOVE J-START() TO WS-RET
    IF WS-RET = ZEROES
    THEN
       DISPLAY "can't connect to server"
       STOP RUN
    END-IF

*>  create main frame with a tree and desktop-pane 
    PERFORM CREATE-MAIN-FRAME

*>  wait and process actions in a loop
    PERFORM PROCESS-ACTIONS
    
    MOVE J-QUIT() TO WS-RET

    STOP RUN
    
    .
 MAIN-TREE-INTERNAL-FRAMES-EX.
    EXIT.

*>------------------------------------------------------------------------------
 CREATE-MAIN-FRAME SECTION.
*>------------------------------------------------------------------------------

*>  generate GUI Objects    
    MOVE J-FRAME("Tree with internal frames Demo")  TO WS-FRAME  
    MOVE J-LOADIMAGE("images/new.gif") TO WS-ICON  
    MOVE J-SETICON(WS-FRAME, WS-ICON)  TO WS-RET
    
    MOVE J-MENUBAR(WS-FRAME)            TO WS-MENUBAR
    MOVE J-MENU(WS-MENUBAR, "File")     TO WS-FILE
    MOVE J-HELPMENU(WS-MENUBAR, "Help") TO WS-HELP

    MOVE J-MENUITEM(WS-FILE, "Quit")    TO WS-QUIT
*>  Q --> 81    
    MOVE 81 TO WS-SHORTCUT-CHAR
    MOVE J-SETSHORTCUT(WS-QUIT, WS-SHORTCUT-CHAR) TO WS-RET

    MOVE J-MENUITEM(WS-HELP, "About")   TO WS-ABOUT
    
    MOVE J-SETBORDERLAYOUT(WS-FRAME) TO WS-RET
    
    MOVE 180 TO WS-POS
    MOVE J-SPLITPANE(WS-FRAME, J-HORIZONTAL, WS-POS) TO WS-SP
    MOVE J-SETBORDERPOS(WS-SP, J-CENTER) TO WS-RET
    
    MOVE J-PANEL(WS-SP) TO WS-PANEL

    MOVE J-SCROLLPANE(WS-PANEL)        TO WS-SCROLLPANE-1
    MOVE J-VSCROLLBAR(WS-SCROLLPANE-1) TO WS-VSCROLL
    MOVE J-HSCROLLBAR(WS-SCROLLPANE-1) TO WS-HSCROLL
    MOVE J-SETSPLITPANELEFT(WS-SP, WS-SCROLLPANE-1)  TO WS-RET

*>  Add desktop-pane to a dummy frame, you need this for internal frame
    MOVE J-FRAME("Dummy-Frame") TO WS-FRAME-DUMMY  
    MOVE J-DESKTOPPANE(WS-FRAME-DUMMY) TO WS-DESKTOPPANE
    MOVE J-SETSPLITPANERIGHT(WS-SP, WS-DESKTOPPANE) TO WS-RET

    MOVE J-SCROLLPANE(WS-DESKTOPPANE)  TO WS-SCROLLPANE-2
    MOVE J-VSCROLLBAR(WS-SCROLLPANE-2) TO WS-VSCROLL
    MOVE J-HSCROLLBAR(WS-SCROLLPANE-2) TO WS-HSCROLL

*>  create root node
    MOVE J-NODE(WS-NODE-NAME(1)) TO WS-NODE-ID(1)
 
*>  create nodes and tree structure    
    PERFORM VARYING WS-IND-1 FROM 2 BY 1
            UNTIL WS-IND-1 > C-MAX-IND
       MOVE J-NODE(WS-NODE-NAME(WS-IND-1)) TO WS-NODE-ID(WS-IND-1)
       MOVE J-ADDNODE(WS-NODE-ID(WS-NODE-PARENT-IND(WS-IND-1)), WS-NODE-ID(WS-IND-1)) TO WS-RET
    END-PERFORM

*>  create tree
    MOVE J-TREE(WS-SCROLLPANE-1, WS-NODE-ID(1)) TO WS-TREE
    MOVE J-ENABLEDOUBLECLICK(WS-TREE)           TO WS-RET
    MOVE 240 TO WS-R  MOVE 240 TO WS-G  MOVE 240 TO WS-B
    MOVE J-SETTREEBGNONSELCOLOR(WS-TREE, WS-R, WS-G, WS-B) TO WS-RET

*>  get screen data
    MOVE J-GETSCREENWIDTH()  TO WS-SCR-WIDTH
    MOVE J-GETSCREENHEIGHT() TO WS-SCR-HEIGHT

*>  set frame size    
    MOVE 800 TO WS-WIDTH 
    MOVE 600 TO WS-HEIGHT 
    MOVE J-SETSIZE(WS-FRAME, WS-WIDTH, WS-HEIGHT) TO WS-RET

*>  the frame position is in the middle of the screen
    COMPUTE WS-XPOS = (WS-SCR-WIDTH - WS-WIDTH) / 2
    COMPUTE WS-YPOS = (WS-SCR-HEIGHT - WS-HEIGHT) / 2
    MOVE J-SETPOS(WS-FRAME, WS-XPOS, WS-YPOS) TO WS-RET
    
    MOVE J-SHOW(WS-FRAME) TO WS-RET

    EXIT SECTION .

*>------------------------------------------------------------------------------
 PROCESS-ACTIONS SECTION.
*>------------------------------------------------------------------------------

*>  Waiting for actions
    PERFORM FOREVER
*>     returns the next event, or 0 if no event available       
       MOVE J-NEXTACTION() TO WS-OBJ

       IF (WS-OBJ = WS-QUIT) OR (WS-OBJ = WS-FRAME)
       THEN
          EXIT PERFORM
       END-IF
       
*>     check click on a node
       IF WS-OBJ NOT = 0
       THEN
          MOVE WS-OBJ TO WS-NODE-SEARCH
          PERFORM SEARCH-NODE-ID

*>        create internal frame
          IF  V-NODE-FOUND-YES OF WS-NODE-SEARCH-FLAG
          AND V-LEAF-YES OF WS-LEAF-FLAG(WS-IND-1)
          AND V-NO OF WS-IFRAME-CREATED(WS-IND-1)
          THEN
             PERFORM CALL-IFRAME
          END-IF       
       END-IF   

*>     go thrue all created internal frames and process theire events
       PERFORM VARYING WS-IND-1 FROM 1 BY 1
               UNTIL WS-IND-1 > C-MAX-IND
          IF V-YES OF WS-IFRAME-CREATED(WS-IND-1)
          THEN
             PERFORM CALL-IFRAME
          END-IF
       END-PERFORM
       
       IF WS-OBJ = WS-ABOUT
       THEN
          MOVE J-ALERTBOX(WS-FRAME, 
               "Tree with internal frames Demo",
               "TODO: short description of this frame...",
               "OK"
               )
            TO WS-RET                    
       END-IF

       MOVE J-SYNC() TO WS-RET
       MOVE 10 TO WS-MSEC
       MOVE J-SLEEP(WS-MSEC) TO WS-RET
    END-PERFORM

    EXIT SECTION .
    
*>------------------------------------------------------------------------------
 SEARCH-NODE-ID SECTION.
*>------------------------------------------------------------------------------

    SET V-NODE-FOUND-NO OF WS-NODE-SEARCH-FLAG TO TRUE    
    
    PERFORM VARYING WS-IND-1 FROM 1 BY 1
            UNTIL WS-IND-1 > C-MAX-IND
       IF WS-NODE-ID(WS-IND-1) = WS-NODE-SEARCH
       THEN
          SET V-NODE-FOUND-YES OF WS-NODE-SEARCH-FLAG TO TRUE    
          EXIT PERFORM
       END-IF
    END-PERFORM
    
    EXIT SECTION .

*>------------------------------------------------------------------------------
 CALL-IFRAME SECTION.
*>------------------------------------------------------------------------------

    CALL  WS-IFRAME-NAME(WS-IND-1) 
          USING WS-FRAME
                WS-DESKTOPPANE 
                WS-OBJ
                WS-NODE-NAME(WS-IND-1)
                WS-IFRAME-CREATED(WS-IND-1)
    END-CALL
    
    EXIT SECTION .

 END PROGRAM tree_internal_frames.
