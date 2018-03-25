       >>source free
*>********************************************
*>                                           *
*>    Stock Table Load via the Stock file    *
*>                 for MySQL                 *
*>     Used as Modal for the others.         *
*>                                           *
*>-------------------------------------------*
*>  This modules uses commit and rollback so *
*>  you MUST ensure that autocommit is OFF   *
*>   in the rdb settings. It is as default   *
*>   set ON.                                 *
*>********************************************
*>
 identification division.
 program-id.             StockLD.
*>**
*>   author.             V.B.Coen FBCS.
*>                       For Applewood Computers.
*>**
*>   Security.           Copyright (C) 2016 & later, Vincent Bryan Coen.
*>                       Distributed under the GNU General Public License
*>                       v2.0. Only. See the file COPYING for details.
*>**
*>   Remarks.            Stock RDB Table load from the Stock File
*>                       using the Mysql RDBMS.
*>                       For use with ACAS v3.02 and later only.
*>**
*>   Version.            See prog-name in Ws.
*>**
*>   Called Modules.     acas011   } For file and table access.
*>                       stockMT   }
*>                       fhlogger
*>
*>**
*>   Error messages used.
*>                       SY001.
*>                       SY004.
*>                       SY006.
*>                       SY007.
*>                       SY008.
*>                       SY009.
*>                       ST010.
*>                       ST011.
*>                       ST012.
*>                       ST013.
*>                       ST014.
*>                       ST015.
*>                       ST018.
*>                       ST097.
*>                       ST099.
*>**
*>   Changes.
*> 04/08/16 vbc - .01 Forgot to mv stock rec to ws - Der!
*>                    Move zero to File-Function & Access-Type to close
*>                    log file via fh-logger before last call to stockMT
*>                     at RDB close.
*>                    Hopefully will clear error 34.
*>                    LS bugs rearing it head again
*> 07/07/16 vbc - .02 Replace calls to acas011 for stockMT.
*>                    Will still need to test acas011 though !
*> 11/07/16 vbc - .03 Added Log rec count & removed clearing fs-reply.
*>                .04 Clear out un-needed testing displays.
*> 29/07/16 vbc - .05 Display extra error details on writing + new msg ST018.
*> 30/07/16 vbc - .06 Use Cobol file accessing and not acas011.
*> 24/10/16 vbc - .   ALL programs now using wsnames.cob in copybooks
*> 03/01/17 vbc - .07 Clean up displays & msgs.
*>**
*>
*>*************************************************************************
*>
*> Copyright Notice.
*>*****************
*>
*> This file/program is part of the Applewood Computers Accounting System
*> and is copyright (c) Vincent B Coen. 2016 and later.
*>
*> This program is free software; you can redistribute it and/or modify it
*> under the terms of the GNU General Public License as published by the
*> Free Software Foundation; version 2 ONLY.
*>
*> ACAS is distributed in the hope that it will be useful, but WITHOUT
*> ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
*> FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License
*> for more details. If it breaks, you own both pieces but I will endevor
*> to fix it, providing you tell me about the problem by using the Bug
*> reporting system on Sourceforge for the ACAS system.
*>
*> You should have received a copy of the GNU General Public License along
*> with ACAS; see the file COPYING.  If not, write to the Free Software
*> Foundation, 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA.
*>*************************************************************************
*>
*>
 environment division.
*>-------------------
*>
 copy "envdiv.cob".
 input-output            section.
*>------------------------------
*>
 file-control.
*>-----------
*>
 copy "selsys.cob".
 data division.
*>------------
*>
 file section.
*>-----------
*>
 copy "fdsys.cob".
 working-storage section.
*>----------------------
 77  prog-name           pic x(17)    value "stockLD (3.02.07)".
 77  z                   binary-char  value zero.
 77  OS-Delimiter        pic x        value "/".
 77  ACAS_BIN            pic x(512)   value spaces.
 77  ACAS_LEDGERS        pic x(500)   value spaces.
 77  Arg-Number          pic 9        value zero.
*>
*> holds program parameter values from command line
 01  Arg-Vals                         value spaces.
     03  Arg-Value       pic x(525)  occurs 2.
 01  Arg-Test            pic x(525)   value spaces.
*>
 01  work-fields.
     03  ws-Rec-Cnt-In   pic 9(4)     value zero.
     03  ws-Rec-Cnt-Out  pic 9(4)     value zero.
     03  ws-Rec-Cnt-R-Out pic 9(6)    value zero.
     03  ws-reply        pic x.
*>
 copy "Test-Data-Flags.cob".  *> set sw-testing to zero to stop logging.
*>
 copy "wsstock.cob".
 copy "wsfnctn.cob".
 copy "wsnames.cob" in "../copybooks".   *> uses the full version.

*>
 01  Error-Messages.
*> System Wide
     03  ST001          pic x(26) value "SY001 System 1 read err = ".
     03  ST004          pic x(59) value "SY004 Problem with opening system file. Hit return to clear".
     03  SY006          pic x(62) value "SY006 Program Arguments limited to two and you have specified ".
     03  SY007          pic x(35) value "SY007 Program arguments incorrect: ".
     03  SY008          pic x(31) value "SY008 Note message & Hit return".
     03  SY009          pic x(53) value "SY009 Environment variables not yet set up : ABORTING".
*> Program specific
     03  ST010          pic x(30) value "ST010 Duplicate key/s found = ".
     03  ST011          pic x(33) value "ST011 Error on stockMT processing".
     03  ST012          pic x(33) value "ST012 Error opening Stock File = ".
     03  ST013          pic x(30) value "ST013 Error on reading file = ".
     03  ST014          pic x(31) value "ST014 Error on writing table = ".
     03  ST015          pic x(34) value "ST015 Error opening Stock Table = ".
     03  ST018          pic x(22) value "ST018 RDBMS details : ".
     03  ST097          pic x(30) value "ST097 No Stock file present".
     03  ST099          pic x(15) value "ST099 Ignoring.".
*>
 procedure division.
*>=================
*>
 aa000-main-start.
     perform  zz020-Get-Program-Args.
     display  prog-name at 0101 with foreground-color 2 erase eos.
     move     5      to WS-Log-System.   *> 1 = IRS, 2=GL, 3=SL, 4=PL, 5=Stock used in FH logging
     move     22     to WS-Log-File-No.  *> RDB, File/Table
*>
*>  Get the system param for the various RDB fields
*>
     open     input System-File.
     if       fs-reply not = zero
              display ST001 fs-reply
              display ST004
              close System-File
              goback
     end-if
     move     1 to rrn.
     read     system-file record.
     if       fs-reply not = zero
              display ST001 fs-reply
              close System-File
              goback
     end-if
*>
*>  Over-ride processes for acas011/stockMT for Dup modes
*>
     move     zero to File-System-Used
                      File-Duplicates-In-Use
                      FA-File-System-Used
                      FA-File-Duplicates-In-Use.   *>  Cobol file in use
     move     zero to Log-file-rec-written.        *> for logging.
*>
     perform  acas011-Open-Input.      *> open input Cobol stock FILE
     if       FS-Reply = 35
              display ST097 at 0301
              display " Terminating nothing to do" at 0338
              close System-File
              perform acas011-Close
              goback.
     if       FS-Reply not = zero
              display ST012       at 0301
              display "FS-Reply=" at 0338
              display FS-Reply    at 0347
              display SY008       at 0401
              accept  ws-Reply    at 0433
              close System-File
              perform acas011-Close
              goback.
     move     1 to File-Key-No.
     move     1 to File-System-Used
                   FA-File-System-Used.            *> RDB in use
     perform  acas011-Open.                        *> Open/Init RDB via FH - acas011
     if       FS-Reply not = zero
              display ST015      at 0301
              close System-File
              perform acas011-Close
              move zero to File-System-Used
                           File-Duplicates-In-Use
              perform acas011-Close
              goback
     end-if.
     move     zero to Access-Type.
     go       to aa010-Read.
*>
 acas011.
     call     "acas011" using System-Record
                              WS-Stock-Record
                              File-Access
                              File-Defs
                              ACAS-DAL-Common-data.
*>
 acas011-Open.
     set      fn-open to true.
     set      fn-i-o  to true.
     perform  acas011.
     perform  aa100-Check-4-Errors.
*>
 acas011-Open-Input.
     set      fn-open  to true.
     set      fn-input to true.
     perform  acas011.
     perform  aa100-Check-4-Errors.
*>
 acas011-Close.
     set      fn-Close to true.
     perform  acas011.
*>
 acas011-Read-Next.
     set      fn-Read-Next to true.
     perform  acas011.
*>
 acas011-Write.
     set      fn-Write to true.
     perform  acas011.
*>
 acas011-Rewrite.
     set      fn-re-write to true.
     perform  acas011.
*>
*>  We will Rollback on any errors but Mysql has to be set up to do it
*>      otherwise as normally it is set to autocommit !!!!!
*>
 aa010-Read.
     move     zero to File-System-Used
                      FA-File-System-Used.            *> Cobol file in use
     perform  acas011-Read-Next.
     if       fs-Reply = 10                        *> EOF
              go to aa999-Finish
     end-if
*>
     if       FS-Reply not = zero
              display ST013    at 1401 with highlight erase eol
              display fs-reply at 1425  with highlight
 *>             perform aa020-Rollback
              go to aa999-Finish
     end-if
*>
     add      1 to ws-Rec-Cnt-In.
*>
     move     1 to File-System-Used     *> acas0nn set to process RDB
                   FA-File-System-Used.
     perform  acas011-Write.
     if       Sql-State = "23000"  *> Dup key (rec already present)
         or   fs-reply = 22                    *> Check for dup key/record and continue at least while testing
         or   SQL-Err (1:4) = "1062"
                           or "1022"
              perform acas011-Rewrite
              if   FS-Reply not = zero
                   display ST010        at 0701 with foreground-color 2 highlight erase eol
                   display WS-File-Key  at 0731 with foreground-color 2 highlight
                   display ST099        at 0801
              else
                   add 1 to ws-Rec-Cnt-R-Out
              end-if
              go to aa010-Read
     end-if
*>
     if       fs-reply not = zero              *> Anything else
              display ST014         at 0701 with foreground-color 2 highlight erase eol
              display fs-reply      at 0732 with foreground-color 2 highlight
              display "WE-Error = " at 0801 with foreground-color 2 highlight
              display WE-Error      at 0811 with foreground-color 2 highlight
              display ST018         at 0901 with foreground-color 2 highlight
              display SQL-Err       at 0923 with foreground-color 2
              display SQL-Msg       at 1001 with foreground-color 2
 *>             perform aa020-Rollback
              display SY008         at 0901 with erase eol
              accept  Accept-Reply  at 0935
              go to aa999-Finish
     end-if
     add      1 to ws-Rec-Cnt-Out.
     go       to aa010-Read.
*>
 aa020-Rollback.
*>
*> These do not work during testing with mariadb - Non transactional model or autocommit set ON
*>           exec sql
*>                rollback
*>           end-exec.
     call     "MySQL_rollback".
*>     if       return-code not = zero
*>              display "Rollback failed " at 0501
*>              display return-code        at 0517
*>     end-if.
*>
 aa030-Commit.
*>           exec sql
*>                commit
*>           end-exec.
     call     "MySQL_commit".
*>     if       return-code not = zero
*>              display "Commit failed " at 0501
*>              display return-code      at 0515
*>     end-if.
*>
 aa100-Check-4-Errors.
     if       fs-reply not = zero
              display ST011            at 0801   *> acas011/StockMT processing
              display "Fs-reply = "    at 0901
              display fs-reply         at 0912
              display "WE-Error = "    at 1001
              display  WE-Error        at 1012
              display SQL-Err          at 1101
              display SQL-Msg          at 1201
 *>             perform aa020-Rollback
              display SY008            at 2001 with erase eol
              accept  Accept-Reply     at 2035
              go to aa999-Finish
     end-if.
*>
 aa999-Finish.
     display  "Rec cnt  in = "     at 1601 with erase eol.
     display  ws-Rec-Cnt-In        at 1615.
     display  "Rec cnt out = "     at 1622.
     display  ws-Rec-Cnt-Out       at 1637.
     display  "Rec Cnt rewrite = " at 1646
     display  ws-Rec-Cnt-R-Out     at 1665
     display  "Log Recs out   = "  at 1801 with erase eol.
     display  Log-File-Rec-Written at 1817.
     move     1 to File-System-Used
                   FA-File-System-Used.
     move     zero to Access-Type.
     move     2 to File-Function.
     perform  acas011-Close.                     *> Close RDB
     close    System-File.
     move     zero to File-System-Used
                      FA-File-System-Used.
     perform  acas011-close.    *> Close cobol stock file
     Display  "EOJ - Load Stock Table" at 2001 with erase eol.
     display  SY008    at 2401.
     accept   ws-reply at 2435.
     goback.
*>
 copy "Proc-Get-Env-Set-Files.cob".  *> Only uses ACAS_LEDGERS now
*>
