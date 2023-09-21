       IDENTIFICATION DIVISION.
       PROGRAM-ID.    SPLIT001.
       ENVIRONMENT DIVISION.
       CONFIGURATION SECTION.
       SOURCE-COMPUTER. IBM-PC.
       OBJECT-COMPUTER. IBM-PC.
       SPECIAL-NAMES.
      *    ARGUMENT-NUMBER   IS COMMAND-LINE-NUMBER
      *    ARGUMENT-VALUE    IS COMMAND-LINE-VALUE
      *    ENVIRONMENT-NAME  IS ENVIRONMENT-NAME
      *    ENVIRONMENT-VALUE IS ENVIRONMENT-VALUE.
       INPUT-OUTPUT SECTION.
       DATA DIVISION.
       FILE SECTION.
       WORKING-STORAGE SECTION.
       01  PROGRAM-FIELDS.
           05  IDY-DSN      PIC X(64).
           05  WEXT         PIC X(03).
           05  WPGM         PIC X(08).
           05  I                       PIC 9(04) COMP-5.
           05  J                       PIC 9(04) COMP-5.
           05 SPLIT-JOIN-PARAM.
               10  PARAM-LENGTH        PIC 9(4) COMP-4.
               10  SPLITJOIN-FLG1      PIC 9(4) COMP-4.
               10  SPLITJOIN-FLG2      PIC 9(4) COMP-4.
               10  PATH-STRT           PIC 9(4) COMP-4.
               10  PATH-LEN            PIC 9(4) COMP-4.
               10  BASE-STRT           PIC 9(4) COMP-4.
               10  BASE-LEN            PIC 9(4) COMP-4.
               10  EXT-STRT            PIC 9(4) COMP-4.
               10  EXT-LEN             PIC 9(4) COMP-4.
               10  TOTAL-LENGTH        PIC 9(4) COMP-4.
               10  SPLIT-BUF-LEN       PIC 9(4) COMP-4.
               10  JOIN-BUF-LEN        PIC 9(4) COMP-4.
               10  FIRST-PATH-LEN      PIC 9(4) COMP-4.
       01  PATH-NAME                       PIC X(160).

       PROCEDURE DIVISION.
           CALL 'CBL_VFILES'.
           DISPLAY 'CBL_DIAGNOSTIC'        UPON ENVIRONMENT-NAME.
           DISPLAY  'OFF'                  UPON ENVIRONMENT-VALUE.

           DISPLAY ' '.
           DISPLAY 'TEST 1'.
           DISPLAY ' '.
           INITIALIZE SPLIT-JOIN-PARAM.
           MOVE +24                    TO PARAM-LENGTH.
           MOVE +3                     TO SPLITJOIN-FLG1.
           MOVE +260                   TO SPLIT-BUF-LEN.

           MOVE SPACES                 TO PATH-NAME.
           STRING
               '\\LINKSYS12214\Seagate Backup Plus Drive\Chuck-Back'
               DELIMITED BY SIZE
               'ups\3570K\Weekly Backup\3570K\Weekly Backup'
               DELIMITED BY SIZE
               '\ TEST . . . COB '
               DELIMITED BY SIZE
               X'00'
               DELIMITED BY SIZE
               INTO PATH-NAME
           CALL 'CBL_SPLIT_FILENAME' USING
                                     SPLIT-JOIN-PARAM
                                     PATH-NAME.

           DISPLAY ' TOTAL-LENGTH IS ' TOTAL-LENGTH.

           IF TOTAL-LENGTH > 80
               COMPUTE J = TOTAL-LENGTH - 80
               END-COMPUTE
               DISPLAY PATH-NAME (1:80)
               DISPLAY PATH-NAME (81:J)
           ELSE
               DISPLAY PATH-NAME (1:TOTAL-LENGTH)
           END-IF.

           DISPLAY ' '.
           DISPLAY ' PARAM-LENGTH    ==> ' PARAM-LENGTH.
           DISPLAY ' SPLITJOIN-FLG1  ==> ' SPLITJOIN-FLG1.
           DISPLAY ' SPLITJOIN-FLG2  ==> ' SPLITJOIN-FLG2.
           DISPLAY ' PATH-STRT       ==> ' PATH-STRT.
           DISPLAY ' PATH-LEN        ==> ' PATH-LEN.
           DISPLAY ' BASE-STRT       ==> ' BASE-STRT.
           DISPLAY ' BASE-LEN        ==> ' BASE-LEN.
           DISPLAY ' EXT-STRT        ==> ' EXT-STRT.
           DISPLAY ' EXT-LEN         ==> ' EXT-LEN.
           DISPLAY ' TOTAL-LENGTH    ==> ' TOTAL-LENGTH.
           DISPLAY ' SPLIT-BUF-LEN   ==> ' SPLIT-BUF-LEN.
           DISPLAY ' JOIN-BUF-LEN    ==> ' JOIN-BUF-LEN.
           DISPLAY ' FIRST-PATH-LEN  ==> ' FIRST-PATH-LEN.

           DISPLAY ' '.
           DISPLAY 'BASE OF FILE NAME ===>'
               PATH-NAME(BASE-STRT:BASE-LEN)
               '<==='.
           DISPLAY ' '.
           DISPLAY 'EXT OF FILE NAME ===>'
               PATH-NAME(EXT-STRT:EXT-LEN)
               '<==='.

           DISPLAY ' '.
           DISPLAY 'TEST 2'.
           DISPLAY ' '.
           INITIALIZE SPLIT-JOIN-PARAM.
           MOVE +24                    TO PARAM-LENGTH.
           MOVE +260                   TO SPLIT-BUF-LEN.
           MOVE +3                     TO SPLITJOIN-FLG1.

           MOVE SPACES                 TO PATH-NAME.
           STRING
               'D:\Seagate Backup Plus Drive\Chuck-Back'
               DELIMITED BY SIZE
               'ups\3570K\Weekly Backup\3570K\Weekly Backup'
               DELIMITED BY SIZE
               '\ TEST . . . COB '
               DELIMITED BY SIZE
               X'00'
               DELIMITED BY SIZE
               INTO PATH-NAME
           CALL 'CBL_SPLIT_FILENAME' USING
                                     SPLIT-JOIN-PARAM
                                     PATH-NAME.

           IF TOTAL-LENGTH > 80
               COMPUTE J = TOTAL-LENGTH - 80
               END-COMPUTE
               DISPLAY PATH-NAME (1:80)
               DISPLAY PATH-NAME (81:J)
           ELSE
               DISPLAY PATH-NAME (1:TOTAL-LENGTH)
           END-IF.

           DISPLAY ' '.
           DISPLAY ' PARAM-LENGTH    ==> ' PARAM-LENGTH.
           DISPLAY ' SPLITJOIN-FLG1  ==> ' SPLITJOIN-FLG1.
           DISPLAY ' SPLITJOIN-FLG2  ==> ' SPLITJOIN-FLG2.
           DISPLAY ' PATH-STRT       ==> ' PATH-STRT.
           DISPLAY ' PATH-LEN        ==> ' PATH-LEN.
           DISPLAY ' BASE-STRT       ==> ' BASE-STRT.
           DISPLAY ' BASE-LEN        ==> ' BASE-LEN.
           DISPLAY ' EXT-STRT        ==> ' EXT-STRT.
           DISPLAY ' EXT-LEN         ==> ' EXT-LEN.
           DISPLAY ' TOTAL-LENGTH    ==> ' TOTAL-LENGTH.
           DISPLAY ' SPLIT-BUF-LEN   ==> ' SPLIT-BUF-LEN.
           DISPLAY ' JOIN-BUF-LEN    ==> ' JOIN-BUF-LEN.
           DISPLAY ' FIRST-PATH-LEN  ==> ' FIRST-PATH-LEN.

           DISPLAY ' '.
           DISPLAY 'BASE OF FILE NAME ===>'
               PATH-NAME(BASE-STRT:BASE-LEN)
               '<==='.
           DISPLAY ' '.
           DISPLAY 'EXT OF FILE NAME ===>'
               PATH-NAME(EXT-STRT:EXT-LEN)
               '<==='.

           DISPLAY ' '.
           DISPLAY 'TEST 3'.
           DISPLAY ' '.
           INITIALIZE SPLIT-JOIN-PARAM.
           MOVE +24                    TO PARAM-LENGTH.
           MOVE +260                   TO SPLIT-BUF-LEN.
           MOVE +3                     TO SPLITJOIN-FLG1.

           MOVE SPACES                 TO PATH-NAME.
           STRING
               '\Seagate Backup Plus Drive\Chuck-Back'
               DELIMITED BY SIZE
               'ups\3570K\Weekly Backup\3570K\Weekly Backup'
               DELIMITED BY SIZE
               '\ TEST . . . COB '
               DELIMITED BY SIZE
               X'00'
               DELIMITED BY SIZE
               INTO PATH-NAME
           CALL 'CBL_SPLIT_FILENAME' USING
                                     SPLIT-JOIN-PARAM
                                     PATH-NAME.

           IF TOTAL-LENGTH > 80
               COMPUTE J = TOTAL-LENGTH - 80
               END-COMPUTE
               DISPLAY PATH-NAME (1:80)
               DISPLAY PATH-NAME (81:J)
           ELSE
               DISPLAY PATH-NAME (1:TOTAL-LENGTH)
           END-IF.

           DISPLAY ' '.
           DISPLAY ' PARAM-LENGTH    ==> ' PARAM-LENGTH.
           DISPLAY ' SPLITJOIN-FLG1  ==> ' SPLITJOIN-FLG1.
           DISPLAY ' SPLITJOIN-FLG2  ==> ' SPLITJOIN-FLG2.
           DISPLAY ' PATH-STRT       ==> ' PATH-STRT.
           DISPLAY ' PATH-LEN        ==> ' PATH-LEN.
           DISPLAY ' BASE-STRT       ==> ' BASE-STRT.
           DISPLAY ' BASE-LEN        ==> ' BASE-LEN.
           DISPLAY ' EXT-STRT        ==> ' EXT-STRT.
           DISPLAY ' EXT-LEN         ==> ' EXT-LEN.
           DISPLAY ' TOTAL-LENGTH    ==> ' TOTAL-LENGTH.
           DISPLAY ' SPLIT-BUF-LEN   ==> ' SPLIT-BUF-LEN.
           DISPLAY ' JOIN-BUF-LEN    ==> ' JOIN-BUF-LEN.
           DISPLAY ' FIRST-PATH-LEN  ==> ' FIRST-PATH-LEN.

           DISPLAY ' '.
           DISPLAY 'BASE OF FILE NAME ===>'
               PATH-NAME(BASE-STRT:BASE-LEN)
               '<==='.
           DISPLAY ' '.
           DISPLAY 'EXT OF FILE NAME ===>'
               PATH-NAME(EXT-STRT:EXT-LEN)
               '<==='.

           DISPLAY ' '.
           DISPLAY 'TEST 4'.
           DISPLAY ' '.
           INITIALIZE SPLIT-JOIN-PARAM.
           MOVE +24                    TO PARAM-LENGTH.
           MOVE +260                   TO SPLIT-BUF-LEN.
           MOVE +3                     TO SPLITJOIN-FLG1.

           MOVE SPACES                 TO PATH-NAME.
           STRING
               'Seagate Backup Plus Drive\Chuck-Back'
               DELIMITED BY SIZE
               'ups\3570K\Weekly Backup\3570K\Weekly Backup'
               DELIMITED BY SIZE
               '\ TEST . . . COB '
               DELIMITED BY SIZE
               X'00'
               DELIMITED BY SIZE
               INTO PATH-NAME
           CALL 'CBL_SPLIT_FILENAME' USING
                                     SPLIT-JOIN-PARAM
                                     PATH-NAME.

           IF TOTAL-LENGTH > 80
               COMPUTE J = TOTAL-LENGTH - 80
               END-COMPUTE
               DISPLAY PATH-NAME (1:80)
               DISPLAY PATH-NAME (81:J)
           ELSE
               DISPLAY PATH-NAME (1:TOTAL-LENGTH)
           END-IF.

           DISPLAY ' '.
           DISPLAY ' PARAM-LENGTH    ==> ' PARAM-LENGTH.
           DISPLAY ' SPLITJOIN-FLG1  ==> ' SPLITJOIN-FLG1.
           DISPLAY ' SPLITJOIN-FLG2  ==> ' SPLITJOIN-FLG2.
           DISPLAY ' PATH-STRT       ==> ' PATH-STRT.
           DISPLAY ' PATH-LEN        ==> ' PATH-LEN.
           DISPLAY ' BASE-STRT       ==> ' BASE-STRT.
           DISPLAY ' BASE-LEN        ==> ' BASE-LEN.
           DISPLAY ' EXT-STRT        ==> ' EXT-STRT.
           DISPLAY ' EXT-LEN         ==> ' EXT-LEN.
           DISPLAY ' TOTAL-LENGTH    ==> ' TOTAL-LENGTH.
           DISPLAY ' SPLIT-BUF-LEN   ==> ' SPLIT-BUF-LEN.
           DISPLAY ' JOIN-BUF-LEN    ==> ' JOIN-BUF-LEN.
           DISPLAY ' FIRST-PATH-LEN  ==> ' FIRST-PATH-LEN.

           DISPLAY ' '.
           DISPLAY 'BASE OF FILE NAME ===>'
               PATH-NAME(BASE-STRT:BASE-LEN)
               '<==='.
           DISPLAY ' '.
           DISPLAY 'EXT OF FILE NAME ===>'
               PATH-NAME(EXT-STRT:EXT-LEN)
               '<==='.

           DISPLAY ' '.
           DISPLAY 'TEST 5'.
           DISPLAY ' '.
           INITIALIZE SPLIT-JOIN-PARAM.
           MOVE +24                    TO PARAM-LENGTH.
           MOVE +260                   TO SPLIT-BUF-LEN.
           MOVE +3                     TO SPLITJOIN-FLG1.

           MOVE SPACES                 TO PATH-NAME.
           STRING
               'Seagate Backup Plus Drive\Chuck-Back'
               DELIMITED BY SIZE
               'ups\3570K\Weekly Backup\3570K\Weekly Backup'
               DELIMITED BY SIZE
               '\ TEST.COB'
               DELIMITED BY SIZE
               X'00000000'
               DELIMITED BY SIZE
               INTO PATH-NAME
           CALL 'CBL_SPLIT_FILENAME' USING
                                     SPLIT-JOIN-PARAM
                                     PATH-NAME.

           IF TOTAL-LENGTH > 80
               COMPUTE J = TOTAL-LENGTH - 80
               END-COMPUTE
               DISPLAY PATH-NAME (1:80)
               DISPLAY PATH-NAME (81:J)
           ELSE
               DISPLAY PATH-NAME (1:TOTAL-LENGTH)
           END-IF.

           DISPLAY ' '.
           DISPLAY ' PARAM-LENGTH    ==> ' PARAM-LENGTH.
           DISPLAY ' SPLITJOIN-FLG1  ==> ' SPLITJOIN-FLG1.
           DISPLAY ' SPLITJOIN-FLG2  ==> ' SPLITJOIN-FLG2.
           DISPLAY ' PATH-STRT       ==> ' PATH-STRT.
           DISPLAY ' PATH-LEN        ==> ' PATH-LEN.
           DISPLAY ' BASE-STRT       ==> ' BASE-STRT.
           DISPLAY ' BASE-LEN        ==> ' BASE-LEN.
           DISPLAY ' EXT-STRT        ==> ' EXT-STRT.
           DISPLAY ' EXT-LEN         ==> ' EXT-LEN.
           DISPLAY ' TOTAL-LENGTH    ==> ' TOTAL-LENGTH.
           DISPLAY ' SPLIT-BUF-LEN   ==> ' SPLIT-BUF-LEN.
           DISPLAY ' JOIN-BUF-LEN    ==> ' JOIN-BUF-LEN.
           DISPLAY ' FIRST-PATH-LEN  ==> ' FIRST-PATH-LEN.

           DISPLAY ' '.
           DISPLAY 'BASE OF FILE NAME ===>'
               PATH-NAME(BASE-STRT:BASE-LEN)
               '<==='.
           DISPLAY ' '.
           DISPLAY 'EXT OF FILE NAME ===>'
               PATH-NAME(EXT-STRT:EXT-LEN)
               '<==='.


           DISPLAY ' '.
           DISPLAY 'TEST 5 FOR BRUCE...'.
           DISPLAY ' '.
           INITIALIZE SPLIT-JOIN-PARAM.
           MOVE +24                    TO PARAM-LENGTH.
           MOVE +260                   TO SPLIT-BUF-LEN.
           MOVE +3                     TO SPLITJOIN-FLG1.

           MOVE SPACES                 TO PATH-NAME.
           STRING
               'c:\winzos\tgroup.cob'
               DELIMITED BY SIZE
               X'00000000'
               DELIMITED BY SIZE
               INTO PATH-NAME
           CALL 'CBL_SPLIT_FILENAME' USING
                                     SPLIT-JOIN-PARAM
                                     PATH-NAME.

           IF TOTAL-LENGTH > 80
               COMPUTE J = TOTAL-LENGTH - 80
               END-COMPUTE
               DISPLAY PATH-NAME (1:80)
               DISPLAY PATH-NAME (81:J)
           ELSE
               DISPLAY PATH-NAME (1:TOTAL-LENGTH)
           END-IF.

           DISPLAY ' '.
           DISPLAY ' PARAM-LENGTH    ==> ' PARAM-LENGTH.
           DISPLAY ' SPLITJOIN-FLG1  ==> ' SPLITJOIN-FLG1.
           DISPLAY ' SPLITJOIN-FLG2  ==> ' SPLITJOIN-FLG2.
           DISPLAY ' PATH-STRT       ==> ' PATH-STRT.
           DISPLAY ' PATH-LEN        ==> ' PATH-LEN.
           DISPLAY ' BASE-STRT       ==> ' BASE-STRT.
           DISPLAY ' BASE-LEN        ==> ' BASE-LEN.
           DISPLAY ' EXT-STRT        ==> ' EXT-STRT.
           DISPLAY ' EXT-LEN         ==> ' EXT-LEN.
           DISPLAY ' TOTAL-LENGTH    ==> ' TOTAL-LENGTH.
           DISPLAY ' SPLIT-BUF-LEN   ==> ' SPLIT-BUF-LEN.
           DISPLAY ' JOIN-BUF-LEN    ==> ' JOIN-BUF-LEN.
           DISPLAY ' FIRST-PATH-LEN  ==> ' FIRST-PATH-LEN.

           DISPLAY ' '.
           DISPLAY 'BASE OF FILE NAME ===>'
               PATH-NAME(BASE-STRT:BASE-LEN)
               '<==='.
           DISPLAY ' '.
           DISPLAY 'EXT OF FILE NAME ===>'
               PATH-NAME(EXT-STRT:EXT-LEN)
               '<==='.

           DISPLAY ' '.
           DISPLAY 'TEST 6'.
           DISPLAY ' '.
           INITIALIZE SPLIT-JOIN-PARAM.
           MOVE +24                    TO PARAM-LENGTH.
           MOVE +260                   TO SPLIT-BUF-LEN.
           MOVE +0                     TO SPLITJOIN-FLG1.

           MOVE SPACES                 TO PATH-NAME.
           STRING
               'Seagate Backup Plus Drive\Chuck-Back'
               DELIMITED BY SIZE
               'ups\3570K\Weekly Backup\3570K\Weekly Backup'
               DELIMITED BY SIZE
               '\ TEST.COB'
      *        DELIMITED BY SIZE
      *        X'00'
               DELIMITED BY SIZE
               INTO PATH-NAME
           CALL 'CBL_SPLIT_FILENAME' USING
                                     SPLIT-JOIN-PARAM
                                     PATH-NAME.

           IF TOTAL-LENGTH > 80
               COMPUTE J = TOTAL-LENGTH - 80
               END-COMPUTE
               DISPLAY PATH-NAME (1:80)
               DISPLAY PATH-NAME (81:J)
           ELSE
               DISPLAY PATH-NAME (1:TOTAL-LENGTH)
           END-IF.

           DISPLAY ' '.
           DISPLAY ' PARAM-LENGTH    ==> ' PARAM-LENGTH.
           DISPLAY ' SPLITJOIN-FLG1  ==> ' SPLITJOIN-FLG1.
           DISPLAY ' SPLITJOIN-FLG2  ==> ' SPLITJOIN-FLG2.
           DISPLAY ' PATH-STRT       ==> ' PATH-STRT.
           DISPLAY ' PATH-LEN        ==> ' PATH-LEN.
           DISPLAY ' BASE-STRT       ==> ' BASE-STRT.
           DISPLAY ' BASE-LEN        ==> ' BASE-LEN.
           DISPLAY ' EXT-STRT        ==> ' EXT-STRT.
           DISPLAY ' EXT-LEN         ==> ' EXT-LEN.
           DISPLAY ' TOTAL-LENGTH    ==> ' TOTAL-LENGTH.
           DISPLAY ' SPLIT-BUF-LEN   ==> ' SPLIT-BUF-LEN.
           DISPLAY ' JOIN-BUF-LEN    ==> ' JOIN-BUF-LEN.
           DISPLAY ' FIRST-PATH-LEN  ==> ' FIRST-PATH-LEN.

           DISPLAY ' '.
           DISPLAY 'BASE OF FILE NAME ===>'
               PATH-NAME(BASE-STRT:BASE-LEN)
               '<==='.
           DISPLAY ' '.
           DISPLAY 'EXT OF FILE NAME ===>'
               PATH-NAME(EXT-STRT:EXT-LEN)
               '<==='.

           DISPLAY ' '.
           DISPLAY 'TEST 7'.
           DISPLAY ' '.
           INITIALIZE SPLIT-JOIN-PARAM.
           MOVE +24                    TO PARAM-LENGTH.
           MOVE +260                   TO SPLIT-BUF-LEN.
           MOVE +3                     TO SPLITJOIN-FLG1.

           MOVE ALL '@'                TO PATH-NAME(1:40).
           STRING
               'XXXX'
               DELIMITED BY SIZE
               INTO PATH-NAME(1:40).
           DISPLAY 'PATH ==>' PATH-NAME(1:40) '<=='.


           MOVE SPACES                 TO PATH-NAME.
           STRING
               'D:\Seagate Backup Plus Drive\Chuck-Back'
               DELIMITED BY SIZE
               'ups\3570K\Weekly Backup\3570K\Weekly Backup'
               DELIMITED BY SIZE
               '\ TEST.COB   '
               DELIMITED BY SIZE
               X'00'
               DELIMITED BY SIZE
               INTO PATH-NAME
           DISPLAY 'PATH ==>' PATH-NAME(1:100) '<=='.
      *    DISPLAY 'PATH ==>' PATH-NAME '<=='.

           CALL 'CBL_SPLIT_FILENAME' USING
                                     SPLIT-JOIN-PARAM
                                     PATH-NAME.

           IF TOTAL-LENGTH > 80
               COMPUTE J = TOTAL-LENGTH - 80
               END-COMPUTE
               DISPLAY PATH-NAME (1:80)
               DISPLAY PATH-NAME (81:J)
           ELSE
               DISPLAY PATH-NAME (1:TOTAL-LENGTH)
           END-IF.

           DISPLAY ' '.
           DISPLAY ' PARAM-LENGTH    ==> ' PARAM-LENGTH.
           DISPLAY ' SPLITJOIN-FLG1  ==> ' SPLITJOIN-FLG1.
           DISPLAY ' SPLITJOIN-FLG2  ==> ' SPLITJOIN-FLG2.
           DISPLAY ' PATH-STRT       ==> ' PATH-STRT.
           DISPLAY ' PATH-LEN        ==> ' PATH-LEN.
           DISPLAY ' BASE-STRT       ==> ' BASE-STRT.
           DISPLAY ' BASE-LEN        ==> ' BASE-LEN.
           DISPLAY ' EXT-STRT        ==> ' EXT-STRT.
           DISPLAY ' EXT-LEN         ==> ' EXT-LEN.
           DISPLAY ' TOTAL-LENGTH    ==> ' TOTAL-LENGTH.
           DISPLAY ' SPLIT-BUF-LEN   ==> ' SPLIT-BUF-LEN.
           DISPLAY ' JOIN-BUF-LEN    ==> ' JOIN-BUF-LEN.
           DISPLAY ' FIRST-PATH-LEN  ==> ' FIRST-PATH-LEN.

           DISPLAY ' '.
           DISPLAY 'BASE OF FILE NAME ===>'
               PATH-NAME(BASE-STRT:BASE-LEN)
               '<==='.
           DISPLAY ' '.
           DISPLAY 'EXT OF FILE NAME ===>'
               PATH-NAME(EXT-STRT:EXT-LEN)
               '<==='.
           GOBACK.
