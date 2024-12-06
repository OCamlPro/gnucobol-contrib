      *-------------------------------------------------------------------------------*
      * **********************************************************
      *  GCSORT Tests
      * **********************************************************
      * Author:    Sauro Menna
      * Date:      20241131
      * License
      *    Copyright 2024 Sauro Menna
      *    GNU Lesser General Public License, LGPL, 3.0 (or greater)
      * Purpose:   Sort COBOL module
      * *********************************************
      *-------------------------------------------------------------------------------*
      * finsqf01.cpy
       fd sortin
            record is varying in size
            from 42 to 95 characters depending on ws-rec-length.            
       01 infile-record.
           05 in-lenrec           pic  9(4).
           05 in-seq-record       pic  9(7).
           05 in-ch-field         pic  x(5).
           05 in-bi-field         pic  9(7) comp.
           05 in-fi-field         pic s9(7) comp.
           05 in-fl-field         comp-2.
           05 in-pd-field         pic s9(7) comp-3.
           05 in-zd-field         pic s9(7).
           05 in-fl-field-1       comp-1.
           05 in-clo-field        pic s9(7) sign is leading.
           05 in-cst-field        pic s9(7) sign is trailing separate.
           05 in-csl-field        pic s9(7) sign is leading separate.
           05 in-ch-filler        pic  x(25).
       01 infile-record-min01   pic x(42).
       01 infile-record-min02   pic x(61).
       