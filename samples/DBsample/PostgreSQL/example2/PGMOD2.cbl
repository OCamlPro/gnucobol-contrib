      *>************************************************************************
      *>  This file is part of DBsample.
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
      *> Purpose:      PostgreSQL sample module
      *>
      *> Author:       Laszlo Erdos - https://www.facebook.com/wortfee
      *>
      *> Date-Written: 2018.07.13
      *>
      *> Usage:        To use this module, simply CALL it as follows: 
      *>               CALL "PGMOD2" USING LN-MOD
      *>
      *>               Implemented features:
      *>               - connect to PostgreSQL
      *>               - disconnect
      *>               - select book
      *>
      *>************************************************************************
      *> Date       Name / Change description 
      *> ========== ============================================================
      *> 2018.07.13 Laszlo Erdos: 
      *>            - first version. 
      *>************************************************************************
      
       IDENTIFICATION DIVISION.
       PROGRAM-ID. PGMOD2.
      
       ENVIRONMENT DIVISION.
      
       DATA DIVISION.
       WORKING-STORAGE SECTION.
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
           
      *> connect fields 
       01 HV-DBNAME                    PIC X(20) VALUE SPACE.
       01 HV-USERID                    PIC X(20) VALUE SPACE.
       01 HV-PSWD                      PIC X(20) VALUE SPACE.
       EXEC SQL END   DECLARE SECTION END-EXEC.
       
       LINKAGE SECTION.
       COPY "LNMOD2.cpy".
       
       PROCEDURE DIVISION USING LN-MOD.
      
      *>------------------------------------------------------------------------
       MAIN-PGMOD2 SECTION.
      *>------------------------------------------------------------------------

          INITIALIZE LN-MSG
      
          EVALUATE TRUE
             WHEN V-LN-FNC-CONNECT
                PERFORM CONNECT
          
             WHEN V-LN-FNC-DISCONNECT
                PERFORM DISCONNECT

             WHEN V-LN-FNC-SELECT
                PERFORM SELECT-BOOK
                
             WHEN OTHER
                MOVE "Wrong linkage function" 
                  TO LN-MSG-1 OF LN-MOD
          END-EVALUATE
      
          GOBACK
      
          .
       MAIN-PGMOD2-EX.
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
          
       END PROGRAM PGMOD2.
