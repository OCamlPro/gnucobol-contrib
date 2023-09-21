       @OPTIONS MAIN(MAIN)
       @OPTIONS DLOAD
       IDENTIFICATION DIVISION.
       PROGRAM-ID. VFILE001.
       ENVIRONMENT DIVISION.
       CONFIGURATION SECTION.
      *SOURCE-COMPUTER. IBM-PC  WITH DEBUGGING MODE.
       OBJECT-COMPUTER. IBM-PC.
       SPECIAL-NAMES.
           ENVIRONMENT-NAME  IS ENVIRONMENT-NAME
           ENVIRONMENT-VALUE IS ENVIRONMENT-VALUE.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
       DATA DIVISION.
       WORKING-STORAGE SECTION.


       01  HEAP-ID                    PIC 9(4) COMP-5.
       01  RELATIVE-ADDRESS-IN-HEAP   PIC 9(9) COMP-5.
       01  DATA-LENGTH                PIC 9(9) COMP-5.
       01  HEAP-STATUS                PIC X(2).
       01  STATUS-CODE                PIC S9(4) COMP-5.

       01  PTR-HEAP                        USAGE POINTER.

       01  CNTR-COUNTERS     USAGE COMP-4.
           05  CNTR-HEAP                   PIC S9(8)   VALUE +0.
           05  CNTR-RCD-WRITTEN            PIC S9(8)   VALUE +0.
           05  CNTR-RCD-READ               PIC S9(8)   VALUE +0.
           05  CNTR-RCD-LENGTH             PIC S9(8)   VALUE +0.
           05  CNTR-RELATVIE-POS           PIC S9(8)   VALUE +0.

       01  TMP.
           05  TMP-MILLISECONDS            PIC S9(8) COMP-5  VALUE +0.
           05  TMP-NBR                     PIC S9(8) COMP-4  VALUE +0.
           05  TMP-DISPLAY                 PIC ZZZ,ZZZ,ZZ9.
           05  TMP-KB                      PIC X(8).

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
           05  MEM-LENGTH                  PIC S9(8) COMP-5  VALUE +0.
           05  MEM-PAGEFAULTCOUNT          PIC S9(8) COMP-5  VALUE +0.
           05  MEM-PEAKWORKINGSETSIZE      PIC S9(8) COMP-5  VALUE +0.
           05  MEM-WORKINGSETSIZE          PIC S9(8) COMP-5  VALUE +0.
           05  MEM-QUOTAPEAKPAGEDPOOL      PIC S9(8) COMP-5  VALUE +0.
           05  MEM-QUOTAPAGEDPOOL          PIC S9(8) COMP-5  VALUE +0.
           05  MEM-QUOTAPEAKNONPAGEDPOOL   PIC S9(8) COMP-5  VALUE +0.
           05  MEM-QUOTANONPAGEDPOOL       PIC S9(8) COMP-5  VALUE +0.
           05  MEM-PAGEFILE                PIC S9(8) COMP-5  VALUE +0.
           05  MEM-PEAKPAGEFILE            PIC S9(8) COMP-5  VALUE +0.

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
               10  HEAP-HEAP-ID            PIC S9(4) COMP-4  VALUE +0.
               10  HEAP-PTR-SEG-FIRST      POINTER.
               10  HEAP-PTR-SEG-LAST       POINTER.
               10  HEAP-SEG-COUNT          PIC S9(8) COMP-4  VALUE +0.
               10  HEAP-TOTAL-ALLOC        PIC S9(8) COMP-4  VALUE +0.
               10  HEAP-TOTAL-DATA-ALLOC   PIC S9(8) COMP-4  VALUE +0.

       01  SEG-SEGMENT-AREA.
           05  SEG-EYE-BALL                PIC X(10).
           05  SEG-HEAP-ID                 PIC S9(4) COMP-4.
           05  SEG-PTR-PREV-SEGST          POINTER.
           05  SEG-PTR-NEXT-SEGT           POINTER.
           05  SEG-SEG-NUM                 PIC  9(8) COMP-4.
           05  SEG-SEG-SIZE                PIC  9(8) COMP-4.
           05  SEG-SEG-DATA-SIZE           PIC  9(8) COMP-4.
           05  SEG-SEG-DATA-REL-START      PIC  9(8) COMP-4.
           05  SEG-SEG-DATA-REL-END        PIC  9(8) COMP-4.
           05  SEG-DATA                    PIC X(512000).

       PROCEDURE DIVISION.

       0000-MAINLINE.

      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *                                                               *
      *    THE FOLLOWING CALL IS USE TO RESOLVE ALL THE ENTRY         *
      *    POINTS IN THE CBL_VFILES.DLL                               *
      *                                                               *
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

      *    DISPLAY 'COB_PRE_LOAD'          UPON ENVIRONMENT-NAME.
      *    DISPLAY 'CWH-VFILES;CWH-ROUTINES;KERNEL32,CBL_SCREENIO'
      *                                    UPON ENVIRONMENT-VALUE.
      *    ACCEPT ENV-TEXT                 FROM ENVIRONMENT-VALUE.
      *    DISPLAY 'COB_PRE_LOAD=' ENV-TEXT.

      *    DISPLAY '  ENTER MEMORY ALLOCATION IN KB '.
      *    ACCEPT TMP-KB.
      *    MOVE 128                    TO TMP-KB.
           DISPLAY 'AFTER ACCEPT OF MEMORY ALLOCATION'.

           DISPLAY 'CBL_DIAGNOSTIC'        UPON ENVIRONMENT-NAME.
           DISPLAY  'ON'                   UPON ENVIRONMENT-VALUE.

           DISPLAY 'CBL_MEM_ALLOC_KB'      UPON ENVIRONMENT-NAME.
           DISPLAY  '128'                  UPON ENVIRONMENT-VALUE.

           DISPLAY 'CBL_MEM_ALLOC_INIT'    UPON ENVIRONMENT-NAME.
           DISPLAY  'ON'                   UPON ENVIRONMENT-VALUE.

           DISPLAY 'AFTER SETTING ENVIRONMENT VARIABLES'.

           DISPLAY 'BEFORE CALLING CWH_VFILES'.
           CALL 'CWH_VFILES'.
           DISPLAY ' AFTER CALLING CWH_VFILES'.

           CALL 'CWH_START_TIME'.
           DISPLAY 'AFTER CALLING START TIME'.

           PERFORM 1000-MEMORY-USAGE THRU 1000-EXIT.
           MOVE ZERO                   TO CNTR-HEAP.

           PERFORM WITH TEST AFTER
               UNTIL CNTR-HEAP > 50
                  OR RETURN-CODE NOT EQUAL ZERO
                   ADD +1              TO CNTR-HEAP
                   PERFORM 2000-OPEN-VFILE THRU 2000-EXIT
           END-PERFORM.

           CALL 'CWH_TIME_DIFF' USING TMP-MILLISECONDS.
           DISPLAY ' TIME TO OPEN 512 VFILES IS                  '
               TMP-MILLISECONDS
               ' MILLISECONDS'.

           PERFORM 1000-MEMORY-USAGE THRU 1000-EXIT.
      D    PERFORM 3000-PRINT-HEAP THRU 3000-EXIT.

           MOVE +22                    TO CNTR-HEAP.
           MOVE +1                     TO RELATIVE-ADDRESS-IN-HEAP.
           MOVE LENGTH OF REC-RECORD-AREA
                                       TO DATA-LENGTH.
           MOVE SPACES                 TO HEAP-STATUS.
      D    DISPLAY ' LENGTH OF DATA RECORD IS ' DATA-LENGTH.

           MOVE ZERO                   TO CNTR-RCD-WRITTEN.

           CALL 'CWH_START_TIME'.

           PERFORM 1000     TIMES
               ADD +1                  TO CNTR-RCD-WRITTEN
               PERFORM 4000-WRITE-VFILE THRU 4000-EXIT
           END-PERFORM.

           CALL 'CWH_TIME_DIFF' USING TMP-MILLISECONDS.
           DISPLAY ' TIME TO WRITE 100,000 RECORDS TO VFILE 22 IS '
               TMP-MILLISECONDS
               ' MILLISECONDS'.

           MOVE ZERO                   TO CNTR-RCD-READ.

           CALL 'CWH_START_TIME'.

           PERFORM 1000     TIMES
               ADD +1                  TO CNTR-RCD-READ
               PERFORM 5000-READ-VFILE THRU 5000-EXIT
           END-PERFORM.

           CALL 'CWH_TIME_DIFF' USING TMP-MILLISECONDS.
           DISPLAY ' TIME TO READ  100,000 RECORDS TO VFILE 22 IS '
               TMP-MILLISECONDS
               ' MILLISECONDS'.

      D    PERFORM 3100-PRINT-HEAP-ENTRY THRU 3100-EXIT.

           PERFORM 1000-MEMORY-USAGE THRU 1000-EXIT.

           CALL 'CWH_START_TIME'.

           PERFORM 6000-CLOSE-VFILE-ALL THRU 6000-EXIT

           CALL 'CWH_TIME_DIFF' USING TMP-MILLISECONDS.
           DISPLAY ' TIME TO CLOSE 512 VFILES IS                  '
               TMP-MILLISECONDS
               ' MILLISECONDS'.
           PERFORM 1000-MEMORY-USAGE THRU 1000-EXIT.

       0000-STOP.

           STOP RUN.

       0000-EXIT.  EXIT.


       1000-MEMORY-USAGE.

           DISPLAY 'LENGTH OF MEM-MEMORY-STATUS IS '
                    LENGTH OF MEM-MEMORY-STATUS.
      *    MOVE LENGTH OF MEM-MEMORY-STATUS    TO MEM-LENGTH.
           CALL 'CWH_MEMORY_STATUS'  USING MEM-MEMORY-STATUS.

      D    DISPLAY ' '.
      D    DISPLAY ' CONTENTS OF MEMORY STATUS ...'.
      D    DISPLAY ' '.

       1000-EXIT.  EXIT.


       2000-OPEN-VFILE.

           CALL 'CWH_OPEN_VFILE' USING HEAP-ID
                                       HEAP-STATUS.

           IF RETURN-CODE NOT EQUAL ZERO
               DISPLAY 'CBL_OPEN_VFILE FAILED AT HEAP-ID ==> '
                   CNTR-HEAP.

      D    DISPLAY ' HEAP-ID IS ==> ' HEAP-ID.

       2000-EXIT.  EXIT.


       3000-PRINT-HEAP.

           CALL 'CWH_GET_HEAP_POINTER' USING PTR-HEAP.

           IF PTR-HEAP = NULL
               DISPLAY 'CBL_GET_HEAP_POINTER RETURNED NULL'
               GO TO 0000-STOP
           END-IF.

           SET ADDRESS OF HEAP-ARRAY   TO PTR-HEAP.
           MOVE ZERO                   TO CNTR-HEAP.

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

           DISPLAY ' HEAP ID '
               HEAP-HEAP-ID           (CNTR-HEAP) '  '
               HEAP-PTR-SEG-FIRST     (CNTR-HEAP) '  '
               HEAP-PTR-SEG-LAST      (CNTR-HEAP) '  '
               HEAP-SEG-COUNT         (CNTR-HEAP) '  '
               HEAP-TOTAL-ALLOC       (CNTR-HEAP) '  '
               HEAP-TOTAL-DATA-ALLOC  (CNTR-HEAP).

       3100-EXIT.  EXIT.


       4000-WRITE-VFILE.

           COMPUTE RELATIVE-ADDRESS-IN-HEAP
               = ((CNTR-RCD-WRITTEN - 1) * DATA-LENGTH) + 1
           END-COMPUTE.

           MOVE CNTR-HEAP              TO HEAP-ID.
           MOVE SPACES                 TO HEAP-STATUS.
           MOVE CNTR-HEAP              TO REC-HEAP-ID.
           MOVE CNTR-RCD-WRITTEN       TO REC-RCD-COUNT.

      D    IF  CNTR-RCD-WRITTEN >= 1305
      D    AND CNTR-RCD-WRITTEN <= 1329
      D        DISPLAY ' IN CBL_WRITE_VFILE  '
      D            'HEAP ID ' HEAP-ID
      D            ' REL ADDR ' RELATIVE-ADDRESS-IN-HEAP
      D            ' DATA LEN ' DATA-LENGTH
      D    END-IF.

           CALL "CWH_WRITE_VFILE"
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

           MOVE CNTR-HEAP              TO HEAP-ID.
           MOVE SPACES                 TO HEAP-STATUS.
           MOVE CNTR-HEAP              TO REC-HEAP-ID.
           MOVE CNTR-RCD-READ          TO REC-RCD-COUNT.

           CALL "CWH_READ_VFILE"
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
               DISPLAY ' CORRUPT RECORD AT ' CNTR-RCD-READ
               DISPLAY 'BUFFER RECORD / COMPARE RECORD ....'
               DISPLAY REC-BUFFER
               DISPLAY REC-RECORD-AREA
      *        GO TO 0000-STOP
           END-IF.

       5000-EXIT.  EXIT.


       6000-CLOSE-VFILE-ALL.

           MOVE ZERO                   TO HEAP-ID.

           PERFORM 512 TIMES
               ADD +1                  TO HEAP-ID
               CALL 'CWH_CLOSE_VFILE'
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


       END PROGRAM VFILE001.
