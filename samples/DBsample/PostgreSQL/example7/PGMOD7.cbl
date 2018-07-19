      *>************************************************************************
      *>  This file is part of DBsample.
      *>
      *>  PGMOD7.cob is free software: you can redistribute it and/or 
      *>  modify it under the terms of the GNU Lesser General Public License as 
      *>  published by the Free Software Foundation, either version 3 of the
      *>  License, or (at your option) any later version.
      *>
      *>  PGMOD7.cob is distributed in the hope that it will be useful, 
      *>  but WITHOUT ANY WARRANTY; without even the implied warranty of 
      *>  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
      *>  See the GNU Lesser General Public License for more details.
      *>
      *>  You should have received a copy of the GNU Lesser General Public  
      *>  License along with PGMOD7.cob.
      *>  If not, see <http://www.gnu.org/licenses/>.
      *>************************************************************************
      
      *>************************************************************************
      *> Program:      PGMOD7.cbl
      *>
      *> Purpose:      PostgreSQL sample module
      *>
      *> Author:       Laszlo Erdos - https://www.facebook.com/wortfee
      *>
      *> Date-Written: 2018.07.13
      *>
      *> Usage:        To use this module, simply CALL it as follows: 
      *>               CALL "PGMOD7" USING LN-MOD
      *>
      *>               Implemented features:
      *>               - connect to PostgreSQL
      *>               - disconnect
      *>               - select book
      *>               - insert book
      *>               - update book
      *>               - delete book
      *>               - paging (select first, next, previous, last)
      *>               - list   (select first, next, previous, last)
      *>
      *>************************************************************************
      *> Date       Name / Change description 
      *> ========== ============================================================
      *> 2018.07.13 Laszlo Erdos: 
      *>            - first version. 
      *>************************************************************************
      
       IDENTIFICATION DIVISION.
       PROGRAM-ID. PGMOD7.
      
       ENVIRONMENT DIVISION.
      
       DATA DIVISION.
       WORKING-STORAGE SECTION.
      *> max number of lines for the list screen   
       78 C-MAX-LINE-NR                VALUE 10.  
      *> indices for cycles
       01 WS-IND-1                     PIC S9(4) COMP.
       
      *> linkage for PGSQLMSG.cob   
       COPY "LNSQLMSG.cpy".

      *> SQL communication area
       COPY "sqlca.cbl".
       
      *> SQL status
       01 WS-SQL-STATUS                PIC S9(9) COMP-5.
          88 SQL-STATUS-OK             VALUE    0.
          88 SQL-STATUS-NOT-FOUND      VALUE  100.
          88 SQL-STATUS-DUP            VALUE -239, -403.
       
      *> SQL declare variables 
       EXEC SQL BEGIN DECLARE SECTION END-EXEC.
      *> host variables for the table BOOK
       01 HV-BOOK.
         05 HV-ISBN                    PIC 9(13).
         05 HV-AUTHORS                 PIC X(40).
         05 HV-TITLE                   PIC X(60).
         05 HV-PUB-DATE                PIC X(10).
         05 HV-PAGE-NR                 PIC 9(4).
         05 HV-INSERT-USER             PIC X(20).
         05 HV-INSERT-TIMESTAMP        PIC X(26).
         05 HV-LUPD-USER               PIC X(20).
         05 HV-LUPD-TIMESTAMP          PIC X(26).
         05 HV-LUPD-COUNTER            PIC 9(6).

      *> to save last update values     
       01 HV-LUPD-TIMESTAMP-SAVE       PIC X(26).
       01 HV-LUPD-COUNTER-SAVE         PIC 9(6).
         
      *> connect fields 
       01 HV-DBNAME                    PIC X(20) VALUE SPACE.
       01 HV-USERID                    PIC X(20) VALUE SPACE.
       01 HV-PSWD                      PIC X(20) VALUE SPACE.
       EXEC SQL END   DECLARE SECTION END-EXEC.
       
       LINKAGE SECTION.
       COPY "LNMOD7.cpy".
       
       PROCEDURE DIVISION USING LN-MOD.
      
      *>------------------------------------------------------------------------
       MAIN-PGMOD7 SECTION.
      *>------------------------------------------------------------------------

          INITIALIZE LN-MSG
          
          EVALUATE TRUE
             WHEN V-LN-FNC-CONNECT
                PERFORM CONNECT
          
             WHEN V-LN-FNC-DISCONNECT
                PERFORM DISCONNECT

             WHEN V-LN-FNC-SELECT
                PERFORM SELECT-BOOK
                
             WHEN V-LN-FNC-INSERT
                PERFORM INSERT-BOOK
                
             WHEN V-LN-FNC-UPDATE
                PERFORM UPDATE-BOOK
                
             WHEN V-LN-FNC-DELETE
                PERFORM DELETE-BOOK
                
      *>     paging functions 
             WHEN V-LN-FNC-PAGING-FIRST
                PERFORM PAGING-FIRST
                
             WHEN V-LN-FNC-PAGING-NEXT
                PERFORM PAGING-NEXT

             WHEN V-LN-FNC-PAGING-PREVIOUS
                PERFORM PAGING-PREVIOUS

             WHEN V-LN-FNC-PAGING-LAST
                PERFORM PAGING-LAST

      *>     list functions 
             WHEN V-LN-FNC-LIST-FIRST
                PERFORM LIST-FIRST
                
             WHEN V-LN-FNC-LIST-NEXT
                PERFORM LIST-NEXT

             WHEN V-LN-FNC-LIST-PREVIOUS
                PERFORM LIST-PREVIOUS

             WHEN V-LN-FNC-LIST-LAST
                PERFORM LIST-LAST
                
             WHEN OTHER
                MOVE "Wrong linkage function" 
                  TO LN-MSG-1 OF LN-MOD
          END-EVALUATE
      
          GOBACK
      
          .
       MAIN-PGMOD7-EX.
          EXIT.
          
      *>------------------------------------------------------------------------
       CONNECT SECTION.
      *>------------------------------------------------------------------------

          MOVE  LN-DBNAME OF LN-MOD TO HV-DBNAME
          MOVE  LN-USERID OF LN-MOD TO HV-USERID
          MOVE  LN-PSWD   OF LN-MOD TO HV-PSWD
       
          PERFORM SQL-CONNECT

          PERFORM COPY-SQL-MSG-IN-LINKAGE
          
          .
       CONNECT-EX.
          EXIT.

      *>------------------------------------------------------------------------
       DISCONNECT SECTION.
      *>------------------------------------------------------------------------

          PERFORM SQL-DISCONNECT

          PERFORM COPY-SQL-MSG-IN-LINKAGE
          
          .
       DISCONNECT-EX.
          EXIT.

      *>------------------------------------------------------------------------
       SELECT-BOOK SECTION.
      *>------------------------------------------------------------------------

          INITIALIZE HV-BOOK
          MOVE LN-INP-ISBN             OF LN-MOD 
            TO HV-ISBN                 OF HV-BOOK
      
          PERFORM SQL-SELECT-BOOK

          PERFORM COPY-SQL-MSG-IN-LINKAGE

          EVALUATE TRUE
          WHEN     SQL-STATUS-OK
             MOVE HV-ISBN                 OF HV-BOOK
               TO LN-OUT-ISBN             OF LN-MOD
             MOVE HV-AUTHORS              OF HV-BOOK
               TO LN-OUT-AUTHORS          OF LN-MOD
             MOVE HV-TITLE                OF HV-BOOK
               TO LN-OUT-TITLE            OF LN-MOD
             MOVE HV-PUB-DATE             OF HV-BOOK
               TO LN-OUT-PUB-DATE         OF LN-MOD
             MOVE HV-PAGE-NR              OF HV-BOOK
               TO LN-OUT-PAGE-NR          OF LN-MOD
             MOVE HV-INSERT-USER          OF HV-BOOK
               TO LN-OUT-INSERT-USER      OF LN-MOD
             MOVE HV-INSERT-TIMESTAMP     OF HV-BOOK
               TO LN-OUT-INSERT-TIMESTAMP OF LN-MOD
             MOVE HV-LUPD-USER            OF HV-BOOK
               TO LN-OUT-LUPD-USER        OF LN-MOD
             MOVE HV-LUPD-TIMESTAMP       OF HV-BOOK
               TO LN-OUT-LUPD-TIMESTAMP   OF LN-MOD
             MOVE HV-LUPD-COUNTER         OF HV-BOOK
               TO LN-OUT-LUPD-COUNTER     OF LN-MOD
      
          WHEN     SQL-STATUS-NOT-FOUND
             MOVE "No book found with this ISBN number: "
               TO LN-MSG-1                OF LN-MOD
             MOVE HV-ISBN                 OF HV-BOOK  
               TO LN-MSG-2                OF LN-MOD
      
          WHEN     OTHER
             CONTINUE
          END-EVALUATE
          
          .
       SELECT-BOOK-EX.
          EXIT.

      *>------------------------------------------------------------------------
       INSERT-BOOK SECTION.
      *>------------------------------------------------------------------------

          INITIALIZE HV-BOOK
          MOVE LN-INP-ISBN             OF LN-MOD 
            TO HV-ISBN                 OF HV-BOOK
          MOVE LN-INP-AUTHORS          OF LN-MOD   
            TO HV-AUTHORS              OF HV-BOOK
          MOVE LN-INP-TITLE            OF LN-MOD
            TO HV-TITLE                OF HV-BOOK
          MOVE LN-INP-PUB-DATE         OF LN-MOD
            TO HV-PUB-DATE             OF HV-BOOK
          MOVE LN-INP-PAGE-NR          OF LN-MOD
            TO HV-PAGE-NR              OF HV-BOOK
      *>  user fields
          MOVE LN-USERID               OF LN-MOD
            TO HV-INSERT-USER          OF HV-BOOK
          MOVE LN-USERID               OF LN-MOD
            TO HV-LUPD-USER            OF HV-BOOK
          MOVE 0
            TO HV-LUPD-COUNTER         OF HV-BOOK
            
          PERFORM SQL-INSERT-BOOK

          PERFORM COPY-SQL-MSG-IN-LINKAGE

          EVALUATE TRUE
          WHEN     SQL-STATUS-OK
             PERFORM SQL-COMMIT
             PERFORM COPY-SQL-MSG-IN-LINKAGE
      
          WHEN     SQL-STATUS-DUP
             PERFORM SQL-ROLLBACK
             MOVE "A book exists yet with this ISBN number: "
               TO LN-MSG-1                OF LN-MOD
             MOVE HV-ISBN                 OF HV-BOOK  
               TO LN-MSG-2                OF LN-MOD
      
          WHEN     OTHER
             PERFORM SQL-ROLLBACK
          END-EVALUATE
          
          .
       INSERT-BOOK-EX.
          EXIT.

      *>------------------------------------------------------------------------
       UPDATE-BOOK SECTION.
      *>------------------------------------------------------------------------

      *>  first select the book
          INITIALIZE HV-BOOK
          MOVE LN-INP-ISBN             OF LN-MOD 
            TO HV-ISBN                 OF HV-BOOK
      
          PERFORM SQL-SELECT-BOOK
      
          PERFORM COPY-SQL-MSG-IN-LINKAGE
          
          EVALUATE TRUE
          WHEN     SQL-STATUS-OK
             CONTINUE
      
          WHEN     SQL-STATUS-NOT-FOUND
             INITIALIZE LN-MSG OF LN-MOD
             MOVE "The book record is not up to date, " &
                  "please select it again." 
               TO LN-MSG-1 OF LN-MOD
             EXIT SECTION
      
          WHEN     OTHER
             EXIT SECTION
          END-EVALUATE

      *>  check LUPD (last update) fields
          IF (LN-INP-LUPD-TIMESTAMP   OF LN-MOD
              NOT = HV-LUPD-TIMESTAMP OF HV-BOOK)
          OR (LN-INP-LUPD-COUNTER     OF LN-MOD
              NOT = HV-LUPD-COUNTER   OF HV-BOOK)
          THEN
             INITIALIZE LN-MSG OF LN-MOD
             MOVE "The book record is not up to date, " &
                  "please select it again." 
               TO LN-MSG-1 OF LN-MOD
             EXIT SECTION
          END-IF
          
      *>  save last update values from linkage    
          MOVE LN-INP-LUPD-TIMESTAMP OF LN-MOD
            TO HV-LUPD-TIMESTAMP-SAVE 
          MOVE LN-INP-LUPD-COUNTER   OF LN-MOD
            TO HV-LUPD-COUNTER-SAVE   
          
      *>  copy values from linkage    
          INITIALIZE HV-BOOK
          MOVE LN-INP-ISBN             OF LN-MOD 
            TO HV-ISBN                 OF HV-BOOK
          MOVE LN-INP-AUTHORS          OF LN-MOD   
            TO HV-AUTHORS              OF HV-BOOK
          MOVE LN-INP-TITLE            OF LN-MOD
            TO HV-TITLE                OF HV-BOOK
          MOVE LN-INP-PUB-DATE         OF LN-MOD
            TO HV-PUB-DATE             OF HV-BOOK
          MOVE LN-INP-PAGE-NR          OF LN-MOD
            TO HV-PAGE-NR              OF HV-BOOK
      *>  user fields
          MOVE LN-USERID               OF LN-MOD
            TO HV-LUPD-USER            OF HV-BOOK
      *>  last update counter
          IF LN-INP-LUPD-COUNTER OF LN-MOD >= 999999
          THEN
      *>     reset counter
             MOVE 0 TO HV-LUPD-COUNTER OF HV-BOOK
          ELSE
             COMPUTE HV-LUPD-COUNTER OF HV-BOOK
                   = LN-INP-LUPD-COUNTER OF LN-MOD + 1
             END-COMPUTE
          END-IF          
            
          PERFORM SQL-UPDATE-BOOK

          PERFORM COPY-SQL-MSG-IN-LINKAGE
          
          EVALUATE TRUE
          WHEN     SQL-STATUS-OK
             PERFORM SQL-COMMIT
             PERFORM COPY-SQL-MSG-IN-LINKAGE
      
          WHEN     SQL-STATUS-NOT-FOUND
             PERFORM SQL-ROLLBACK
             INITIALIZE LN-MSG OF LN-MOD
             MOVE "The book record is not up to date, " &
                  "please select it again." 
               TO LN-MSG-1 OF LN-MOD
      
          WHEN     OTHER
             PERFORM SQL-ROLLBACK
          END-EVALUATE
          
          .
       UPDATE-BOOK-EX.
          EXIT.

      *>------------------------------------------------------------------------
       DELETE-BOOK SECTION.
      *>------------------------------------------------------------------------

      *>  first select the book
          INITIALIZE HV-BOOK
          MOVE LN-INP-ISBN             OF LN-MOD 
            TO HV-ISBN                 OF HV-BOOK
      
          PERFORM SQL-SELECT-BOOK
      
          PERFORM COPY-SQL-MSG-IN-LINKAGE
          
          EVALUATE TRUE
          WHEN     SQL-STATUS-OK
             CONTINUE
      
          WHEN     SQL-STATUS-NOT-FOUND
             INITIALIZE LN-MSG OF LN-MOD
             MOVE "The book record is not up to date, " &
                  "please select it again." 
               TO LN-MSG-1 OF LN-MOD
             EXIT SECTION
      
          WHEN     OTHER
             EXIT SECTION
          END-EVALUATE

      *>  check LUPD (last update) fields
          IF (LN-INP-LUPD-TIMESTAMP   OF LN-MOD
              NOT = HV-LUPD-TIMESTAMP OF HV-BOOK)
          OR (LN-INP-LUPD-COUNTER     OF LN-MOD
              NOT = HV-LUPD-COUNTER   OF HV-BOOK)
          THEN
             INITIALIZE LN-MSG OF LN-MOD
             MOVE "The book record is not up to date, " &
                  "please select it again." 
               TO LN-MSG-1 OF LN-MOD
             EXIT SECTION
          END-IF
          
      *>  save last update values from linkage    
          MOVE LN-INP-LUPD-TIMESTAMP OF LN-MOD
            TO HV-LUPD-TIMESTAMP-SAVE 
          MOVE LN-INP-LUPD-COUNTER   OF LN-MOD
            TO HV-LUPD-COUNTER-SAVE   
          
      *>  copy values from linkage    
          INITIALIZE HV-BOOK
          MOVE LN-INP-ISBN             OF LN-MOD 
            TO HV-ISBN                 OF HV-BOOK
            
          PERFORM SQL-DELETE-BOOK

          PERFORM COPY-SQL-MSG-IN-LINKAGE
          
          EVALUATE TRUE
          WHEN     SQL-STATUS-OK
             PERFORM SQL-COMMIT
             PERFORM COPY-SQL-MSG-IN-LINKAGE
      
          WHEN     SQL-STATUS-NOT-FOUND
             PERFORM SQL-ROLLBACK
             INITIALIZE LN-MSG OF LN-MOD
             MOVE "The book record is not up to date, " &
                  "please select it again." 
               TO LN-MSG-1 OF LN-MOD
      
          WHEN     OTHER
             PERFORM SQL-ROLLBACK
          END-EVALUATE
          
          .
       DELETE-BOOK-EX.
          EXIT.

      *>------------------------------------------------------------------------
       PAGING-FIRST SECTION.
      *>------------------------------------------------------------------------

      *>  A Cursor can not be declared in WORKING-STORAGE with ocesql.
      *>  We can not use the "WITH HOLD" option in cursor with ocesql.
      *>  Before Cursor declare we need a connection to DB.
          PERFORM SQL-DECLARE-CURSOR-BOOK-PF
      
          INITIALIZE HV-BOOK
      
          PERFORM SQL-OPEN-CURSOR-BOOK-PF

          PERFORM COPY-SQL-MSG-IN-LINKAGE

          IF SQL-STATUS-OK
          THEN
             PERFORM SQL-FETCH-CURSOR-BOOK-PF

             PERFORM COPY-SQL-MSG-IN-LINKAGE
             
             EVALUATE TRUE
             WHEN     SQL-STATUS-OK
                PERFORM COPY-HV-DATA-IN-LINKAGE
                MOVE "First book selected."
                  TO LN-MSG-1          OF LN-MOD
                MOVE SPACES
                  TO LN-MSG-2          OF LN-MOD
         
             WHEN     SQL-STATUS-NOT-FOUND
                MOVE "No first book found."
                  TO LN-MSG-1          OF LN-MOD
                MOVE SPACES
                  TO LN-MSG-2          OF LN-MOD
         
             WHEN     OTHER
                CONTINUE
             END-EVALUATE
          END-IF      
          
      *>  always try to close the cursor, also in error cases    
          PERFORM SQL-CLOSE-CURSOR-BOOK-PF

      *>  There is no "WITH HOLD" option in cursor, therefore we need a commit.     
          PERFORM SQL-COMMIT
          
          .
       PAGING-FIRST-EX.
          EXIT.

      *>------------------------------------------------------------------------
       PAGING-NEXT SECTION.
      *>------------------------------------------------------------------------

      *>  A Cursor can not be declared in WORKING-STORAGE with ocesql.
      *>  We can not use the "WITH HOLD" option in cursor with ocesql.
      *>  Before Cursor declare we need a connection to DB.
          PERFORM SQL-DECLARE-CURSOR-BOOK-PN      
      
          INITIALIZE HV-BOOK
      *>  current value as restart point          
          MOVE LN-INP-ISBN             OF LN-MOD 
            TO HV-ISBN                 OF HV-BOOK
      
          PERFORM SQL-OPEN-CURSOR-BOOK-PN

          PERFORM COPY-SQL-MSG-IN-LINKAGE

          IF SQL-STATUS-OK
          THEN
             PERFORM SQL-FETCH-CURSOR-BOOK-PN

             PERFORM COPY-SQL-MSG-IN-LINKAGE
             
             EVALUATE TRUE
             WHEN     SQL-STATUS-OK
                PERFORM COPY-HV-DATA-IN-LINKAGE
                MOVE "Next book selected."
                  TO LN-MSG-1          OF LN-MOD
                MOVE SPACES
                  TO LN-MSG-2          OF LN-MOD
         
             WHEN     SQL-STATUS-NOT-FOUND
                MOVE "No next book found."
                  TO LN-MSG-1          OF LN-MOD
                MOVE SPACES
                  TO LN-MSG-2          OF LN-MOD
         
             WHEN     OTHER
                CONTINUE
             END-EVALUATE
          END-IF      
          
      *>  always try to close the cursor, also in error cases    
          PERFORM SQL-CLOSE-CURSOR-BOOK-PN

      *>  There is no "WITH HOLD" option in cursor, therefore we need a commit.     
          PERFORM SQL-COMMIT
          
          .
       PAGING-NEXT-EX.
          EXIT.

      *>------------------------------------------------------------------------
       PAGING-PREVIOUS SECTION.
      *>------------------------------------------------------------------------

      *>  A Cursor can not be declared in WORKING-STORAGE with ocesql.
      *>  We can not use the "WITH HOLD" option in cursor with ocesql.
      *>  Before Cursor declare we need a connection to DB.
          PERFORM SQL-DECLARE-CURSOR-BOOK-PP
      
          INITIALIZE HV-BOOK
      *>  current value as restart point          
          MOVE LN-INP-ISBN             OF LN-MOD 
            TO HV-ISBN                 OF HV-BOOK
      
          PERFORM SQL-OPEN-CURSOR-BOOK-PP

          PERFORM COPY-SQL-MSG-IN-LINKAGE

          IF SQL-STATUS-OK
          THEN
             PERFORM SQL-FETCH-CURSOR-BOOK-PP

             PERFORM COPY-SQL-MSG-IN-LINKAGE
             
             EVALUATE TRUE
             WHEN     SQL-STATUS-OK
                PERFORM COPY-HV-DATA-IN-LINKAGE
                MOVE "Previous book selected."
                  TO LN-MSG-1          OF LN-MOD
                MOVE SPACES
                  TO LN-MSG-2          OF LN-MOD
         
             WHEN     SQL-STATUS-NOT-FOUND
                MOVE "No previous book found."
                  TO LN-MSG-1          OF LN-MOD
                MOVE SPACES
                  TO LN-MSG-2          OF LN-MOD
         
             WHEN     OTHER
                CONTINUE
             END-EVALUATE
          END-IF      
          
      *>  always try to close the cursor, also in error cases    
          PERFORM SQL-CLOSE-CURSOR-BOOK-PP

      *>  There is no "WITH HOLD" option in cursor, therefore we need a commit.     
          PERFORM SQL-COMMIT
          
          .
       PAGING-PREVIOUS-EX.
          EXIT.

      *>------------------------------------------------------------------------
       PAGING-LAST SECTION.
      *>------------------------------------------------------------------------

      *>  A Cursor can not be declared in WORKING-STORAGE with ocesql.
      *>  We can not use the "WITH HOLD" option in cursor with ocesql.
      *>  Before Cursor declare we need a connection to DB.
          PERFORM SQL-DECLARE-CURSOR-BOOK-PL
      
          INITIALIZE HV-BOOK
      
          PERFORM SQL-OPEN-CURSOR-BOOK-PL

          PERFORM COPY-SQL-MSG-IN-LINKAGE

          IF SQL-STATUS-OK
          THEN
             PERFORM SQL-FETCH-CURSOR-BOOK-PL

             PERFORM COPY-SQL-MSG-IN-LINKAGE
             
             EVALUATE TRUE
             WHEN     SQL-STATUS-OK
                PERFORM COPY-HV-DATA-IN-LINKAGE
                MOVE "Last book selected."
                  TO LN-MSG-1          OF LN-MOD
                MOVE SPACES
                  TO LN-MSG-2          OF LN-MOD
         
             WHEN     SQL-STATUS-NOT-FOUND
                MOVE "No last book found."
                  TO LN-MSG-1          OF LN-MOD
                MOVE SPACES
                  TO LN-MSG-2          OF LN-MOD
         
             WHEN     OTHER
                CONTINUE
             END-EVALUATE
          END-IF      
          
      *>  always try to close the cursor, also in error cases    
          PERFORM SQL-CLOSE-CURSOR-BOOK-PL

      *>  There is no "WITH HOLD" option in cursor, therefore we need a commit.     
          PERFORM SQL-COMMIT
          
          .
       PAGING-LAST-EX.
          EXIT.


      *>------------------------------------------------------------------------
       LIST-FIRST SECTION.
      *>------------------------------------------------------------------------

      *>  A Cursor can not be declared in WORKING-STORAGE with ocesql.
      *>  We can not use the "WITH HOLD" option in cursor with ocesql.
      *>  Before Cursor declare we need a connection to DB.
          PERFORM SQL-DECLARE-CURSOR-BOOK-LF
      
          INITIALIZE LN-OUTPUT
          INITIALIZE HV-BOOK
      
          PERFORM SQL-OPEN-CURSOR-BOOK-LF

          PERFORM COPY-SQL-MSG-IN-LINKAGE

          IF SQL-STATUS-OK
          THEN
             PERFORM VARYING WS-IND-1 FROM 1 BY 1
               UNTIL WS-IND-1 > C-MAX-LINE-NR
          
                PERFORM SQL-FETCH-CURSOR-BOOK-LF
   
                PERFORM COPY-SQL-MSG-IN-LINKAGE
                
                EVALUATE TRUE
                WHEN     SQL-STATUS-OK
                   MOVE WS-IND-1
                     TO LN-OUT-BOOK-TAB-LINE-NR OF LN-MOD
                   
      *>           copy selected data in linkage
                   PERFORM COPY-LIST-IN-LINKAGE
                
                   MOVE "First book list selected."
                     TO LN-MSG-1       OF LN-MOD
                   MOVE SPACES
                     TO LN-MSG-2       OF LN-MOD
            
                WHEN     SQL-STATUS-NOT-FOUND
                   IF WS-IND-1 = 1
                   THEN
                      MOVE ZEROES
                        TO LN-OUT-BOOK-TAB-LINE-NR OF LN-MOD
                        
                      MOVE "No first book list found."
                        TO LN-MSG-1    OF LN-MOD
                      MOVE SPACES
                        TO LN-MSG-2    OF LN-MOD
                   ELSE     
                      MOVE "First book list selected."
                        TO LN-MSG-1    OF LN-MOD
                      MOVE SPACES
                        TO LN-MSG-2    OF LN-MOD
                   END-IF  
                   EXIT PERFORM
            
                WHEN     OTHER
                   EXIT PERFORM
                END-EVALUATE
             END-PERFORM   
          END-IF      
          
      *>  always try to close the cursor, also in error cases    
          PERFORM SQL-CLOSE-CURSOR-BOOK-LF
 
      *>  There is no "WITH HOLD" option in cursor, therefore we need a commit.     
          PERFORM SQL-COMMIT

          .
       LIST-FIRST-EX.
          EXIT.

      *>------------------------------------------------------------------------
       LIST-NEXT SECTION.
      *>------------------------------------------------------------------------

      *>  A Cursor can not be declared in WORKING-STORAGE with ocesql.
      *>  We can not use the "WITH HOLD" option in cursor with ocesql.
      *>  Before Cursor declare we need a connection to DB.
          PERFORM SQL-DECLARE-CURSOR-BOOK-LN
      
          INITIALIZE LN-OUTPUT
          INITIALIZE HV-BOOK
      
      *>  current value as restart point          
          MOVE LN-INP-AUTHORS          OF LN-MOD 
            TO HV-AUTHORS              OF HV-BOOK
          MOVE LN-INP-TITLE            OF LN-MOD 
            TO HV-TITLE                OF HV-BOOK
          MOVE LN-INP-ISBN             OF LN-MOD 
            TO HV-ISBN                 OF HV-BOOK
      
          PERFORM SQL-OPEN-CURSOR-BOOK-LN

          PERFORM COPY-SQL-MSG-IN-LINKAGE

          IF SQL-STATUS-OK
          THEN
             PERFORM VARYING WS-IND-1 FROM 1 BY 1
               UNTIL WS-IND-1 > C-MAX-LINE-NR
          
                PERFORM SQL-FETCH-CURSOR-BOOK-LN
   
                PERFORM COPY-SQL-MSG-IN-LINKAGE
                
                EVALUATE TRUE
                WHEN     SQL-STATUS-OK
                   MOVE WS-IND-1
                     TO LN-OUT-BOOK-TAB-LINE-NR OF LN-MOD
                   
      *>           copy selected data in linkage
                   PERFORM COPY-LIST-IN-LINKAGE
                
                   MOVE "Next book list selected."
                     TO LN-MSG-1       OF LN-MOD
                   MOVE SPACES
                     TO LN-MSG-2       OF LN-MOD
            
                WHEN     SQL-STATUS-NOT-FOUND
                   IF WS-IND-1 = 1
                   THEN
                      MOVE ZEROES
                        TO LN-OUT-BOOK-TAB-LINE-NR OF LN-MOD
                        
                      MOVE "No next book list found."
                        TO LN-MSG-1    OF LN-MOD
                      MOVE SPACES
                        TO LN-MSG-2    OF LN-MOD
                   ELSE     
                      MOVE "Next book list selected."
                        TO LN-MSG-1    OF LN-MOD
                      MOVE SPACES
                        TO LN-MSG-2    OF LN-MOD
                   END-IF  
                   EXIT PERFORM
            
                WHEN     OTHER
                   EXIT PERFORM
                END-EVALUATE
             END-PERFORM   
          END-IF      
          
      *>  always try to close the cursor, also in error cases    
          PERFORM SQL-CLOSE-CURSOR-BOOK-LN

      *>  There is no "WITH HOLD" option in cursor, therefore we need a commit.     
          PERFORM SQL-COMMIT
 
          .
       LIST-NEXT-EX.
          EXIT.

      *>------------------------------------------------------------------------
       LIST-PREVIOUS SECTION.
      *>------------------------------------------------------------------------

      *>  A Cursor can not be declared in WORKING-STORAGE with ocesql.
      *>  We can not use the "WITH HOLD" option in cursor with ocesql.
      *>  Before Cursor declare we need a connection to DB.
          PERFORM SQL-DECLARE-CURSOR-BOOK-LP
      
          INITIALIZE LN-OUTPUT
          INITIALIZE HV-BOOK

      *>  current value as restart point          
          MOVE LN-INP-AUTHORS          OF LN-MOD 
            TO HV-AUTHORS              OF HV-BOOK
          MOVE LN-INP-TITLE            OF LN-MOD 
            TO HV-TITLE                OF HV-BOOK
          MOVE LN-INP-ISBN             OF LN-MOD 
            TO HV-ISBN                 OF HV-BOOK
          
          PERFORM SQL-OPEN-CURSOR-BOOK-LP

          PERFORM COPY-SQL-MSG-IN-LINKAGE

          IF SQL-STATUS-OK
          THEN
             PERFORM VARYING WS-IND-1 FROM C-MAX-LINE-NR BY -1
               UNTIL WS-IND-1 < 1
          
                PERFORM SQL-FETCH-CURSOR-BOOK-LP
   
                PERFORM COPY-SQL-MSG-IN-LINKAGE
                
                EVALUATE TRUE
                WHEN     SQL-STATUS-OK
                   MOVE C-MAX-LINE-NR
                     TO LN-OUT-BOOK-TAB-LINE-NR OF LN-MOD
                   
      *>           copy selected data in linkage
                   PERFORM COPY-LIST-IN-LINKAGE
                
                   MOVE "Previous book list selected."
                     TO LN-MSG-1       OF LN-MOD
                   MOVE SPACES
                     TO LN-MSG-2       OF LN-MOD
            
                WHEN     SQL-STATUS-NOT-FOUND
                   IF WS-IND-1 = C-MAX-LINE-NR
                   THEN
                      MOVE ZEROES
                        TO LN-OUT-BOOK-TAB-LINE-NR OF LN-MOD
                        
                      MOVE "No previous book list found."
                        TO LN-MSG-1    OF LN-MOD
                      MOVE SPACES
                        TO LN-MSG-2    OF LN-MOD
                   ELSE     
                      MOVE "Previous book list selected."
                        TO LN-MSG-1    OF LN-MOD
                      MOVE SPACES
                        TO LN-MSG-2    OF LN-MOD
                   END-IF  
                   EXIT PERFORM
            
                WHEN     OTHER
                   EXIT PERFORM
                END-EVALUATE
             END-PERFORM   
          END-IF      
          
      *>  always try to close the cursor, also in error cases    
          PERFORM SQL-CLOSE-CURSOR-BOOK-LP

      *>  There is no "WITH HOLD" option in cursor, therefore we need a commit.     
          PERFORM SQL-COMMIT
 
          .
       LIST-PREVIOUS-EX.
          EXIT.

      *>------------------------------------------------------------------------
       LIST-LAST SECTION.
      *>------------------------------------------------------------------------

      *>  A Cursor can not be declared in WORKING-STORAGE with ocesql.
      *>  We can not use the "WITH HOLD" option in cursor with ocesql.
      *>  Before Cursor declare we need a connection to DB.
          PERFORM SQL-DECLARE-CURSOR-BOOK-LL
      
          INITIALIZE LN-OUTPUT
          INITIALIZE HV-BOOK
      
          PERFORM SQL-OPEN-CURSOR-BOOK-LL

          PERFORM COPY-SQL-MSG-IN-LINKAGE

          IF SQL-STATUS-OK
          THEN
             PERFORM VARYING WS-IND-1 FROM C-MAX-LINE-NR BY -1
               UNTIL WS-IND-1 < 1
          
                PERFORM SQL-FETCH-CURSOR-BOOK-LL
   
                PERFORM COPY-SQL-MSG-IN-LINKAGE
                
                EVALUATE TRUE
                WHEN     SQL-STATUS-OK
                   MOVE C-MAX-LINE-NR
                     TO LN-OUT-BOOK-TAB-LINE-NR OF LN-MOD
                   
      *>           copy selected data in linkage
                   PERFORM COPY-LIST-IN-LINKAGE
                
                   MOVE "Last book list selected."
                     TO LN-MSG-1       OF LN-MOD
                   MOVE SPACES
                     TO LN-MSG-2       OF LN-MOD
            
                WHEN     SQL-STATUS-NOT-FOUND
                   IF WS-IND-1 = C-MAX-LINE-NR
                   THEN
                      MOVE ZEROES
                        TO LN-OUT-BOOK-TAB-LINE-NR OF LN-MOD
                        
                      MOVE "No last book list found."
                        TO LN-MSG-1    OF LN-MOD
                      MOVE SPACES
                        TO LN-MSG-2    OF LN-MOD
                   ELSE     
                      MOVE "Last book list selected."
                        TO LN-MSG-1    OF LN-MOD
                      MOVE SPACES
                        TO LN-MSG-2    OF LN-MOD
                   END-IF  
                   EXIT PERFORM
            
                WHEN     OTHER
                   EXIT PERFORM
                END-EVALUATE
             END-PERFORM   
          END-IF      
          
      *>  always try to close the cursor, also in error cases    
          PERFORM SQL-CLOSE-CURSOR-BOOK-LL

      *>  There is no "WITH HOLD" option in cursor, therefore we need a commit.     
          PERFORM SQL-COMMIT
 
          .
       LIST-LAST-EX.
          EXIT.
          
      *>------------------------------------------------------------------------
       COPY-SQL-MSG-IN-LINKAGE SECTION.
      *>------------------------------------------------------------------------

      *>  get SQL message
          CALL "PGSQLMSG" USING SQLCA
                                LN-SQLMSG
          END-CALL
           
          MOVE SQLCODE         
            TO LN-SQLCODE              OF LN-MOD
          MOVE SQLSTATE       
            TO LN-SQLSTATE             OF LN-MOD
          MOVE LN-MSG-1                OF LN-SQLMSG         
            TO LN-MSG-1                OF LN-MOD
          MOVE LN-MSG-2                OF LN-SQLMSG         
            TO LN-MSG-2                OF LN-MOD
          MOVE LN-MSG-3                OF LN-SQLMSG         
            TO LN-MSG-3                OF LN-MOD
          MOVE LN-MSG-4                OF LN-SQLMSG         
            TO LN-MSG-4                OF LN-MOD
           
          .
       COPY-SQL-MSG-IN-LINKAGE-EX.
          EXIT.

      *>------------------------------------------------------------------------
       COPY-HV-DATA-IN-LINKAGE SECTION.
      *>------------------------------------------------------------------------

      *>  copy selected data in linkage
          MOVE HV-ISBN                 OF HV-BOOK
            TO LN-OUT-ISBN             OF LN-MOD
          MOVE HV-AUTHORS              OF HV-BOOK
            TO LN-OUT-AUTHORS          OF LN-MOD
          MOVE HV-TITLE                OF HV-BOOK
            TO LN-OUT-TITLE            OF LN-MOD
          MOVE HV-PUB-DATE             OF HV-BOOK
            TO LN-OUT-PUB-DATE         OF LN-MOD
          MOVE HV-PAGE-NR              OF HV-BOOK
            TO LN-OUT-PAGE-NR          OF LN-MOD
          MOVE HV-INSERT-USER          OF HV-BOOK
            TO LN-OUT-INSERT-USER      OF LN-MOD
          MOVE HV-INSERT-TIMESTAMP     OF HV-BOOK
            TO LN-OUT-INSERT-TIMESTAMP OF LN-MOD
          MOVE HV-LUPD-USER            OF HV-BOOK
            TO LN-OUT-LUPD-USER        OF LN-MOD
          MOVE HV-LUPD-TIMESTAMP       OF HV-BOOK
            TO LN-OUT-LUPD-TIMESTAMP   OF LN-MOD
          MOVE HV-LUPD-COUNTER         OF HV-BOOK
            TO LN-OUT-LUPD-COUNTER     OF LN-MOD
            
          .
       COPY-HV-DATA-IN-LINKAGE-EX.
          EXIT.

      *>------------------------------------------------------------------------
       COPY-LIST-IN-LINKAGE SECTION.
      *>------------------------------------------------------------------------

      *>  copy selected data in linkage
          INITIALIZE LN-OUT-BOOK-TAB-LINE(WS-IND-1)
          MOVE HV-AUTHORS              OF HV-BOOK
            TO LN-OUT-BOOK-TAB-AUTHORS(WS-IND-1)
          MOVE HV-TITLE                OF HV-BOOK
            TO LN-OUT-BOOK-TAB-TITLE(WS-IND-1)
          MOVE HV-ISBN                 OF HV-BOOK
            TO LN-OUT-BOOK-TAB-ISBN(WS-IND-1)
            
          .
       COPY-LIST-IN-LINKAGE-EX.
          EXIT.
          
      *>------------------------------------------------------------------------
       SQL-CONNECT SECTION.
      *>------------------------------------------------------------------------

          EXEC SQL  
               CONNECT       :HV-USERID 
               IDENTIFIED BY :HV-PSWD USING :HV-DBNAME 
          END-EXEC
          
          MOVE SQLCODE TO WS-SQL-STATUS
          
          .
       SQL-CONNECT-EX.
          EXIT.
      
      *>------------------------------------------------------------------------
       SQL-DISCONNECT SECTION.
      *>------------------------------------------------------------------------

          EXEC SQL  
               DISCONNECT ALL
          END-EXEC
          
          MOVE SQLCODE TO WS-SQL-STATUS
          
          .
       SQL-DISCONNECT-EX.
          EXIT.

      *>------------------------------------------------------------------------
       SQL-COMMIT SECTION.
      *>------------------------------------------------------------------------

          EXEC SQL  
               COMMIT
          END-EXEC
          
          MOVE SQLCODE TO WS-SQL-STATUS
          
          .
       SQL-COMMIT-EX.
          EXIT.
          
      *>------------------------------------------------------------------------
       SQL-ROLLBACK SECTION.
      *>------------------------------------------------------------------------

          EXEC SQL  
               ROLLBACK
          END-EXEC

          MOVE SQLCODE TO WS-SQL-STATUS
          
          .
       SQL-ROLLBACK-EX.
          EXIT.
          
      *>------------------------------------------------------------------------
       SQL-SELECT-BOOK SECTION.
      *>------------------------------------------------------------------------

          EXEC SQL
               SELECT ISBN                
                    , AUTHORS              
                    , TITLE               
                    , PUB_DATE            
                    , PAGE_NR                
                    , INSERT_USER         
                    , INSERT_TIMESTAMP    
                    , LUPD_USER           
                    , LUPD_TIMESTAMP      
                    , LUPD_COUNTER        
               INTO   :HV-ISBN            
                    , :HV-AUTHORS         
                    , :HV-TITLE             
                    , :HV-PUB-DATE          
                    , :HV-PAGE-NR              
                    , :HV-INSERT-USER       
                    , :HV-INSERT-TIMESTAMP  
                    , :HV-LUPD-USER         
                    , :HV-LUPD-TIMESTAMP    
                    , :HV-LUPD-COUNTER      
               FROM   BOOK
               WHERE  ISBN = :HV-ISBN
          END-EXEC
          
          MOVE SQLCODE TO WS-SQL-STATUS
          
          .
       SQL-SELECT-BOOK-EX.
          EXIT.

      *>------------------------------------------------------------------------
       SQL-INSERT-BOOK SECTION.
      *>------------------------------------------------------------------------

          EXEC SQL
               INSERT INTO BOOK
               (  ISBN         
                , AUTHORS              
                , TITLE               
                , PUB_DATE            
                , PAGE_NR                
                , INSERT_USER         
                , INSERT_TIMESTAMP    
                , LUPD_USER           
                , LUPD_TIMESTAMP      
                , LUPD_COUNTER        
               )
               VALUES
               (  :HV-ISBN
                , :HV-AUTHORS  
                , :HV-TITLE               
                , :HV-PUB-DATE            
                , :HV-PAGE-NR                
                , :HV-INSERT-USER         
                , CURRENT_TIMESTAMP    
                , :HV-LUPD-USER           
                , CURRENT_TIMESTAMP     
                , :HV-LUPD-COUNTER        
               )
          END-EXEC
          
          MOVE SQLCODE TO WS-SQL-STATUS
          
          .
       SQL-INSERT-BOOK-EX.
          EXIT.

      *>------------------------------------------------------------------------
       SQL-UPDATE-BOOK SECTION.
      *>------------------------------------------------------------------------

          EXEC SQL
               UPDATE BOOK
               SET       AUTHORS
                      = :HV-AUTHORS
                      ,  TITLE
                      = :HV-TITLE
                      ,  PUB_DATE
                      = :HV-PUB-DATE
                      ,  PAGE_NR
                      = :HV-PAGE-NR
                      ,  LUPD_USER
                      = :HV-LUPD-USER
                      ,  LUPD_TIMESTAMP
                      =  CURRENT_TIMESTAMP
                      ,  LUPD_COUNTER
                      = :HV-LUPD-COUNTER
               WHERE  ISBN           = :HV-ISBN
               AND    LUPD_TIMESTAMP = :HV-LUPD-TIMESTAMP-SAVE
               AND    LUPD_COUNTER   = :HV-LUPD-COUNTER-SAVE        
          END-EXEC
          
          MOVE SQLCODE TO WS-SQL-STATUS
          
          .
       SQL-UPDATE-BOOK-EX.
          EXIT.


      *>------------------------------------------------------------------------
       SQL-DELETE-BOOK SECTION.
      *>------------------------------------------------------------------------

          EXEC SQL
               DELETE
               FROM   BOOK
               WHERE  ISBN           = :HV-ISBN
               AND    LUPD_TIMESTAMP = :HV-LUPD-TIMESTAMP-SAVE
               AND    LUPD_COUNTER   = :HV-LUPD-COUNTER-SAVE        
          END-EXEC
          
          MOVE SQLCODE TO WS-SQL-STATUS
          
          .
       SQL-DELETE-BOOK-EX.
          EXIT.

      *>------------------------------------------------------------------------
       SQL-DECLARE-CURSOR-BOOK-PF SECTION.
      *>------------------------------------------------------------------------
      
      *>  cursor for paging first
          EXEC SQL
               DECLARE   CURSOR_BOOK_PF CURSOR FOR
               SELECT    ISBN            
                       , AUTHORS          
                       , TITLE           
                       , PUB_DATE        
                       , PAGE_NR         
                       , INSERT_USER     
                       , INSERT_TIMESTAMP
                       , LUPD_USER       
                       , LUPD_TIMESTAMP  
                       , LUPD_COUNTER    
               FROM      BOOK
               ORDER BY  ISBN             ASC
          END-EXEC
          
          .
       SQL-DECLARE-CURSOR-BOOK-PF-EX.
          EXIT.
      
      *>------------------------------------------------------------------------
       SQL-DECLARE-CURSOR-BOOK-PN SECTION.
      *>------------------------------------------------------------------------
      
      *>  cursor for paging next
          EXEC SQL
               DECLARE   CURSOR_BOOK_PN CURSOR FOR
               SELECT    ISBN            
                       , AUTHORS          
                       , TITLE           
                       , PUB_DATE        
                       , PAGE_NR         
                       , INSERT_USER     
                       , INSERT_TIMESTAMP
                       , LUPD_USER       
                       , LUPD_TIMESTAMP  
                       , LUPD_COUNTER    
               FROM      BOOK
               WHERE  (
                         ISBN
                      ) > (
                        :HV-ISBN
                      )
               ORDER BY  ISBN             ASC
          END-EXEC
          
          .
       SQL-DECLARE-CURSOR-BOOK-PN-EX.
          EXIT.
          
      *>------------------------------------------------------------------------
       SQL-DECLARE-CURSOR-BOOK-PP SECTION.
      *>------------------------------------------------------------------------
      
      *>  cursor for paging previous
          EXEC SQL
               DECLARE   CURSOR_BOOK_PP CURSOR FOR
               SELECT    ISBN            
                       , AUTHORS          
                       , TITLE           
                       , PUB_DATE        
                       , PAGE_NR         
                       , INSERT_USER     
                       , INSERT_TIMESTAMP
                       , LUPD_USER       
                       , LUPD_TIMESTAMP  
                       , LUPD_COUNTER    
               FROM      BOOK
               WHERE  (
                         ISBN
                      ) < (
                        :HV-ISBN
                      )
               ORDER BY  ISBN             DESC
          END-EXEC
          
          .
       SQL-DECLARE-CURSOR-BOOK-PP-EX.
          EXIT.
      
      *>------------------------------------------------------------------------
       SQL-DECLARE-CURSOR-BOOK-PL SECTION.
      *>------------------------------------------------------------------------
      
      *>  cursor for paging last
          EXEC SQL
               DECLARE   CURSOR_BOOK_PL CURSOR FOR
               SELECT    ISBN            
                       , AUTHORS          
                       , TITLE           
                       , PUB_DATE        
                       , PAGE_NR         
                       , INSERT_USER     
                       , INSERT_TIMESTAMP
                       , LUPD_USER       
                       , LUPD_TIMESTAMP  
                       , LUPD_COUNTER    
               FROM      BOOK
               ORDER BY  ISBN             DESC
          END-EXEC
      
          .
       SQL-DECLARE-CURSOR-BOOK-PL-EX.
          EXIT.

      *>------------------------------------------------------------------------
       SQL-DECLARE-CURSOR-BOOK-LF SECTION.
      *>------------------------------------------------------------------------
      
      *>  cursor for list first
          EXEC SQL
               DECLARE   CURSOR_BOOK_LF CURSOR FOR
               SELECT    AUTHORS          
                       , TITLE     
                       , ISBN                    
               FROM      BOOK
               ORDER BY  AUTHORS          ASC
                       , TITLE            ASC
                       , ISBN             ASC
          END-EXEC
          
          .
       SQL-DECLARE-CURSOR-BOOK-LF-EX.
          EXIT.
      
      *>------------------------------------------------------------------------
       SQL-DECLARE-CURSOR-BOOK-LN SECTION.
      *>------------------------------------------------------------------------
      
      *>  cursor for list next
          EXEC SQL
               DECLARE   CURSOR_BOOK_LN CURSOR FOR
               SELECT    AUTHORS          
                       , TITLE     
                       , ISBN                    
               FROM      BOOK
               WHERE  (
                         AUTHORS  
                       , TITLE
                       , ISBN
                      ) > (
                        :HV-AUTHORS
                       ,:HV-TITLE
                       ,:HV-ISBN
                      )
               ORDER BY  AUTHORS          ASC
                       , TITLE            ASC
                       , ISBN             ASC
          END-EXEC
          
          .
       SQL-DECLARE-CURSOR-BOOK-LN-EX.
          EXIT.
          
      *>------------------------------------------------------------------------
       SQL-DECLARE-CURSOR-BOOK-LP SECTION.
      *>------------------------------------------------------------------------
      
      *>  cursor for list previous
          EXEC SQL
               DECLARE   CURSOR_BOOK_LP CURSOR FOR
               SELECT    AUTHORS          
                       , TITLE     
                       , ISBN                    
               FROM      BOOK
               WHERE  (
                         AUTHORS  
                       , TITLE
                       , ISBN
                      ) < (
                        :HV-AUTHORS
                       ,:HV-TITLE
                       ,:HV-ISBN
                      )
               ORDER BY  AUTHORS          DESC
                       , TITLE            DESC
                       , ISBN             DESC
          END-EXEC
          
          .
       SQL-DECLARE-CURSOR-BOOK-LP-EX.
          EXIT.
      
      *>------------------------------------------------------------------------
       SQL-DECLARE-CURSOR-BOOK-LL SECTION.
      *>------------------------------------------------------------------------
      
      *>  cursor for list last
          EXEC SQL
               DECLARE   CURSOR_BOOK_LL CURSOR FOR
               SELECT    AUTHORS          
                       , TITLE     
                       , ISBN                    
               FROM      BOOK
               ORDER BY  AUTHORS          DESC
                       , TITLE            DESC
                       , ISBN             DESC
          END-EXEC
      
          .
       SQL-DECLARE-CURSOR-BOOK-LL-EX.
          EXIT.
          
      *>------------------------------------------------------------------------
       SQL-OPEN-CURSOR-BOOK-PF SECTION.
      *>------------------------------------------------------------------------

          EXEC SQL
               OPEN CURSOR_BOOK_PF
          END-EXEC
          
          MOVE SQLCODE TO WS-SQL-STATUS
          
          .
       SQL-OPEN-CURSOR-BOOK-PF-EX.
          EXIT.
          
      *>------------------------------------------------------------------------
       SQL-OPEN-CURSOR-BOOK-PN SECTION.
      *>------------------------------------------------------------------------

          EXEC SQL
               OPEN CURSOR_BOOK_PN
          END-EXEC
          
          MOVE SQLCODE TO WS-SQL-STATUS
          
          .
       SQL-OPEN-CURSOR-BOOK-PN-EX.
          EXIT.

      *>------------------------------------------------------------------------
       SQL-OPEN-CURSOR-BOOK-PP SECTION.
      *>------------------------------------------------------------------------

          EXEC SQL
               OPEN CURSOR_BOOK_PP
          END-EXEC
          
          MOVE SQLCODE TO WS-SQL-STATUS
          
          .
       SQL-OPEN-CURSOR-BOOK-PP-EX.
          EXIT.
          
      *>------------------------------------------------------------------------
       SQL-OPEN-CURSOR-BOOK-PL SECTION.
      *>------------------------------------------------------------------------

          EXEC SQL
               OPEN CURSOR_BOOK_PL
          END-EXEC
          
          MOVE SQLCODE TO WS-SQL-STATUS
          
          .
       SQL-OPEN-CURSOR-BOOK-PL-EX.
          EXIT.

      *>------------------------------------------------------------------------
       SQL-OPEN-CURSOR-BOOK-LF SECTION.
      *>------------------------------------------------------------------------

          EXEC SQL
               OPEN CURSOR_BOOK_LF
          END-EXEC
          
          MOVE SQLCODE TO WS-SQL-STATUS
          
          .
       SQL-OPEN-CURSOR-BOOK-LF-EX.
          EXIT.

      *>------------------------------------------------------------------------
       SQL-OPEN-CURSOR-BOOK-LN SECTION.
      *>------------------------------------------------------------------------

          EXEC SQL
               OPEN CURSOR_BOOK_LN
          END-EXEC
          
          MOVE SQLCODE TO WS-SQL-STATUS
          
          .
       SQL-OPEN-CURSOR-BOOK-LN-EX.
          EXIT.

      *>------------------------------------------------------------------------
       SQL-OPEN-CURSOR-BOOK-LP SECTION.
      *>------------------------------------------------------------------------

          EXEC SQL
               OPEN CURSOR_BOOK_LP
          END-EXEC
          
          MOVE SQLCODE TO WS-SQL-STATUS
          
          .
       SQL-OPEN-CURSOR-BOOK-LP-EX.
          EXIT.
          
      *>------------------------------------------------------------------------
       SQL-OPEN-CURSOR-BOOK-LL SECTION.
      *>------------------------------------------------------------------------

          EXEC SQL
               OPEN CURSOR_BOOK_LL
          END-EXEC
          
          MOVE SQLCODE TO WS-SQL-STATUS
          
          .
       SQL-OPEN-CURSOR-BOOK-LL-EX.
          EXIT.
          
      *>------------------------------------------------------------------------
       SQL-FETCH-CURSOR-BOOK-PF SECTION.
      *>------------------------------------------------------------------------

          EXEC SQL
               FETCH CURSOR_BOOK_PF
               INTO    :HV-ISBN   
                     , :HV-AUTHORS  
                     , :HV-TITLE            
                     , :HV-PUB-DATE         
                     , :HV-PAGE-NR          
                     , :HV-INSERT-USER      
                     , :HV-INSERT-TIMESTAMP 
                     , :HV-LUPD-USER        
                     , :HV-LUPD-TIMESTAMP   
                     , :HV-LUPD-COUNTER     
          END-EXEC
          
          MOVE SQLCODE TO WS-SQL-STATUS
          
          .
       SQL-FETCH-CURSOR-BOOK-PF-EX.
          EXIT.
          
      *>------------------------------------------------------------------------
       SQL-FETCH-CURSOR-BOOK-PN SECTION.
      *>------------------------------------------------------------------------

          EXEC SQL
               FETCH CURSOR_BOOK_PN
               INTO    :HV-ISBN   
                     , :HV-AUTHORS  
                     , :HV-TITLE            
                     , :HV-PUB-DATE         
                     , :HV-PAGE-NR          
                     , :HV-INSERT-USER      
                     , :HV-INSERT-TIMESTAMP 
                     , :HV-LUPD-USER        
                     , :HV-LUPD-TIMESTAMP   
                     , :HV-LUPD-COUNTER     
          END-EXEC
          
          MOVE SQLCODE TO WS-SQL-STATUS
          
          .
       SQL-FETCH-CURSOR-BOOK-PN-EX.
          EXIT.
          
      *>------------------------------------------------------------------------
       SQL-FETCH-CURSOR-BOOK-PP SECTION.
      *>------------------------------------------------------------------------

          EXEC SQL
               FETCH CURSOR_BOOK_PP
               INTO    :HV-ISBN   
                     , :HV-AUTHORS  
                     , :HV-TITLE            
                     , :HV-PUB-DATE         
                     , :HV-PAGE-NR          
                     , :HV-INSERT-USER      
                     , :HV-INSERT-TIMESTAMP 
                     , :HV-LUPD-USER        
                     , :HV-LUPD-TIMESTAMP   
                     , :HV-LUPD-COUNTER     
          END-EXEC
          
          MOVE SQLCODE TO WS-SQL-STATUS
          
          .
       SQL-FETCH-CURSOR-BOOK-PP-EX.
          EXIT.
          
      *>------------------------------------------------------------------------
       SQL-FETCH-CURSOR-BOOK-PL SECTION.
      *>------------------------------------------------------------------------

          EXEC SQL
               FETCH CURSOR_BOOK_PL
               INTO    :HV-ISBN   
                     , :HV-AUTHORS  
                     , :HV-TITLE            
                     , :HV-PUB-DATE         
                     , :HV-PAGE-NR          
                     , :HV-INSERT-USER      
                     , :HV-INSERT-TIMESTAMP 
                     , :HV-LUPD-USER        
                     , :HV-LUPD-TIMESTAMP   
                     , :HV-LUPD-COUNTER     
          END-EXEC
          
          MOVE SQLCODE TO WS-SQL-STATUS
          
          .
       SQL-FETCH-CURSOR-BOOK-PL-EX.
          EXIT.

      *>------------------------------------------------------------------------
       SQL-FETCH-CURSOR-BOOK-LF SECTION.
      *>------------------------------------------------------------------------

          EXEC SQL
               FETCH CURSOR_BOOK_LF
               INTO    :HV-AUTHORS  
                     , :HV-TITLE            
                     , :HV-ISBN   
          END-EXEC
          
          MOVE SQLCODE TO WS-SQL-STATUS
          
          .
       SQL-FETCH-CURSOR-BOOK-LF-EX.
          EXIT.

      *>------------------------------------------------------------------------
       SQL-FETCH-CURSOR-BOOK-LN SECTION.
      *>------------------------------------------------------------------------

          EXEC SQL
               FETCH CURSOR_BOOK_LN
               INTO    :HV-AUTHORS  
                     , :HV-TITLE            
                     , :HV-ISBN   
          END-EXEC
          
          MOVE SQLCODE TO WS-SQL-STATUS
          
          .
       SQL-FETCH-CURSOR-BOOK-LN-EX.
          EXIT.

      *>------------------------------------------------------------------------
       SQL-FETCH-CURSOR-BOOK-LP SECTION.
      *>------------------------------------------------------------------------

          EXEC SQL
               FETCH CURSOR_BOOK_LP
               INTO    :HV-AUTHORS  
                     , :HV-TITLE            
                     , :HV-ISBN   
          END-EXEC
          
          MOVE SQLCODE TO WS-SQL-STATUS
          
          .
       SQL-FETCH-CURSOR-BOOK-LP-EX.
          EXIT.
          
      *>------------------------------------------------------------------------
       SQL-FETCH-CURSOR-BOOK-LL SECTION.
      *>------------------------------------------------------------------------

          EXEC SQL
               FETCH CURSOR_BOOK_LL
               INTO    :HV-AUTHORS  
                     , :HV-TITLE            
                     , :HV-ISBN   
          END-EXEC
          
          MOVE SQLCODE TO WS-SQL-STATUS
          
          .
       SQL-FETCH-CURSOR-BOOK-LL-EX.
          EXIT.
          
      *>------------------------------------------------------------------------
       SQL-CLOSE-CURSOR-BOOK-PF SECTION.
      *>------------------------------------------------------------------------

          EXEC SQL
               CLOSE CURSOR_BOOK_PF
          END-EXEC
          
          MOVE SQLCODE TO WS-SQL-STATUS
          
          .
       SQL-CLOSE-CURSOR-BOOK-PF-EX.
          EXIT.
          
      *>------------------------------------------------------------------------
       SQL-CLOSE-CURSOR-BOOK-PN SECTION.
      *>------------------------------------------------------------------------

          EXEC SQL
               CLOSE CURSOR_BOOK_PN
          END-EXEC
          
          MOVE SQLCODE TO WS-SQL-STATUS
          
          .
       SQL-CLOSE-CURSOR-BOOK-PN-EX.
          EXIT.
          
      *>------------------------------------------------------------------------
       SQL-CLOSE-CURSOR-BOOK-PP SECTION.
      *>------------------------------------------------------------------------

          EXEC SQL
               CLOSE CURSOR_BOOK_PP
          END-EXEC
          
          MOVE SQLCODE TO WS-SQL-STATUS
          
          .
       SQL-CLOSE-CURSOR-BOOK-PP-EX.
          EXIT.
          
      *>------------------------------------------------------------------------
       SQL-CLOSE-CURSOR-BOOK-PL SECTION.
      *>------------------------------------------------------------------------

          EXEC SQL
               CLOSE CURSOR_BOOK_PL
          END-EXEC
          
          MOVE SQLCODE TO WS-SQL-STATUS
          
          .
       SQL-CLOSE-CURSOR-BOOK-PL-EX.
          EXIT.
          
      *>------------------------------------------------------------------------
       SQL-CLOSE-CURSOR-BOOK-LF SECTION.
      *>------------------------------------------------------------------------

          EXEC SQL
               CLOSE CURSOR_BOOK_LF
          END-EXEC
          
          MOVE SQLCODE TO WS-SQL-STATUS
          
          .
       SQL-CLOSE-CURSOR-BOOK-LF-EX.
          EXIT.

      *>------------------------------------------------------------------------
       SQL-CLOSE-CURSOR-BOOK-LN SECTION.
      *>------------------------------------------------------------------------

          EXEC SQL
               CLOSE CURSOR_BOOK_LN
          END-EXEC
          
          MOVE SQLCODE TO WS-SQL-STATUS
          
          .
       SQL-CLOSE-CURSOR-BOOK-LN-EX.
          EXIT.

      *>------------------------------------------------------------------------
       SQL-CLOSE-CURSOR-BOOK-LP SECTION.
      *>------------------------------------------------------------------------

          EXEC SQL
               CLOSE CURSOR_BOOK_LP
          END-EXEC
          
          MOVE SQLCODE TO WS-SQL-STATUS
          
          .
       SQL-CLOSE-CURSOR-BOOK-LP-EX.
          EXIT.
          
      *>------------------------------------------------------------------------
       SQL-CLOSE-CURSOR-BOOK-LL SECTION.
      *>------------------------------------------------------------------------

          EXEC SQL
               CLOSE CURSOR_BOOK_LL
          END-EXEC
          
          MOVE SQLCODE TO WS-SQL-STATUS
          
          .
       SQL-CLOSE-CURSOR-BOOK-LL-EX.
          EXIT.
          
       END PROGRAM PGMOD7.
