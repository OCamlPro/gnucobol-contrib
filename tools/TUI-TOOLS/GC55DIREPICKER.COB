       >>SOURCE FORMAT IS FREE
       REPLACE ==:BCOL:== BY ==with BACKGROUND-COLOR==
               ==:FCOL:== BY ==FOREGROUND-COLOR== .
IDENTIFICATION DIVISION.
program-id. GC55DIREPICKER is initial.
*> ***********************************************************************************
*> GnuCOBOL TT (TUI TOOLS) COLLECTION
*> Purpose:    list Directory TREE in a window on screen. Let the user browse & pickup a DIR
*> ***********************************************************************************
*>             works only on WINDOWS operating systems
*>             adapt this cobol source to be used on UNIX operating systems
*> ***********************************************************************************
*> Tectonics:  cobc -m GC55DIREPICKER.COB  (use GnuCOBOL 2.0 or greater)
*> Usage:      call GC55DIREPICKER using FilePicker-Area
*> Parameters: look at GC55DIREPICKER.CPY
*> Dpendencies:GC55DIREPICKER call to GC26LISTVIEW
*>             GC26LISTVIEW   call to GC02BOXMEX, GC01BOX
*>             GC02BOXMEX     call to GC01BOX
*> Author:     Eugenio Di Lorenzo - Italia (DILO) - eugenio.dilo@gmail.com
*> License:    Copyright 2018 E.Di Lorenzo - LGPL, 3.0 (or greater)
*> Version:    1.0 2018.12.31  with GC55DIREPICKER.CPY version 1.0
*> Changelog:  1.0 first release.
*> ***********************************************************************************
ENVIRONMENT DIVISION.

CONFIGURATION SECTION.
REPOSITORY.
    FUNCTION ALL INTRINSIC.

INPUT-OUTPUT SECTION.
FILE-CONTROL.
     *> contains dicetory file list to be displayed on screen
     select DIRETEMP
            assign                 to DIRETEMP-FSPEC
            organization           is line sequential
            file status            is DIRETEMP-FS.

*> **************************************************************
*>           D A T A     D I V I S I O N
*> **************************************************************
DATA DIVISION.

FILE SECTION.
FD  DIRETEMP.
01  DIRETEMP-REC   pic X(0512).

WORKING-STORAGE SECTION.

01 wDire1   pic x(512) value space.
01 wDire2   pic x(512) value space.
01 wDire3   pic x(512) value space.
01 wDire4   pic x(512) value space.
01 wDire5   pic x(512) value space.
01 wDire6   pic x(512) value space.
01 wDire7   pic x(512) value space.
01 wDire8   pic x(512) value space.
01 wDire9   pic x(512) value space.
01 wDireLiv pic 9(002) value zero.
01 wDir-Tab3           value space.
   03 wDir-Ele3        occurs 999 indexed by wDir-Idx3.
      05 wDir-Path3    pic x(256).
01  wDir-Idx           pic 9999 value zero.

01  DIRETEMP-FSPEC     pic x(40).
01  DIRETEMP-FS        pic x(02).

01  wDIRETEMP-EOF      pic x(02) value space.
    88 DIRETEMP-EOF    value 'T' false 'F'.

01 black   constant as 0.
01 blue    constant as 1.
01 green   constant as 2.
01 cyan    constant as 3.
01 red     constant as 4.
01 magenta constant as 5.
01 yellow  constant as 6.  *> or Brown
01 white   constant as 7.

01  wLenght           PIC 9(009) VALUE 128.
01  wBuffer           PIC x(128) VALUE space.
01  wRETURN-CODE      PIC 9999 VALUE 0000.
01  wDIR-Ind          pic 9999 value zero.
01  wDIR.
    03 wDir-Ele occurs 256 pic X.
01  wCmdLine          pic x(0256) VALUE SPACE.
01  wSTRING           pic x(0060) VALUE SPACE.
01  ws-KEY            PIC 9(04) VALUE 9999.
01  wTitle            pic x(80) VALUE ALL '_'.
01  wDummy            pic x(01) VALUE     ' '.
01  wCommandTREE      pic x(20) VALUE     ' TREE '.
01  wOption1          pic x(10) value space.
01  wOption2          pic x(10) value space.

*> SAVE/RESTORE SCREEN VARIABLES
01 wScreenName        PIC X(256).
01 wiScrOk            BINARY-LONG.

  COPY 'GC01BOX.CPY'.
  COPY 'GC26LISTVIEW.CPY'.
  COPY 'GC98KEYCODE.CPY'.

LINKAGE SECTION.
  COPY 'GC55DIREPICKER.CPY'.
*> ***********************************************************************************
*>           P R O C E D U R E   D I V I S I O N
*> ***********************************************************************************
PROCEDURE DIVISION using DirePicker-Area.
  *> sets in order to detect the PgUp, PgDn, PrtSc(screen print), Esc keys,
  set environment 'COB_SCREEN_EXCEPTIONS' TO 'Y'.
  set environment 'COB_SCREEN_ESC'        TO 'Y'.

  move 'DIRETEMP.TXT'       TO DIRETEMP-FSPEC
  call 'CBL_DELETE_FILE' using DIRETEMP-FSPEC

  *> GET the current Directory
  call 'CBL_GET_CURRENT_DIR' using by value 0 by value wLenght by reference wBuffer

  *> if none is requested, start with current Directory
  if Dir-Path = space
     move wBuffer to Dir-Path
  end-if

  continue.
Loop0.
  string  wCommandTREE       delimited by size
          Dir-Path           delimited by space
          ' '                delimited by size
          wOption1           delimited by space
          ' '                delimited by size
          wOption2           delimited by space
          ' > DIRETEMP.TXT ' delimited by size
          X'00'              delimited by size  INTO wCmdLine
  end-string

  *> CALL TO SYSTEM
  perform Call-System thru Call-SystemEx
  continue.

Loop1.
  set Dir-Idx      to zero
  set DIRETEMP-EOF to false

  move space to Dir-Tab

  open input DIRETEMP
  if DIRETEMP-FS not = '00'
     string '... error 01 DIRETEMP-FS on OPEN INPUT = ' DIRETEMP-FS  into wSTRING
     display wSTRING  at 001001 :BCOL: 4 :FCOL: 7
     accept omitted
     stop run
  end-if

  *> *************************************************************
  *> read TEMP file and load table in memory
  *> *************************************************************
  perform until DIRETEMP-EOF or Dir-Idx > 998
      read DIRETEMP
           at end
              set DIRETEMP-EOF to true
           not at end
              set Dir-Idx up by 1
              move DIRETEMP-REC to Dir-Row(Dir-Idx)

              if DIRETEMP-REC(1:1) is alphabetic and DIRETEMP-REC(1:1) not = space
                move '1' to Dir-Dis(Dir-Idx)  *> item not selectable
              else
                 move ' ' to Dir-Dis(Dir-Idx)
                 perform DirectorySet thru DirectorySetEx
              end-if
      end-read
  end-perform

  close DIRETEMP
  call 'CBL_DELETE_FILE' using DIRETEMP-FSPEC
  if RETURN-CODE not = zero
       move RETURN-CODE to wRETURN-CODE
       string '... error 02 RETURN-CODE on DELETE FILE= ' wRETURN-CODE    into wSTRING
       display wSTRING  at 001001 :BCOL: 4 :FCOL: 7
       accept omitted
       stop run
  end-if

  perform ScreenSave    thru ScreenSaveEx

  *> *****************************************
  *> set default parameters ad CALLL LISTVIEW
  *> *****************************************
  move 120             to Dir-TabNumCols
  move Dir-Idx         to Dir-TabNumRows
  if Dir-Idx > 16
     move 016          to Dir-WinNumRows
  else
     move Dir-Idx      to Dir-WinNumRows
  end-if
  move Dir-Parameters  to Lv-Parameters
  move Dir-Parameters2 to Lv-Parameters2
  move Dir-NoSelTxt    to Lv-NoSelTxt
  *> *****************************************
  *> CALLL LISTVIEW
  *> *****************************************
  call GC26LISTVIEW using ListView-Area end-call

  move Lv-Selected to Dir-Selected
  move Lv-Key      to Dir-Key

  *> *******************************************************************************
  *> EXECUTE ACTIONS
  *> *******************************************************************************
  if Dir-Key = Key-Escape go End-Program end-if
  if Dir-Key = Key-Enter  go End-Program end-if

  *> *******************************************************************************
  *> use F4 to go up when the current directory does not have subdirectories
  *> *******************************************************************************
  if Dir-Key = Key-F4
     move Dir-Path to wDir
     perform DirectoryUp thru DirectoryUpEx
     move wDir     to Dir-Path
     go to Loop0
  end-if

  *> ************************************************************
  *> TOGGLE /A for graphics char Vs non graphics chars
  *> ************************************************************
  if Dir-Key = Key-F5
     if wOption1 = space
        move '/A ' to wOption1
     else
        move space to wOption1
     end-if
     go to Loop0
  end-if

  *> ************************************************************
  *> TOGGLE /F to show file or not to show files
  *> ************************************************************
  if Dir-Key = Key-F6
     if wOption2 = space
        move '/F ' to wOption2
     else
        move space to wOption2
     end-if
     go to Loop0
  end-if
  continue.

End-Program.

  move wDir-Path3(Dir-Selected)  to Dir-DireName
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
       call 'SYSTEM' using wCmdLine
       move space to wCmdLine
       continue.
Call-SystemEx.

ScreenSave.
   move Z'GC55DIREPICKERDEMO.TMP' to wScreenName
   call static 'scr_dump' using by reference wScreenName returning wiScrOk end-call.
ScreenSaveEx. Exit.

ScreenRestore.
   call static 'scr_restore' using by reference wScreenName returning wiScrOk end-call
   CALL 'CBL_DELETE_FILE' USING wScreenName.
ScreenRestoreEx. Exit.

*> ******************************************************************************
*> set path name for each tree item in a working storage table
*> ******************************************************************************
DirectorySet.
   set wDir-Idx3 to Dir-Idx
   evaluate true
     when DIRETEMP-REC(05:1) is alphabetic and DIRETEMP-REC(05:1) not = space
        move 1 to wDireLiv
        move DIRETEMP-REC(05:)   to wDire1
        move space to    wDire2 wDire3 wDire4 wDire5 wDire6 wDire7 wDire8 wDire9
        *> two spaces to include directory names with one space (!)
        string '\'    delimited by size
               wDire1 delimited by '  '
          into wDir-Path3(wDir-Idx3)
        end-string

     when DIRETEMP-REC(09:1) is alphabetic and DIRETEMP-REC(09:1) not = space
        move 2 to wDireLiv
        move DIRETEMP-REC(09:)   to wDire2
        move space to          wDire3 wDire4 wDire5 wDire6 wDire7 wDire8 wDire9
        string '\'    delimited by size
               wDire1 delimited by '  '
               '\'    delimited by size
               wDire2 delimited by '  '
          into wDir-Path3(wDir-Idx3)
        end-string

     when DIRETEMP-REC(13:1) is alphabetic and DIRETEMP-REC(13:1) not = space
        move 3 to wDireLiv
        move DIRETEMP-REC(13:)   to wDire3
        move space to                wDire4 wDire5 wDire6 wDire7 wDire8 wDire9
        string '\'    delimited by size
               wDire1 delimited by '  '
               '\'    delimited by size
               wDire2 delimited by '  '
               '\'    delimited by size
               wDire3 delimited by '  '
          into wDir-Path3(wDir-Idx3)
        end-string

     when DIRETEMP-REC(17:1) is alphabetic and DIRETEMP-REC(17:1) not = space
        move 4 to wDireLiv
        move DIRETEMP-REC(17:)   to wDire4
        move space to                      wDire5 wDire6 wDire7 wDire8 wDire9
        string '\'    delimited by size
               wDire1 delimited by '  '
               '\'    delimited by size
               wDire2 delimited by '  '
               '\'    delimited by size
               wDire3 delimited by '  '
               '\'    delimited by size
               wDire4 delimited by '  '
          into wDir-Path3(wDir-Idx3)
        end-string

   end-evaluate
   continue.

DirectorySetEx. Exit.
