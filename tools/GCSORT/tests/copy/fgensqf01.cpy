      *-------------------------------------------------------------------------------*
      * **********************************************************
      *  GCSORT Tests
      * **********************************************************
      * Author:    Sauro Menna
      * Date:      20160821
      * License
      *    Copyright 2016 Sauro Menna
      *    GNU Lesser General Public License, LGPL, 3.0 (or greater)
      * Purpose:   Sort COBOL module
      * *********************************************
      *-------------------------------------------------------------------------------*
      * fgensqf01.cpy
       fd outfile.
       01 outfile-record.
           05 seq-record         pic  9(07).
           05 ch-field           pic  x(5).
           05 bi-field           pic  9(7) COMP.
           05 fi-field           pic s9(7) COMP.
           05 fl-field           COMP-2.
           05 pd-field           pic s9(7) COMP-3.
           05 zd-field           pic s9(7).   
           05 fl-field-1         COMP-1.
           05 clo-field          pic s9(7) sign is leading.
           05 cst-field          pic s9(7) sign is  trailing separate.
           05 csl-field          pic s9(7) sign is  leading separate.
           05 ch-filler          pic x(25).
