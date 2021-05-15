*>******************************************************************************
*>  This file is part of cobjapi.
*>
*>  flowlayout1.cob is free software: you can redistribute it and/or 
*>  modify it under the terms of the GNU Lesser General Public License as 
*>  published by the Free Software Foundation, either version 3 of the License,
*>  or (at your option) any later version.
*>
*>  flowlayout1.cob is distributed in the hope that it will be useful, 
*>  but WITHOUT ANY WARRANTY; without even the implied warranty of 
*>  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
*>  See the GNU Lesser General Public License for more details.
*>
*>  You should have received a copy of the GNU Lesser General Public License 
*>  along with flowlayout1.cob.
*>  If not, see <http://www.gnu.org/licenses/>.
*>******************************************************************************

*>******************************************************************************
*> Program:      flowlayout1.cob
*>
*> Purpose:      Example GnuCOBOL program for JAPI
*>
*> Author:       Laszlo Erdos - https://www.facebook.com/wortfee
*>
*> Date-Written: 2021.05.15
*>
*> Tectonics:    Example for static link.
*>               cobc -x -free flowlayout1.cob cobjapi.o \
*>                                             japilib.o \
*>                                             imageio.o \
*>                                             fileselect.o
*>
*> Usage:        ./flowlayout1.exe
*>
*>******************************************************************************
*> Date       Name / Change description 
*> ========== ==================================================================
*> 2003.02.26 This comment is only for History. The latest Version (V1.0.6) of 
*>            JAPI was released on 02/26/2003. Homepage: http://www.japi.de 
*>------------------------------------------------------------------------------
*> 2021.05.15 Laszlo Erdos: 
*>            - flowlayout.c converted into flowlayout1.cob. 
*>******************************************************************************

 IDENTIFICATION DIVISION.
 PROGRAM-ID. flowlayout1.

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
 01 WS-OBJ                             BINARY-LONG.
 01 WS-ALIGN                           BINARY-LONG.
 01 WS-ORIENT                          BINARY-LONG.
 01 WS-FILL                            BINARY-LONG.
 01 WS-PACK                            BINARY-LONG.

 01 WS-PANEL-LEFT                      BINARY-LONG.
 01 WS-PANEL-RIGHT                     BINARY-LONG.
 01 WS-PANEL-BOTTOM                    BINARY-LONG.
 01 WS-PANEL-TOP                       BINARY-LONG.
 01 WS-PANEL-CENTER                    BINARY-LONG.

 01 WS-LABEL                           BINARY-LONG.
 01 WS-FONT                            BINARY-LONG.
 01 WS-FONTSTYLE                       BINARY-LONG.
 01 WS-FONTSIZE                        BINARY-LONG.

 01 WS-FTXT                            BINARY-LONG.
 01 WS-COLUMNS                         BINARY-LONG.
 01 WS-MASK-STR                        PIC X(40).
 01 WS-PLACE-HOLDER-CHAR               PIC X(1).

 01 WS-BUTTON-WRITE                    BINARY-LONG.
 01 WS-BUTTON-BACK                     BINARY-LONG.
 
*> function args 
 01 WS-DEBUG-LEVEL                     BINARY-LONG.
 01 WS-WIDTH                           BINARY-LONG.
 01 WS-HEIGHT                          BINARY-LONG.
 01 WS-TOP                             BINARY-LONG.
 01 WS-BOTTOM                          BINARY-LONG.
 01 WS-LEFT                            BINARY-LONG.
 01 WS-RIGHT                           BINARY-LONG.
 
 PROCEDURE DIVISION.

*>------------------------------------------------------------------------------
 MAIN-FLOWLAYOUT SECTION.
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
    MOVE J-FRAME("Flow Layout Demo 1") TO WS-FRAME  
    MOVE 800 TO WS-WIDTH
    MOVE 600 TO WS-HEIGHT
    MOVE J-SETSIZE(WS-FRAME, WS-WIDTH, WS-HEIGHT)  TO WS-RET

    MOVE J-SETBORDERLAYOUT(WS-FRAME) TO WS-RET

    MOVE 10 TO WS-TOP
    MOVE 10 TO WS-BOTTOM
    MOVE 10 TO WS-LEFT
    MOVE 10 TO WS-RIGHT
    MOVE J-SETINSETS(WS-FRAME, WS-TOP, WS-BOTTOM, WS-LEFT, WS-RIGHT) TO WS-RET

    MOVE J-PANEL(WS-FRAME) TO WS-PANEL-RIGHT  
    MOVE 10 TO WS-TOP
    MOVE 10 TO WS-BOTTOM
    MOVE 10 TO WS-LEFT
    MOVE 10 TO WS-RIGHT
    MOVE J-SETINSETS(WS-PANEL-RIGHT, WS-TOP, WS-BOTTOM, WS-LEFT, WS-RIGHT) TO WS-RET

    MOVE J-PANEL(WS-FRAME) TO WS-PANEL-LEFT   
    MOVE 10 TO WS-TOP
    MOVE 10 TO WS-BOTTOM
    MOVE 10 TO WS-LEFT
    MOVE 10 TO WS-RIGHT
    MOVE J-SETINSETS(WS-PANEL-LEFT, WS-TOP, WS-BOTTOM, WS-LEFT, WS-RIGHT) TO WS-RET

    MOVE J-PANEL(WS-FRAME) TO WS-PANEL-BOTTOM 
    MOVE 10 TO WS-TOP
    MOVE 10 TO WS-BOTTOM
    MOVE 10 TO WS-LEFT
    MOVE 10 TO WS-RIGHT
    MOVE J-SETINSETS(WS-PANEL-BOTTOM, WS-TOP, WS-BOTTOM, WS-LEFT, WS-RIGHT) TO WS-RET

    MOVE J-PANEL(WS-FRAME) TO WS-PANEL-TOP    
    MOVE 10 TO WS-TOP
    MOVE 10 TO WS-BOTTOM
    MOVE 10 TO WS-LEFT
    MOVE 10 TO WS-RIGHT
    MOVE J-SETINSETS(WS-PANEL-TOP, WS-TOP, WS-BOTTOM, WS-LEFT, WS-RIGHT) TO WS-RET

    MOVE J-PANEL(WS-FRAME) TO WS-PANEL-CENTER 
    MOVE 10 TO WS-TOP
    MOVE 10 TO WS-BOTTOM
    MOVE 10 TO WS-LEFT
    MOVE 10 TO WS-RIGHT
    MOVE J-SETINSETS(WS-PANEL-CENTER, WS-TOP, WS-BOTTOM, WS-LEFT, WS-RIGHT) TO WS-RET

    MOVE J-SETBORDERPOS(WS-PANEL-RIGHT, J-RIGHT)   TO WS-RET
    MOVE J-SETBORDERPOS(WS-PANEL-LEFT, J-LEFT)     TO WS-RET
    MOVE J-SETBORDERPOS(WS-PANEL-BOTTOM, J-BOTTOM) TO WS-RET
    MOVE J-SETBORDERPOS(WS-PANEL-TOP, J-TOP)       TO WS-RET
    MOVE J-SETBORDERPOS(WS-PANEL-CENTER, J-CENTER) TO WS-RET

*>  panel top
    MOVE J-SETFLOWLAYOUT(WS-PANEL-TOP, J-HORIZONTAL) TO WS-RET        
    MOVE J-LABEL(WS-PANEL-TOP, "Update Customers")   TO WS-LABEL 
    MOVE J-COURIER  TO WS-FONT
    MOVE J-BOLD     TO WS-FONTSTYLE
    MOVE "30"       TO WS-FONTSIZE
    MOVE J-SETFONT(WS-LABEL, WS-FONT, WS-FONTSTYLE, WS-FONTSIZE) TO WS-RET

*>  panel bottom
    MOVE J-SETFLOWLAYOUT(WS-PANEL-BOTTOM, J-HORIZONTAL)   TO WS-RET        
    MOVE J-BUTTON(WS-PANEL-BOTTOM, "Write Record")        TO WS-BUTTON-WRITE 
    MOVE J-COURIER  TO WS-FONT
    MOVE J-BOLD     TO WS-FONTSTYLE
    MOVE "20"       TO WS-FONTSIZE
    MOVE J-SETFONT(WS-BUTTON-WRITE, WS-FONT, WS-FONTSTYLE, WS-FONTSIZE) TO WS-RET

    MOVE J-BUTTON(WS-PANEL-BOTTOM, "Back without change") TO WS-BUTTON-BACK 
    MOVE J-COURIER  TO WS-FONT
    MOVE J-BOLD     TO WS-FONTSTYLE
    MOVE "20"       TO WS-FONTSIZE
    MOVE J-SETFONT(WS-BUTTON-BACK, WS-FONT, WS-FONTSTYLE, WS-FONTSIZE) TO WS-RET

*>  panel left
    MOVE J-SETFLOWLAYOUT(WS-PANEL-LEFT, J-VERTICAL) TO WS-RET        
    MOVE J-SETALIGN(WS-PANEL-LEFT, J-RIGHT)         TO WS-RET                               

    MOVE J-LABEL(WS-PANEL-LEFT, "Customer number:") TO WS-LABEL 
    MOVE J-COURIER  TO WS-FONT
    MOVE J-BOLD     TO WS-FONTSTYLE
    MOVE "20"       TO WS-FONTSIZE
    MOVE J-SETFONT(WS-LABEL, WS-FONT, WS-FONTSTYLE, WS-FONTSIZE) TO WS-RET

    MOVE J-LABEL(WS-PANEL-LEFT, "Customer name:")   TO WS-LABEL 
    MOVE J-COURIER  TO WS-FONT
    MOVE J-BOLD     TO WS-FONTSTYLE
    MOVE "20"       TO WS-FONTSIZE
    MOVE J-SETFONT(WS-LABEL, WS-FONT, WS-FONTSTYLE, WS-FONTSIZE) TO WS-RET

    MOVE J-LABEL(WS-PANEL-LEFT, "Contact partner:") TO WS-LABEL 
    MOVE J-COURIER  TO WS-FONT
    MOVE J-BOLD     TO WS-FONTSTYLE
    MOVE "20"       TO WS-FONTSIZE
    MOVE J-SETFONT(WS-LABEL, WS-FONT, WS-FONTSTYLE, WS-FONTSIZE) TO WS-RET

    MOVE J-LABEL(WS-PANEL-LEFT, "Street:")          TO WS-LABEL 
    MOVE J-COURIER  TO WS-FONT
    MOVE J-BOLD     TO WS-FONTSTYLE
    MOVE "20"       TO WS-FONTSIZE
    MOVE J-SETFONT(WS-LABEL, WS-FONT, WS-FONTSTYLE, WS-FONTSIZE) TO WS-RET

    MOVE J-LABEL(WS-PANEL-LEFT, "Postcode:")        TO WS-LABEL 
    MOVE J-COURIER  TO WS-FONT
    MOVE J-BOLD     TO WS-FONTSTYLE
    MOVE "20"       TO WS-FONTSIZE
    MOVE J-SETFONT(WS-LABEL, WS-FONT, WS-FONTSTYLE, WS-FONTSIZE) TO WS-RET

    MOVE J-LABEL(WS-PANEL-LEFT, "City:")            TO WS-LABEL 
    MOVE J-COURIER  TO WS-FONT
    MOVE J-BOLD     TO WS-FONTSTYLE
    MOVE "20"       TO WS-FONTSIZE
    MOVE J-SETFONT(WS-LABEL, WS-FONT, WS-FONTSTYLE, WS-FONTSIZE) TO WS-RET

*>  panel center
    MOVE J-SETFLOWLAYOUT(WS-PANEL-CENTER, J-VERTICAL) TO WS-RET        
    MOVE J-SETALIGN(WS-PANEL-CENTER, J-LEFT)          TO WS-RET                               

    MOVE "########" TO WS-MASK-STR         
    MOVE "_" TO WS-PLACE-HOLDER-CHAR
    MOVE 0 TO WS-COLUMNS
    MOVE J-FORMATTEDTEXTFIELD(WS-PANEL-CENTER, WS-MASK-STR, WS-PLACE-HOLDER-CHAR, WS-COLUMNS) TO WS-FTXT
    MOVE J-COURIER  TO WS-FONT
    MOVE J-BOLD     TO WS-FONTSTYLE
    MOVE "16"       TO WS-FONTSIZE
    MOVE J-SETFONT(WS-FTXT, WS-FONT, WS-FONTSTYLE, WS-FONTSIZE) TO WS-RET

    MOVE ALL "A" TO WS-MASK-STR         
    MOVE "_" TO WS-PLACE-HOLDER-CHAR
    MOVE 40 TO WS-COLUMNS
    MOVE J-FORMATTEDTEXTFIELD(WS-PANEL-CENTER, WS-MASK-STR, WS-PLACE-HOLDER-CHAR, WS-COLUMNS) TO WS-FTXT
    MOVE J-COURIER  TO WS-FONT
    MOVE J-BOLD     TO WS-FONTSTYLE
    MOVE "16"       TO WS-FONTSIZE
    MOVE J-SETFONT(WS-FTXT, WS-FONT, WS-FONTSTYLE, WS-FONTSIZE) TO WS-RET

    MOVE ALL "A" TO WS-MASK-STR         
    MOVE "_" TO WS-PLACE-HOLDER-CHAR
    MOVE 40 TO WS-COLUMNS
    MOVE J-FORMATTEDTEXTFIELD(WS-PANEL-CENTER, WS-MASK-STR, WS-PLACE-HOLDER-CHAR, WS-COLUMNS) TO WS-FTXT
    MOVE J-COURIER  TO WS-FONT
    MOVE J-BOLD     TO WS-FONTSTYLE
    MOVE "16"       TO WS-FONTSIZE
    MOVE J-SETFONT(WS-FTXT, WS-FONT, WS-FONTSTYLE, WS-FONTSIZE) TO WS-RET

    MOVE ALL "A" TO WS-MASK-STR         
    MOVE "_" TO WS-PLACE-HOLDER-CHAR
    MOVE 40 TO WS-COLUMNS
    MOVE J-FORMATTEDTEXTFIELD(WS-PANEL-CENTER, WS-MASK-STR, WS-PLACE-HOLDER-CHAR, WS-COLUMNS) TO WS-FTXT
    MOVE J-COURIER  TO WS-FONT
    MOVE J-BOLD     TO WS-FONTSTYLE
    MOVE "16"       TO WS-FONTSIZE
    MOVE J-SETFONT(WS-FTXT, WS-FONT, WS-FONTSTYLE, WS-FONTSIZE) TO WS-RET

    MOVE "#####" TO WS-MASK-STR         
    MOVE "_" TO WS-PLACE-HOLDER-CHAR
    MOVE 0 TO WS-COLUMNS
    MOVE J-FORMATTEDTEXTFIELD(WS-PANEL-CENTER, WS-MASK-STR, WS-PLACE-HOLDER-CHAR, WS-COLUMNS) TO WS-FTXT
    MOVE J-COURIER  TO WS-FONT
    MOVE J-BOLD     TO WS-FONTSTYLE
    MOVE "16"       TO WS-FONTSIZE
    MOVE J-SETFONT(WS-FTXT, WS-FONT, WS-FONTSTYLE, WS-FONTSIZE) TO WS-RET

    MOVE ALL "A" TO WS-MASK-STR         
    MOVE "_" TO WS-PLACE-HOLDER-CHAR
    MOVE 40 TO WS-COLUMNS
    MOVE J-FORMATTEDTEXTFIELD(WS-PANEL-CENTER, WS-MASK-STR, WS-PLACE-HOLDER-CHAR, WS-COLUMNS) TO WS-FTXT
    MOVE J-COURIER  TO WS-FONT
    MOVE J-BOLD     TO WS-FONTSTYLE
    MOVE "16"       TO WS-FONTSIZE
    MOVE J-SETFONT(WS-FTXT, WS-FONT, WS-FONTSTYLE, WS-FONTSIZE) TO WS-RET
    
    MOVE J-PACK(WS-FRAME) TO WS-RET
    MOVE J-SHOW(WS-FRAME) TO WS-RET

*>  panel right not filled yet

*>  Waiting for actions
    PERFORM FOREVER
       MOVE J-NEXTACTION() TO WS-OBJ

       IF WS-OBJ = WS-FRAME
       THEN
          EXIT PERFORM
       END-IF
    END-PERFORM
    
    MOVE J-QUIT() TO WS-RET

    STOP RUN
    
    .
 MAIN-FLOWLAYOUT-EX.
    EXIT.
 END PROGRAM flowlayout1.
