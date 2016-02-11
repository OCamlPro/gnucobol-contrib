999999 IDENTIFICATION DIVISION.
999999 PROGRAM-ID. TSTCHSORTX.
999999 ENVIRONMENT DIVISION.
999999 INPUT-OUTPUT SECTION.
999999 FILE-CONTROL.
999999* ************************* Select 
999999      SELECT FGENFILE	ASSIGN TO 'FGENFILE'
999999            ORGANIZATION IS SEQUENTIAL
999999            ACCESS MODE  IS SEQUENTIAL.
999999 DATA DIVISION.
999999 FILE SECTION.
999999* ************************* Fd 
999999      FD FGENFILE	
999999           RECORDING MODE IS F.
999999 01   MasterSeqRecord-F.
999999       03   F-PR-00001-00005-A         PIC S9(00005).
999999       03   F-PD-00006-00005-A         PIC S9(00009) COMP-3.
999999       03   F-CH-00011-00009-A         PIC  X(00009).
999999       03   F-BI-00020-00003-A         PIC  9(00006) COMP.
999999       03   F-FI-00023-00003-A         PIC S9(00006) COMP.
999999       03   F-FX-00026-00010-A         PIC  X(00010).
999999       03   F-CH-00036-00010-D         PIC  X(00010).
999999       03   F-FX-00046-00003-A         PIC  X(00003).
999999       03   F-CH-00049-00005-A         PIC  X(00005).
999999       03   F-ZD-00054-00012-A         PIC S9(00012).
999999       03   FILLER-00100             PIC  X(00035).
999999* ************************* Working 
999999 WORKING-STORAGE SECTION.
999999*
999999 77   recordsize     PIC 9(10) COMP.
999999 01   WK-MasterSeqRecord-F.
999999       03   WK-F-PR-00001-00005-A      PIC S9(00005).
999999       03   WK-F-PD-00006-00005-A      PIC S9(00009) COMP-3.
999999       03   WK-F-CH-00011-00009-A      PIC  X(00009).
999999       03   WK-F-BI-00020-00003-A      PIC  9(00006) COMP.
999999       03   WK-F-FI-00023-00003-A      PIC S9(00006) COMP.
999999       03   WK-F-FX-00026-00010-A      PIC  X(00010).
999999       03   WK-F-CH-00036-00010-D      PIC  X(00010).
999999       03   WK-F-FX-00046-00003-A      PIC  X(00003).
999999       03   WK-F-CH-00049-00005-A      PIC  X(00005).
999999       03   WK-F-ZD-00054-00012-A      PIC S9(00012).
999999       03   WK-FILLER-00100           PIC  X(00035).
999999 77   wk-field-error      PIC X(20).
999999 77   numrecords		   PIC 9(15) VALUE ZERO.
999999 77   segment-01          PIC 9(15) VALUE ZERO.
999999 77   segment-02          PIC 9(15) VALUE ZERO.
999999*
999999* ************************* Procedure 
999999 PROCEDURE DIVISION.
999999 Begin-Procedure.
999999     display "Start Program TSTCHSORTX ".
999999     display "Check data file sorted by OCSort."
999999     open input FGENFILE.
999999     read FGENFILE at end go to Read-End.
999999     add 1  to numrecords.
999999     move MasterSeqRecord-F to WK-MasterSeqRecord-F.
999999 Read-Again-00.
999999     read FGENFILE at end go to Read-End.
999999     add 1  to numrecords.
999999     divide numrecords by 100000 giving segment-02
999999     		remainder segment-01.
999999     if (segment-01 = ZERO)
999999        display "Readed " numrecords.
999999** Check Field F-CH-00011-00009-A 
999999*  Field sort Ascending
999999     if (F-CH-00011-00009-A < WK-F-CH-00011-00009-A)
999999                 display " Error Field NOT Ascending order "
999999           move "F-CH-00011-00009-A" to wk-field-error 
999999              go Error-Sort.
999999*  Field sort Ascending
999999     if (F-CH-00011-00009-A > WK-F-CH-00011-00009-A)
999999            move MasterSeqRecord-F to WK-MasterSeqRecord-F
999999                    go Read-Again-00.
999999** Check Field F-BI-00020-00003-A 
999999*  Field sort Ascending
999999     if (F-BI-00020-00003-A < WK-F-BI-00020-00003-A)
999999                 display " Error Field NOT Ascending order "
999999           move "F-BI-00020-00003-A" to wk-field-error 
999999              go Error-Sort.
999999*  Field sort Ascending
999999     if (F-BI-00020-00003-A > WK-F-BI-00020-00003-A)
999999            move MasterSeqRecord-F to WK-MasterSeqRecord-F
999999                    go Read-Again-00.
999999** Check Field F-PD-00006-00005-A 
999999*  Field sort Ascending
999999     if (F-PD-00006-00005-A < WK-F-PD-00006-00005-A)
999999                 display " Error Field NOT Ascending order "
999999           move "F-PD-00006-00005-A" to wk-field-error 
999999              go Error-Sort.
999999*  Field sort Ascending
999999     if (F-PD-00006-00005-A > WK-F-PD-00006-00005-A)
999999            move MasterSeqRecord-F to WK-MasterSeqRecord-F
999999                    go Read-Again-00.
999999** Check Field F-FI-00023-00003-A 
999999*  Field sort Ascending
999999     if (F-FI-00023-00003-A < WK-F-FI-00023-00003-A)
999999                 display " Error Field NOT Ascending order "
999999           move "F-FI-00023-00003-A" to wk-field-error 
999999              go Error-Sort.
999999*  Field sort Ascending
999999     if (F-FI-00023-00003-A > WK-F-FI-00023-00003-A)
999999            move MasterSeqRecord-F to WK-MasterSeqRecord-F
999999                    go Read-Again-00.
999999** Check Field F-ZD-00054-00012-A 
999999*  Field sort Ascending
999999     if (F-ZD-00054-00012-A < WK-F-ZD-00054-00012-A)
999999                 display " Error Field NOT Ascending order "
999999           move "F-ZD-00054-00012-A" to wk-field-error 
999999              go Error-Sort.
999999*  Field sort Ascending
999999     if (F-ZD-00054-00012-A > WK-F-ZD-00054-00012-A)
999999            move MasterSeqRecord-F to WK-MasterSeqRecord-F
999999                    go Read-Again-00.
999999** Check Field F-CH-00036-00010-D 
999999*  Field sort Descending
999999     if (F-CH-00036-00010-D > WK-F-CH-00036-00010-D)
999999                 display " Error Field NOT Descending order "
999999           move "F-CH-00036-00010-D" to wk-field-error 
999999              go Error-Sort.
999999*  Field sort Descending
999999     if (F-CH-00036-00010-D < WK-F-CH-00036-00010-D)
999999            move MasterSeqRecord-F to WK-MasterSeqRecord-F
999999                    go Read-Again-00.
999999     move MasterSeqRecord-F to WK-MasterSeqRecord-F.
999999     go Read-Again-00.
999999 Error-Sort.
999999     display "Error sort order "
999999     display "Field error :  " wk-field-error
999999     display "Keys for current and previous record "
999999     display "================================== "
999999     display 
999999     "   F-CH-00011-00009-A = "     F-CH-00011-00009-A
999999     display 
999999     "WK-F-CH-00011-00009-A = "  WK-F-CH-00011-00009-A
999999     display "================================== "
999999     display 
999999     "   F-BI-00020-00003-A = "     F-BI-00020-00003-A
999999     display 
999999     "WK-F-BI-00020-00003-A = "  WK-F-BI-00020-00003-A
999999     display "================================== "
999999     display 
999999     "   F-PD-00006-00005-A = "     F-PD-00006-00005-A
999999     display 
999999     "WK-F-PD-00006-00005-A = "  WK-F-PD-00006-00005-A
999999     display "================================== "
999999     display 
999999     "   F-FI-00023-00003-A = "     F-FI-00023-00003-A
999999     display 
999999     "WK-F-FI-00023-00003-A = "  WK-F-FI-00023-00003-A
999999     display "================================== "
999999     display 
999999     "   F-ZD-00054-00012-A = "     F-ZD-00054-00012-A
999999     display 
999999     "WK-F-ZD-00054-00012-A = "  WK-F-ZD-00054-00012-A
999999     display "================================== "
999999     display 
999999     "   F-CH-00036-00010-D = "     F-CH-00036-00010-D
999999     display 
999999     "WK-F-CH-00036-00010-D = "  WK-F-CH-00036-00010-D
999999     display "================================== "
999999     display "Number records read : " NUMRECORDS.
999999     go End-Close.
999999 Read-End.
999999     display  "SORT  OK ".
999999     display  " Total records : " NUMRECORDS.
999999 End-Close.
999999     close FGENFILE.      
999999 Begin-Procedure.
999999     display "End Program TSTCHSORTX ".
999999 End-Procedure.
999999     goback.
