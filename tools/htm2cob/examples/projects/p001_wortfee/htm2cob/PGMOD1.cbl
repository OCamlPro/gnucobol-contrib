      *>************************************************************************
      *>  This file is part of htm2cob.
      *>
      *>  PGMOD1.cob is free software: you can redistribute it and/or 
      *>  modify it under the terms of the GNU Lesser General Public License as 
      *>  published by the Free Software Foundation, either version 3 of the
      *>  License, or (at your option) any later version.
      *>
      *>  PGMOD1.cob is distributed in the hope that it will be useful, 
      *>  but WITHOUT ANY WARRANTY; without even the implied warranty of 
      *>  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
      *>  See the GNU Lesser General Public License for more details.
      *>
      *>  You should have received a copy of the GNU Lesser General Public  
      *>  License along with PGMOD1.cob.
      *>  If not, see <http://www.gnu.org/licenses/>.
      *>************************************************************************
      
      *>************************************************************************
      *> Program:      PGMOD1.cbl
      *>
      *> Purpose:      PostgreSQL module
      *>
      *> Author:       Laszlo Erdos - https://www.facebook.com/wortfee
      *>
      *> Date-Written: 2019.12.23
      *>
      *> Usage:        To use this module, simply CALL it as follows: 
      *>               CALL "PGMOD1" USING LN-MOD1
      *>
      *>************************************************************************
      *> Date       Name / Change description 
      *> ========== ============================================================
      *> 2019.12.23 Laszlo Erdos: 
      *>            - first version. 
      *>************************************************************************

       IDENTIFICATION DIVISION.
       PROGRAM-ID. PGMOD1.
      
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
       01 HV-WF-DICTIONARY.
         05 HV-DICT-LEVEL              PIC 9(1).

       01 HV-LEVEL-COUNT               PIC 9(4).
           
      *> connect fields 
       01 HV-DBNAME                    PIC X(20) VALUE SPACE.
       01 HV-USERID                    PIC X(20) VALUE SPACE.
       01 HV-PSWD                      PIC X(20) VALUE SPACE.
       EXEC SQL END   DECLARE SECTION END-EXEC.
       
      *> indices for cycles
       01 WS-IND-1                     PIC S9(4) COMP.

       01 WS-LOG-TXT                   PIC X(30).
       
       LINKAGE SECTION.
       01 LN-MOD1.
         02 LN-OUTPUT.
           03 LN-RESULT-FLAG           PIC 9(1).
              88 V-OK                  VALUE 0.
              88 V-NOT-OK              VALUE 1.
           03 LN-LEVEL-TABLE.
             04 LN-LEVEL-TAB OCCURS 8 TIMES.
               05 LN-LEVEL-TAB-LINE.
                 06 LN-LEVEL           PIC 9(4).
       
       PROCEDURE DIVISION USING LN-MOD1.
      
      *>------------------------------------------------------------------------
       MAIN-PGMOD1 SECTION.
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

          INITIALIZE LN-OUTPUT OF LN-MOD1
      
          PERFORM CONNECT
          IF V-NOT-OK OF LN-RESULT-FLAG
          THEN
             EXIT SECTION
          END-IF
          
          IF V-OK OF LN-RESULT-FLAG
          THEN
             PERFORM SELECT-LEVEL-COUNT
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
       SELECT-LEVEL-COUNT SECTION.
      *>------------------------------------------------------------------------

          PERFORM VARYING WS-IND-1 FROM 1 BY 1
            UNTIL WS-IND-1 > 8
             INITIALIZE HV-LEVEL-COUNT
   
             MOVE WS-IND-1 TO HV-DICT-LEVEL
         
             PERFORM SQL-SELECT-LEVEL-COUNT
   
             EVALUATE TRUE
             WHEN     SQL-STATUS-OK
                MOVE HV-LEVEL-COUNT TO LN-LEVEL OF LN-MOD1(WS-IND-1)
         
             WHEN     OTHER
                SET V-NOT-OK OF LN-RESULT-FLAG TO TRUE
                EXIT SECTION
             END-EVALUATE
          END-PERFORM
          
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
       SQL-SELECT-LEVEL-COUNT SECTION.
      *>------------------------------------------------------------------------

          EXEC SQL
               SELECT COUNT(*)                
               INTO   :HV-LEVEL-COUNT            
               FROM   WF_DICTIONARY
               WHERE  DICT_LEVEL <= :HV-DICT-LEVEL
          END-EXEC
          
          MOVE SQLCODE TO WS-SQL-STATUS
          
          EXIT SECTION .
          
       END PROGRAM PGMOD1.
