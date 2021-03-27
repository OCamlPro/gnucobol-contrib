*>******************************************************************************
*>  This file is part of cobjapi.
*>
*>  table3.cob is free software: you can redistribute it and/or 
*>  modify it under the terms of the GNU Lesser General Public License as 
*>  published by the Free Software Foundation, either version 3 of the License,
*>  or (at your option) any later version.
*>
*>  table3.cob is distributed in the hope that it will be useful, 
*>  but WITHOUT ANY WARRANTY; without even the implied warranty of 
*>  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
*>  See the GNU Lesser General Public License for more details.
*>
*>  You should have received a copy of the GNU Lesser General Public License 
*>  along with table3.cob.
*>  If not, see <http://www.gnu.org/licenses/>.
*>******************************************************************************

*>******************************************************************************
*> Program:      table3.cob
*>
*> Purpose:      Example GnuCOBOL program for JAPI
*>
*> Author:       Laszlo Erdos - https://www.facebook.com/wortfee
*>
*> Date-Written: 2020.12.30
*>
*> Tectonics:    Example for static link.
*>               cobc -x -free table3.cob cobjapi.o \
*>                                        japilib.o \
*>                                        imageio.o \
*>                                        fileselect.o
*>
*> Usage:        ./table3.exe
*>
*>******************************************************************************
*> Date       Name / Change description 
*> ========== ==================================================================
*> 2003.02.26 This comment is only for History. The latest Version (V1.0.6) of 
*>            JAPI was released on 02/26/2003. Homepage: http://www.japi.de 
*>------------------------------------------------------------------------------
*> 2020.12.30 Laszlo Erdos: 
*>            - button.cob converted into table3.cob. 
*>******************************************************************************

 IDENTIFICATION DIVISION.
 PROGRAM-ID. table3.

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
 01 WS-BUTTON-3                        BINARY-LONG.
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
 01 WS-MSEC                            BINARY-LONG.

*> vars
 01 WS-TEXT                            PIC X(50).
 01 WS-ROW-TEXT                        PIC X(140).
 01 WS-SELECTED-ROW                    PIC Z(9)9(1).
 01 WS-IND-1                           PIC 9(4). 
 
*> table column names and widths, the separator is "|" 
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
 01 WS-COLUMN-WIDTHS.
   02 FILLER                           VALUE "85".
   02 FILLER                           VALUE "|".
   02 FILLER                           VALUE "160".
   02 FILLER                           VALUE "|".
   02 FILLER                           VALUE "230".
   02 FILLER                           VALUE "|".
   02 FILLER                           VALUE "65".
   02 FILLER                           VALUE "|".
   02 FILLER                           VALUE "50".

*> table rows, the separator is "|". Do not use this separator in data!
 COPY "tableBooks.cpy".
 
 PROCEDURE DIVISION.

*>------------------------------------------------------------------------------
 MAIN-TABLE3 SECTION.
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
    MOVE J-FRAME("Table3 Demo")               TO WS-FRAME  
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
    MOVE J-BUTTON(WS-PANEL-1, "Set column widths") TO WS-BUTTON-3

    MOVE J-PANEL(WS-PANEL-2)                       TO WS-PANEL-TABLE
    MOVE 600 TO WS-WIDTH
    MOVE 200 TO WS-HEIGHT
    MOVE J-SETSIZE(WS-PANEL-TABLE, WS-WIDTH, WS-HEIGHT) TO WS-RET
    MOVE J-TABLE(WS-PANEL-TABLE, WS-COLUMN-NAMES)       TO WS-TABLE

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
*>        first clear the table data
          MOVE J-CLEARTABLE(WS-TABLE) TO WS-RET

          PERFORM VARYING WS-IND-1 FROM 1 BY 1
                  UNTIL WS-IND-1 > C-MAX-IND
             INITIALIZE WS-ROW-TEXT
             STRING WS-ISBN(WS-IND-1) 
                    "|"
                    TRIM(WS-AUTHORS(WS-IND-1))
                    "|"
                    TRIM(WS-TITLE(WS-IND-1))
                    "|"
                    WS-PUB-DATE(WS-IND-1)
                    "|"
                    WS-PAGE-NR(WS-IND-1) DELIMITED BY SIZE
               INTO WS-ROW-TEXT
             END-STRING  
             MOVE J-ADDROW(WS-TABLE, WS-ROW-TEXT) TO WS-RET
          END-PERFORM
       END-IF

       IF WS-OBJ = WS-BUTTON-2
       THEN
          MOVE J-CLEARTABLE(WS-TABLE) TO WS-RET
       END-IF

       IF WS-OBJ = WS-BUTTON-3
       THEN
          MOVE J-SETCOLUMNWIDTHS(WS-TABLE, WS-COLUMN-WIDTHS) TO WS-RET
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

             ADD 1 TO WS-ITEM END-ADD
             INITIALIZE WS-ROW-TEXT
             STRING WS-ISBN(WS-ITEM) X"0A"
                    TRIM(WS-AUTHORS(WS-ITEM)) X"0A"
                    TRIM(WS-TITLE(WS-ITEM)) X"0A"
                    WS-PUB-DATE(WS-ITEM) X"0A"
                    WS-PAGE-NR(WS-ITEM) DELIMITED BY SIZE
               INTO WS-ROW-TEXT
             END-STRING  
             MOVE J-ALERTBOX(WS-FRAME, "Selected row data from COBOL table",
                  WS-ROW-TEXT, "OK") TO WS-RET                    
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
 MAIN-TABLE3-EX.
    EXIT.
    
 END PROGRAM table3.
