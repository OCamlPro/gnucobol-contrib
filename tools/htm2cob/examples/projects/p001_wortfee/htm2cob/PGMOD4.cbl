      *>************************************************************************
      *>  This file is part of htm2cob.
      *>
      *>  PGMOD4.cob is free software: you can redistribute it and/or 
      *>  modify it under the terms of the GNU Lesser General Public License as 
      *>  published by the Free Software Foundation, either version 3 of the
      *>  License, or (at your option) any later version.
      *>
      *>  PGMOD4.cob is distributed in the hope that it will be useful, 
      *>  but WITHOUT ANY WARRANTY; without even the implied warranty of 
      *>  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
      *>  See the GNU Lesser General Public License for more details.
      *>
      *>  You should have received a copy of the GNU Lesser General Public  
      *>  License along with PGMOD4.cob.
      *>  If not, see <http://www.gnu.org/licenses/>.
      *>************************************************************************
      
      *>************************************************************************
      *> Program:      PGMOD4.cbl
      *>
      *> Purpose:      PostgreSQL module
      *>
      *> Author:       Laszlo Erdos - https://www.facebook.com/wortfee
      *>
      *> Date-Written: 2019.12.23
      *>
      *> Usage:        To use this module, simply CALL it as follows: 
      *>               CALL "PGMOD4" USING LN-MOD4
      *>
      *>************************************************************************
      *> Date       Name / Change description 
      *> ========== ============================================================
      *> 2019.12.23 Laszlo Erdos: 
      *>            - first version. 
      *>************************************************************************

       IDENTIFICATION DIVISION.
       PROGRAM-ID. PGMOD4.
      
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
                                                     
      *> connect fields 
       01 HV-DBNAME                    PIC X(20) VALUE SPACE.
       01 HV-USERID                    PIC X(20) VALUE SPACE.
       01 HV-PSWD                      PIC X(20) VALUE SPACE.
       EXEC SQL END   DECLARE SECTION END-EXEC.
       
      *> indices for cycles
       01 WS-IND-1                     PIC S9(4) COMP.

       01 WS-LOG-TXT                   PIC X(30).
       
       LINKAGE SECTION.
       01 LN-MOD4.
         02 LN-OUTPUT.
           03 LN-RESULT-FLAG           PIC 9(1).
              88 V-OK                  VALUE 0.
              88 V-NOT-OK              VALUE 1.
      *>   saved number of lines in the table
           03 LN-GUEST-TAB-LINE-NR     PIC 9(3).
           03 LN-GUEST-TABLE.
             04 LN-GUEST-TAB OCCURS 100 TIMES.
               05 LN-GUEST-TAB-LINE.
                 06 LN-START-TIME      PIC X(19).
                 06 LN-END-TIME        PIC X(19).
                 06 LN-NICKNAME        PIC X(15).
                 06 LN-LANGUAGES       PIC X(5).
                 06 LN-LEVEL           PIC 9(1).
                 06 LN-QUESTION-COUNT  PIC 9(6).
                 06 LN-ANSWER-OK-COUNT PIC 9(6).
                 06 LN-MAX-USER-WORD   PIC 9(4).
       
       PROCEDURE DIVISION USING LN-MOD4.
      
      *>------------------------------------------------------------------------
       MAIN-PGMOD4 SECTION.
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

          INITIALIZE LN-OUTPUT OF LN-MOD4
      
          PERFORM CONNECT
          IF V-NOT-OK OF LN-RESULT-FLAG
          THEN
             EXIT SECTION
          END-IF
          
          IF V-OK OF LN-RESULT-FLAG
          THEN
             PERFORM FILL-GUEST-TABLE
          END-IF
          
          PERFORM DISCONNECT
      
          GOBACK
      
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
       FILL-GUEST-TABLE SECTION.
      *>------------------------------------------------------------------------

      *>  A Cursor can not be declared in WORKING-STORAGE with ocesql.
      *>  We can not use the "WITH HOLD" option in cursor with ocesql.
      *>  Before Cursor declare we need a connection to DB.
          PERFORM SQL-DECLARE-CURSOR-WF-GLST
      
          INITIALIZE HV-WF-GUESTLIST
          
          PERFORM SQL-OPEN-CURSOR-WF-GLST

          IF SQL-STATUS-OK
          THEN
             PERFORM VARYING WS-IND-1 FROM 1 BY 1
               UNTIL WS-IND-1 > 100
                  OR NOT SQL-STATUS-OK
          
                PERFORM SQL-FETCH-CURSOR-WF-GLST
                
                EVALUATE TRUE
                WHEN     SQL-STATUS-OK
                   MOVE WS-IND-1
                     TO LN-GUEST-TAB-LINE-NR
                   
      *>           copy selected data in linkage table
                   MOVE HV-GLST-START-TIMESTAMP 
                     TO LN-START-TIME(WS-IND-1)
                   MOVE HV-GLST-END-TIMESTAMP
                     TO LN-END-TIME(WS-IND-1)                   
                   MOVE HV-GLST-NICKNAME     
                     TO LN-NICKNAME(WS-IND-1)                   
                   MOVE HV-GLST-LANGUAGES    
                     TO LN-LANGUAGES(WS-IND-1)                   
                   MOVE HV-GLST-LEVEL         
                     TO LN-LEVEL(WS-IND-1)                   
                   MOVE HV-GLST-QUESTION-COUNT  
                     TO LN-QUESTION-COUNT(WS-IND-1)
                   MOVE HV-GLST-ANSWER-OK-COUNT 
                     TO LN-ANSWER-OK-COUNT(WS-IND-1)
                   MOVE HV-GLST-MAX-USER-WORD   
                     TO LN-MAX-USER-WORD(WS-IND-1)
            
                WHEN     SQL-STATUS-NOT-FOUND
                   IF WS-IND-1 = 1
                   THEN
                      MOVE ZEROES
                        TO LN-GUEST-TAB-LINE-NR
                   END-IF  
                   EXIT PERFORM
            
                WHEN     OTHER
                   SET V-NOT-OK OF LN-RESULT-FLAG TO TRUE
                   EXIT PERFORM
                END-EVALUATE
             END-PERFORM   
          END-IF      
          
      *>  always try to close the cursor, also in error cases    
          PERFORM SQL-CLOSE-CURSOR-WF-GLST
 
      *>  There is no "WITH HOLD" option in cursor, therefore we need a commit.     
          PERFORM SQL-COMMIT
          
          EXIT SECTION .
          
      *>------------------------------------------------------------------------
       SQL-CONNECT SECTION.
      *>------------------------------------------------------------------------

          EXEC SQL  
               CONNECT       :HV-USERID 
               IDENTIFIED BY :HV-PSWD USING :HV-DBNAME 
          END-EXEC
          
          MOVE SQLCODE TO WS-SQL-STATUS
          
          EXIT SECTION .
      
      *>------------------------------------------------------------------------
       SQL-DISCONNECT SECTION.
      *>------------------------------------------------------------------------

          EXEC SQL  
               DISCONNECT ALL
          END-EXEC
          
          MOVE SQLCODE TO WS-SQL-STATUS
          
          EXIT SECTION .

      *>------------------------------------------------------------------------
       SQL-COMMIT SECTION.
      *>------------------------------------------------------------------------

          EXEC SQL  
               COMMIT
          END-EXEC
          
          MOVE SQLCODE TO WS-SQL-STATUS
          
          EXIT SECTION .
          
      *>------------------------------------------------------------------------
       SQL-ROLLBACK SECTION.
      *>------------------------------------------------------------------------

          EXEC SQL  
               ROLLBACK
          END-EXEC

          MOVE SQLCODE TO WS-SQL-STATUS
          
          EXIT SECTION .
          
      *>------------------------------------------------------------------------
       SQL-DECLARE-CURSOR-WF-GLST SECTION.
      *>------------------------------------------------------------------------
      
          EXEC SQL
               DECLARE   CURSOR_WF_GLST CURSOR FOR
               SELECT    GLST_SESSION_ID_HEX
                       , GLST_START_TIMESTAMP 
                       , GLST_END_TIMESTAMP   
                       , GLST_NICKNAME        
                       , GLST_LANGUAGES       
                       , GLST_LEVEL           
                       , GLST_QUESTION_COUNT  
                       , GLST_ANSWER_OK_COUNT 
                       , GLST_MAX_USER_WORD   
                       , GLST_INSERT_TIMESTAMP
               FROM      WF_GUESTLIST
               ORDER BY  GLST_START_TIMESTAMP   DESC
          END-EXEC

      *>  only for test   
      *>  DISPLAY SQLCODE  OF SQLCA
      *>  DISPLAY SQLSTATE OF SQLCA
          
          EXIT SECTION .
          
      *>------------------------------------------------------------------------
       SQL-OPEN-CURSOR-WF-GLST SECTION.
      *>------------------------------------------------------------------------

          EXEC SQL
               OPEN CURSOR_WF_GLST
          END-EXEC
          
          MOVE SQLCODE TO WS-SQL-STATUS

      *>  only for test   
      *>  DISPLAY SQLCODE  OF SQLCA
      *>  DISPLAY SQLSTATE OF SQLCA
          
          EXIT SECTION .
          
      *>------------------------------------------------------------------------
       SQL-FETCH-CURSOR-WF-GLST SECTION.
      *>------------------------------------------------------------------------

          EXEC SQL
               FETCH CURSOR_WF_GLST
               INTO    :HV-GLST-SESSION-ID-HEX
                     , :HV-GLST-START-TIMESTAMP 
                     , :HV-GLST-END-TIMESTAMP   
                     , :HV-GLST-NICKNAME        
                     , :HV-GLST-LANGUAGES       
                     , :HV-GLST-LEVEL           
                     , :HV-GLST-QUESTION-COUNT  
                     , :HV-GLST-ANSWER-OK-COUNT 
                     , :HV-GLST-MAX-USER-WORD   
                     , :HV-GLST-INSERT-TIMESTAMP
          END-EXEC
          
          MOVE SQLCODE TO WS-SQL-STATUS

      *>  only for test   
      *>  DISPLAY SQLCODE  OF SQLCA
      *>  DISPLAY SQLSTATE OF SQLCA
          
          EXIT SECTION .
          
      *>------------------------------------------------------------------------
       SQL-CLOSE-CURSOR-WF-GLST SECTION.
      *>------------------------------------------------------------------------

          EXEC SQL
               CLOSE CURSOR_WF_GLST
          END-EXEC
          
          MOVE SQLCODE TO WS-SQL-STATUS

      *>  only for test   
      *>  DISPLAY SQLCODE  OF SQLCA
      *>  DISPLAY SQLSTATE OF SQLCA
          
          EXIT SECTION .
          
       END PROGRAM PGMOD4.
