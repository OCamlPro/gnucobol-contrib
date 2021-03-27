*>******************************************************************************
*>  This file is part of cobjapi.
*>
*>  table2.cob is free software: you can redistribute it and/or 
*>  modify it under the terms of the GNU Lesser General Public License as 
*>  published by the Free Software Foundation, either version 3 of the License,
*>  or (at your option) any later version.
*>
*>  table2.cob is distributed in the hope that it will be useful, 
*>  but WITHOUT ANY WARRANTY; without even the implied warranty of 
*>  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
*>  See the GNU Lesser General Public License for more details.
*>
*>  You should have received a copy of the GNU Lesser General Public License 
*>  along with table2.cob.
*>  If not, see <http://www.gnu.org/licenses/>.
*>******************************************************************************

*>******************************************************************************
*> Program:      table2.cob
*>
*> Purpose:      Example GnuCOBOL program for JAPI
*>
*> Author:       Laszlo Erdos - https://www.facebook.com/wortfee
*>
*> Date-Written: 2020.12.30
*>
*> Tectonics:    Example for static link.
*>               cobc -x -free table2.cob cobjapi.o \
*>                                        japilib.o \
*>                                        imageio.o \
*>                                        fileselect.o
*>
*> Usage:        ./table2.exe
*>
*>******************************************************************************
*> Date       Name / Change description 
*> ========== ==================================================================
*> 2003.02.26 This comment is only for History. The latest Version (V1.0.6) of 
*>            JAPI was released on 02/26/2003. Homepage: http://www.japi.de 
*>------------------------------------------------------------------------------
*> 2020.12.30 Laszlo Erdos: 
*>            - button.cob converted into table2.cob. 
*>******************************************************************************

 IDENTIFICATION DIVISION.
 PROGRAM-ID. table2.

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
 01 WS-BUTTON-1                        BINARY-LONG.
 01 WS-BUTTON-2                        BINARY-LONG.
 01 WS-PANEL-1                         BINARY-LONG.
 01 WS-PANEL-2                         BINARY-LONG.
 01 WS-PANEL-3                         BINARY-LONG.
 01 WS-PANEL-TABLE                     BINARY-LONG.
 01 WS-LABEL-1                         BINARY-LONG.
 01 WS-LABEL-2                         BINARY-LONG.
 01 WS-TABLE                           BINARY-LONG.
 01 WS-OBJ                             BINARY-LONG.
 
*> function args 
 01 WS-DEBUG-LEVEL                     BINARY-LONG.
 01 WS-WIDTH                           BINARY-LONG.
 01 WS-HEIGHT                          BINARY-LONG.
 01 WS-HGAP                            BINARY-LONG.
 01 WS-VGAP                            BINARY-LONG.
 01 WS-TOP                             BINARY-LONG.
 01 WS-BOTTOM                          BINARY-LONG.
 01 WS-LEFT                            BINARY-LONG.
 01 WS-RIGHT                           BINARY-LONG.
 01 WS-ITEM                            BINARY-LONG.

*> RGB color
 01 WS-R                               BINARY-LONG.
 01 WS-G                               BINARY-LONG.
 01 WS-B                               BINARY-LONG.

*> vars
 01 WS-TEXT                            PIC X(50).
 01 WS-SELECTED-ROW                    PIC Z(9)9(1).
 
*> table column names, the separator is "|" 
 01 WS-COLUMN-NAMES.
   02 FILLER                           VALUE "ISBN".
   02 FILLER                           VALUE "|".
   02 FILLER                           VALUE "Author".
   02 FILLER                           VALUE "|".
   02 FILLER                           VALUE "Title".
   02 FILLER                           VALUE "|".
   02 FILLER                           VALUE "Publish date".
   02 FILLER                           VALUE "|".
   02 FILLER                           VALUE "Page Nr.".

*> table rows, the separator is "|". Do not use this separator in data!
 01 WS-ROW-1.
   02 FILLER VALUE "9780345391803".
   02 FILLER VALUE "|".
   02 FILLER VALUE "Douglas Adams".
   02 FILLER VALUE "|".
   02 FILLER VALUE "The Hitchhikers Guide to the Galaxy (Book 1)".
   02 FILLER VALUE "|".
   02 FILLER VALUE "1995-09-27".
   02 FILLER VALUE "|".
   02 FILLER VALUE "224".

 01 WS-ROW-2.
   02 FILLER VALUE "9780672314537".
   02 FILLER VALUE "|".
   02 FILLER VALUE "Thane Hubbell".
   02 FILLER VALUE "|".
   02 FILLER VALUE "Sams Teach Yourself COBOL in 24 Hours, w. CD-ROM".
   02 FILLER VALUE "|".
   02 FILLER VALUE "1998-12-24".
   02 FILLER VALUE "|".
   02 FILLER VALUE "496".
   
 01 WS-ROW-3.
   02 FILLER VALUE "9781890774028".
   02 FILLER VALUE "|".
   02 FILLER VALUE "Steve Eckols, Curtis Garvin".
   02 FILLER VALUE "|".
   02 FILLER VALUE "DB2 for the Cobol Programmer".
   02 FILLER VALUE "|".
   02 FILLER VALUE "1998-11-01".
   02 FILLER VALUE "|".
   02 FILLER VALUE "431".
 
 
 PROCEDURE DIVISION.

*>------------------------------------------------------------------------------
 MAIN-TABLE2 SECTION.
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
    MOVE J-FRAME("Table2 Demo")               TO WS-FRAME  
    MOVE J-SETBORDERLAYOUT(WS-FRAME)          TO WS-RET
    MOVE 10 TO WS-HGAP
    MOVE J-SETHGAP(WS-FRAME, WS-HGAP)         TO WS-RET    
    MOVE 10 TO WS-VGAP
    MOVE J-SETVGAP(WS-FRAME, WS-VGAP)         TO WS-RET    
                                       
    MOVE J-MENUBAR(WS-FRAME)                  TO WS-MENUBAR
    MOVE J-MENU(WS-MENUBAR, "File")           TO WS-FILE
    MOVE J-MENUITEM(WS-FILE, "Quit")          TO WS-QUIT
                                              
    MOVE J-PANEL(WS-FRAME, "TOP")             TO WS-PANEL-1
    MOVE J-PANEL(WS-FRAME, "CENTER")          TO WS-PANEL-2
    MOVE J-PANEL(WS-FRAME, "BOTTOM")          TO WS-PANEL-3
    MOVE J-SETBORDERPOS(WS-PANEL-1, J-TOP)    TO WS-RET
    MOVE J-SETBORDERPOS(WS-PANEL-2, J-CENTER) TO WS-RET
    MOVE J-SETBORDERPOS(WS-PANEL-3, J-BOTTOM) TO WS-RET
    MOVE 10 TO WS-TOP
    MOVE 10 TO WS-BOTTOM
    MOVE 10 TO WS-LEFT
    MOVE 10 TO WS-RIGHT
    MOVE J-SETINSETS(WS-PANEL-1, WS-TOP, WS-BOTTOM, WS-LEFT, WS-RIGHT) TO WS-RET
    MOVE J-SETINSETS(WS-PANEL-2, WS-TOP, WS-BOTTOM, WS-LEFT, WS-RIGHT) TO WS-RET
    MOVE J-SETINSETS(WS-PANEL-3, WS-TOP, WS-BOTTOM, WS-LEFT, WS-RIGHT) TO WS-RET

    MOVE J-SETFLOWLAYOUT(WS-PANEL-1, J-HORIZONTAL) TO WS-RET        
    MOVE J-SETFLOWLAYOUT(WS-PANEL-2, J-HORIZONTAL) TO WS-RET        
    MOVE J-SETFLOWLAYOUT(WS-PANEL-3, J-HORIZONTAL) TO WS-RET        

    MOVE J-BUTTON(WS-PANEL-1, "Add data")          TO WS-BUTTON-1
    MOVE J-BUTTON(WS-PANEL-1, "Clear data")        TO WS-BUTTON-2

    MOVE J-PANEL(WS-PANEL-2)                       TO WS-PANEL-TABLE
    MOVE 600 TO WS-WIDTH
    MOVE 200 TO WS-HEIGHT
    MOVE J-SETSIZE(WS-PANEL-TABLE, WS-WIDTH, WS-HEIGHT) TO WS-RET
    MOVE J-TABLE(WS-PANEL-TABLE, WS-COLUMN-NAMES)       TO WS-TABLE

*>  set table colors with named colors
    MOVE J-SETNAMEDCOLOR(WS-TABLE, J-BLUE) TO WS-RET
    MOVE J-SETNAMEDCOLORBG(WS-TABLE, J-LIGHT-GRAY) TO WS-RET

    MOVE J-SETGRIDNAMEDCOLOR(WS-TABLE, J-RED) TO WS-RET

    MOVE J-SETHEADERNAMEDCOLOR(WS-TABLE, J-GREEN) TO WS-RET
*>    MOVE J-SETHEADERNAMEDCOLORBG(WS-TABLE, J-YELLOW) TO WS-RET

*>  try this also with RGB colors
*>  set table colors with RGB colors
*>    MOVE 255 TO WS-R  MOVE 127 TO WS-G  MOVE  68 TO WS-B
*>    MOVE J-SETCOLOR(WS-TABLE, WS-R, WS-G, WS-B) TO WS-RET
*>    MOVE 107 TO WS-R  MOVE 127 TO WS-G  MOVE 117 TO WS-B
*>    MOVE J-SETCOLORBG(WS-TABLE, WS-R, WS-G, WS-B) TO WS-RET
*>
*>    MOVE 107 TO WS-R  MOVE 127 TO WS-G  MOVE 117 TO WS-B
*>    MOVE J-SETGRIDCOLOR(WS-TABLE, WS-R, WS-G, WS-B) TO WS-RET
*>
*>    MOVE 255 TO WS-R  MOVE 127 TO WS-G  MOVE  68 TO WS-B
*>    MOVE J-SETHEADERCOLOR(WS-TABLE, WS-R, WS-G, WS-B) TO WS-RET
*>    MOVE 107 TO WS-R  MOVE 127 TO WS-G  MOVE 117 TO WS-B
*>    MOVE J-SETHEADERCOLORBG(WS-TABLE, WS-R, WS-G, WS-B) TO WS-RET

    MOVE J-LABEL(WS-PANEL-3, "Double click on a row!")  TO WS-LABEL-1
    MOVE J-LABEL(WS-PANEL-3, "Selected row: ")          TO WS-LABEL-2

    MOVE 800 TO WS-WIDTH
    MOVE 600 TO WS-HEIGHT
    MOVE J-SETSIZE(WS-FRAME, WS-WIDTH, WS-HEIGHT) TO WS-RET

    MOVE J-SHOW(WS-FRAME) TO WS-RET

*>  Waiting for actions
    PERFORM FOREVER
       MOVE J-NEXTACTION() TO WS-OBJ

       IF WS-OBJ = WS-BUTTON-1
       THEN
          MOVE J-ADDROW(WS-TABLE, WS-ROW-1) TO WS-RET
          MOVE J-ADDROW(WS-TABLE, WS-ROW-2) TO WS-RET
          MOVE J-ADDROW(WS-TABLE, WS-ROW-3) TO WS-RET
       END-IF

       IF WS-OBJ = WS-BUTTON-2
       THEN
          MOVE J-CLEARTABLE(WS-TABLE) TO WS-RET
       END-IF

       IF WS-OBJ = WS-TABLE
       THEN
          MOVE J-GETSELECT(WS-TABLE) TO WS-ITEM
*>        We can get -1 back, if no row selected
          IF WS-ITEM >= 0
          THEN
             MOVE WS-ITEM TO WS-SELECTED-ROW
             INITIALIZE WS-TEXT
             STRING "Selected row: " 
                    WS-SELECTED-ROW DELIMITED BY SIZE
               INTO WS-TEXT
             END-STRING  
             MOVE J-SETTEXT(WS-LABEL-2, WS-TEXT) TO WS-RET
          END-IF   
       END-IF

       IF (WS-OBJ = WS-QUIT) OR (WS-OBJ = WS-FRAME)
       THEN
          EXIT PERFORM
       END-IF
    END-PERFORM
    
    MOVE J-QUIT() TO WS-RET

    STOP RUN
    
    .
 MAIN-TABLE2-EX.
    EXIT.
 END PROGRAM table2.
