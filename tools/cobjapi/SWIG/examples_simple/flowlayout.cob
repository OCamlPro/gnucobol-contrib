*>******************************************************************************
*>  This file is part of cobjapi.
*>
*>  flowlayout.cob is free software: you can redistribute it and/or 
*>  modify it under the terms of the GNU Lesser General Public License as 
*>  published by the Free Software Foundation, either version 3 of the License,
*>  or (at your option) any later version.
*>
*>  flowlayout.cob is distributed in the hope that it will be useful, 
*>  but WITHOUT ANY WARRANTY; without even the implied warranty of 
*>  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
*>  See the GNU Lesser General Public License for more details.
*>
*>  You should have received a copy of the GNU Lesser General Public License 
*>  along with flowlayout.cob.
*>  If not, see <http://www.gnu.org/licenses/>.
*>******************************************************************************

*>******************************************************************************
*> Program:      flowlayout.cob
*>
*> Purpose:      Example GnuCOBOL program for JAPI
*>
*> Author:       Laszlo Erdos - https://www.facebook.com/wortfee
*>
*> Date-Written: 2014.12.24
*>
*> Tectonics:    Example for static link.
*>               cobc -x -free flowlayout.cob cobjapi.o \
*>                                            japilib.o \
*>                                            imageio.o \
*>                                            fileselect.o
*>
*> Usage:        ./flowlayout.exe
*>
*>******************************************************************************
*> Date       Name / Change description 
*> ========== ==================================================================
*> 2003.02.26 This comment is only for History. The latest Version (V1.0.6) of 
*>            JAPI was released on 02/26/2003. Homepage: http://www.japi.de 
*>------------------------------------------------------------------------------
*> 2014.12.24 Laszlo Erdos: 
*>            - GnuCOBOL support for JAPI added. 
*>            - flowlayout.c converted into flowlayout.cob. 
*>******************************************************************************

 IDENTIFICATION DIVISION.
 PROGRAM-ID. flowlayout.
 AUTHOR.     Laszlo Erdos.

 ENVIRONMENT DIVISION.
 CONFIGURATION SECTION.
 REPOSITORY.
    FUNCTION J-SETDEBUG
    FUNCTION J-START
    FUNCTION J-FRAME
    FUNCTION J-SETSIZE
    FUNCTION J-SETFLOWLAYOUT
    FUNCTION J-SETALIGN
    FUNCTION J-BUTTON
    FUNCTION J-SETHGAP
    FUNCTION J-SETVGAP    
    FUNCTION J-SHOW
    FUNCTION J-PACK
    FUNCTION J-NEXTACTION
    FUNCTION J-SETFLOWFILL
    FUNCTION J-QUIT
    FUNCTION ALL INTRINSIC.

 DATA DIVISION.

 WORKING-STORAGE SECTION.
*> function return value 
 01 WS-RET                             BINARY-INT.

*> GUI elements
 01 WS-FRAME                           BINARY-INT.
 01 WS-OBJ                             BINARY-INT.
 01 WS-ALIGN                           BINARY-INT.
 01 WS-ORIENT                          BINARY-INT.
 01 WS-FILL                            BINARY-INT.
 01 WS-PACK                            BINARY-INT.
 
*> function args 
 01 WS-DEBUG-LEVEL                     BINARY-INT.
 01 WS-WIDTH                           BINARY-INT.
 01 WS-HEIGHT                          BINARY-INT.
 01 WS-ALIGNMENT                       BINARY-INT.
 01 WS-ORIENTATION                     BINARY-INT.
 01 WS-DOFILL                          BINARY-INT.
 01 WS-HGAP                            BINARY-INT.
 01 WS-VGAP                            BINARY-INT.

*> Constants for the cobjapi wrapper 
 COPY "cobjapi.cpy".
 
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

    MOVE J-TOP        TO WS-ALIGNMENT
    MOVE J-HORIZONTAL TO WS-ORIENTATION
    MOVE J-FALSE      TO WS-DOFILL
    
*>  Generate GUI Objects    
    MOVE J-FRAME("Flow Layout Demo") TO WS-FRAME  
    MOVE 800 TO WS-WIDTH
    MOVE 600 TO WS-HEIGHT
    MOVE J-SETSIZE(WS-FRAME, WS-WIDTH, WS-HEIGHT)  TO WS-RET
        
    MOVE J-SETFLOWLAYOUT(WS-FRAME, WS-ORIENTATION) TO WS-RET        
    MOVE J-SETALIGN(WS-FRAME, WS-ALIGNMENT)        TO WS-RET                               
                               
    MOVE J-BUTTON(WS-FRAME, "alignment")   TO WS-ALIGN
    MOVE J-BUTTON(WS-FRAME, "orientation") TO WS-ORIENT
    MOVE J-BUTTON(WS-FRAME, "fill")        TO WS-FILL
    MOVE J-BUTTON(WS-FRAME, "pack")        TO WS-PACK

    MOVE 10 TO WS-HGAP
    MOVE J-SETHGAP(WS-FRAME, WS-HGAP)      TO WS-RET
    MOVE 10 TO WS-VGAP
    MOVE J-SETVGAP(WS-FRAME, WS-VGAP)      TO WS-RET
    
    MOVE 100 TO WS-WIDTH
    MOVE 100 TO WS-HEIGHT
    MOVE J-SETSIZE(WS-ALIGN, WS-WIDTH, WS-HEIGHT)  TO WS-RET
    MOVE 200 TO WS-WIDTH
    MOVE 200 TO WS-HEIGHT
    MOVE J-SETSIZE(WS-ORIENT, WS-WIDTH, WS-HEIGHT) TO WS-RET
    
    MOVE J-SHOW(WS-FRAME) TO WS-RET

*>  Waiting for actions
    PERFORM FOREVER
       MOVE J-NEXTACTION() TO WS-OBJ

       IF WS-OBJ = WS-FRAME
       THEN
          EXIT PERFORM
       END-IF
       
       IF WS-OBJ = WS-ALIGN
       THEN
          EVALUATE WS-ALIGNMENT
             WHEN J-LEFT        MOVE J-CENTER      TO WS-ALIGNMENT
             WHEN J-CENTER      MOVE J-RIGHT       TO WS-ALIGNMENT
             WHEN J-RIGHT       MOVE J-TOP         TO WS-ALIGNMENT
             WHEN J-TOP         MOVE J-BOTTOM      TO WS-ALIGNMENT
             WHEN J-BOTTOM      MOVE J-TOPLEFT     TO WS-ALIGNMENT
             WHEN J-TOPLEFT     MOVE J-TOPRIGHT    TO WS-ALIGNMENT
             WHEN J-TOPRIGHT    MOVE J-BOTTOMLEFT  TO WS-ALIGNMENT
             WHEN J-BOTTOMLEFT  MOVE J-BOTTOMRIGHT TO WS-ALIGNMENT
             WHEN J-BOTTOMRIGHT MOVE J-LEFT        TO WS-ALIGNMENT
          END-EVALUATE      
          MOVE J-SETALIGN(WS-FRAME, WS-ALIGNMENT)  TO WS-RET                               
       END-IF

       IF WS-OBJ = WS-PACK
       THEN
          MOVE J-PACK(WS-FRAME) TO WS-RET
       END-IF
       
       IF WS-OBJ = WS-FILL
       THEN
          IF WS-DOFILL = J-TRUE
          THEN
             MOVE J-FALSE TO WS-DOFILL 
          ELSE   
             MOVE J-TRUE  TO WS-DOFILL 
          END-IF

          MOVE J-SETFLOWFILL(WS-FRAME, WS-DOFILL) TO WS-RET
       END-IF

       IF WS-OBJ = WS-FILL
       THEN
          IF WS-ORIENTATION = J-VERTICAL
          THEN
             MOVE J-HORIZONTAL TO WS-ORIENTATION 
          ELSE   
             MOVE J-VERTICAL   TO WS-ORIENTATION 
          END-IF

          MOVE J-SETFLOWLAYOUT(WS-FRAME, WS-ORIENTATION) TO WS-RET
          MOVE J-SETALIGN(WS-FRAME, WS-ALIGNMENT)        TO WS-RET                               
          MOVE J-SETFLOWLAYOUT(WS-FRAME, WS-DOFILL)      TO WS-RET        
       END-IF
    END-PERFORM
    
    MOVE J-QUIT() TO WS-RET

    STOP RUN
    
    .
 MAIN-FLOWLAYOUT-EX.
    EXIT.
 END PROGRAM flowlayout.
