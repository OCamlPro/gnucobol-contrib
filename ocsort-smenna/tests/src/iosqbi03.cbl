      *-------------------------------------------------------------------------------*
      * **********************************************************
      *  OCSort Tests
      * **********************************************************
      * Author:    Sauro Menna
      * Date:      20160821
      * License
      *    Copyright 2016 Sauro Menna
      *    GNU Lesser General Public License, LGPL, 3.0 (or greater)
      * Purpose:   Generate COBOL fixed file with COMP fields
      *            For Sumfield
      *            Sort/Merge COBOL Program and OCSort data file
      * **********************************************************
      * option:
      * cobc -x -t ..\listing\%1.lst -I ..\copy -Wall -fbinary-size=1--8 
      *      -fnotrunc -fbinary-byteorder=big-endian -o ..\bin\%1 ..\src\%1.CBL 
      * **********************************************************
      *-------------------------------------------------------------------------------*
	   IDENTIFICATION DIVISION.
       PROGRAM-ID.  IOSQBI03.
       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT MasterSeqFile ASSIGN TO  EXTERNAL sqbi03
               ORGANIZATION IS SEQUENTIAL
               ACCESS MODE  IS SEQUENTIAL.

       DATA DIVISION.
       FILE SECTION.
       FD MasterSeqFile.
       01 MasterSeqRecord.
          05 MSR-02S    PIC S9(2) COMP.
          05 FILLER     PIC X.
          05 MSR-02     PIC 9(2) COMP.
          05 FILLER     PIC X.
          05 MSR-04S    PIC S9(4) COMP.
          05 FILLER     PIC X.
          05 MSR-04     PIC 9(4) COMP.
          05 FILLER     PIC X.
          05 MSR-06S    PIC S9(6) COMP.
          05 FILLER     PIC X.
          05 MSR-06     PIC 9(6) COMP.
          05 FILLER     PIC X.
          05 MSR-08S    PIC S9(8) COMP.
          05 FILLER     PIC X.
          05 MSR-08     PIC 9(8) COMP.
          05 FILLER     PIC X.
          05 MSR-10S    PIC S9(10) COMP.
          05 FILLER     PIC X.
          05 MSR-10     PIC 9(10) COMP.
          05 FILLER     PIC X.
          05 MSR-12S    PIC S9(12) COMP.
          05 FILLER     PIC X.
          05 MSR-12     PIC 9(12) COMP.
          05 FILLER     PIC X.
          05 MSR-14S    PIC S9(14) COMP.
          05 FILLER     PIC X.
          05 MSR-14     PIC 9(14) COMP.
          05 FILLER     PIC X.
          05 MSR-16S    PIC S9(16) COMP.
          05 FILLER     PIC X.
          05 MSR-16     PIC 9(16) COMP.
          05 FILLER     PIC X.
          05 MSR-18S    PIC S9(18) COMP.
          05 FILLER     PIC X.
          05 MSR-18     PIC 9(18) COMP.
          05 FILLER     PIC X.

       WORKING-STORAGE SECTION.
       01 RecordSize			PIC 9999.
	   01 wk-tot.
          05 WRKMSR-03S    PIC S9(3) COMP.
          05 WRKMSR-03     PIC 9(3) COMP.
          05 WRKMSR-09S    PIC S9(9) COMP.
          05 WRKMSR-09     PIC 9(9) COMP.
          05 WRKMSR-18S    PIC S9(18) COMP.
          05 WRKMSR-18     PIC 9(18) COMP.

       PROCEDURE DIVISION.
       Begin.
	      MOVE ZERO TO RecordSize
		  MOVE 58 TO 	WRKMSR-03S, WRKMSR-03
						WRKMSR-09S, WRKMSR-09
						WRKMSR-18S, WRKMSR-18
          MOVE RecordSize  TO WRKMSR-03S
		  MOVE WRKMSR-18S  TO RecordSize
		
          OPEN OUTPUT MasterSeqFile.
	   prdi-00.
	      MOVE ALL "|"      TO MasterSeqRecord. 
		  MOVE  33                TO MSR-02, MSR-02S
		  MOVE  5555              TO MSR-04, MSR-04S
		  MOVE 777777             TO MSR-06, MSR-06S
		  MOVE 99999999           TO MSR-08, MSR-08S
		  MOVE 3333333333         TO MSR-10, MSR-10S
		  MOVE 66666666666        TO MSR-12, MSR-12S
		  MOVE 14141414141414     TO MSR-14, MSR-14S
		  MOVE 2222222222222222   TO MSR-16, MSR-16S
		  MOVE 1111111111111111   TO MSR-18, MSR-18S
    	  WRITE MasterSeqRecord.
	      MOVE ALL "|"		       TO MasterSeqRecord. 
		  MOVE -33                 TO MSR-02S
		  MOVE  33                 TO MSR-02
		  MOVE -5555               TO MSR-04S
		  MOVE  5555               TO MSR-04
		  MOVE -777777             TO MSR-06S
		  MOVE  777777             TO MSR-06 
		  MOVE -99999999           TO MSR-08S
		  MOVE  99999999           TO MSR-08
		  MOVE 3333333333          TO MSR-10
		  MOVE -3333333333         TO MSR-10S
		  MOVE  66666666666        TO MSR-12
		  MOVE -66666666666        TO MSR-12S
		  MOVE  14141414141414     TO MSR-14
		  MOVE -14141414141414     TO MSR-14S
		  MOVE -2222222222222222   TO MSR-16S
		  MOVE  2222222222222222   TO MSR-16
		  MOVE -1111111111111111   TO MSR-18S
		  MOVE  1111111111111111   TO MSR-18
    	  WRITE MasterSeqRecord.
       end-close.             
          CLOSE MasterSeqFile.
       end-proc.
          STOP RUN.
