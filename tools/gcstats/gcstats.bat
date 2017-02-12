       IDENTIFICATION DIVISION.
       PROGRAM-ID.    GCSTATS.
      ************************************************************
      * Written 2017 by Ron Norman (rjn@inglenet.com)
      * 
      * This program is for reading the File I/O statistics file
      * created by GnuCOBOL and summarizing the data into a report
      ************************************************************
       ENVIRONMENT DIVISION.
       CONFIGURATION SECTION.

       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT STATSFILE ASSIGN TO INP-FILE
             ORGANIZATION LINE SEQUENTIAL
             FILE STATUS IS INP-STAT.

           SELECT RPT-FILE ASSIGN TO LINE ADVANCING OUT-FILE.

           SELECT SORTSTATS ASSIGN TO EXTERNAL SORTFILE.

       DATA  DIVISION.
       FILE SECTION.
       FD  RPT-FILE
           REPORTS ARE PROG-FILE, SUM-BY-TIME.

       FD  STATSFILE
           BLOCK CONTAINS 5 RECORDS.

       01  STATS-RECORD.
           10  STATS-DATA         PICTURE X(256).

       SD  SORTSTATS.

       01  STATS-FIX.
      ****  Time that information was recorded
           05  ST-TOD.
             10  ST-DATE.
               15  ST-YEAR        PIC 9(4).
               15  FILLER         PIC X.
               15  ST-MONTH       PIC 9(2).
               15  FILLER         PIC X.
               15  ST-DAY         PIC 9(2).
             10  FILLER           PIC X.
             10  ST-TIME.
               15  ST-HOUR        PIC 9(2).
               15  FILLER         PIC X.
               15  ST-MIN         PIC 9(2).
               15  FILLER         PIC X.
               15  ST-SEC         PIC 9(2).
      ****  Source file name
           05  ST-SOURCE          PIC X(30).
      ****  SELECT/FD Name of file
           05  ST-FILE            PIC X(30).

           05  ST-IO-COUNTS.
      ****  Counts of I/O requests
             10  ST-START         PIC 9(9).
             10  ST-READ-SEQ      PIC 9(9).
             10  ST-READ          PIC 9(9).
             10  ST-WRITE         PIC 9(9).
             10  ST-REWRITE       PIC 9(9).
             10  ST-DELETE        PIC 9(9).
      ****  Counts of I/O requests that had bad status
      ****  The 'bad status' counts are include ing I/O request counts
             10  ST-X-START       PIC 9(9).
             10  ST-X-READ-SEQ    PIC 9(9).
             10  ST-X-READ        PIC 9(9).
             10  ST-X-WRITE       PIC 9(9).
             10  ST-X-REWRITE     PIC 9(9).
             10  ST-X-DELETE      PIC 9(9).
           05  FILLER REDEFINES ST-IO-COUNTS.
             10  ST-COUNT         PIC 9(9) OCCURS 12 TIMES.

       WORKING-STORAGE SECTION.

       77  INP-STAT           PIC X(2)   VALUE "00".
       77  INP-FILE           PIC X(256) VALUE "tststats.txt".
       77  INP-PTR            PIC 999    VALUE 1.
       77  IDX1               PIC 9(4)   COMP-4.
       77  OUT-FILE           PIC X(256) VALUE "stats-report.txt".
       77  BGN-TOD            PIC X(19)  VALUE "9999/99/99 99:99:99".
       77  END-TOD            PIC X(19)  VALUE "0000/00/00 00:00:00".
       77  PRV-SOURCE         PIC X(30)  VALUE SPACES.
       77  PRV-HOUR           PIC 9(2)   VALUE 0.
       77  PRV-DATE           PIC X(12)  VALUE SPACE.
       77  PRV-IO             PIC 9(10)  COMP-4 VALUE 0.
       77  MAX-SOURCE         PIC X(30)  VALUE SPACES.
       77  MAX-IO             PIC 9(10)  COMP-4 VALUE 0.

       01  LO.
            05 OPTIONRECORD OCCURS 4 TIMES.
                10 ONAME        PIC X(25).
                10 HAS-VALUE    PIC 9.
                10 VALPOINT     POINTER     VALUE NULL.
                10 VAL          PIC X(4).

       01  SO                 PIC X(8).
       01  LONGIND            PIC 99.
       01  LONG-ONLY          PIC 9  VALUE 1.
       01  RETURN-CHAR        PIC X(4) VALUE SPACES.
       01  OPT-VAL            PIC X(256) VALUE SPACES.
       01  RET-DISP           PIC S9 VALUE 0.
       01  COUNTER            PIC 9  VALUE 0.

       77  MAX-SHOW           PIC 9(4) COMP-4 VALUE 32.
       77  NUM-SHOW           PIC 9(4) COMP-4 VALUE 0.
       01  SHOW-PROG          PIC X(30) OCCURS 32 TIMES.

       77  MAX-EXCLUDE        PIC 9(4) COMP-4 VALUE 32.
       77  NUM-EXCLUDE        PIC 9(4) COMP-4 VALUE 0.
       01  EXCLUDE-PROG       PIC X(30) OCCURS 32 TIMES.

       REPORT SECTION.
       RD PROG-FILE
          CONTROLS ARE FINAL ST-SOURCE ST-FILE
          PAGE LIMIT IS 66 LINES
          HEADING 1   FIRST DETAIL 5
          LAST DETAIL 64.

       01  TYPE PAGE HEADING.
         02  LINE 1.
            03  COLUMN 2   PIC X(60) 
                VALUE "GnuCOBOL I/O Summary by Program/File".
            03  COLUMN 70  PIC X(4) VALUE "Page".
            03  COLUMN +1  PIC ZZZ9 SOURCE PAGE-COUNTER.
         02  LINE 2.
            03  COLUMN 6   PIC X(4) VALUE "From".
            03  COLUMN +1  PIC X(19) SOURCE BGN-TOD.
            03  COLUMN +1  PIC X(4) VALUE "thru".
            03  COLUMN +1  PIC X(19) SOURCE END-TOD.
            03  COLUMN 103 PIC X(17) VALUE "  --- Totals ---".
         02  LINE PLUS 1.
            03  COLUMN 33  PIC X(10) VALUE "      Read".
            03  COLUMN +1  PIC X(10) VALUE "     Write".
            03  COLUMN +1  PIC X(10) VALUE "   ReWrite".
            03  COLUMN +1  PIC X(10) VALUE "    Delete".
            03  COLUMN +1  PIC X(10) VALUE "     Start".
            03  COLUMN +1  PIC X(10) VALUE "  Read-Seq".
            03  COLUMN +2  PIC X(11) VALUE "        I/O".
            03  COLUMN +1  PIC X(9)  VALUE "   Errors".

       01  PROG-HEAD TYPE CONTROL HEADING ST-SOURCE.
         02  LINE PLUS 1.
            03  COLUMN 1   PIC X(8) VALUE " Source:".
            03  COLUMN +1  PIC X(20) SOURCE ST-SOURCE.

       01  PROG-FOOT TYPE CONTROL FOOTING ST-SOURCE
           NEXT GROUP +1.
         02  LINE PLUS 1.
            03  COLUMN 33  PIC X(10) VALUE "   -------".
            03  COLUMN +1  PIC X(10) VALUE "   -------".
            03  COLUMN +1  PIC X(10) VALUE "   -------".
            03  COLUMN +1  PIC X(10) VALUE "   -------".
            03  COLUMN +1  PIC X(10) VALUE "   -------".
            03  COLUMN +1  PIC X(10) VALUE "   -------".
            03  COLUMN +2  PIC X(11) VALUE "    -------".
            03  COLUMN +1  PIC X(9)  VALUE "  -------".

         02  LINE PLUS 1.
            03  COLUMN 1   PIC X(8) VALUE " Totals:".
            03  COLUMN +1  PIC X(18) SOURCE ST-SOURCE.
            03  COLUMN 33  PIC ZZZZZZZZZ9 SUM ST-READ.
            03  COLUMN +1  PIC ZZZZZZZZZ9 SUM ST-WRITE.
            03  COLUMN +1  PIC ZZZZZZZZZ9 SUM ST-REWRITE.
            03  COLUMN +1  PIC ZZZZZZZZZ9 SUM ST-DELETE.
            03  COLUMN +1  PIC ZZZZZZZZZ9 SUM ST-START.
            03  COLUMN +1  PIC ZZZZZZZZZ9 SUM ST-READ-SEQ.
            03  COLUMN +2  PIC ZZZZZZZZZZ9 
                 SUM ST-START ST-READ-SEQ ST-READ    
                     ST-WRITE ST-REWRITE  ST-DELETE.
            03  COLUMN +1  PIC ZZZZZZZZ9 
                 SUM ST-X-START ST-X-READ-SEQ ST-X-READ    
                     ST-X-WRITE ST-X-REWRITE  ST-X-DELETE.

       01  FILE-FOOT TYPE CONTROL FOOTING ST-FILE.
         02  LINE PLUS 1.
            03  COLUMN 2   PIC X(8) VALUE "   File:".
            03  COLUMN +2  PIC X(18) SOURCE ST-FILE.
            03  COLUMN 33  PIC ZZZZZZZZZ9 SUM ST-READ.
            03  COLUMN +1  PIC ZZZZZZZZZ9 SUM ST-WRITE.
            03  COLUMN +1  PIC ZZZZZZZZZ9 SUM ST-REWRITE.
            03  COLUMN +1  PIC ZZZZZZZZZ9 SUM ST-DELETE.
            03  COLUMN +1  PIC ZZZZZZZZZ9 SUM ST-START.
            03  COLUMN +1  PIC ZZZZZZZZZ9 SUM ST-READ-SEQ.
            03  COLUMN +2  PIC ZZZZZZZZZZ9 
                 SUM ST-START ST-READ-SEQ ST-READ    
                     ST-WRITE ST-REWRITE  ST-DELETE.
            03  COLUMN +1  PIC ZZZZZZZZ9 
                 SUM ST-X-START ST-X-READ-SEQ ST-X-READ    
                     ST-X-WRITE ST-X-REWRITE  ST-X-DELETE.

       01  FINAL-FOOT TYPE CONTROL FOOTING FINAL.
         02  LINE PLUS 2.
            03  COLUMN 33  PIC X(10) VALUE "  ========".
            03  COLUMN +1  PIC X(10) VALUE "  ========".
            03  COLUMN +1  PIC X(10) VALUE "  ========".
            03  COLUMN +1  PIC X(10) VALUE "  ========".
            03  COLUMN +1  PIC X(10) VALUE "  ========".
            03  COLUMN +1  PIC X(10) VALUE "  ========".
            03  COLUMN +2  PIC X(11) VALUE "   ========".
            03  COLUMN +1  PIC X(9)  VALUE "   ======".
         02  LINE PLUS 1.
            03  COLUMN 1   PIC X(13) VALUE "Grand Total:".
            03  COLUMN 33  PIC ZZZZZZZZZ9 SUM ST-READ.
            03  COLUMN +1  PIC ZZZZZZZZZ9 SUM ST-WRITE.
            03  COLUMN +1  PIC ZZZZZZZZZ9 SUM ST-REWRITE.
            03  COLUMN +1  PIC ZZZZZZZZZ9 SUM ST-DELETE.
            03  COLUMN +1  PIC ZZZZZZZZZ9 SUM ST-START.
            03  COLUMN +1  PIC ZZZZZZZZZ9 SUM ST-READ-SEQ.
            03  COLUMN +2  PIC ZZZZZZZZZZ9 
                 SUM ST-START ST-READ-SEQ ST-READ    
                     ST-WRITE ST-REWRITE  ST-DELETE.
            03  COLUMN +1  PIC ZZZZZZZZ9 
                 SUM ST-X-START ST-X-READ-SEQ ST-X-READ    
                     ST-X-WRITE ST-X-REWRITE  ST-X-DELETE.

       RD SUM-BY-TIME
          CONTROLS ARE FINAL ST-DATE  ST-HOUR
          PAGE LIMIT IS 66 LINES
          HEADING 1   FIRST DETAIL 5
          LAST DETAIL 64.

       01  TYPE PAGE HEADING.
         02  LINE 1.
            03  COLUMN 2   PIC X(60) 
                VALUE "GnuCOBOL I/O Summary by Hour of the Day".
            03  COLUMN 70  PIC X(4) VALUE "Page".
            03  COLUMN +1  PIC ZZZ9 SOURCE PAGE-COUNTER.
         02  LINE 2.
            03  COLUMN 6   PIC X(4) VALUE "From".
            03  COLUMN +1  PIC X(19) SOURCE BGN-TOD.
            03  COLUMN +1  PIC X(4) VALUE "thru".
            03  COLUMN +1  PIC X(19) SOURCE END-TOD.
         02  LINE PLUS 1.
            03  COLUMN 25  PIC X(11) VALUE "      Reads".
            03  COLUMN +1  PIC X(11) VALUE "    Updates".
            03  COLUMN +1  PIC X(9)  VALUE "   Errors".
            03  COLUMN +4  PIC X(20) VALUE "Most I/O in Hour".
            03  COLUMN +1  PIC X(10) VALUE "      I/O".

       01  DATE-HEAD TYPE CONTROL HEADING ST-DATE.
         02  LINE PLUS 1.
            03  COLUMN 1   PIC X(8) VALUE "   Date:".
            03  COLUMN +1  PIC X(12) SOURCE ST-DATE.

       01  DATE-FOOT TYPE CONTROL FOOTING ST-DATE
           NEXT GROUP +1.
         02  LINE PLUS 1.
            03  COLUMN 25  PIC X(11) VALUE "    -------".
            03  COLUMN +1  PIC X(11) VALUE "    -------".
            03  COLUMN +1  PIC X(9)  VALUE "  -------".

         02  LINE PLUS 1.
            03  COLUMN 1   PIC X(8) VALUE " Totals:".
            03  COLUMN +1  PIC X(18) SOURCE ST-DATE.
            03  COLUMN 25  PIC ZZZZZZZZZZ9 
                 SUM ST-START ST-READ-SEQ ST-READ.
            03  COLUMN +1  PIC ZZZZZZZZZZ9 
                 SUM ST-WRITE ST-REWRITE  ST-DELETE.
            03  COLUMN +1  PIC ZZZZZZZZ9 
                 SUM ST-X-START ST-X-READ-SEQ ST-X-READ    
                     ST-X-WRITE ST-X-REWRITE  ST-X-DELETE.

       01  HOUR-FOOT TYPE CONTROL FOOTING ST-HOUR.
         02  LINE PLUS 1.
            03  COLUMN 2   PIC X(8) VALUE "   Hour:".
            03  COLUMN +2  PIC X(5) SOURCE ST-HOUR.
            03  COLUMN 25  PIC ZZZZZZZZZZ9 
                 SUM ST-START ST-READ-SEQ ST-READ.
            03  COLUMN +1  PIC ZZZZZZZZZZ9 
                 SUM ST-WRITE ST-REWRITE  ST-DELETE.
            03  COLUMN +1  PIC ZZZZZZZZ9 
                 SUM ST-X-START ST-X-READ-SEQ ST-X-READ    
                     ST-X-WRITE ST-X-REWRITE  ST-X-DELETE.
            03  COLUMN +4  PIC X(20) SOURCE MAX-SOURCE.
            03  COLUMN +1  PIC ZZZZZZZZ9 SOURCE MAX-IO.

       01  TYPE CONTROL FOOTING FINAL.
         02  LINE PLUS 2.
            03  COLUMN 25  PIC X(11) VALUE "   ========".
            03  COLUMN +1  PIC X(11) VALUE "   ========".
            03  COLUMN +1  PIC X(9)  VALUE "   ======".
         02  LINE PLUS 1.
            03  COLUMN 1   PIC X(13) VALUE "Grand Total:".
            03  COLUMN 25  PIC ZZZZZZZZZZ9 
                 SUM ST-START ST-READ-SEQ ST-READ.
            03  COLUMN +1  PIC ZZZZZZZZZZ9 
                 SUM ST-WRITE ST-REWRITE  ST-DELETE.
            03  COLUMN +1  PIC ZZZZZZZZ9 
                 SUM ST-X-START ST-X-READ-SEQ ST-X-READ    
                     ST-X-WRITE ST-X-REWRITE  ST-X-DELETE.

       PROCEDURE DIVISION.

           MOVE "V"       TO SO.
           MOVE "input"   TO ONAME     (1).
           MOVE 1         TO HAS-VALUE (1).
           MOVE "i"       TO VAL       (1).
           
           MOVE "output"  TO ONAME     (2).
           MOVE 1         TO HAS-VALUE (2).
           MOVE "o"       TO VAL       (2).

           MOVE "exclude" TO ONAME     (3).
           MOVE 1         TO HAS-VALUE (3).
           MOVE "x"       TO VAL       (3).

           MOVE "show"    TO ONAME     (4).
           MOVE 1         TO HAS-VALUE (4).
           MOVE "s"       TO VAL       (4).
        
           PERFORM WITH TEST AFTER
                   VARYING COUNTER FROM 0 BY 1
                   UNTIL RETURN-CODE = -1
              CALL 'CBL_OC_GETOPT' USING 
                 BY REFERENCE SO LO LONGIND
                 BY VALUE     LONG-ONLY
                 BY REFERENCE RETURN-CHAR OPT-VAL
              END-CALL
           
              EVALUATE RETURN-CHAR
              WHEN  'i'
                 MOVE OPT-VAL   TO INP-FILE
              WHEN  'o'
                 MOVE OPT-VAL   TO OUT-FILE
              WHEN  's'
                 IF NUM-SHOW < MAX-SHOW
                     ADD 1 TO NUM-SHOW
                     INSPECT OPT-VAL REPLACING ALL LOW-VALUES by SPACES
                     MOVE OPT-VAL   TO SHOW-PROG (NUM-SHOW)
                 END-IF
              WHEN  'x'
                 IF NUM-EXCLUDE < MAX-EXCLUDE
                     ADD 1 TO NUM-EXCLUDE
                     INSPECT OPT-VAL REPLACING ALL LOW-VALUES by SPACES
                     MOVE OPT-VAL   TO EXCLUDE-PROG (NUM-EXCLUDE)
                 END-IF
              WHEN  'V'
                 DISPLAY "(c) 2017, Written by Ron Norman"
                 DISPLAY "gcstats is distributed in the hope that it"
                 DISPLAY "will be useful but WITHOUT ANY WARRANTY"
                 DISPLAY "You are free to make changes as you wish"
                 STOP RUN
              END-EVALUATE
           END-PERFORM.

           IF  NUM-SHOW > 0
           AND NUM-EXCLUDE > 0
               DISPLAY "Do not use both -show and -exclude"
               STOP RUN
           END-IF.
           DISPLAY "Read from " INP-FILE (1:64).
           DISPLAY "Report to " OUT-FILE (1:64).

           OPEN INPUT STATSFILE.
           IF INP-STAT NOT = "00"
               DISPLAY "Error " INP-STAT " opening input "
                       INP-FILE (1:64)
               STOP RUN
           END-IF.
           OPEN OUTPUT RPT-FILE.
           INITIATE PROG-FILE.
           SORT SORTSTATS
               ASCENDING KEY ST-SOURCE, ST-FILE, ST-TOD
               INPUT PROCEDURE  GET-STATS-SORT
               OUTPUT PROCEDURE PUT-STATS-SORT.
           TERMINATE PROG-FILE.
           CLOSE STATSFILE.

           OPEN INPUT STATSFILE.
           INITIATE SUM-BY-TIME.
           SORT SORTSTATS
               ASCENDING KEY ST-TOD, ST-SOURCE, ST-FILE
               INPUT PROCEDURE  GET-STATS-SORT
               OUTPUT PROCEDURE PUT-TIME-SORT.
           CLOSE STATSFILE.
           TERMINATE SUM-BY-TIME.
           CLOSE RPT-FILE.
           STOP RUN.

       GET-STATS-SORT SECTION.
           PERFORM READ-STATSFILE.
           PERFORM UNTIL INP-STAT NOT = "00"
              RELEASE STATS-FIX
              PERFORM READ-STATSFILE
           END-PERFORM.

       PUT-STATS-SORT SECTION.
       100-PUT-SORT.
           RETURN SORTSTATS AT END GO TO EXIT-PUT-SORT.

           GENERATE PROG-FILE.
           GO TO 100-PUT-SORT.

       EXIT-PUT-SORT.
           EXIT.

       PUT-TIME-SORT SECTION.
       100-PUT-SORT.
           RETURN SORTSTATS AT END GO TO EXIT-PUT-SORT.

           IF PRV-SOURCE = SPACES
               MOVE ZERO      TO PRV-IO     MAX-IO
               MOVE ST-SOURCE TO PRV-SOURCE MAX-SOURCE
               MOVE ST-DATE   TO PRV-DATE
           ELSE IF PRV-SOURCE NOT = ST-SOURCE
               IF PRV-IO > MAX-IO
                   MOVE PRV-IO     TO MAX-IO
                   MOVE ST-SOURCE  TO MAX-SOURCE
                   MOVE ZERO       TO PRV-IO
               END-IF
           END-IF.
           ADD ST-START ST-READ-SEQ ST-READ    
               ST-WRITE ST-REWRITE  ST-DELETE TO PRV-IO.
           MOVE ST-SOURCE    TO PRV-SOURCE.

           GENERATE SUM-BY-TIME.

           IF PRV-HOUR NOT = ST-HOUR
           OR PRV-DATE NOT = ST-DATE
           OR PRV-IO > MAX-IO
               MOVE PRV-IO     TO MAX-IO
               MOVE ST-SOURCE  TO MAX-SOURCE
               MOVE ZERO       TO PRV-IO
               MOVE ST-DATE    TO PRV-DATE
               MOVE ST-HOUR    TO PRV-HOUR
           END-IF.
           GO TO 100-PUT-SORT.

       EXIT-PUT-SORT.
           EXIT.

       READ-STATSFILE SECTION.
       100-READ-STATSFILE.
           READ STATSFILE.
           IF INP-STAT NOT = "00"
             GO TO EXIT-READ-STATSFILE.

           INITIALIZE STATS-FIX.
           MOVE 1 TO INP-PTR.
           UNSTRING STATS-DATA DELIMITED BY ", " OR "," INTO
             ST-TOD ST-SOURCE ST-FILE
           WITH POINTER INP-PTR
           END-UNSTRING.
           IF FUNCTION TRIM(ST-TOD) = "Time"
               GO TO 100-READ-STATSFILE.

      * Check if this module is to be included
           IF NUM-SHOW > 0
               PERFORM VARYING IDX1 FROM 1 BY 1
                         UNTIL IDX1 > NUM-SHOW
                   IF ST-SOURCE = SHOW-PROG (IDX1)
                       GO TO 200-READ-STATSFILE
                   END-IF
               END-PERFORM
               GO TO 100-READ-STATSFILE
           END-IF.

      * Check if this module is to be excluded
           IF NUM-EXCLUDE > 0
               PERFORM VARYING IDX1 FROM 1 BY 1
                         UNTIL IDX1 > NUM-EXCLUDE
                   IF ST-SOURCE = EXCLUDE-PROG (IDX1)
                       GO TO 100-READ-STATSFILE
                   END-IF
               END-PERFORM
           END-IF.

       200-READ-STATSFILE.

           UNSTRING STATS-DATA 
            DELIMITED BY ", " OR "," OR "      " INTO 
              ST-START ST-READ-SEQ ST-READ ST-WRITE 
              ST-REWRITE ST-DELETE
              ST-X-START ST-X-READ-SEQ ST-X-READ ST-X-WRITE
              ST-X-REWRITE ST-X-DELETE
            WITH POINTER INP-PTR
           END-UNSTRING.
           IF ST-TOD < BGN-TOD
               MOVE ST-TOD TO BGN-TOD.
           IF ST-TOD > END-TOD
               MOVE ST-TOD TO END-TOD.
  
       EXIT-READ-STATSFILE.
           EXIT.
