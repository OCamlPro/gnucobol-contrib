*>******************************************************************************
*>  parse-json.cob is free software: you can redistribute it and/or 
*>  modify it under the terms of the GNU Lesser General Public License as 
*>  published by the Free Software Foundation, either version 3 of the License,
*>  or (at your option) any later version.
*>
*>  parse-json.cob is distributed in the hope that it will be useful, 
*>  but WITHOUT ANY WARRANTY; without even the implied warranty of 
*>  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
*>  See the GNU Lesser General Public License for more details.
*>
*>  You should have received a copy of the GNU Lesser General Public License 
*>  along with parse-json.cob.
*>  If not, see <http://www.gnu.org/licenses/>.
*>******************************************************************************

*>******************************************************************************
*> Program:      parse-json.cob
*>
*> Purpose:      cJSON parser
*>
*> Author:       Laszlo Erdos - https://www.facebook.com/wortfee
*>
*> Date-Written: 2025-01-02
*>
*> Tectonics:    see the makefile
*>
*>******************************************************************************
*> Date       Name / Change description 
*> ========== ==================================================================
*> 2025-01-02 First version.
*>------------------------------------------------------------------------------
*>
*>******************************************************************************

 IDENTIFICATION DIVISION.
 PROGRAM-ID. parse-json.

 ENVIRONMENT DIVISION.
 CONFIGURATION SECTION.
 REPOSITORY.
    FUNCTION ALL INTRINSIC.
 
 DATA DIVISION.
 WORKING-STORAGE SECTION.
 78 C-JSON-MAX-LEN                     VALUE 1000.

 01 JSON-ROOT                          USAGE POINTER.
 01 JSON-OBJECT                        USAGE POINTER.
 01 JSON-FIELD                         USAGE POINTER.
 01 JSON-OUT                           USAGE POINTER.

 01 CJSON                              BASED.
    05 JSON-NEXT                       USAGE POINTER.
    05 JSON-PREV                       USAGE POINTER.
    05 JSON-CHILD                      USAGE POINTER.
    05 JSON-TYPE                       USAGE BINARY-LONG SYNC.
    05 VALUESTRING                     USAGE POINTER     SYNC.
    05 VALUEINT                        USAGE BINARY-LONG SYNC.
    05 VALUEDOUBLE                     USAGE FLOAT-LONG  SYNC.
    05 JSON-NAME                       USAGE POINTER     SYNC.

 01 WS-TMP-STR                   BASED PIC X(30).

 LINKAGE SECTION.
 01 LNK-PARSE-JSON.
   02 LNK-INPUT.
     03 LNK-JSON-DATA                  PIC X(C-JSON-MAX-LEN).
     03 LNK-JSON-DATA-LEN              BINARY-LONG. 
   02 LNK-OUTPUT.                      
     03 LNK-RESULT-FLAG                PIC 9(2).
        88 V-OK                        VALUE  0.
        88 V-NOT-OK                    VALUE  1.
     03 LNK-UPDATE-TIME-UTC            PIC X(25).
     03 LNK-USD-RATE                   PIC X(20).
     03 LNK-EUR-RATE                   PIC X(20).

 PROCEDURE DIVISION USING LNK-PARSE-JSON.
 
*>------------------------------------------------------------------------------
 MAIN-PARSE-JSON SECTION.
*>------------------------------------------------------------------------------

    INITIALIZE LNK-OUTPUT

*>  start parsing, allocate JSON structure
    PERFORM START-PARSE-JSON

*>  retrieve "time" / "updated"
    IF V-OK OF LNK-RESULT-FLAG
    THEN
       PERFORM GET-TIME-UPDATED
    END-IF

*>  retrieve "bpi" / "USD" / "rate"
    IF V-OK OF LNK-RESULT-FLAG
    THEN
       PERFORM GET-USD-RATE
    END-IF

*>  retrieve "bpi" / "EUR" / "rate"
    IF V-OK OF LNK-RESULT-FLAG
    THEN
       PERFORM GET-EUR-RATE
    END-IF

*>  always free the allocated JSON structure    
    PERFORM FREE-JSON-STRUCT

    GOBACK
    .

*>------------------------------------------------------------------------------
 START-PARSE-JSON SECTION.
*>------------------------------------------------------------------------------

*>  start parsing
    CALL STATIC "cJSON_Parse" 
         USING LNK-JSON-DATA(1:LNK-JSON-DATA-LEN)
         RETURNING JSON-ROOT
    END-CALL     

    IF JSON-ROOT = NULL
    THEN
       SET V-NOT-OK OF LNK-RESULT-FLAG TO TRUE
       DISPLAY "Error: start parsing"
       EXIT SECTION
    END-IF

    .
    EXIT SECTION .

*>------------------------------------------------------------------------------
 GET-TIME-UPDATED SECTION.
*>------------------------------------------------------------------------------

*>  retrieve "time" / "updated"
    CALL STATIC "cJSON_GetObjectItem" 
         USING BY VALUE JSON-ROOT
               BY REFERENCE z"time"
         RETURNING JSON-OBJECT
    END-CALL
   
    CALL STATIC "cJSON_GetObjectItem" 
         USING BY VALUE JSON-OBJECT
               BY REFERENCE z"updated"
         RETURNING JSON-FIELD
    END-CALL

    IF JSON-FIELD NOT = NULL 
    THEN
       SET ADDRESS OF CJSON      TO JSON-FIELD
       SET ADDRESS OF WS-TMP-STR TO VALUESTRING
       MOVE WS-TMP-STR(1:FUNCTION CONTENT-LENGTH(VALUESTRING)) TO LNK-UPDATE-TIME-UTC
    ELSE
       SET V-NOT-OK OF LNK-RESULT-FLAG TO TRUE
       DISPLAY "Error: retrieve time / updated"
       EXIT SECTION
    END-IF

    .
    EXIT SECTION .

*>------------------------------------------------------------------------------
 GET-USD-RATE SECTION.
*>------------------------------------------------------------------------------

*>  retrieve "bpi" / "USD" / "rate"
    CALL STATIC "cJSON_GetObjectItem" 
         USING BY VALUE JSON-ROOT
               BY REFERENCE z"bpi"
         RETURNING JSON-OBJECT
    END-CALL
   
    CALL STATIC "cJSON_GetObjectItem" 
         USING BY VALUE JSON-OBJECT
               BY REFERENCE z"USD"
         RETURNING JSON-OBJECT
    END-CALL

    CALL STATIC "cJSON_GetObjectItem" 
         USING BY VALUE JSON-OBJECT
               BY REFERENCE z"rate"
         RETURNING JSON-FIELD
    END-CALL

    IF JSON-FIELD NOT = NULL 
    THEN
       SET ADDRESS OF CJSON      TO JSON-FIELD
       SET ADDRESS OF WS-TMP-STR TO VALUESTRING
       MOVE WS-TMP-STR(1:FUNCTION CONTENT-LENGTH(VALUESTRING)) TO LNK-USD-RATE
    ELSE
       SET V-NOT-OK OF LNK-RESULT-FLAG TO TRUE
       DISPLAY "Error: retrieve bpi / USD / rate"
       EXIT SECTION
    END-IF

    .
    EXIT SECTION .

*>------------------------------------------------------------------------------
 GET-EUR-RATE SECTION.
*>------------------------------------------------------------------------------

*>  retrieve "bpi" / "EUR" / "rate"
    CALL STATIC "cJSON_GetObjectItem" 
         USING BY VALUE JSON-ROOT
               BY REFERENCE z"bpi"
         RETURNING JSON-OBJECT
    END-CALL
   
    CALL STATIC "cJSON_GetObjectItem" 
         USING BY VALUE JSON-OBJECT
               BY REFERENCE z"EUR"
         RETURNING JSON-OBJECT
    END-CALL

    CALL STATIC "cJSON_GetObjectItem" 
         USING BY VALUE JSON-OBJECT
               BY REFERENCE z"rate"
         RETURNING JSON-FIELD
    END-CALL

    IF JSON-FIELD NOT = NULL 
    THEN
       SET ADDRESS OF CJSON      TO JSON-FIELD
       SET ADDRESS OF WS-TMP-STR TO VALUESTRING
       MOVE WS-TMP-STR(1:FUNCTION CONTENT-LENGTH(VALUESTRING)) TO LNK-EUR-RATE
    ELSE
       SET V-NOT-OK OF LNK-RESULT-FLAG TO TRUE
       DISPLAY "Error: retrieve bpi / EUR / rate"
       EXIT SECTION
    END-IF

    .
    EXIT SECTION .

*>------------------------------------------------------------------------------
 FREE-JSON-STRUCT SECTION.
*>------------------------------------------------------------------------------

*>  free the entire structure
    CALL STATIC "cJSON_Delete" 
         USING BY VALUE JSON-ROOT
         RETURNING OMITTED
    END-CALL

    .
    EXIT SECTION .
 
 END PROGRAM parse-json.
