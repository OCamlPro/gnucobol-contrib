       >>SOURCE FORMAT IS FREE
IDENTIFICATION DIVISION.
program-id. GC74HELPLOAD.
*> ***********************************************************************************
*> GnuCOBOL TT (TUI TOOLS) COLLECTION
*> Purpose:    GC74 TUI HELP SYSTEM: LOAD AN INDEXED HELP FILE FROM A SOURCE TXT FILE
*> Tectonics:  cobc -x GC74HELPLOAD.COB  (use GnuCOBOL 2.0 or greater)
*> Usage:      GC74HELPLOAD
*> Parameters: none
*> Author:     Eugenio Di Lorenzo - Italia (DILO)
*> License:    Copyright 2017 E.Di Lorenzo - LGPL, 3.0 (or greater)
*> Version:    1.0 2017.01.31
*> Changelog:  1.0 first release.
*> ***********************************************************************************
*> the TXT input FILE has tobe as follows
*> - lrec = 84 (lkey= 8+4, ldata= 72)
*> - if byte 1 = * (a "comment " row) then the record is skipped (non loaded to indxed file)
*> - if byte 1 =  & then this will start a new key (a new HELP TOPIC)
*> - the indexed FILE key is 12 cahrs = 8 chars from TTXT file + a 4 digit counter
*> ****************************************************************
*> to be done: if the input file is not ordered the program should read the TXT file
*> use a SORT cobol verb, SORT ... using ... Giving ....
*> abd next use the sorted file to create the indxed file.
*> ****************************************************************

ENVIRONMENT DIVISION.
configuration section.
input-output  section.
file-control.
   *> Input file
   select HelpI
    assign to  FilespecI
    access mode  is sequential
    organization is line sequential
    file status  is FS-HELP-I.
   *> Output file
   select HelpO
    assign to  FilespecO
    access mode  is dynamic
    organization is indexed
    record key   is HelpOKey
    file status  is FS-HELP-O.

DATA DIVISION.
file section.

fd  HelpI label record omitted.
01  HelpIRec pic x(072).

fd  HelpO label record standard.
01  HelpORec.
   03 HelpOKey.
      05 HelpOkcod pic x(08).
      05 HelpOknum pic 9(04) value zero.
   03 HelpOData    pic x(72).

WORKING-STORAGE SECTION.

01  FileSpecI    pic  x(80) value ' '.
01  FileSpecO    pic  x(80) value ' '.
01  FS-HELP-I    pic  x(02) value space.
01  FS-HELP-O    pic  x(02) value space.
01  HelpIeof     pic  x(03) value space.
01  numrec       pic  9(04) value zero.
01  wAnswer      pic  x(01) value space.
01  delay1       pic x(080) value ' '.
01  delay2       pic x(080) value ' '.

01 ctrHelpTitle   Pic 99999 value zero.
01 ctrHelpComment Pic 99999 value zero.
01 ctrHelpRows    Pic 99999 value zero.
01 ctrHelpTotal   Pic 99999 value zero.

*> **************************************************************
*>           P R O C E D U R E   D I V I S I O N
*> **************************************************************
PROCEDURE DIVISION.
inizio.

   display 'Input Filename (default [.TXT]) ............: ' with no advancing
   accept FilespecI
   if FilespecI = space go to inizio end-if
   inspect FilespecI tallying tally for all '.'
   if tally = 0
      inspect FilespecI replacing first '    ' by '.TXT'
   end-if

   display 'Ouput Filename (default = Input Filename.DAT) ......: ' with no advancing
   accept FilespecO
   if FilespecO = space
      move FilespecI to FilespecO
      inspect FilespecO replacing all 'TXT' by 'DAT' after initial '.'
   end-if
   inspect FilespecO tallying tally for all '.'
   if tally = 0
      inspect FilespecO replacing first '    ' by '.DAT'
   end-if

   display space
   display 'Input Filename ...........: ' FilespecI(1:30)
   display 'Output Filename ..........: ' FilespecO(1:30)
   display 'continue (Y/N) ? .....: ' with no advancing
   accept  wAnswer
   if wAnswer = 'Y' or 'y'
      continue
   else
      display space
      display '... Processing stopped by user.' with no advancing
      display space
      stop run
   end-if

  perform

      open input  HelpI
      if FS-HELP-I not = '00'
         display '... error FS-HELP-I = ' FS-HELP-I
         stop run
      end-if

      open output HelpO
      if FS-HELP-O not = '00'
         display '... error FS-HELP-O = ' FS-HELP-O
         stop run
      end-if

      read HelpI
           at end display 'input file empty' stop run
           not at end
               perform until HelpIeof = 'eof'
                      evaluate HelpIrec(1:1)
                       when '*'
                            move ' found a comment --> record skipped '    to HelpOrec
                            add 1 to ctrHelpComment
                       when '&'
                            move HelpIrec(02:08) to HelpOkcod
                            move 0               to HelpOknum
                            move HelpIrec(10:62) to HelpOdata
                            write HelpOrec
                            add 1 to ctrHelpTitle
                       when other
                            add  1        to HelpOknum
                            move HelpIrec to HelpOdata
                            write HelpOrec
                            add 1 to ctrHelpRows
                      end-evaluate

                      add 1 to numrec
                      display 'record ' numrec ' ' HelpOrec(1:60)
                      *> loop to delay the display
                      perform  2000000 times
                               move delay1 to delay2
                      end-perform

                      read HelpI at end move 'eof' to HelpIeof end-read
           end-perform
      end-read

      close HelpI HelpO

      display space
      display '... Processing completed.'
      display space
      display 'Num Rec.Comment ......: ' ctrHelpComment
      display 'Num Rec.Help Topics ..: ' ctrHelpTitle
      display 'Num Rec.Help Rows ....: ' ctrHelpRows
      compute ctrHelpTotal = ctrHelpComment + ctrHelpTitle + ctrHelpRows
      display '                       -------'
      display 'Num rec.TOTAL ........: ' ctrHelpTotal

   end-perform.
