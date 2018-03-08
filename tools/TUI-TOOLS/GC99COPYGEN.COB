       >>SOURCE FORMAT IS FREE
       IDENTIFICATION DIVISION.
       Program-Id. GC99COPYGEN.
      *> ***********************************************************************************
      *> GnuCOBOL TT (TUI TOOLS) COLLECTION
      *> Purpose:    COPY COBOL GENERATOR FROM TEMPLATE OF REPORTS
      *> Tectonics:  cobc -x GC99COPYGEN.COB  (use GnuCOBOL 2.0 or greater)
      *> Usage:      GC99COPYGEN
      *> Parameters:
      *> Author:     Eugenio Di Lorenzo - Italia (DILO)
      *> License:    Copyright 2017 E.Di Lorenzo - GNU Lesser General Public License, LGPL, 3.0 (or greater)
      *> Version:    1.0 2017.01.31
      *> Changelog:  1.0 first release.
      *> ***********************************************************************************
       ENVIRONMENT DIVISION.
       CONFIGURATION SECTION.
       Special-Names.
              Decimal-Point is Comma.

       INPUT-OUTPUT SECTION.
       File-Control.
       select FILEINP
              assign to   FilespecI
              organization is line sequential
              file status  is FS-FILEINP.
       select FILEOUT
              assign to  FilespecO
              organization is line sequential
              file status  is FS-FILEOUT.

      *>* *************************************************************
      *>*
      *>*
      *>* *************************************************************
       DATA DIVISION.
       FILE SECTION.
       Fd  FILEINP. *> label record omitted.
       01  I-rec.
           03 I-char pic x occurs 133.

       Fd  FILEOUT. *> label record omitted.
       01  O-rec    pic x(80).

      *>* *************************************************************
      *>*
      *>*
      *>* *************************************************************
       WORKING-STORAGE SECTION.
       01  wAnswer          pic x(01) value space.
       01  FileSpecI        pic x(80) value ' '.
       01  FileSpecO        pic x(80) value ' '.
       77  FS-FILEINP       PIC XX    value space.
       77  FS-FILEOUT       PIC XX    value space.
       77  Drive-Id         pic x(01) value ' '.
       77  Direc-Name       pic x(24) value ' '.
       77  DiskFileName     pic x(29) value ' '.

       01  tab-rows value space.
           03 occurs 99.
               05 nr      pic x(002).
               05 el-row  pic x(132).

       01  lar                   pic 9(03) value 132.
       01  num-row               pic 9(02) value 1.
       01  num-field             pic 9(02) value zero.
       01  nrec                  pic 9(02) value 1.
       01  ctr                   pic 9(02) value zero.
       01  cr                    pic 9(03) value zero.
       01  i                     pic 9(03) value zero.
       01  k                     pic 9(03) value zero.
       01  y                     pic 9(02) value zero.
       01  wPos                  pic 9(03) value 1.
       01  wPicture              pic x(01) value space.
       01  wChar                 pic x(01) value space.
       01  wChar2                pic x(01) value space.
       01  comodo                pic x(34) value space.
       01  wend-of-file          pic x(01) value space.
           88 eof                value 'T'.
           88 not-eof            value 'F'.
       01  wsearch               pic x(01) value space.
           88 wfound             value 'T'.
           88 non-wfound         value 'F'.
       01  wfind-table           pic x(01) value space.
           88 wend-table         value 'T'.
           88 not-wend-table     value 'F'.
       01  wfind-equals          pic x(01) value space.
           88 w-all-equals       value 'T'.
           88 non-w-all-equals   value 'F'.

       01  wRow                  pic x(80).
       01  wRowc  redefines wRow.
           03                    pic x(06).
           03 O-aster.
              05 O-ast1          pic x(02).
              05 O-comm          pic x(63).

      *>****************************************************************
      *>           P R O C E D U R E   D I V I S I O N
      *>****************************************************************
       PROCEDURE DIVISION.

         Perform Accept-File-Names thru Accept-File-Names-Ex

         open input  FILEINP
         if FS-FILEINP not = '00'
           display '... error FS-HELP-I = ' FS-FILEINP
           stop run
          end-if

         open output FILEOUT
         if FS-FILEOUT not = '00'
           display '... error FS-HELP-I = ' FS-FILEOUT
           stop run
          end-if

         display space
         display '*** COPY COBOL report automatic generation.'
         display space

         read FILEINP
          at end display 'FILEINP is empty. ' close FILEINP FILEOUT stop run

          not at end
          *> skip if found a blank line
          if i-rec = space
             perform until i-rec not = space
               *> display '*** wRow' nrec ' a blank --> scarta'
               display '*** Row number ' nrec ' empty --> not generated'
               add 1 to nrec
               read FILEINP
                 at end display 'FILEINP is empty'
                        close FILEINP FILEOUT stop run
                 not at end continue
               end-read
             end-perform
          end-if

          *> write a header for the copy
          move space      to wRow
          move all '*'    to o-aster
          move '*>'       to o-ast1
          add 1 to cr
          write o-rec from wRow end-write

          move space      to wRow
          move '*>'       to o-ast1
          move '                                 ' to o-comm
          write o-rec from wRow end-write
          move '           ------ GnuCOBOL COPY GENERATED ------' to
               o-comm
          write o-rec from wRow end-write
          move '                  REPORT COD.XXXXXXXX' to o-comm
          write o-rec from wRow end-write
          add 3 to cr

          move space      to wRow
          move '*>'       to o-ast1
          move '                                 ' to o-comm
          write o-rec from wRow end-write

          move space      to wRow
          move all '*'    to o-aster
          move '*>'       to o-ast1
          add 1 to cr
          write o-rec from wRow end-write

          *> processes the individual rows read
          set not-eof to true
          Perform until eof

            *> write first row of copy (01 level).
            move 1         to i
            move space     to wRow
            string '       01  ROW' num-row '.'
              delimited by size into wRow end-string
            add 1 to cr
            write o-rec from wRow end-write

            display '*** Row number ' nrec '  --> generated Copy Row ' num-row *> DISPLAY

            *> processes the individual fields of the line read
            *> and writes the lines of copy with fields (level 03)
            perform until i >= lar

              move I-char(i) to wChar
              move zero to ctr

              if I-char(i) = '$' or '#'
                 *> treatment field with variable (pic x o pic 9)
                 perform until I-char(i) not = wChar or i > lar
                   add 1 to i ctr
                 end-perform
                 move space to wRow
                 add 1 to num-field
                 if wChar = '$' move 'X' to wPicture end-if
                 if wChar = '#' move '9' to wPicture end-if
                 string '           03 R' num-row '-FIELD'
                   num-field '    PIC ' wPicture '(' ctr ').'
                   delimited by size into wRow end-string
                 add 1 to cr
                 write o-rec from wRow end-write

                 add ctr to wPos
              else
                 *> treatment field with constant
                 perform until
                   (I-char(i) = '$' or '#') or ctr = 50 or i > lar
                   add 1 to i ctr
                 end-perform

                 move space to wRow

                 *> check if line contains all same character
                 *> (to set VALUE ALL ... if the case
                 set non-w-all-equals to true
                 move i-rec(wPos:1) to wChar2
                 move zero to tally
                 inspect i-rec(wPos:ctr) tallying tally for all wChar2
                 if tally = ctr
                    set w-all-equals to true
                 end-if

                 if ctr > 24 and not w-all-equals
                    *> the program writes 2 rows.
                    *> the first one is with "PICTURE (PIC)"
                    string '           03                PIC X('
                    ctr ')' delimited by size into wRow end-string
                    add 1 to cr
                    write o-rec from wRow end-write

                    *> the second one is with "VALUE"
                    move space     to wRow
                    string '           VALUE ''' i-rec(wPos:ctr)
                      '''.' delimited by size into wRow end-string
                    add 1 to cr
                    write o-rec from wRow end-write
                 else
                    *> the program write only one source line in the copy
                    move space to comodo
                    if i-rec(wPos:ctr) = space
                      *> wRow con value space
                      string ' VALUE SPACE.'
                        delimited by size into comodo end-string
                    else
                        if w-all-equals and tally not = 1
                         string ' VALUE ALL ''' i-rec(wPos:1) '''.'
                          delimited by size into comodo end-string
                        else string ' VALUE ''' i-rec(wPos:ctr) '''.'
                          delimited by size into comodo end-string
                        end-if
                    end-if
                    string '           03                PIC X('
                      ctr ')' comodo delimited by size into wRow
                    end-string
                    add 1 to cr
                    write o-rec from wRow end-write

                 end-if
                 add ctr to wPos
              end-if

            end-perform

            *> write a blank line to separate row fields at level 01
            move space to wRow
            add 1 to cr
            write o-rec from wRow end-write

            move 1 to i wPos
            move 0 to num-field
            add  1 to num-row

            add 1 to y
            *> store numer of line and all the line read
            move  nrec to nr(y)
            move i-rec to el-row(y)

            *> read next record , try to find if the line already exist
            *> in previous stored lines. If exist , then skip the line.
            *> to avoid the generation of source copy line with duplicate fileds
            set not-wend-table to true
            perform until  eof or wend-table
             read FILEINP
               at end set eof to true
               not at end
                add 1 to nrec
                set non-wfound to true
                move 1 to k
                set not-wend-table to true

                perform until wfound or wend-table or (k > 30)
                 if el-row(k) = space
                    set wend-table to true
                 else if i-rec = space
                         set wfound to true
                         display '*** Row number ' nrec ' empty / blank --> not generated'
                      end-if
                      if i-rec = el-row(k)
                         set wfound to true
                         display '*** Row number ' nrec ' = to row ' nr(k) ' --> not generated'
                      end-if
                 end-if
                 add 1 to k
                end-perform
             end-read
            end-perform
          end-perform
         end-read

         Subtract 1 from num-row cr
         display space

         display '*** Copy created with  ' num-row ' report rows.'
         display '*** Copy COBOL contain ' cr ' source statements.'
         display '*** Ok. End of work.'
         display space.

         close FILEINP FILEOUT
         stop run.

      *>****************************************************************
      *>
      *>****************************************************************
Accept-File-Names.
         display 'Input Filename (default [.TXT]) ............: '
          with no advancing
         accept FilespecI
         if FilespecI = space go to Accept-File-Names end-if
         inspect FilespecI tallying tally for all '.'
         if tally = 0
          inspect FilespecI replacing first '    ' by '.TXT'
         end-if

         display 'Ouput Filename (default = Input Filename.CPY) ......: '
          with no advancing
         accept FilespecO
         if FilespecO = space
          move FilespecI to FilespecO
          inspect FilespecO replacing all 'TXT' by 'CPY'
           after initial '.'
         end-if
         inspect FilespecO tallying tally for all '.'
         if tally = 0
          inspect FilespecO replacing first '    ' by '.CPY'
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
         end-if.
Accept-File-Names-Ex. Exit.

End Program GC99COPYGEN.
