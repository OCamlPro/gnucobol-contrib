         >>SOURCE FORMAT IS FREE
IDENTIFICATION DIVISION.
Program-Id. GC71CRUDESEL is INITIAL program.
*> ***********************************************************************************
*> GnuCOBOL TT (TUI TOOLS) COLLECTION
*> Purpose:    CRUDE APPLICATION - SELECTION OF A FILE
*> Tectonics:  cobc -m GC71CRUDESEL.COB  (use GnuCOBOL 2.0 or greater)
*> Usage:      call GC71CRUDESEL using LnkFunction
*> Parameters: LnkFunction
*> Author:     Eugenio Di Lorenzo - Italia (DILO)
*> License:    Copyright 2017 E.Di Lorenzo -GNU LGPL , 3.0 (or greater)
*> Version:    1.0 2017.03.01
*> Changelog:  1.0 first release.
*> ***********************************************************************************
DATA DIVISION.
Working-Storage Section.
01 blue    constant as 1.
01 green   constant as 2.
01 cyan    constant as 3.
01 red     constant as 4.
01 magenta constant as 5.
01 yellow  constant as 6.
01 white   constant as 7.
01 black   constant as 0.

01  Key-Escape      pic 9(3) value 027.
*> Values that may be returned in CRT STATUS (or COB-CRT-STATUS)
78  K-ENTER       VALUE 0000.
78  K-UP          VALUE 2003.
78  K-DOWN        VALUE 2004.
78  K-LEFT        VALUE 2009.
78  K-RIGHT       VALUE 2010.
78  K-ESC         VALUE 2005.
78  K-TAB         VALUE 2007.
78  K-BACKTAB     VALUE 2008.
78  K-PAGEUP      VALUE 2001.
78  K-PAGEDOWN    VALUE 2002.
78  K-ESCAPE      VALUE 2005.

01 GC71CRUDEBRO PIC X(12) VALUE 'GC71CRUDEBRO'. *> List of data records
01 GC71CRUDECUD PIC X(12) VALUE 'GC71CRUDECUD'. *> Create, Update, delete of data records

1 DescOperazione  pic x(015).
1 DescKeyAttiva   pic x(015).

01  LnkKey          pic 9(006) value zero.
01  LnkKeyActive    pic x(001) value '3'.
01  LnkFileName     pic x(012) value 'ANAGE---.DAT'.

 01  wMenu1 pic  x(80) value
         ' Enter=Select CursorKeys PgUp/Dn Tab/Backtab Spacebar ESC=Exit                  '.
 *>       12345678901234567890123456789012345678901234567890123456789012345678901234567890
 *>                1         2         3         4         5         6         7


COPY 'GC09BUTTONS.CPY'.
COPY 'GC01BOX.CPY'.

LINKAGE SECTION.
01  LnkFunction   pic x(001).

*> **************************************************************
*>           P R O C E D U R E   D I V I S I O N
*> **************************************************************
PROCEDURE DIVISION using LnkFunction.

FileSelection.
   *> background box
   move '002001024080' to Box-rc
   set Box-bco to green Move 'N' to Box-3D
   CALL GC01BOX USING BY CONTENT BOX-AREA

   evaluate LnkFunction
      when 'C' move 'CREATE       ' to DescOperazione
      when 'R' move 'READ (BROWSE)' to DescOperazione
      when 'U' move 'UPDATE       ' to DescOperazione
      when 'D' move 'DELETE       ' to DescOperazione
   end-evaluate

   evaluate LnkKeyActive
      when '1' move 'AGENT CODE     ' to DescKeyAttiva
      when '2' move 'FISCAL CODE    ' to DescKeyAttiva
      when '3' move 'NAME           ' to DescKeyAttiva
   end-evaluate

   display ' C.R.U.DE. APPLICATION                                                          '
                  at 0101 with Background-Color green Foreground-Color white highlight
   display wMenu1 at 2501 with background-color green foreground-color white highlight


   display ' Operation: '        at 0132 with  Background-Color green Foreground-Color white
           DescOperazione        at 0144 with  Background-Color green Foreground-Color white

   if LnkFunction not = 'C'
      display ' Order by: '       at 0160 with  Background-Color green Foreground-Color white
              DescKeyAttiva(1:8)  at 0171 with  Background-Color green Foreground-Color white
   end-if


   *> ********************************************************
   *> SELECTION OF A FILE
   *> ********************************************************
   move '004017023065' to Box-rc
   set Box-bco to white
   CALL GC01BOX USING BY CONTENT BOX-AREA

   move 'E'   to box-3d
   move 'Y' to Bu-Click bu-Shadow
   display '   SELECT A COMPANY   ' at 005031 with  background-Color white foreground-Color red
   move '15007031     Company ALIVE      '  & x'00' to Bu-Ele(01)
   move ' 5009031    Company BERRIES     '  & x'00' to Bu-Ele(02)
   move ' 5011031    Company BEVERAGE    '  & x'00' to Bu-Ele(03)
   move ' 5013031    Company DOLLARS     '  & x'00' to Bu-Ele(04)
   move ' 5015031     Company GREAT      '  & x'00' to Bu-Ele(05)
   move ' 5017031     Company ITALY      '  & x'00' to Bu-Ele(06)
   move ' 5019031     Company KING''S     ' & x'00' to Bu-Ele(07)
   move ' 5021031     Company VISION     '  & x'00' to Bu-Ele(08)
   CALL GC09BUTTONS using Buttons-Area

   If bu-Key = Key-Escape go Esci end-if

   evaluate Bu-selected
    when 1 move 'ALI' to LnkFileName(6:3)
    when 2 move 'BER' to LnkFileName(6:3)
    when 3 move 'BEV' to LnkFileName(6:3)
    when 4 move 'DOL' to LnkFileName(6:3)
    when 5 move 'GRE' to LnkFileName(6:3)
    when 6 move 'ITA' to LnkFileName(6:3)
    when 7 move 'KIN' to LnkFileName(6:3)
    when 8 move 'VIS' to LnkFileName(6:3)
   end-evaluate

   evaluate LnkFunction
    *> Create / insert a record
    when 'C'
     call   GC71CRUDECUD using LnkFileName LnkFunction LnkKey LnkKeyActive
     cancel GC71CRUDECUD
    *> Browse (Read) list of records
    when 'R'
     call   GC71CRUDEBRO using LnkFileName
     cancel GC71CRUDEBRO
   end-evaluate

   go FileSelection
   .
ESCI.
   Goback.
