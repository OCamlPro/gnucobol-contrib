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
      * copy fmrgsqf03.cpy
       fd mergein3.
       01 infile3-record.
           05 in3-seq-record     pic  9(07).
           05 in3-ch-field       pic  x(5).
           05 in3-bi-field       pic  9(7) comp.
           05 in3-fi-field       pic s9(7) comp.
           05 in3-fl-field       comp-2.
           05 in3-pd-field       pic s9(7) comp-3.
           05 in3-zd-field       pic s9(7).
           05 in3-fl-field-1     COMP-1.
           05 in3-clo-field      pic s9(7) sign is leading.
           05 in3-cst-field      pic s9(7) sign is trailing separate.
           05 in3-csl-field      pic s9(7) sign is leading separate.
           05 in3-ch-filler      pic  x(25).
