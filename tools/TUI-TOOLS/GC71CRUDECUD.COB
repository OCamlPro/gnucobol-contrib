       >>SOURCE FORMAT IS FREE
IDENTIFICATION DIVISION.
program-id. GC71CRUDECUD is INITIAL program.
*> ***********************************************************************************
*> GnuCOBOL TT (TUI TOOLS) COLLECTION
*> Purpose:    CRUDE APPLICATION - CREATE / UPDATE / DELETE A DATA RECORD
*> Tectonics:  cobc -m GC71CRUDECUD.COB  (use GnuCOBOL 2.0 or greater)
*> Usage:      call GC71CRUDECUD using LnkFileName LnkFunction LnkKey LnkKeyActive
*> Parameters: LnkFileName LnkFunction LnkKey LnkKeyActive
*> Author:     Eugenio Di Lorenzo - Italia (DILO)
*> License:    Copyright 2017 E.Di Lorenzo - LGPL, 3.0 (or greater)
*> Version:    1.0 2017.03.01
*> Changelog:  1.0 first release.
*> ***********************************************************************************
*> THIS PROGRAM IS A 'STANDARD SCHEMA' FOR SCREEN FIELDS DATA-ENTRY TO CREATE/UPDATE/DELETE
*> - fields are shown and accepted on screen
*> - with ENTER, CursorDown or Tab  ==> check the field and go to next field
*> - with CursorUp or SHIFT-Tab     ==> check the field and go to previsous field
*> ***********************************************************************************
*> How to use the standard schema of this program:
*> - set NumFields value (how many fields are on screen ?)
*> - set display/accept of single fields on screen
*> - set labels at "go to depending on" for Accept and for Controls
*> - set fields controls at your need
*> ***********************************************************************************
*>   to done: con paggiu/pagsu da' l'agente seguente / precedente
*> ***********************************************************************************

ENVIRONMENT DIVISION.
Configuration Section.
 SPECIAL-NAMES.
   CRT STATUS IS wKeyPressed
   Currency Sign is '€'
   Decimal-Point is Comma.

input-output section.
file-control.
   *> MASTER FILE
   select ANAGE
          assign                 to AnageFSPEC
          access mode            is dynamic
          organization           is indexed
          record key             is FdAnageKey
          alternate record key   is FdAnageCodAge
          alternate record key   is FdAnageCodFis
          alternate record key   is FdAnageRagSoc
          file status            is AnageFS.

DATA DIVISION.
file section.

fd  ANAGE label records are standard.
01  FdAnageRec.
   03 FdAnageKey    pic 9(009). *> Key (a REC.ID)
   03 FdAnageCodAge pic x(010). *> code
   03 FdAnageCodFis pic x(016). *> fiscal code
   03 FdAnageRagSoc pic x(030). *> name
   03               pic x(335).

*> **************************************************************
WORKING-STORAGE SECTION.
*> **************************************************************
*> Values that may be returned in CRT STATUS (or COB-CRT-STATUS)
78  K-ENTER       VALUE 0000.
78  K-UP          VALUE 2003.
78  K-DOWN        VALUE 2004.
78  K-LEFT        VALUE 2009.
78  K-RIGHT       VALUE 2010.
78  K-ESCAPE      VALUE 2005.
78  K-TAB         VALUE 2007.
78  K-BACKTAB     VALUE 2008.
78  K-PAGEUP      VALUE 2001.
78  K-PAGEDOWN    VALUE 2002.
78  K-NO-DATA     VALUE 8000.
78  K-TIMEOUT     VALUE 8001.
78  K-F1          VALUE 1001.
78  K-F4          VALUE 1004.
78  K-F12         VALUE 1012.
78  K-SHIFT-F1          VALUE 1013.
78  K-SHIFT-F3          VALUE 1015.

01 black   constant as 0.
01 blue    constant as 1.
01 green   constant as 2.
01 cyan    constant as 3.
01 red     constant as 4.
01 magenta constant as 5.
01 yellow  constant as 6.  *> or Brown
01 white   constant as 7.

01  wKeyPressed  PIC  9(04) VALUE 9999.
77  NumFields    pic s9(02) comp-5 value +40. *> number of fields on screen

77  AnageFS    pic x(02).
77  AnageFSPEC pic x(30).

01  Anage999Rec.
   03 Anage999Key pic 9(009). *> chiave del file
   03 Anage999Ctr pic 9(009). *> contatore progressivo delle chiavi
   03             pic x(382).

01 wRetCode     PIC 9999.

01 AnageAnticiX pic X(11).
01 AnageAnticiZ pic -(7)9,99.
01 AnageTraSinX pic X(11).
01 AnageTraSinZ pic -(7)9,99.
01 AnageConSpeX pic X(11).
01 AnageConSpeZ pic -(7)9,99.
01 AnageAssicuX pic X(09).
01 AnageAssicuZ pic -(5)9,99.
01 AnageCapSocX pic x(12).
01 AnageCapSocZ pic z(11)9.

77 Pivot    pic s9(02) comp-5 value +01.
77 dbc      pic s9(04) comp-5 value +01. *> display backgr.color
77 dfc      pic s9(04) comp-5 value +15. *> display foregr.color
77 abc      pic s9(04) comp-5 value +00. *> accept  backgr.color
77 afc      pic s9(04) comp-5 value +15. *> accept  backgr.color
77 Pro      pic  x(01)        value '_'.  *> ±'.
77 wHeader     pic x(80) value space.
77 ExecuteOper pic x(26) value ' F12= Execute '.

01  wString   pic x(31).
01  FirstTimeAltS  pic x value 'Y'.

01 SavedCodAge pic x(010) value space.
01 SavedCodFis pic x(016) value space.
01 SavedRagSoc pic x(030) value space.

01 DupKeyAlt-CodAge         pic x(01).
    88 DupKeyAlt-CodAge-no  value 'N'.
    88 DupKeyAlt-CodAge-yes value 'Y'.
01 DupKeyAlt-CodFis         pic x(01).
    88 DupKeyAlt-CodFis-no  value 'N'.
    88 DupKeyAlt-CodFis-yes value 'Y'.
01 DupKeyAlt-RagSoc         pic x(01).
    88 DupKeyAlt-RagSoc-no  value 'N'.
    88 DupKeyAlt-RagSoc-yes value 'Y'.

01 wOperation pic x.
   88 Operation-Enabled     value 'Y'.
   88 Operation-Not-Enabled value 'N'.
01 ER pic x.
   88 NoErrors value 'N'.
   88   Errors value 'Y'.

01  wCursorShow       BINARY-SHORT SIGNED value 2.
01  wCursorHide       BINARY-SHORT SIGNED value 0.

*> SAVE/RESTORE SCREEN VARIABLES
01 wScreenName        PIC X(256).
01 wiScrOk            BINARY-LONG.

1 DescOperation  pic x(015).
1 DescKeyActive  pic x(015).

copy 'GC71CRUDEREC.CPY' .

COPY 'GC01BOX.CPY'      .
COPY 'GC02BOXMEX.CPY'   .
copy 'GC03YESNO.CPY'    .
COPY 'GC09BUTTONS.CPY'  .
copy 'GC74HELPVIEW.CPY' .
copy 'GC56DATEPICKER.CPY'.

LINKAGE SECTION.
1 LnkFileName     pic x(012).
1 LnkFunction     pic x(001).
1 LnkKey          pic 9(009).
1 LnkKeyActive    pic X(001).


*> **************************************************************
*>           P R O C E D U R E   D I V I S I O N
*> **************************************************************
PROCEDURE DIVISION using LnkFileName LnkFunction LnkKey LnkKeyActive.

    *> sets in order to detect the PgUp, PgDn, PrtSc(screen print), Esc keys,
    set environment 'COB_SCREEN_EXCEPTIONS' TO 'Y'.
    set environment 'COB_SCREEN_ESC'        TO 'Y'.

    move green to dbc
    move white to dfc

    move LnkFileName to AnageFSPEC
    *> space also to filler fields
    move space to AnageRec
    initialize AnageRec

    *> read the record (the caller gives only the key). update/edit or delete of record
    if LnkFunction = 'U' or 'D'
        open  i-o ANAGE
        move  LnkKey to FdAnageKey
        read  ANAGE into AnageRec

        move AnageCodAge to SavedCodAge
        move AnageCodFis to SavedCodFis
        move AnageRagSoc to SavedRagSoc

        close ANAGE
    end-if

    perform DisplayDataOnScreen thru DisplayDataOnScreenEx.

LOOP-DELETE.
    *> if request a Delete skip accept and control of fields
    if LnkFunction = 'D'
       set     Operation-Enabled to true
       move    DescOperation     to ExecuteOper (15:12)
       display ExecuteOper       at 2560 with  Background-Color green Foreground-Color white
       accept  omitted
       go to EVALUATE-KEY
    end-if.

LOOP-ACCEPT.
   *> re-show the cursor
   call static 'curs_set' using by value wCursorShow end-call
   *> reset the "F4 datepicker" message at row 25
   display '                '  at 2523 with  Background-Color green Foreground-Color white

   go to acc01 acc02 acc03 acc04 acc05 acc06 acc07 acc08 acc09 acc10
         acc11 acc12 acc13 acc14 acc15 acc16 acc17 acc18 acc19 acc20
         acc21 acc22 acc23 acc24 acc25 acc26 acc27 acc28 acc29 acc30
         acc31 acc32 acc33 acc34 acc35 acc36 acc37 acc38 acc39 acc40
    depending on Pivot.

ACC01.
   *> NAME
   move 'P050-001' to HeKey
   accept AnageRagSoc at 0527 with  Background-Color abc Foreground-Color afc
          update prompt character is pro auto-skip reverse-video
   go EVALUATE-KEY.
ACC02.
   *> CODE
   move 'P050-002' to HeKey
   accept AnageCodAge at 0570 with  Background-Color abc Foreground-Color afc
          update prompt character is pro auto-skip reverse-video
   go EVALUATE-KEY.
ACC03.
   *> FISCAL CODE
   move 'P050-003' to HeKey
   accept AnageCodFis                    line 06 column 27
    with  Background-Color abc Foreground-Color afc
     update prompt character is pro auto-skip reverse-video
   go EVALUATE-KEY.
ACC04.
   *> VAT CODE
   move 'P050-012' to HeKey
   accept AnageParIVA                    line 06 column 46
    with  Background-Color abc Foreground-Color afc
     update prompt character is pro auto-skip reverse-video
   go EVALUATE-KEY.
ACC05.
   *> matricola
   move 'P050-004' to HeKey
   accept AnageMatEna                    line 06 column 72
    with  Background-Color abc Foreground-Color afc
     update prompt character is pro auto-skip reverse-video
   go EVALUATE-KEY.
ACC06.
   *> ADDRESS
   accept AnageIndLeg                    line 07 column 27
    with  Background-Color abc Foreground-Color afc
     update prompt character is pro auto-skip reverse-video
   go EVALUATE-KEY.
ACC07.
   *> Localita'
   accept AnageLocLeg                    line 08 column 27
    with  Background-Color abc Foreground-Color afc
     update prompt character is pro auto-skip reverse-video
   go EVALUATE-KEY.
ACC08.
   *> ZIP
   accept AnageCapLeg                     line 08 column 66
    with  Background-Color abc Foreground-Color afc
     update prompt character is pro auto-skip reverse-video
   go EVALUATE-KEY.
ACC09.
   *> provincia
   accept AnageProLeg                     line 08 column 78
    with  Background-Color abc Foreground-Color afc
     update prompt character is pro auto-skip reverse-video
   go EVALUATE-KEY.
ACC10.
   *> localita' di nascita
   accept AnageLocaNa                    line 09 column 27
    with  Background-Color abc Foreground-Color afc
     update prompt character is pro auto-skip reverse-video
   go EVALUATE-KEY.
ACC11.
   *> date of birth - on date fields  F4 Datepicker is available
   display "F4-<Date Picker>"  at 2523 with  Background-Color green Foreground-Color white
   accept AnageDataNa                     line 09 column 63
    with  Background-Color abc Foreground-Color afc
     update prompt character is pro auto-skip reverse-video
   go EVALUATE-KEY.
ACC12.
   *> provincia di nascita
   accept AnageProvNa                     line 09 column 78
    with  Background-Color abc Foreground-Color afc
     update prompt character is pro auto-skip reverse-video
   go EVALUATE-KEY.
ACC13.
   *> home telefono
   accept AnageTelCas                     line 10 column 27
    with  Background-Color abc Foreground-Color afc
     update prompt character is pro auto-skip reverse-video
   go EVALUATE-KEY.
ACC14.
   *> telefono mobile
   accept AnageTelCel                     line 10 column 43
    with  Background-Color abc Foreground-Color afc
     update prompt character is pro auto-skip reverse-video
   go EVALUATE-KEY.
ACC15.
   *> fax
   accept AnageTelFax                     line 10 column 63
    with  Background-Color abc Foreground-Color afc
     update prompt character is pro auto-skip reverse-video
   go EVALUATE-KEY.
ACC16.
   *> Tipo contratto (mono/plurimandatario)
   move 'P050-010' to HeKey
   accept AnageTipCon                    line 11 column 27
    with  Background-Color abc Foreground-Color afc
     update prompt character is pro auto-skip reverse-video
   go EVALUATE-KEY.
ACC17.
   *> Tipo soggetto (age.individuale, soc.persone/capitali)
   move 'P050-011' to HeKey
   accept AnageTipSog                    line 12 column 27
    with  Background-Color abc Foreground-Color afc
     update prompt character is pro auto-skip reverse-video
   go EVALUATE-KEY.
ACC18.
   *> data inizio rapporto di agenzia
   display "F4-<Date Picker>"  at 2523 with  Background-Color green Foreground-Color white
   accept AnageDataIn                    line 14 column 27
    with  Background-Color abc Foreground-Color afc
     update prompt character is pro auto-skip reverse-video
   go EVALUATE-KEY.
ACC19.
   *> data cessazione rapporto di agenzia
   display "F4-<Date Picker>"  at 2523 with  Background-Color green Foreground-Color white
   accept AnageDataCe                    line 14 column 66
    with  Background-Color abc Foreground-Color afc
     update prompt character is pro auto-skip reverse-video
   go EVALUATE-KEY.
ACC20.
   *> tipo cessazione rapporto di agenzia
   move 'P050-104' to HeKey
   accept AnageTipoCe                    line 14 column 78
    with  Background-Color abc Foreground-Color afc
     update prompt character is pro auto-skip reverse-video
   go EVALUATE-KEY.
ACC21.
   *> anticipo fisso mensile
   *> accept AnageAntici                    line 15 column 27
   accept AnageAnticiX                   line 15 column 27
    with  Background-Color abc Foreground-Color afc
     update prompt character is pro auto-skip reverse-video
     *> space-fill
   inspect AnageAntici converting space to zero
   go EVALUATE-KEY.
ACC22.
   *> concorso spese fisso
   move 'P050-107' to HeKey
   accept AnageConSpeX                   line 15 column 66
    with  Background-Color abc Foreground-Color afc
     update prompt character is pro auto-skip reverse-video
   inspect AnageConSpe converting space to zero
   go EVALUATE-KEY.
ACC23.
   *> trattenuta sindacale
   move 'P050-106' to HeKey
   accept AnageTraSinX                   line 16 column 27
    with  Background-Color abc Foreground-Color afc
     update prompt character is pro auto-skip reverse-video
   inspect AnageTrasin converting space to zero
   go EVALUATE-KEY.
ACC24.
   *> tipo liquidazione (acconti+conguaglio o su eff.mese)
   move 'P050-105' to HeKey
   accept AnageTipLiq                    line 16 column 66
    with  Background-Color abc Foreground-Color afc
     update prompt character is pro auto-skip reverse-video
   go EVALUATE-KEY.
ACC25.
   *> se ha subagenti (x percentuale ritenuta d'acconto)
   move 'P050-102' to HeKey
   accept AnageSubage                    line 17 column 27
    with  Background-Color abc Foreground-Color afc
     update prompt character is pro auto-skip reverse-video
   go EVALUATE-KEY.
ACC26.
   *> percentuale Iva in fattura agente
   move 'P050-022' to HeKey
   accept AnagePerIva                    line 17 column 38
    with  Background-Color abc Foreground-Color afc
     update prompt character is pro auto-skip reverse-video
   inspect AnagePerIva converting space to zero
   go EVALUATE-KEY.
ACC27.
   *> numerazione automatica fatture ?
   move 'P050-021' to HeKey
   accept AnageNumAut                    line 17 column 66
    with  Background-Color abc Foreground-Color afc
     update prompt character is pro auto-skip reverse-video
   go EVALUATE-KEY.
ACC28.
   *> sex
   move 'P050-112' to HeKey
   accept AnageSesso                     line 17 column 78
    with  Background-Color abc Foreground-Color afc
     update prompt character is pro auto-skip reverse-video
   go EVALUATE-KEY.
ACC29.
   *> numero camera di commercio
   accept AnageCamCom                    line 18 column 27
    with  Background-Color abc Foreground-Color afc
     update prompt character is pro auto-skip reverse-video
   go EVALUATE-KEY.
ACC30.
   *> iscriz.reg.ditte
   accept AnageNumRuo                    line 18 column 66
    with  Background-Color abc Foreground-Color afc
     update prompt character is pro auto-skip reverse-video
   go EVALUATE-KEY.

ACC31.
   *> iscriz.registro delle imprese
   accept AnageIscTri                    line 19 column 27
    with  Background-Color abc Foreground-Color afc
     update prompt character is pro auto-skip reverse-video
   go EVALUATE-KEY.
ACC32.
   *> capitale sociale
   accept AnageCapSocX                   line 19 column 66
    with  Background-Color abc Foreground-Color afc
     update prompt character is pro auto-skip reverse-video
     *> space-fill
   inspect AnageCapSoc converting space to zero
   go EVALUATE-KEY.
ACC33.
   *> codice fornitore in contab.fornitori
   move 'P050-020' to HeKey
   accept AnageCodFor                    line 20 column 27
    with  Background-Color abc Foreground-Color afc
     update prompt character is pro auto-skip reverse-video
   go EVALUATE-KEY.
ACC34.
   *> codice centro di costo
   move 'P050-027' to HeKey
   accept AnageCodcdc                    line 20 column 66
    with  Background-Color abc Foreground-Color afc
     update prompt character is pro auto-skip reverse-video
   go EVALUATE-KEY.
ACC35.
   *> rete di vendita
   accept AnageReteVe                    line 21 column 27
    with  Background-Color abc Foreground-Color afc
     update prompt character is pro auto-skip reverse-video
   go EVALUATE-KEY.
ACC36.
   *> zona di vendita
   accept AnageZonaVe                    line 21 column 34
    with  Background-Color abc Foreground-Color afc
     update prompt character is pro auto-skip reverse-video
   go EVALUATE-KEY.
ACC37.
   *> casella postale
   accept AnageCasPos                    line 21 column 66
    with  Background-Color abc Foreground-Color afc
     update prompt character is pro auto-skip reverse-video
   go EVALUATE-KEY.
ACC38.
   *> descrizione % provvigioni
   move 'P050-103' to HeKey
   accept AnageProvvi                    line 22 column 27
    with  Background-Color abc Foreground-Color afc
     update prompt character is pro auto-skip reverse-video
   go EVALUATE-KEY.
ACC39.
   *> Settore contabile stampato su lett.allegata a fatture
   move 'P050-109' to HeKey
   accept AnageSetCon                    line 22 column 52
    with  Background-Color abc Foreground-Color afc
     update prompt character is pro auto-skip reverse-video
     *> space-fill
   go EVALUATE-KEY.
ACC40.
   *> assicur.da trattenere da firr
   move 'P050-108' to HeKey
   accept AnageAssicuX                   line 22 column 66
    with  Background-Color abc Foreground-Color afc
     update prompt character is pro auto-skip reverse-video
     *> space-fill
   inspect AnageAssicu converting space to zero
   go EVALUATE-KEY.


EVALUATE-KEY.

 EVALUATE wKeyPressed
    *> ******************************************************************
    *> ENTER = CONTROLS ON SCREEN FIELDS
    *> ******************************************************************
    WHEN K-ENTER
    WHEN K-TAB
    WHEN K-DOWN
         *> if request a Delete skip accept and acontrol of fields
         if LnkFunction = 'D'
            go LOOP-DELETE
         else
            perform CtrFields thru CtrFieldsEx
            if Errors
               continue
            else
               *> go to next field on screen
               compute Pivot = Pivot + 1
                *> with next statement the cursor remain on last fields
               *> there in no wrapping to the first fied
               *> if Pivot > NumFields move NumFields to Pivot end-if
                *> with next statement the cursor do not remain on last fields
               *> cursor wraps to the first field on screen
               if Pivot > NumFields move 1 to Pivot end-if
            end-if
         end-if

    WHEN K-BACKTAB
    WHEN K-UP
         *> if request a Delete skip accept and acontrol of fields
         if LnkFunction = 'D'
            go LOOP-DELETE
         else
             perform CtrFields thru CtrFieldsEx
             if Errors
                continue
             else
                *> go to previous field on screen
                compute Pivot = Pivot - 1

                *> with following statement, when cursors is on 1st field
                *> it remains there (non to go - wrap - on last filed)
                if Pivot < 1 move 1 to Pivot end-if

                *> with following statement, when cursors is on 1st field
                *> it not remains there (to go - wrap - on last filed)
                *> Warning: whne cursor is on last field the probgarm enables
                *> update or delete or create . It may be to enable oeperation
                *> without check all fileds (!)
                *> if Pivot < 1 move NumFields to Pivot end-if
             end-if
         end-if

    *> ******************************************************************
    *> F12 (or PAGEDOWN) - EXECUTE OPERATION: CREATE, UPDATE, DELETE
    *> ******************************************************************
    WHEN K-F12
    WHEN K-PAGEDOWN
         *> confirmation is requested
         perform CtrFields thru CtrFieldsEx

         if Errors
             continue
         else
             if Operation-Enabled
                if NoErrors
                   perform ScreenSave thru ScreenSaveEx
                   evaluate LnkFunction
                          when 'C' move '        CONFIRM TO CREATE ?        ' to Yn-mess
                          when 'U' move '        CONFIRM TO UPDATE ?        ' to Yn-mess
                          when 'D' move '        CONFIRM TO DELETE ?        ' to Yn-mess
                   end-evaluate
                   CALL GC03YESNO using by reference YESNO-AREA
                   perform ScreenRestore thru ScreenRestoreEx
                   if Yn-yesno = 'Y' and Yn-Key = 13
                       evaluate LnkFunction
                          when 'C' perform Record-Write    thru Record-WriteEx
                          when 'U' perform Record-Rewrite  thru Record-RewriteEx
                          when 'D' perform Record-Delete   thru Record-DeleteEx
                       end-evaluate
                       move 'Y' to FirstTimeAltS
                   end-if
                end-if
             end-if
         end-if

    *> ******************************************************************
    *> DATE PICKER BUT ONLY FOR DATE FIELDS
    *> ******************************************************************
    WHEN K-F4
        *> DATE FIELDS ARE FIELDS N. 11 18 & 19
        if pivot = 11 or 18 or 19
             perform DatePicker thru DatePickerEx
             if pivot = 11 move Dtp-DateSel to AnageDataNa  end-if
             if pivot = 18 move Dtp-DateSel to AnageDataIn  end-if
             if pivot = 19 move Dtp-DateSel to AnageDataCe  end-if
        end-if

    *> ******************************************************************
    *> DISPLAY HELP WINDOW WITH FIELDS INFO
    *> ******************************************************************
    WHEN K-F1
     if LnkFunction = 'D'
         go LOOP-DELETE
     else
         perform Help thru HelpEx
     end-if
    *> ******************************************************************
    *> ESCAPE = EXIT
    *> ******************************************************************
    when K-ESCAPE
         perform ScreenSave thru ScreenSaveEx
         move 'Y' to Yn-yesno
         move '         CONFIRM THE EXIT ?        ' to Yn-mess
         CALL GC03YESNO using by reference YESNO-AREA
         if Yn-yesno = 'Y' and Yn-Key = 13
            go End-of-Program
         end-if
         perform ScreenRestore thru ScreenRestoreEx

 END-EVALUATE

 move 'P999-???' to HeKey

 GO LOOP-ACCEPT.


 *> *****************************************************************************
 *>                        E N D     O F    P R O G R A M
 *> *****************************************************************************
 END-OF-PROGRAM.
 Goback.



 *> *****************************************************************************
 *>
 *>                 C H E C K     F I E L D S   C O N T E N T
 *>
 *> *****************************************************************************
 CtrFields.
     set NoErrors to true
     go to ctr01 ctr02 ctr03 ctr04 ctr05 ctr06 ctr07 ctr08 ctr09 ctr10
           ctr11 ctr12 ctr13 ctr14 ctr15 ctr16 ctr17 ctr18 ctr19 ctr20
           ctr21 ctr22 ctr23 ctr24 ctr25 ctr26 ctr27 ctr28 ctr29 ctr30
           ctr31 ctr32 ctr33 ctr34 ctr35 ctr36 ctr37 ctr38 ctr39 ctr40
      depending on Pivot.
 CTR01.
     *> name Agent or Company (we decide to always convert lowercase to uppercase)
     inspect AnageRagSoc converting 'abcdefghijklmnopqrstuvwxyz' to 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
     display AnageRagSoc at 0527 with  Background-Color abc Foreground-Color afc reverse-video
     if AnageRagSoc = space
        set Errors to true
        move '                              ' & x'00' to bxm-mex(1)
        move '        >>> ERROR <<<         ' & x'00' to bxm-mex(2)
        move '                              ' & x'00' to bxm-mex(3)
        move '  Type a NAME                 ' & x'00' to bxm-mex(4)
        perform DisplayErrorMessage thru DisplayErrorMessageEx
     end-if
     go CtrFieldsEx.
 CTR02.
     *> code in this company (we decide to always convert lowercase to uppercase)
     inspect AnageCodAge converting 'abcdefghijklmnopqrstuvwxyz' to 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
     display AnageCodAge at 0570 with  Background-Color abc Foreground-Color afc reverse-video
     if AnageCodAge = space
        set Errors to true
        move '                              ' & x'00' to bxm-mex(1)
        move '          >>> ERROR <<<       ' & x'00' to bxm-mex(2)
        move '                              ' & x'00' to bxm-mex(3)
        move '  Type a CODE                 ' & x'00' to bxm-mex(4)
        perform DisplayErrorMessage thru DisplayErrorMessageEx
     end-if
     go CtrFieldsEx.
 CTR03.
     *> fiscal code (we decide to always convert lowercase to uppercase)
     Inspect AnageCodFis converting 'abcdefghijklmnopqrstuvwxyz' to 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
     display AnageCodFis at 0627 with Background-Color abc Foreground-Color afc reverse-video
     if AnageCodFis = space
        set Errors to true
        move '                              ' & x'00' to bxm-mex(1)
        move '          >>> ERROR <<<       ' & x'00' to bxm-mex(2)
        move '                              ' & x'00' to bxm-mex(3)
        move '  Enter a Fiscal Code         ' & x'00' to bxm-mex(4)
        move '                              ' & x'00' to bxm-mex(5)
        move '                              ' & x'00' to bxm-mex(6)
        move '                              ' & x'00' to bxm-mex(7)
        perform DisplayErrorMessage thru DisplayErrorMessageEx
     end-if
     go CtrFieldsEx.
 CTR04.
      go CtrFieldsEx.
 CTR05.
     *> matricola  (we decide to allow only digits)
     if AnageMatEna not = space
         if AnageMatEna is not numeric
            set Errors to true
            move '                              ' & x'00' to bxm-mex(1)
            move '                              ' & x'00' to bxm-mex(2)
            move '  Matricola errata !          ' & x'00' to bxm-mex(3)
            move '  Type 8 digits  or all space ' & x'00' to bxm-mex(4)
            move '                              ' & x'00' to bxm-mex(5)
            move '                              ' & x'00' to bxm-mex(6)
            move '                              ' & x'00' to bxm-mex(7)
            perform DisplayErrorMessage thru DisplayErrorMessageEx
         end-if
     end-if
     go CtrFieldsEx.
 CTR06.
        continue go CtrFieldsEx.
 CTR07.
        continue go CtrFieldsEx.
 CTR08.
        continue go CtrFieldsEx.
 CTR09.
 *> just convert lower to upper case
     Inspect AnageProLeg converting 'abcdefghijklmnopqrstuvwxyz' to 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
     display AnageProLeg at 0878 with  Background-Color abc Foreground-Color afc reverse-video
     go CtrFieldsEx.
 CTR10.
     continue go CtrFieldsEx.
 CTR11.
     *> date of birth (not mandatory)
     If AnageDatana = space
        continue
     else
        if function test-date-yyyymmdd(AnageDataNa9) not = 0
          perform DisplayDateMessage thru DisplayDateMessageEx
        end-if
     end-if
     go CtrFieldsEx.
 CTR12.
     *> provincia di nascita
     Inspect AnageProvNa converting 'abcdefghijklmnopqrstuvwxyz' to 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
     display AnageProvNa at 0978 with  Background-Color abc Foreground-Color afc reverse-video
     go CtrFieldsEx.
 CTR13. continue go CtrFieldsEx.
 CTR14. continue go CtrFieldsEx.
 CTR15. continue go CtrFieldsEx.
 CTR16.
     Inspect AnageTipCon converting 'mp' to 'MP'
     display AnageTipCon at 1127 with  Background-Color abc Foreground-Color afc reverse-video
     if AnageTipCon = 'M'
          display 'MONO MANDATE    ' at 1129 with  Background-Color dbc Foreground-Color dfc
     else
        if AnageTipCon = 'P'
           display 'PLURI MANDATE  ' at 1129 with  Background-Color dbc Foreground-Color dfc
        else
           display '???????????????' at 1129 with  Background-Color dbc Foreground-Color dfc
           set Errors to true
           move '                              ' & x'00' to bxm-mex(1)
           move '  Wrong Contract Type !       ' & x'00' to bxm-mex(2)
           move '  M = mono mandate            ' & x'00' to bxm-mex(3)
           move '  P = pluri mandate           ' & x'00' to bxm-mex(4)
           move '                              ' & x'00' to bxm-mex(5)
           move '                              ' & x'00' to bxm-mex(6)
           move '                              ' & x'00' to bxm-mex(7)
           perform DisplayErrorMessage thru DisplayErrorMessageEx
        end-if
     end-if
     go CtrFieldsEx.
 CTR17.
     inspect AnageTipSog converting 'apcs' to 'APCS'
     display AnageTipSog at 1227 with  Background-Color abc Foreground-Color afc reverse-video

     evaluate AnageTipSog
     when 'A' display 'AGENT                   ' at 1229 with  Background-Color dbc Foreground-Color dfc
     when 'P' display 'PEOPLE COMPANY          ' at 1229 with  Background-Color dbc Foreground-Color dfc
     when 'C' display 'CAPITAL COMPANY         ' at 1229 with  Background-Color dbc Foreground-Color dfc
     when other
      display '???????????????'                  at 1229 with  Background-Color dbc Foreground-Color dfc
      set Errors to true
      move ' Wrong Subject Type !         ' & x'00' to bxm-mex(1)
      move ' A= AGENT                     ' & x'00' to bxm-mex(2)
      move ' P= PEOPLE COMPANY            ' & x'00' to bxm-mex(3)
      move ' C= CAPITAL COMPANY           ' & x'00' to bxm-mex(4)
      move '                              ' & x'00' to bxm-mex(5)
      move '                              ' & x'00' to bxm-mex(6)
      move '                              ' & x'00' to bxm-mex(7)
      perform DisplayErrorMessage thru DisplayErrorMessageEx
     end-evaluate
     go CtrFieldsEx.
 CTR18.
     *> data inizio attivita' - obbligatoria
     if AnageDataIn = space
        set Errors to true
        move '                              ' & x'00' to bxm-mex(1)
        move '        þþþ WARNING þþþ       ' & x'00' to bxm-mex(2)
        move '                              ' & x'00' to bxm-mex(3)
        move ' Start Date is mandatory.     ' & x'00' to bxm-mex(4)
        move ' Type F4 to have a Date Picker' & x'00' to bxm-mex(5)
        move '                              ' & x'00' to bxm-mex(6)
        move '                              ' & x'00' to bxm-mex(7)
        perform DisplayErrorMessage thru DisplayErrorMessageEx
     else
        if function test-date-yyyymmdd(AnageDataIn9) not = 0
           perform DisplayDateMessage thru DisplayDateMessageEx
        end-if
     end-if
     go CtrFieldsEx.
 CTR19.
     *> data cessazione (campo facltativo)
     If AnageDataCe = space
        continue
     else
        if function test-date-yyyymmdd(AnageDataCe9) not = 0
           perform DisplayDateMessage thru DisplayDateMessageEx
        else
          if AnageDataCe <= AnageDataIn
             set Errors to true
             move '                             '  & x'00' to bxm-mex(1)
             move ' End date must be            '  & x'00' to bxm-mex(2)
             move ' greater than Start date     '  & x'00' to bxm-mex(3)
             move ' F4 to have a Date Picker    '  & x'00' to bxm-mex(4)
             move '                             '  & x'00' to bxm-mex(5)
             move '                             '  & x'00' to bxm-mex(6)
             move '                             '  & x'00' to bxm-mex(7)
             perform DisplayErrorMessage thru DisplayErrorMessageEx
          end-if
        end-if
     end-if
     go CtrFieldsEx.
 CTR20.
      *> tipo cessazione
      inspect AnageTipoCe converting 'abcdefghijklmnopqrstuvwxyz' to 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
      display AnageTipoCe at 1478 with  Background-Color abc Foreground-Color afc reverse-video
     if AnageDataCe not = space
        if AnageTipoCe = 'D' or 'P' or 'I' or 'L'
           continue
        else
           set Errors to true
           move ' Digitare tipo cessazione:   '  & x'00' to bxm-mex(1)
           move ' D= Dimissionario            '  & x'00' to bxm-mex(2)
           move ' P= Dimissionario x raggiun- '  & x'00' to bxm-mex(3)
           move '    ta eta'' pensionabile o   ' & x'00' to bxm-mex(4)
           move ' I= invalidita'' permenente   ' & x'00' to bxm-mex(5)
           move '    e totale                 '  & x'00' to bxm-mex(6)
           move ' L= Disdettato dall''azienda  ' & x'00' to bxm-mex(7)
           perform DisplayErrorMessage thru DisplayErrorMessageEx
        end-if
     else
        if AnageTipoCe = space
           continue
      else
           set Errors to true
           move '                             '  & x'00' to bxm-mex(1)
           move ' Tipo cessazione deve essere '  & x'00' to bxm-mex(2)
           move ' specificato solo per gli a- '  & x'00' to bxm-mex(3)
           move ' genti cessati !             '  & x'00' to bxm-mex(4)
           move '                             '  & x'00' to bxm-mex(5)
           move '                             ' & x'00' to bxm-mex(6)
           move '                             '  & x'00' to bxm-mex(7)
           perform DisplayErrorMessage thru DisplayErrorMessageEx
      end-if
     end-if
     go CtrFieldsEx.
 CTR21.
  *> importo anticipo spese
  *> ------------------------------------------------------------------------------------------
  *> HOW TO ACCEPT A SIGNED NUMERIC FILED WITH 9 DIGIT, 7 INTEGERS AND 2 DECIMALS, ON SCREEN:
  *> a) make an accept from a corresponding field PIC X(11) =  9 + 1 for comma + 1 for sign
  *> b) use a corresponding edited field pic -(7)9,99.
  *> c) make FUNCTION TEST-NUMVAL over the pic x field to check the field content / user input
  *> d) if field is empty the function returns the field legth + 1 = 12
  *> e) if there is a wrong char the function returns the position of this wrong char = from 1 to 11
  *> f) else the function returns zero.
  *> g) in this case FUNTION NUMVAL converts pic x field to pic 9 field
  *> ------------------------------------------------------------------------------------------
  if function test-numval(AnageAnticiX) > length of AnageAnticiX
     move zero to AnageAnticiX
     move function numval(AnageAnticiX) to AnageAntici AnageAnticiZ
     move AnageAnticiZ to AnageAnticiX
     display AnageAnticiX  at 1527 with Background-Color abc Foreground-Color afc reverse-video
  else
     if function test-numval(AnageAnticiX) not = ZERO
        set Errors to true
        move '                             '  & x'00' to bxm-mex(1)
        move ' wrong numeric format        '  & x'00' to bxm-mex(2)
        move ' must be: nnnnnnn,nn         '  & x'00' to bxm-mex(3)
        move '                             '  & x'00' to bxm-mex(4)
        move '                             '  & x'00' to bxm-mex(5)
        move '                             '  & x'00' to bxm-mex(6)
        move '                             '  & x'00' to bxm-mex(7)
        perform DisplayErrorMessage thru DisplayErrorMessageEx
     else
        move function numval(AnageAnticiX) to AnageAntici AnageAnticiZ
        move AnageAnticiZ to AnageAnticiX
        display AnageAnticiX at 1527 with Background-Color abc Foreground-Color afc reverse-video
      end-if
  end-if
  go CtrFieldsEx.
 CTR22.
   *> Contributo spese
   if function test-numval(AnageConSpeX) > length of AnageConSpeX
     move zero to AnageConSpeX
     move function numval(AnageConSpeX) to AnageConSpe AnageConSpeZ
     move AnageConSpeZ to AnageConSpeX
     display AnageConSpeX  at 1566 with Background-Color abc Foreground-Color afc reverse-video
  else
     if function test-numval(AnageConSpeX) not = ZERO
        set Errors to true
        move '                             '  & x'00' to bxm-mex(1)
        move ' wrong numeric format        '  & x'00' to bxm-mex(2)
        move ' must be: nnnnnnn,nn         '  & x'00' to bxm-mex(3)
        move '                             '  & x'00' to bxm-mex(4)
        move '                             '  & x'00' to bxm-mex(5)
        move '                             '  & x'00' to bxm-mex(6)
        move '                             '  & x'00' to bxm-mex(7)
        perform DisplayErrorMessage thru DisplayErrorMessageEx
     else
        move function numval(AnageConSpeX) to AnageConSpe AnageConSpeZ
        move AnageConSpeZ to AnageConSpeX
        display AnageConSpeX at 1566 with Background-Color abc Foreground-Color afc reverse-video
      end-if
  end-if
  go CtrFieldsEx.
 CTR23.
    *> trattenuta sindacale
    if function test-numval(AnageTraSinX) > length of AnageTraSinX
     move zero to AnageTraSinX
     move function numval(AnageTraSinX) to AnageConSpe AnageTraSinZ
     move AnageTraSinZ to AnageTraSinX
     display AnageTraSinX  at 1627 with Background-Color abc Foreground-Color afc reverse-video
  else
     if function test-numval(AnageTraSinX) not = ZERO
        set Errors to true
        move '                             '  & x'00' to bxm-mex(1)
        move ' wrong numeric format        '  & x'00' to bxm-mex(2)
        move ' must be: nnnnnnn,nn         '  & x'00' to bxm-mex(3)
        move '                             '  & x'00' to bxm-mex(4)
        move '                             '  & x'00' to bxm-mex(5)
        move '                             '  & x'00' to bxm-mex(6)
        move '                             '  & x'00' to bxm-mex(7)
        perform DisplayErrorMessage thru DisplayErrorMessageEx
     else
        move function numval(AnageTraSinX) to AnageTraSin AnageTraSinZ
        move AnageTraSinZ to AnageTraSinX
        display AnageTraSinX at 1627 with Background-Color abc Foreground-Color afc reverse-video
      end-if
  end-if
  go CtrFieldsEx.
 CTR24.
      *> tipo liquidazione (campo obbligatorio)
      inspect AnageTipLiq converting 'abcdefghijklmnopqrstuvwxyz' to 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
      display AnageTipLiq at 1666 with  Background-Color abc Foreground-Color afc reverse-video
     if AnageTipLiq = 'M' or 'T'
        continue
     else
        set Errors to true
        move ' Digitare TIPO LIQUIDAZIONE: ' & x'00' to bxm-mex(1)
        move '                             ' & x'00' to bxm-mex(2)
        move ' M= monthly payment          ' & x'00' to bxm-mex(3)
        move '                             ' & x'00' to bxm-mex(4)
        move ' T= Quarterly payment        ' & x'00' to bxm-mex(5)
        move '                             ' & x'00' to bxm-mex(6)
        move '                             ' & x'00' to bxm-mex(7)
        perform DisplayErrorMessage thru DisplayErrorMessageEx
     end-if
     go CtrFieldsEx.
 CTR25.
     if AnageSubage = ' ' or 'Y' or 'y'
        inspect AnageSubAge converting 'y' to 'Y'
        display AnageSubAge at 1727 with  Background-Color abc Foreground-Color afc reverse-video
     else
        set Errors to true
        move '                             ' & x'00' to bxm-mex(1)
        move ' Type "Y" if Agent has       ' & x'00' to bxm-mex(2)
        move ' subagents                   ' & x'00' to bxm-mex(3)
        move ' or leave  blank             ' & x'00' to bxm-mex(4)
        move '                             ' & x'00' to bxm-mex(5)
        move '                             ' & x'00' to bxm-mex(6)
        move '                             ' & x'00' to bxm-mex(7)
        perform DisplayErrorMessage thru DisplayErrorMessageEx
        end-if
     go CtrFieldsEx.
 CTR26.
     *> perc.IVA
     if AnagePerIva > 0
       continue
     else
        set Errors to true
        move ' Type VAT %                  ' & x'00' to bxm-mex(1)
        move '                             ' & x'00' to bxm-mex(2)
        move ' example:                    ' & x'00' to bxm-mex(3)
        move '  4%  --> type  04           ' & x'00' to bxm-mex(4)
        move ' 10%  --> type  10           ' & x'00' to bxm-mex(5)
        move ' ... etc.                    ' & x'00' to bxm-mex(6)
        move '                             ' & x'00' to bxm-mex(7)
        perform DisplayErrorMessage thru DisplayErrorMessageEx
     end-if
     go CtrFieldsEx.
 CTR27.
     if AnageNumAut = ' ' or 'Y' or 'y'
        inspect AnageNumAut converting 'y' to 'Y'
        display AnageNumAut at 1766 with  Background-Color abc Foreground-Color afc reverse-video
     else
        set Errors to true
        move '                             ' & x'00' to bxm-mex(1)
        move ' Type "Y" if requested       ' & x'00' to bxm-mex(2)
        move ' invoices automatic          ' & x'00' to bxm-mex(3)
        move ' numbering.                  ' & x'00' to bxm-mex(4)
        move '                             ' & x'00' to bxm-mex(5)
        move '                             ' & x'00' to bxm-mex(6)
        move '                             ' & x'00' to bxm-mex(7)
        perform DisplayErrorMessage thru DisplayErrorMessageEx
      end-if
     go CtrFieldsEx.
 CTR28.
     *> sex is mandatory when AGENT
     inspect AnageSesso  converting 'abcdefghijklmnopqrstuvwxyz' to 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
     display AnageSesso  at 1778 with  Background-Color abc Foreground-Color afc reverse-video
     if AnageTipSog     = 'A' and (AnageSesso = 'M' or 'F') go CtrFieldsEx end-if
     if AnageTipSog not = 'A' and AnageSesso  = ' '         go CtrFieldsEx end-if
     set Errors to true
     move '                             ' & x'00' to bxm-mex(1)
     move ' if AGENT                    ' & x'00' to bxm-mex(2)
     move ' type sex M or F             ' & x'00' to bxm-mex(3)
     move '                             ' & x'00' to bxm-mex(4)
     move ' if PEOPLE or CAPITAL        ' & x'00' to bxm-mex(5)
     move ' COMPANY do not type sex     ' & x'00' to bxm-mex(6)
     move '                             ' & x'00' to bxm-mex(7)
     perform DisplayErrorMessage thru DisplayErrorMessageEx
     go CtrFieldsEx.
 CTR29.
        continue go CtrFieldsEx.
 CTR30.
        continue go CtrFieldsEx.
 CTR31.
        continue go CtrFieldsEx.
 CTR32.
  if function test-numval(AnageCapSocX) > length of AnageCapSocX
     move zero to AnageCapSocX
     move function numval(AnageCapSocX) to AnageCapSoc AnageCapSocZ
     move AnageCapSocZ to AnageCapSocX
     display AnageCapSocX  at 1966 with Background-Color abc Foreground-Color afc reverse-video
  else
     if function test-numval(AnageCapSocX) not = ZERO
        set Errors to true
        move '                             '  & x'00' to bxm-mex(1)
        move ' wrong numeric format        '  & x'00' to bxm-mex(2)
        move ' must be: nnnnnnnnnnnn       '  & x'00' to bxm-mex(3)
        move '                             '  & x'00' to bxm-mex(4)
        move '                             '  & x'00' to bxm-mex(5)
        move '                             '  & x'00' to bxm-mex(6)
        move '                             '  & x'00' to bxm-mex(7)
        perform DisplayErrorMessage thru DisplayErrorMessageEx
     else
        move function numval(AnageCapSocX) to AnageCapSoc AnageCapSocZ
        move AnageCapSocZ to AnageCapSocX
        display AnageCapSocX at 1966 with Background-Color abc Foreground-Color afc reverse-video
      end-if
  end-if
  go CtrFieldsEx.
 CTR33. continue go CtrFieldsEx.
 CTR34. continue go CtrFieldsEx.
 CTR35. continue go CtrFieldsEx.
 CTR36. continue go CtrFieldsEx.
 CTR37. continue go CtrFieldsEx.
 CTR38. continue go CtrFieldsEx.
 CTR39. continue go CtrFieldsEx.
 CTR40.
  if function test-numval(AnageAssicuX) > length of AnageAssicuX
     move zero to AnageAssicuX
     move function numval(AnageAssicuX) to AnageAssicu AnageAssicuZ
     move AnageAssicuZ to AnageAssicuX
     display AnageAssicuX  at 2266 with Background-Color abc Foreground-Color afc reverse-video
  else
     if function test-numval(AnageAssicuX) not = ZERO
        set Errors to true
        move '                             '  & x'00' to bxm-mex(1)
        move ' wrong numeric format        '  & x'00' to bxm-mex(2)
        move ' must be: nnnnn,nn           '  & x'00' to bxm-mex(3)
        move '                             '  & x'00' to bxm-mex(4)
        move '                             '  & x'00' to bxm-mex(5)
        move '                             '  & x'00' to bxm-mex(6)
        move '                             '  & x'00' to bxm-mex(7)
        perform DisplayErrorMessage thru DisplayErrorMessageEx
     else
        move function numval(AnageAssicuX) to AnageAssicu AnageAssicuZ
        move AnageAssicuZ to AnageAssicuX
        display AnageAssicuX at 2266 with Background-Color abc Foreground-Color afc reverse-video
      end-if
  end-if.


 CtrFieldsEnd.
     *> **********************************************************
     *> END OF CONTROLS
     *> **********************************************************
     *> Each filed is cheched when the user press enter on it.
     *> after cursor has passed the last field on screen, at end of controls
     *> CREATE or UPDATE or DELETE the record is enabled.
     *> This behavior ensure all fields are checked
     *> **********************************************************

     set     Operation-Enabled to true
     move    DescOperation     to ExecuteOper (15:12)
     display ExecuteOper at 2560 with  Background-Color green Foreground-Color white.
 CtrFieldsEx. exit.




*> *************************************************************
*>                          W R I T E
*> *************************************************************
Record-Write.
   *> open and close the file at every record create, safer against system failure
   Open I-O ANAGE

   if AnageFS = '05' or '35' or '92'
     *> **********************************************************
     *> if FILE does not exist insert the first record
     *> **********************************************************
      perform Record-Create thru Record-CreateEx
      move space to AnageRec
      initialize AnageRec
      perform DisplayDataOnScreen thru DisplayDataOnScreenEx

   *> **********************************************************
   *> if FILE exist insert the new record (Open is OK)
   *> **********************************************************
   else
      *> ***************************** read record with last REC.ID
      move 999999999 to   FdAnageKey
      read ANAGE     into Anage999Rec Key is FdAnageKey
      if AnageFS = '00'
         add 1 to Anage999ctr
      else
         *> key 999999999 not found !!!!!!
         string '  File status = ' AnageFS ' !!!!!!! ' & x'00' delimited by size into bxm-mex(4)
         move   ' Error,key 999999999 not found'       & x'00' to bxm-mex(5)
         perform DisplayFileMessage thru DisplayFileMessageEx
         stop run
      end-if
      *> ******************************* write new record
      move  Anage999ctr  to  Anagekey
      write FdAnageRec from AnageRec

      evaluate AnageFS
        when '00'
           *> update the record with key counter (REC.ID)
           Rewrite FdAnageRec from Anage999Rec
           set Operation-Not-Enabled to true
           *> move space to "F12 EXECUTE'
           display  '                          ' at 2560 with Background-Color green Foreground-Color white
           move low-value to wString
           string '      REC.ID '  AnageKey(5:5) ' ADDED      ' x'00' into wString end-string
           move wString to bxm-mex(4)
           perform DisplayFileMessage thru DisplayFileMessageEx
           move space to AnageRec
           initialize AnageRec
           perform DisplayDataOnScreen thru DisplayDataOnScreenEx
        when  '22'
           *> there is/are duplicate on at least one of the slternative keys
           *> check which one of the altrenative keys are duplicated
           perform Alternate-DupKeyCheck thru Alternate-DupKeyCheckEx
           move '         - WARNING -          ' & x'00' to bxm-mex(1)
           move ' one of following keys        ' & x'00' to bxm-mex(2)
           move ' already exist:               ' & x'00' to bxm-mex(3)
           move ' -NAME                        ' & x'00' to bxm-mex(4)
           move ' -CODE                        ' & x'00' to bxm-mex(5)
           move ' -FISCALCODE                  ' & x'00' to bxm-mex(6)
           move ' duplicates are not allowed   ' & x'00' to bxm-mex(7)
           if DupKeyAlt-RagSoc = 'Y' move 'IS DUPLICATED    ' to bxm-mex(4) (14:17)
           else                            move 'IS NOT DUPLICATED' to bxm-mex(4) (14:17) end-if
           if DupKeyAlt-CodAge = 'Y' move 'IS DUPLICATED    ' to bxm-mex(5) (14:17)
           else                            move 'IS NOT DUPLICATED' to bxm-mex(5) (14:17) end-if
           if DupKeyAlt-CodFis = 'Y' move 'IS DUPLICATED    ' to bxm-mex(6) (14:17)
           else                            move 'IS NOT DUPLICATED' to bxm-mex(6) (14:17) end-if
           perform DisplayErrorMessage thru DisplayErrorMessageEx
        when  other
           string '  File status = ' AnageFS ' !!!!!!! ' & x'00' delimited by size into bxm-mex(4)
           perform DisplayFileMessage thru DisplayFileMessageEx
      end-evaluate
   end-if

   close ANAGE.
Record-WriteEx. exit.

*> *************************************************************
*>            C R E A T E   ( = F I R S T    W R I T E )
*> *************************************************************
Record-Create.
   *> first insert of one record and insertion of the record with keys counter
   Open Output ANAGE
   if AnageFS not = '00'
      string '  Fs OPEN OUT = ' AnageFS ' !!!!!!! ' & x'00' delimited by size into bxm-mex(4)
      perform DisplayFileMessage thru DisplayFileMessageEx
   end-if

   *> write the first data record
   move  1 to   AnageKey
   write FdAnageRec from AnageRec

   if AnageFS = '00'
      set Operation-Not-Enabled to true
      display  '                          ' at 2560 with Background-Color green Foreground-Color white
      move ' File created. Insert 1st Rec.' & x'00' to bxm-mex(4)
      perform DisplayFileMessage thru DisplayFileMessageEx

      *> generate record with key counter
      move space     to Anage999Rec
      initialize        Anage999Rec
      move 999999999 to Anage999Key
      move         1 to Anage999ctr
      write FdAnageRec from Anage999Rec
      if AnageFS not = '00'
         string '  Fs WRITE 1  = ' AnageFS ' !!!!!!! ' & x'00' delimited by size into bxm-mex(4)
         perform DisplayFileMessage thru DisplayFileMessageEx
      end-if
   else
      string '  File status = ' AnageFS ' !!!!!!! ' & x'00' delimited by size into bxm-mex(4)
      perform DisplayFileMessage thru DisplayFileMessageEx
   end-if
   close ANAGE.
Record-CreateEx. exit.

*> *************************************************************
*>                      R E W R I T E
*> *************************************************************
Record-Rewrite.
   *> program open and close the file at every record update, safer against system failure
   Open I-O ANAGE

   *> *****************************************************************************
   *> TEST FOR DUPLICATE ALTERNATIVE KEYS BERFORE EXECUTE REWRITE
   *> if the user  has changed one of the akt key fiedls on screen
   *> we have to check if the new value is duplicated (duplicate are not allowed)
   *> (in case of duplicate alternative key/s the standard FILE STATUS is 22 but
   *> the system doesn't tell you which one of the key/Keys is duplicated)
   if AnageRagSoc = SavedRagSoc
      Set DupKeyAlt-RagSoc-no  to true
   else
      move  AnageRagSoc to FdAnageRagSoc
      Start ANAGE key = FdAnageRagSoc
                      invalid key Set DupKeyAlt-RagSoc-no  to true
                  not invalid key Set DupKeyAlt-RagSoc-yes to true end-start
   end-if

   if AnageCodAge = SavedCodAge
      Set DupKeyAlt-CodAge-no  to true
   else
      move  AnageCodAge to FdAnageCodAge
      Start ANAGE key = FdAnageCodAge
                      invalid key Set DupKeyAlt-CodAge-no  to true
                  not invalid key Set DupKeyAlt-CodAge-yes to true end-start
   end-if
   if AnageCodFis = SavedCodFis
      Set DupKeyAlt-CodFis-no  to true
   else
      move  AnageCodFis to FdAnageCodFis
      Start ANAGE key = FdAnageCodFis
                      invalid key Set DupKeyAlt-CodFis-no  to true
                  not invalid key Set DupKeyAlt-CodFis-yes to true end-start
   end-if

   if DupKeyAlt-RagSoc-yes or DupKeyAlt-CodAge-yes or DupKeyAlt-CodFis-yes
        *> there is/are duplicate on at least one of the slternative keys !
        *> check which one of the alternative keys are duplicated
        *> skip the rewrite statement
        move '         > WARNING <          ' & x'00' to bxm-mex(1)
        move ' one of following keys        ' & x'00' to bxm-mex(2)
        move ' already exist:               ' & x'00' to bxm-mex(3)
        move ' -NAME                        ' & x'00' to bxm-mex(4)
        move ' -CODE                        ' & x'00' to bxm-mex(5)
        move ' -FISCALCODE                  ' & x'00' to bxm-mex(6)
        move ' duplicates are not allowed   ' & x'00' to bxm-mex(7)
        if DupKeyAlt-RagSoc-yes move 'IS DUPLICATED    ' to bxm-mex(4) (14:17)
        else                    move 'IS NOT DUPLICATED' to bxm-mex(4) (14:17) end-if
        if DupKeyAlt-CodAge-yes move 'IS DUPLICATED    ' to bxm-mex(5) (14:17)
        else                    move 'IS NOT DUPLICATED' to bxm-mex(5) (14:17) end-if
        if DupKeyAlt-CodFis-yes move 'IS DUPLICATED    ' to bxm-mex(6) (14:17)
        else                    move 'IS NOT DUPLICATED' to bxm-mex(6) (14:17) end-if
        perform DisplayErrorMessage thru DisplayErrorMessageEx
        Set DupKeyAlt-CodAge-no DupKeyAlt-CodFis-no DupKeyAlt-RagSoc-no to true
        go to Record-RewriteEx
   end-if

   *> if user has not changed none of alternative keys on screen
   *> or if new values are not duplicated, we can do the rewrite
   Rewrite  FdAnageRec from AnageRec

   Evaluate AnageFS
     when '00'
          set Operation-Not-Enabled to true
          *> move space to "F12 EXECUTE' on  menu 25 row
          display  '                          ' at 2560 with Background-Color green Foreground-Color white
          move low-value to wString
          string '     REC.ID '  AnageKey(5:5) ' UPDATED     ' x'00'  into wString end-string
          move wString to bxm-mex(4)
          perform DisplayFileMessage thru DisplayFileMessageEx
     when  '22'
        *> du eto the previuos test this will never happen on rewrite
        string '  File status = ' AnageFS ' !!!!!!! ' & x'00' delimited by size into bxm-mex(4)
        perform DisplayFileMessage thru DisplayFileMessageEx
        go to Record-RewriteEx
     when  other
        string '  File status = ' AnageFS ' !!!!!!! ' & x'00' delimited by size into bxm-mex(4)
        perform DisplayFileMessage thru DisplayFileMessageEx
        go to Record-RewriteEx
   end-evaluate

   close ANAGE

*>   The program gives next record to update, the next in the order of active alternative key
*>   NB: if you have duplicate alternative key (not allowed) (example space), they are skipped !
*>       infatti se la start fosse per >= allora si leggerebbe lo stesso record !
*> --------------------------------------------------------------
*>   soluzione al problema: memorizzare la key primaria appena
*>   usata per la rewrite, fare la start per >= e fare un loop
*>   di readnext fino a leggere il record seguente a quello della
*>   key primaria appena usata per la rewrite.
*>   forse, piu' semplicemente basta fare una readnext senza fare
*>   la close del file e poi di nuovo la open !
*>
   Open I-O ANAGE
   evaluate LnkKeyActive
      when '1' start ANAGE Key > FdAnageCodAge end-start
      when '2' start ANAGE Key > FdAnageCodFis end-start
      when '3' start ANAGE Key > FdAnageRagSoc end-start
   end-evaluate
   *> 23 = key greater or equal not found ==>  EOF
   if AnageFS = '23'
      close ANAGE
      move '                              ' & x'00' to bxm-mex(1)
      move '   End of file reached        ' & x'00' to bxm-mex(2)
      move '                              ' & x'00' to bxm-mex(3)
      move '                              ' & x'00' to bxm-mex(4)
      move '                              ' & x'00' to bxm-mex(5)
      move '                              ' & x'00' to bxm-mex(6)
      move '                              ' & x'00' to bxm-mex(7)
      perform DisplayErrorMessage thru DisplayErrorMessageEx
      go to End-of-Program
   end-if

   Perform ReadNext thru ReadNextEx
   close ANAGE

   *> se eof o se letta la key col contatore delle chiavi
   if AnageFS = '10'
      close ANAGE
      move '                              ' & x'00' to bxm-mex(1)
      move '   End of file reached        ' & x'00' to bxm-mex(2)
      move '                              ' & x'00' to bxm-mex(3)
      move '                              ' & x'00' to bxm-mex(4)
      move '                              ' & x'00' to bxm-mex(5)
      move '                              ' & x'00' to bxm-mex(6)
      move '                              ' & x'00' to bxm-mex(7)
      perform DisplayErrorMessage thru DisplayErrorMessageEx
      go to End-of-Program
   end-if

   move 1 to pivot
   perform DisplayDataOnScreen thru DisplayDataOnScreenEx .
Record-RewriteEx. exit.

*> *************************************************************
*>                       D E L E T E
*> *************************************************************
Record-Delete.
   *> program open and close the file at every record delete, safer against system failure
   Open I-O ANAGE
   Delete   ANAGE
   if AnageFS = '00'
      move low-value to wString
      string '     REC.ID '  AnageKey(5:5) ' DELETED     ' x'00'  into wString end-string
      move wString to bxm-mex(4)
   else
      string '  File status = ' AnageFS ' !!!!!!! ' & x'00' delimited by size into bxm-mex(4)
   end-if
   perform DisplayFileMessage thru DisplayFileMessageEx
   Close ANAGE

*>   The program gives next record to delete, the next in the order of active alternative key
*>   NB: if you have duplicate alternative key (not allowed) (example space), they are skipped !
*>   infatti se la start fosse per >= allora si leggerebbe lo stesso record !
*>   lette una dopo l'altra in quanto la start e' per > o = dato che la key preced.e' stata deletata .
   open i-o ANAGE
   evaluate LnkKeyActive
      when '1' Start ANAGE Key >= FdAnageCodAge end-start
      when '2' Start ANAGE Key >= FdAnageCodFis end-start
      when '3' Start ANAGE Key >= FdAnageRagSoc end-start
   end-evaluate
   *> if 23 ( key > o = not found ) = ==> EOF
   if AnageFS = '23'
      close ANAGE
      move '                              ' & x'00' to bxm-mex(1)
      move '   End of FILE reached        ' & x'00' to bxm-mex(2)
      move '                              ' & x'00' to bxm-mex(3)
      move '                              ' & x'00' to bxm-mex(4)
      move '                              ' & x'00' to bxm-mex(5)
      move '                              ' & x'00' to bxm-mex(6)
      move '                              ' & x'00' to bxm-mex(7)
      perform DisplayErrorMessage thru DisplayErrorMessageEx
      go to End-of-Program
   end-if

   perform readNext thru readNextEx
   Close ANAGE
   *> at eof  read the record with record key counter
   if AnageFS = '10'
      close ANAGE
      move '                              ' & x'00' to bxm-mex(1)
      move '   End of file reached !      ' & x'00' to bxm-mex(2)
      move '                              ' & x'00' to bxm-mex(3)
      move '                              ' & x'00' to bxm-mex(4)
      move '                              ' & x'00' to bxm-mex(5)
      move '                              ' & x'00' to bxm-mex(6)
      move '                              ' & x'00' to bxm-mex(7)
      perform DisplayErrorMessage thru DisplayErrorMessageEx
      go to End-of-Program
   end-if

   perform DisplayDataOnScreen thru DisplayDataOnScreenEx .
   go to LOOP-DELETE.
Record-DeleteEx. exit.


*> ************************************************************************************
*>                             D I S P L A Y    S C R E E N
*> ************************************************************************************
DisplayDataOnScreen.
   move 1 to Pivot
   set Operation-Not-Enabled to true

   evaluate LnkFunction
      when 'C' move 'CREATE       ' to DescOperation
      when 'U' move 'UPDATE       ' to DescOperation
      when 'D' move 'DELETE       ' to DescOperation
   end-evaluate

   evaluate LnkKeyActive
      when '1' move 'CODE           ' to DescKeyActive
      when '2' move 'FISCALCODE     ' to DescKeyActive
      when '3' move 'NAME           ' to DescKeyActive
   end-evaluate

   move '001001025080' to Box-rc Move 'N' to Box-style
   set Box-bco to green
   CALL GC01BOX USING BY CONTENT BOX-AREA
   Move 'D' to Box-style

   string  ' C.R.U.DE. APPLICATION      (File: ' LnkFileName ')' delimited by size into wHeader
   display wHeader at 0101 with  Background-Color green Foreground-Color white highlight
   display ' F1-<Help> ESC-<Exit>                                                           '
                   at 2501 with  Background-Color 02 Foreground-Color 15
   display ' Operation .............:'   at 0301 with  Background-Color dbc Foreground-Color yellow highlight
   display DescOperation                 at 0327 with  Background-Color dbc Foreground-Color yellow highlight

   if LnkFunction not = 'C'
      display ' Order by: '  at 0340 with  Background-Color dbc Foreground-Color yellow highlight
      display DescKeyActive  at 0351 with  Background-Color dbc Foreground-Color yellow highlight
      display 'REC.ID: '     at 0362 with  Background-Color dbc Foreground-Color yellow highlight
      display AnageKey       at 0370 with  Background-Color dbc Foreground-Color yellow highlight
   end-if

   move '002001004080' to Box-rc
   set Box-bco to green
   move "N" to Box-fill
   CALL GC01BOX USING BY CONTENT BOX-AREA

  *> 001 ragione sociale agente
  display ' Name ..................:' at 0501 with  Background-Color dbc Foreground-Color dfc
  display AnageRagSoc                 at 0527 with  Background-Color abc Foreground-Color afc
  *> 002 codice agente nella divisione
  display ' Code..:'                  at 0561 with  Background-Color dbc Foreground-Color dfc
  display AnageCodAge                 at 0570 with  Background-Color abc Foreground-Color afc
  *> 003 codice fiscale agente
  display ' Fiscal & VAT Codes ....:' at 0601 with  Background-Color dbc Foreground-Color dfc
  display AnageCodFis                 at 0627 with  Background-Color abc Foreground-Color afc
  display AnageParIVA                 at 0646 with  Background-Color abc Foreground-Color afc
  *> 004 matricola Enasarco
  display  'UserCode:'                at 0662 with  Background-Color dbc Foreground-Color dfc
  display AnageMatEna                 at 0672 with  Background-Color abc Foreground-Color afc
  *> 005 Indirizzo
  display ' Address ...............:' at 0701 with  Background-Color dbc Foreground-Color dfc
  display AnageIndLeg                 at 0727 with  Background-Color abc Foreground-Color afc
  *> 006 Localita'
  display ' City ..................:' at 0801 with  Background-Color dbc Foreground-Color dfc
  display AnageLocLeg                 at 0827 with  Background-Color abc Foreground-Color afc
  *> 007 CAP
  display 'ZIP:'                      at 0861 with  Background-Color dbc Foreground-Color dfc
  display AnageCapLeg                 at 0866 with  Background-Color abc Foreground-Color afc
  *> 008 provincia
  display 'Prov:'                     at 0872 with  Background-Color dbc Foreground-Color dfc
  display AnageProLeg                 at 0878 with  Background-Color abc Foreground-Color afc
  *> 009 localita' di nascita
  display ' Place of birth ........:' at 0901 with  Background-Color dbc Foreground-Color dfc
  display AnageLocaNa                 at 0927 with  Background-Color abc Foreground-Color afc
  *> 010 data di nascita
  display 'il:'                       at 0959 with  Background-Color dbc Foreground-Color dfc
  display AnageDataNa                 at 0963 with  Background-Color abc Foreground-Color afc
  *> 011 provincia di nascita
  display 'Prov:'                     at 0972 with  Background-Color dbc Foreground-Color dfc
  display AnageProvNa                 at 0978 with  Background-Color abc Foreground-Color afc
  *> 011a telefono casa
  display ' Tel.home & mobile .....:' at 1001 with  Background-Color dbc Foreground-Color dfc
  display AnageTelCas                 at 1027 with  Background-Color abc Foreground-Color afc
  display AnageTelCel                 at 1043 with  Background-Color abc Foreground-Color afc
  *> 011c
  display ' Fax:'                     at 1057 with  Background-Color dbc Foreground-Color dfc
  display AnageTelFax                 at 1063 with  Background-Color abc Foreground-Color afc

  *> 012 Tipo contratto (mono/plurimandatario)
  display ' Contract Type .........:' at 1101 with  Background-Color dbc Foreground-Color dfc
  display AnageTipCon                 at 1127 with  Background-Color abc Foreground-Color afc
  if AnageTipCon = 'M'
        display 'MONO-MANDATE    ' at 1129 with  Background-Color dbc Foreground-Color dfc
  else
      if AnageTipCon = 'P'
         display 'PLURI-MANDATE  ' at 1129 with  Background-Color dbc Foreground-Color dfc
      else
         display '???????????????' at 1129 with  Background-Color dbc Foreground-Color dfc
      end-if
  end-if

  *> 013 Tipo soggetto (age.individuale, soc.persone/capitali)
  display ' Subject Type ..........:' at 1201 with  Background-Color dbc Foreground-Color dfc
  display AnageTipSog                 at 1227 with  Background-Color abc Foreground-Color afc

  evaluate AnageTipSog
     when 'A'
      display 'AGENT                   ' at 1229 with  Background-Color dbc Foreground-Color dfc
     when 'P'
      display 'PEOPLE COMPANY          ' at 1229 with  Background-Color dbc Foreground-Color dfc
     when 'C'
      display 'CAPITAL COMPANY         ' at 1229 with  Background-Color dbc Foreground-Color dfc
     when other
      display '???????????????'          at 1229 with  Background-Color dbc Foreground-Color dfc
  end-evaluate

  compute box-r1 = 13           compute box-c1 = 01
  compute box-r2 = 23           compute box-c2 = 80
  set Box-bco to green
  move "Y" to Box-fill
  CALL GC01BOX USING BY CONTENT BOX-AREA

  *> 014 data inizio rapporto di agenzia
  display ' Start Date (yyyymmdd) :'  at 1402 with  Background-Color dbc Foreground-Color dfc
  display AnageDataIn                 at 1427 with  Background-Color abc Foreground-Color afc
  *> 015 data cessazione rapporto di agenzia
  display ' End Date (yyyymmdd) ..:'  at 1441 with  Background-Color dbc Foreground-Color dfc
  display AnageDataCe                 at 1466 with  Background-Color abc Foreground-Color afc
  *> 015 tipo cessazione 1=dimiss,2=dim.x eta pens,3=disdettato
  display 'Tp:'                       at 1475 with  Background-Color dbc Foreground-Color dfc
  display AnageTipoCe                 at 1478 with  Background-Color abc Foreground-Color afc

  *> 016 anticipo fisso mensile
  display ' Monthly payment ......:'  at 1502 with  Background-Color dbc Foreground-Color dfc
  if LnkFunction = 'U' or 'D'
     move AnageAntici  to AnageAnticiZ
     move AnageAnticiZ to AnageAnticiX
  else
     move space        to AnageAnticiX
  end-if
  display AnageAnticiX                at 1527 with  Background-Color abc Foreground-Color afc

  *> 017 concorso spese fisso
  display ' Expense Contribution .:'  at 1541 with  Background-Color dbc Foreground-Color dfc
  if LnkFunction = 'U' or 'D'
      move AnageConSpe  to AnageConSpeZ
      move AnageConSpeZ to AnageConSpeX
  else
      move space        to AnageConSpeX
  end-if
  display AnageConSpeX                at 1566 with  Background-Color abc Foreground-Color afc

  *> 017 trattenuta sindacale
  display ' Union retention ......:'  at 1602 with  Background-Color dbc Foreground-Color dfc
  *> when Function is Create, display space instead 0,00
    if LnkFunction = 'U' or 'D'
     move AnageTraSin  to AnageTraSinZ
     move AnageTraSinZ to AnageTraSinX
  else
     move space        to AnageTraSinX
  end-if
  display AnageTraSinX                at 1627 with  Background-Color abc Foreground-Color afc
  *> 017 tipo liquidaz.(acconti+conguaglio o su effettivo)
  display ' Payment Type .........:'  at 1641 with  Background-Color dbc Foreground-Color dfc
  display AnageTipLiq                 at 1666 with  Background-Color abc Foreground-Color afc
  *> 018 ritenuta d'acconto
  display ' Sub Agents (Y) .......:'  at 1702 with  Background-Color dbc Foreground-Color dfc
  display AnageSubage                 at 1727 with  Background-Color abc Foreground-Color afc
  *> 019 percentuale iva in fattura
  display 'VAT %:'                    at 1731 with  Background-Color dbc Foreground-Color dfc
  display AnagePerIva                 at 1738 with  Background-Color abc Foreground-Color afc
  *> 024 numerazione automatica fatture ?
  display ' Invoices aut.numb.(Y).:'  at 1741 with  Background-Color dbc Foreground-Color dfc
  display AnageNumAut                 at 1766 with  Background-Color abc Foreground-Color afc
  *> 025 sesso
  display  ' Sex M/F .:'              at 1767 with  Background-Color dbc Foreground-Color dfc
  display AnageSesso                  at 1778 with  Background-Color abc Foreground-Color afc
  *> 020 Numero camera di commercio
  display ' Reg.code CCIAA .......:'  at 1802 with  Background-Color dbc Foreground-Color dfc
  display AnageCamCom                 at 1827 with  Background-Color abc Foreground-Color afc
  *> 021 Num.iscriz.al registro ditte
  display ' Company Register code.:'  at 1841 with  Background-Color dbc Foreground-Color dfc
  display AnageNumRuo                 at 1866 with  Background-Color abc Foreground-Color afc
  *> 020 ex Iscriz.al tribunale ora reg.delle imprese
  display ' Business Register Code:'  at 1902 with  Background-Color dbc Foreground-Color dfc
  display AnageIscTri                 at 1927 with  Background-Color abc Foreground-Color afc
  *> 021 Capitale sociale
  display ' Capital Stock ..:'        at 1947 with  Background-Color dbc Foreground-Color dfc
  *> display AnageCapSoc                 at 1966 with  Background-Color abc Foreground-Color afc
  if LnkFunction = 'U' or 'D'
     move AnageCapSoc  to AnageCapSocZ
     move AnageCapSocZ to AnageCapSocX
  else
     move space        to AnageCapSocX
  end-if
  display AnageCapSocX                at 1966 with  Background-Color abc Foreground-Color afc
  *> 022 codice fornitore in contabilita' fornitori
  display ' Vendor Code ..........:'  at 2002 with  Background-Color dbc Foreground-Color dfc
  display AnageCodFor                 at 2027 with  Background-Color abc Foreground-Color afc
  *> 023 centro di costo per statistiche div.bevande
  display ' Cost Center ..........:'  at 2041 with  Background-Color dbc Foreground-Color dfc
  display AnageCodcdc                 at 2066 with  Background-Color abc Foreground-Color afc
  *> 025 Rete di vendita
  display ' Netw & Sales Area ....:'  at 2102 with  Background-Color dbc Foreground-Color dfc
  display AnageReteVe                 at 2127 with  Background-Color abc Foreground-Color afc
  *> 026 Zona di vendita
  display AnageZonaVe                 at 2134 with  Background-Color abc Foreground-Color afc
  *> 024 casella postale uff.posta interno (div.bevande)
  display ' P.O. Box .............:'  at 2141 with  Background-Color dbc Foreground-Color dfc
  display AnageCasPos                 at 2166 with  Background-Color abc Foreground-Color afc
  *> 025 Descrizione % provvigioni
  display ' Perc.Commission ......:'  at 2202 with  Background-Color dbc Foreground-Color dfc
  display AnageProvvi                 at 2227 with  Background-Color abc Foreground-Color afc
  *> 024 assicuraz.da trattenere da firr
  display ' Insur.:'                  at 2257 with  Background-Color dbc Foreground-Color dfc
  if LnkFunction = 'U' or 'D'
     move AnageAssicu  to AnageAssicuZ
     move AnageAssicuZ to AnageAssicuX
  else
     move space        to AnageAssicuX
  end-if
  display AnageAssicuX                at 2266 with  Background-Color abc Foreground-Color afc
  *> 024 Settore contabile
  display ' Set.Cont:'                at 2241 with  Background-Color dbc Foreground-Color dfc
  display AnageSetCon                 at 2252 with  Background-Color abc Foreground-Color afc .
DisplayDataOnScreenEx. exit.


Readnext.
   Read ANAGE next into AnageRec
   *> skip the record whit key counter
   if FdAnageKey = 999999999
      read ANAGE next into AnageRec
   end-if .
   move AnageCodAge to SavedCodAge
   move AnageCodFis to SavedCodFis
   move AnageRagSoc to SavedRagSoc.
ReadnextEx. exit.

Alternate-DupKeyCheck.
*> idea code courtesy from Luke Smith.
*> we have 3 alternative keys on the file without duplicates check wich one is duplicate
*> Aternate 1.
   Start ANAGE key is equal to FdAnageCodAge
                   invalid key Set DupKeyAlt-CodAge-no  to true
               not invalid key Set DupKeyAlt-CodAge-yes to true end-start
*> Aternate 2.
   Start ANAGE key is equal to FdAnageCodFis
                   invalid key Set DupKeyAlt-CodFis-no  to true
               not invalid key Set DupKeyAlt-CodFis-yes to true end-start
*> Aternate 3.
   Start ANAGE key is equal to FdAnageRagSoc
                   invalid key Set DupKeyAlt-RagSoc-no  to true
               not invalid key Set DupKeyAlt-RagSoc-yes to true end-start.
Alternate-DupKeyCheckEx. Exit.

DisplayFileMessage.
   move '                              ' & x'00' to bxm-mex(1)
   move '      - - = o O o = - -       ' & x'00' to bxm-mex(2)
   move '                              ' & x'00' to bxm-mex(3)
   move '                              ' & x'00' to bxm-mex(5)
   move '                              ' & x'00' to bxm-mex(6)
   move '                              ' & x'00' to bxm-mex(7)
   perform DisplayErrorMessage thru DisplayErrorMessageEx .
DisplayFileMessageEx. exit.

DisplayDateMessage.
   set Errors to true
   move '                              ' & x'00' to bxm-mex(1)
   move '   Wrong Date !               ' & x'00' to bxm-mex(2)
   move '                              ' & x'00' to bxm-mex(3)
   move '   must be --> YYYYMMDD       ' & x'00' to bxm-mex(4)
   move '   F4 = Date Picker           ' & x'00' to bxm-mex(5)
   move '                              ' & x'00' to bxm-mex(6)
   move '                              ' & x'00' to bxm-mex(7)
   perform DisplayErrorMessage thru DisplayErrorMessageEx .
DisplayDateMessageEx. exit.

DisplayErrorMessage.
   perform ScreenSave thru ScreenSaveEx
   move '010020019051' to Bxm-rc
   move red to Bxm-bco Bxm-bcoM move white to Bxm-fco Bxm-fcoM
   move 'Y' to Bxm-fcoH
   move 'S' to Bxm-style
   call GC02BOXMEX using BOXMEX-AREA
   initialize Bxm-tabmex all to value
   perform ScreenRestore thru ScreenRestoreEx .
DisplayErrorMessageEx. exit.

Help.
   move 'GC74HELPFILE.DAT' to HeFile
   call GC74HELPVIEW using Help-Area.
HelpEx. exit.

ScreenSave.
   move Z'BOXMEX.SCR' to wScreenName
   call static 'scr_dump' using by reference wScreenName returning wiScrOk end-call.
ScreenSaveEx. Exit.

ScreenRestore.
   call static 'scr_restore' using by reference wScreenName returning wiScrOk end-call
   CALL 'CBL_DELETE_FILE' USING wScreenName.
ScreenRestoreEx. Exit.

DatePicker.
   perform ScreenSave thru ScreenSaveEx
   move 'S'  to Dtp-dim
   move '010035' to Dtp-r1c1
   call GC56DATEPICKER  using DatePicker-Area cancel GC56DATEPICKER
   perform ScreenRestore thru ScreenRestoreEx.
DatePickerEx. Exit.
