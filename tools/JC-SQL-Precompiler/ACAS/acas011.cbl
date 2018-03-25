       >>source free
*>***********************************************
*>                                              *
*>                    Stock                     *
*>               File/Table Handler             *
*>                                              *
*>  The Program name is taken from the FILE-nn  *
*>       used in the cobol file select.         *
*>***********************************************
*>
 identification division.
 Program-Id.            acas011.
*>**
*> Author.              Vincent B Coen, FBCS, FIDM, FIDPM, CPL
*>                      for Applewood Computers.
*>**
*> Security.            Copyright (C) 2016 - 2018, Vincent Bryan Coen.
*>                      Distributed under the GNU General Public License
*>                      v2.0. Only. See the file COPYING for details.
*>**
*> Remarks.             Stock File Handler.
*>                      ******************
*>                      This and associated modules relate to ACAS versions v3.02 and later.
*>                      --------------------------------------------------- ^^^^^ ---------
*>
*>   WARNING   WARNING   WARNING   WARNING   WARNING   WARNING   WARNING   WARNING   WARNING
*>
*>        This module acas011 (along with stockMT) are the first FH (cobol File Handler for I/O)
*>            and DAL (Data Access Layer) for RDBMS direct I/O processing and these two modules
*>                 are the first modules written (& tested) for the ACAS system and specifically
*>                  for stock control.
*>
*>        Therefore they are the models for all other FH and DALs.
*>          This means that any bugs found in one of them that is NOT file specific code changes
*>            have to be added to all existing other FH and or DAL modules.
*>               This must be done immediately after all changes to any one so that no mods are
*>                    forgotten about.
*>
*>   **************************************** END OF WARNING ********************************
*>
*>                      This modules does all Cobol file handling for the file
*>                                     (Stock File).
*>
*>                      If Cobol Flat files are in use (via the system parameter file settings)
*>                      which is passed via the wsfnctn (via copybook) / File-Access data block
*>                      via the application module and each FH & DAL.
*>                      It will read/write/delete/update/open/close as required and requested.
*>                      NOTE the same fields are used for ALL of the FL and DAL modules so
*>                      checking the error flags have to be done after each call before clearing.
*>
*>                      If RDBMS (Relational DataBase Management Systems) is in use it will call
*>                      the specific module to handle similar processing passing the equivelent
*>                      RDB (Relational DataBase) row as a Cobol file record (01 level) moving
*>                      row by row to the correct Cobol flat file fields as required.
*>                      These retrieve ALL columns and there fore the DAL modules cannot handle
*>                      processing for selective columns, e.g., only updating one field/column
*>                      as the whole record / row must be read or written to/from the RDB table.
*>
*>                      Module naming is based on the File ID variable name and for the Stock
*>                      file which uses file-11  the FH is therefore acas011 - the last two chars
*>                      reflect the same number as last two chars the 'file-nn' name.
*>
*>                      Did it have to be this way ? no but it is easy to see in the original
*>                      code the name in the select statement for the Cobol file.
*>
*>                      RDB DAL (Data Access Layer) modules are individually modified to handle:
*>                      MS SQL server, Mysql, DB2, Postgres and Oracle as available and tested.
*>                      These are contained in seperate directories for each RDB, eg
*>                       'MSSQL' (MS SQL Server), 'Mysql', 'DB2', 'Postgres'. 'Oracle'.
*>                       You need to compile from the correct directory for the specific
*>                       RDB you will use and have installed along with all of the development
*>                       libraries and include files etc using the correct pre-compiler tool
*>                       to process the EXEC SQL code converting to Cobol calls etc.
*>
*>                      For specific SQL servers supported the pre-compiler system is included
*>                       where ever possible but for some, copyright reasons may prevent
*>                       inclusion. In some cases for one specific RDB more than one precompiler
*>                       is used as an experiment to help find the ideal one to use.
*>
*>                      In addition:
*>                        If the system has been set up to (see the System File set up via the
*>                        main menu module for each sub system), also process BOTH flat file
*>                        AND the correct rdb table/s,
*>                        it will write/delete/update etc to both but read from 1=Flat and be
*>                        overwritten by the rdb access. This was set up more for testing the
*>                        new code for both cobol files and the rdb accessing modules.
*>                       This can help in transferring the Cobol flat files to rdb tables but
*>                        see below regarding the Load programs/modules.
*>
*>                      If you wish to convert a running ACAS system over from Flat files
*>                      to RDBMS see below. However it is strongly recommended to not to use
*>                      the Duplicate processing of files/table as outlined above but:
*>
*>                      Included are LM's (Load Modules) to convert each ISAM
*>                      (Indexed Sequential) file to the rdb database tables if you wish to
*>                      convert the system in one hit, without using the Duplicate file/RDB
*>                      processing procedures. These will also need to be compiled from the
*>                      specific LM directory that contains the rdb DAL modules.
*>
*>                      A specific program or bash process will be created to use, that will run
*>                      each LM process for all existing Cobol files. These are created during
*>                      writing of the FH and DAL for each file/table if only to help in testing
*>                      them.
*>**
*> Called Modules:
*>                      stockMT -
*>                                DAL (RDB Data Access Layer) or a variation
*>                      Selected via CDF etc [to be added].
*>
*>**
*> Error Messages Used.
*>
*>                      AC901 Note error and hit return
*>                      AC902 Program Error: Temp rec =yyy < Stock-Rec = zzz
*>**
*> Version.             1.00 29/02/2012. Rewritten June 2016 after creating the DAL.
*>
*>                      This module is the first of the ACAS File Handlers and
*>                      will act as the model for all the others which in turn
*>                      is lightly modelled on the irsub modules for IRS.
*>
*>
*> Changes.
*> 29/02/12 vbc - Created for Gnu Cobol v1.1 & v2.0. Code also to be tested with MF VC
*>                ** UNDER TEST ** but there again every thing is!
*> 17/05/16 vbc - Adding code for log file.
*>                Notes about error messages.
*> 24/06/16 vbc - Minor coding errors with a evaluate.
*> 02/07/16 vbc - .01 Missing DB params in system rec not moved to DB-xx in wsfnctn.
*> 04/08/16 vbc       Moved logging code into a new module to be called
*>                    from here and the stockMT code.
*> 04/08/16 vbc - .02 Test on read for read next at end bypass moves etc.
*> 21/07/16 vbc - .03 Minor tidy up  of code & comments near the call to the DAL.
*>                    Extra module comments and notes.
*> 27/07/16 vbc - .04 Rem'd out some mv zero to fs-reply but don't think it is causing issues, may be
*> 24/10/16 vbc - .   ALL programs now using wsnames.cob in copybooks
*>
*>**
*>  Module USAGE
*>**************
*>
*>    On Entry:         Set up Linkage areas -
*>    ********              1. File and table WS record : -
*>    acas011 ONLY             WS-Stock-Record = Contents of data record to be written/read
*>                          2. File-Access = File-Function as needed.
*>                                        Access-Type   as needed.
*>                          3. File-Defs (File-Definitions) = Paths set up.
*>
*>    On Exit:          Linkage contains and apples to ALL FH and DAL modules:
*>    *******               Record = containing a read data record or table row
*>                          Fs-Reply = 0, 99 or other value where
*>                                     0  = Operation completed successfully
*>                                     10 = End of file
*>                                     21 = Invalid key | key not found
*>                                     99 = Indicates an error see WE-Error for more info
*>                          WE-Error   0    = Operation completed successfully
*>                                     999  = Undefined / unknown error
*>                                     998* = File-Key-No Out Of Range not 1, 2 or 3.
*>                                     997* = Access-Type wrong (< 5 or > 8)
*>                                     996* = File Delete key out of range (not = 1 or 2)
*>                                     995* = During Delete SQLSTATE not '00000' investigate using MSG-Err/Msg
*>                                     994* = During Rewrite,                     ^^ see above ^^
*>                                     990* = Unknown and unexpected error, again ^^ see above ^^
*>                                     989* = Unexpected error on Read-Indexed, investigate as above.
*>                                     911* = Rdb Error during initializing,
*>                                            possibly can not connect to database
*>                                             Check connect data and
*>                                             see SQL-Err & SQL-MSG
*>                                            Produced by Mysql-1100-Db-Error in copy
*>                                            module mysql-procedure.
*>                                     901  = File Def Record size not =< than ws record size
*>                                            Module needs ws definition changing to correct size
*>                                            FATAL, Stop using system, fix source code
*>                                            and recompile before using system again.
*>                                     Other = any other rdbms errors see specific
*>                                             (Rdbms) manual
*>                          SQL-Err  = Error code from RDBMS is set if above 2 are non zero
*>                          SQL-Msg  = Non space providing more info if SQL-Err non '00000'
*>                                     * = FS-Reply = 99.
*>
*>       During testing a log file will be created containing datetime stamp, task and return codes
*>       for both FS-Reply and WE-Error and table used along with the RDB error number and message
*>         In this case for the
*>                Stock File.
*>
*>       WARNING - This file could get large so needs manually deleting after examination.
*>
*>  Programmer note : CONSIDER WRITING A reporting program for this with report selection criteria.
*>
*>******************************************************************************
*>
*> Copyright Notice.
*>*****************
*>
*> This file/program is part of the Applewood Computers Accounting System
*> and is copyright (c) Vincent B Coen. 1976-2018 and later.
*>
*> This program is free software; you can redistribute it and/or modify it
*> under the terms of the GNU General Public License as published by the
*> Free Software Foundation; version 2 ONLY.
*>
*> ACAS is distributed in the hope that it will be useful, but WITHOUT
*> ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
*> FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License
*> for more details. If it breaks, you own both pieces but I will endeavour
*> to fix it, providing you tell me about the problem. See below for my
*> email address to use for this purpose.
*>
*> You should have received a copy of the GNU General Public License along
*> with ACAS; see the file COPYING.  If not, write to the Free Software
*> Foundation, 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA.
*>
*>**********************************************************************************
*>
*> WARNING:
*> *******
*> Some of the RDB handlers (DAL for MS SQL server) are NOT covered under the above
*> GPL but authority to use, WITHOUT the right of ANY FORM OF PAID REDISTRIBUTION
*> is given. HOWEVER, distribution licensing can be offered on a case by case basis.
*>
*> Contact the Lead Programmer at vbcoen@gmail.com with details of your requirements.
*>
*>**********************************************************************************
*>
 environment division.
 copy "envdiv.cob".
*>
 input-output section.
 file-control.
*>
 copy "selstock.cob".
*>
 data division.
 file section.
*>***********
 copy "fdstock.cob".
*>
 working-storage section.
*>**********************
*>
 77  prog-name           pic x(17)    value "acas011 (3.02.04)".
*>
 77  ws-reply           pic x      value space.
*>
 77  A                  pic s9(4)     comp    value zero.  *> A & B used in 1st test ONLY
 77  B                  pic s9(4)     comp    value zero.  *>  in ba-Process-RDBMS
 77  Display-Blk        pic x(75)             value spaces.
 77  Cobol-File-Status  pic 9                 value zero.
     88  Cobol-File-Eof                       value 1.
*>
 01  Error-Messages.
*> System Wide
*> Module Specific
     03  ST901          pic x(31) value "AC901 Note error and hit return".
     03  ST902          pic x(32) value "AC902 Program Error: Temp rec = ".
*>                                        yyy < Stock-Rec = zzz
 *>    03  ST906          pic x(41) value "AC906 Stock File not found, nothing to do".
*>
 Linkage Section.
*>**************
 copy "wsstock.cob".
*>
 copy "wssystem.cob".
*>
 copy "wsfnctn.cob".
*>
*> As this module sits in the common directory we need to get the right one.
*>   although we could use the one in the copybook for ALL systems it's just a
*>    lot larger so wasting RAM.
*>
 copy "wsnames.cob" in "../copybooks".   *> uses the full version.
*>
 copy "Test-Data-Flags.cob".  *> set sw-testing to zero to stop logging.
*>
 Procedure Division Using System-Record

                          WS-Stock-Record

                          File-Access
                          File-Defs
                          ACAS-DAL-Common-data.
*>********************************************
*>
 aa-Process-Flat-File Section.
*>***************************
 aa010-main.
*>
*>  For logging only.
*>
     move     5      to WS-Log-System.   *> 1 = IRS, 2=GL, 3=SL, 4=PL, 5=Stock used in FH logging
     move     12     to WS-Log-File-No.  *> RDB, File/Table
*>
*>   Now Test for valid key for start, read-indexed and delete
*>
     evaluate File-Function
              when  4   *> fn-read-indexed
              when  9   *> fn-start
                if     File-Key-No < 1 or > 3
                       move 998 to WE-Error       *> file seeks key type out of range        998
                       move 99 to fs-reply
                       go   to aa999-main-exit
                end-if
              when     8  *> fn-delete
                if     File-Key-No < 1 or > 2     *> 1 or 2 is only for RDB as Cobol does it on primary key
                       move 996 to WE-Error       *> file seeks key type out of range        996
                       move 99 to fs-reply
                       go   to aa999-main-exit
                end-if
     end-evaluate.
*>
*> Check if data files or RDBMS processing or are we doing both !!
*>
     if       not FS-Cobol-Files-Used
              move RDBMS-Flat-Statuses to FA-RDBMS-Flat-Statuses    *> needed for DAL? not JC/dbpre versions
              go to ba-Process-RDBMS                                *>  Can't hurt
     end-if.
*>
*>  File paths for Cobol File has already done in main menu module
*>
*>******************************************************************************
*> So we are processing Cobol Flat files, as Dup processing, or by themselves. *
*>    if reading, get it but will be overwritten by rdb processing if set,     *
*>      otherwise will write/rewrite/delete etc, to both formats               *
*>******************************************************************************
*>
*>  ?   move     zero   to  WE-Error
 *>  ?                      FS-Reply.
     move     spaces to SQL-Err SQL-Msg SQL-State.
*>
     evaluate File-Function
        when  1
              go to aa020-Process-Open
        when  2
              go to aa030-Process-Close
        when  3
              go to aa040-Process-Read-Next
        when  4
              go to aa050-Process-Read-Indexed
        when  5
              go to aa070-Process-Write
        when  7
              go to aa090-Process-Rewrite
        when  8
              go to aa080-Process-Delete
        when  9
              go to aa060-Process-Start
        when  other                          *> 6 is spare / unused
              go to aa100-Bad-Function
     end-evaluate.
*>
*>  Should never get here but in case :(
     go       to aa100-Bad-Function.
*>
 aa020-Process-Open.
     move     spaces to WS-File-Key.     *> for logging
     move     201 to WS-No-Paragraph.
     if       fn-input
              open input Stock-File
              if   Fs-Reply not = zero
 *>                  display ST906 at 2301 with erase eos
                   move 35 to fs-Reply
                   close Stock-File
                   go to aa999-Main-Exit
              end-if
      else
       if     fn-i-o
              open i-o Stock-File
              if       fs-reply not = zero              *> this block was in st010 at ba000-Setup-Stock
                       close       Stock-File
                       open output Stock-File           *> Doesnt create in i-o
                       close       Stock-File
                       open i-o    Stock-File
              end-if                                      *> file-status will NOT be updated   ????
       else
        if    fn-output                      *> should not need to be used
              open output Stock-File         *> caller should check fs-reply
        else
         if   fn-extend                      *> Must not be used for ISAM files
*>              open extend Stock-File
              move 997 to WE-Error
              move 99  to FS-Reply
              go to aa999-main-exit
         end-if
        end-if
       end-if
     end-if.
*> 27/07/16 16:30     move     zeros to FS-Reply WE-Error.
     move     zero to Cobol-File-Status.
     move     "OPEN STOCK File" to WS-File-Key.
     if       fs-reply not = zero
              move  999 to WE-Error
     go       to aa999-main-exit.            *> with test for dup processing
*>
 aa030-Process-Close.
     move     202 to WS-No-Paragraph.
     move     spaces to WS-File-Key.     *> for logging
     close    Stock-File.
*> 27/07/16 16:30     move     zeros to FS-Reply WE-Error.
     move     zero to Cobol-File-Status.
     move     "CLOSE STOCK File" to WS-File-Key
     perform  aa999-main-exit.
     move     zero to  File-Function
                       Access-Type.              *> close log file
     perform  Ca-Process-Logs.
     go       to aa-main-exit.
*>
 aa040-Process-Read-Next.
*>
*>   Process READs, 1st is read next then read by key This is processed after
*>    Start code as its really Start/Read next
*>
     move     203 to WS-No-Paragraph.
     if       Cobol-File-Eof
              move 10 to FS-Reply
                         WE-Error
              move spaces to Stock-Key
                             SQL-Err
                             SQL-Msg
              stop "Cobol File EOF"               *> for testing
              go to aa999-main-exit
     end-if
*>
     read     Stock-File next record at end
              move 10 to we-error fs-reply        *> EOF
              set Cobol-File-EoF to true
              move 1 to Cobol-File-Status         *> JIC above don't work :)
              initialize Stock-Record
              move "EOF" to WS-File-Key           *> for logging
              go to aa999-main-exit
     end-read.
     if       FS-Reply not = zero
              go to aa999-main-exit.
     move     Stock-Record to WS-Stock-Record.
     move     WS-Stock-Key to WS-File-Key.
     move     zeros to WE-Error.
     go to    aa999-main-exit.
*>
*>   The next block will never get executed unless performed  so is it needed ?
*>
 aa045-Eval-Keys.
     evaluate File-Function      *> Set up keys just for logging
              when  4             *> fn-read-indexed
              when  5             *> fn-write
              when  7             *> fn-re-write
              when  8             *> fn-delete    For delete can ignore Desc key
              when  9             *> fn-start
                    evaluate  File-Key-No
                              when   1
                                     move   WS-Stock-Key       to WS-File-Key
                                                                  Stock-Key
                              when   2
                                     move   WS-Stock-Abrev-Key to WS-File-Key
                                                                  Stock-Abrev-Key
                              when   3
                                     move   WS-Stock-Desc      to WS-File-Key
                                                                  Stock-Desc
                              when   other
                                     move   spaces             to WS-File-Key
                    end-evaluate
              when  other
                    move   spaces             to WS-File-Key
     end-evaluate.
*>
 aa050-Process-Read-Indexed.
*>
*> copy the three possible keys to main file area
*>
     move     204 to WS-No-Paragraph.
     perform  aa045-Eval-keys.
     if       File-Key-No = 1
              read     Stock-File key Stock-Key       invalid key
                       move 21 to we-error fs-reply
              end-read
              if       fs-Reply = zero
                       move     Stock-Record to WS-Stock-Record
                       move     WS-Stock-Key to WS-File-Key
              else
                       move     spaces     to WS-Stock-Record
              end-if
              go       to aa999-main-exit
     end-if.
     if       File-Key-No = 2
              read     Stock-File key Stock-Abrev-Key invalid key
                       move 21 to we-error fs-reply
              end-read
              if       fs-Reply = zero
                       move     Stock-Record to WS-Stock-Record
                       move     WS-Stock-Abrev-Key to WS-File-Key
              else
                       move     spaces to WS-Stock-Record
              end-if
              go       to aa999-main-exit
     end-if.
     if       File-Key-No = 3                           *> can also use start, read next
              read     Stock-File key Stock-Desc      invalid key
                       move 21 to we-error fs-reply
              end-read
              if       fs-Reply = zero
                       move     Stock-Record to WS-Stock-Record
                       move     WS-Stock-Desc to WS-File-Key
              else
                       move     spaces to WS-Stock-Record
              end-if
              go       to aa999-main-exit
     end-if.
     move     998 to WE-Error       *> file seeks key type out of range but should never get here       998
     move     99 to fs-reply
     go       to aa999-main-exit.
*>
 aa060-Process-Start.
*>
*>  Check for Param error 1st on start   WARNING Not logging starts
*>
     move     205 to WS-No-Paragraph.
     perform  aa045-Eval-keys.
     move     zeros to fs-reply
                       WE-Error.
*>
     if       access-type < 5 or > 8                   *> NOT using 'not >'
              move 998 to WE-Error                     *> 998 Invalid calling parameter settings
              go to aa999-main-exit
     end-if
*>
*>  Now do Start primary key before read-next
*>
     if       File-Key-No = 1
        and   fn-equal-to
              start Stock-File key = Stock-Key invalid key
                    move 21 to Fs-Reply
                    go to aa999-main-exit
              end-start
     end-if
     if       File-Key-No = 1
        and   fn-less-than
              start Stock-File key < Stock-Key invalid key
                    move 21 to Fs-Reply
                    go to aa999-main-exit
              end-start
     end-if
     if       File-Key-No = 1
        and   fn-greater-than
              start Stock-File key > Stock-Key invalid key
                    move 21 to Fs-Reply
                    go to aa999-main-exit
              end-start
     end-if
     if       File-Key-No = 1
        and   fn-not-less-than
              start Stock-File key not < Stock-Key invalid key
                    move 21 to Fs-Reply
                    go to aa999-main-exit
              end-start
     end-if
     if       File-Key-No = 1
              move     WS-Stock-Key to WS-File-Key.
*>
*>  Now do 1st alternate key (Stock-Abrev-Key) before read-next
*>
     if       File-Key-No = 2
        and   fn-equal-to
              start Stock-File key = Stock-Abrev-Key invalid key
                    move 21 to Fs-Reply
                    go to aa999-main-exit
              end-start
     end-if.
     if       File-Key-No = 2
        and   fn-less-than
              start Stock-File key < Stock-Abrev-Key invalid key
                    move 21 to Fs-Reply
                    go to aa999-main-exit
              end-start
     end-if.
     if       File-Key-No = 2
        and   fn-greater-than
              start Stock-File key > Stock-Abrev-Key invalid key
                    move 21 to Fs-Reply
                    go to aa999-main-exit
              end-start
     end-if.
     if       File-Key-No = 2
        and   fn-not-less-than
              start Stock-File key not < Stock-Abrev-Key invalid key
                    move 21 to Fs-Reply
                    go to aa999-main-exit
              end-start
     end-if.
     if       File-Key-No = 2
              move     WS-Stock-Abrev-Key to WS-File-Key
*>
*>  Now do 2nd alternate key (Stock-Desc) before read-next
*>
     if       File-Key-No = 3
        and   fn-equal-to
              start Stock-File key = Stock-Desc invalid key
                    move 21 to Fs-Reply
                    go to aa999-main-exit
              end-start
     end-if.
     if       File-Key-No = 3
        and   fn-less-than
              start Stock-File key < Stock-Desc invalid key
                    move 21 to Fs-Reply
                    go to aa999-main-exit
              end-start
     end-if.
     if       File-Key-No = 3
        and   fn-greater-than
              start Stock-File key > Stock-Desc invalid key
                    move 21 to Fs-Reply
                    go to aa999-main-exit
              end-start
     end-if.
     if       File-Key-No = 3
        and   fn-not-less-than
              start Stock-File key not < Stock-Desc invalid key
                    move 21 to Fs-Reply
                    go to aa999-main-exit
              end-start
     end-if.
     if       File-Key-No = 3
              move     WS-Stock-Desc to WS-File-Key
     go       to aa999-main-exit.
*>
 aa070-Process-Write.
     move     206 to WS-No-Paragraph.
     move     WS-Stock-Record to Stock-Record.
     move     zeros to FS-Reply  WE-Error.
     write    Stock-Record invalid key
              move 22 to FS-Reply
     end-write.
     move     WS-Stock-Key to WS-File-Key.
     go       to aa999-main-exit.
*>
 aa080-Process-Delete.
     move     207 to WS-No-Paragraph.
     move     WS-Stock-Record to Stock-Record.
     move     zeros to FS-Reply  WE-Error.
     delete   Stock-File record invalid key
              move 21 to FS-Reply
     end-delete.
     move     WS-Stock-Key to WS-File-Key.
     go       to aa999-main-exit.
*>
 aa090-Process-Rewrite.
*>
     move     208 to WS-No-Paragraph.
     move     WS-Stock-Record to Stock-Record.
     move     zeros to FS-Reply  WE-Error.
     rewrite  Stock-Record invalid key
              move 21 to FS-Reply
     end-rewrite
     move     WS-Stock-Key to WS-File-Key.
     go       to aa999-main-exit.
*>
 aa100-Bad-Function.
*>
*> Houston; We have a problem
*>
     move     999 to WE-Error.                         *> 999
     move     99  to fs-reply.
*>
 aa999-main-exit.
     if       Testing-1
              perform Ca-Process-Logs
     end-if.
*>
 aa-main-exit.
*>
*> Now have processed cobol flat file,  so ..
*>
 aa-Exit.
     exit program.
*>
 ba-Process-RDBMS section.
*>***********************
*>
*>********************************************************************
*>  Here we call the relevent RDBMS module for this table            *
*>   which will include processing any other joined tables as needed *
*>********************************************************************
*>
 ba010-Test-WS-Rec-Size.
*>
*>     Test on very first call only  (So do NOT use var A & B again)
*>       Lets test that Data-record size is = or > than declared Rec in DAL
*>          as we can't adjust at compile/run time due to ALL Cobol compilers ?
*>
     move     22 to WS-Log-File-no.        *> for FHlogger
*>
     if       A = zero                        *> so it is being called first time
              move     function Length (
                                        WS-Stock-Record
                                                 ) to A
              move     function length (
                                        Stock-Record
                                                 ) to B
              if   A < B                      *> COULD LET caller module deal with these errors !!!!!!!
                   move 901 to WE-Error       *> 901 Programming error; temp rec length is wrong caller must stop
                   move 99 to fs-reply        *> allow for last field ( FILLER) not being present in layout.
              end-if
              if       WE-Error = 901                  *> record length wrong so display error, accept and then stop run.
                       move spaces to Display-Blk
                       string ST902          delimited by size
                              A              delimited by size
                              " < "          delimited by size
                              "Stock-Rec = " delimited by size
                              B              delimited by size    into Display-Blk
                       end-string
                       display Display-Blk at 2301 with erase eol     *> BUT WILL REMIND ME TO SET IT UP correctly
                       display ST901 at 2401 with erase eol
                       if  Testing-1
                           perform Ca-Process-Logs
                       end-if
                       accept Accept-Reply at 2433
                       go to ba-rdbms-exit
              end-if
*>
*>  Not a error comparing the length of records so - -
*>  Load up the DB settings from the system record as its not passed on
*>           hopefully once is enough  :)
*>
              move     RDBMS-DB-Name to DB-Schema
              move     RDBMS-User    to DB-UName
              move     RDBMS-Passwd  to DB-UPass
              move     RDBMS-Port    to DB-Port
              move     RDBMS-Host    to DB-Host
              move     RDBMS-Socket  to DB-Socket
     end-if.
*>
*>
*>   HERE we need a CDF [Compiler Directive] to select the correct DAL based
*>     on the pre SQL compiler e.g., JC's or dbpre or Prima conversions <<<<  ? >>>>>
*>        Do this after system testing and pre code release.
*>
*>  NOW SET UP FOR JC pre-sql compiler system.
*>   DAL-Datablock not needed unless using RDBMS DAL from Prima & MS Sql
*>
     call     "stockMT" using File-Access
                              ACAS-DAL-Common-data

                              WS-Stock-Record
     end-call.
*>
*>   Any errors leave it to caller to recover from
*>
 ba-rdbms-exit.
     exit     program.
*>   ****     *******
*>
 Ca-Process-Logs. *> Not called on DAL access as it does it already
*>**************
*>
     call     "fhlogger" using File-Access
                               ACAS-DAL-Common-data.
*>
 ca-Exit.     exit.
*>
 end program acas011.
