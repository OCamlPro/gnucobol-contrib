      *>************************************************************************
      *>  This file is part of DB2sample.
      *>
      *>  DB2TEST2.cob is free software: you can redistribute it and/or 
      *>  modify it under the terms of the GNU Lesser General Public License as 
      *>  published by the Free Software Foundation, either version 3 of the
      *>  License, or (at your option) any later version.
      *>
      *>  DB2TEST2.cob is distributed in the hope that it will be useful, 
      *>  but WITHOUT ANY WARRANTY; without even the implied warranty of 
      *>  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
      *>  See the GNU Lesser General Public License for more details.
      *>
      *>  You should have received a copy of the GNU Lesser General Public  
      *>  License along with DB2TEST2.cob.
      *>  If not, see <http://www.gnu.org/licenses/>.
      *>************************************************************************
      
      *>************************************************************************
      *> Program:      DB2TEST2.cob
      *>
      *> Purpose:      Test program for the DB2 sample module
      *>
      *> Author:       Laszlo Erdos - https://www.facebook.com/wortfee
      *>
      *> Date-Written: 2015.12.24
      *>
      *> Tectonics:    cobc -x DB2TEST2.cob
      *>
      *> Usage:        This is a test program for the DB2 sample module. You
      *>               can call and test through a few simple screens the 
      *>               code in the DB2 module.
      *>
      *>               Implemented features:
      *>               - connect to DB2
      *>               - connect reset
      *>               - select book
      *>
      *>************************************************************************
      *> Date       Name / Change description 
      *> ========== ============================================================
      *> 2015.12.24 Laszlo Erdos: 
      *>            - first version. 
      *>************************************************************************
      
       IDENTIFICATION DIVISION.
       PROGRAM-ID. DB2TEST2.
      
       ENVIRONMENT DIVISION.
       CONFIGURATION SECTION.
       SPECIAL-NAMES.
          CRT STATUS IS WS-FNC-KEY.
       
       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01 WS-FNC-KEY                   PIC 9(4).
          88 V-FNC-F1                  VALUE 1001.
          88 V-FNC-F2                  VALUE 1002.
          88 V-FNC-F3                  VALUE 1003.
          88 V-FNC-F9                  VALUE 1009.
          88 V-FNC-F10                 VALUE 1010.
       01 WS-ACCEPT-FNC-KEY            PIC X.

       01 WS-MSG.
         02 WS-SQLCODE                 PIC S9(10).
         02 WS-SQLSTATE                PIC X(5).
         02 WS-MSG-1                   PIC X(80).
         02 WS-MSG-2                   PIC X(80).
         02 WS-MSG-3                   PIC X(80).
         02 WS-MSG-4                   PIC X(80).

       01 WS-CONNECT.
         02 WS-DBALIAS                 PIC X(9).
         02 WS-USERID                  PIC X(20).
         02 WS-PSWD                    PIC X(20).

       01 WS-INP-BOOK.  
         02 WS-INP-ISBN                PIC 9(13). 
         
       01 WS-OUT-BOOK.  
         02 WS-OUT-ISBN                PIC 9(13). 
         02 WS-OUT-AUTHOR              PIC X(40).
         02 WS-OUT-TITLE               PIC X(60).
         02 WS-OUT-PUB-DATE            PIC X(10).
         02 WS-OUT-PAGE-NR             PIC 9(4).
         02 WS-OUT-INSERT-USER         PIC X(20).
         02 WS-OUT-INSERT-TIMESTAMP    PIC X(26).
         02 WS-OUT-LUPD-USER           PIC X(20).
         02 WS-OUT-LUPD-TIMESTAMP      PIC X(26).
         02 WS-OUT-LUPD-COUNTER        PIC 9(6).

      *> linkage 
       COPY "LNMOD2.cpy".
       
      *> colors
       COPY SCREENIO.
      
       SCREEN SECTION.
       01 HEADER-SCREEN.
          05 FILLER LINE 2 COLUMN 13
             VALUE "DB2 sample program, please select a function"
      *>     this deletes the screen       
             BLANK SCREEN
             FOREGROUND-COLOR COB-COLOR-GREEN.
      
       01 MAIN-FUNCTION-SCREEN.
          05 FILLER LINE 4 COLUMN 5
             VALUE "F1 - Connect to DB2"
             FOREGROUND-COLOR COB-COLOR-GREEN.
          05 FILLER LINE 5 COLUMN 5
             VALUE "F2 - Connect reset"
             FOREGROUND-COLOR COB-COLOR-GREEN.
          05 FILLER LINE 6 COLUMN 5
             VALUE "F3 - Select book"
             FOREGROUND-COLOR COB-COLOR-GREEN.
      
          05 FILLER LINE 18 COLUMN 5
             VALUE "F9 - Exit"
             FOREGROUND-COLOR COB-COLOR-GREEN.
          05 FILLER PIC X TO WS-ACCEPT-FNC-KEY SECURE
             LINE 18 COLUMN 79
             FOREGROUND-COLOR COB-COLOR-GREEN.
             
       01 MESSAGE-SCREEN.
      *> line 20
          05 FILLER LINE 20 COLUMN 1
             VALUE "SQLCODE: "
             FOREGROUND-COLOR COB-COLOR-GREEN.
          05 FILLER PIC -Z(9)9 FROM WS-SQLCODE OF WS-MSG
             LINE 20 COLUMN 10
             FOREGROUND-COLOR COB-COLOR-GREEN.
          05 FILLER LINE 20 COLUMN 30
             VALUE "SQLSTATE: "
             FOREGROUND-COLOR COB-COLOR-GREEN.
          05 FILLER PIC X(5) FROM WS-SQLSTATE OF WS-MSG
             LINE 20 COLUMN 40
             FOREGROUND-COLOR COB-COLOR-GREEN.
      *> line 21
          05 FILLER PIC X(80) FROM WS-MSG-1 OF WS-MSG
             LINE 21 COLUMN 1
             FOREGROUND-COLOR COB-COLOR-GREEN.
      *> line 22
          05 FILLER PIC X(80) FROM WS-MSG-2 OF WS-MSG
             LINE 22 COLUMN 1
             FOREGROUND-COLOR COB-COLOR-GREEN.
      *> line 23
          05 FILLER PIC X(80) FROM WS-MSG-3 OF WS-MSG
             LINE 23 COLUMN 1
             FOREGROUND-COLOR COB-COLOR-GREEN.
      *> line 24
          05 FILLER PIC X(80) FROM WS-MSG-4 OF WS-MSG
             LINE 24 COLUMN 1
             FOREGROUND-COLOR COB-COLOR-GREEN.

       01 CONNECT-SCREEN.
          05 FILLER LINE 4 COLUMN 1
             VALUE "DBALIAS:"
             FOREGROUND-COLOR COB-COLOR-GREEN.
          05 FILLER PIC X(9) TO WS-DBALIAS
             LINE 4 COLUMN 10
             FOREGROUND-COLOR COB-COLOR-GREEN.
          05 FILLER LINE 4 COLUMN 50
             VALUE "eg.: testdb"
             FOREGROUND-COLOR COB-COLOR-GREEN.
          05 FILLER LINE 5 COLUMN 1
             VALUE "USERID:"
             FOREGROUND-COLOR COB-COLOR-GREEN.
          05 FILLER PIC X(20) TO WS-USERID
             LINE 5 COLUMN 10
             FOREGROUND-COLOR COB-COLOR-GREEN.
          05 FILLER LINE 5 COLUMN 50
             VALUE "eg.: LASZLO.ERDOES"
             FOREGROUND-COLOR COB-COLOR-GREEN.
          05 FILLER LINE 6 COLUMN 1
             VALUE "PSWD:"
             FOREGROUND-COLOR COB-COLOR-GREEN.
          05 FILLER PIC X(20) TO WS-PSWD SECURE
             LINE 6 COLUMN 10
             FOREGROUND-COLOR COB-COLOR-GREEN.
          05 FILLER LINE 6 COLUMN 50
             VALUE "eg.: laszlopw"
             FOREGROUND-COLOR COB-COLOR-GREEN.
          05 FILLER LINE 18 COLUMN 1    
             VALUE "F1 - Connect to DB2"
             FOREGROUND-COLOR COB-COLOR-GREEN.
          05 FILLER LINE 18 COLUMN 25    
             VALUE "F10 - Back to main"
             FOREGROUND-COLOR COB-COLOR-GREEN.
          05 FILLER PIC X TO WS-ACCEPT-FNC-KEY SECURE
             LINE 18 COLUMN 79
             FOREGROUND-COLOR COB-COLOR-GREEN.

       01 SELECT-BOOK-SCREEN.
          05 FILLER LINE 4 COLUMN 1
             VALUE "ISBN:"
             FOREGROUND-COLOR COB-COLOR-GREEN.
          05 FILLER PIC 9(13) TO WS-INP-ISBN
             LINE 4 COLUMN 10
             FOREGROUND-COLOR COB-COLOR-GREEN.
          05 FILLER LINE 4 COLUMN 50
             VALUE "eg.: 9780345391803"
             FOREGROUND-COLOR COB-COLOR-GREEN.
          05 FILLER LINE 5 COLUMN 1
             VALUE "Author:"
             FOREGROUND-COLOR COB-COLOR-GREEN.
          05 FILLER PIC X(40) FROM WS-OUT-AUTHOR
             LINE 5 COLUMN 10
             FOREGROUND-COLOR COB-COLOR-GREEN.
          05 FILLER LINE 6 COLUMN 1
             VALUE "Title:"
             FOREGROUND-COLOR COB-COLOR-GREEN.
          05 FILLER PIC X(60) FROM WS-OUT-TITLE
             LINE 6 COLUMN 10
             FOREGROUND-COLOR COB-COLOR-GREEN.
          05 FILLER LINE 7 COLUMN 1
             VALUE "Date:"
             FOREGROUND-COLOR COB-COLOR-GREEN.
          05 FILLER PIC X(10) FROM WS-OUT-PUB-DATE
             LINE 7 COLUMN 10
             FOREGROUND-COLOR COB-COLOR-GREEN.
          05 FILLER LINE 8 COLUMN 1
             VALUE "Page-nr:"
             FOREGROUND-COLOR COB-COLOR-GREEN.
          05 FILLER PIC 9(4) FROM WS-OUT-PAGE-NR
             LINE 8 COLUMN 10
             FOREGROUND-COLOR COB-COLOR-GREEN.
          05 FILLER LINE 10 COLUMN 1
             VALUE "Insert user:"
             FOREGROUND-COLOR COB-COLOR-GREEN.
          05 FILLER PIC X(20) FROM WS-OUT-INSERT-USER
             LINE 10 COLUMN 24
             FOREGROUND-COLOR COB-COLOR-GREEN.
          05 FILLER LINE 11 COLUMN 1
             VALUE "Insert timestamp:"
             FOREGROUND-COLOR COB-COLOR-GREEN.
          05 FILLER PIC X(26) FROM WS-OUT-INSERT-TIMESTAMP
             LINE 11 COLUMN 24
             FOREGROUND-COLOR COB-COLOR-GREEN.
          05 FILLER LINE 12 COLUMN 1
             VALUE "Last update user:"
             FOREGROUND-COLOR COB-COLOR-GREEN.
          05 FILLER PIC X(20) FROM WS-OUT-LUPD-USER
             LINE 12 COLUMN 24
             FOREGROUND-COLOR COB-COLOR-GREEN.
          05 FILLER LINE 13 COLUMN 1
             VALUE "Last update timestamp:"
             FOREGROUND-COLOR COB-COLOR-GREEN.
          05 FILLER PIC X(26) FROM WS-OUT-LUPD-TIMESTAMP
             LINE 13 COLUMN 24
             FOREGROUND-COLOR COB-COLOR-GREEN.
          05 FILLER LINE 14 COLUMN 1
             VALUE "Last update counter:"
             FOREGROUND-COLOR COB-COLOR-GREEN.
          05 FILLER PIC 9(6) FROM WS-OUT-LUPD-COUNTER
             LINE 14 COLUMN 24
             FOREGROUND-COLOR COB-COLOR-GREEN.
          05 FILLER LINE 18 COLUMN 1    
             VALUE "F1 - Select with ISBN"
             FOREGROUND-COLOR COB-COLOR-GREEN.
          05 FILLER LINE 18 COLUMN 25    
             VALUE "F10 - Back to main"
             FOREGROUND-COLOR COB-COLOR-GREEN.
          05 FILLER PIC X TO WS-ACCEPT-FNC-KEY SECURE
             LINE 18 COLUMN 79
             FOREGROUND-COLOR COB-COLOR-GREEN.
             
       PROCEDURE DIVISION.
      
      *>------------------------------------------------------------------------
       MAIN-DB2TEST2 SECTION.
      *>------------------------------------------------------------------------
      
          PERFORM FOREVER
             DISPLAY HEADER-SCREEN END-DISPLAY  
             DISPLAY MAIN-FUNCTION-SCREEN END-DISPLAY
             DISPLAY MESSAGE-SCREEN END-DISPLAY 
             ACCEPT MAIN-FUNCTION-SCREEN END-ACCEPT
      
      *>     init message       
             INITIALIZE WS-MSG
             DISPLAY MESSAGE-SCREEN END-DISPLAY 
             
             EVALUATE TRUE
                WHEN V-FNC-F1
                   PERFORM FNC-CONNECT-SCREEN
      
                WHEN V-FNC-F2
                   PERFORM FNC-CONNECT-RESET

                WHEN V-FNC-F3
                   PERFORM FNC-SELECT-SCREEN
                   
                WHEN V-FNC-F9
                   EXIT PERFORM
                   
                WHEN OTHER
                   MOVE "Please select a valid function key" 
                     TO WS-MSG-1 OF WS-MSG
             END-EVALUATE
          END-PERFORM
      
          STOP RUN
      
          .
       MAIN-DB2TEST2-EX.
          EXIT.
          
      *>------------------------------------------------------------------------
       FNC-CONNECT-SCREEN SECTION.
      *>------------------------------------------------------------------------
      
          PERFORM FOREVER
             DISPLAY HEADER-SCREEN END-DISPLAY  
             DISPLAY CONNECT-SCREEN END-DISPLAY
             DISPLAY MESSAGE-SCREEN END-DISPLAY 
             ACCEPT CONNECT-SCREEN END-ACCEPT
      
      *>     init message       
             INITIALIZE WS-MSG
             DISPLAY MESSAGE-SCREEN END-DISPLAY 
             
             EVALUATE TRUE
                WHEN V-FNC-F1
                   PERFORM FNC-CONNECT
      
                WHEN V-FNC-F10
                   EXIT PERFORM
                   
                WHEN OTHER
                   MOVE "Please select a valid function key" 
                     TO WS-MSG-1 OF WS-MSG
             END-EVALUATE
          END-PERFORM
          
          .
       FNC-CONNECT-SCREEN-EX.
          EXIT.

      *>------------------------------------------------------------------------
       FNC-CONNECT SECTION.
      *>------------------------------------------------------------------------
      
          INITIALIZE LN-MOD
          INITIALIZE WS-MSG
          SET V-LN-FNC-CONNECT OF LN-MOD TO TRUE
          MOVE WS-CONNECT TO LN-CONNECT OF LN-MOD
      
          CALL "DB2MOD2" USING LN-MOD END-CALL
      
          PERFORM COPY-LN-MSG-IN-WS-MSG
          
          .
       FNC-CONNECT-EX.
          EXIT.
          
      *>------------------------------------------------------------------------
       FNC-CONNECT-RESET SECTION.
      *>------------------------------------------------------------------------
      
          INITIALIZE LN-MOD
          INITIALIZE WS-MSG
          SET V-LN-FNC-CONNECT-RESET OF LN-MOD TO TRUE
      
          CALL "DB2MOD2" USING LN-MOD END-CALL
      
          PERFORM COPY-LN-MSG-IN-WS-MSG
          
          .
       FNC-CONNECT-RESET-EX.
          EXIT.

      *>------------------------------------------------------------------------
       FNC-SELECT-SCREEN SECTION.
      *>------------------------------------------------------------------------
      
          PERFORM FOREVER
             DISPLAY HEADER-SCREEN END-DISPLAY  
             DISPLAY SELECT-BOOK-SCREEN END-DISPLAY
             DISPLAY MESSAGE-SCREEN END-DISPLAY 
             ACCEPT SELECT-BOOK-SCREEN END-ACCEPT
      
      *>     init message       
             INITIALIZE WS-MSG
             DISPLAY MESSAGE-SCREEN END-DISPLAY 
             
             EVALUATE TRUE
                WHEN V-FNC-F1
                   PERFORM FNC-SELECT-BOOK
      
                WHEN V-FNC-F10
                   EXIT PERFORM
                   
                WHEN OTHER
                   MOVE "Please select a valid function key" 
                     TO WS-MSG-1 OF WS-MSG
             END-EVALUATE
          END-PERFORM
          
          .
       FNC-SELECT-SCREEN-EX.
          EXIT.
          
      *>------------------------------------------------------------------------
       FNC-SELECT-BOOK SECTION.
      *>------------------------------------------------------------------------
      
          INITIALIZE LN-MOD
          INITIALIZE WS-MSG
          SET V-LN-FNC-SELECT OF LN-MOD TO TRUE
          MOVE WS-INP-BOOK TO LN-INP-BOOK
      
          CALL "DB2MOD2" USING LN-MOD END-CALL
      
          PERFORM COPY-LN-MSG-IN-WS-MSG

          MOVE LN-OUT-BOOK             OF LN-OUTPUT
            TO WS-OUT-BOOK          
          
          .
       FNC-SELECT-BOOK-EX.
          EXIT.
          
      *>------------------------------------------------------------------------
       COPY-LN-MSG-IN-WS-MSG SECTION.
      *>------------------------------------------------------------------------
      
          MOVE LN-MSG                  OF LN-OUTPUT         
            TO WS-MSG                  
          
          .
       COPY-LN-MSG-IN-WS-MSG-EX.
          EXIT.
          
       END PROGRAM DB2TEST2.
