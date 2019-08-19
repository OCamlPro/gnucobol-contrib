       IDENTIFICATION DIVISION.         
       PROGRAM-ID. MULTISRV.

      * This program implements a socket-server which can 
      * keep multiple connections and allows new ones.
      * It reads data from clients and reacts to their commands
      * to close active Connections.
       
       ENVIRONMENT DIVISION.
       CONFIGURATION SECTION.
       INPUT-OUTPUT SECTION.
       DATA DIVISION.
       FILE SECTION.
       WORKING-STORAGE SECTION.
       
       01 TOUT   pic X(6) value '005000'.
       01 PORT   pic X(4) value '1234'.
       01 HNDL   pic X(4).
       01 LISTEN pic X(4).
       01 BUFF   pic X(64000).
       01 BYTES  pic 9(5).
       01 RECV   pic 9(5).
       01 RESULT pic 9(3).
       01 OUT    pic X(25).
       01 dummy  pic X.

       01 ERRMSG PIC X(256).

       PROCEDURE DIVISION.
       MAIN-PARAGRAPH.

      * Create Socket
              display "creating server-socket..."
              end-display
              call "CBL_GC_SOCKET" 
                   using "00" PORT LISTEN giving RESULT
              end-call
              perform handle-CRITICAL-error.

      * Wait for a connection that could be read
       HANDLE-READ.

              display 'waiting for incoming connection / data ...'
              end-display
              call 'CBL_GC_SOCKET'
                   using "10" LISTEN HNDL TOUT giving RESULT
              end-call.
              evaluate RESULT
                 when 0
                     display 'data is available ...'
                     end-display
                 when 5
                     display 'timeout is over ...'
                     end-display
                     go to HANDLE-READ
                 when other
                     perform handle-error
              end-evaluate.
              
      * Receive data from Client
              display 'receiving data ...'
              end-display
              move 10 to RECV.
              move SPACES to BUFF.
              call 'CBL_GC_SOCKET'
                     using "04" HNDL RECV BUFF giving RESULT
              end-call.
              if result = 2
                 perform handle-error
                 display 'Client is not available any more.'
                 end-display
                 display 'closing client connection ...'
                 end-display
                 call "CBL_GC_SOCKET"
                        using "06" HNDL giving RESULT
                 end-call
                 perform handle-error
              else
                 perform handle-error
                 move BUFF to OUT
                 display "client says: " OUT
                 end-display

                 if BUFF = 'close' then
                    display 'client sent end of connection ...'
                    end-display
                    display 'closing client connection ...'
                    end-display
                    call "CBL_GC_SOCKET"
                           using "06" HNDL giving RESULT
                    end-call
                    perform handle-error
                 end-if
              end-if

              go to HANDLE-READ.
      
              stop run.
              
      * Handle error, display result
       HANDLE-ERROR SECTION.
      *00.
              if RESULT not= 0 
              then
                   display 'Return-Code: ' RESULT
                   end-display
                   call 'CBL_GC_SOCKET' using '98' ERRMSG giving RESULT
                   end-call
                   display 'OS-Error: ' RESULT ': ' ERRMSG
                   end-display
                   display 'Press ENTER to go on... '
                   end-display
                   accept dummy
                   end-accept
              end-if
              .
       HANDLE-CRITICAL-ERROR SECTION.
      *00.
              if RESULT not= 0 
              then
                   display 'Return-Code: ' RESULT
                   end-display
                   call 'CBL_GC_SOCKET' using '98' ERRMSG giving RESULT
                   end-call
                   display 'OS-Error: ' RESULT ': ' ERRMSG
                   end-display
                   display 'Press ENTER to stop the server'
                   end-display
                   accept dummy
                   end-accept
                   stop run
              end-if
              .

