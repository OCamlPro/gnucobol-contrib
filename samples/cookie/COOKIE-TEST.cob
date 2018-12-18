*>******************************************************************************
*>  COOKIE-TEST.cob is free software: you can redistribute it and/or 
*>  modify it under the terms of the GNU Lesser General Public License as 
*>  published by the Free Software Foundation, either version 3 of the License,
*>  or (at your option) any later version.
*>
*>  COOKIE-TEST.cob is distributed in the hope that it will be useful, 
*>  but WITHOUT ANY WARRANTY; without even the implied warranty of 
*>  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
*>  See the GNU Lesser General Public License for more details.
*>
*>  You should have received a copy of the GNU Lesser General Public License 
*>  along with COOKIE-TEST.cob.
*>  If not, see <http://www.gnu.org/licenses/>.
*>******************************************************************************

*>******************************************************************************
*> Program:      COOKIE-TEST.cob
*>
*> Purpose:      Test program for COOKIE.cob
*>
*> Author:       Laszlo Erdos - https://www.facebook.com/wortfee
*>
*> Date-Written: 2018-12-18
*>
*> Tectonics:    see the makefile
*>
*>******************************************************************************
*> Date       Name / Change description 
*> ========== ==================================================================
*> 2018-12-18 First version.
*>------------------------------------------------------------------------------
*>
*>******************************************************************************

 IDENTIFICATION DIVISION.
 PROGRAM-ID. COOKIE-TEST.

 ENVIRONMENT DIVISION.

 DATA DIVISION.
 WORKING-STORAGE SECTION.

 01 LNK-COOKIE.
   02 LNK-INPUT.
     03 LNK-COOKIE-FUNC                PIC X(3).
       88 V-SET                        VALUE "SET".
       88 V-DEL                        VALUE "DEL".
     03 LNK-COOKIE-NAME                PIC X(100).
     03 LNK-COOKIE-VALUE               PIC X(256).
     03 LNK-MAX-AGE-SEC                PIC 9(10).
     03 LNK-DOMAIN-VALUE               PIC X(256).
     03 LNK-PATH-VALUE                 PIC X(256).
     03 LNK-SECURE-FLAG                PIC 9(1).
       88 V-NO                         VALUE 0.
       88 V-YES                        VALUE 1.
     03 LNK-HTTPONLY-FLAG              PIC 9(1).
       88 V-NO                         VALUE 0.
       88 V-YES                        VALUE 1.
     03 LNK-SAMESITE-FLAG              PIC 9(1).
       88 V-NO                         VALUE 0.
       88 V-YES-LAX                    VALUE 1.
       88 V-YES-STRICT                 VALUE 2.
   02 LNK-OUTPUT.
     03 LNK-COOKIE-STR                 PIC X(1024).

 PROCEDURE DIVISION.
 
*>------------------------------------------------------------------------------
 COOKIE-TEST-MAIN SECTION.
*>------------------------------------------------------------------------------

    PERFORM SET-COOKIE-TEST

    PERFORM DEL-COOKIE-TEST
    
    STOP RUN
    .
    
*>------------------------------------------------------------------------------
 SET-COOKIE-TEST SECTION.
*>------------------------------------------------------------------------------

    DISPLAY " " END-DISPLAY
    DISPLAY "Set Cookie Test" END-DISPLAY
    DISPLAY " " END-DISPLAY

*>  test 1
    INITIALIZE LNK-COOKIE
    SET V-SET OF LNK-COOKIE-FUNC TO TRUE
    MOVE "NAME01"        TO LNK-COOKIE-NAME
    MOVE "VALUE01"       TO LNK-COOKIE-VALUE
    PERFORM CALL-COOKIE

*>  test 2
    INITIALIZE LNK-COOKIE
    SET V-SET OF LNK-COOKIE-FUNC TO TRUE
    MOVE "NAME02"        TO LNK-COOKIE-NAME
    MOVE "VALUE02"       TO LNK-COOKIE-VALUE
    MOVE 1800            TO LNK-MAX-AGE-SEC
    PERFORM CALL-COOKIE
    
*>  test 3
    INITIALIZE LNK-COOKIE
    SET V-SET OF LNK-COOKIE-FUNC TO TRUE
    MOVE "NAME03"        TO LNK-COOKIE-NAME
    MOVE "VALUE03"       TO LNK-COOKIE-VALUE
    MOVE 1800            TO LNK-MAX-AGE-SEC
    MOVE "freecobol.com" TO LNK-DOMAIN-VALUE
    PERFORM CALL-COOKIE

*>  test 4
    INITIALIZE LNK-COOKIE
    SET V-SET OF LNK-COOKIE-FUNC TO TRUE
    MOVE "NAME04"        TO LNK-COOKIE-NAME
    MOVE "VALUE04"       TO LNK-COOKIE-VALUE
    MOVE 1800            TO LNK-MAX-AGE-SEC
    MOVE "freecobol.com" TO LNK-DOMAIN-VALUE
    MOVE "/subfolder1"   TO LNK-PATH-VALUE
    PERFORM CALL-COOKIE

*>  test 5
    INITIALIZE LNK-COOKIE
    SET V-SET OF LNK-COOKIE-FUNC TO TRUE
    MOVE "NAME05"        TO LNK-COOKIE-NAME
    MOVE "VALUE05"       TO LNK-COOKIE-VALUE
    MOVE 1800            TO LNK-MAX-AGE-SEC
    MOVE "freecobol.com" TO LNK-DOMAIN-VALUE
    MOVE "/subfolder1"   TO LNK-PATH-VALUE
    SET V-YES OF LNK-SECURE-FLAG TO TRUE
    PERFORM CALL-COOKIE

*>  test 6
    INITIALIZE LNK-COOKIE
    SET V-SET OF LNK-COOKIE-FUNC TO TRUE
    MOVE "NAME06"        TO LNK-COOKIE-NAME
    MOVE "VALUE06"       TO LNK-COOKIE-VALUE
    MOVE 1800            TO LNK-MAX-AGE-SEC
    MOVE "freecobol.com" TO LNK-DOMAIN-VALUE
    MOVE "/subfolder1"   TO LNK-PATH-VALUE
    SET V-YES OF LNK-SECURE-FLAG TO TRUE
    SET V-YES OF LNK-HTTPONLY-FLAG TO TRUE
    PERFORM CALL-COOKIE

*>  test 7
    INITIALIZE LNK-COOKIE
    SET V-SET OF LNK-COOKIE-FUNC TO TRUE
    MOVE "NAME07"        TO LNK-COOKIE-NAME
    MOVE "VALUE07"       TO LNK-COOKIE-VALUE
    MOVE 1800            TO LNK-MAX-AGE-SEC
    MOVE "freecobol.com" TO LNK-DOMAIN-VALUE
    MOVE "/subfolder1"   TO LNK-PATH-VALUE
    SET V-YES OF LNK-SECURE-FLAG TO TRUE
    SET V-YES OF LNK-HTTPONLY-FLAG TO TRUE
    SET V-YES-LAX OF LNK-SAMESITE-FLAG TO TRUE
    PERFORM CALL-COOKIE

*>  test 8
    INITIALIZE LNK-COOKIE
    SET V-SET OF LNK-COOKIE-FUNC TO TRUE
    MOVE "NAME08"        TO LNK-COOKIE-NAME
    MOVE "VALUE08"       TO LNK-COOKIE-VALUE
    MOVE 1800            TO LNK-MAX-AGE-SEC
    MOVE "freecobol.com" TO LNK-DOMAIN-VALUE
    MOVE "/subfolder1"   TO LNK-PATH-VALUE
    SET V-YES OF LNK-SECURE-FLAG TO TRUE
    SET V-YES OF LNK-HTTPONLY-FLAG TO TRUE
    SET V-YES-STRICT OF LNK-SAMESITE-FLAG TO TRUE
    PERFORM CALL-COOKIE
    
    .
    EXIT SECTION .

*>------------------------------------------------------------------------------
 DEL-COOKIE-TEST SECTION.
*>------------------------------------------------------------------------------

    DISPLAY " " END-DISPLAY
    DISPLAY "Delete Cookie Test" END-DISPLAY
    DISPLAY " " END-DISPLAY

*>  test 9
    INITIALIZE LNK-COOKIE
    SET V-DEL OF LNK-COOKIE-FUNC TO TRUE
    MOVE "NAME08"        TO LNK-COOKIE-NAME
    MOVE "freecobol.com" TO LNK-DOMAIN-VALUE
    MOVE "/subfolder1"   TO LNK-PATH-VALUE
    PERFORM CALL-COOKIE

    .
    EXIT SECTION .

*>------------------------------------------------------------------------------
 CALL-COOKIE SECTION.
*>------------------------------------------------------------------------------

    CALL "COOKIE" USING LNK-COOKIE END-CALL
    
    DISPLAY FUNCTION TRIM(LNK-COOKIE-STR) END-DISPLAY

    .
    EXIT SECTION .
    
 END PROGRAM COOKIE-TEST.
