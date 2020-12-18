*>******************************************************************************
*>  This file is part of cobjapi.
*>
*>  tree3.cob is free software: you can redistribute it and/or 
*>  modify it under the terms of the GNU Lesser General Public License as 
*>  published by the Free Software Foundation, either version 3 of the License,
*>  or (at your option) any later version.
*>
*>  tree3.cob is distributed in the hope that it will be useful, 
*>  but WITHOUT ANY WARRANTY; without even the implied warranty of 
*>  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
*>  See the GNU Lesser General Public License for more details.
*>
*>  You should have received a copy of the GNU Lesser General Public License 
*>  along with tree3.cob.
*>  If not, see <http://www.gnu.org/licenses/>.
*>******************************************************************************

*>******************************************************************************
*> Program:      tree3.cob
*>
*> Purpose:      Example GnuCOBOL program for JAPI
*>
*> Author:       Laszlo Erdos - https://www.facebook.com/wortfee
*>
*> Date-Written: 2020.10.03
*>
*> Tectonics:    Example for static link.
*>               cobc -x -free tree3.cob cobjapi.o \
*>                                       japilib.o \
*>                                       imageio.o \
*>                                       fileselect.o
*>
*> Usage:        ./tree3.exe
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
 PROGRAM-ID. tree3.

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
 
 01 C-MAX-IND                          CONSTANT AS 7.
 01 WS-NODES.
*> 01 
  02 FILLER                            PIC 9(4) VALUE 0.
  02 FILLER                            BINARY-LONG.
  02 FILLER                            PIC 9(1) VALUE 0.
  02 FILLER                            PIC X(256) 
     VALUE "Root".
*> 02 
  02 FILLER                            PIC 9(4) VALUE 1.
  02 FILLER                            BINARY-LONG.
  02 FILLER                            PIC 9(1) VALUE 0.
  02 FILLER                            PIC X(256) 
     VALUE "Node1".
*> 03 
  02 FILLER                            PIC 9(4) VALUE 1.
  02 FILLER                            BINARY-LONG.
  02 FILLER                            PIC 9(1) VALUE 0.
  02 FILLER                            PIC X(256) 
     VALUE "Node2".
*> 04 
  02 FILLER                            PIC 9(4) VALUE 2.
  02 FILLER                            BINARY-LONG.
  02 FILLER                            PIC 9(1) VALUE 1.
  02 FILLER                            PIC X(256) 
     VALUE "Node11".
*> 05 
  02 FILLER                            PIC 9(4) VALUE 2.
  02 FILLER                            BINARY-LONG.
  02 FILLER                            PIC 9(1) VALUE 1.
  02 FILLER                            PIC X(256) 
     VALUE "Node12".
*> 06 
  02 FILLER                            PIC 9(4) VALUE 3.
  02 FILLER                            BINARY-LONG.
  02 FILLER                            PIC 9(1) VALUE 1.
  02 FILLER                            PIC X(256) 
     VALUE "Node21".
*> 07 
  02 FILLER                            PIC 9(4) VALUE 3.
  02 FILLER                            BINARY-LONG.
  02 FILLER                            PIC 9(1) VALUE 1.
  02 FILLER                            PIC X(256) 
     VALUE "Node22".
 01 WS-NODES-R REDEFINES WS-NODES.
  02 WS-NODES-LINES OCCURS C-MAX-IND TIMES.
   03 WS-NODE-PARENT-IND               PIC 9(4).
   03 WS-NODE-ID                       BINARY-LONG.
   03 WS-LEAF-FLAG                     PIC 9(1).
      88 V-LEAF-NO                     VALUE 0.
      88 V-LEAF-YES                    VALUE 1.
   03 WS-NODE-TITLE                    PIC X(256).

*> function args 
 01 WS-DEBUG-LEVEL                     BINARY-LONG.
 01 WS-POS                             BINARY-LONG.

 PROCEDURE DIVISION.

*>------------------------------------------------------------------------------
 MAIN-TREE3 SECTION.
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
    MOVE J-FRAME("Tree3 Demo")  TO WS-FRAME  
    MOVE J-SETBORDERLAYOUT(WS-FRAME) TO WS-RET
    
    MOVE 142 TO WS-POS
    MOVE J-SPLITPANE(WS-FRAME, J-HORIZONTAL, WS-POS) TO WS-SP
    MOVE J-SETBORDERPOS(WS-SP, J-CENTER) TO WS-RET
    
    MOVE J-PANEL(WS-SP) TO WS-PANEL-1
    MOVE J-PANEL(WS-SP) TO WS-PANEL-2
    MOVE J-LABEL(WS-PANEL-2, "Right Panel") TO WS-LABEL
    
    MOVE J-SETSPLITPANELEFT(WS-SP, WS-PANEL-1)  TO WS-RET
    MOVE J-SETSPLITPANERIGHT(WS-SP, WS-PANEL-2) TO WS-RET

*>  create root node
    MOVE J-NODE(WS-NODE-TITLE(1)) TO WS-NODE-ID(1)
 
*>  create nodes and tree structure    
    PERFORM VARYING WS-IND-1 FROM 2 BY 1
            UNTIL WS-IND-1 > C-MAX-IND
       MOVE J-NODE(WS-NODE-TITLE(WS-IND-1)) TO WS-NODE-ID(WS-IND-1)
       MOVE J-ADDNODE(WS-NODE-ID(WS-NODE-PARENT-IND(WS-IND-1)), WS-NODE-ID(WS-IND-1)) TO WS-RET
    END-PERFORM

*>  create tree
    MOVE J-TREE(WS-PANEL-1, WS-NODE-ID(1)) TO WS-TREE
    
    MOVE J-SHOW(WS-FRAME) TO WS-RET

*>  Waiting for actions
    PERFORM FOREVER
       MOVE J-NEXTACTION() TO WS-OBJ
       IF WS-OBJ = WS-FRAME
       THEN
          EXIT PERFORM
       END-IF
       
       MOVE WS-OBJ TO WS-NODE-SEARCH
       PERFORM SEARCH-NODE-ID
       IF  V-NODE-FOUND-YES OF WS-NODE-SEARCH-FLAG
       AND V-LEAF-YES OF WS-LEAF-FLAG(WS-IND-1)
       THEN
          DISPLAY "NODE-PARENT-IND: " WS-NODE-PARENT-IND(WS-IND-1)
          DISPLAY "NODE-ID        : " WS-NODE-ID(WS-IND-1)
          DISPLAY "NODE-TITLE     : " WS-NODE-TITLE(WS-IND-1)
       END-IF       
    END-PERFORM
    
    MOVE J-QUIT() TO WS-RET

    STOP RUN
    
    .
 MAIN-TREE3-EX.
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
    
 END PROGRAM tree3.
