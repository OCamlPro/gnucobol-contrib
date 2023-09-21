       IDENTIFICATION DIVISION.
       PROGRAM-ID. VFILE005.
       ENVIRONMENT DIVISION.
       CONFIGURATION SECTION.

      *SOURCE-COMPUTER. IBM-PC  WITH DEBUGGING MODE.

       OBJECT-COMPUTER. IBM-PC.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
       DATA DIVISION.
       WORKING-STORAGE SECTION.

       77  SW-FIRST-TIME              PIC X  VALUE 'Y'.

       01  HEAP-ID                    PIC 9(4) COMP-5.
       01  RELATIVE-ADDRESS-IN-HEAP   BINARY-LONG UNSIGNED.
       01  DATA-LENGTH                BINARY-LONG UNSIGNED.
       01  HEAP-STATUS                PIC X(2).
       01  STATUS-CODE                PIC S9(4) COMP-5.

       01  PTR-HEAP                        USAGE POINTER.

       01  CNTR-COUNTERS     USAGE BINARY-LONG UNSIGNED.
           05  CNTR-HEAP.
           05  CNTR-RCD-WRITTEN.
           05  CNTR-RCD-READ.
           05  CNTR-RCD-LENGTH.
           05  CNTR-RELATVIE-POS.

       01  TMP.
           05  TMP-DOUBLE                  BINARY-DOUBLE UNSIGNED.
           05  TMP-MILLISECONDS            BINARY-LONG.
           05  TMP-NBR                     BINARY-LONG UNSIGNED.
           05  TMP-KB                      PIC X(8).
           05  TMP-DISPLAY                 PIC ZZZ,ZZZ,ZZ9.
           05  TMP-DISPLAY-LONG            PIC ZZZ,ZZZ,ZZZ,ZZZ,ZZZ,ZZ9.

       01  REC-BUFFER                      PIC X(100).

       01  REC-RECORD-AREA.
           05  FILLER                      PIC X(7)  VALUE 'HEAPID '.
           05  REC-HEAP-ID                 PIC 9(3).
           05  FILLER                      PIC X(8)  VALUE ' RECORD '.
           05  REC-RCD-COUNT               PIC ZZZ,ZZZ,ZZ9.
           05  FILLER                      PIC X     VALUE SPACE.
           05  FILLER                      PIC X(10)
                   VALUE '0123456789'.
           05  FILLER                      PIC X(10)
                   VALUE '0123456789'.
           05  FILLER                      PIC X(10)
                   VALUE '0123456789'.
           05  FILLER                      PIC X(10)
                   VALUE '0123456789'.
           05  FILLER                      PIC X(10)
                   VALUE '0123456789'.
           05  FILLER                      PIC X(10)
                   VALUE '0123456789'.
           05  FILLER                      PIC X(10)
                   VALUE '0123456789'.

       01  MEM-MEMORY-STATUS.
           05  MEM-LENGTH                  BINARY-LONG UNSIGNED.
           05  MEM-PAGEFAULTCOUNT          BINARY-LONG UNSIGNED.
           05  MEM-PEAKWORKINGSETSIZE      BINARY-LONG UNSIGNED.
           05  MEM-WORKINGSETSIZE          BINARY-LONG UNSIGNED.
           05  MEM-QUOTAPEAKPAGEDPOOL      BINARY-LONG UNSIGNED.
           05  MEM-QUOTAPAGEDPOOL          BINARY-LONG UNSIGNED.
           05  MEM-QUOTAPEAKNONPAGEDPOOL   BINARY-LONG UNSIGNED.
           05  MEM-QUOTANONPAGEDPOOL       BINARY-LONG UNSIGNED.
           05  MEM-PAGEFILE                BINARY-LONG UNSIGNED.
           05  MEM-PEAKPAGEFILE            BINARY-LONG UNSIGNED.

       01  DSP-TEXT.
           05 DSP-01 PIC X(28) VALUE ' PERCENT OF MEMORY IN USE   '.
           05 DSP-02 PIC X(28) VALUE ' TOTAL KB OF PHYSICAL MEMORY'.
           05 DSP-03 PIC X(28) VALUE ' FREE  KB OF PHYSICAL MEMORY'.
           05 DSP-04 PIC X(28) VALUE ' TOTAL KB OF PAGING FILE    '.
           05 DSP-05 PIC X(28) VALUE ' FREE  KB OF PAGING FILE    '.
           05 DSP-06 PIC X(28) VALUE ' TOTAL KB OF VIRTUAL MEMORY '.
           05 DSP-07 PIC X(28) VALUE ' FREE  KB OF VIRTUAL MEMORY '.
           05 DSP-08 PIC X(28) VALUE ' FREE  KB OF EXTENDED MEMORY'.

       01  ENV-TEXT                        PIC X(256).

       LINKAGE SECTION.

       01  HEAP-ARRAY.
           05  HEAP-ENTRY        OCCURS 512 TIMES.
               10  HEAP-EYE-BALL           PIC X(10).
               10  HEAP-HEAP-ID            BINARY-SHORT UNSIGNED.
               10  HEAP-PTR-SEG-FIRST      POINTER.
               10  HEAP-PTR-SEG-LAST       POINTER.
               10  HEAP-SEG-COUNT          BINARY-LONG UNSIGNED.
               10  HEAP-TOTAL-ALLOC        BINARY-LONG UNSIGNED.
               10  HEAP-TOTAL-DATA-ALLOC   BINARY-LONG UNSIGNED.

       01  SEG-SEGMENT-AREA.
           05  SEG-EYE-BALLL               PIC X(10).
           05  SEG-HEAP-IDD                BINARY-SHORT UNSIGNED.
           05  SEG-PTR-PREV-SEGST          POINTER.
           05  SEG-PTR-NEXT-SEGT           POINTER.
           05  SEG-SEG-NUM                 BINARY-LONG UNSIGNED.
           05  SEG-SEG-SIZE                BINARY-LONG UNSIGNED.
           05  SEG-SEG-DATA-SIZE           BINARY-LONG UNSIGNED.
           05  SEG-SEG-DATA-REL-START      BINARY-LONG UNSIGNED.
           05  SEG-SEG-DATA-REL-END        BINARY-LONG UNSIGNED.
           05  SEG-DATA                    PIC X(512000).

       PROCEDURE DIVISION.

       0000-MAINLINE.

      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *                                                               *
      *    THE FOLLOWING CALL IS USE TO RESOLVE ALL THE ENTRY         *
      *    POINTS IN THE CBL_VFILES.DLL                               *
      *                                                               *
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

           DISPLAY 'BEFORE CALLING CBL_VFILES'.
      *    DISPLAY 'CWH-VFILES;CWH-ROUTINES;KERNEL32,CBL_SCREENIO'
      *                                    UPON ENVIRONMENT-VALUE.
      *    ACCEPT ENV-TEXT                 FROM ENVIRONMENT-VALUE.
      *    DISPLAY 'COB_PRE_LOAD=' ENV-TEXT.

           DISPLAY '  ENTER MEMORY ALLOCATION IN KB '.
           ACCEPT TMP-KB.


           DISPLAY 'CBL_DIAGNOSTIC'        UPON ENVIRONMENT-NAME.
           DISPLAY  'OFF'                  UPON ENVIRONMENT-VALUE.

           DISPLAY 'CBL_MEM_ALLOC_KB'      UPON ENVIRONMENT-NAME.
           DISPLAY  TMP-KB                 UPON ENVIRONMENT-VALUE.

           DISPLAY 'CBL_MEM_ALLOC_INIT'    UPON ENVIRONMENT-NAME.
           DISPLAY  'OFF'                  UPON ENVIRONMENT-VALUE.

           CALL 'CBL_VFILES'.

           CALL 'CBL_START_TIME'.

           PERFORM 1000-MEMORY-USAGE THRU 1000-EXIT.
           DISPLAY 'AFTER MEMORY USAGE'.
           MOVE ZERO                   TO CNTR-HEAP.
           MOVE LENGTH OF REC-RECORD-AREA
                                       TO DATA-LENGTH.
      D    DISPLAY ' LENGTH OF DATA RECORD IS ' DATA-LENGTH.

           PERFORM WITH TEST AFTER
               UNTIL CNTR-HEAP >= 1
                  OR RETURN-CODE NOT EQUAL ZERO
                   ADD +1              TO CNTR-HEAP
                   PERFORM 2000-OPEN-VFILE THRU 2000-EXIT
           END-PERFORM.

           MOVE ZERO                   TO CNTR-RCD-WRITTEN.

           PERFORM 5000000    TIMES
               ADD +1                  TO CNTR-RCD-WRITTEN
               PERFORM 4000-WRITE-VFILE THRU 4000-EXIT
           END-PERFORM.

           MOVE ZERO                   TO CNTR-RCD-READ.

           PERFORM 5000000    TIMES
               ADD +1                  TO CNTR-RCD-READ
               PERFORM 5000-READ-VFILE THRU 5000-EXIT
           END-PERFORM.

           PERFORM 1000-MEMORY-USAGE THRU 1000-EXIT.
           PERFORM 6000-CLOSE-VFILE-ALL THRU 6000-EXIT

           PERFORM 1000-MEMORY-USAGE THRU 1000-EXIT.
           CALL 'CBL_TIME_DIFF' USING TMP-MILLISECONDS.
           DISPLAY ' TIME TO OPEN 512 VFILES IS                  '
               TMP-MILLISECONDS
               ' MILLISECONDS'.
           CALL 'CBL_CPU_CYCLES' USING TMP-DOUBLE.
           MOVE TMP-DOUBLE             TO TMP-DISPLAY-LONG.
           DISPLAY ' *** CPU CLOCK CYCLES ==> ' TMP-DISPLAY-LONG.

       0000-STOP.

           STOP RUN.

       0000-EXIT.  EXIT.


       1000-MEMORY-USAGE.

           DISPLAY 'LENGTH OF MEM-MEMORY-STATUS IS '
                    LENGTH OF MEM-MEMORY-STATUS.
      *    MOVE LENGTH OF MEM-MEMORY-STATUS    TO MEM-LENGTH.
           CALL 'CBL_MEMORY_STATUS'  USING MEM-MEMORY-STATUS.

           DISPLAY ' '.
           DISPLAY ' CONTENTS OF MEMORY STATUS ...'.
           DISPLAY ' '.

      *    DISPLAY ' MEM-LENGTH                '
      *              MEM-LENGTH
      *    DISPLAY ' MEM-PAGEFAULTCOUNT        '
      *              MEM-PAGEFAULTCOUNT
      *    DISPLAY ' MEM-PEAKWORKINGSETSIZE    '
      *              MEM-PEAKWORKINGSETSIZE
      *    DISPLAY ' MEM-WORKINGSETSIZE        '
      *              MEM-WORKINGSETSIZE
      *    DISPLAY ' MEM-QUOTAPEAKPAGEDPOOL    '
      *              MEM-QUOTAPEAKPAGEDPOOL
      *    DISPLAY ' MEM-QUOTAPAGEDPOOL        '
      *              MEM-QUOTAPAGEDPOOL
      *    DISPLAY ' MEM-QUOTAPEAKNONPAGEDPOOL '
      *              MEM-QUOTAPEAKNONPAGEDPOOL
      *    DISPLAY ' MEM-QUOTANONPAGEDPOOL     '
      *              MEM-QUOTANONPAGEDPOOL
           DISPLAY ' MEM-PAGEFILE              '
                     MEM-PAGEFILE
           DISPLAY ' MEM-PEAKPAGEFILE          '
                     MEM-PEAKPAGEFILE
           .
       1000-EXIT.  EXIT.


       2000-OPEN-VFILE.

           CALL 'CBL_OPEN_VFILE' USING HEAP-ID
                                       HEAP-STATUS.

           IF RETURN-CODE NOT EQUAL ZERO
               DISPLAY 'CBL_OPEN_VFILE FAILED AT HEAP-ID ==> '
                   CNTR-HEAP.

      D    DISPLAY ' HEAP-ID IS ==> ' HEAP-ID.

       2000-EXIT.  EXIT.


       3000-PRINT-HEAP.

           CALL 'CBL_GET_HEAP_POINTER' USING PTR-HEAP.

           IF PTR-HEAP = NULL
               DISPLAY 'CBL_GET_HEAP_POINTER RETURNED NULL'
               GO TO 0000-STOP
           END-IF.

           SET ADDRESS OF HEAP-ARRAY   TO PTR-HEAP.
           MOVE ZERO                   TO CNTR-HEAP.
      D    DISPLAY ' *** STARTING HEAP PRINT ***'.

           PERFORM 512 TIMES
               ADD +1                  TO CNTR-HEAP
               PERFORM 3100-PRINT-HEAP-ENTRY THRU 3100-EXIT
           END-PERFORM.

       3000-EXIT.  EXIT.


       3100-PRINT-HEAP-ENTRY.

           IF HEAP-EYE-BALL (CNTR-HEAP) NOT EQUAL 'HEAP ENTRY'
               DISPLAY 'INVALID HEAP ENTRY AT HEAP-ID ' CNTR-HEAP
               GO TO 0000-STOP
           END-IF.

           IF HEAP-SEG-COUNT (CNTR-HEAP) > 0
               DISPLAY ' HEAP ID '
                   HEAP-HEAP-ID           (CNTR-HEAP) '  '
                   HEAP-PTR-SEG-FIRST     (CNTR-HEAP) '  '
                   HEAP-PTR-SEG-LAST      (CNTR-HEAP) '  '
                   HEAP-SEG-COUNT         (CNTR-HEAP) '  '
                   HEAP-TOTAL-ALLOC       (CNTR-HEAP) '  '
                   HEAP-TOTAL-DATA-ALLOC  (CNTR-HEAP)
           END-IF.

       3100-EXIT.  EXIT.


       4000-WRITE-VFILE.

      *    IF CNTR-RCD-WRITTEN = 11
      *        COMPUTE RELATIVE-ADDRESS-IN-HEAP
      *            = ((5                - 1) * DATA-LENGTH) + 1
      *        END-COMPUTE
      *    ELSE
               COMPUTE RELATIVE-ADDRESS-IN-HEAP
                   = ((CNTR-RCD-WRITTEN - 1) * DATA-LENGTH) + 1
               END-COMPUTE
      *    END-IF.
               MOVE SPACES                 TO HEAP-STATUS
               MOVE HEAP-ID                TO REC-HEAP-ID
               MOVE CNTR-RCD-WRITTEN       TO REC-RCD-COUNT

      D    DISPLAY ' '.
      D    DISPLAY 'CNTR-RCD-WRITTEN IS '
      D        CNTR-RCD-WRITTEN
      D    DISPLAY 'RECORD WRITTEN AT OFFSET '
      D        RELATIVE-ADDRESS-IN-HEAP
      D    DISPLAY 'DATA LENGTH IS '
      D        DATA-LENGTH
      D    DISPLAY REC-RECORD-AREA (1:50).
      D    DISPLAY ' '.

      *    IF  CNTR-RCD-WRITTEN >= 1305
      *    AND CNTR-RCD-WRITTEN <= 1329
      *        DISPLAY ' IN CBL_WRITE_VFILE  '
      *            'HEAP ID ' HEAP-ID
      *            ' REL ADDR ' RELATIVE-ADDRESS-IN-HEAP
      *            ' DATA LEN ' DATA-LENGTH
      *    END-IF.

           CALL "CBL_WRITE_VFILE"
               USING BY VALUE HEAP-ID
                     BY VALUE RELATIVE-ADDRESS-IN-HEAP
                     BY VALUE DATA-LENGTH
                     BY REFERENCE REC-RECORD-AREA.

           IF RETURN-CODE NOT EQUAL ZERO
               DISPLAY 'CBL_WRITE_VFILE BAD RETURN CODE '
                   RETURN-CODE
                   ' AT RCD '
                   CNTR-RCD-WRITTEN
               GO TO 0000-STOP
           END-IF.

       4000-EXIT.  EXIT.


       5000-READ-VFILE.

           COMPUTE RELATIVE-ADDRESS-IN-HEAP
               = ((CNTR-RCD-READ - 1) * DATA-LENGTH) + 1
           END-COMPUTE.

           MOVE SPACES                 TO HEAP-STATUS.
           MOVE HEAP-ID                TO REC-HEAP-ID.
           MOVE CNTR-RCD-READ          TO REC-RCD-COUNT.

           CALL "CBL_READ_VFILE"
               USING BY VALUE HEAP-ID
                     BY VALUE RELATIVE-ADDRESS-IN-HEAP
                     BY VALUE DATA-LENGTH
                     BY REFERENCE REC-BUFFER.

           IF RETURN-CODE NOT EQUAL ZERO
               DISPLAY 'CBL_READ_VFILE BAD RETURN CODE '
                   RETURN-CODE
                   ' AT RCD '
                   CNTR-RCD-READ
               GO TO 0000-STOP
           END-IF.

           IF REC-RECORD-AREA NOT EQUAL REC-BUFFER
               DISPLAY ' '
               DISPLAY ' CORRUPT RECORD AT ' CNTR-RCD-READ
               DISPLAY 'COMPARE RECORD .... THEN REC-BUFFER IN HEX'
               DISPLAY '-------------------'
               DISPLAY REC-RECORD-AREA  (1:50)
               DISPLAY '-------------------'
               DISPLAY REC-BUFFER       (1:50)
               DISPLAY 'HEX OF '
                   FUNCTION HEX-OF (REC-BUFFER (1:50))
               DISPLAY 'HEX OF '
                   FUNCTION HEX-OF (REC-BUFFER (51:50))
               DISPLAY '-------------------'
               DISPLAY ' '
      *        GO TO 0000-STOP
           END-IF.

       5000-EXIT.  EXIT.


       6000-CLOSE-VFILE-ALL.

           MOVE ZERO                   TO HEAP-ID.

           PERFORM 512 TIMES
               ADD +1                  TO HEAP-ID
               CALL 'CBL_CLOSE_VFILE'
                   USING BY VALUE HEAP-ID
               IF RETURN-CODE NOT EQUAL ZERO
                   DISPLAY 'CBL_CLOSE_VFILE BAD RETURN CODE '
                       RETURN-CODE
                       ' AT HEAP ID '
                       HEAP-ID
                   GO TO 0000-STOP
               END-IF
           END-PERFORM.

       6000-EXIT.  EXIT.


       END PROGRAM VFILE005.
