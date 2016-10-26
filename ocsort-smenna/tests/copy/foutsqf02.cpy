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
      * foutsqf02.cpy
      * OUTREC area record 
       fd sortout.
       01 outfile-record.
           05 out-seq-record      pic  9(07).
           05 out-zd-field        pic s9(7).
           05 out-fl-field        comp-2.
           05 out-fi-field        pic s9(7) comp.
           05 out-pd-field        pic s9(7) comp-3.
           05 out-bi-field        pic  9(7) comp.
           05 out-ch-field        pic  x(5).
           05 out-fl-field-1      COMP-1.
           05 out-clo-field       pic s9(7) sign is leading.
           05 out-cst-field       pic s9(7) sign is trailing separate.
           05 out-csl-field       pic s9(7) sign is leading separate.
           05 ch-filler           pic  x(25).
