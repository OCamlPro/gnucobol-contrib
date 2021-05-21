      * https://www.ibm.com/docs/en/zos/2.1.0?topic=cobol-e15-user-exit-altering-records
      * shows an example of a COBOL E15 routine for a data set 
      * with fixed-length records of 100 bytes. It examines 
      * the department field in the passed record and takes 
      * the following action:
      * If the department is D29, it changes it to J99.
      * If the department is not D29, it accepts the record unchanged.
       IDENTIFICATION DIVISION.
       PROGRAM-ID.
           CE15DATE.
       ENVIRONMENT DIVISION.
       DATA DIVISION.
       LINKAGE SECTION.
       01  RECORD-FLAGS       PIC 9(8) BINARY.
           88  FIRST-REC            VALUE 00.
           88  MIDDLE-REC           VALUE 04.
           88  END-REC              VALUE 08.
       01  NEW-REC.
        05 NFILL1             PIC 9(4).
        05 NEW-VALUE          PIC X(6).
        05 NFILL2             PIC X(12).
       01  RETURN-REC.
        05 RFILL1             PIC 9(4).
        05 RETURN-VALUE       PIC X(6).
        05 RFILL2             PIC X(12).
       
       PROCEDURE DIVISION USING RECORD-FLAGS, NEW-REC, RETURN-REC.
       
            display 'RECORD-FLAGS - NEW-VALUE '
                     RECORD-FLAGS ' - ' NEW-VALUE
       
           IF END-REC
              MOVE 8 TO RETURN-CODE
           ELSE
             IF NEW-VALUE EQUAL TO "KKMMBB"
                MOVE NEW-REC    TO RETURN-REC
                MOVE "MODREC"   TO RETURN-VALUE
                MOVE 20 TO RETURN-CODE
             ELSE
              IF NEW-VALUE EQUAL TO "ZZBBCC"
                 MOVE NEW-REC    TO RETURN-REC
                 MOVE 1977       TO RFILL1
                 MOVE "NEWREC"   TO RETURN-VALUE
                 MOVE "7705NEWR7703"       TO RFILL2
                 MOVE 12 TO RETURN-CODE
                 display 'new RETURN-CODE - RETURN-VALUE '
                 RETURN-CODE ' - ' RETURN-VALUE                 
               ELSE
                 MOVE 0 TO RETURN-CODE
               END-IF
             END-IF
           END-IF
       
           GOBACK.
           
           