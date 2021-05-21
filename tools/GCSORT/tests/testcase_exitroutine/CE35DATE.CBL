      **
       IDENTIFICATION DIVISION.
       PROGRAM-ID. CE35DATE.
       ENVIRONMENT DIVISION.
       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01  INSERT-DONE PIC 9(1)      VALUE 0.
       01  K22-REC.
        05 K22-YYYY         PIC 9(4) VALUE 1999.
        05 K22-ID1          PIC X(6) VALUE "BBCCDD".
        05 K22-ID2          PIC 9(4) VALUE 9901.
        05 K22-LATER        PIC X(8) VALUE "E35 9909".
       01  LEAVING-VAR-LEN PIC 9(8) BINARY.
       LINKAGE SECTION.
       01  RECORD-FLAGS       PIC 9(8) BINARY.
           88  FIRST-REC            VALUE 00.
           88  MIDDLE-REC           VALUE 04.
           88  END-REC              VALUE 08.
       01  LEAVING-REC.
        05 LREC-YYYY         PIC 9(4).
        05 LREC-ID1          PIC X(6).
        05 LREC-ID2          PIC 9(4).
        05 LREC-LATER        pic x(8).
       01  RETURN-REC        pic x(22).                   
       01  OUTPUT-REC        pic x(22).
       01  UNUSED1            PIC 9(8) BINARY.
       01  LEAVING-REC-LEN    PIC 9(8) BINARY.
       01  RETURN-REC-LEN     PIC 9(8) BINARY.
       01  OUTPUT-REC-LEN     PIC 9(8) BINARY.
       01  EXITAREA-LEN       PIC 9(4) BINARY.
       01  EXITAREA           pic x(256).
       PROCEDURE DIVISION USING RECORD-FLAGS, LEAVING-REC,
                RETURN-REC, OUTPUT-REC, UNUSED1, LEAVING-REC-LEN,
                RETURN-REC-LEN, OUTPUT-REC-LEN, EXITAREA-LEN,
                EXITAREA.
            display '===================================='
            display ' INSERT-DONE ' INSERT-DONE
            display ' EXITAREA(1:1) '    EXITAREA(1:1)
            display ' Record mod '
            display ' RECORD-FLAGS        ' RECORD-FLAGS
            display ' LEAVING-REC         ' LEAVING-REC
            display ' RETURN-REC          ' RETURN-REC 
            display ' OUTPUT-REC          ' OUTPUT-REC 
            display ' LEAVING-REC-LEN     ' LEAVING-REC-LEN
            display ' RETURN-REC-LEN      ' RETURN-REC-LEN 
            display ' OUTPUT-REC-LEN      ' OUTPUT-REC-LEN        
            display '---------------------------------------------'
      **********     goback.
            IF END-REC
              MOVE 8 TO RETURN-CODE
           ELSE
000000*             IF INSERT-DONE EQUAL TO 1
000000        IF EXITAREA(1:1) = space
                display ' EXITAREA(1:1) = space '
                MOVE 0 TO RETURN-CODE
                move 1 to EXITAREA-LEN 
                move '1' to EXITAREA(1:1)
             ELSE
               SUBTRACT 43 FROM LEAVING-REC-LEN
                  GIVING LEAVING-VAR-LEN
               IF LREC-YYYY GREATER THAN K22-YYYY
                  MOVE 1        TO INSERT-DONE
                  MOVE 43       TO RETURN-REC-LEN
                  MOVE K22-REC  TO RETURN-REC
                  MOVE 12 TO RETURN-CODE
            display '===================================='
                    display ' Record mod '
                    display 'RETURN-REC ' RETURN-REC
            display '===================================='
               ELSE
                 MOVE 0 TO RETURN-CODE
               END-IF
             END-IF
             
           .
           GOBACK.