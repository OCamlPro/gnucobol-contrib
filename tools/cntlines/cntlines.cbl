       >>source free
*>
*> Counts total lines from all prn files first checking that it is a valid
*> gnucobol report of each program record the line number
*>  at end of each file adds the line number to a total.
*>  IGNORING any lines that have a value lower than the current-cnt
*>  as it is not a Cobol source (may be C or object code etc).
*>
*> Program Assumes NO program is longer than 65,535 lines otherwise field
*>   Src-Lines needs to be changed to binary-long unsigned.
*>  There again who write single program that large on a micro ?
*>
*>  At end of all sources deletes temp file, reports total count and stops.
*>
      program-id.         cntlines.
*>    Author.             V.B.Coen FBCS, FIDM, FIDPM.
*>    Remarks.            Copyright (c) 2025, Vincent B Coen.
*>    Changes.
*> 20/09/25 vbc - 1.0.00  First written.
*> 25/09/25 vbc - 1.0.01  Add activity marker but commented out as not needed
*>                        here.
*>
 environment             division.
 copy  "envdiv.cob".
 REPOSITORY.
     function all intrinsic.
*>
 input-output section.
 file-control.
*> Reads each prn file taken from File-Stream
       select  Input-File  assign  WS-Input-File-Name
                                   organization line sequential
                                   file status FS-Status.
*>
       select  File-Stream assign  "cnt.tmp"
                                   organization line sequential
                                   file status FS-Status.
*>
 data  division.
 file section.
 fd  Input-File.
 01  Input-Rec           pic x(132).
 01  Inp-Rec2.
     03  INP-CountX.
         05  Inp-Count   pic 9(6).
     03  Inp-Copy        pic x.
     03  INP-Rest        pic x(93).    *> to test for spaces | STORED-CHAR-LENGTH = 0
     03  filler          pic x(32).
*>
 fd  File-Stream.
 01  FS-Record.
     03  filler          pic xx.       *> ignore ./
     03  FS-Data         pic x(48).    *> Assumes no folder/filename > 48 & see WS-Input-File-Name.
*>
 working-storage section.
 77  prog-name           pic x(17)    value "cntlines (1.0.01)".
 77  Total-Cnt           Binary-long unsigned value zeros.
 77  Current-Cnt         Binary-long unsigned value zeros.
 77  Disp-Total-Cnt      pic z,zzz,zz9 value zeros.
 77  WS-Input-File-Name  pic x(48).   *> name from cnt-tmp recs
 77  WS-Find-Cmd         pic x(37)    value "find . -name '*.prn' | sort > cnt.tmp".
 77  Saved-Line-No       pic 9(6)     value zero.
*>
 01  WS-Data.
     03  FS-StatusX.                              *>  File status returned from file ops
         05  FS-Status   pic 99.
 *>    03  WS-Stacked-Disp pic x(4)      value "|/-\".
 *>    03  WS-Stacked-Char redefines WS-Stacked-Disp
 *>                        pic x   occurs 4.
 *>    03  A               binary-char   value zero.
 *>
*>
*> For FILE_EXIST intrinsic FUNCTION.
*>
 01  File-Info                          value zero.
     03 File-Size-Bytes  pic 9(18) comp.
     03 Mod-DD           pic 9(2)  comp.
     03 Mod-MO           pic 9(2)  comp.
     03 Mod-YYYY         pic 9(4)  comp.
     03 Mod-HH           pic 9(2)  comp.
     03 Mod-MM           pic 9(2)  comp.
     03 Mod-SS           pic 9(2)  comp.
     03 filler           pic 9(2)  comp. *> Always 00
*>
 procedure division.
*>
 AA000-Init.
     display  Prog-Name at 0101 with erase eos.
     display  space at 0201.
     set      ENVIRONMENT "COB_EXIT_WAIT"  to "N".
     initialise
              Current-Cnt
 *>             A
              Total-Cnt.  *> JIC
     call     "SYSTEM" using WS-Find-Cmd.
     call     "CBL_CHECK_FILE_EXIST" using "cnt.tmp"
                                           File-Info.
     if       return-code not = zero         *> does not exist
        or    File-Size-Bytes = zero
              CALL     "CBL_DELETE_FILE" USING "cnt.tmp"
              display  "No print files (.prn) found - EOJ" at 0310
              move     File-Size-Bytes to Disp-Total-Cnt
              display  Disp-Total-Cnt at 0420
              display  space at 0501
              stop run.
*>
     open     input    File-Stream.
     if       FS-Status not = zeros
              display  "Error - No Stream file found - Aborting" at 0310
              close    File-Stream
              stop run
     end-if
*>
 *>    display  "Active " at 0501.
     perform  forever
              read     File-Stream at end
                       move     Total-Cnt to Disp-Total-Cnt
                       display  "Total Cobol lines found = " at 0301
                       display  Disp-Total-Cnt  at 0326
                       display  space at 0801
                       close    File-Stream
*> rem out the next line if you wish to keep this temp file
                       CALL     "CBL_DELETE_FILE" USING "cnt.tmp"
                       stop run
              end-read
              move     FS-Data to WS-Input-File-Name
              open     input Input-File
              move     zero to Current-Cnt
  *>            add      1 to A
  *>            if       A > 4
  *>                     move     1 to A
  *>            end-if
  *>            display  WS-Stacked-Char (A) at 0508
              perform  forever
                       read     Input-File at end
                                close    Input-File
                                exit perform
                       end-read
                       if       INP-Countx = spaces
                                exit perform cycle
                       end-if
                       if       INP-CountX not numeric
                          or    Inp-Count not numeric
                          or    Inp-CountX > "999999"
                                exit perform cycle
                       end-if
                       if       Inp-CountX = "000001"  *> Reading C or obj junk so quit this one
                          and   Inp-Copy not = "C"     *> Will also not do nested compiles b onwards
                         and    Current-Cnt > 1        *> ie cobc -x a.cbl b.cbl but should be more accurate
                                close    Input-File
                                move     zero to Current-Cnt
                                exit perform
                       end-if
                       add      1 to Current-Cnt
                       add      1 to Total-Cnt
                       exit perform cycle
              end-perform
              exit perform cycle
     end-perform.
*> Should never get here
 *>    close    File-Stream.
     stop   "Houston, we have a problem".
     stop run.
