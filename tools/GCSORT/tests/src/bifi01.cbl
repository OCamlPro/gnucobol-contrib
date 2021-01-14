      *-------------------------------------------------------------------------------*
      * *********************************************
      * Author:    Sauro Menna
      * Date:      20160821
      * License
      *    Copyright 2016 Sauro Menna
      *    GNU Lesser General Public License, LGPL, 3.0 (or greater)
      * Purpose:   Sort COBOL module
      * Instruction use,sum fields
      * *********************************************
      * option:
      * cobc -x -t ..\listing\%1.lst -I ..\copy -Wall -fbinary-size=1--8 
      *      -fnotrunc -fbinary-byteorder=big-endian -o ..\bin\%1 ..\src\%1.CBL 
      * **********************************************************
      *-------------------------------------------------------------------------------*
       identification division.
       program-id. bifi01.
       environment division.
       configuration section.
       repository.
        function all intrinsic.
       input-output section.
       file-control.
       data division.
       file section.
      *
       working-storage section.
      *  
       01 infile-record.      
           05 in-seq-record       pic  9(07).      
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
      * 
      *      
       01  SumFields-00.      
            02 Tot-bi-field            pic  9(16) comp.      
            02 Tot-fi-field            pic s9(16) comp.      
            02 Tot-fl-field            comp-2.      
            02 Tot-pd-field            pic s9(16) comp-3.      
            02 Tot-zd-field            pic s9(16).      
            02 Tot-fl-field-1          COMP-1.      
            02 Tot-clo-field           pic s9(7) sign is leading.      
            02 Tot-cst-field           pic s9(16)      
                    sign is  trailing separate.      
            02 Tot-csl-field           pic s9(16)      
                    sign is  leading separate.      
      *
      *
      * ============================= *
       procedure division.
      * ============================= *
       master-sort.
           display "*===============================================* "
           move 03 to  in-bi-field      
           move 04 to  in-fi-field      
           move 05 to  in-fl-field      
           move 06 to  in-pd-field      
           move 07 to  in-zd-field      
           move 08 to  in-fl-field-1    
           move 09 to  in-clo-field     
           move 10 to  in-cst-field     
           move 11 to  in-csl-field   
                   display "============== ## ============== "
                   display " bi="   in-bi-field      
                           " fi="   in-fi-field      
                           " pd="   in-pd-field      
                           " zd="   in-zd-field 
                           " fl="   in-fl-field     
                           " fl_="  in-fl-field-1  
                           " clo="  in-clo-field   
                           " cst="  in-cst-field   
                           " csl="  in-csl-field   

           move zero to Tot-bi-field
           move zero to Tot-fi-field
           move zero to Tot-fl-field
           move zero to Tot-pd-field
           move zero to Tot-zd-field
           move zero to Tot-fl-field-1
           move zero to Tot-clo-field
           move zero to Tot-cst-field
           move zero to Tot-csl-field
           .
           add in-bi-field   to Tot-bi-field
           add in-fi-field   to Tot-fi-field
           add in-fl-field   to Tot-fl-field
           add in-pd-field   to Tot-pd-field
           add in-zd-field   to Tot-zd-field
           add in-fl-field-1 to Tot-fl-field-1
           add in-clo-field  to Tot-clo-field
           add in-cst-field  to Tot-cst-field
           add in-csl-field  to Tot-csl-field
           .
            display "============== ## ============== "
            display " bi="   Tot-bi-field      
                    " fi="   Tot-fi-field      
                    " pd="   Tot-pd-field      
                    " zd="   Tot-zd-field 
                    " fl="   Tot-fl-field     
                    " fl_="  Tot-fl-field-1  
                    " clo="  Tot-clo-field   
                    " cst="  Tot-cst-field   
                    " csl="  Tot-csl-field   

            goback
            .
      *
 