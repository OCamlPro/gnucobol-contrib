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
       01 IDX PIC 9(5) value 0.
       01 dummy pic x.

       01 CLID PIC 9.

       01 ERRMSG PIC X(256).

       PROCEDURE DIVISION CHAINING CLID.
       MAIN-PARAGRAPH.

      * Verbindung herstellen     
              display 'Client mit der ID ' CLID
              end-display
              display 'Kontaktiere Server ...'
              end-display
              call "CBL_OC_SOCKET" 
                   using "02" IP PORT HNDL giving RESULT
              end-call.
              perform handle-error.

      * Daten senden
      *        perform varying IDX from 1 by 1 until IDX > CLID
              perform varying IDX from 1 by 1 until IDX > 50000
                     display 'Sende ID ...'
                     end-display
                     move spaces to BUFF
                     string 'client' CLID into BUFF
                     move 10 to BYTES
                     call "CBL_OC_SOCKET" 
                          using "03" HNDL BYTES BUFF giving RESULT
                     end-call
                     perform handle-error
                     
      *               display 'Warte ' CLID ' Sekunden ...'
      *               end-display
      *               call 'C$SLEEP' using CLID
      *               end-call
              end-perform
              
      * Daten senden
              display 'Singalisiere Verbindungsende ...'
              end-display
              move 'close' to BUFF.
              move 10 to BYTES.
              call "CBL_OC_SOCKET" 
                   using "03" HNDL BYTES BUFF giving RESULT
              end-call.
              perform handle-error.
              
      * Verbindung schliessen
              display 'Schliesse Verbindung ...'
              end-display
              call "CBL_OC_SOCKET"
                  using "06" HNDL giving RESULT
              end-call.
              perform handle-error.

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

