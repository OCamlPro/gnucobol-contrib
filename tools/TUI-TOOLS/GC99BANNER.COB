       >>SOURCE FORMAT IS FREE
IDENTIFICATION DIVISION.
Program-Id. GC99BANNER is INITIAL.
*> ***********************************************************************************
*> GnuCOBOL TT (TUI TOOLS) AND UTILITIES COLLECTION
*> Purpose:    PRINT A BANNER TO A TXT FILE. USEFUL TO PRINT A COVER PAGE BEFORE A REPORT
*> Tectonics:  cobc -x GC99BANNER.COB  (use GnuCOBOL 2.0 or greater)
*> Usage:      call GC99BANNER using BANNER-AREA or insert this COBOL code into your program
*>             some modification will be necessary
*>             this version accept a string at screen and print that string to a TXT file.
*> Parameters:
*> Author:     Eugenio Di Lorenzo - Italia (DILO)
*> License:    Copyright 2017 E.Di Lorenzo - GNU LGPL, 3.0 (or greater)
*> Version:    1.0 2017.10.31
*> Changelog:  1.0 first release.
*> ***********************************************************************************
*>          UTILITY TO PRINT A BANNER / COVER PAGE
*>
*>                       ** ABSTRACT **
*>  This program accept a string and print the string with big characters.
*>  The single Big Character size is 12 x 09 (cols x rows)
*>  this way You can print max 11 caharacters in a report of 132 cols.
*>
*>      +---------------------------------------------------+
*>      ! O                                               O !
*>      ! O                                               O !
*>      ! O                                               O !
*>      ! O                                               O !
*>      ! O   1   2   3   4   5   6   7   8   9  10  11   O !
*>      ! O +---+---+---+---+---+---+---+---+---+---+---+ O !
*>      ! O !   !   !   !   !   !   !   !   !   !   !   ! O !
*>      ! O !   !   !   !   !   !   !   !   !   !   !   ! O !
*>      ! O !   !   !   !   !   !   !   !   !   !   !   ! O !
*>      ! O +---+---+---+---+---+---+---+---+---+---+---+ O !
*>      ! O                                               O !
*>      ! O <----------------- TOT 132 COLs ------------- O !
*>      ! O                                               O !
*>      ! O                                               O !
*>      +---------------------------------------------------+
*>
*>   This program is also useful as a GnuCOBOL Table (Array) management "tutorial"
*>
ENVIRONMENT DIVISION.
CONFIGURATION SECTION.

INPUT-OUTPUT SECTION.
File-Control.
   select STAMPA  assign to  FileSelect
    organization is line sequential
    file status  is STAMPA-FS.

DATA DIVISION.
FILE SECTION.
FD  STAMPA label record is omitted.
01  Report-Row                  PIC X(133).


WORKING-STORAGE SECTION.
01  wAnswer                      pic x(01) value space.
77  FILEPRN                      pic X(22).
01  A                            PIC 99     VALUE 0.
01  ROW                          PIC 99     VALUE 0.
01  wColumn                      PIC 99     VALUE 0.
01  STAMPA-FS                    PIC X(02)  value '00'.
01 FileSelect PIC x(22).

*> .--------------------------------------------------------------.
*> !  PRINT WORK AREA                                             !
*> '--------------------------------------------------------------'
01  WReport-Row.
    03 W-ASA                      PIC X      VALUE SPACE.
    03 wEle-Row                   PIC X(12)  OCCURS 11.
*> .--------------------------------------------------------------.
*> !  STRING TO BE PRINTED                                        !
*> '--------------------------------------------------------------'
01  I-STRING                    PIC 99     VALUE 0.
01  wSTRING.
    03 Skip-Page                 PIC X.
    03 FILLER                    PIC X.
    03 Skip-RowsX.
       05 Skip-Rows              PIC 99.
    03 FILLER                    PIC X.
    03 el1-STRING.
       05 EL-STRING              PIC X      OCCURS 11.
*> .--------------------------------------------------------------.
*> !  TABLE USED TO SEARCH CHARACTER POSITION.                   !
*> !  ITS INDEX IS COPUPLED WITH INDEX OF FOLLOWING TABLE         !
*> !  WHERE THE PROGRAM WILL TAKE BIG CHARACTERS CONFIGURATION    !
*> !  TO BE PRINTED                                               !
*> '--------------------------------------------------------------'
01  COM                          PIC X(40)  VALUE
    ' ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!+-'.
01  TAB-COM            REDEFINES COM.
    03 EL-COM                    PIC X      OCCURS 40 INDEXED BY I-COM.

*> .---------------------------------------------------------------------.
*> !  TABLE WITH BIG CHARACTERS TO BE PRINTED                            !
*> '---------------------------------------------------------------------'
01  I-BIG                        PIC 99     VALUE 0.
01  TAB-BIG.
    03 CHAR-BIG                             OCCURS 11.
       05 EL-BIG                 PIC X(12)  OCCURS 09.


       01  GRAF.
           03 FILLER                    PIC X(108) VALUE SPACE.
           03 FILLER                    PIC X(108) VALUE   '  OOOOOOOOO '
      &                                                    ' OOOOOOOOOOO'
      &                                                    ' OOOO   OOOO'
      &                                                    ' OOOO   OOOO'
      &                                                    ' OOOOOOOOOOO'
      &                                                    ' OOOOOOOOOOO'
      &                                                    ' OOOO   OOOO'
      &                                                    ' OOOO   OOOO'
      &                                                    ' '
           .
           03 FILLER                    PIC X(108) VALUE   ' OOOOOOOOOO '
      &                                                    ' OOOOOOOOOOO'
      &                                                    ' OOOO   OOOO'
      &                                                    ' OOOOOOOOOOO'
      &                                                    ' OOOOOOOOOO '
      &                                                    ' OOOO   OOOO'
      &                                                    ' OOOOOOOOOOO'
      &                                                    ' OOOOOOOOOO '
      &                                                    ' '
           .
           03 FILLER                    PIC X(108) VALUE   '  OOOOOOOOO '
      &                                                    ' OOOOOOOOOOO'
      &                                                    ' OOOO       '
      &                                                    ' OOOO       '
      &                                                    ' OOOO       '
      &                                                    ' OOOO       '
      &                                                    ' OOOOOOOOOOO'
      &                                                    '  OOOOOOOOO '
      &                                                    ' '
           .
           03 FILLER                    PIC X(108) VALUE   ' OOOOOOOOOO '
      &                                                    ' OOOOOOOOOOO'
      &                                                    ' OOOO   OOOO'
      &                                                    ' OOOO   OOOO'
      &                                                    ' OOOO   OOOO'
      &                                                    ' OOOO   OOOO'
      &                                                    ' OOOOOOOOOOO'
      &                                                    ' OOOOOOOOOO '
      &                                                    ' '
           .
           03 FILLER                    PIC X(108) VALUE   ' OOOOOOOOOOO'
      &                                                    ' OOOOOOOOOOO'
      &                                                    ' OOOO       '
      &                                                    ' OOOOOOOOOOO'
      &                                                    ' OOOOOOOOOOO'
      &                                                    ' OOOO       '
      &                                                    ' OOOOOOOOOOO'
      &                                                    ' OOOOOOOOOOO'
      &                                                    ' '
           .
           03 FILLER                    PIC X(108) VALUE   ' OOOOOOOOOOO'
      &                                                    ' OOOOOOOOOOO'
      &                                                    ' OOOO       '
      &                                                    ' OOOOOOOOOOO'
      &                                                    ' OOOOOOOOOOO'
      &                                                    ' OOOO       '
      &                                                    ' OOOO       '
      &                                                    ' OOOO       '
      &                                                    ' '
           .
           03 FILLER                    PIC X(108) VALUE   '  OOOOOOOOO '
      &                                                    ' OOOOOOOOOOO'
      &                                                    ' OOOO       '
      &                                                    ' OOOO       '
      &                                                    ' OOOO  OOOOO'
      &                                                    ' OOOO   OOOO'
      &                                                    ' OOOOOOOOOOO'
      &                                                    '  OOOOOOOOO '
      &                                                    ' '
           .
           03 FILLER                    PIC X(108) VALUE   ' OOOO   OOOO'
      &                                                    ' OOOO   OOOO'
      &                                                    ' OOOO   OOOO'
      &                                                    ' OOOOOOOOOOO'
      &                                                    ' OOOOOOOOOOO'
      &                                                    ' OOOO   OOOO'
      &                                                    ' OOOO   OOOO'
      &                                                    ' OOOO   OOOO'
      &                                                    ' '
           .
           03 FILLER                    PIC X(108) VALUE   '   OOOOOOOO '
      &                                                    '   OOOOOOOO '
      &                                                    '     OOOO   '
      &                                                    '     OOOO   '
      &                                                    '     OOOO   '
      &                                                    '     OOOO   '
      &                                                    '   OOOOOOOO '
      &                                                    '   OOOOOOOO '
      &                                                    ' '
           .
           03 FILLER                    PIC X(108) VALUE   '     OOOOOOO'
      &                                                    '     OOOOOOO'
      &                                                    '       OOOO '
      &                                                    '       OOOO '
      &                                                    '       OOOO '
      &                                                    ' OOOO  OOOO '
      &                                                    ' OOOOOOOOOO '
      &                                                    '  OOOOOOOO  '
      &                                                    '  '
           .
           03 FILLER                    PIC X(108) VALUE   ' OOOO   OOOO'
      &                                                    ' OOOO  OOOO '
      &                                                    ' OOOO OOOO  '
      &                                                    ' OOOOOOOO   '
      &                                                    ' OOOOOOOO   '
      &                                                    ' OOOO OOOO  '
      &                                                    ' OOOO  OOOO '
      &                                                    ' OOOO   OOOO'
      &                                                    '  '
           .
           03 FILLER                    PIC X(108) VALUE   ' OOOO       '
      &                                                    ' OOOO       '
      &                                                    ' OOOO       '
      &                                                    ' OOOO       '
      &                                                    ' OOOO       '
      &                                                    ' OOOO       '
      &                                                    ' OOOOOOOOOOO'
      &                                                    ' OOOOOOOOOOO'
      &                                                    '  '
           .
           03 FILLER                    PIC X(108) VALUE   ' OOOO   OOOO'
      &                                                    ' OOOOO OOOOO'
      &                                                    ' OOOOOOOOOOO'
      &                                                    ' OOOOOOOOOOO'
      &                                                    ' OOOO O OOOO'
      &                                                    ' OOOO   OOOO'
      &                                                    ' OOOO   OOOO'
      &                                                    ' OOOO   OOOO'
      &                                                    '  '
           .
           03 FILLER                    PIC X(108) VALUE   ' OOOO   OOOO'
      &                                                    ' OOOOO  OOOO'
      &                                                    ' OOOOOOOOOOO'
      &                                                    ' OOOOOOOOOOO'
      &                                                    ' OOOO OOOOOO'
      &                                                    ' OOOO  OOOOO'
      &                                                    ' OOOO   OOOO'
      &                                                    ' OOOO   OOOO'
      &                                                    '  '
           .
           03 FILLER                    PIC X(108) VALUE   '  OOOOOOOOO '
      &                                                    ' OOOOOOOOOOO'
      &                                                    ' OOOO   OOOO'
      &                                                    ' OOOO   OOOO'
      &                                                    ' OOOO   OOOO'
      &                                                    ' OOOO   OOOO'
      &                                                    ' OOOOOOOOOOO'
      &                                                    '  OOOOOOOOO '
      &                                                    '  '
           .
           03 FILLER                    PIC X(108) VALUE   ' OOOOOOOOOO '
      &                                                    ' OOOOOOOOOOO'
      &                                                    ' OOOO   OOOO'
      &                                                    ' OOOOOOOOOOO'
      &                                                    ' OOOOOOOOOO '
      &                                                    ' OOOO       '
      &                                                    ' OOOO       '
      &                                                    ' OOOO       '
      &                                                    '  '
           .
           03 FILLER                    PIC X(108) VALUE   '  OOOOOOOOO '
      &                                                    ' OOOOOOOOOOO'
      &                                                    ' OOOO   OOOO'
      &                                                    ' OOOO   OOOO'
      &                                                    ' OOOO   OOOO'
      &                                                    ' OOOO OO OOO'
      &                                                    ' OOOOOOOOOO '
      &                                                    '  OOOOOO OOO'
      &                                                    '  '
           .
           03 FILLER                    PIC X(108) VALUE   ' OOOOOOOOOO '
      &                                                    ' OOOOOOOOOOO'
      &                                                    ' OOOO   OOOO'
      &                                                    ' OOOOOOOOOOO'
      &                                                    ' OOOOOOOOOO '
      &                                                    ' OOOO  OOOO '
      &                                                    ' OOOO   OOOO'
      &                                                    ' OOOO   OOOO'
      &                                                    '  '
           .
           03 FILLER                    PIC X(108) VALUE   '  OOOOOOOOO '
      &                                                    ' OOOOOOOOOOO'
      &                                                    ' OOOO       '
      &                                                    ' OOOOOOOOOO '
      &                                                    '  OOOOOOOOOO'
      &                                                    '        OOOO'
      &                                                    ' OOOOOOOOOOO'
      &                                                    '  OOOOOOOOO '
      &                                                    '  '
           .
           03 FILLER                    PIC X(108) VALUE   ' OOOOOOOOOOO'
      &                                                    ' OOOOOOOOOOO'
      &                                                    '     OOOO   '
      &                                                    '     OOOO   '
      &                                                    '     OOOO   '
      &                                                    '     OOOO   '
      &                                                    '     OOOO   '
      &                                                    '     OOOO   '
      &                                                    ' '
           .
           03 FILLER                    PIC X(108) VALUE   ' OOOO   OOOO'
      &                                                    ' OOOO   OOOO'
      &                                                    ' OOOO   OOOO'
      &                                                    ' OOOO   OOOO'
      &                                                    ' OOOO   OOOO'
      &                                                    ' OOOO   OOOO'
      &                                                    ' OOOOOOOOOOO'
      &                                                    '  OOOOOOOOO '
      &                                                    ' '
           .
           03 FILLER                    PIC X(108) VALUE   ' OOOO   OOOO'
      &                                                    ' OOOO   OOOO'
      &                                                    ' OOOO   OOOO'
      &                                                    ' OOOO   OOOO'
      &                                                    '  OOOO OOOO '
      &                                                    '   OOOOOOO  '
      &                                                    '    OOOOO   '
      &                                                    '     OOO    '
      &                                                    '  '
           .
           03 FILLER                    PIC X(108) VALUE   ' OOOO   OOOO'
      &                                                    ' OOOO   OOOO'
      &                                                    ' OOOO   OOOO'
      &                                                    ' OOOO O OOOO'
      &                                                    ' OOOOOOOOOOO'
      &                                                    ' OOOOOOOOOOO'
      &                                                    ' OOOOO OOOOO'
      &                                                    '  OOO   OOO '
      &                                                    '  '
           .
           03 FILLER                    PIC X(108) VALUE   ' OOOO   OOOO'
      &                                                    ' OOOO   OOOO'
      &                                                    '  OOOO OOOO '
      &                                                    '   OOOOOOO  '
      &                                                    '   OOOOOOO  '
      &                                                    '  OOOO OOOO '
      &                                                    ' OOOO   OOOO'
      &                                                    ' OOOO   OOOO'
      &                                                    '  '
           .
           03 FILLER                    PIC X(108) VALUE   ' OOOO   OOOO'
      &                                                    ' OOOO   OOOO'
      &                                                    ' OOOO   OOOO'
      &                                                    '  OOOOOOOOO '
      &                                                    '   OOOOOOO  '
      &                                                    '    OOOOO   '
      &                                                    '    OOOOO   '
      &                                                    '    OOOOO   '
      &                                                    '  '
           .
           03 FILLER                    PIC X(108) VALUE   ' OOOOOOOOOOO'
      &                                                    ' OOOOOOOOOOO'
      &                                                    '       OOOO '
      &                                                    '     OOOOO  '
      &                                                    '   OOOOO    '
      &                                                    '  OOOOO     '
      &                                                    ' OOOOOOOOOOO'
      &                                                    ' OOOOOOOOOOO'
      &                                                    '  '
           .
           03 FILLER                    PIC X(108) VALUE   '   OOOOOOO  '
      &                                                    '  OOOOOOOOO '
      &                                                    ' OOOO   OOOO'
      &                                                    ' OOOO OOOOOO'
      &                                                    ' OOOOOO OOOO'
      &                                                    ' OOOO   OOOO'
      &                                                    '  OOOOOOOOO '
      &                                                    '   OOOOOOO  '
      &                                                    '  '
           .
           03 FILLER                    PIC X(108) VALUE   '    OOOOO   '
      &                                                    '   OOOOOO   '
      &                                                    '  OOOOOOO   '
      &                                                    '     OOOO   '
      &                                                    '     OOOO   '
      &                                                    '     OOOO   '
      &                                                    '   OOOOOOOO '
      &                                                    '   OOOOOOOO '
      &                                                    '  '
           .
           03 FILLER                    PIC X(108) VALUE   '  OOOOOOOOO '
      &                                                    ' OOOOOOOOOOO'
      &                                                    ' OOO   OOOOO'
      &                                                    '      OOOO  '
      &                                                    '    OOOOO   '
      &                                                    '  OOOOO     '
      &                                                    ' OOOOOOOOOOO'
      &                                                    ' OOOOOOOOOOO'
      &                                                    '  '
           .
           03 FILLER                    PIC X(108) VALUE   '  OOOOOOOOO '
      &                                                    ' OOOOOOOOOOO'
      &                                                    ' OOO   OOOOO'
      &                                                    '      OOOOO '
      &                                                    '      OOOOO '
      &                                                    ' OOO   OOOOO'
      &                                                    ' OOOOOOOOOOO'
      &                                                    '  OOOOOOOOO '
      &                                                    '  '
           .
           03 FILLER                    PIC X(108) VALUE   '     OOOOO  '
      &                                                    '    OO OOOO '
      &                                                    '   OOO OOOO '
      &                                                    '  OOO  OOOO '
      &                                                    ' OOO   OOOO '
      &                                                    ' OOOOOOOOOOO'
      &                                                    '  OOOOOOOOOO'
      &                                                    '       OOOO '
      &                                                    '  '
           .
           03 FILLER                    PIC X(108) VALUE   ' OOOOOOOOOOO'
      &                                                    ' OOOOOOOOOOO'
      &                                                    ' OOOO       '
      &                                                    ' OOOOOOOOOO '
      &                                                    '  OOOOOOOOOO'
      &                                                    '        OOOO'
      &                                                    ' OOOOOOOOOOO'
      &                                                    '  OOOOOOOOO '
      &                                                    '  '
           .
           03 FILLER                    PIC X(108) VALUE   '  OOOOOOOOO '
      &                                                    ' OOOOOOOOOOO'
      &                                                    ' OOOO       '
      &                                                    ' OOOOOOOOOO '
      &                                                    ' OOOO   OOOO'
      &                                                    ' OOOO   OOOO'
      &                                                    ' OOOOOOOOOOO'
      &                                                    '  OOOOOOOOO '
      &                                                    '  '
           .
           03 FILLER                    PIC X(108) VALUE   ' OOOOOOOOOOO'
      &                                                    ' OOOOOOOOOOO'
      &                                                    '       OOOOO'
      &                                                    '      OOOOO '
      &                                                    '     OOOOO '
      &                                                    '    OOOOO   '
      &                                                    '   OOOOO    '
      &                                                    '  OOOOOO    '
      &                                                    '  '
           .
           03 FILLER                    PIC X(108) VALUE   '  OOOOOOOOO '
      &                                                    ' OOOOOOOOOOO'
      &                                                    ' OOOO   OOOO'
      &                                                    '  OOOOOOOOO '
      &                                                    ' OOOOOOOOOOO'
      &                                                    ' OOOO   OOOO'
      &                                                    ' OOOOOOOOOOO'
      &                                                    '  OOOOOOOOO '
      &                                                    '  '
           .
           03 FILLER                    PIC X(108) VALUE   '  OOOOOOOOO '
      &                                                    ' OOOOOOOOOOO'
      &                                                    ' OOOO   OOOO'
      &                                                    ' OOOO   OOOO'
      &                                                    '  OOOOOOOOOO'
      &                                                    '        OOOO'
      &                                                    ' OOOOOOOOOOO'
      &                                                    '  OOOOOOOOO '
      &                                                    '  '
           .
           03 FILLER                    PIC X(108) VALUE   '    OOOOO   '
      &                                                    '    OOOOO   '
      &                                                    '    OOOOO   '
      &                                                    '    OOOOO   '
      &                                                    '    OOOOO   '
      &                                                    '    OOOOO   '
      &                                                    '            '
      &                                                    '    OOOOO   '
      &                                                    '    OOOOO  '
           .
           03 FILLER                    PIC X(108) VALUE   '    OOOOO   '
      &                                                    '    OOOOO   '
      &                                                    '    OOOOO   '
      &                                                    'OOOOOOOOOOOO'
      &                                                    'OOOOOOOOOOOO'
      &                                                    '    OOOOO   '
      &                                                    '    OOOOO   '
      &                                                    '    OOOOO   '
      &                                                    '    OOOOO '
           .
           03 FILLER                    PIC X(108) VALUE   '            '
      &                                                    '            '
      &                                                    '            '
      &                                                    'OOOOOOOOOOOO'
      &                                                    'OOOOOOOOOOOO'
      &                                                    '            '
      &                                                    '            '
      &                                                    '            '
      &                                                    '   '
           .
       01  TAB-GRAF                     REDEFINES GRAF.
           03 EL-GRAF                   PIC X(108) OCCURS 40
                                        INDEXED BY I-GRAF.

      01  Banner-Area.
   *>
   *> PARAMETER DESCRIPTION
   *> --------- ----------------------------------------------------
   *> FileName  File Name where the Banner has to be printed.
   *> String    This file contains the string used to make the Banner
   *> SkipPage  if = Y the the program will go to a new page before
   *>           printing the Banner
   *> Skip-Rows Number of Rows will be skipped in th epage before
   *>           printing the Banner
         03 Bann-FileName   pic x(22) value spaces.
         03 Bann-String     pic x(11) value spaces.  *> max 11 characters
         03 Bann-SkipPage   pic x(01) value 'N'.
         03 Bann-Skip-Rows  pic 9(02) value zeroes.


*> .--------------------------------------------------------------.
*> !                                                              !
*> '--------------------------------------------------------------'
LINKAGE SECTION.
*> COPY 'GC99BANNER.CPY'.



*> .--------------------------------------------------------------.
*> !                     PROCEDURE DIVISION                       !
*> '--------------------------------------------------------------'
PROCEDURE DIVISION . *> USING Banner-Area.

   *> move Bann-FileName     to        FILEPRN.
   move "12345678901" to Bann-String.
   move 4 to Bann-Skip-Rows .
   move 'GC99BANNER.TXT' to Bann-Filename.


   move    Bann-FileName to FileSelect.
   Perform Accept-String thru Accept-String-Ex
   *> this version of the program ACCEPT a string at screen from user just to show how it works

   INITIALIZE                       wSTRING.
   move Bann-String       to        el1-STRING.
   move Bann-SkipPage     to        Skip-Page.
   move Bann-Skip-Rows    to        Skip-Rows.

   IF   wSTRING = spaces
        THEN go to FINE.

   OPEN OUTPUT STAMPA.
    if STAMPA-FS NOT = '00'
      *> or '41' or '37'
      display '                                *'
      display '...Error writing !!             *'
      display '...FILE STATUS:  ' STAMPA-FS
      accept omitted
      go to FINE.

*>------------- CHECK FOR SKIP A PAGE OR SKIP SOME EROWS -------


   IF Skip-Page = 'Y'
      move spaces to Report-Row
      write Report-Row after advancing page.
   if Skip-Rows is numeric
      move spaces to Report-Row
      write Report-Row   after advancing Skip-Rows lines.
*> .--------------------------------------------------------------.
*> ! SCAN CHARACTERS INTO THE STRING AND SET BANNER AREA          !
*> '--------------------------------------------------------------'

   MOVE 1 TO   I-STRING I-BIG.

FIND-CHAR.
*> .--------------------------------------------------------------.
*> ! SI RICERCA IL CARATTERE DI EL-STRING NELLA TABELLA DI EL-   !
*> ! COMODO E SE TROVATO SI MUOVE LA CONFIGURAZIONE GRAFICA DI    !
*> ! CARATTERI CORRISPONDENTE NELL'AREA DA STAMPARE.              !
*> '--------------------------------------------------------------'
   SET I-COM    TO 1.
   SET I-GRAF   TO 1.
   SEARCH EL-COM    VARYING I-GRAF
          AT END MOVE ALL '?'         TO  CHAR-BIG (I-BIG)
          WHEN  EL-COM (I-COM)        = EL-STRING (I-STRING)
                MOVE EL-GRAF (I-GRAF) TO  CHAR-BIG (I-BIG).

   ADD  1          TO  I-BIG.
   ADD  1          TO  I-STRING.
   IF   I-STRING < 12 GO TO FIND-CHAR.
*> .--------------------------------------------------------------.
*> !  STAMPA DELL'AREA DOVE SONO LE CONFIGURAZIONI GRAFICHE       !
*> '--------------------------------------------------------------'

   MOVE 1 TO ROW.

NEW-Report-Row.
   MOVE 1 TO wColumn.

NEW-wColumn.
   MOVE EL-BIG (wColumn ROW) TO wEle-Row (wColumn).
   ADD  1 TO wColumn.
   IF wColumn < 12 GO TO NEW-wColumn.

   WRITE    Report-Row FROM WReport-Row AFTER ADVANCING 1 LINE.

   ADD 1 TO ROW.
   IF  ROW < 10 GO TO NEW-Report-Row.

   display 'Banner printed to FILE: ' Bann-FileName.
   display 'Use NOTEPAD to see the BANNER. ' .

   CLOSE STAMPA.

*> .--------------------------------------------------------------.
*> !                     END OF PROGRAM                           !
*> '--------------------------------------------------------------'
FINE.
   GOBACK.

*>****************************************************************
*>
*>****************************************************************
Accept-String.
     display 'Type a string (MAX 11 characters) ............: ' with no advancing
     accept Bann-String
     if Bann-String = space go to Accept-String end-if

     Inspect Bann-String converting 'abcdefghijklmnopqrstuvwxyz' to 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'.
     display space
     display 'String =  ' Bann-String
     display 'continue (Y/N) ? .....: ' with no advancing
     accept  wAnswer

     if wAnswer = 'Y' or 'y'
        continue
     else
        display space
        display '... Process ended by the user.' with no advancing
        display space
        stop run
     end-if.
Accept-String-Ex. Exit.


End Program GC99BANNER.
