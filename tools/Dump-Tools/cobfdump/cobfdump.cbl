       >>SOURCE FORMAT IS FIXED
       IDENTIFICATION DIVISION.
       PROGRAM-ID.   cobfdump.
      *>***************************************************************
      *> This is an GnuCOBOL subroutine that will generate a         **
      *> formatted Hex/Char dump of a storage area.  To use this     **
      *> subroutine, simply CALL it as follows:                      **
      *>                                                             **
      *> CALL "COBFDUMP" USING <data-item>                           ** fcsisat
      *>                       [ <length> ]                          ** fcsisat
      *>                       [ "filename" ]                        ** fcsisat
      *>                       [ "filemode" ]                        ** fcsisat
      *>                                                             **
      *> If specified, the <length> argument specifies how many      **
      *> bytes of <data-item> are to be dumped.  If absent, all of   **
      *> <data-item> will be dumped (i.e. LENGTH(<data-item>) will   **
      *> be assumed for <length>).                                   **
      *>                                                             **
      *> >>> Note that the subroutine name MUST be specified in  <<< **
      *> >>> UPPERCASE                                           <<< **
      *>                                                             **
      *> AUTHOR:       GARY L. CUTLER                                **
      *>                                                             **
      *> NOTE:         The author has a sentimental attachment to    **
      *>               this subroutine - it's been around since 1971 **
      *>               and it's been converted to and run on 10 dif- **
      *>               ferent operating system/compiler environments **
      *>                                                             **
      *> DATE-WRITTEN: October 14, 1971                              **
      *>                                                             **
      *>***************************************************************
      *>  DATE  CHANGE DESCRIPTION                                   **
      *> ====== ==================================================== **
      *> GC1071 Initial coding - Univac Dept. of Defense COBOL '68   **
      *> GC0577 Converted to Univac ASCII COBOL (ACOB) - COBOL '74   **
      *> GC1182 Converted to Univac UTS4000 COBOL - COBOL '74 w/     **
      *>        SCREEN SECTION enhancements                          **
      *> GC0883 Converted to Honeywell/Bull COBOL - COBOL '74        **
      *> GC0983 Converted to IBM VS COBOL - COBOL '74                **
      *> GC0887 Converted to IBM VS COBOL II - COBOL '85             **
      *> GC1294 Converted to Micro Focus COBOL V3.0 - COBOL '85 w/   **
      *>        extensions                                           **
      *> GC0703 Converted to Unisys Universal Compiling System (UCS) **
      *>        COBOL (UCOB) - COBOL '85                             **
      *> GC1204 Converted to Unisys Object COBOL (OCOB) - COBOL 2002 **
      *> GC0609 Converted to OpenCOBOL 1.1 - COBOL '85 w/ some COBOL **
      *>        2002 features                                        **
      *> GC0410 Enhanced to make 2nd argument (buffer length)        **
      *>        optional                                             **
      *> GC0211 Ported to IBM Enterprise COBOL                       **
      *> GC0612 Updated for OpenCOBOL 2.0                            **
      *> VC0322 Moved lines only with . to end of previous statement **
      *>        Fix for bug #816 by making WS-Buffer-Byte-NUM        **
      *>        UNSIGNED                                             **
      *>                                                             **
      *> 070822 Extend GC's great work by adding optional file out   **
      *>          fcsisat by FCSI CodeWerks:                         **
      *> VC1222 Clean up comment here with source references.        **
      *>                                                             **
      *>***************************************************************
       ENVIRONMENT DIVISION.
      *
      * The next three lines should be commented out so the program can
      * be included in a lib*.so.  Un-comment for free-standing compile.
      *
       CONFIGURATION SECTION.
       REPOSITORY.
           FUNCTION ALL INTRINSIC.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT DUMPFILE   ASSIGN TO DISC      DUMPFILE-NAME
                             ORGANIZATION LINE SEQUENTIAL
                             ACCESS SEQUENTIAL
                             STATUS DASDSTAT.
      *
       DATA DIVISION.
       FILE SECTION.
       FD  DUMPFILE.
       01  DUMPFILE-RECD     PIC X(080).

       WORKING-STORAGE SECTION.
      *
      * Version identification string
       01  FILLER.
           03 FILLER         PIC X(016)     VALUE 'FCSI CodeWerks:'.
           03 FILLER         PIC X(064)     VALUE
              'Name:cobfdump  Version:6.22.2  Date:2022-12-07'.
           03 FILLER         PIC X(002)     VALUE LOW-VALUES.
      *
      * The inclusion of an argument 3 affects this flag.
       01                         PIC X(001)     VALUE 'N'.
       88  OUTPUT-IS-DISK         VALUE "Y"      WHEN SET TO FALSE "N". fcsisat
      *
      *                       *** WARNING ***
      * Normally because of potential security issues this program will
      * not write to an existing file.  If the fourth argument exists
      * and is set to 'E' (upper case required) the file named will use
      * 'OPEN EXTEND'.  This may allow you to damage your system so pay
      * attention to the file names you use to hold your dump information
      * and use this extend option carefully.
      *
      *           All the usual denials of responsibility apply.
      *
      *                 *** YOU HAVE BEEN WARNED ***
      *
       01                         PIC X(001)     VALUE 'N'.
       88  EXTEND-OUTPUT          VALUE "Y"      WHEN SET TO FALSE "N". fcsisat
      *
      *
       01  DUMPFILE-NAME     PIC X(256).
       01  DASDSTAT          PIC X(002).
           88 GOODIO                             VALUE "00".
       01  PWD-NAME-TEXT     PIC X(256)          VALUE SPACES.
       01  PWD-NAME-SIZE     PIC 9(004)          VALUE ZEROES.
       01  WS-TEXT-INDX      PIC 9(002).
       01  WS-PATH-CHAR      PIC X(001)          VALUE SPACES.
      *
       01  WS-Addr-PTR                           USAGE POINTER.
       01  WS-Addr-NUM REDEFINES WS-Addr-PTR
                                                 USAGE BINARY-LONG.

       01  WS-Addr-SUB                           USAGE BINARY-CHAR.

       01  WS-Addr-Value-NUM                     USAGE BINARY-LONG.

       01  WS-Buffer-Byte-CHR.
           05 WS-Buffer-Byte-NUM                 USAGE BINARY-CHAR
                                                        UNSIGNED.

       01  WS-Buffer-Length-NUM                  USAGE BINARY-LONG.

       01  WS-Buffer-SUB                         PIC 9(4) COMP-5.

       01  WS-Hex-Digit-TXT VALUE '0123456789ABCDEF'.
           05 WS-Hex-Digit-CHR                   OCCURS 16 TIMES
                                                 PIC X(1).

       01  WS-Nibble-SUB                         PIC 9(1) COMP-5.

       01  WS-Nibble-Left-SUB                    PIC 9(1) COMP-5.

       01  WS-Nibble-Right-SUB                   PIC 9(1) COMP-5.

       01  WS-Output-Detail-TXT.
           05 WS-OD-Addr-TXT.
              10 WS-OD-Addr-Hex-CHR              OCCURS 8 TIMES PIC X.
           05 FILLER                             PIC X(1).
           05 WS-OD-Relative-Byte-NUM            PIC Z(3)9.
           05 FILLER                             PIC X(1).
           05 WS-OD-Hex-TXT                      OCCURS 16 TIMES.
              10 WS-OD-Hex-1-CHR                 PIC X.
              10 WS-OD-Hex-2-CHR                 PIC X.
              10 FILLER                          PIC X.
           05 WS-OD-ASCII-Data-TXT.
              10 WS-OD-ASCII-CHR                 OCCURS 16 TIMES
                                                 PIC X.

       01  WS-Output-SUB                         PIC 9(2) COMP-5.

      *>>SOURCE FORMAT IS FREE                                          fcsisat
       01  WS-Output-Header-1-TXT.
           05 VALUE '<-Addr-> Byte <---------------- Hexadecimal ' &    fcsisat
              '----------------> <---- Char ---->' PIC X(80).           fcsisat

       01  WS-Output-Header-2-TXT.
           05 VALUE '======== ==== ==============================' &    fcsisat
              '================= ================' PIC X(80).

      *>>SOURCE FORMAT IS FIXED                                         fcsisat

       LINKAGE SECTION.
       01  L-Buffer-TXT                          ANY LENGTH.
       01  L-Buffer-Length-NUM                   ANY NUMERIC.   *>Optional
       01  L-File-Name                           ANY LENGTH.    *>Optional
       01  L-File-Mode                           ANY LENGTH.    *>Optional

       PROCEDURE DIVISION USING L-Buffer-TXT,
                       OPTIONAL L-Buffer-Length-NUM,
                       OPTIONAL L-File-Name
                       OPTIONAL L-File-Mode.
       DECLARATIVES.
      *
       DUMPFILE-STAT SECTION.
           USE AFTER STANDARD EXCEPTION PROCEDURE ON DUMPFILE.
       DUMPFILE-CODE.
      *
       END DECLARATIVES.
      *
      *
       000-Main SECTION.
           IF L-Buffer-Length-NUM OMITTED
               MOVE function LENGTH(L-Buffer-TXT) TO
                 WS-Buffer-Length-NUM
           ELSE
               MOVE L-Buffer-Length-NUM TO WS-Buffer-Length-NUM
           END-IF.
           IF WS-Buffer-Length-NUM Not > ZEROES
               MOVE 1 TO WS-Buffer-Length-NUM
           END-IF.

           IF L-File-Name OMITTED
               GO TO 020-CONTINUE
           END-IF.
      *
      * A dump file name has been included in the srguments - check mode
           SET EXTEND-OUTPUT TO FALSE.
           IF L-File-Mode OMITTED
               CONTINUE
           ELSE
               IF L-File-Mode(1:1) = 'E'   *>uppercase required
                   SET EXTEND-OUTPUT TO TRUE
               END-IF
           END-IF.
      *
      * File creation seems to work better in GnuCobol if the file name
      * is a fully qualified value.  Therefore if a file name does not
      * start with a '/' or a '\' we will prepend the submitted name
      * with the path to the current folder.
           PERFORM 700-SET-PATH-CHAR.
           IF L-File-Name(1:1) = WS-PATH-CHAR    *>ie /tmp/mydumpfile
           OR L-File-Name(3:1) = WS-PATH-CHAR    *>WinDoze D:\temp\dumpfile
               MOVE L-File-Name TO DUMPFILE-NAME
               GO TO 010-CONTINUE
           END-IF.
      * Prepend the current folder name to the requested file name ...
           MOVE 1 TO WS-TEXT-INDX
           IF L-File-Name(1:2) = './'
               MOVE 3 TO WS-TEXT-INDX
           END-IF
           MOVE length of PWD-NAME-TEXT TO PWD-NAME-SIZE
           CALL "CBL_GET_CURRENT_DIR" USING
               BY VALUE 0,
               BY VALUE PWD-NAME-SIZE,
               BY REFERENCE PWD-NAME-TEXT
           END-CALL
           MOVE SPACES TO DUMPFILE-NAME
           STRING PWD-NAME-TEXT   DELIMITED ' ',
                  WS-PATH-CHAR    DELIMITED SIZE,
                  L-File-Name(WS-TEXT-INDX:) DELIMITED ' '
             INTO DUMPFILE-NAME
           END-STRING.

       010-CONTINUE.
      * For security reasons the default is to NOT allow writing to an
      * existing file unless argument 4 is present and set to 'E'.
           IF EXTEND-OUTPUT      *>Extending an existing file requested
               OPEN EXTEND DUMPFILE
               IF GOODIO
                   SET OUTPUT-IS-DISK TO TRUE
                   GO TO 020-CONTINUE
               END-IF
      * The requested extension of an existing dump file has failed.
      * Proceed with the default procedure by creating a new file.
               SET EXTEND-OUTPUT TO FALSE
           END-IF.
      * Initialize a new dump file.
           OPEN INPUT DUMPFILE    *>First check that file doesn't exist.
           IF GOODIO
               CLOSE DUMPFILE     *>File found; dump to disk not allowed.
               SET OUTPUT-IS-DISK TO FALSE
           ELSE
               OPEN OUTPUT DUMPFILE
               IF GOODIO
                   SET OUTPUT-IS-DISK TO TRUE
               END-IF
           END-IF.

       020-CONTINUE.
           MOVE SPACES TO WS-Output-Detail-TXT
           SET WS-Addr-PTR TO ADDRESS OF L-Buffer-TXT
           PERFORM 100-Generate-Address
           MOVE 0 TO WS-Output-SUB
           IF OUTPUT-IS-DISK
             WRITE DUMPFILE-RECD FROM WS-Output-Header-1-TXT
             WRITE DUMPFILE-RECD FROM WS-Output-Header-2-TXT
           ELSE
             DISPLAY WS-Output-Header-1-TXT UPON SYSERR
             DISPLAY WS-Output-Header-2-TXT UPON SYSERR
           END-IF.
           PERFORM VARYING WS-Buffer-SUB FROM 1 BY 1
                     UNTIL WS-Buffer-SUB > WS-Buffer-Length-NUM
               ADD 1 TO WS-Output-SUB
               IF WS-Output-SUB = 1
                   MOVE WS-Buffer-SUB TO WS-OD-Relative-Byte-NUM
               END-IF
               MOVE L-Buffer-TXT (WS-Buffer-SUB : 1)
                 TO WS-OD-ASCII-CHR (WS-Output-SUB)
                    WS-Buffer-Byte-CHR
               DIVIDE WS-Buffer-Byte-NUM BY 16
                   GIVING WS-Nibble-Left-SUB
                   REMAINDER WS-Nibble-Right-SUB
               ADD 1 TO WS-Nibble-Left-SUB
                        WS-Nibble-Right-SUB
               MOVE WS-Hex-Digit-CHR (WS-Nibble-Left-SUB)
                 TO WS-OD-Hex-1-CHR  (WS-Output-SUB)
               MOVE WS-Hex-Digit-CHR (WS-Nibble-Right-SUB)
                 TO WS-OD-Hex-2-CHR  (WS-Output-SUB)
               IF WS-Output-SUB = 16
                   CALL "CBL_GC_PRINTABLE" USING WS-OD-ASCII-Data-TXT   fcsisat
                   IF OUTPUT-IS-DISK
                     WRITE DUMPFILE-RECD FROM WS-Output-Detail-TXT
                   ELSE
                     DISPLAY WS-Output-Detail-TXT UPON SYSERR
                   END-IF
                   MOVE SPACES TO WS-Output-Detail-TXT
                   MOVE 0 TO WS-Output-SUB
                   SET WS-Addr-PTR UP BY 16
                   PERFORM 100-Generate-Address
               END-IF
           END-PERFORM
           IF WS-Output-SUB > 0
               CALL "CBL_GC_PRINTABLE" USING WS-OD-ASCII-Data-TXT       fcsisat
               IF OUTPUT-IS-DISK
                 WRITE DUMPFILE-RECD FROM WS-Output-Detail-TXT
               ELSE
                 DISPLAY WS-Output-Detail-TXT UPON SYSERR
               END-IF
           END-IF.
           CLOSE DUMPFILE.
           EXIT PROGRAM.

       100-Generate-Address SECTION.
       100-Generate-Address-0000.
           MOVE 8 TO WS-Addr-SUB
           MOVE WS-Addr-NUM TO WS-Addr-Value-NUM
           MOVE ALL '0' TO WS-OD-Addr-TXT
           PERFORM WITH TEST BEFORE UNTIL WS-Addr-Value-NUM = 0
               DIVIDE WS-Addr-Value-NUM BY 16
                   GIVING WS-Addr-Value-NUM
                   REMAINDER WS-Nibble-SUB
               ADD 1 TO WS-Nibble-SUB
               MOVE WS-Hex-Digit-CHR (WS-Nibble-SUB)
                 TO WS-OD-Addr-Hex-CHR (WS-Addr-SUB)
               SUBTRACT 1 FROM WS-Addr-SUB
           END-PERFORM.
       100-Generate-Address-EXIT.
           EXIT.
      *
      * Set up WS-PATH-CHAR from environmental $HOME or $WINDIR.
      * Use linux '\' as default.
       700-SET-PATH-CHAR SECTION.
       700-SET-PATH-CHAR-0000.
           ACCEPT WS-PATH-CHAR FROM ENVIRONMENT 'HOME'.
           IF WS-PATH-CHAR = ' '
               ACCEPT WS-PATH-CHAR FROM ENVIRONMENT 'WINDIR'
           END-IF
           IF WS-PATH-CHAR = ' '
               MOVE '\' TO WS-PATH-CHAR
           END-IF.
       700-SET-PATH-CHAR-EXIT.
           EXIT.
      *
      *
       END PROGRAM cobfdump.
      *

