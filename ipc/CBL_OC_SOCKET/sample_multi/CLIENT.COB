      * Dieses Program implementiert einen Client passend zum 
      * Multi-Socket-Server. Als Parameter nimmt er eine einstellige
      * Nummer (1-9) die als ID fuer den Client fungiert. Der Client
      * nimmt kontakt zum Server auf und sendet seine ID und wartet 
      * danach eine gewisse Zeitspanne. Wie oft der Client die ID sendet 
      * und wie lange er nach jedem Senden wartet, haengt von der ID ab.
      * Am Ende signalisiert der Client dem Server das Ende der 
      * Verbindung und schliesst diese.

       IDENTIFICATION DIVISION.         
       PROGRAM-ID. CLIENT.

      * This program implements a socket-client for accessing the
      * multi socket server.
      * 
      * It reads data from clients and reacts to their commands
      * to close active Connections.
       
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

       01 CLID-X.
          02 CLID     PIC 99.

       01 ERRMSG PIC X(256).

       PROCEDURE DIVISION CHAINING CLID-X.
       MAIN-PARAGRAPH.
       
               move function numval (CLID-X) to RESULT
               if RESULT = 0 
                  display 'Invalid Client-ID: "' CLID-X '"'
                  end-display
                  display 'Pass numeric value as argument!'
                  end-display
                  accept dummy
                  end-accept
                  stop run
               end-if
               
               move RESULT to CLID

      * Connect to server
              display 'I''m the client with ID ' CLID
              end-display
              display 'contacting server ...'
              end-display
              call "CBL_OC_SOCKET" 
                   using "02" IP PORT HNDL giving RESULT
              end-call.
              perform handle-error.

      * Send data
      *        perform 50000 times
               perform 100 times
                     display 'sending ID ...'
                     end-display
                     move spaces to BUFF
                     string 'client' CLID into BUFF
                     move 10 to BYTES
                     call "CBL_OC_SOCKET" 
                          using "03" HNDL BYTES BUFF giving RESULT
                     end-call
                     perform handle-error
                     
                     display 'Waiting ' CLID ' seconds ...'
                     end-display
                     call 'C$SLEEP' using CLID
                     end-call
              end-perform
              
      * Send data (command)
              display 'Tallying the server to close the connection ...'
              end-display
              move 'close' to BUFF.
              move 10 to BYTES.
              call "CBL_OC_SOCKET" 
                   using "03" HNDL BYTES BUFF giving RESULT
              end-call.
              perform handle-error.
              
      * Close connection
              display 'Closing connection ...'
              end-display
              call "CBL_OC_SOCKET"
                  using "06" HNDL giving RESULT
              end-call.
              perform handle-error.

              stop run.

      * Handle error, display result 
       HANDLE-ERROR SECTION.
      *00.
              if RESULT not= 0 
              then
                   display 'Return-Code: ' RESULT
                   end-display
                   call 'CBL_OC_SOCKET' using '98' ERRMSG giving RESULT
                   end-call
                   display 'OS-Error: ' RESULT ': ' ERRMSG
                   end-display
                   display 'Press ENTER to stop the client'
                   end-display
                   accept dummy
                   end-accept
                   stop run
              end-if
              .

