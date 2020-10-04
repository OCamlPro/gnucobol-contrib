*>******************************************************************************
*>  This file is part of cobjapi.
*>
*>  tree4.cob is free software: you can redistribute it and/or 
*>  modify it under the terms of the GNU Lesser General Public License as 
*>  published by the Free Software Foundation, either version 3 of the License,
*>  or (at your option) any later version.
*>
*>  tree4.cob is distributed in the hope that it will be useful, 
*>  but WITHOUT ANY WARRANTY; without even the implied warranty of 
*>  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
*>  See the GNU Lesser General Public License for more details.
*>
*>  You should have received a copy of the GNU Lesser General Public License 
*>  along with tree4.cob.
*>  If not, see <http://www.gnu.org/licenses/>.
*>******************************************************************************

*>******************************************************************************
*> Program:      tree4.cob
*>
*> Purpose:      Example GnuCOBOL program for JAPI
*>
*> Author:       Laszlo Erdos - https://www.facebook.com/wortfee
*>
*> Date-Written: 2020.10.03
*>
*> Tectonics:    Example for static link.
*>               cobc -x -free tree4.cob cobjapi.o \
*>                                       japilib.o \
*>                                       imageio.o \
*>                                       fileselect.o
*>
*> Usage:        ./tree4.exe
*>
*>******************************************************************************
*> Date       Name / Change description 
*> ========== ==================================================================
*> 2003.02.26 This comment is only for History. The latest Version (V1.0.6) of 
*>            JAPI was released on 02/26/2003. Homepage: http://www.japi.de 
*>------------------------------------------------------------------------------
*> 2020.10.03 Laszlo Erdos: 
*>            - first version.
*>******************************************************************************

 IDENTIFICATION DIVISION.
 PROGRAM-ID. tree4.
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
 01 WS-OBJ                             BINARY-LONG.

*> GUI elements
 01 WS-FRAME                           BINARY-LONG.
 01 WS-MENUBAR                         BINARY-LONG.
 01 WS-SUBMENU                         BINARY-LONG.
 01 WS-FILE                            BINARY-LONG.
 01 WS-HELP                            BINARY-LONG.
 01 WS-QUIT                            BINARY-LONG.
 01 WS-ABOUT                           BINARY-LONG.
 01 WS-ENABLE                          BINARY-LONG.
 01 WS-SCROLLPANE-1                    BINARY-LONG.
 01 WS-SCROLLPANE-2                    BINARY-LONG.
 01 WS-VSCROLL                         BINARY-LONG.
 01 WS-HSCROLL                         BINARY-LONG.
 01 WS-PANEL-1                         BINARY-LONG.
 01 WS-PANEL-2                         BINARY-LONG.
 01 WS-SP                              BINARY-LONG.
 01 WS-LABEL                           BINARY-LONG.
 01 WS-TREE                            BINARY-LONG.

 01 WS-NODE-SEARCH                     BINARY-LONG.
 01 WS-NODE-SEARCH-FLAG                PIC 9(1) VALUE 0.
    88 V-NODE-FOUND-NO                 VALUE 0.
    88 V-NODE-FOUND-YES                VALUE 1.

 01 WS-IND-1                           PIC 9(4). 
 01 WS-TEXT                            PIC X(256).

*> countries as nodes in cobol table 
 COPY "tree4Countries.cpy".

*> function args 
 01 WS-DEBUG-LEVEL                     BINARY-LONG.
 01 WS-POS                             BINARY-LONG.
 01 WS-SHORTCUT-CHAR                   BINARY-CHAR.

 PROCEDURE DIVISION.

*>------------------------------------------------------------------------------
 MAIN-TREE4 SECTION.
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
    MOVE J-FRAME("Tree4 Demo")  TO WS-FRAME  
    
    MOVE J-MENUBAR(WS-FRAME)            TO WS-MENUBAR
    MOVE J-MENU(WS-MENUBAR, "File")     TO WS-FILE
    MOVE J-MENU(WS-MENUBAR, "Tree settings") TO WS-SUBMENU
    MOVE J-HELPMENU(WS-MENUBAR, "Help") TO WS-HELP

    MOVE J-MENUITEM(WS-FILE, "Quit")    TO WS-QUIT
*>  Q --> 81    
    MOVE 81 TO WS-SHORTCUT-CHAR
    MOVE J-SETSHORTCUT(WS-QUIT, WS-SHORTCUT-CHAR) TO WS-RET

    MOVE J-MENUITEM(WS-HELP, "About")   TO WS-ABOUT
    
    MOVE J-CHECKMENUITEM(WS-SUBMENU, "Enable double click action") TO WS-ENABLE
    
    
    MOVE J-SETBORDERLAYOUT(WS-FRAME) TO WS-RET
    
    MOVE 142 TO WS-POS
    MOVE J-SPLITPANE(WS-FRAME, J-HORIZONTAL, WS-POS) TO WS-SP
    MOVE J-SETBORDERPOS(WS-SP, J-CENTER) TO WS-RET
    
    MOVE J-PANEL(WS-SP) TO WS-PANEL-1
    MOVE J-PANEL(WS-SP) TO WS-PANEL-2

    MOVE J-SCROLLPANE(WS-PANEL-1)    TO WS-SCROLLPANE-1
    MOVE J-VSCROLLBAR(WS-SCROLLPANE-1) TO WS-VSCROLL
    MOVE J-HSCROLLBAR(WS-SCROLLPANE-1) TO WS-HSCROLL
    MOVE J-SETSPLITPANELEFT(WS-SP, WS-SCROLLPANE-1)  TO WS-RET

    MOVE J-SCROLLPANE(WS-PANEL-2)    TO WS-SCROLLPANE-2
    MOVE J-VSCROLLBAR(WS-SCROLLPANE-2) TO WS-VSCROLL
    MOVE J-HSCROLLBAR(WS-SCROLLPANE-2) TO WS-HSCROLL
    MOVE J-SETSPLITPANERIGHT(WS-SP, WS-SCROLLPANE-2) TO WS-RET

    MOVE J-LABEL(WS-SCROLLPANE-2, "Right Panel") TO WS-LABEL

*>  create root node
    MOVE J-NODE(WS-COUNTRY(1)) TO WS-NODE-ID(1)
 
*>  create nodes and tree structure    
    PERFORM VARYING WS-IND-1 FROM 2 BY 1
            UNTIL WS-IND-1 > C-MAX-IND
       MOVE J-NODE(WS-COUNTRY(WS-IND-1)) TO WS-NODE-ID(WS-IND-1)
       MOVE J-ADDNODE(WS-NODE-ID(WS-NODE-PARENT-IND(WS-IND-1)), WS-NODE-ID(WS-IND-1)) TO WS-RET
    END-PERFORM

*>  create tree
    MOVE J-TREE(WS-SCROLLPANE-1, WS-NODE-ID(1)) TO WS-TREE
    
    MOVE J-SHOW(WS-FRAME) TO WS-RET

*>  Waiting for actions
    PERFORM FOREVER
       MOVE J-NEXTACTION() TO WS-OBJ
       IF WS-OBJ = WS-FRAME
       THEN
          EXIT PERFORM
       END-IF

       IF (WS-OBJ = WS-QUIT) OR (WS-OBJ = WS-FRAME)
       THEN
          EXIT PERFORM
       END-IF
       
       IF WS-OBJ = WS-ENABLE
       THEN
          IF J-GETSTATE(WS-ENABLE) = J-FALSE
          THEN
             MOVE J-DISABLEDOUBLECLICK(WS-TREE) TO WS-RET
          ELSE
             MOVE J-ENABLEDOUBLECLICK(WS-TREE)  TO WS-RET
          END-IF
       END-IF
       
       MOVE WS-OBJ TO WS-NODE-SEARCH
       PERFORM SEARCH-NODE-ID
       IF  V-NODE-FOUND-YES OF WS-NODE-SEARCH-FLAG
       AND V-LEAF-YES OF WS-LEAF-FLAG(WS-IND-1)
       THEN
          MOVE SPACES TO WS-TEXT
          STRING "Country: "                  
                 TRIM(WS-COUNTRY(WS-IND-1))   
                 "; Capital: "                
                 TRIM(WS-CAPITAL(WS-IND-1))   
                 "; Continent: "              
                 TRIM(WS-CONTINENT(WS-IND-1)) DELIMITED BY SIZE
            INTO WS-TEXT
          END-STRING       
          MOVE J-SETTEXT(WS-LABEL, WS-TEXT) TO WS-RET
       END-IF       
    END-PERFORM
    
    MOVE J-QUIT() TO WS-RET

    STOP RUN
    
    .
 MAIN-TREE4-EX.
    EXIT.
    
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
    
 END PROGRAM tree4.
