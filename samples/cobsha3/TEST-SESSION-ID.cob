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
     03 LNK-REMOTE-ADDR                PIC X(100).
     03 LNK-REMOTE-ADDR-FLAG           PIC 9.
       88 V-NO                         VALUE 0.
       88 V-YES                        VALUE 1.
     03 LNK-HTTP-USER-AGENT            PIC X(8000).
     03 LNK-HTTP-USER-AGENT-FLAG       PIC 9.
       88 V-NO                         VALUE 0.
       88 V-YES                        VALUE 1.
   02 LNK-OUTPUT.
     03 LNK-SESSION-ID-BIN             PIC X(64).
     03 LNK-SESSION-ID-HEX             PIC X(128).
     03 LNK-USER-AGENT-HASH-BIN        PIC X(64).
     03 LNK-USER-AGENT-HASH-HEX        PIC X(128).
 
 PROCEDURE DIVISION.

*>------------------------------------------------------------------------------
 MAIN-TEST-SESSION-ID SECTION.
*>------------------------------------------------------------------------------

*>  test SESSION-ID
    INITIALIZE LNK-SESSION-ID

    DISPLAY " " END-DISPLAY
    DISPLAY "Test SESSION-ID" END-DISPLAY
    DISPLAY "Input IP addr.: 79.205.32.185" 
    DISPLAY " " END-DISPLAY
            
    MOVE "79.205.32.185" TO LNK-REMOTE-ADDR OF LNK-SESSION-ID
    SET V-YES OF LNK-REMOTE-ADDR-FLAG OF LNK-SESSION-ID TO TRUE

    PERFORM VARYING WS-IND-1 FROM 1 BY 1
            UNTIL   WS-IND-1 > 10
       PERFORM TEST-CALL
       DISPLAY "SESSION-ID-HEX: " LNK-SESSION-ID-HEX OF LNK-SESSION-ID END-DISPLAY
    END-PERFORM

    DISPLAY "-------------------------------------------------" END-DISPLAY
    DISPLAY " " END-DISPLAY

*>  test USER-AGENT-HASH 1
    INITIALIZE LNK-SESSION-ID

    DISPLAY " " END-DISPLAY
    DISPLAY "Test USER-AGENT-HASH 1" END-DISPLAY
    DISPLAY "Input HTTP-USER-AGENT: "
            "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:60.0) Gecko/20100101 "
            "Firefox/60.0" END-DISPLAY   
    DISPLAY " " END-DISPLAY
            
    MOVE "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:60.0) Gecko/20100101 Firefox/60.0 "
      TO LNK-HTTP-USER-AGENT OF LNK-SESSION-ID
    SET V-YES OF LNK-HTTP-USER-AGENT-FLAG OF LNK-SESSION-ID TO TRUE

    PERFORM TEST-CALL
    
    DISPLAY "USER-AGENT-HASH-HEX: " LNK-USER-AGENT-HASH-HEX OF LNK-SESSION-ID
    END-DISPLAY
    DISPLAY "-------------------------------------------------" END-DISPLAY
    DISPLAY " " END-DISPLAY

*>  test USER-AGENT-HASH 2
    INITIALIZE LNK-SESSION-ID

    DISPLAY " " END-DISPLAY
    DISPLAY "Test USER-AGENT-HASH 2" END-DISPLAY
    DISPLAY "Input HTTP-USER-AGENT: "
            "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) "
            "Chrome/64.0.3282.140 Safari/537.36 Edge/17.17134"
             END-DISPLAY   
    DISPLAY " " END-DISPLAY
            
    MOVE "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/64.0.3282.140 Safari/537.36 Edge/17.17134"
      TO LNK-HTTP-USER-AGENT OF LNK-SESSION-ID
    SET V-YES OF LNK-HTTP-USER-AGENT-FLAG OF LNK-SESSION-ID TO TRUE

    PERFORM TEST-CALL
    
    DISPLAY "USER-AGENT-HASH-HEX: " LNK-USER-AGENT-HASH-HEX OF LNK-SESSION-ID
    END-DISPLAY
    DISPLAY "-------------------------------------------------" END-DISPLAY
    DISPLAY " " END-DISPLAY

*>  test USER-AGENT-HASH 3
    INITIALIZE LNK-SESSION-ID

    DISPLAY " " END-DISPLAY
    DISPLAY "Test USER-AGENT-HASH 3" END-DISPLAY
    DISPLAY "Input HTTP-USER-AGENT: "
            "Mozilla/5.0 (Windows NT 10.0; WOW64; Trident/7.0; rv:11.0) like Gecko"
             END-DISPLAY   
    DISPLAY " " END-DISPLAY
            
    MOVE "Mozilla/5.0 (Windows NT 10.0; WOW64; Trident/7.0; rv:11.0) like Gecko"
      TO LNK-HTTP-USER-AGENT OF LNK-SESSION-ID
    SET V-YES OF LNK-HTTP-USER-AGENT-FLAG OF LNK-SESSION-ID TO TRUE

    PERFORM TEST-CALL
    
    DISPLAY "USER-AGENT-HASH-HEX: " LNK-USER-AGENT-HASH-HEX OF LNK-SESSION-ID
    END-DISPLAY
    DISPLAY "-------------------------------------------------" END-DISPLAY
    DISPLAY " " END-DISPLAY

*>  test SESSION-ID and USER-AGENT-HASH
    INITIALIZE LNK-SESSION-ID

    DISPLAY " " END-DISPLAY
    DISPLAY "Test SESSION-ID and USER-AGENT-HASH" END-DISPLAY
    DISPLAY "Input IP addr.: 79.205.32.185" 
    DISPLAY "Input HTTP-USER-AGENT: "
            "Mozilla/5.0 (Windows NT 10.0; WOW64; Trident/7.0; rv:11.0) like Gecko"
             END-DISPLAY   
    DISPLAY " " END-DISPLAY
            
    MOVE "79.205.32.185" 
      TO LNK-REMOTE-ADDR     OF LNK-SESSION-ID
    SET V-YES OF LNK-REMOTE-ADDR-FLAG     OF LNK-SESSION-ID TO TRUE

    MOVE "Mozilla/5.0 (Windows NT 10.0; WOW64; Trident/7.0; rv:11.0) like Gecko"
      TO LNK-HTTP-USER-AGENT OF LNK-SESSION-ID
    SET V-YES OF LNK-HTTP-USER-AGENT-FLAG OF LNK-SESSION-ID TO TRUE

    PERFORM VARYING WS-IND-1 FROM 1 BY 1
            UNTIL   WS-IND-1 > 5
       PERFORM TEST-CALL
       DISPLAY "SESSION-ID-HEX     : " LNK-SESSION-ID-HEX      OF LNK-SESSION-ID END-DISPLAY
       DISPLAY "USER-AGENT-HASH-HEX: " LNK-USER-AGENT-HASH-HEX OF LNK-SESSION-ID END-DISPLAY
    DISPLAY " " END-DISPLAY
    END-PERFORM

    DISPLAY "-------------------------------------------------" END-DISPLAY
    DISPLAY " " END-DISPLAY
    
    STOP RUN
    .

*>------------------------------------------------------------------------------
 TEST-CALL SECTION.
*>------------------------------------------------------------------------------
    
    CALL "SESSION-ID" USING LNK-SESSION-ID END-CALL
    .
    EXIT SECTION .
    
 END PROGRAM TEST-SESSION-ID.
