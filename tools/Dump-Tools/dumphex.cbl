000010 IDENTIFICATION DIVISION.
000020 PROGRAM-ID. DUMPHEX.
000030*>***************************************************************
000040*> THIS IS MY 32 BYTE WIDE VERSION I CALL DUMPHEX              **
000050*> This is an COBOL subroutine that will generate a            **
000060*> formatted Hex/Char dump of a storage area. To use this      **
000070*> subroutine, simply CALL it as follows:                      **
000080*>                                                             **
000090*> CALL "DUMPHEX" USING <data-item> [ <length> ]               **
000100*>                                                             **
000110*>                                                             **
000120*> If specified, the <length> argument specifies how many      **
000130*> bytes of <data-item> are to be dumped. If absent, all of    **
000140*> <data-item> will be dumped (i.e. LENGTH(<data-item>) will   **
000150*> be assumed for <length>). Define <length> in WS as an       **
000160*> 05  WS-Buffer-Length USAGE BINARY-LONG.                     **
000170*>                                                             **
000180*> >>> Note that the subroutine name MUST be specified in <<<  **
000190*> >>> UPPERCASE <<<                                           **
000200*>                                                             **
000210*> The dump is generated to SYSERR, so you may pipe it to a    **
000220*> file when you execute your program using "2> file".         **
000230*>***************************************************************
000240 ENVIRONMENT DIVISION.
000250 CONFIGURATION SECTION.
000260 REPOSITORY.
000270 FUNCTION ALL INTRINSIC.
000280 DATA DIVISION.
000290 WORKING-STORAGE SECTION.
000300 01  WS-Addr-PTR USAGE POINTER.
000310 01  WS-Addr-NUM REDEFINES WS-Addr-PTR
000320     USAGE BINARY-LONG.
000330
000340 01  WS-Addr-SUB             USAGE BINARY-CHAR.
000350
000360 01  WS-Addr-Value-NUM       USAGE BINARY-LONG.
000370
000380 01  WS-Buffer-Byte-CHR.
000390     05  WS-Buffer-Byte-NUM  USAGE BINARY-CHAR UNSIGNED.
000400
000410 01  WS-Buffer-Length-NUM    USAGE BINARY-LONG.
000420
000430 01  WS-Buffer-Length-DISP   PIC Z(9)9.
000440
000450 01  WS-Buffer-SUB           PIC 9(8) COMP-5.
000460
000470 01  WS-Hex-Digit-TXT VALUE "0123456789ABCDEF".
000480     05 WS-Hex-Digit-CHR OCCURS 16 TIMES
000490                                PIC X(1).
000500
000510 01  WS-Nibble-SUB           PIC 9(1) COMP-5.
000520
000530 01  WS-Nibble-Left-SUB      PIC 9(1) COMP-5.
000540
000550 01  WS-Nibble-Right-SUB     PIC 9(1) COMP-5.
000560
000570 01  WS-Output-Detail-TXT.
000580     05 WS-OD-Addr-TXT.
000590        10 WS-OD-Addr-Hex-CHR OCCURS 8 TIMES PIC X.
000600     05 FILLER               PIC X(1).
000610     05 WS-OD-Relative-Byte-NUM PIC Z(4)9.
000620     05 FILLER               PIC X(1).
000630     05 WS-OD-Hex-TXT OCCURS 32 TIMES.
000640       10 WS-OD-Hex-1-CHR    PIC X.
000650       10 WS-OD-Hex-2-CHR    PIC X.
000660       10 FILLER             PIC X.
000670     05 WS-OD-ASCII-Data-TXT.
000680       10 WS-OD-ASCII-CHR OCCURS 32 TIMES PIC X.
000690
000700
000710 01  WS-Output-SUB           PIC 9(2) COMP-5.
000720
000730 01  WS-Output-Header-1-TXT.
000740     05 VALUE " Address  Byte " &
000750              "<-----------------------------" &
000760              "----HEXIDECIMAL CHARACTERS----" &
000770              "------------------------------" &
000780              "----> " &
000790              "<------ ASCII Characters ------>"
000800                                                PIC X(143).
000810
000820 01  WS-Output-Header-2-TXT.
000830     05 VALUE "           No  " &
000840              " 0           0              1 " &
000850              "             1              2 " &
000860              "             2              3 " &
000870              "      " &
000880              "0   0    1    1    2    2    3  " PIC X(143).
000890
000900 01  WS-Output-Header-3-TXT.
000910     05 VALUE "======== ===== " &
000920              " 1 == == ==  5 == == == ==  0 " &
000930              "== == == ==  5 == == == ==  0 " &
000940              "== == == ==  5 == == == ==  0 " &
000950              "== == " &
000960              "1===5====0====5====0====5====0==" PIC X(143).
000970
000980 LINKAGE SECTION.
000990 01  L-Buffer-TXT            PIC X ANY LENGTH.
001000
001010 01  L-Buffer-Length-NUM     USAGE BINARY-LONG.
001020
001030 PROCEDURE DIVISION USING L-Buffer-TXT,
001040 OPTIONAL L-Buffer-Length-NUM.
001050 000-Main SECTION.
001060* Do we have any CALL-PARAMETERS? If not, quit.
001070
001080     IF NUMBER-OF-CALL-PARAMETERS = 0
001090        DISPLAY "ERROR - No Call-Parameters passed"
001100         " Exit without dump." UPON SYSERR
001110        DISPLAY "You MUST Provide an <address> "
001120                "and optionally a <length>." UPON SYSERR
001130        GOBACK
001140     END-IF
001150
001160* If we have only 1 CALL PARAMETER, assume it to be the data to
001170* dump and use its' length for the number of characters to dump.
001180
001190     IF NUMBER-OF-CALL-PARAMETERS = 1
001200        MOVE LENGTH(L-Buffer-TXT) TO WS-Buffer-Length-NUM
001210     ELSE
001220        MOVE L-Buffer-Length-NUM TO WS-Buffer-Length-NUM
001230     END-IF
001240
001250* Make sure the length is Less than the 5 digit byte number field.
001260* This is to prevent the program from exceeding the "Byte No"
001270* feild size of 99999. See (WS-OD-Relative-Byte-NUM).
001280* By the way, 99998 would be 3,124 lines of display.
001290     IF WS-Buffer-Length-NUM > 99998
001300        MOVE 99998 TO WS-Buffer-Length-NUM
001310     END-IF
001320
001330* Do some housekeeping and display column headings.
001340
001350     MOVE SPACES TO WS-Output-Detail-TXT
001360     SET WS-Addr-PTR TO ADDRESS OF L-Buffer-TXT
001370     PERFORM 100-Generate-Address
001380     MOVE 0 TO WS-Output-SUB
001390     MOVE WS-Buffer-Length-NUM TO WS-Buffer-Length-DISP
001400     DISPLAY " " UPON SYSERR
001410     DISPLAY "DUMPING " TRIM(WS-Buffer-Length-DISP)
001420             " CHARACTERS STARTING AT " WS-OD-Addr-TXT
001430                                    UPON SYSERR
001440     DISPLAY WS-Output-Header-1-TXT UPON SYSERR
001450     DISPLAY WS-Output-Header-2-TXT UPON SYSERR
001460     DISPLAY WS-Output-Header-3-TXT UPON SYSERR
001470
001480* This is the main logic. Do this perform until we have dumped
001490* WS-Buffer-Length-NUM characters.
001500
001510     PERFORM VARYING WS-Buffer-SUB FROM 1 BY 1
001520             UNTIL WS-Buffer-SUB > WS-Buffer-Length-NUM
001530         ADD 1 TO WS-Output-SUB
001540         IF WS-Output-SUB = 1
001550            MOVE WS-Buffer-SUB TO WS-OD-Relative-Byte-NUM
001560         END-IF
001570         MOVE L-Buffer-TXT (WS-Buffer-SUB : 1)
001580                       TO WS-OD-ASCII-CHR (WS-Output-SUB)
001590                          WS-Buffer-Byte-CHR
001600         DIVIDE WS-Buffer-Byte-NUM BY 16
001610            GIVING WS-Nibble-Left-SUB
001620            REMAINDER WS-Nibble-Right-SUB
001630         ADD 1 TO WS-Nibble-Left-SUB
001640                  WS-Nibble-Right-SUB
001650         MOVE WS-Hex-Digit-CHR (WS-Nibble-Left-SUB)
001660              TO WS-OD-Hex-1-CHR (WS-Output-SUB)
001670         MOVE WS-Hex-Digit-CHR (WS-Nibble-Right-SUB)
001680              TO WS-OD-Hex-2-CHR (WS-Output-SUB)
001690         IF WS-Output-SUB = 32
001700            CALL "CBL_GC_PRINTABLE" USING WS-OD-ASCII-Data-TXT
001710            DISPLAY WS-Output-Detail-TXT UPON SYSERR
001720            MOVE SPACES TO WS-Output-Detail-TXT
001730            MOVE 0 TO WS-Output-SUB
001740            SET WS-Addr-PTR UP BY 32
001750            PERFORM 100-Generate-Address
001760         END-IF
001770     END-PERFORM
001780
001790* We are all done. Print the last row of data and GOBACK.
001800
001810     IF WS-Output-SUB > 0
001820        CALL "CBL_GC_PRINTABLE" USING WS-OD-ASCII-Data-TXT
001830        DISPLAY WS-Output-Detail-TXT UPON SYSERR
001840     END-IF
001850     GOBACK
001860     .
001870 100-Generate-Address SECTION.
001880     MOVE 8                  TO WS-Addr-SUB
001890     MOVE WS-Addr-NUM        TO WS-Addr-Value-NUM
001900     MOVE ALL "0"            TO WS-OD-Addr-TXT
001910     PERFORM WITH TEST BEFORE UNTIL WS-Addr-Value-NUM = 0
001920       DIVIDE      WS-Addr-Value-NUM BY 16
001930            GIVING WS-Addr-Value-NUM
001940         REMAINDER WS-Nibble-SUB
001950       ADD 1                 TO WS-Nibble-SUB
001960       MOVE WS-Hex-Digit-CHR (WS-Nibble-SUB)
001970          TO WS-OD-Addr-Hex-CHR (WS-Addr-SUB)
001980       SUBTRACT 1 FROM WS-Addr-SUB
001990     END-PERFORM.
002000
