       IDENTIFICATION DIVISION
       PROGRAM-ID. client.
       
       ENVIRONMENT DIVISION.
       CONFIGURATION SECTION.
       INPUT-OUTPUT SECTION.
       DATA DIVISION.
       FILE SECTION.
       WORKING-STORAGE SECTION.
       
       01 IP     PIC X(15) VALUE "127.0.0.1".
       01 PORT   PIC X(4) VALUE "1234".
       01 HNDL   PIC X(4).
       01 BUFF   PIC X(64000).
       01 BYTES  PIC 9(5).
       01 RECV   PIC 9(5).
       01 RESULT PIC 9(3).
       01 OUT    PIC X(25).
       01 dummy pic x.

       PROCEDURE DIVISION.


       start-proc.
      * Connect...
              DISPLAY "Connect to server ...".
              CALL "cob_socket" 
                   USING "02" IP PORT HNDL GIVING RESULT
              END-CALL.
              perform handle-error.

      * send data
              DISPLAY "Sending some data ...".
              MOVE "Hello server !" TO BUFF.
              MOVE 14 TO BYTES.
              CALL "cob_socket" 
                   USING "03" HNDL BYTES BUFF GIVING RESULT
              END-CALL.
              perform handle-error.

      * receive data
              DISPLAY "Reading some data ...".
              MOVE SPACES TO BUFF.
              MOVE 14 TO RECV.
              CALL "cob_socket" 
                   USING "04" HNDL RECV BUFF GIVING RESULT
              END-CALL.
              perform handle-error.

              MOVE SPACES TO OUT.
              MOVE BUFF TO OUT.
              DISPLAY "Server says: " OUT.

      * send response
              DISPLAY "Sending data ...".
              MOVE 17 TO BYTES.
              MOVE "Good bye server !" TO BUFF.

              CALL "cob_socket"
                   USING "03" HNDL BYTES BUFF GIVING RESULT
              END-CALL.
              perform handle-error.
              
              DISPLAY "Reading some data ...".
              MOVE SPACES TO BUFF.
              MOVE 13 TO RECV.
              CALL "cob_socket" 
                   USING "04" HNDL RECV BUFF GIVING RESULT
              END-CALL.
              perform handle-error.
              
              MOVE SPACES TO OUT.
              MOVE BUFF TO OUT.
              DISPLAY "Server says: " OUT.

              DISPLAY "Closing socket ...".
              CALL "cob_socket"
                   USING "06" HNDL GIVING RESULT
              END-CALL.
              perform handle-error.

      *       accept port.

              call 'C$SLEEP' using '1'.

              go to start-proc.

              STOP RUN.

       HANDLE-ERROR SECTION.
              DISPLAY "Result is: " RESULT.
              IF RESULT NOT = 0 
              THEN
                   CALL "cob_socket" USING "99" GIVING RESULT
                   DISPLAY "OS-ERROR: " RESULT
                   accept dummy
                   STOP RUN
              END-IF.


