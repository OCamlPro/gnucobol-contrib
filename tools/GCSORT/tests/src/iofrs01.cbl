      *-------------------------------------------------------------------------------*
      * **********************************************************
      *  GCSORT Tests
      * **********************************************************
      * Author:    Sauro Menna
      * Date:      20160821
      * License
      *    Copyright 2022 Sauro Menna
      *    GNU Lesser General Public License, LGPL, 3.0 (or greater)
      * Purpose:   Generate COBOL fixed file with COMP fields
      *            Sort/Merge COBOL Program and GCSORT data file
      * **********************************************************
      * option:
      * cobc -x -t ..\listing\%1.lst -I ..\copy -Wall -fbinary-size=1--8 
      *      -fnotrunc -fbinary-byteorder=big-endian -o ..\bin\%1 ..\src\%1.CBL 
      * **********************************************************
      *-------------------------------------------------------------------------------*
	   identification division.
       program-id.  iofrs01.
       environment division.
       input-output section.
       file-control.
           select masterseqfile assign to  external dd_outfile
               organization is line sequential
               access mode  is sequential.

       data division.
       file section.
       fd masterseqfile.
       01 masterseqrecord.
          05 msr-01     pic X(100).

       working-storage section.
      *    
           copy wkenvfield.
      *    
       procedure division.
       begin.
      *  check if defined environment variables
           move 'dd_outfile'  to env-pgm
           perform check-env-var
      *                
          open output masterseqfile.
	   prdi-00.
	      move all "1"             to masterseqrecord. 
          move " xyz  "            to masterseqrecord(10:6) 
          move " K541 "            to masterseqrecord(30:6) 
          move " ZSWF "            to masterseqrecord(50:6) 
          move " ZSWF "            to masterseqrecord(60:6) 
          move " ZSWF "            to masterseqrecord(70:6) 
    	  write masterseqrecord.
	      move all "2"		       to masterseqrecord. 
          move " xyz  "            to masterseqrecord(10:6) 
          move " K541 "            to masterseqrecord(30:6) 
          move " ZSWF "            to masterseqrecord(50:6) 
          move " ZSWF "            to masterseqrecord(60:6) 
          move " ZSWF "            to masterseqrecord(70:6) 
    	  write masterseqrecord.
	      move all "3"		       to masterseqrecord. 
          move " xyz  "            to masterseqrecord(10:6) 
          move " K541 "            to masterseqrecord(30:6) 
          move " ZSWF "            to masterseqrecord(50:6) 
          move " ZSWF "            to masterseqrecord(60:6) 
          move " ZSWF "            to masterseqrecord(70:6) 
    	  write masterseqrecord.
       end-close.             
          close masterseqfile.
       end-proc.
          stop run.
      *       
           copy prenvfield2.
      *
