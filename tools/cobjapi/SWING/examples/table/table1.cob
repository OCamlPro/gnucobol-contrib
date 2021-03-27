*>******************************************************************************
*>  This file is part of cobjapi.
*>
*>  table1.cob is free software: you can redistribute it and/or 
*>  modify it under the terms of the GNU Lesser General Public License as 
*>  published by the Free Software Foundation, either version 3 of the License,
*>  or (at your option) any later version.
*>
*>  table1.cob is distributed in the hope that it will be useful, 
*>  but WITHOUT ANY WARRANTY; without even the implied warranty of 
*>  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
*>  See the GNU Lesser General Public License for more details.
*>
*>  You should have received a copy of the GNU Lesser General Public License 
*>  along with table1.cob.
*>  If not, see <http://www.gnu.org/licenses/>.
*>******************************************************************************

*>******************************************************************************
*> Program:      table1.cob
*>
*> Purpose:      Example GnuCOBOL program for JAPI
*>
*> Author:       Laszlo Erdos - https://www.facebook.com/wortfee
*>
*> Date-Written: 2020.12.30
*>
*> Tectonics:    Example for static link.
*>               cobc -x -free table1.cob cobjapi.o \
*>                                        japilib.o \
*>                                        imageio.o \
*>                                        fileselect.o
*>
*> Usage:        ./table1.exe
*>
*>******************************************************************************
*> Date       Name / Change description 
*> ========== ==================================================================
*> 2003.02.26 This comment is only for History. The latest Version (V1.0.6) of 
*>            JAPI was released on 02/26/2003. Homepage: http://www.japi.de 
*>------------------------------------------------------------------------------
*> 2020.12.30 Laszlo Erdos: 
*>            - button.cob converted into table1.cob. 
*>******************************************************************************

 IDENTIFICATION DIVISION.
 PROGRAM-ID. table1.

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
 01 WS-TABLE                           BINARY-LONG.
 01 WS-LABEL                           BINARY-LONG.
 01 WS-OBJ                             BINARY-LONG.
 
*> function args 
 01 WS-DEBUG-LEVEL                     BINARY-LONG.
 01 WS-WIDTH                           BINARY-LONG.
 01 WS-HEIGHT                          BINARY-LONG.
 01 WS-XPOS                            BINARY-LONG.
 01 WS-YPOS                            BINARY-LONG.
 01 WS-ITEM                            BINARY-LONG.
 
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
 MAIN-TABLE1 SECTION.
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
    MOVE J-FRAME("Table1 Demo")         TO WS-FRAME  
                                       
    MOVE J-MENUBAR(WS-FRAME)            TO WS-MENUBAR
    MOVE J-MENU(WS-MENUBAR, "File")     TO WS-FILE
    MOVE J-MENUITEM(WS-FILE, "Quit")    TO WS-QUIT

    MOVE J-PANEL(WS-FRAME)              TO WS-PANEL

    MOVE 100 TO WS-XPOS
    MOVE  30 TO WS-YPOS
    MOVE J-SETPOS(WS-PANEL, WS-XPOS, WS-YPOS)     TO WS-RET
    MOVE 500 TO WS-WIDTH
    MOVE 200 TO WS-HEIGHT
    MOVE J-SETSIZE(WS-PANEL, WS-WIDTH, WS-HEIGHT) TO WS-RET

    MOVE J-TABLE(WS-PANEL, WS-COLUMN-NAMES)       TO WS-TABLE
    MOVE J-ADDROW(WS-TABLE, WS-ROW-1)             TO WS-RET
    MOVE J-ADDROW(WS-TABLE, WS-ROW-2)             TO WS-RET
    MOVE J-ADDROW(WS-TABLE, WS-ROW-3)             TO WS-RET

    MOVE J-LABEL(WS-FRAME, "Double click on a row!") TO WS-LABEL
    MOVE 100 TO WS-XPOS
    MOVE 300 TO WS-YPOS
    MOVE J-SETPOS(WS-LABEL, WS-XPOS, WS-YPOS)     TO WS-RET

    MOVE 800 TO WS-WIDTH
    MOVE 600 TO WS-HEIGHT
    MOVE J-SETSIZE(WS-FRAME, WS-WIDTH, WS-HEIGHT) TO WS-RET
    
    MOVE J-SHOW(WS-FRAME) TO WS-RET

*>  Waiting for actions
    PERFORM FOREVER
       MOVE J-NEXTACTION() TO WS-OBJ

       IF WS-OBJ = WS-TABLE
       THEN
          MOVE J-GETSELECT(WS-TABLE) TO WS-ITEM
*>        We can get -1 back, if no row selected
          IF WS-ITEM >= 0
          THEN
             DISPLAY "Selected Row: " WS-ITEM
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
 MAIN-TABLE1-EX.
    EXIT.
 END PROGRAM table1.
