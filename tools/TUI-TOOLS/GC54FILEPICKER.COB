       >>SOURCE FORMAT IS FREE
       REPLACE ==:BCOL:== BY ==with BACKGROUND-COLOR==
               ==:FCOL:== BY ==FOREGROUND-COLOR== .
IDENTIFICATION DIVISION.
program-id. GC54FILEPICKER is initial.
*> ***********************************************************************************
*> GnuCOBOL TT (TUI TOOLS) COLLECTION
*> Purpose:    list FILES in a window on screen and let the user browse & pick-up one
*> ***********************************************************************************
*>             works only on WINDOWS operating systems
*>             adapt this cobol source to be used on UNIX operating systems
*> ***********************************************************************************
*> Tectonics:  cobc -m GC54FILEPICKER.COB  (use GnuCOBOL 2.0 or greater)
*> Usage:      call GC54FILEPICKER using FilePicker-Area
*> Parameters: look at GC54FILEPICKER.CPY
*> Dpendencies:GC54FILEPICKER call to GC26LISTVIEW
*>             GC26LISTVIEW   call to GC02BOXMEX, GC01BOX
*>             GC02BOXMEX     call to GC01BOX
*> Author:     Eugenio Di Lorenzo - Italia (DILO)
*> License:    Copyright 2018 E.Di Lorenzo - LGPL, 3.0 (or greater)
*> Version:    1.1 2018.12.16  with GC54FILEPICKER.CPY version 1.1
*> Changelog:  1.0 first release.
*>             1.1 a different text message when slection is not on a file name
*>                 a new parameter Fip-Path at initial call
*>                 a new parameter Fip-PtrCursor added (cursor position at first call)
*> ***********************************************************************************
ENVIRONMENT DIVISION.
Configuration Section.
REPOSITORY.
    FUNCTION ALL INTRINSIC.

INPUT-OUTPUT SECTION.
FILE-CONTROL.
     select FILETEMP
            assign                 to FILETEMP-FSPEC
            organization           is line sequential
            file status            is FILETEMP-FS.

*> **************************************************************
*>           D A T A     D I V I S I O N
*> **************************************************************
DATA DIVISION.
FILE SECTION.
FD  FILETEMP.
01  FILETEMP-REC   pic X(1000).

WORKING-STORAGE SECTION.

01  FILETEMP-FSPEC  pic x(40).
01  FILETEMP-FS     pic x(02).

01  wFILETEMP-EOF   pic x(02) value space.
    88 FILETEMP-EOF value 'T' false 'F'.

01 black   constant as 0.
01 blue    constant as 1.
01 green   constant as 2.
01 cyan    constant as 3.
01 red     constant as 4.
01 magenta constant as 5.
01 yellow  constant as 6.  *> or Brown
01 white   constant as 7.

01  wRETURN-CODE      PIC 9999 VALUE 0000.
01  wDIR-Ind          pic 9999 value zero.
01  wDIR.
    03 wDir-Ele occurs 256 pic X.
01  wCmdLine          pic x(0256) VALUE SPACE.
01  wSTRING           pic x(0060) VALUE SPACE.
01  ws-KEY            PIC 9(04) VALUE 9999.
01  wTitle            pic x(80) VALUE ALL '_'.
01  wDummy            pic x(01) VALUE     ' '.


 COPY 'GC01BOX.CPY'.
 COPY 'GC26LISTVIEW.CPY'.
 COPY 'GC98KEYCODE.CPY'.

LINKAGE SECTION.
COPY 'GC54FILEPICKER.CPY'.
*> ***********************************************************************************
*>           P R O C E D U R E   D I V I S I O N
*> ***********************************************************************************
PROCEDURE DIVISION using FilePicker-Area.
  *> sets in order to detect the PgUp, PgDn, PrtSc(screen print), Esc keys,
  set environment 'COB_SCREEN_EXCEPTIONS' TO 'Y'.
  set environment 'COB_SCREEN_ESC'        TO 'Y'.

  move ' You can''t select this element !    ' to Fip-NoSelTxt-Ele(03)

  move 'FILETEMP.TXT'       TO FILETEMP-FSPEC
  call 'CBL_DELETE_FILE' using FILETEMP-FSPEC

  if   Fip-Path = space
       string ' DIR > FILETEMP.TXT ' X'00' INTO wCmdLine
  else
       string  ' DIR '            delimited by size
               Fip-Path           delimited by space
               ' > FILETEMP.TXT ' delimited by size
               X'00'              delimited by size  INTO wCmdLine
       end-string
  end-if

  *> FIST CALL TO SYSTEM
  perform Call-System thru Call-SystemEx
  continue.

Loop1.
  set Fip-Idx      to zero
  set FILETEMP-EOF to false

  move space to Fip-Tab

  open input FILETEMP
  if FILETEMP-FS not = '00'
     string '... error 03 FILETEMP-FS = ' FILETEMP-FS  into wSTRING
     display wSTRING  at 001001 :BCOL: 4 :FCOL: 7
     accept omitted
     stop run
  end-if
  perform until FILETEMP-EOF or Fip-Idx > 998
      read FILETEMP
           at end
              set FILETEMP-EOF to true
           not at end
              set Fip-Idx up by 1
              move FILETEMP-REC to Fip-Row(Fip-Idx)
              if FILETEMP-REC(1:1) is numeric
                 move ' ' to Fip-Dis(Fip-Idx)
              else
                 move '1' to Fip-Dis(Fip-Idx)
              end-if
              if Fip-Row(Fip-Idx) (37:2) = '..'
                 move '<-- SELECT TO GO UP !' to Fip-Row(Fip-Idx) (41:)
              end-if
      end-read
  end-perform
  close FILETEMP
  call 'CBL_DELETE_FILE' using FILETEMP-FSPEC
  if RETURN-CODE not = zero
       move RETURN-CODE to wRETURN-CODE
       string '... error 04 RETURN-CODE= ' wRETURN-CODE    into wSTRING
       display wSTRING  at 001001 :BCOL: 4 :FCOL: 7
       accept omitted
       stop run
  end-if

  *> set default parameters
  move '005004' to Fip-r1c1
  move 120      to Fip-TabNumCols
  move Fip-Idx  to Fip-TabNumRows
  if Fip-Idx > 16
     move 016     to Fip-WinNumRows
  else
     move Fip-Idx to Fip-WinNumRows
  end-if
  move 060      to Fip-WinNumCols

  move Fip-Parameters  to Lv-Parameters
  move Fip-Parameters2 to Lv-Parameters2
  move Fip-NoSelTxt    to Lv-NoSelTxt
  call GC26LISTVIEW using ListView-Area end-call
  move Lv-Selected to Fip-Selected
  move Lv-Key      to Fip-Key

  if Fip-Key = Key-Escape go End-Program end-if

  *> store whole path in memory
  move Fip-Row(4) (15:100)  to wDIR
  move space                to wCmdLine

  if Fip-Row(Fip-Selected) (22:5) = '<DIR>'               *> IF SELECTED A DIRECTORY ...
       if Fip-Row(Fip-Selected) (37:2) = '..'             *> GO DIRECTORY UP
            perform DirectoryUp thru DirectoryUpEx
            string ' DIR '            delimited by size
                   wDIR (01:60)       delimited by space
                   '\*.*'             delimited by size
                   ' > FILETEMP.TXT ' delimited by size
                   X'00'              delimited by size into wCmdLine
            end-string
       else                                                *> GO DIRECTORY DOWN
          if wDir = 'C:\'
            string ' DIR '             delimited by size
                    wDIR (01:60)       delimited by space
                    Fip-Row(Fip-Selected) (37:20) delimited by space
                    ' > FILETEMP.TXT ' delimited by size
                    X'00'              delimited by size  inTO wCmdLine
            end-string
           else
            string ' DIR '             delimited by size
                    wDIR (01:60)       delimited by space
                    '\'                delimited by size
                    Fip-Row(Fip-Selected) (37:20) delimited by space
                    ' > FILETEMP.TXT ' delimited by size
                    X'00'              delimited by size  inTO wCmdLine
            end-string
          end-if
       end-if
       perform Call-System thru Call-SystemEx
       go to Loop1
  end-if

  continue.
End-Program.

  move Fip-Row(Fip-Selected) (37:25) to Fip-FileName
  goback.

*> *************************************************************
*>                P R O G R A M     R O U T I N E S
*> *************************************************************
DirectoryUp.
    move 256 to wDir-Ind
    continue.
DirectoryUpLoop.
    if wDir-Ele(wDir-Ind) = '\'
       move space to wDir-Ele(wDir-Ind)
       go to DirectoryUpEx
    else
       move space to wDir-Ele(wDir-Ind)
       compute wDir-Ind = wDir-Ind - 1
       go to DirectoryUpLoop
    end-if
    continue.
DirectoryUpEx. exit.

Call-System.
       *> display '                                                      ' at 0101
       *> display wCmdLine at 0101
       *> accept omitted
       call 'SYSTEM' using wCmdLine
       move space to wCmdLine
       continue.
Call-SystemEx.
