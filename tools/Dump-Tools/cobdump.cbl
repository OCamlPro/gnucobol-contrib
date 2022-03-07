       >>SOURCE FORMAT IS FIXED
       IDENTIFICATION DIVISION.
       PROGRAM-ID.   COBDUMP.
      *>***************************************************************
      *> This is an OpenCOBOL subroutine that will generate a        **
      *> formatted Hex/Char dump of a storage area.  To use this     **
      *> subroutine, simply CALL it as follows:                      **
      *>                                                             **
      *> CALL "COBDUMP" USING <data-item>                            **
      *>                    [ <length> ]                             **
      *>                                                             **
      *> If specified, the <length> argument specifies how many      **
      *> bytes of <data-item> are to be dumped.  If absent, all of   **
      *> <data-item> will be dumped (i.e. LENGTH(<data-item>) will   **
      *> be assumed for <length>).                                   **
      *>                                                             **
      *> >>> Note that the subroutine name MUST be specified in  <<< **
      *> >>> UPPERCASE                                           <<< **
      *>                                                             **
      *> The dump is generated to STDERR, so you may pipe it to a    **
      *> file when you execute your program using "2> file".         **
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
      *>***************************************************************
       ENVIRONMENT DIVISION.
       CONFIGURATION SECTION.
       REPOSITORY.
           FUNCTION ALL INTRINSIC.
       DATA DIVISION.
       WORKING-STORAGE SECTION.
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

       >>SOURCE FORMAT IS FREE
       01  WS-Output-Header-1-TXT.
           05 VALUE '<-Addr-> Byte <---------------- Hexadecimal ''----------------> <---
- Char ---->' PIC X(80).

       01  WS-Output-Header-2-TXT.
           05 VALUE '======== ==== =============================================== ======
==========' PIC X(80).
       >>SOURCE FORMAT IS FIXED

       LINKAGE SECTION.
       01  L-Buffer-TXT                          PIC X ANY LENGTH.

       01  L-Buffer-Length-NUM                   USAGE BINARY-LONG.

       PROCEDURE DIVISION USING L-Buffer-TXT,
                                OPTIONAL L-Buffer-Length-NUM.
       000-Main SECTION.
           IF NUMBER-OF-CALL-PARAMETERS = 1
               MOVE LENGTH(L-Buffer-TXT) TO WS-Buffer-Length-NUM
           ELSE
               MOVE L-Buffer-Length-NUM  TO WS-Buffer-Length-NUM
           END-IF
           MOVE SPACES TO WS-Output-Detail-TXT
           SET WS-Addr-PTR TO ADDRESS OF L-Buffer-TXT
           PERFORM 100-Generate-Address
           MOVE 0 TO WS-Output-SUB
           DISPLAY WS-Output-Header-1-TXT UPON SYSERR
           DISPLAY WS-Output-Header-2-TXT UPON SYSERR
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
                   CALL "C$PRINTABLE" USING WS-OD-ASCII-Data-TXT
                   DISPLAY WS-Output-Detail-TXT UPON SYSERR
                   MOVE SPACES TO WS-Output-Detail-TXT
                   MOVE 0 TO WS-Output-SUB
                   SET WS-Addr-PTR UP BY 16
                   PERFORM 100-Generate-Address
               END-IF
           END-PERFORM
           IF WS-Output-SUB > 0
               CALL "C$PRINTABLE" USING WS-OD-ASCII-Data-TXT
               DISPLAY WS-Output-Detail-TXT UPON SYSERR
           END-IF
           EXIT PROGRAM.

       100-Generate-Address SECTION.
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
           END-PERFORM
           .
