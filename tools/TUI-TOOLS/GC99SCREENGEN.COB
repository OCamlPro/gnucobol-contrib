       >>SOURCE FORMAT IS FREE
IDENTIFICATION DIVISION.
Program-Id. GC99SCREENGEN.
*> ***********************************************************************************
*> GnuCOBOL TT (TUI TOOLS) COLLECTION
*> Purpose:    COPY COBOL GENERATOR FROM TEMPLATE OF SCRREN
*> Tectonics:  cobc -x GC99SCREENGEN.COB  (use GnuCOBOL 3.0 or greater)
*> Usage:      GC99SCREENGEN
*> Parameters:
*> Author:     Eugenio Di Lorenzo - Italia (DILO) - eugenio.dilo@gmail.com
*> License:    Copyright 2019 E.Di Lorenzo - GNU Lesser General Public License, LGPL, 3.0 (or greater)
*> Version:    1.0 2019.05.31
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
    03 I-char pic x occurs 80.

Fd  FILEOUT. *> label record omitted.
01  O-rec    pic x(80).

*>* *************************************************************
*>*
*>*
*>* *************************************************************
WORKING-STORAGE SECTION.

01  FileSpecI        pic x(80) value ' '.
01  FileSpecO        pic x(80) value ' '.
77  FS-FILEINP       PIC XX    value space.
77  FS-FILEOUT       PIC XX    value space.
77  Drive-Id         pic x(01) value ' '.
77  Direc-Name       pic x(24) value ' '.
77  DiskFileName     pic x(29) value ' '.
01  wAnswer          pic x(01) value space.

01  tab-rows value space.
    03 occurs 99.
       05 el-NumRow  pic x(002).
       05 el-Row     pic x(132).

01  wWidth                pic 9(03) value 080.
01  wNumScreenRow         pic 9(03) value 1.
01  wNumField             pic 9(02) value zero.
01  wNumRecInp            pic 9(02) value 1.
01  wNumChar              pic 9(02) value zero.
01  wNumSourceRow         pic 9(03) value zero.
01  i                     pic 9(03) value zero.
01  k                     pic 9(03) value zero.
01  y                     pic 9(02) value zero.
01  wCol                  pic 9(03) value zero.
01  wPos                  pic 9(03) value 1.
01  wPicture              pic x(01) value space.
01  wChar                 pic x(01) value space.
01  wChar2                pic x(01) value space.
01  wValue                pic x(34) value space.
01  wend-of-file          pic x(01) value space.
    88 eof                value 'T'.
    88 not-eof            value 'F'.
01  wsearch               pic x(01) value space.
    88 wfound             value 'T'.
    88 not-wfound         value 'F'.
01  wfind-table           pic x(01) value space.
    88 wend-table         value 'T'.
    88 not-wend-table     value 'F'.
01  wfind-equals          pic x(01) value space.
    88 w-all-equals       value 'T'.
    88 not-w-all-equals   value 'F'.

01  wCopyRow              pic x(80).
01  wCopyRowc  redefines wCopyRow.
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
  display '... error FS-FILE-INP = ' FS-FILEINP
  goback
end-if

open output FILEOUT
if FS-FILEOUT not = '00'
  display '... error FS-FILE-OUT = ' FS-FILEOUT
  goback
end-if

display space
display '*** COPY COBOL SCREEN SECTION automatic generation.'
display space

read FILEINP
  at end display 'FILEINP is empty. ' close FILEINP FILEOUT goback

not at end

  *> write a header for the copy
  move space      to wCopyRow
  move all '*'    to o-aster
  move '*>'       to o-ast1
  add 1 to wNumSourceRow
  write o-rec from wCopyRow end-write

  move '           ------ GnuCOBOL COPY GENERATED ------' to o-comm
  write o-rec from wCopyRow end-write
  add 1 to wNumSourceRow
  move '                  SCREEN COD.XXXXXXXX' to o-comm
  write o-rec from wCopyRow end-write
  add 1 to wNumSourceRow

  move space      to wCopyRow
  move all '*'    to o-aster
  move '*>'       to o-ast1
  add 1 to wNumSourceRow
  write o-rec from wCopyRow end-write

  move space      to wCopyRow
  move '       01  SCREEN001 blank screen auto-skip.' to wCopyRow
  add 1 to wNumSourceRow
  write o-rec from wCopyRow end-write

  *> processes the individual rows read
  set not-eof to true
  perform until eof

    *> write first row of copy (03 level).
    move 1         to i
    move space     to wCopyRow
    string '           03 SCR' wNumRecInp ' background-color 2 foreground-color 7 .' delimited by size into wCopyRow end-string
    add 1 to wNumSourceRow
    write o-rec from wCopyRow end-write

    display '*** Row number ' wNumRecInp '  --> generated Copy Row ' wNumScreenRow *> DISPLAY

    *> processes the individual fields of the line read
    *> and write the lines of copy with fields (level 03)
    perform until i >= wWidth

      move I-char(i) to wChar
      move zero to wNumChar

      move i to wCol
      if I-char(i) = '$' or '#'

          *> treatment field with a variable (pic x o pic 9)
          perform until I-char(i) not = wChar or i > wWidth
                  add 1 to i wNumChar
          end-perform
          move space to wCopyRow
          add 1 to wNumField
          if wChar = '$' move 'X' to wPicture end-if
          if wChar = '#' move '9' to wPicture end-if
          string '              05 S' wNumRecInp '-FIELD' wNumField ' line ' wNumRecInp ' col ' wCol ' PIC ' wPicture '(' wNumChar ').'
                delimited by size into wCopyRow end-string
          add 1 to wNumSourceRow
          write o-rec from wCopyRow end-write

          add wNumChar to wPos
      else
          *> treatment field with constant
          perform until (I-char(i) = '$' or '#') or wNumChar = 50 or i > wWidth
                  add 1 to i wNumChar
          end-perform

          move space to wCopyRow

          *> check if line contains all same character (to set VALUE ALL ... if the case
          set not-w-all-equals to true
          move i-rec(wPos:1) to wChar2
          move zero to tally
          inspect i-rec(wPos:wNumChar) tallying tally for all wChar2
          if tally = wNumChar
             set w-all-equals to true
          end-if

          if wNumChar > 24 and not w-all-equals
            *> the program writes 2 rows. the first one is with "PICTURE (PIC)"
            string '              05' ' line ' wNumRecInp ' col ' wCol ' PIC X(' wNumChar ')' delimited by size into wCopyRow end-string
            add 1 to wNumSourceRow
            write o-rec from wCopyRow end-write

            *> the second one is with "VALUE"
            move space     to wCopyRow
            string '              VALUE ''' i-rec(wPos:wNumChar) '''.' delimited by size into wCopyRow end-string
            add 1 to wNumSourceRow
            write o-rec from wCopyRow end-write
          else
            *> the program write only one source line in the copy
            move space to wValue

            if i-rec(wPos:wNumChar) = space
               *> wCopyRow con value space
               string ' VALUE SPACE.' delimited by size into wValue end-string
            else
                if w-all-equals and tally not = 1
                  string ' VALUE ALL ''' i-rec(wPos:1) '''.' delimited by size into wValue end-string
                else
                  string ' VALUE ''' i-rec(wPos:wNumChar) '''.'  delimited by size into wValue end-string
                end-if
            end-if

            string '              05' ' line ' wNumRecInp ' col ' wCol ' PIC X(' wNumChar ')' wValue delimited by size into wCopyRow end-string
            add 1 to wNumSourceRow
            write o-rec from wCopyRow end-write

          end-if
          add wNumChar to wPos
      end-if

    end-perform

    move 1 to i wPos
    move 0 to wNumField
    add  1 to wNumScreenRow

    add  1 to y
    *> store number of line and all the line read
    move wNumRecInp to el-NumRow(y)
    move i-rec      to el-Row(y)

    *> read next record ,
    set not-wend-table to true
    perform until eof or wend-table
      read FILEINP
        at end set eof to true
        not at end
            add 1 to wNumRecInp
            set not-wfound to true
            set wend-table to true
      end-read
    end-perform

  end-perform
end-read

subtract 1 from wNumScreenRow *> wNumSourceRow
display space

display '*** Copy created with  ' wNumScreenRow ' screen rows.'
display '*** Copy COBOL contain ' wNumSourceRow ' source statements.'
display '*** Ok. End of work.'
display space.

close FILEINP FILEOUT
goback.

*>****************************************************************
*>
*>****************************************************************
Accept-File-Names.
  display 'Input Filename (default [.TXT]) ............: ' with no advancing
  accept FilespecI
  if FilespecI = space go to Accept-File-Names end-if
     inspect FilespecI tallying tally for all '.'
  if tally = 0
     inspect FilespecI replacing first '    ' by '.TXT'
  end-if

  display 'Ouput Filename (default = Input Filename.CPY) ......: ' with no advancing
  accept FilespecO
  if FilespecO = space
     move FilespecI to FilespecO
     inspect FilespecO replacing all 'TXT' by 'CPY' after initial '.'
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
  if wAnswer = 'Y' or 'y' or space
     continue
  else
      display space
      display '... Processing stopped by user.' with no advancing
      display space
      goback
  end-if.
Accept-File-Names-Ex. exit.

End Program GC99SCREENGEN.
