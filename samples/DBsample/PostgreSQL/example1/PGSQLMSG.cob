      *>************************************************************************
      *>  This file is part of DBsample.
      *>
      *>  PGSQLMSG.cob is free software: you can redistribute it and/or 
      *>  modify it under the terms of the GNU Lesser General Public License as 
      *>  published by the Free Software Foundation, either version 3 of the
      *>  License, or (at your option) any later version.
      *>
      *>  PGSQLMSG.cob is distributed in the hope that it will be useful, 
      *>  but WITHOUT ANY WARRANTY; without even the implied warranty of 
      *>  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
      *>  See the GNU Lesser General Public License for more details.
      *>
      *>  You should have received a copy of the GNU Lesser General Public  
      *>  License along with PGSQLMSG.cob.
      *>  If not, see <http://www.gnu.org/licenses/>.
      *>************************************************************************
      
      *>************************************************************************
      *> Program:      PGSQLMSG.cob
      *>
      *> Purpose:      Read PostgreSQL SQLCODE and SQLSTATE messages
      *>
      *> Author:       Laszlo Erdos - https://www.facebook.com/wortfee
      *>
      *> Date-Written: 2018.07.13
      *>
      *> Usage:        Use this module in GnuCOBOL PostgreSQL programs to get
      *>               the SQLCODE and SQLSTATE messages.
      *>
      *>               To use this module, simply CALL it as follows: 
      *>               CALL "PGSQLMSG" USING SQLCA
      *>                                     LN-SQLMSG
      *>               where:
      *>                 SQLCA     - input, SQL communication area 
      *>                 LN-SQLMSG - output, SQLCODE and SQLSTATE messages
      *>
      *>************************************************************************
      *> Date       Name / Change description 
      *> ========== ============================================================
      *> 2018.07.13 Laszlo Erdos: 
      *>            - first version. 
      *>************************************************************************
      
       IDENTIFICATION DIVISION.
       PROGRAM-ID. PGSQLMSG.
      
       ENVIRONMENT DIVISION.
      
       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01 WS-ERROR-BUFFER              PIC X(256).
       01 WS-STATE-BUFFER              PIC X(256).
       
       COPY "STATETXT.cpy".
       
       LINKAGE SECTION.
       COPY "sqlca.cbl".
       COPY "LNSQLMSG.cpy".
       
       PROCEDURE DIVISION USING SQLCA 
                                LN-SQLMSG.
                                
      *>------------------------------------------------------------------------
       MAIN-PGSQLMSG SECTION.
      *>------------------------------------------------------------------------
      
          INITIALIZE LN-SQLMSG
          MOVE SPACES TO WS-ERROR-BUFFER
          MOVE SPACES TO WS-STATE-BUFFER
      
          IF  SQLERRML OF SQLCA > ZEROES
          AND SQLERRMC OF SQLCA(1:SQLERRML OF SQLCA) NOT = SPACES
          THEN
             MOVE SQLERRMC OF SQLCA(1:SQLERRML OF SQLCA)
               TO WS-ERROR-BUFFER
          ELSE
      *>     search SQLCODE message    
             SET WS-CODETXT-IDX TO 1
             SEARCH WS-SQL-CODETXT-LINES
                AT END MOVE SPACES TO WS-ERROR-BUFFER
                WHEN WS-SQL-CODETXT-NUM(WS-CODETXT-IDX) 
                                              = SQLCODE OF SQLCA 
                     MOVE WS-SQL-CODETXT-TEXT(WS-CODETXT-IDX) 
                       TO WS-ERROR-BUFFER
             END-SEARCH      
          END-IF
          
      *>  replace hexa 00-0F with spaces
          INSPECT WS-ERROR-BUFFER CONVERTING
               X"000102030405060708090A0B0C0D0E0F" 
             TO "                "

      *>  replace hexa 10-1F with spaces
          INSPECT WS-ERROR-BUFFER CONVERTING
               X"101112131415161718191A1B1C1D1E1F" 
             TO "                "
             
      *>  search SQLSTATE message    
          SET WS-STATETXT-IDX TO 1
          SEARCH WS-SQL-STATETXT-LINES
             AT END MOVE SPACES TO WS-STATE-BUFFER
             WHEN WS-SQL-STATETXT-NUM(WS-STATETXT-IDX) 
                                           = SQLSTATE OF SQLCA 
                  MOVE WS-SQL-STATETXT-TEXT(WS-STATETXT-IDX) 
                    TO WS-STATE-BUFFER
          END-SEARCH      
      
      *>  replace hexa 00-0F with spaces
          INSPECT WS-STATE-BUFFER CONVERTING
               X"000102030405060708090A0B0C0D0E0F" 
             TO "                "

      *>  replace hexa 10-1F with spaces
          INSPECT WS-STATE-BUFFER CONVERTING
               X"101112131415161718191A1B1C1D1E1F" 
             TO "                "
             
      *>  replace German chars
      *>  INSPECT WS-STATE-BUFFER CONVERTING
      *>        X"81848E94999AE1" 
      *>     TO X"7561416F4F5573"
          
          MOVE WS-ERROR-BUFFER( 1:80) TO LN-MSG-1
          MOVE WS-ERROR-BUFFER(81:80) TO LN-MSG-2
          
          MOVE WS-STATE-BUFFER( 1:80) TO LN-MSG-3
          MOVE WS-STATE-BUFFER(81:80) TO LN-MSG-4
      
          GOBACK
      
          .
       MAIN-PGSQLMSG-EX.
          EXIT.
          
       END PROGRAM PGSQLMSG.
