      *>************************************************************************
      *>  This file is part of DBsample.
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
      *> Purpose:      PostgreSQL sample module
      *>
      *> Author:       Laszlo Erdos - https://www.facebook.com/wortfee
      *>
      *> Date-Written: 2018.07.13
      *>
      *> Usage:        To use this module, simply CALL it as follows: 
      *>               CALL "PGMOD1" USING LN-MOD
      *>
      *>               Implemented features:
      *>               - connect to PostgreSQL
      *>               - disconnect
      *>
      *>************************************************************************
      *> Date       Name / Change description 
      *> ========== ============================================================
      *> 2018.07.13 Laszlo Erdos: 
      *>            - first version. 
      *>************************************************************************
      
       IDENTIFICATION DIVISION.
       PROGRAM-ID. PGMOD1.
      
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
      *> connect fields 
       01 HV-DBNAME                    PIC X(20) VALUE SPACE.
       01 HV-USERID                    PIC X(20) VALUE SPACE.
       01 HV-PSWD                      PIC X(20) VALUE SPACE.
       EXEC SQL END   DECLARE SECTION END-EXEC.
       
       LINKAGE SECTION.
       COPY "LNMOD1.cpy".
       
       PROCEDURE DIVISION USING LN-MOD.
      
      *>------------------------------------------------------------------------
       MAIN-PGMOD1 SECTION.
      *>------------------------------------------------------------------------

          INITIALIZE LN-MSG
      
          EVALUATE TRUE
             WHEN V-LN-FNC-CONNECT
                PERFORM CONNECT
          
             WHEN V-LN-FNC-DISCONNECT
                PERFORM DISCONNECT
                
             WHEN OTHER
                MOVE "Wrong linkage function" 
                  TO LN-MSG-1 OF LN-MOD
          END-EVALUATE
      
          GOBACK
      
          .
       MAIN-PGMOD1-EX.
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
      
       END PROGRAM PGMOD1.
