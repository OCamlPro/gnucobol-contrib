       IDENTIFICATION DIVISION.
       PROGRAM-ID. server.
       
       ENVIRONMENT DIVISION.
       CONFIGURATION SECTION.
       INPUT-OUTPUT SECTION.
       DATA DIVISION.
       FILE SECTION.
       WORKING-STORAGE SECTION.
       
       01 PORT   PIC X(4) VALUE "1234".
       01 HNDL   PIC X(4).
       01 LISTEN   PIC X(4).
       01 BUFF   PIC X(64000).
       01 BYTES  PIC 9(5).
       01 RECV   PIC 9(5).
       01 RESULT PIC 9(3).
       01 OUT    PIC X(25).
       01 dummy pic x.

       
       PROCEDURE DIVISION.

       MAIN-PARAGRAPH.

              DISPLAY "Opening socket for incoming connections ...".
              CALL "cob_socket" 
                   USING "00" PORT LISTEN GIVING RESULT
              END-CALL.
              perform handle-error.
      
      *        CALL "cob_socket" 
      *             USING "98" GIVING RESULT.
              
       ACCEPT-CONN.
              
              DISPLAY "Listening for incomming connections ...".
              CALL "cob_socket" 
                   USING "07" LISTEN HNDL GIVING RESULT
              END-CALL.
              perform handle-error.

              DISPLAY "Getting data from client ...".
              MOVE 14 TO RECV.
              MOVE SPACES TO BUFF.
              CALL "cob_socket"
                     USING "04" HNDL RECV BUFF GIVING RESULT
              END-CALL.
              perform handle-error.

              MOVE SPACES TO OUT.
              MOVE BUFF TO OUT.
              DISPLAY "Client says: " OUT.

              DISPLAY "Sending data and waiting for response ...".
              MOVE "Hello client !" TO BUFF.
              MOVE 14 TO BYTES.
              MOVE 17 TO RECV.

              CALL "cob_socket"
                     USING "05" HNDL BYTES RECV BUFF GIVING RESULT
              END-CALL.
              perform handle-error.

              MOVE SPACES TO OUT.
              MOVE BUFF TO OUT.
              DISPLAY "Client responds: " OUT.

              DISPLAY "Sending data ...".
              MOVE 13 TO BYTES.
              MOVE "Hasta la vista" TO BUFF.

              CALL "cob_socket"
                   USING "03" HNDL BYTES BUFF GIVING RESULT
              END-CALL.
              perform handle-error.

              DISPLAY "Closing connection ...".
              CALL "cob_socket"
                     USING "06" HNDL GIVING RESULT
              END-CALL.
              perform handle-error.

              go to accept-conn.

              accept dummy.
              
              STOP RUN.
              
       HANDLE-ERROR SECTION.
              DISPLAY "Result is: " RESULT.
              IF RESULT NOT = 0 
              THEN
                   CALL "cob_socket" USING "99" GIVING RESULT
                   DISPLAY "OS-ERROR: " RESULT
                   accept dummy
                   STOP RUN
              END-IF
              .
