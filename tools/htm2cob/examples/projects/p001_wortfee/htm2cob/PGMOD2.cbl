      *>************************************************************************
      *>  This file is part of htm2cob.
      *>
      *>  PGMOD2.cob is free software: you can redistribute it and/or 
      *>  modify it under the terms of the GNU Lesser General Public License as 
      *>  published by the Free Software Foundation, either version 3 of the
      *>  License, or (at your option) any later version.
      *>
      *>  PGMOD2.cob is distributed in the hope that it will be useful, 
      *>  but WITHOUT ANY WARRANTY; without even the implied warranty of 
      *>  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
      *>  See the GNU Lesser General Public License for more details.
      *>
      *>  You should have received a copy of the GNU Lesser General Public  
      *>  License along with PGMOD2.cob.
      *>  If not, see <http://www.gnu.org/licenses/>.
      *>************************************************************************
      
      *>************************************************************************
      *> Program:      PGMOD2.cbl
      *>
      *> Purpose:      PostgreSQL module
      *>
      *> Author:       Laszlo Erdos - https://www.facebook.com/wortfee
      *>
      *> Date-Written: 2019.12.23
      *>
      *> Usage:        To use this module, simply CALL it as follows: 
      *>               CALL "PGMOD2" USING LN-MOD2
      *>
      *>************************************************************************
      *> Date       Name / Change description 
      *> ========== ============================================================
      *> 2019.12.23 Laszlo Erdos: 
      *>            - first version. 
      *>************************************************************************

       IDENTIFICATION DIVISION.
       PROGRAM-ID. PGMOD2.
      
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
         05 HV-DICT-LEVEL              PIC 9(1).     
                                                     
      *> connect fields 
       01 HV-DBNAME                    PIC X(20) VALUE SPACE.
       01 HV-USERID                    PIC X(20) VALUE SPACE.
       01 HV-PSWD                      PIC X(20) VALUE SPACE.
       EXEC SQL END   DECLARE SECTION END-EXEC.
       
      *> indices for cycles
       01 WS-IND-1                     PIC S9(4) COMP.

       01 WS-LOG-TXT                   PIC X(30).

      *> selected WORD-NR from the WF_DICTIONARY table
       78 C-MAX-WORD-NR                VALUE 3000.  
       01 WS-WORD-NR-TABLE.
         02 WS-WORD-NR-TAB OCCURS 3000 TIMES.
           03 WS-WORD-NR-TAB-LINE.
             04 WS-WORD-NR             PIC 9(4).
             04 WS-SUCCESS-NR          PIC 9(1).
       
       LINKAGE SECTION.
       01 LN-MOD2.
         02 LN-INPUT.
           03 LN-SESSION-ID-HEX        PIC X(128).
           03 LN-NICKNAME              PIC X(15).
           03 LN-LANGUAGES             PIC X(5).
           03 LN-LEVEL                 PIC 9(1).
         02 LN-OUTPUT.
           03 LN-RESULT-FLAG           PIC 9(1).
              88 V-OK                  VALUE 0.
              88 V-NOT-OK              VALUE 1.
           03 LN-LEVEL-COUNT           PIC 9(4).
       
       PROCEDURE DIVISION USING LN-MOD2.
      
      *>------------------------------------------------------------------------
       MAIN-PGMOD2 SECTION.
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

          INITIALIZE LN-OUTPUT OF LN-MOD2
      
          PERFORM CONNECT
          IF V-NOT-OK OF LN-RESULT-FLAG
          THEN
             EXIT SECTION
          END-IF
          
          IF V-OK OF LN-RESULT-FLAG
          THEN
             PERFORM FILL-USER-WORD-TABLE
          END-IF
          
          IF V-OK OF LN-RESULT-FLAG
          THEN
             PERFORM INSERT-WF-SESSION
          END-IF

      *>  this is a good place to delete old session data  
          PERFORM DELETE-OLD-WF-SESSION
          
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
       FILL-USER-WORD-TABLE SECTION.
      *>------------------------------------------------------------------------

      *>  A Cursor can not be declared in WORKING-STORAGE with ocesql.
      *>  We can not use the "WITH HOLD" option in cursor with ocesql.
      *>  Before Cursor declare we need a connection to DB.
          PERFORM SQL-DECLARE-CURSOR-WF-DICT
      
          INITIALIZE HV-WF-DICTIONARY
          INITIALIZE WS-WORD-NR-TABLE
          
          MOVE LN-LEVEL OF LN-MOD2
            TO HV-DICT-LEVEL
      
          PERFORM SQL-OPEN-CURSOR-WF-DICT

          IF SQL-STATUS-OK
          THEN
             PERFORM VARYING WS-IND-1 FROM 1 BY 1
               UNTIL WS-IND-1 > C-MAX-WORD-NR
          
                PERFORM SQL-FETCH-CURSOR-WF-DICT
                
                EVALUATE TRUE
                WHEN     SQL-STATUS-OK
                   MOVE WS-IND-1
                     TO LN-LEVEL-COUNT OF LN-MOD2
                   
      *>           copy selected data in internal table
                   MOVE HV-DICT-WORD-NR
                     TO WS-WORD-NR    OF WS-WORD-NR-TABLE(WS-IND-1)
                   MOVE ZEROES
                     TO WS-SUCCESS-NR OF WS-WORD-NR-TABLE(WS-IND-1)
            
                WHEN     SQL-STATUS-NOT-FOUND
                   IF WS-IND-1 = 1
                   THEN
                      MOVE ZEROES
                        TO LN-LEVEL-COUNT OF LN-MOD2
                   END-IF  
                   EXIT PERFORM
            
                WHEN     OTHER
                   SET V-NOT-OK OF LN-RESULT-FLAG TO TRUE
                   EXIT PERFORM
                END-EVALUATE
             END-PERFORM   
          END-IF      
          
      *>  always try to close the cursor, also in error cases    
          PERFORM SQL-CLOSE-CURSOR-WF-DICT
 
      *>  There is no "WITH HOLD" option in cursor, therefore we need a commit.     
          PERFORM SQL-COMMIT
          
          EXIT SECTION .

      *>------------------------------------------------------------------------
       INSERT-WF-SESSION SECTION.
      *>------------------------------------------------------------------------

          INITIALIZE HV-WF-SESSION
          
          MOVE LN-SESSION-ID-HEX        OF LN-MOD2
            TO HV-SESS-SESSION-ID-HEX   OF HV-WF-SESSION
          MOVE LN-NICKNAME              OF LN-MOD2
            TO HV-SESS-NICKNAME         OF HV-WF-SESSION
          MOVE LN-LANGUAGES             OF LN-MOD2  
            TO HV-SESS-LANGUAGES        OF HV-WF-SESSION
          MOVE LN-LEVEL                 OF LN-MOD2
            TO HV-SESS-LEVEL            OF HV-WF-SESSION
          MOVE 0  
            TO HV-SESS-QUESTION-COUNT   OF HV-WF-SESSION
          MOVE 0  
            TO HV-SESS-ANSWER-OK-COUNT  OF HV-WF-SESSION
          MOVE LN-LEVEL-COUNT           OF LN-MOD2  
            TO HV-SESS-SUCCESS-0        OF HV-WF-SESSION
          MOVE 0  
            TO HV-SESS-SUCCESS-1        OF HV-WF-SESSION
          MOVE 0  
            TO HV-SESS-SUCCESS-2        OF HV-WF-SESSION
          MOVE 0  
            TO HV-SESS-SUCCESS-3        OF HV-WF-SESSION
          MOVE 0  
            TO HV-SESS-SUCCESS-4        OF HV-WF-SESSION
          MOVE 0  
            TO HV-SESS-SUCCESS-5        OF HV-WF-SESSION
          MOVE LN-LEVEL-COUNT           OF LN-MOD2  
            TO HV-SESS-MAX-USER-WORD    OF HV-WF-SESSION
          MOVE WS-WORD-NR-TABLE  
            TO HV-SESS-USER-WORD-TABLE  OF HV-WF-SESSION
          MOVE 0  
            TO HV-SESS-CURR-IMG-NR      OF HV-WF-SESSION
          MOVE 0  
            TO HV-SESS-CURR-WORD-NR     OF HV-WF-SESSION
          MOVE 0  
            TO HV-SESS-LAST-WORD-NR-1   OF HV-WF-SESSION
          MOVE 0  
            TO HV-SESS-LAST-WORD-NR-2   OF HV-WF-SESSION
          MOVE 0  
            TO HV-SESS-LUPD-COUNTER     OF HV-WF-SESSION
            
          PERFORM SQL-INSERT-WF-SESSION

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
       DELETE-OLD-WF-SESSION SECTION.
      *>------------------------------------------------------------------------

          INITIALIZE HV-WF-SESSION

          PERFORM SQL-DELETE-OLD-WF-SESSION
          
          EVALUATE TRUE
          WHEN     SQL-STATUS-OK
             PERFORM SQL-COMMIT
      
          WHEN     SQL-STATUS-NOT-FOUND
             PERFORM SQL-ROLLBACK
      
          WHEN     OTHER
             PERFORM SQL-ROLLBACK
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
       SQL-INSERT-WF-SESSION SECTION.
      *>------------------------------------------------------------------------

          EXEC SQL
               INSERT INTO WF_SESSION
               (  SESS_SESSION_ID_HEX  
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
               )
               VALUES
               (  :HV-SESS-SESSION-ID-HEX  
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
                , CURRENT_TIMESTAMP   
                , CURRENT_TIMESTAMP   
                , :HV-SESS-LUPD-COUNTER     
               )
          END-EXEC
          
          MOVE SQLCODE TO WS-SQL-STATUS

      *>  only for test   
      *>  DISPLAY SQLCODE  OF SQLCA
      *>  DISPLAY SQLSTATE OF SQLCA
          
          EXIT SECTION .

      *>------------------------------------------------------------------------
       SQL-DELETE-OLD-WF-SESSION SECTION.
      *>------------------------------------------------------------------------

          EXEC SQL
               DELETE
               FROM   WF_SESSION
               WHERE  SESS_LUPD_TIMESTAMP <= CURRENT_TIMESTAMP 
                                           - INTERVAL '20 MINUTES'
          END-EXEC
          
          MOVE SQLCODE TO WS-SQL-STATUS
          
      *>  only for test   
      *>  DISPLAY SQLCODE  OF SQLCA
      *>  DISPLAY SQLSTATE OF SQLCA
          
          EXIT SECTION .
          
      *>------------------------------------------------------------------------
       SQL-DECLARE-CURSOR-WF-DICT SECTION.
      *>------------------------------------------------------------------------
      
          EXEC SQL
               DECLARE   CURSOR_WF_DICT CURSOR FOR
               SELECT    DICT_WORD_NR            
               FROM      WF_DICTIONARY
               WHERE     DICT_LEVEL <= :HV-DICT-LEVEL
               ORDER BY  DICT_WORD_NR     ASC
          END-EXEC

      *>  only for test   
      *>  DISPLAY SQLCODE  OF SQLCA
      *>  DISPLAY SQLSTATE OF SQLCA
          
          EXIT SECTION .
          
      *>------------------------------------------------------------------------
       SQL-OPEN-CURSOR-WF-DICT SECTION.
      *>------------------------------------------------------------------------

          EXEC SQL
               OPEN CURSOR_WF_DICT
          END-EXEC
          
          MOVE SQLCODE TO WS-SQL-STATUS

      *>  only for test   
      *>  DISPLAY SQLCODE  OF SQLCA
      *>  DISPLAY SQLSTATE OF SQLCA
          
          EXIT SECTION .
          
      *>------------------------------------------------------------------------
       SQL-FETCH-CURSOR-WF-DICT SECTION.
      *>------------------------------------------------------------------------

          EXEC SQL
               FETCH CURSOR_WF_DICT
               INTO    :HV-DICT-WORD-NR   
          END-EXEC
          
          MOVE SQLCODE TO WS-SQL-STATUS

      *>  only for test   
      *>  DISPLAY SQLCODE  OF SQLCA
      *>  DISPLAY SQLSTATE OF SQLCA
          
          EXIT SECTION .
          
      *>------------------------------------------------------------------------
       SQL-CLOSE-CURSOR-WF-DICT SECTION.
      *>------------------------------------------------------------------------

          EXEC SQL
               CLOSE CURSOR_WF_DICT
          END-EXEC
          
          MOVE SQLCODE TO WS-SQL-STATUS

      *>  only for test   
      *>  DISPLAY SQLCODE  OF SQLCA
      *>  DISPLAY SQLSTATE OF SQLCA
          
          EXIT SECTION .
          
       END PROGRAM PGMOD2.
