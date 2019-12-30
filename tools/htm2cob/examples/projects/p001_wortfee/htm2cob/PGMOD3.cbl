      *>************************************************************************
      *>  This file is part of htm2cob.
      *>
      *>  PGMOD3.cob is free software: you can redistribute it and/or 
      *>  modify it under the terms of the GNU Lesser General Public License as 
      *>  published by the Free Software Foundation, either version 3 of the
      *>  License, or (at your option) any later version.
      *>
      *>  PGMOD3.cob is distributed in the hope that it will be useful, 
      *>  but WITHOUT ANY WARRANTY; without even the implied warranty of 
      *>  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
      *>  See the GNU Lesser General Public License for more details.
      *>
      *>  You should have received a copy of the GNU Lesser General Public  
      *>  License along with PGMOD3.cob.
      *>  If not, see <http://www.gnu.org/licenses/>.
      *>************************************************************************
      
      *>************************************************************************
      *> Program:      PGMOD3.cbl
      *>
      *> Purpose:      PostgreSQL module
      *>
      *> Author:       Laszlo Erdos - https://www.facebook.com/wortfee
      *>
      *> Date-Written: 2019.12.23
      *>
      *> Usage:        To use this module, simply CALL it as follows: 
      *>               CALL "PGMOD3" USING LN-MOD3
      *>
      *>************************************************************************
      *> Date       Name / Change description 
      *> ========== ============================================================
      *> 2019.12.23 Laszlo Erdos: 
      *>            - first version. 
      *>************************************************************************

       IDENTIFICATION DIVISION.
       PROGRAM-ID. PGMOD3.
      
       ENVIRONMENT DIVISION.
      
       DATA DIVISION.
       WORKING-STORAGE SECTION.
      *> SQL communication area
       COPY "sqlca.cbl".
       
      *> SQL status
       01 WS-SQL-STATUS                PIC S9(9) COMP-5.
          88 SQL-STATUS-OK             VALUE    0.
          88 SQL-STATUS-NOT-FOUND      VALUE  100.
          88 SQL-STATUS-DUP            VALUE -239, -403.
       
      *> SQL declare variables 
       EXEC SQL BEGIN DECLARE SECTION END-EXEC.
      *> host variables
       01 HV-WF-SESSION.
         05 HV-SESS-SESSION-ID-HEX     PIC X(128).   
         05 HV-SESS-NICKNAME           PIC X(15).    
         05 HV-SESS-LANGUAGES          PIC X(5).     
         05 HV-SESS-LEVEL              PIC 9(1).     
         05 HV-SESS-QUESTION-COUNT     PIC 9(6).     
         05 HV-SESS-ANSWER-OK-COUNT    PIC 9(6).     
         05 HV-SESS-SUCCESS-0          PIC 9(4).     
         05 HV-SESS-SUCCESS-1          PIC 9(4).     
         05 HV-SESS-SUCCESS-2          PIC 9(4).     
         05 HV-SESS-SUCCESS-3          PIC 9(4).     
         05 HV-SESS-SUCCESS-4          PIC 9(4).     
         05 HV-SESS-SUCCESS-5          PIC 9(4).     
         05 HV-SESS-MAX-USER-WORD      PIC 9(4).
         05 HV-SESS-USER-WORD-TABLE    PIC X(15000). 
         05 HV-SESS-CURR-IMG-NR        PIC 9(1).     
         05 HV-SESS-CURR-WORD-NR       PIC 9(4).     
         05 HV-SESS-LAST-WORD-NR-1     PIC 9(4).     
         05 HV-SESS-LAST-WORD-NR-2     PIC 9(4).     
         05 HV-SESS-INSERT-TIMESTAMP   PIC X(26).    
         05 HV-SESS-LUPD-TIMESTAMP     PIC X(26).    
         05 HV-SESS-LUPD-COUNTER       PIC 9(6).     
                                                     
       01 HV-WF-DICTIONARY.                          
         05 HV-DICT-WORD-NR            PIC 9(4).     
         05 HV-DICT-IMAGE              PIC X(80).     
         05 HV-DICT-WORD-DE            PIC X(80).     
         05 HV-DICT-WORD-EN            PIC X(80).     
         05 HV-DICT-WORD-HU            PIC X(80).     

       01 HV-WF-GUESTLIST.                          
         05 HV-GLST-SESSION-ID-HEX     PIC X(128).
         05 HV-GLST-START-TIMESTAMP    PIC X(26).
         05 HV-GLST-END-TIMESTAMP      PIC X(26).
         05 HV-GLST-NICKNAME           PIC X(15).
         05 HV-GLST-LANGUAGES          PIC X(5).
         05 HV-GLST-LEVEL              PIC 9(1).
         05 HV-GLST-QUESTION-COUNT     PIC 9(6).
         05 HV-GLST-ANSWER-OK-COUNT    PIC 9(6).
         05 HV-GLST-MAX-USER-WORD      PIC 9(4).
         05 HV-GLST-INSERT-TIMESTAMP   PIC X(26).

       01 HV-SESS-LUPD-TIMESTAMP-SAVE  PIC X(26).    
       01 HV-SESS-LUPD-COUNTER-SAVE    PIC 9(6).     

       01 HV-WF-SESSION-COUNT          PIC 9(6).     
                                                     
      *> connect fields 
       01 HV-DBNAME                    PIC X(20) VALUE SPACE.
       01 HV-USERID                    PIC X(20) VALUE SPACE.
       01 HV-PSWD                      PIC X(20) VALUE SPACE.
       EXEC SQL END   DECLARE SECTION END-EXEC.
       
      *> indices for cycles
       01 WS-IND-1                     PIC S9(4) COMP.
       01 WS-IND-2                     PIC S9(4) COMP.
       01 WS-WORD-IND                  PIC 9(4).

       01 WS-WORD-FOUND                PIC 9(1).
          88 V-NO                      VALUE 0.
          88 V-YES                     VALUE 1.
          
       01 WS-SUCCESS-GROUP-PERCENT     PIC 9(3).
       01 WS-SUCCESS-GROUP             PIC 9(1).
       01 WS-SUCCESS-GROUP-MAX-NR      PIC 9(4).
       01 WS-SUCCESS-GROUP-FOUND       PIC 9(1).
          88 V-NO                      VALUE 0.
          88 V-YES                     VALUE 1.

      *> for clock_gettime
       01 CLOCK-MONOTONIC              BINARY-LONG VALUE 1.
       01 TIME-SPEC.
         02 TV-SEC                     BINARY-DOUBLE SIGNED.
         02 TV-NSEC                    BINARY-DOUBLE SIGNED.
       01 WS-TV-SEC                    PIC S9(21).
       01 WS-TV-NSEC                   PIC S9(21).
       
       01 WS-RANDOM-NR                 PIC 9V9(37).
       
       01 WS-LOG-TXT                   PIC X(30).

       01 WS-LANGUAGE                  PIC X(5).    
       01 WS-LANGUAGE-R REDEFINES WS-LANGUAGE.
         02 WS-LANGUAGE-Q              PIC X(2).
            88 V-DE                    VALUE "DE".
            88 V-EN                    VALUE "EN".
            88 V-HU                    VALUE "HU".
         02 FILLER                     PIC X(1).
         02 WS-LANGUAGE-A              PIC X(2).
            88 V-DE                    VALUE "DE".
            88 V-EN                    VALUE "EN".
            88 V-HU                    VALUE "HU".

      *> selected WORD-NR from the WF_DICTIONARY table
       78 C-MAX-WORD-NR                VALUE 3000.  
       01 WS-WORD-NR-TABLE.
         02 WS-WORD-NR-TAB OCCURS 3000 TIMES.
           03 WS-WORD-NR-TAB-LINE.
             04 WS-WORD-NR             PIC 9(4).
             04 WS-SUCCESS-NR          PIC 9(1).
       
       LINKAGE SECTION.
       01 LN-MOD3.
         02 LN-INPUT.
           03 LN-SESSION-ID-HEX        PIC X(128).
           03 LN-SELECTED-IMG-NR       PIC 9(1).
         02 LN-OUTPUT.
           03 LN-RESULT-FLAG           PIC 9(1).
              88 V-OK                  VALUE 0.
              88 V-NOT-OK              VALUE 1.
           03 LN-COMPLETED-FLAG        PIC 9(1).
              88 V-NO                  VALUE 0.
              88 V-YES                 VALUE 1.
           03 LN-NICKNAME              PIC X(15).    
           03 LN-LANGUAGES             PIC X(5).     
           03 LN-LEVEL                 PIC 9(1).     
           03 LN-START-TIME            PIC X(19).     
           03 LN-GUEST-COUNT           PIC 9(6).     
           03 LN-QUESTION-COUNT        PIC 9(6).     
           03 LN-ANSWER-OK-COUNT       PIC 9(6).     
           03 LN-SUCCESS-0             PIC 9(4).     
           03 LN-SUCCESS-1             PIC 9(4).     
           03 LN-SUCCESS-2             PIC 9(4).     
           03 LN-SUCCESS-3             PIC 9(4).     
           03 LN-SUCCESS-4             PIC 9(4).     
           03 LN-SUCCESS-5             PIC 9(4).     
           03 LN-MAX-USER-WORD         PIC 9(4).
           03 LN-QUESTION-WORD         PIC X(80).     
           03 LN-QUESTION-IMG-NR       PIC 9(1).     
           03 LN-WORD-TABLE.
             04 LN-WORD-TAB OCCURS 6 TIMES.
               05 LN-WORD-TAB-LINE.
                 06 LN-WORD-NR         PIC 9(4).
                 06 LN-IMAGE           PIC X(80).
                 06 LN-WORD            PIC X(80).
       
       PROCEDURE DIVISION USING LN-MOD3.
      
      *>------------------------------------------------------------------------
       MAIN-PGMOD3 SECTION.
      *>------------------------------------------------------------------------

      *>  If OCDB_LOGLEVEL is set, then the file ocesql.log is created under \tmp
      *>  Possible values:
      *>  - nothing to set -> same as NOLOG
      *>  - NOLOG or nolog
      *>  - ERR or err
      *>  - DEBUG or debug
      *>  DISPLAY "OCDB_LOGLEVEL" UPON ENVIRONMENT-NAME
      *>  DISPLAY "DEBUG" UPON ENVIRONMENT-VALUE

      *>  If you do not set the OCDB_DB_CHAR environment variable, then "SJIS" will be 
      *>  used as default. See ocesql.c in _ocesqlConnectMain() function.
      *>  If it is not set, then there are errors for example at duplacate key.
          DISPLAY "OCDB_DB_CHAR" UPON ENVIRONMENT-NAME
          DISPLAY "UTF8" UPON ENVIRONMENT-VALUE

      *>  only for test
      *>  MOVE SPACES TO WS-LOG-TXT
      *>  ACCEPT WS-LOG-TXT FROM ENVIRONMENT "OCDB_LOGLEVEL" 
      *>  DISPLAY "OCDB_LOGLEVEL: " WS-LOG-TXT
      *>
      *>  MOVE SPACES TO WS-LOG-TXT
      *>  ACCEPT WS-LOG-TXT FROM ENVIRONMENT "OCDB_DB_CHAR" 
      *>  DISPLAY "OCDB_DB_CHAR: " WS-LOG-TXT

      *>  only for test, the program must be compiled with
      *>  "-ftrace" switch (trace procedures) or
      *>  "-ftraceall" switch (trace procedures and statements)
      *>  DISPLAY "COB_SET_TRACE" UPON ENVIRONMENT-NAME
      *>  DISPLAY "Y" UPON ENVIRONMENT-VALUE
      *>  DISPLAY "COB_TRACE_FILE" UPON ENVIRONMENT-NAME
      *>  DISPLAY "/tmp/PGMOD3.log" UPON ENVIRONMENT-VALUE

          INITIALIZE LN-OUTPUT
      
          PERFORM CONNECT
          IF V-NOT-OK OF LN-RESULT-FLAG
          THEN
             EXIT SECTION
          END-IF
          
          IF V-OK OF LN-RESULT-FLAG
          THEN
             PERFORM SELECT-WF-SESSION
          END-IF

      *>  check if it completed, write in guest list
          IF V-OK OF LN-RESULT-FLAG
          THEN
             PERFORM CHECK-COMPLETED
          END-IF

          IF  V-OK OF LN-RESULT-FLAG
          AND V-NO OF LN-COMPLETED-FLAG
          THEN
             PERFORM PROCESS-REQUEST
          END-IF
          
          IF  V-OK OF LN-RESULT-FLAG
          AND V-NO OF LN-COMPLETED-FLAG
          THEN
             PERFORM UPDATE-WF-SESSION
          END-IF

          IF  V-OK OF LN-RESULT-FLAG
          AND V-NO OF LN-COMPLETED-FLAG
          THEN
             PERFORM SELECT-WF-SESSION-COUNT
          END-IF

      *>  check if it completed, write in guest list
          IF V-OK OF LN-RESULT-FLAG
          THEN
             PERFORM CHECK-COMPLETED
          END-IF
          
          PERFORM DISCONNECT
      
          GOBACK
      
          EXIT SECTION .

      *>------------------------------------------------------------------------
       CHECK-COMPLETED SECTION.
      *>------------------------------------------------------------------------

          IF  HV-SESS-SUCCESS-0 = 0
          AND HV-SESS-SUCCESS-1 = 0
          AND HV-SESS-SUCCESS-2 = 0
          AND HV-SESS-SUCCESS-3 = 0
          AND HV-SESS-SUCCESS-4 = 0
          AND HV-SESS-SUCCESS-5 = HV-SESS-MAX-USER-WORD
          THEN          
             SET V-YES OF LN-COMPLETED-FLAG TO TRUE
      *>     write in guest list       
             PERFORM INSERT-WF-GUESTLIST
          END-IF

          EXIT SECTION .

      *>------------------------------------------------------------------------
       PROCESS-REQUEST SECTION.
      *>------------------------------------------------------------------------

          IF LN-SELECTED-IMG-NR NOT = ZEROES
          THEN
             PERFORM CHECK-RESULT
          END-IF

          IF V-OK OF LN-RESULT-FLAG
          THEN
             PERFORM SEARCH-ANSWER-WORD
          END-IF

          IF V-OK OF LN-RESULT-FLAG
          THEN
             PERFORM SEARCH-QUESTION-WORD
          END-IF

          EXIT SECTION .

      *>------------------------------------------------------------------------
       CHECK-RESULT SECTION.
      *>------------------------------------------------------------------------

      *>  search word in internal table
          SET V-NO OF WS-WORD-FOUND TO TRUE
          PERFORM VARYING WS-IND-1 FROM 1 BY 1
            UNTIL WS-IND-1 > C-MAX-WORD-NR
            OR    WS-IND-1 > HV-SESS-MAX-USER-WORD
              IF WS-WORD-NR(WS-IND-1) = HV-SESS-CURR-WORD-NR           
              THEN
                 SET V-YES OF WS-WORD-FOUND TO TRUE
                 EXIT PERFORM
              END-IF            
          END-PERFORM  

          IF V-NO OF WS-WORD-FOUND
          THEN
             EXIT SECTION
          END-IF

          IF LN-SELECTED-IMG-NR = HV-SESS-CURR-IMG-NR
          THEN
      *>     answer OK    
             IF HV-SESS-ANSWER-OK-COUNT >= 999999
             THEN
      *>        reset counter
                MOVE ZEROES TO HV-SESS-ANSWER-OK-COUNT
             ELSE
                COMPUTE HV-SESS-ANSWER-OK-COUNT
                      = HV-SESS-ANSWER-OK-COUNT + 1
                END-COMPUTE
             END-IF          

             IF WS-SUCCESS-NR(WS-IND-1) >= 5
             THEN
                MOVE 5 
                  TO WS-SUCCESS-NR(WS-IND-1)
             ELSE
                COMPUTE WS-SUCCESS-NR(WS-IND-1)
                      = WS-SUCCESS-NR(WS-IND-1) + 1
                END-COMPUTE
             END-IF          
          ELSE          
      *>     answer not OK    
             MOVE ZEROES TO WS-SUCCESS-NR(WS-IND-1)          
          END-IF

          IF HV-SESS-QUESTION-COUNT >= 999999
          THEN
      *>     reset counter
             MOVE ZEROES TO HV-SESS-QUESTION-COUNT
          ELSE
             COMPUTE HV-SESS-QUESTION-COUNT
                   = HV-SESS-QUESTION-COUNT + 1
             END-COMPUTE
          END-IF          

      *>  write in linkage
          MOVE HV-SESS-QUESTION-COUNT  TO LN-QUESTION-COUNT
          MOVE HV-SESS-ANSWER-OK-COUNT TO LN-ANSWER-OK-COUNT

          EXIT SECTION .

      *>------------------------------------------------------------------------
       SEARCH-ANSWER-WORD SECTION.
      *>------------------------------------------------------------------------

      *>  get sec and nano sec
          PERFORM GETTIME
      *>  get random number with a seed of nano sec
          MOVE FUNCTION RANDOM(WS-TV-NSEC) TO WS-RANDOM-NR

          MOVE 1 TO WS-IND-1
          PERFORM UNTIL WS-IND-1 > 6
      *>     get random number
             MOVE FUNCTION RANDOM() TO WS-RANDOM-NR
             COMPUTE WS-WORD-IND = WS-RANDOM-NR 
                                 * HV-SESS-MAX-USER-WORD + 1
             END-COMPUTE

      *>     search word in linkage table
             SET V-NO OF WS-WORD-FOUND TO TRUE
             PERFORM VARYING WS-IND-2 FROM 1 BY 1
               UNTIL WS-IND-2 > 6
                 IF LN-WORD-NR(WS-IND-2) = 
                    WS-WORD-NR(WS-WORD-IND)
                 THEN
                    SET V-YES OF WS-WORD-FOUND TO TRUE
                 END-IF            
             END-PERFORM  

             IF  V-NO OF WS-WORD-FOUND
             AND WS-WORD-NR(WS-WORD-IND) NOT = HV-SESS-LAST-WORD-NR-1
             AND WS-WORD-NR(WS-WORD-IND) NOT = HV-SESS-LAST-WORD-NR-2
             THEN
                MOVE WS-WORD-NR(WS-WORD-IND) TO LN-WORD-NR(WS-IND-1)
                ADD 1 TO WS-IND-1 END-ADD
             END-IF   
          END-PERFORM  

          MOVE HV-SESS-LANGUAGES TO WS-LANGUAGE
          
          PERFORM VARYING WS-IND-1 FROM 1 BY 1
            UNTIL WS-IND-1 > 6
             INITIALIZE HV-WF-DICTIONARY
             MOVE LN-WORD-NR(WS-IND-1) TO HV-DICT-WORD-NR

             PERFORM SELECT-WF-DICTIONARY
             IF V-NOT-OK OF LN-RESULT-FLAG
             THEN
                EXIT SECTION
             END-IF

             MOVE HV-DICT-IMAGE TO LN-IMAGE(WS-IND-1)             
             
      *>     fill with selected language
             EVALUATE TRUE
                WHEN V-DE OF WS-LANGUAGE-A
                   MOVE HV-DICT-WORD-DE TO LN-WORD(WS-IND-1)
                WHEN V-EN OF WS-LANGUAGE-A
                   MOVE HV-DICT-WORD-EN TO LN-WORD(WS-IND-1)
                WHEN V-HU OF WS-LANGUAGE-A
                   MOVE HV-DICT-WORD-HU TO LN-WORD(WS-IND-1)
             END-EVALUATE
          END-PERFORM  

          EXIT SECTION .

      *>------------------------------------------------------------------------
       SEARCH-QUESTION-WORD SECTION.
      *>------------------------------------------------------------------------

          PERFORM SET-SUCCESS-STATISTICS

          SET V-NO OF WS-WORD-FOUND TO TRUE
          PERFORM UNTIL V-YES OF WS-WORD-FOUND
             PERFORM SEARCH-SUCCESS-GROUP

      *>     get random number
             MOVE FUNCTION RANDOM() TO WS-RANDOM-NR
             COMPUTE WS-IND-2 = WS-RANDOM-NR 
                              * WS-SUCCESS-GROUP-MAX-NR + 1
             END-COMPUTE

             INITIALIZE WS-IND-1
             PERFORM VARYING WS-WORD-IND FROM 1 BY 1
               UNTIL WS-WORD-IND > C-MAX-WORD-NR
               OR    WS-WORD-IND > HV-SESS-MAX-USER-WORD
                IF WS-SUCCESS-NR(WS-WORD-IND) = WS-SUCCESS-GROUP
                THEN
                   ADD 1 TO WS-IND-1 END-ADD
                   IF WS-IND-1 = WS-IND-2
                   THEN
                      EXIT PERFORM
                   END-IF
                END-IF
             END-PERFORM  
             
      *>     not last two words, and not in linkage yet
             IF  WS-WORD-NR(WS-WORD-IND) NOT = HV-SESS-CURR-WORD-NR
             AND WS-WORD-NR(WS-WORD-IND) NOT = HV-SESS-LAST-WORD-NR-1
             AND WS-WORD-NR(WS-WORD-IND) NOT = HV-SESS-LAST-WORD-NR-2
             AND WS-WORD-NR(WS-WORD-IND) NOT = LN-WORD-NR(1)
             AND WS-WORD-NR(WS-WORD-IND) NOT = LN-WORD-NR(2)
             AND WS-WORD-NR(WS-WORD-IND) NOT = LN-WORD-NR(3)
             AND WS-WORD-NR(WS-WORD-IND) NOT = LN-WORD-NR(4)
             AND WS-WORD-NR(WS-WORD-IND) NOT = LN-WORD-NR(5)
             AND WS-WORD-NR(WS-WORD-IND) NOT = LN-WORD-NR(6)
             THEN 
                SET V-YES OF WS-WORD-FOUND TO TRUE
      *>        shift last words          
                MOVE HV-SESS-LAST-WORD-NR-1  TO HV-SESS-LAST-WORD-NR-2
                MOVE HV-SESS-CURR-WORD-NR    TO HV-SESS-LAST-WORD-NR-1
                MOVE WS-WORD-NR(WS-WORD-IND) TO HV-SESS-CURR-WORD-NR
             END-IF
          END-PERFORM  

      *>  select question word  
          INITIALIZE HV-WF-DICTIONARY
          MOVE WS-WORD-NR(WS-WORD-IND) TO HV-DICT-WORD-NR
          
          PERFORM SELECT-WF-DICTIONARY
          IF V-NOT-OK OF LN-RESULT-FLAG
          THEN
             EXIT SECTION
          END-IF
          
      *>  fill with selected language
          EVALUATE TRUE
             WHEN V-DE OF WS-LANGUAGE-Q
                MOVE HV-DICT-WORD-DE TO LN-QUESTION-WORD
             WHEN V-EN OF WS-LANGUAGE-Q
                MOVE HV-DICT-WORD-EN TO LN-QUESTION-WORD
             WHEN V-HU OF WS-LANGUAGE-Q
                MOVE HV-DICT-WORD-HU TO LN-QUESTION-WORD
          END-EVALUATE
          
      *>  rewrite answer in linkage on a random position      
      *>  get random number
          MOVE FUNCTION RANDOM() TO WS-RANDOM-NR
          COMPUTE WS-IND-1 = WS-RANDOM-NR * 6 + 1
          END-COMPUTE

          MOVE HV-DICT-IMAGE TO LN-IMAGE(WS-IND-1)             
          
      *>  fill with selected language
          EVALUATE TRUE
             WHEN V-DE OF WS-LANGUAGE-A
                MOVE HV-DICT-WORD-DE TO LN-WORD(WS-IND-1)
             WHEN V-EN OF WS-LANGUAGE-A
                MOVE HV-DICT-WORD-EN TO LN-WORD(WS-IND-1)
             WHEN V-HU OF WS-LANGUAGE-A
                MOVE HV-DICT-WORD-HU TO LN-WORD(WS-IND-1)
          END-EVALUATE
          
          MOVE WS-IND-1 TO HV-SESS-CURR-IMG-NR
          MOVE WS-IND-1 TO LN-QUESTION-IMG-NR

          EXIT SECTION .
          
      *>------------------------------------------------------------------------
       SET-SUCCESS-STATISTICS SECTION.
      *>------------------------------------------------------------------------

          INITIALIZE HV-SESS-SUCCESS-0     
          INITIALIZE HV-SESS-SUCCESS-1     
          INITIALIZE HV-SESS-SUCCESS-2     
          INITIALIZE HV-SESS-SUCCESS-3     
          INITIALIZE HV-SESS-SUCCESS-4     
          INITIALIZE HV-SESS-SUCCESS-5     

          PERFORM VARYING WS-IND-1 FROM 1 BY 1
            UNTIL WS-IND-1 > C-MAX-WORD-NR
            OR    WS-IND-1 > HV-SESS-MAX-USER-WORD
             EVALUATE WS-SUCCESS-NR(WS-IND-1)
                WHEN 0
                   ADD 1 TO HV-SESS-SUCCESS-0 END-ADD
                WHEN 1
                   ADD 1 TO HV-SESS-SUCCESS-1 END-ADD
                WHEN 2
                   ADD 1 TO HV-SESS-SUCCESS-2 END-ADD
                WHEN 3
                   ADD 1 TO HV-SESS-SUCCESS-3 END-ADD
                WHEN 4
                   ADD 1 TO HV-SESS-SUCCESS-4 END-ADD
                WHEN 5
                   ADD 1 TO HV-SESS-SUCCESS-5 END-ADD
             END-EVALUATE 
          END-PERFORM  

          MOVE HV-SESS-SUCCESS-0 TO LN-SUCCESS-0
          MOVE HV-SESS-SUCCESS-1 TO LN-SUCCESS-1
          MOVE HV-SESS-SUCCESS-2 TO LN-SUCCESS-2
          MOVE HV-SESS-SUCCESS-3 TO LN-SUCCESS-3
          MOVE HV-SESS-SUCCESS-4 TO LN-SUCCESS-4
          MOVE HV-SESS-SUCCESS-5 TO LN-SUCCESS-5

          EXIT SECTION .

      *>------------------------------------------------------------------------
       SEARCH-SUCCESS-GROUP SECTION.
      *>------------------------------------------------------------------------

          SET V-NO OF WS-SUCCESS-GROUP-FOUND TO TRUE
          
          PERFORM UNTIL V-YES OF WS-SUCCESS-GROUP-FOUND
      *>     get random number
             MOVE FUNCTION RANDOM() TO WS-RANDOM-NR
            
             COMPUTE WS-SUCCESS-GROUP-PERCENT = WS-RANDOM-NR * 100
                                              + 1
             END-COMPUTE
            
      *>     search success group according to predefined %
             EVALUATE TRUE
                WHEN WS-SUCCESS-GROUP-PERCENT >= 1 
                 AND WS-SUCCESS-GROUP-PERCENT <= 35
                 AND HV-SESS-SUCCESS-0 > ZEROES
                   MOVE 0 TO WS-SUCCESS-GROUP 
                   MOVE HV-SESS-SUCCESS-0 TO WS-SUCCESS-GROUP-MAX-NR
                   SET V-YES OF WS-SUCCESS-GROUP-FOUND TO TRUE
                WHEN WS-SUCCESS-GROUP-PERCENT >= 36 
                 AND WS-SUCCESS-GROUP-PERCENT <= 60
                 AND HV-SESS-SUCCESS-1 > ZEROES
                   MOVE 1 TO WS-SUCCESS-GROUP              
                   MOVE HV-SESS-SUCCESS-1 TO WS-SUCCESS-GROUP-MAX-NR
                   SET V-YES OF WS-SUCCESS-GROUP-FOUND TO TRUE
                WHEN WS-SUCCESS-GROUP-PERCENT >= 61 
                 AND WS-SUCCESS-GROUP-PERCENT <= 78
                 AND HV-SESS-SUCCESS-2 > ZEROES
                   MOVE 2 TO WS-SUCCESS-GROUP              
                   MOVE HV-SESS-SUCCESS-2 TO WS-SUCCESS-GROUP-MAX-NR
                   SET V-YES OF WS-SUCCESS-GROUP-FOUND TO TRUE
                WHEN WS-SUCCESS-GROUP-PERCENT >= 79 
                 AND WS-SUCCESS-GROUP-PERCENT <= 88
                 AND HV-SESS-SUCCESS-3 > ZEROES
                   MOVE 3 TO WS-SUCCESS-GROUP              
                   MOVE HV-SESS-SUCCESS-3 TO WS-SUCCESS-GROUP-MAX-NR
                   SET V-YES OF WS-SUCCESS-GROUP-FOUND TO TRUE
                WHEN WS-SUCCESS-GROUP-PERCENT >= 89 
                 AND WS-SUCCESS-GROUP-PERCENT <= 96
                 AND HV-SESS-SUCCESS-4 > ZEROES
                   MOVE 4 TO WS-SUCCESS-GROUP              
                   MOVE HV-SESS-SUCCESS-4 TO WS-SUCCESS-GROUP-MAX-NR
                   SET V-YES OF WS-SUCCESS-GROUP-FOUND TO TRUE
                WHEN WS-SUCCESS-GROUP-PERCENT >= 97 
                 AND WS-SUCCESS-GROUP-PERCENT <= 100
                 AND HV-SESS-SUCCESS-5 > ZEROES
                   MOVE 5 TO WS-SUCCESS-GROUP       
                   MOVE HV-SESS-SUCCESS-5 TO WS-SUCCESS-GROUP-MAX-NR
                   SET V-YES OF WS-SUCCESS-GROUP-FOUND TO TRUE
             END-EVALUATE
          END-PERFORM          
                
          EXIT SECTION .

      *>------------------------------------------------------------------------
       GETTIME SECTION.
      *>------------------------------------------------------------------------
      
          CALL STATIC "clock_gettime"
                USING BY VALUE     CLOCK-MONOTONIC
                      BY REFERENCE TIME-SPEC
          END-CALL
      
          MOVE TV-SEC  OF TIME-SPEC TO WS-TV-SEC
          MOVE TV-NSEC OF TIME-SPEC TO WS-TV-NSEC
      
          EXIT SECTION .
          
      *>------------------------------------------------------------------------
       CONNECT SECTION.
      *>------------------------------------------------------------------------

      *>  MOVE "testdb"        TO HV-DBNAME
      *>  MOVE "Laszlo.Erdoes" TO HV-USERID
      *>  MOVE " "             TO HV-PSWD
          COPY "PGUSER.cpy".
       
          PERFORM SQL-CONNECT
          
          IF NOT SQL-STATUS-OK
          THEN
             SET V-NOT-OK OF LN-RESULT-FLAG TO TRUE
          END-IF
          
          EXIT SECTION .

      *>------------------------------------------------------------------------
       DISCONNECT SECTION.
      *>------------------------------------------------------------------------

          PERFORM SQL-DISCONNECT
          
          EXIT SECTION .

      *>------------------------------------------------------------------------
       SELECT-WF-SESSION SECTION.
      *>------------------------------------------------------------------------

          INITIALIZE HV-WF-SESSION

          MOVE LN-SESSION-ID-HEX
            TO HV-SESS-SESSION-ID-HEX  OF HV-WF-SESSION
      
          PERFORM SQL-SELECT-WF-SESSION

          EVALUATE TRUE
          WHEN     SQL-STATUS-OK
             PERFORM SQL-COMMIT
             MOVE HV-SESS-NICKNAME         OF HV-WF-SESSION
               TO LN-NICKNAME
             MOVE HV-SESS-LANGUAGES        OF HV-WF-SESSION
               TO LN-LANGUAGES
             MOVE HV-SESS-LEVEL            OF HV-WF-SESSION
               TO LN-LEVEL
             MOVE HV-SESS-MAX-USER-WORD    OF HV-WF-SESSION
               TO LN-MAX-USER-WORD
             MOVE HV-SESS-USER-WORD-TABLE  OF HV-WF-SESSION
               TO WS-WORD-NR-TABLE
             MOVE HV-SESS-INSERT-TIMESTAMP OF HV-WF-SESSION
               TO LN-START-TIME
             MOVE HV-SESS-LUPD-TIMESTAMP   OF HV-WF-SESSION
               TO HV-SESS-LUPD-TIMESTAMP-SAVE               
             MOVE HV-SESS-LUPD-COUNTER     OF HV-WF-SESSION
               TO HV-SESS-LUPD-COUNTER-SAVE                 
      
          WHEN     OTHER
             PERFORM SQL-ROLLBACK
             SET V-NOT-OK OF LN-RESULT-FLAG TO TRUE
             EXIT SECTION
          END-EVALUATE
          
          EXIT SECTION .

      *>------------------------------------------------------------------------
       SELECT-WF-SESSION-COUNT SECTION.
      *>------------------------------------------------------------------------

          INITIALIZE HV-WF-SESSION-COUNT

          PERFORM SQL-SELECT-WF-SESSION-COUNT

          EVALUATE TRUE
          WHEN     SQL-STATUS-OK
             PERFORM SQL-COMMIT
             MOVE HV-WF-SESSION-COUNT
               TO LN-GUEST-COUNT
      
          WHEN     OTHER
             PERFORM SQL-ROLLBACK
             SET V-NOT-OK OF LN-RESULT-FLAG TO TRUE
             EXIT SECTION
          END-EVALUATE
          
          EXIT SECTION .

      *>------------------------------------------------------------------------
       SELECT-WF-DICTIONARY SECTION.
      *>------------------------------------------------------------------------
      
          PERFORM SQL-SELECT-WF-DICTIONARY

          EVALUATE TRUE
          WHEN     SQL-STATUS-OK
             PERFORM SQL-COMMIT
      
          WHEN     OTHER
             PERFORM SQL-ROLLBACK
             SET V-NOT-OK OF LN-RESULT-FLAG TO TRUE
             EXIT SECTION
          END-EVALUATE
          
          EXIT SECTION .

      *>------------------------------------------------------------------------
       INSERT-WF-GUESTLIST SECTION.
      *>------------------------------------------------------------------------

          INITIALIZE HV-WF-GUESTLIST

          MOVE HV-SESS-SESSION-ID-HEX  
            TO HV-GLST-SESSION-ID-HEX  
          MOVE HV-SESS-INSERT-TIMESTAMP
            TO HV-GLST-START-TIMESTAMP 
          MOVE HV-SESS-LUPD-TIMESTAMP  
            TO HV-GLST-END-TIMESTAMP   
          MOVE HV-SESS-NICKNAME
            TO HV-GLST-NICKNAME  
          MOVE HV-SESS-LANGUAGES            
            TO HV-GLST-LANGUAGES       
          MOVE HV-SESS-LEVEL
            TO HV-GLST-LEVEL           
          MOVE HV-SESS-QUESTION-COUNT
            TO HV-GLST-QUESTION-COUNT  
          MOVE HV-SESS-ANSWER-OK-COUNT
            TO HV-GLST-ANSWER-OK-COUNT 
          MOVE HV-SESS-MAX-USER-WORD  
            TO HV-GLST-MAX-USER-WORD   
            
          PERFORM SQL-INSERT-WF-GUESTLIST

          EVALUATE TRUE
          WHEN     SQL-STATUS-OK
             PERFORM SQL-COMMIT
      
          WHEN     SQL-STATUS-DUP
      *>     it exists yet    
             PERFORM SQL-ROLLBACK
      
          WHEN     OTHER
             PERFORM SQL-ROLLBACK
             SET V-NOT-OK OF LN-RESULT-FLAG TO TRUE
             EXIT SECTION
          END-EVALUATE
          
          EXIT SECTION .

      *>------------------------------------------------------------------------
       UPDATE-WF-SESSION SECTION.
      *>------------------------------------------------------------------------

          MOVE WS-WORD-NR-TABLE 
            TO HV-SESS-USER-WORD-TABLE OF HV-WF-SESSION

      *>  last update counter
          IF HV-SESS-LUPD-COUNTER-SAVE >= 999999
          THEN
      *>     reset counter
             MOVE ZEROES TO HV-SESS-LUPD-COUNTER OF HV-WF-SESSION
          ELSE
             COMPUTE HV-SESS-LUPD-COUNTER OF HV-WF-SESSION
                   = HV-SESS-LUPD-COUNTER OF HV-WF-SESSION + 1
             END-COMPUTE
          END-IF          
            
          PERFORM SQL-UPDATE-WF-SESSION
          
          EVALUATE TRUE
          WHEN     SQL-STATUS-OK
             PERFORM SQL-COMMIT
      
          WHEN     OTHER
             PERFORM SQL-ROLLBACK
             SET V-NOT-OK OF LN-RESULT-FLAG TO TRUE
             EXIT SECTION
          END-EVALUATE

          EXIT SECTION .
          
      *>------------------------------------------------------------------------
       SQL-CONNECT SECTION.
      *>------------------------------------------------------------------------

          EXEC SQL  
               CONNECT       :HV-USERID 
               IDENTIFIED BY :HV-PSWD USING :HV-DBNAME 
          END-EXEC
          
          MOVE SQLCODE TO WS-SQL-STATUS

      *>  only for test   
      *>  DISPLAY SQLCODE  OF SQLCA
      *>  DISPLAY SQLSTATE OF SQLCA
          
          EXIT SECTION .
      
      *>------------------------------------------------------------------------
       SQL-DISCONNECT SECTION.
      *>------------------------------------------------------------------------

          EXEC SQL  
               DISCONNECT ALL
          END-EXEC
          
          MOVE SQLCODE TO WS-SQL-STATUS

      *>  only for test   
      *>  DISPLAY SQLCODE  OF SQLCA
      *>  DISPLAY SQLSTATE OF SQLCA
          
          EXIT SECTION .

      *>------------------------------------------------------------------------
       SQL-COMMIT SECTION.
      *>------------------------------------------------------------------------

          EXEC SQL  
               COMMIT
          END-EXEC
          
          MOVE SQLCODE TO WS-SQL-STATUS

      *>  only for test   
      *>  DISPLAY SQLCODE  OF SQLCA
      *>  DISPLAY SQLSTATE OF SQLCA
          
          EXIT SECTION .
          
      *>------------------------------------------------------------------------
       SQL-ROLLBACK SECTION.
      *>------------------------------------------------------------------------

          EXEC SQL  
               ROLLBACK
          END-EXEC

          MOVE SQLCODE TO WS-SQL-STATUS

      *>  only for test   
      *>  DISPLAY SQLCODE  OF SQLCA
      *>  DISPLAY SQLSTATE OF SQLCA
          
          EXIT SECTION .

      *>------------------------------------------------------------------------
       SQL-SELECT-WF-SESSION SECTION.
      *>------------------------------------------------------------------------

          EXEC SQL
               SELECT SESS_SESSION_ID_HEX  
                    , SESS_NICKNAME         
                    , SESS_LANGUAGES        
                    , SESS_LEVEL            
                    , SESS_QUESTION_COUNT   
                    , SESS_ANSWER_OK_COUNT  
                    , SESS_SUCCESS_0        
                    , SESS_SUCCESS_1        
                    , SESS_SUCCESS_2        
                    , SESS_SUCCESS_3        
                    , SESS_SUCCESS_4        
                    , SESS_SUCCESS_5        
                    , SESS_MAX_USER_WORD    
                    , SESS_USER_WORD_TABLE  
                    , SESS_CURR_IMG_NR      
                    , SESS_CURR_WORD_NR     
                    , SESS_LAST_WORD_NR_1     
                    , SESS_LAST_WORD_NR_2
                    , SESS_INSERT_TIMESTAMP 
                    , SESS_LUPD_TIMESTAMP   
                    , SESS_LUPD_COUNTER     
               INTO   :HV-SESS-SESSION-ID-HEX  
                    , :HV-SESS-NICKNAME         
                    , :HV-SESS-LANGUAGES        
                    , :HV-SESS-LEVEL            
                    , :HV-SESS-QUESTION-COUNT   
                    , :HV-SESS-ANSWER-OK-COUNT  
                    , :HV-SESS-SUCCESS-0        
                    , :HV-SESS-SUCCESS-1        
                    , :HV-SESS-SUCCESS-2        
                    , :HV-SESS-SUCCESS-3        
                    , :HV-SESS-SUCCESS-4        
                    , :HV-SESS-SUCCESS-5        
                    , :HV-SESS-MAX-USER-WORD    
                    , :HV-SESS-USER-WORD-TABLE  
                    , :HV-SESS-CURR-IMG-NR      
                    , :HV-SESS-CURR-WORD-NR     
                    , :HV-SESS-LAST-WORD-NR-1     
                    , :HV-SESS-LAST-WORD-NR-2
                    , :HV-SESS-INSERT-TIMESTAMP 
                    , :HV-SESS-LUPD-TIMESTAMP   
                    , :HV-SESS-LUPD-COUNTER     
               FROM   WF_SESSION
               WHERE  SESS_SESSION_ID_HEX = :HV-SESS-SESSION-ID-HEX
          END-EXEC
          
          MOVE SQLCODE TO WS-SQL-STATUS

      *>  only for test   
      *>  DISPLAY SQLCODE  OF SQLCA
      *>  DISPLAY SQLSTATE OF SQLCA
          
          EXIT SECTION .

      *>------------------------------------------------------------------------
       SQL-SELECT-WF-SESSION-COUNT SECTION.
      *>------------------------------------------------------------------------

          EXEC SQL
               SELECT COUNT(*)                
               INTO   :HV-WF-SESSION-COUNT            
               FROM   WF_SESSION
          END-EXEC
          
          MOVE SQLCODE TO WS-SQL-STATUS

      *>  only for test   
      *>  DISPLAY SQLCODE  OF SQLCA
      *>  DISPLAY SQLSTATE OF SQLCA
          
          EXIT SECTION .

      *>------------------------------------------------------------------------
       SQL-SELECT-WF-DICTIONARY SECTION.
      *>------------------------------------------------------------------------

          EXEC SQL
               SELECT DICT_WORD_NR     
                    , DICT_IMAGE       
                    , DICT_WORD_DE     
                    , DICT_WORD_EN     
                    , DICT_WORD_HU     
               INTO   :HV-DICT-WORD-NR               
                    , :HV-DICT-IMAGE                 
                    , :HV-DICT-WORD-DE
                    , :HV-DICT-WORD-EN
                    , :HV-DICT-WORD-HU
               FROM   WF_DICTIONARY
               WHERE  DICT_WORD_NR = :HV-DICT-WORD-NR
          END-EXEC
          
          MOVE SQLCODE TO WS-SQL-STATUS

      *>  only for test   
      *>  DISPLAY SQLCODE  OF SQLCA
      *>  DISPLAY SQLSTATE OF SQLCA
          
          EXIT SECTION .

      *>------------------------------------------------------------------------
       SQL-INSERT-WF-GUESTLIST SECTION.
      *>------------------------------------------------------------------------

          EXEC SQL
               INSERT INTO WF_GUESTLIST
               (  GLST_SESSION_ID_HEX
                , GLST_START_TIMESTAMP 
                , GLST_END_TIMESTAMP   
                , GLST_NICKNAME        
                , GLST_LANGUAGES       
                , GLST_LEVEL           
                , GLST_QUESTION_COUNT  
                , GLST_ANSWER_OK_COUNT 
                , GLST_MAX_USER_WORD   
                , GLST_INSERT_TIMESTAMP
               )
               VALUES
               (  :HV-GLST-SESSION-ID-HEX
                , :HV-GLST-START-TIMESTAMP 
                , :HV-GLST-END-TIMESTAMP   
                , :HV-GLST-NICKNAME        
                , :HV-GLST-LANGUAGES       
                , :HV-GLST-LEVEL           
                , :HV-GLST-QUESTION-COUNT  
                , :HV-GLST-ANSWER-OK-COUNT 
                , :HV-GLST-MAX-USER-WORD   
                , CURRENT_TIMESTAMP   
               )
          END-EXEC
          
          MOVE SQLCODE TO WS-SQL-STATUS

      *>  only for test   
      *>  DISPLAY SQLCODE  OF SQLCA
      *>  DISPLAY SQLSTATE OF SQLCA
          
          EXIT SECTION .

      *>------------------------------------------------------------------------
       SQL-UPDATE-WF-SESSION SECTION.
      *>------------------------------------------------------------------------

          EXEC SQL
               UPDATE WF_SESSION
               SET       SESS_QUESTION_COUNT   
                      = :HV-SESS-QUESTION-COUNT    
                       , SESS_ANSWER_OK_COUNT  
                      = :HV-SESS-ANSWER-OK-COUNT  
                       , SESS_SUCCESS_0        
                      = :HV-SESS-SUCCESS-0        
                       , SESS_SUCCESS_1  
                      = :HV-SESS-SUCCESS-1                         
                       , SESS_SUCCESS_2        
                      = :HV-SESS-SUCCESS-2         
                       , SESS_SUCCESS_3  
                      = :HV-SESS-SUCCESS-3                        
                       , SESS_SUCCESS_4  
                      = :HV-SESS-SUCCESS-4                         
                       , SESS_SUCCESS_5  
                      = :HV-SESS-SUCCESS-5                         
                       , SESS_USER_WORD_TABLE  
                      = :HV-SESS-USER-WORD-TABLE  
                       , SESS_CURR_IMG_NR  
                      = :HV-SESS-CURR-IMG-NR                        
                       , SESS_CURR_WORD_NR     
                      = :HV-SESS-CURR-WORD-NR     
                       , SESS_LAST_WORD_NR_1     
                      = :HV-SESS-LAST-WORD-NR-1      
                       , SESS_LAST_WORD_NR_2
                      = :HV-SESS-LAST-WORD-NR-2
                       , SESS_LUPD_TIMESTAMP  
                      =  CURRENT_TIMESTAMP                       
                       , SESS_LUPD_COUNTER
                      = :HV-SESS-LUPD-COUNTER                       
               WHERE     SESS_SESSION_ID_HEX 
                      = :HV-SESS-SESSION-ID-HEX
               AND       SESS_LUPD_TIMESTAMP 
                      = :HV-SESS-LUPD-TIMESTAMP-SAVE
               AND       SESS_LUPD_COUNTER   
                      = :HV-SESS-LUPD-COUNTER-SAVE        
          END-EXEC
          
          MOVE SQLCODE TO WS-SQL-STATUS
          
      *>  only for test   
      *>  DISPLAY SQLCODE  OF SQLCA
      *>  DISPLAY SQLSTATE OF SQLCA
          
          EXIT SECTION .
          
       END PROGRAM PGMOD3.
