      *-------------------------------------------------------------------------------*
      * **********************************************************
      *  OCSort Tests
      * **********************************************************
      * Author:    Sauro Menna
      * Date:      20160821
      * License
      *    Copyright 2016 Sauro Menna
      *    GNU Lesser General Public License, LGPL, 3.0 (or greater)
      * Purpose:   Sort COBOL module
      * *********************************************
      *-------------------------------------------------------------------------------*
      * copy fmrgsqf02.cpy
       fd mergein2.
       01 infile2-record.
           05 in2-seq-record     pic  9(07).
           05 in2-ch-field       pic  x(5).
           05 in2-bi-field       pic  9(7) comp.
           05 in2-fi-field       pic s9(7) comp.
           05 in2-fl-field       comp-2.
           05 in2-pd-field       pic s9(7) comp-3.
           05 in2-zd-field       pic s9(7).
           05 in2-fl-field-1     COMP-1.
           05 in2-clo-field      pic s9(7) sign is leading.
           05 in2-cst-field      pic s9(7) sign is trailing separate.
           05 in2-csl-field      pic s9(7) sign is leading separate.
           05 in2-ch-filler      pic  x(25).
