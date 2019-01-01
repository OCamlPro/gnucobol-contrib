       >>source free
 IDENTIFICATION    DIVISION.
 PROGRAM-ID.       AfldConv1.
 AUTHOR.           V.B.COEN MBCS.
 DATE-WRITTEN.     18th DECEMBER 2018.
 DATE-COMPILED.    TO-DAY.   *> GC does NOT update.
*> Security.       Copyright (C) 2019, Vincent Bryan Coen.
*>                 Distributed under the GNU General Public License
*>                 v2.0. Only. See the file Copying.pdf for details.
*>**
 REMARKS.          Personal Flight Log Book Program data convert
*>                 for change of alfd-name size from 20 to 36 for use
*>                 with flightlog v2.02.00.
*>                 Note that the code base also used for other files
*>                 when required.
*>**
*>  CHANGES.       None.
*>
 ENVIRONMENT        DIVISION.
 CONFIGURATION SECTION.
 SOURCE-COMPUTER.        FX8350.
 OBJECT-COMPUTER.        FX8350.
 SPECIAL-NAMES.
     CONSOLE IS CRT.
*>
 INPUT-OUTPUT        SECTION.
 FILE-CONTROL.
*>
     SELECT AIRFIELD-FILE    ASSIGN       "airfield.dat"   *> New file format.
                             ACCESS       DYNAMIC
                             ORGANIZATION INDEXED
                             STATUS       FS-REPLY
                             RECORD KEY   ICAO-CODE.
     select Airfieldbackup-file                            *> OLD Sequential file
                             assign       "airfield.seq"
                             ORGANIZATION LINE SEQUENTIAL
                             STATUS       FS-REPLY.
*>
 DATA  DIVISION.
 FILE SECTION.
*>
 FD  AIRFIELD-FILE.                             *> NEW FORMAT
 01  AIRFIELD-RECORD.
     03  ICAO-CODE           PIC X(4).
     03  AFLD-Name           pic x(36).
     03  AFLD-Last-Flt       pic 9(8).
*>
 FD  AIRFIELDBackup-FILE.                       *> OLD FORMAT
 01  AIRFIELDBackup-RECORD.
     03  Old-ICAO-CODE           PIC X(4).
     03  Old-AFLD-Name           pic x(20).
     03  Old-AFLD-Last-Flt       pic 9(8).
*>
 WORKING-STORAGE SECTION.
 77  PROG-NAME               PIC X(19) VALUE "AfldConv1 (1.00.00)".  *> For Flightlog 2.02.00 from 2.01 => .34.
 77  WS-Reply                pic x.
 77  FS-REPLY                PIC XX.
 77  A                       pic 999   value zero.
 77  B                       pic 999   value zero.
*>
*> Used for checking for existing data and SEQ files.
*>
 01  Cbl-File-Details.
     03  Cbl-File-Size      pic x(8)       comp-x  value zero.
     03  Cbl-File-Date      pic x(4)       comp-x  value zero.
     03  Cbl-File-time      pic x(4)       comp-x  value zero.
*>
 01  File-Status-Flags                       value zeros.
     03  Flightlog-Dat-Exists pic 9.
     03  Aircraft-Dat-Exists  pic 9.
     03  Airfield-Dat-Exists  pic 9.
     03  Flightlog-Seq-Exists pic 9.
     03  Aircraft-Seq-Exists  pic 9.
     03  Airfield-Seq-Exists  pic 9.
*>
 PROCEDURE DIVISION.
 A000-CONTROL       SECTION.
*>
     display  Prog-Name at 0101 with erase eos.
     display  "Airfield file convert from v2.01 to v2.02" at 0138.
*>
     display  "Make sure you have a back up of your current .dat and .seq files" at 0301.
     display  " as well the current version of Flightlog" at 0401.
     display  "Confirm you have done so - Y or N - [ ]" at 0601.
     move     "N" to WS-Reply.
     accept   WS-Reply at 0638 with update.
     if       WS-Reply not = "Y"
              display "Rerun program when back up completed" at 0810
              goback.
*>
*> As we are using the seq file must exist.
*>
     CALL     "CBL_CHECK_FILE_EXIST" USING "airfield.seq" Cbl-File-Details.
     if       Return-Code = zero
              move 1 to Airfield-Seq-Exists.
*>
     if       AirField-Seq-Exists = zero
              display "Cannot find Airfield.seq - aborting" at 0810 with erase eol
              goback.
*>
*> Rename old airfield dat to bak
*>
     call     "CBL_RENAME_FILE" USING "airfield.dat" "airfield.BAK".
     if       Return-Code not = zero
              display "The rename of airfield.dat to airfield.BAK failed - Aborting" at 0810
              goback.
*>
*> Old .dat file renamed .BAK so nice and safe
*>
     open     output Airfield-File.
     open     input  AIRFIELDBackup-File.
*>
 A010-Read-File-1.
     read     AirfieldBackup-File at end
              go to A900-EOF.
     add      1 to A.
     move     Old-ICAO-CODE     to ICAO-CODE.
     move     Old-AFLD-Name     to AFLD-Name.
     move     Old-AFLD-Last-Flt to AFLD-Last-Flt.
     write    AIRFIELD-RECORD.
     if       FS-Reply not = "00"
              display "Error on writing to Airfield.dat file" at 1010
              display "COPY airfield.BAK to airfield.dat, fix problem and rerun" at 1210
              perform  A900-EOF
              stop run.
     add      1 to B.
     go       to A010-Read-File-1.
*>
 A900-EOF.
     close    AirfieldBackup-File Airfield-File.
*>
 A901-display-Totals.
     display  "Records read    = " at 1601
     display  "Records written = " at 1701.
     display  A                    at 1619.
     display  B                    at 1719.
     display  " File converted"    at 1901.
*>
 A999-EOJ.
     stop run.
*>
