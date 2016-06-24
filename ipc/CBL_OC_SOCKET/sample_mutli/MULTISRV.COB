      * Diese Programm implementiert einen Multi-Socket-Server
      * der mehrere Verbindungen halten und neue akzeptieren kann.
      * Er nimmt Daten von Clients entgegen und reagiert auf 
      * deren Kommandos zum Schliessen einer aktiven Verbindung.

       IDENTIFICATION DIVISION.         
       PROGRAM-ID. MULTISRV.
       
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

      * Socket oeffnen      
              display "Oeffne Server-Socket..."
              end-display
              call "CBL_OC_SOCKET" 
                   using "00" PORT LISTEN giving RESULT
              end-call
              perform handle-error.

      * Auf eine Verbindung warten die gelesen werden kann
       HANDLE-READ.

              display 'Warte auf eingehende Verbindung/'
                      'eingehende Daten ...'
              end-display
              call 'CBL_OC_SOCKET'
                   using "10" LISTEN HNDL TOUT giving RESULT
              end-call.
              evaluate RESULT
              when 0
                     display 'Daten verfuegbar ...'
                     end-display
              when 5
                     display 'Timeout abgelaufen ...'
                     end-display
                     go to HANDLE-READ
              when other
                     perform handle-error
              end-evaluate.
              
      * Daten vom Client empfangen
              display 'Empfange Daten ...'
              end-display
              move 10 to RECV.
              move SPACES to BUFF.
              call 'CBL_OC_SOCKET'
                     using "04" HNDL RECV BUFF giving RESULT
              end-call.
              perform handle-error

              move SPACES to OUT.
              move BUFF to OUT.
              display "Client sagt: " OUT
              end-display

              if BUFF = 'close' then
                     display 'Client signalisiert Ende  ...'
                     end-display
                     call "CBL_OC_SOCKET"
                            using "06" HNDL giving RESULT
                     end-call
                     perform handle-error
              end-if

              go to HANDLE-READ.
      
              stop run.
              
      * Fehler behandeln        
       HANDLE-ERROR SECTION.
       00.
              if RESULT not= 0 
              then
                   display 'Rueckgabewert: ' RESULT
                   end-display
                   call 'CBL_OC_SOCKET' using '98' ERRMSG giving RESULT
                   end-call
                   display 'OS-FEHLER: ' RESULT ': ' ERRMSG
                   end-display
                   display 'Druecken Sie ENTER'
                   end-display
                   accept dummy
                   end-accept
                   stop run
              end-if
              .

