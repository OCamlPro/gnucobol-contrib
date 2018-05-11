*>******************************************************************************
*>  This file is part of cobsha3.
*>
*>  TEST-SESSION-ID.cob is free software: you can redistribute it and/or 
*>  modify it under the terms of the GNU Lesser General Public License as 
*>  published by the Free Software Foundation, either version 3 of the License,
*>  or (at your option) any later version.
*>
*>  TEST-SESSION-ID.cob is distributed in the hope that it will be useful, 
*>  but WITHOUT ANY WARRANTY; without even the implied warranty of 
*>  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
*>  See the GNU Lesser General Public License for more details.
*>
*>  You should have received a copy of the GNU Lesser General Public License 
*>  along with TEST-SESSION-ID.cob.
*>  If not, see <http://www.gnu.org/licenses/>.
*>******************************************************************************

*>******************************************************************************
*> Program:      TEST-SESSION-ID.cob
*>
*> Purpose:      Test program for the SESSION-ID module
*>
*> Author:       Laszlo Erdos - https://www.facebook.com/wortfee
*>
*> Date-Written: 2018.05.10
*>
*> Tectonics:    cobc -x -W -free TEST-SESSION-ID.cob
*>
*> Usage:        ./TEST-SESSION-ID.exe
*>
*>******************************************************************************
*> Date       Name / Change description 
*> ========== ==================================================================
*> 2018.05.10 Laszlo Erdos: 
*>            - First version created.
*>------------------------------------------------------------------------------
*> yyyy.mm.dd
*>
*>******************************************************************************

 IDENTIFICATION DIVISION.
 PROGRAM-ID. TEST-SESSION-ID.

 ENVIRONMENT DIVISION.

 DATA DIVISION.
 WORKING-STORAGE SECTION.
 01 WS-IND-1                           BINARY-INT.

 01 LNK-SESSION-ID.
   02 LNK-INPUT.
     03 LNK-IP-ADDR                    PIC X(100).
   02 LNK-OUTPUT.
     03 LNK-SESSION-ID-BIN             PIC X(32).
     03 LNK-SESSION-ID-HEX             PIC X(64).
 
 PROCEDURE DIVISION.

*>------------------------------------------------------------------------------
 MAIN-TEST-SESSION-ID SECTION.
*>------------------------------------------------------------------------------

    INITIALIZE LNK-SESSION-ID

    DISPLAY " " END-DISPLAY
    DISPLAY "Input IP addr.: 79.205.33.120" 
    DISPLAY " " END-DISPLAY
            
    MOVE "79.205.33.120" TO LNK-IP-ADDR OF LNK-SESSION-ID

    PERFORM VARYING WS-IND-1 FROM 1 BY 1
            UNTIL   WS-IND-1 > 100
       PERFORM TEST-CALL
    END-PERFORM
    
    STOP RUN
    .

*>------------------------------------------------------------------------------
 TEST-CALL SECTION.
*>------------------------------------------------------------------------------
    
    CALL "SESSION-ID" USING LNK-SESSION-ID
    END-CALL

    DISPLAY "SESSION-ID-HEX: " LNK-SESSION-ID-HEX OF LNK-SESSION-ID END-DISPLAY
    .
    EXIT SECTION .
    
 END PROGRAM TEST-SESSION-ID.
