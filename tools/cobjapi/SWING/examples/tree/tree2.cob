*>******************************************************************************
*>  This file is part of cobjapi.
*>
*>  tree2.cob is free software: you can redistribute it and/or 
*>  modify it under the terms of the GNU Lesser General Public License as 
*>  published by the Free Software Foundation, either version 3 of the License,
*>  or (at your option) any later version.
*>
*>  tree2.cob is distributed in the hope that it will be useful, 
*>  but WITHOUT ANY WARRANTY; without even the implied warranty of 
*>  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
*>  See the GNU Lesser General Public License for more details.
*>
*>  You should have received a copy of the GNU Lesser General Public License 
*>  along with tree2.cob.
*>  If not, see <http://www.gnu.org/licenses/>.
*>******************************************************************************

*>******************************************************************************
*> Program:      tree2.cob
*>
*> Purpose:      Example GnuCOBOL program for JAPI
*>
*> Author:       Laszlo Erdos - https://www.facebook.com/wortfee
*>
*> Date-Written: 2020.10.03
*>
*> Tectonics:    Example for static link.
*>               cobc -x -free tree2.cob cobjapi.o \
*>                                       japilib.o \
*>                                       imageio.o \
*>                                       fileselect.o
*>
*> Usage:        ./tree2.exe
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
 PROGRAM-ID. tree2.

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
 01 WS-PANEL                           BINARY-LONG.
 01 WS-SCROLLPANE                      BINARY-LONG.
 01 WS-VSCROLL                         BINARY-LONG.
 01 WS-HSCROLL                         BINARY-LONG.
*> for tree
 01 WS-TREE                            BINARY-LONG.
 01 WS-ROOT-NODE                       BINARY-LONG.
 01 WS-NODE-1                          BINARY-LONG.
 01 WS-NODE-2                          BINARY-LONG.
 01 WS-NODE-11                         BINARY-LONG.
 01 WS-NODE-12                         BINARY-LONG.
 01 WS-NODE-21                         BINARY-LONG.
 01 WS-NODE-22                         BINARY-LONG.

*> RGB color
 01 WS-R                               BINARY-LONG.
 01 WS-G                               BINARY-LONG.
 01 WS-B                               BINARY-LONG.
  
*> function args 
 01 WS-DEBUG-LEVEL                     BINARY-LONG.

 PROCEDURE DIVISION.

*>------------------------------------------------------------------------------
 MAIN-TREE2 SECTION.
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
    MOVE J-FRAME("Tree2 Demo")  TO WS-FRAME  
    MOVE J-SETBORDERLAYOUT(WS-FRAME) TO WS-RET

    MOVE J-SCROLLPANE(WS-FRAME)      TO WS-SCROLLPANE
    MOVE J-VSCROLLBAR(WS-SCROLLPANE) TO WS-VSCROLL
    MOVE J-HSCROLLBAR(WS-SCROLLPANE) TO WS-HSCROLL
    
    MOVE J-PANEL(WS-SCROLLPANE) TO WS-PANEL

*>  create nodes and tree structure    
    MOVE J-NODE("Root")  TO WS-ROOT-NODE

    MOVE J-NODE("Node1") TO WS-NODE-1
    MOVE J-ADDNODE(WS-ROOT-NODE, WS-NODE-1) TO WS-RET
    MOVE J-NODE("Node2") TO WS-NODE-2
    MOVE J-ADDNODE(WS-ROOT-NODE, WS-NODE-2) TO WS-RET

    MOVE J-NODE("Node11") TO WS-NODE-11
    MOVE J-ADDNODE(WS-NODE-1, WS-NODE-11) TO WS-RET
    MOVE J-NODE("Node12") TO WS-NODE-12
    MOVE J-ADDNODE(WS-NODE-1, WS-NODE-12) TO WS-RET

    MOVE J-NODE("Node21") TO WS-NODE-21
    MOVE J-ADDNODE(WS-NODE-2, WS-NODE-21) TO WS-RET
    MOVE J-NODE("Node22") TO WS-NODE-22
    MOVE J-ADDNODE(WS-NODE-2, WS-NODE-22) TO WS-RET

*>  create tree
    MOVE J-TREE(WS-PANEL, WS-ROOT-NODE) TO WS-TREE

*>  try this also with named colors
*>*>  set tree colors with named colors
*>    MOVE J-SETNAMEDCOLOR(WS-TREE, J-ORANGE) TO WS-RET
*>    MOVE J-SETNAMEDCOLORBG(WS-TREE, J-LIGHT-GRAY) TO WS-RET
*>*>  selected node
*>    MOVE J-SETTREETEXTSELNAMEDCOLOR(WS-TREE, J-RED) TO WS-RET
*>    MOVE J-SETTREEBGSELNAMEDCOLOR(WS-TREE, J-WHITE) TO WS-RET
*>    MOVE J-SETTREEBORDERSELNAMEDCOLOR(WS-TREE, J-BLUE) TO WS-RET
*>*>  not selected nodes
*>    MOVE J-SETTREETEXTNONSELNAMEDCOLOR(WS-TREE, J-GREEN) TO WS-RET
*>    MOVE J-SETTREEBGNONSELNAMEDCOLOR(WS-TREE, J-LIGHT-GRAY) TO WS-RET

*>  set tree colors with RGB colors
    MOVE 255 TO WS-R  MOVE 127 TO WS-G  MOVE  68 TO WS-B
    MOVE J-SETCOLOR(WS-TREE, WS-R, WS-G, WS-B) TO WS-RET
    MOVE 107 TO WS-R  MOVE 127 TO WS-G  MOVE 117 TO WS-B
    MOVE J-SETCOLORBG(WS-TREE, WS-R, WS-G, WS-B) TO WS-RET
*>  selected node
    MOVE 255 TO WS-R  MOVE 127 TO WS-G  MOVE 127 TO WS-B
    MOVE J-SETTREETEXTSELCOLOR(WS-TREE, WS-R, WS-G, WS-B) TO WS-RET
    MOVE 216 TO WS-R  MOVE 255 TO WS-G  MOVE 230 TO WS-B
    MOVE J-SETTREEBGSELCOLOR(WS-TREE, WS-R, WS-G, WS-B) TO WS-RET
    MOVE  50 TO WS-R  MOVE 135 TO WS-G  MOVE 255 TO WS-B
    MOVE J-SETTREEBORDERSELCOLOR(WS-TREE, WS-R, WS-G, WS-B) TO WS-RET
*>  not selected nodes
    MOVE 147 TO WS-R  MOVE 255 TO WS-G  MOVE 203 TO WS-B
    MOVE J-SETTREETEXTNONSELCOLOR(WS-TREE, WS-R, WS-G, WS-B) TO WS-RET
    MOVE 192 TO WS-R  MOVE 192 TO WS-G  MOVE 192 TO WS-B
    MOVE J-SETTREEBGNONSELCOLOR(WS-TREE, WS-R, WS-G, WS-B) TO WS-RET
    
    MOVE J-SHOW(WS-FRAME) TO WS-RET

*>  Waiting for actions
    PERFORM FOREVER
       MOVE J-NEXTACTION() TO WS-OBJ
       IF WS-OBJ = WS-FRAME
       THEN
          EXIT PERFORM
       END-IF
       
       EVALUATE WS-OBJ 
       WHEN WS-ROOT-NODE
          DISPLAY "Root-Node event"
       WHEN WS-NODE-1
          DISPLAY "Node-1 event"
       WHEN WS-NODE-2
          DISPLAY "Node-2 event"
       WHEN WS-NODE-11
          DISPLAY "Node-11 event"
       WHEN WS-NODE-12
          DISPLAY "Node-12 event"
       WHEN WS-NODE-21
          DISPLAY "Node-21 event"
       WHEN WS-NODE-22
          DISPLAY "Node-22 event"
       END-EVALUATE
       
    END-PERFORM
    
    MOVE J-QUIT() TO WS-RET

    STOP RUN
    
    .
 MAIN-TREE2-EX.
    EXIT.
 END PROGRAM tree2.
