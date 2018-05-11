*>******************************************************************************
*>  This file is part of cobsha3.
*>
*>  SESSION-ID.cob is free software: you can redistribute it and/or 
*>  modify it under the terms of the GNU Lesser General Public License as 
*>  published by the Free Software Foundation, either version 3 of the License,
*>  or (at your option) any later version.
*>
*>  SESSION-ID.cob is distributed in the hope that it will be useful, 
*>  but WITHOUT ANY WARRANTY; without even the implied warranty of 
*>  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
*>  See the GNU Lesser General Public License for more details.
*>
*>  You should have received a copy of the GNU Lesser General Public License 
*>  along with SESSION-ID.cob.
*>  If not, see <http://www.gnu.org/licenses/>.
*>******************************************************************************

*>******************************************************************************
*> Program:      SESSION-ID.cob
*>
*> Purpose:      This module computes a session ID with SHA3-256. 
*>
*> Author:       Laszlo Erdos - https://www.facebook.com/wortfee
*>
*> Date-Written: 2018.05.10
*>
*> Tectonics:    cobc -m -free SESSION-ID.cob SHA3-256.o KECCAK.o
*>
*> Usage:        Call this module in your web application. It creates a session
*>               ID from the IP address of the visitor. This is the REMOTE_ADDR 
*>               CGI Environment Variable. To the IP address will be append a
*>               timestamp and a random number. After it will be SHA3-256 
*>               called to create a hash. The output hash is available in binary
*>               and in hexadecimal format.
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
 PROGRAM-ID. SESSION-ID.

 ENVIRONMENT DIVISION.

 DATA DIVISION.
 WORKING-STORAGE SECTION.
 01 WS-SHA3-256-INPUT                  PIC X(200).
 01 WS-SHA3-256-INPUT-BYTE-LEN         BINARY-DOUBLE UNSIGNED.
 01 WS-SHA3-256-OUTPUT                 PIC X(32).

 01 WS-CURRENT-DATE-AND-TIME           PIC X(21). 
 01 WS-CDT REDEFINES WS-CURRENT-DATE-AND-TIME.
   02 WS-CDT-DATE-AND-TIME             PIC 9(16).
   02 WS-CDT-GMT-DIFF                  PIC S9(4).

 01 WS-RANDOM-NR                       PIC 9V9(37).  
 01 WS-RND-NR-RE REDEFINES WS-RANDOM-NR.
   02 WS-RND-DOT                       PIC X(1).
   02 WS-RND-NR                        PIC X(37).
   
*> for clock_gettime   
 01 CLOCK-MONOTONIC                    BINARY-LONG VALUE 1.
 01 TIME-SPEC.
   02 TV-SEC                           BINARY-DOUBLE SIGNED.
   02 TV-NSEC                          BINARY-DOUBLE SIGNED.
 01 WS-TV-SEC                          PIC S9(21).
 01 WS-TV-NSEC                         PIC S9(21).
   
*> for converting num to hex   
 01 WS-NUM2HEX-IN                      PIC 9(2) COMP-5.
 01 WS-NUM2HEX-OUT                     PIC X(2).
 01 WS-NUM2HEX-QUOTIENT                PIC 9(2) COMP-5.
 01 WS-NUM2HEX-REMAINDER               PIC 9(2) COMP-5.
 01 WS-HEX-CHAR                        PIC X(16) VALUE "0123456789ABCDEF".

 01 WS-IND-1                           BINARY-INT.
 01 WS-IND-2                           BINARY-INT.

 01 WS-NUM-DATA                        PIC X(32).
 01 WS-NUM-TABLE REDEFINES WS-NUM-DATA.
   02 WS-NUM                           PIC 9(2) COMP-5 OCCURS 32.
 
 01 WS-HEX-DATA                        PIC X(64).
 01 WS-HEX-TABLE REDEFINES WS-HEX-DATA.
   02 WS-HEX                           PIC X(2) OCCURS 32.
 
 LINKAGE SECTION.
 01 LNK-SESSION-ID.
   02 LNK-INPUT.
     03 LNK-IP-ADDR                    PIC X(100).
   02 LNK-OUTPUT.
     03 LNK-SESSION-ID-BIN             PIC X(32).
     03 LNK-SESSION-ID-HEX             PIC X(64).
 
 PROCEDURE DIVISION USING LNK-SESSION-ID.          

*>------------------------------------------------------------------------------
 MAIN-SESSION-ID SECTION.
*>------------------------------------------------------------------------------

*>  init fields
    INITIALIZE WS-SHA3-256-INPUT
    INITIALIZE WS-SHA3-256-OUTPUT
    INITIALIZE WS-CURRENT-DATE-AND-TIME
    INITIALIZE WS-RANDOM-NR

*>  current-date is not enough, we need nano sec also   
    MOVE FUNCTION CURRENT-DATE TO WS-CURRENT-DATE-AND-TIME
*>  get sec and nano sec  
    PERFORM GETTIME
*>  get random number with a seed of nano sec   
    MOVE FUNCTION RANDOM(WS-TV-NSEC) TO WS-RANDOM-NR

*>  string all together    
    STRING LNK-IP-ADDR OF LNK-SESSION-ID DELIMITED BY SPACE
           WS-CDT-DATE-AND-TIME          DELIMITED BY SIZE
           WS-RND-NR                     DELIMITED BY SPACE
           WS-TV-SEC                     DELIMITED BY SIZE
           WS-TV-NSEC                    DELIMITED BY SIZE
      INTO WS-SHA3-256-INPUT
    END-STRING  
    
    MOVE FUNCTION STORED-CHAR-LENGTH(WS-SHA3-256-INPUT) 
      TO WS-SHA3-256-INPUT-BYTE-LEN    
      
*>  compute the hash      
    CALL "SHA3-256" USING WS-SHA3-256-INPUT
                          WS-SHA3-256-INPUT-BYTE-LEN
                          WS-SHA3-256-OUTPUT
    END-CALL

    MOVE WS-SHA3-256-OUTPUT TO LNK-SESSION-ID-BIN OF LNK-SESSION-ID
    
*>  convert in hexa
    MOVE WS-SHA3-256-OUTPUT TO WS-NUM-DATA
    PERFORM DATA-BUFF-IN-HEXA
    MOVE WS-HEX-DATA        TO LNK-SESSION-ID-HEX OF LNK-SESSION-ID

    GOBACK
    .

*>----------------------------------------------------------------------
 GETTIME SECTION.
*>----------------------------------------------------------------------

    CALL STATIC "clock_gettime" 
          USING BY VALUE     CLOCK-MONOTONIC 
                BY REFERENCE TIME-SPEC
    END-CALL                           

    MOVE TV-SEC  OF TIME-SPEC TO WS-TV-SEC
    MOVE TV-NSEC OF TIME-SPEC TO WS-TV-NSEC
    .
    EXIT SECTION .
    
*>----------------------------------------------------------------------
 DATA-BUFF-IN-HEXA SECTION.
*>----------------------------------------------------------------------

    INITIALIZE WS-HEX-DATA
    
    PERFORM VARYING WS-IND-1 FROM 1 BY 1
            UNTIL   WS-IND-1 > 32

       MOVE WS-NUM(WS-IND-1) TO WS-NUM2HEX-IN
       PERFORM NUM2HEX
       MOVE WS-NUM2HEX-OUT   TO WS-HEX(WS-IND-1)  
    END-PERFORM
    .
    EXIT SECTION .
    
*>----------------------------------------------------------------------
 NUM2HEX SECTION.
*>----------------------------------------------------------------------

    INITIALIZE WS-NUM2HEX-OUT

    PERFORM VARYING WS-IND-2 FROM 2 BY -1
            UNTIL   WS-IND-2 < 1

       DIVIDE WS-NUM2HEX-IN BY 16
          GIVING    WS-NUM2HEX-QUOTIENT
          REMAINDER WS-NUM2HEX-REMAINDER
       END-DIVIDE

       ADD 1 TO WS-NUM2HEX-REMAINDER

       MOVE WS-HEX-CHAR(WS-NUM2HEX-REMAINDER:1)
         TO WS-NUM2HEX-OUT(WS-IND-2:1)

       MOVE WS-NUM2HEX-QUOTIENT
         TO WS-NUM2HEX-IN
    END-PERFORM
    .
    EXIT SECTION .
    
 END PROGRAM SESSION-ID.
