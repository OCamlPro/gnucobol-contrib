      *-------------------------------------------------------------------------------*
      * **********************************************************
      *  GCSORT Tests
      * **********************************************************
      * Author:    Sauro Menna
      * Date:      20160821
      * License
      *    Copyright 2016 Sauro Menna
      *    GNU Lesser General Public License, LGPL, 3.0 (or greater)
      * Purpose:   Generate COBOL fixed file with COMP fields
      *            For Sumfield
      *            Sort/Merge COBOL Program and GCSORT data file
      * **********************************************************
      * option:
      * cobc -x -t ..\listing\%1.lst -I ..\copy -Wall -fbinary-size=1--8 
      *      -fnotrunc -fbinary-byteorder=big-endian -o ..\bin\%1 ..\src\%1.CBL 
      * **********************************************************
      *-------------------------------------------------------------------------------*
	   IDENTIFICATION DIVISION.
       PROGRAM-ID.  readsqbi03.
       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT MasterSeqFile ASSIGN TO  EXTERNAL sqbi03
               ORGANIZATION IS SEQUENTIAL
               ACCESS MODE  IS SEQUENTIAL
               file status is f-s.

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
       01 f-s                   pic xx.
       01 RecordSize			PIC 9999.
	   01 wk-tot.
          05 WRKMSR-03S    PIC S9(3) COMP.
          05 WRKMSR-03     PIC 9(3) COMP.
          05 WRKMSR-09S    PIC S9(9) COMP.
          05 WRKMSR-09     PIC 9(9) COMP.
          05 WRKMSR-18S    PIC S9(18) COMP.
          05 WRKMSR-18     PIC 9(18) COMP.
      *    
           copy wkenvfield.
      *    
       PROCEDURE DIVISION.
       Begin.
	      MOVE ZERO TO RecordSize
		  MOVE 58 TO 	WRKMSR-03S, WRKMSR-03
						WRKMSR-09S, WRKMSR-09
						WRKMSR-18S, WRKMSR-18
          MOVE RecordSize  TO WRKMSR-03S
		  MOVE WRKMSR-18S  TO RecordSize
      *  check if defined environment variables
           move 'sqbi03'  to env-pgm
           perform check-env-var
		
          OPEN input MasterSeqFile.
	   prdi-00.
    	  read MasterSeqFile.
          display ' [1]> f-s = ' f-s
          display ' [1]> MSR-02 = ' MSR-02
    	  read MasterSeqFile.
          display ' [2]>f-s = ' f-s
          display ' [2]>MSR-02 = ' MSR-02
          .
       end-close.             
          CLOSE MasterSeqFile.
       end-proc.
          STOP RUN.
      *       
           copy prenvfield2.
      *
