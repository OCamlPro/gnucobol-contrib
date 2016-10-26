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
      *    copy wktotsum01.cpy
       01  SumFields-00.
         02 Tot-bi-field            pic  9(18) comp.
         02 Tot-fi-field            pic s9(18) comp.
         02 Tot-fl-field            comp-2.
         02 Tot-pd-field            pic s9(18) comp-3.
         02 Tot-zd-field            pic s9(18).
         02 Tot-fl-field-1          COMP-1.
         02 Tot-clo-field           pic s9(7) sign is leading.
         02 Tot-cst-field           pic s9(19) 
                sign is  trailing separate.
         02 Tot-csl-field           pic s9(19) 
                sign is  leading separate.
      * key 
       01 key-curr-input.                                             
           05 key-curr-seq-record        pic  9(07).
           05 key-curr-ch-field          pic  x(5).
           05 key-curr-bi-field          pic  9(7) comp.
           05 key-curr-fi-field          pic s9(7) comp.
           05 key-curr-fl-field          comp-2.
           05 key-curr-pd-field          pic s9(7) comp-3.
           05 key-curr-zd-field          pic s9(7).
           05 key-curr-fl-field-1        COMP-1.
           05 key-curr-clo-field         pic s9(7) 
                sign is leading.
           05 key-curr-cst-field         pic s9(7) 
                sign is  trailing separate.
           05 key-curr-csl-field         pic s9(7) 
                sign is  leading separate.
       01 key-prec-input.                                             
           05 key-prec-seq-record        pic  9(07).
           05 key-prec-ch-field          pic  x(5).
           05 key-prec-bi-field          pic  9(7) comp.
           05 key-prec-fi-field          pic s9(7) comp.
           05 key-prec-fl-field          comp-2.
           05 key-prec-pd-field          pic s9(7) comp-3.
           05 key-prec-zd-field          pic s9(7).
           05 key-prec-fl-field-1        COMP-1.
           05 key-prec-clo-field         pic s9(7) 
                sign is leading.
           05 key-prec-cst-field         pic s9(7) 
                sign is  trailing separate.
           05 key-prec-csl-field         pic s9(7) 
                sign is  leading separate.
