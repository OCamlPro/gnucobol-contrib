*>******************************************************************************
*>  This file is part of cobjapi.
*>
*>  texteditor.cob is free software: you can redistribute it and/or 
*>  modify it under the terms of the GNU Lesser General Public License as 
*>  published by the Free Software Foundation, either version 3 of the License,
*>  or (at your option) any later version.
*>
*>  texteditor.cob is distributed in the hope that it will be useful, 
*>  but WITHOUT ANY WARRANTY; without even the implied warranty of 
*>  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
*>  See the GNU Lesser General Public License for more details.
*>
*>  You should have received a copy of the GNU Lesser General Public License 
*>  along with texteditor.cob.
*>  If not, see <http://www.gnu.org/licenses/>.
*>******************************************************************************

*>******************************************************************************
*> Program:      texteditor.cob
*>
*> Purpose:      Example GnuCOBOL program for JAPI
*>
*> Author:       Laszlo Erdos - https://www.facebook.com/wortfee
*>
*> Date-Written: 2014.12.24
*>
*> Tectonics:    Example for static link.
*>               cobc -x -free texteditor.cob cobjapi.o \
*>                                            japilib.o \
*>                                            imageio.o \
*>                                            fileselect.o
*>
*> Usage:        ./texteditor.exe
*>
*>******************************************************************************
*> Date       Name / Change description 
*> ========== ==================================================================
*> 2003.02.26 This comment is only for History. The latest Version (V1.0.6) of 
*>            JAPI was released on 02/26/2003. Homepage: http://www.japi.de 
*>------------------------------------------------------------------------------
*> 2014.12.24 Laszlo Erdos: 
*>            - GnuCOBOL support for JAPI added. 
*>            - text.c converted into texteditor.cob. 
*>******************************************************************************

 IDENTIFICATION DIVISION.
 PROGRAM-ID. texteditor.
 AUTHOR.     Laszlo Erdos.

 ENVIRONMENT DIVISION.
 CONFIGURATION SECTION.
 REPOSITORY.
*> Functions for the cobjapi wrapper 
 COPY "cobjapifn.cpy".

 DATA DIVISION.

 WORKING-STORAGE SECTION.
*> Constants for the cobjapi wrapper 
 COPY "cobjapi.cpy".
 
*> function return value 
 01 WS-RET                             BINARY-INT.

*> GUI elements
 01 WS-FRAME                           BINARY-INT.
 01 WS-PANEL                           BINARY-INT.
 01 WS-MENUBAR                         BINARY-INT.
 01 WS-FILE                            BINARY-INT.
 01 WS-NEW                             BINARY-INT.
 01 WS-SAVE                            BINARY-INT.
 01 WS-QUIT                            BINARY-INT.
 01 WS-EDIT                            BINARY-INT.
 01 WS-SELALL                          BINARY-INT.
 01 WS-CUT                             BINARY-INT.
 01 WS-COPY                            BINARY-INT.
 01 WS-PASTE                           BINARY-INT.
 01 WS-TEXT                            BINARY-INT.
 01 WS-OBJ                             BINARY-INT.
 
*> function args 
 01 WS-DEBUG-LEVEL                     BINARY-INT.
 01 WS-SELSTART                        BINARY-INT VALUE 0.
 01 WS-SELEND                          BINARY-INT VALUE 0.
 01 WS-ROW                             BINARY-INT.
 01 WS-COL                             BINARY-INT.
 01 WS-FONTSIZE                        BINARY-INT.
 01 WS-XPOS                            BINARY-INT.
 01 WS-YPOS                            BINARY-INT.
 
 01 WS-NEWTEXT                         PIC X(256) VALUE
    "JAPI (Java Application"   & X"0A" &
    "Programming Interface)"   & X"0A" &
    "a platform and language"  & X"0A" &
    "independent API".

*> 65536 = 2 ** 16  
 01 WS-CONTENT                         PIC X(65536).

 
 PROCEDURE DIVISION.

*>------------------------------------------------------------------------------
 MAIN-TEXTEDITOR SECTION.
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
    MOVE J-FRAME("A simple editor") TO WS-FRAME  
	MOVE 1 TO WS-ROW
    MOVE 1 TO WS-COL
    MOVE J-SETGRIDLAYOUT(WS-FRAME, WS-ROW, WS-COL) TO WS-RET
    MOVE J-PANEL(WS-FRAME) TO WS-PANEL
	MOVE 1 TO WS-ROW
    MOVE 1 TO WS-COL
    MOVE J-SETGRIDLAYOUT(WS-PANEL, WS-ROW, WS-COL) TO WS-RET
    
    MOVE J-MENUBAR(WS-FRAME)               TO WS-MENUBAR
    MOVE J-MENU(WS-MENUBAR, "File")        TO WS-FILE
    MOVE J-MENUITEM(WS-FILE, "New")        TO WS-NEW
    MOVE J-MENUITEM(WS-FILE, "Save")       TO WS-SAVE
    MOVE J-SEPERATOR(WS-FILE)              TO WS-RET
    MOVE J-MENUITEM(WS-FILE, "Quit")       TO WS-QUIT

    MOVE J-MENU(WS-MENUBAR, "Edit")        TO WS-EDIT
    MOVE J-MENUITEM(WS-EDIT, "Select All") TO WS-SELALL
    MOVE J-SEPERATOR(WS-EDIT)              TO WS-RET
    MOVE J-MENUITEM(WS-EDIT, "Cut")        TO WS-CUT
    MOVE J-MENUITEM(WS-EDIT, "Copy")       TO WS-COPY
    MOVE J-MENUITEM(WS-EDIT, "Paste")      TO WS-PASTE

    MOVE  4 TO WS-ROW                      
    MOVE 15 TO WS-COL                      
    MOVE J-TEXTAREA(WS-PANEL, WS-ROW, WS-COL) TO WS-TEXT
    MOVE 18 TO WS-FONTSIZE    
    MOVE J-SETFONT(WS-TEXT, J-DIALOGIN, J-BOLD, WS-FONTSIZE) TO WS-RET
    MOVE 10 TO WS-XPOS
    MOVE 60 TO WS-YPOS
    MOVE J-SETPOS(WS-TEXT, WS-XPOS, WS-YPOS) TO WS-RET
    MOVE J-SETTEXT(WS-TEXT, WS-NEWTEXT)      TO WS-RET
    
    MOVE J-SHOW(WS-FRAME) TO WS-RET
    MOVE J-PACK(WS-FRAME) TO WS-RET

    MOVE  4 TO WS-ROW
    MOVE J-SETROWS(WS-TEXT, WS-ROW)    TO WS-RET
    MOVE 15 TO WS-COL
    MOVE J-SETCOLUMNS(WS-TEXT, WS-COL) TO WS-RET
    MOVE J-PACK(WS-FRAME) TO WS-RET
    
*>  Waiting for actions
    PERFORM FOREVER
       MOVE J-NEXTACTION() TO WS-OBJ

       IF (WS-OBJ = WS-QUIT) OR (WS-OBJ = WS-FRAME)
       THEN
          EXIT PERFORM
       END-IF
       
       IF WS-OBJ = WS-PANEL
       THEN
          DISPLAY "Size changed to "
                  J-GETROWS(WS-TEXT) 
                  " rows "
                  J-GETCOLUMNS(WS-TEXT) 
                  " columns."
          END-DISPLAY        
          DISPLAY "Size changed to "
                  J-GETWIDTH(WS-TEXT) 
                  " x "
                  J-GETHEIGHT(WS-TEXT) 
                  " pixel."
          END-DISPLAY        
          DISPLAY " " END-DISPLAY
       END-IF

       IF WS-OBJ = WS-TEXT
       THEN
          DISPLAY "text changed (len = "
                  J-GETLENGTH(WS-TEXT)
                  ")"
          END-DISPLAY        
       END-IF

       IF WS-OBJ = WS-NEW
       THEN
          MOVE J-SETTEXT(WS-TEXT, WS-NEWTEXT) TO WS-RET
       END-IF
       
       IF WS-OBJ = WS-SAVE
       THEN
          MOVE J-GETTEXT(WS-TEXT, WS-CONTENT) TO WS-RET
          DISPLAY X"0A" & "BEGIN" & X"0A" 
                  TRIM(WS-CONTENT)
                  X"0A" & "END" & X"0A" 
          END-DISPLAY
       END-IF
       
       IF WS-OBJ = WS-SELALL
       THEN
          MOVE J-SELECTALL(WS-TEXT) TO WS-RET
       END-IF

       IF WS-OBJ = WS-CUT 
       OR WS-OBJ = WS-COPY
       OR WS-OBJ = WS-PASTE
       THEN
          MOVE J-GETSELSTART(WS-TEXT) TO WS-SELSTART
          MOVE J-GETSELEND(WS-TEXT)   TO WS-SELEND
       END-IF
       
       IF WS-OBJ = WS-CUT 
       THEN
          MOVE J-GETSELTEXT(WS-TEXT, WS-CONTENT)         TO WS-RET
          MOVE J-DELETE(WS-TEXT, WS-SELSTART, WS-SELEND) TO WS-RET
       END-IF
       
       IF WS-OBJ = WS-COPY 
       THEN
          MOVE J-GETSELTEXT(WS-TEXT, WS-CONTENT) TO WS-RET
       END-IF

       IF WS-OBJ = WS-PASTE
       THEN
          IF WS-SELSTART = WS-SELEND
          THEN
             MOVE J-INSERTTEXT(WS-TEXT, WS-CONTENT, 
                               J-GETCURPOS(WS-TEXT))   TO WS-RET
          ELSE
             MOVE J-REPLACETEXT(WS-TEXT, WS-CONTENT, 
                               WS-SELSTART, WS-SELEND) TO WS-RET
          END-IF
          
          MOVE J-SETCURPOS(WS-TEXT, WS-SELSTART) TO WS-RET
       END-IF
    END-PERFORM
    
    MOVE J-QUIT() TO WS-RET

    STOP RUN
    
    .
 MAIN-TEXTEDITOR-EX.
    EXIT.
 END PROGRAM texteditor.
