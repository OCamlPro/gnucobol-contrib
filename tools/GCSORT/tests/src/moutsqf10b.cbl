      *-------------------------------------------------------------------------------*
      * **********************************************************
      *  GCSORT Tests
      * **********************************************************
      * Author:    Sauro Menna
      * Date:      20160821
      * License
      *    Copyright 2016 Sauro Menna
      *    GNU Lesser General Public License, LGPL, 3.0 (or greater)
      * Purpose:   Merge COBOL module
      * *********************************************
      * option:
      * cobc -x -t ..\listing\%1.lst -I ..\copy -Wall -fbinary-size=1--8 
      *      -fnotrunc -fbinary-byteorder=big-endian -o ..\bin\%1 ..\src\%1.CBL 
      * **********************************************************
      *-------------------------------------------------------------------------------*
       identification division.
       program-id. momisqf10b.
       environment division.
       configuration section.
       repository.
        function all intrinsic.
       input-output section.
       file-control.
      *merge input file1
            select mergein1 assign to external dd_infile1
                organization is sequential
                access is sequential
                file status is fs-infile1.
      *merge input file2
            select mergein2 assign to external dd_infile2
                organization is sequential
                access is sequential
                file status is fs-infile2.
      *merge input file3
            select mergein3 assign to external dd_infile3
                organization is sequential
                access is sequential
                file status is fs-infile3.
      *merge output file
           select mergeout assign to external dd_outfile
                organization is sequential
                access is sequential
                file status is fs-outfile.
      *merge file (sd)
           select file-merge assign to external dd_mergework
                file status is fs-merge.
       data division.
       file section.
       fd mergein1.
       01 infile1-record.
           05 in1-01                pic x(10).
           05 in1-02                pic x(07).
           05 in1-03                pic x(05).
           05 in1-04                pic x(05).
           05 in1-05                pic x(06).
           05 in1-06                pic x(08).
           05 in1-07                pic x(09).
           05 in1-08                pic x.
           05 in1-09                pic x(06).
           05 in1-10                pic x(06).
           05 in1-11                pic x.
           05 in1-12                pic x(07).
           05 in1-13                pic x(09).
           05 in1-14                pic x.
           05 filler                pic x(9).
       fd mergein2.
       01 infile2-record.
           05 in2-01                pic x(10).
           05 in2-02                pic x(07).
           05 in2-03                pic x(05).
           05 in2-04                pic x(05).
           05 in2-05                pic x(06).
           05 in2-06                pic x(08).
           05 in2-07                pic x(09).
           05 in2-08                pic x.
           05 in2-09                pic x(06).
           05 in2-10                pic x(06).
           05 in2-11                pic x.
           05 in2-12                pic x(07).
           05 in2-13                pic x(09).
           05 in2-14                pic x.
           05 filler                pic x(9).
       fd mergein3.
       01 infile3-record.
           05 in3-01                pic x(10).
           05 in3-02                pic x(07).
           05 in3-03                pic x(05).
           05 in3-04                pic x(05).
           05 in3-05                pic x(06).
           05 in3-06                pic x(08).
           05 in3-07                pic x(09).
           05 in3-08                pic x.
           05 in3-09                pic x(06).
           05 in3-10                pic x(06).
           05 in3-11                pic x.
           05 in3-12                pic x(07).
           05 in3-13                pic x(09).
           05 in3-14                pic x.
           05 filler                pic x(9).
       fd mergeout.
       01 outfile-record.
           05 out-01                pic x(10).
           05 out-02                pic x(07).
           05 out-03                pic x(05).
           05 out-04                pic x(05).
           05 out-05                pic x(06).
           05 out-06                pic x(08).
           05 out-07                pic x(09).
           05 out-08                pic x.
           05 out-09                pic x(06).
           05 out-10                pic x(06).
           05 out-11                pic x.
           05 out-12                pic x(07).
           05 out-13                pic x(09).
           05 out-14                pic x.
           05 filler                pic x(9).
       sd file-merge.
       01 merge-data.
           05 mrg-01                pic x(10).
           05 mrg-02                pic x(07).
           05 mrg-03                pic x(05).
           05 mrg-04                pic x(05).
           05 mrg-05                pic x(06).
           05 mrg-06                pic x(08).
           05 mrg-07                pic x(09).
           05 mrg-08                pic x.
           05 mrg-09                pic x(06).
           05 mrg-10                pic x(06).
           05 mrg-11                pic x.
           05 mrg-12                pic x(07).
           05 mrg-13                pic x(09).
           05 mrg-14                pic x.
           05 filler                pic x(9).
      *
       working-storage section.
       77 fs-infile1                pic xx.
       77 fs-infile2                pic xx.
       77 fs-infile3                pic xx.
       77 fs-outfile                pic xx.
       77 fs-merge                  pic xx.
      *
      * ============================= *
       77 record-counter-in              pic 9(7) value zero.
       77 record-counter-out             pic 9(7) value zero.
       77 bIsFirstTime                   pic 9    value zero.       
       77 bIsPending                     pic 9    value zero.       
       01 current-time.
           05 ct-hours      pic 99.
           05 ct-minutes    pic 99.
           05 ct-seconds    pic 99.
           05 ct-hundredths pic 99.       
       
      * ============================= *
       procedure division.
      * ============================= *
       master-merge.
           display "*===============================================* "
           display " Merge on ascending  key    mrg-05 "
           display "*===============================================* "
           
           merge file-merge
               on ascending  key     mrg-05            
               using mergein1 mergein2 mergein3   
               giving mergeout
            
           display "*===============================================* "
           display " Record output : "  record-counter-out
           display "*===============================================* "
           goback
           .
      *

