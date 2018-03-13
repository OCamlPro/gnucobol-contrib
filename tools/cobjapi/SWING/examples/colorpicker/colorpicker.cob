*>******************************************************************************
*>  This file is part of cobjapi.
*>
*>  colorpicker.cob is free software: you can redistribute it and/or 
*>  modify it under the terms of the GNU Lesser General Public License as 
*>  published by the Free Software Foundation, either version 3 of the License,
*>  or (at your option) any later version.
*>
*>  colorpicker.cob is distributed in the hope that it will be useful, 
*>  but WITHOUT ANY WARRANTY; without even the implied warranty of 
*>  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
*>  See the GNU Lesser General Public License for more details.
*>
*>  You should have received a copy of the GNU Lesser General Public License 
*>  along with colorpicker.cob.
*>  If not, see <http://www.gnu.org/licenses/>.
*>******************************************************************************

*>******************************************************************************
*> Program:      colorpicker.cob
*>
*> Purpose:      Example GnuCOBOL program for JAPI
*>
*> Author:       Laszlo Erdos - https://www.facebook.com/wortfee
*>
*> Date-Written: 2015.06.07
*>
*> Tectonics:    Example for static link.
*>               cobc -x -free colorpicker.cob cobjapi.o \
*>                                             japilib.o \
*>                                             imageio.o \
*>                                             fileselect.o
*>
*> Usage:        ./colorpicker.exe
*>
*>******************************************************************************
*> Date       Name / Change description 
*> ========== ==================================================================
*> 2003.02.26 This comment is only for History. The latest Version (V1.0.6) of 
*>            JAPI was released on 02/26/2003. Homepage: http://www.japi.de 
*>------------------------------------------------------------------------------
*> 2015.06.07 Laszlo Erdos: 
*>            - GnuCOBOL support for JAPI added. 
*>            - colorpicker.c converted into colorpicker.cob. 
*>******************************************************************************

 IDENTIFICATION DIVISION.
 PROGRAM-ID. colorpicker.
 AUTHOR.     Laszlo Erdos.

 ENVIRONMENT DIVISION.
 CONFIGURATION SECTION.
 REPOSITORY.
*>  Colorpicker dialog function
    FUNCTION FN-COLORPICKER
*>  Functions for the cobjapi wrapper 
    COPY "cobjapifn.cpy".

 DATA DIVISION.

 WORKING-STORAGE SECTION.
*> function return value 
 01 WS-RET                             BINARY-INT.

*> GUI elements
 01 WS-FRAME                           BINARY-INT.
 01 WS-MENUBAR                         BINARY-INT.
 01 WS-FILE                            BINARY-INT.
 01 WS-COLOR                           BINARY-INT.
 01 WS-QUIT                            BINARY-INT.
 01 WS-OBJ                             BINARY-INT.

*> function args 
 01 WS-DEBUG-LEVEL                     BINARY-INT.
 01 WS-R                               BINARY-CHAR UNSIGNED.
 01 WS-G                               BINARY-CHAR UNSIGNED.
 01 WS-B                               BINARY-CHAR UNSIGNED.

*> Constants for the cobjapi wrapper 
 COPY "cobjapi.cpy".
 
 PROCEDURE DIVISION.

*>------------------------------------------------------------------------------
 MAIN-COLORPICKER SECTION.
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
    MOVE J-FRAME("Colorpicker Demo")  TO WS-FRAME  
    MOVE J-MENUBAR(WS-FRAME)          TO WS-MENUBAR
    MOVE J-MENU(WS-MENUBAR, "File")   TO WS-FILE
    MOVE J-MENUITEM(WS-FILE, "Color") TO WS-COLOR
    MOVE J-MENUITEM(WS-FILE, "Quit")  TO WS-QUIT

    MOVE 0 TO WS-R WS-G WS-B
    MOVE J-SETCOLORBG(WS-FRAME, WS-R, WS-G, WS-B) TO WS-RET
    
    MOVE J-SHOW(WS-FRAME) TO WS-RET

*>  Waiting for actions
    PERFORM FOREVER
       MOVE J-NEXTACTION() TO WS-OBJ

       IF (WS-OBJ = WS-QUIT) OR (WS-OBJ = WS-FRAME)
       THEN
          EXIT PERFORM
       END-IF
       
       IF (WS-OBJ = WS-COLOR) 
       THEN
*>        Create colorpicker dialog       
          IF FN-COLORPICKER(WS-FRAME, WS-R, WS-G, WS-B) = J-TRUE
          THEN
             MOVE J-SETCOLORBG(WS-FRAME, WS-R, WS-G, WS-B) TO WS-RET
          END-IF
       END-IF
    END-PERFORM
    
    MOVE J-QUIT() TO WS-RET

    STOP RUN
    
    .
 MAIN-COLORPICKER-EX.
    EXIT.
 END PROGRAM colorpicker.

*>------------------------------------------------------------------------------
 IDENTIFICATION DIVISION.
 FUNCTION-ID. FN-COLORPICKER.
 AUTHOR.      Laszlo Erdos.

 ENVIRONMENT DIVISION.
 CONFIGURATION SECTION.
 REPOSITORY.
*>  Functions for the cobjapi wrapper 
    COPY "cobjapifn.cpy".
 
 DATA DIVISION.
 
 WORKING-STORAGE SECTION.
*> function return value 
 01 WS-RET                             BINARY-INT.

*> GUI elements
 01 WS-DIALOG                          BINARY-INT.
*> scrolls 
 01 WS-R-SCROLL                        BINARY-INT.
 01 WS-G-SCROLL                        BINARY-INT.
 01 WS-B-SCROLL                        BINARY-INT.
*> labels
 01 WS-R-LABEL                         BINARY-INT.
 01 WS-G-LABEL                         BINARY-INT.
 01 WS-B-LABEL                         BINARY-INT.
*> panels
 01 WS-PANEL-1                         BINARY-INT.
 01 WS-PANEL-2                         BINARY-INT.
*> buttons
 01 WS-OK                              BINARY-INT.
 01 WS-CANCEL                          BINARY-INT.

 01 WS-CANVAS                          BINARY-INT.
 01 WS-OBJ                             BINARY-INT.

*> function args 
 01 WS-DEBUG-LEVEL                     BINARY-INT.
 01 WS-TOP                             BINARY-INT.
 01 WS-BOTTOM                          BINARY-INT.
 01 WS-LEFT                            BINARY-INT.
 01 WS-RIGHT                           BINARY-INT.
 01 WS-WIDTH                           BINARY-INT.
 01 WS-HEIGHT                          BINARY-INT.
 01 WS-XPOS                            BINARY-INT.
 01 WS-YPOS                            BINARY-INT.
 01 WS-ROW                             BINARY-INT.
 01 WS-COL                             BINARY-INT.
 01 WS-HGAP                            BINARY-INT.
 01 WS-MAX-VAL                         BINARY-INT.
 01 WS-CURRENT-VALUE                   BINARY-INT.
 01 WS-R                               BINARY-CHAR UNSIGNED.
 01 WS-G                               BINARY-CHAR UNSIGNED.
 01 WS-B                               BINARY-CHAR UNSIGNED.
 
 01 WS-VAL-NUM                         PIC 9(3). 
 01 WS-VAL-STR REDEFINES WS-VAL-NUM    PIC X(3). 
 
*> Constants for the cobjapi wrapper 
 COPY "cobjapi.cpy".
 
 LINKAGE SECTION.
 01 LNK-FRAME                          BINARY-INT.
 01 LNK-R                              BINARY-CHAR UNSIGNED.
 01 LNK-G                              BINARY-CHAR UNSIGNED.
 01 LNK-B                              BINARY-CHAR UNSIGNED.
 01 LNK-RET                            BINARY-INT.
 
 PROCEDURE DIVISION USING BY VALUE     LNK-FRAME
                          BY REFERENCE LNK-R
                          BY REFERENCE LNK-G
                          BY REFERENCE LNK-B
                    RETURNING          LNK-RET.

 MAIN-FN-COLORPICKER SECTION.

*>  MOVE 5 TO WS-DEBUG-LEVEL
*>  MOVE J-SETDEBUG(WS-DEBUG-LEVEL) TO WS-RET
 
    MOVE J-FALSE TO LNK-RET
    
*>  disable main frame    
    MOVE J-DISABLE(LNK-FRAME) TO WS-RET
    
*>  create dialog
    MOVE J-DIALOG(LNK-FRAME, "Colorpicker") TO WS-DIALOG
    MOVE 30 TO WS-TOP   
    MOVE 10 TO WS-BOTTOM
    MOVE 10 TO WS-LEFT  
    MOVE 10 TO WS-RIGHT 
    MOVE J-SETINSETS(WS-DIALOG, WS-TOP, WS-BOTTOM, WS-LEFT, WS-RIGHT) TO WS-RET
    MOVE J-SETNAMEDCOLORBG(WS-DIALOG, J-WHITE) TO WS-RET    
    MOVE J-SETBORDERLAYOUT(WS-DIALOG)          TO WS-RET
    MOVE J-PANEL(WS-DIALOG)                    TO WS-PANEL-1
    MOVE J-SETBORDERPOS(WS-PANEL-1, J-LEFT)    TO WS-RET
    MOVE J-SETBORDERLAYOUT(WS-PANEL-1)         TO WS-RET
    
    MOVE J-PANEL(WS-PANEL-1)               TO WS-PANEL-2
    MOVE J-SETBORDERPOS(WS-PANEL-2, J-TOP) TO WS-RET
    MOVE 0 TO WS-ROW
    MOVE 3 TO WS-COL
    MOVE J-SETGRIDLAYOUT(WS-PANEL-2, WS-ROW, WS-COL) TO WS-RET
*>  create labels
    MOVE J-LABEL(WS-PANEL-2, "255") TO WS-R-LABEL
    MOVE J-LABEL(WS-PANEL-2, "255") TO WS-G-LABEL
    MOVE J-LABEL(WS-PANEL-2, "255") TO WS-B-LABEL

    MOVE J-PANEL(WS-PANEL-1) TO WS-PANEL-2
    MOVE 0 TO WS-ROW
    MOVE 3 TO WS-COL
    MOVE J-SETGRIDLAYOUT(WS-PANEL-2, WS-ROW, WS-COL) TO WS-RET
    MOVE 20 TO WS-HGAP
    MOVE J-SETHGAP(WS-PANEL-2, WS-HGAP) TO WS-RET   
    MOVE 0 TO WS-TOP   
    MOVE 0 TO WS-BOTTOM
    MOVE 0 TO WS-LEFT  
    MOVE 0 TO WS-RIGHT 
    MOVE J-SETINSETS(WS-PANEL-1, WS-TOP, WS-BOTTOM, WS-LEFT, WS-RIGHT) TO WS-RET
*>  create scrollbars
    MOVE J-VSCROLLBAR(WS-PANEL-2)  TO WS-R-SCROLL    
    MOVE J-VSCROLLBAR(WS-PANEL-2)  TO WS-G-SCROLL    
    MOVE J-VSCROLLBAR(WS-PANEL-2)  TO WS-B-SCROLL 
    MOVE 265 TO WS-MAX-VAL    
    MOVE J-SETMAX(WS-R-SCROLL, WS-MAX-VAL) TO WS-RET
    MOVE J-SETMAX(WS-G-SCROLL, WS-MAX-VAL) TO WS-RET
    MOVE J-SETMAX(WS-B-SCROLL, WS-MAX-VAL) TO WS-RET
*>  set scrollbars color
    MOVE J-SETNAMEDCOLORBG(WS-R-SCROLL, J-RED)   TO WS-RET   
    MOVE J-SETNAMEDCOLORBG(WS-G-SCROLL, J-GREEN) TO WS-RET   
    MOVE J-SETNAMEDCOLORBG(WS-B-SCROLL, J-BLUE)  TO WS-RET   
*>  set scroll values from linkage    
    COMPUTE WS-CURRENT-VALUE = 255 - LNK-R END-COMPUTE
    MOVE J-SETVALUE(WS-R-SCROLL, WS-CURRENT-VALUE) TO WS-RET
    COMPUTE WS-CURRENT-VALUE = 255 - LNK-G END-COMPUTE
    MOVE J-SETVALUE(WS-G-SCROLL, WS-CURRENT-VALUE) TO WS-RET
    COMPUTE WS-CURRENT-VALUE = 255 - LNK-B END-COMPUTE
    MOVE J-SETVALUE(WS-B-SCROLL, WS-CURRENT-VALUE) TO WS-RET

    MOVE J-PANEL(WS-DIALOG) TO WS-PANEL-1
    MOVE J-SETBORDERPOS(WS-PANEL-1, J-BOTTOM)      TO WS-RET
    MOVE J-SETFLOWLAYOUT(WS-PANEL-1, J-HORIZONTAL) TO WS-RET
*>  create buttons
    MOVE J-BUTTON(WS-PANEL-1, "OK")     TO WS-OK
    MOVE J-BUTTON(WS-PANEL-1, "Cancel") TO WS-CANCEL
    MOVE 0 TO WS-TOP   
    MOVE 0 TO WS-BOTTOM
    MOVE 0 TO WS-LEFT  
    MOVE 0 TO WS-RIGHT 
    MOVE J-SETINSETS(WS-PANEL-1, WS-TOP, WS-BOTTOM, WS-LEFT, WS-RIGHT) TO WS-RET

*>  create canvas for selected color    
    MOVE 200 TO WS-WIDTH
    MOVE 200 TO WS-HEIGHT
    MOVE J-CANVAS(WS-DIALOG, WS-WIDTH, WS-HEIGHT) TO WS-CANVAS

*>  open dialog in the middle    
    MOVE J-PACK(WS-DIALOG) TO WS-RET
    COMPUTE WS-XPOS = J-GETXPOS(LNK-FRAME)
                    + J-GETWIDTH(LNK-FRAME) / 2
                    - J-GETWIDTH(WS-DIALOG) / 2
    END-COMPUTE                
    COMPUTE WS-YPOS = J-GETYPOS(LNK-FRAME)
                    + J-GETHEIGHT(LNK-FRAME) / 2
                    - J-GETHEIGHT(WS-DIALOG) / 2
    END-COMPUTE                
    MOVE J-SETPOS(WS-DIALOG, WS-XPOS, WS-YPOS) TO WS-RET
    MOVE J-SHOW(WS-DIALOG) TO WS-RET
 
*>  Waiting for actions
    PERFORM FOREVER
*>     set canvas color
       COMPUTE WS-R = 255 - J-GETVALUE(WS-R-SCROLL) END-COMPUTE      
       COMPUTE WS-G = 255 - J-GETVALUE(WS-G-SCROLL) END-COMPUTE      
       COMPUTE WS-B = 255 - J-GETVALUE(WS-B-SCROLL) END-COMPUTE      
       MOVE J-SETCOLORBG(WS-CANVAS, WS-R, WS-G, WS-B) TO WS-RET
*>     set lables text       
       COMPUTE WS-VAL-NUM = 255 - J-GETVALUE(WS-R-SCROLL) END-COMPUTE
       MOVE J-SETTEXT(WS-R-LABEL, WS-VAL-NUM) TO WS-RET
       COMPUTE WS-VAL-NUM = 255 - J-GETVALUE(WS-G-SCROLL) END-COMPUTE
       MOVE J-SETTEXT(WS-G-LABEL, WS-VAL-NUM) TO WS-RET
       COMPUTE WS-VAL-NUM = 255 - J-GETVALUE(WS-B-SCROLL) END-COMPUTE
       MOVE J-SETTEXT(WS-B-LABEL, WS-VAL-NUM) TO WS-RET
    
       MOVE J-NEXTACTION() TO WS-OBJ

       IF (WS-OBJ = WS-CANCEL) OR (WS-OBJ = WS-DIALOG)
       THEN
          EXIT PERFORM
       END-IF
       
       IF (WS-OBJ = WS-OK) 
       THEN
          MOVE J-TRUE TO LNK-RET
          COMPUTE LNK-R = 255 - J-GETVALUE(WS-R-SCROLL) END-COMPUTE      
          COMPUTE LNK-G = 255 - J-GETVALUE(WS-G-SCROLL) END-COMPUTE      
          COMPUTE LNK-B = 255 - J-GETVALUE(WS-B-SCROLL) END-COMPUTE      
          
          EXIT PERFORM
       END-IF
    END-PERFORM
    
    MOVE J-DISPOSE(WS-DIALOG) TO WS-RET
*>  enable main frame    
    MOVE J-ENABLE(LNK-FRAME)  TO WS-RET
    
    GOBACK

    .
 MAIN-FN-COLORPICKER-EX.
    EXIT.
 END FUNCTION FN-COLORPICKER.
