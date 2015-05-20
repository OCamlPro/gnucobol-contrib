Identification Division.

  Program-Id.                          JOBCARDC.
  $define %VERSION="03.00"#
  Program-Name.                        Job Card Modifier.
  Author.                              Robert W.Mills.
  Date-Written.                        February 1992.
  Date-Compiled.                       Not Yet.

*> =============================================================================
*>  Scans all files that match the specified fileset looking for !JOB cards.
*>  When a jobcard is found, the change specified by the keyword entry is
*>  actioned.
*>
*>  NOTE: The modification will be done in-situ.
*> =============================================================================

*> -----------------------------------------------------------------------------
*>  Modification History:
*>  ---------------------
*>  01.00 February 1992 by Robert W.Mills
*>  - Initial Version.
*>  02.00 August 2002 by Robert W.Mills
*>  - Allow up to 10 keywords to be entered. If a keyword appears more than once
*>    then only the change specified by the last occurence is actioned.
*>  - Replace Cobol Open on Jobstream file with call to HPFOPEN (allows any
*>    record size to be accepted).
*>  03.00 November 2014 by Robert W.Mills
*>  - Turned into a sample program for CobolMac.
*> -----------------------------------------------------------------------------

*> -----------------------------------------------------------------------------
*>  Future Modifications:
*>  ---------------------
*>  1) Add count of files found, modified, rejected.
*>  2) Allow user to select if the names of files being checked are displayed.
*>  3) Handle jobcards split over more than one source record.
*> -----------------------------------------------------------------------------

*> -----------------------------------------------------------------------------
*>  Compilation Instructions:
*>  -------------------------
*>  :COB85XL JOBCARDC.SOURCE
*>  :PURGE JOBCARDC.NMPRG
*>  :LINK FROM=$OLDPASS;TO=JOBCARDC.NMPRG;CAP=IA,BA
*> -----------------------------------------------------------------------------

Environment Division.

  Configuration Section.

    Source-Computer.                   HPe3000.
    Object-Computer.                   HPe3000.

    Special-Names.

      Condition-Code                   Is Intrinsic-Code.

  Input-Output Section.

    File-Control.

      Select JSFL-File                 Assign To "JOBCARDL"
                                       Status Is COBOLFILEERROR-STATUS
                                       .

Data Division.

  File Section.

    *> -------------------------------------------------------------------------
    *> JSFL -- Jobstream File List.
    *> -------------------------------------------------------------------------

    FD  JSFL-FILE.

    01  JSFL-RECORD                    Pic X(256).

  Working-Storage Section.

    $include JOBCARDC.inc

    *> -------------------------------------------------------------------------
    *> W1nn -- Program identification and Usage instruction variables.
    *> -------------------------------------------------------------------------

    01  W100-PROGRAM-IDENTITY.
      05  W100-LINE-01.
        10  W100-NAME                 Pic X(008) Value "JOBCARDC".
        10                            Pic X(001) Value "/".
        10  W100-VERSION              Pic X(005) Value %VERSION.
        10                            Pic X(003) Value " - ".
        10  W100-TITLE                Pic X(062) Value "Job Card Modifier".
      05  W100-LINE-02.
        10  W100-COPYRIGHT            Pic X(079) Value "(c) Robert W.Mills, 1992-2002.".

    01  W105-USAGE-INSTRUCTIONS.
      05  W105-LINE-01.
        10  Pic X(079) Value "Usage:".
      05  W105-LINE-02.
        10  Pic X(002) Value Spaces.
        10  Pic X(077) Value "[RUN] JOBCARDC[.group[.account]];info='FileSet;KeyWord[=value][%...]'".
      05  W105-LINE-03.
        10  Pic X(079) Value "Where:".
      05  W105-LINE-04.
        10  Pic X(002) Value Spaces.
        10  Pic X(077) Value "FileSet = A standard fileset as used by the :LISTF command.".
      05  W105-LINE-05.
        10  Pic X(002) Value Spaces.
        10  Pic X(077) Value "KeyWord = The items that can be changed (as listed below):".
      05  W105-LINE-06.
        10  Pic X(004) Value Spaces.
        10  Pic X(038) Value "UNAME='User Name'".
        10  Pic X(037) Value "UPASS=['User Password']".
      05  W105-LINE-07.
        10  Pic X(004) Value Spaces.
        10  Pic X(038) Value "ANAME='Account Name'".
        10  Pic X(037) Value "APASS=['Account Password']".
      05  W105-LINE-08.
        10  Pic X(004) Value Spaces.
        10  Pic X(038) Value "GNAME=['Group Name']".
       10  Pic X(037) Value "GPASS=['Group Password']".
      05  W105-LINE-09.
        10  Pic X(004) Value Spaces.
        10  Pic X(075) Value "Values in [] above are optional. If not supplied, Job Card item is removed.".
      05  W105-LINE-10.
        10  Pic X(004) Value Spaces.
       10  Pic X(075) Value "Removal of 'Group Name' will also remove any existing 'Group Password'.".
      05  W105-LINE-11.
        10  Pic X(004) Value Spaces.
        10  Pic X(075) Value "NOTE: Only the last occurrence of a keyword will be actioned.".

    *> -------------------------------------------------------------------------
    *> W4nn -- System Intrinsic Parameters.
    *> -------------------------------------------------------------------------

    01  W400-HPFOPEN-PARAMETERS.
      05  W400-FILE-NUMBER             Pic S9(09) Comp.
      05  W400-STATUS                  Pic S9(09) Comp.
      05                     Redefines W400-STATUS.
        10  W400-STATUS-INFO           Pic S9(04) Comp.
        10  W400-STATUS-SUBSYS         Pic S9(04) Comp.
      05  W400-FILE-NAME               Pic X(256).
      05  W400-DOMAIN                  Pic S9(09) Comp.
        88  W400-NEW-PERMANENT                         Value 4.
        88  W400-NEW-TEMPORARY                         Value Zero.
        88  W400-OLD-PERM-OR-TEMP                      Value 3.
        88  W400-OLD-PERMANENT                         Value 1.
        88  W400-OLD-TEMPORARY                         Value 2.
      05  W400-RECORD-FORMAT           Pic S9(09) Comp.
        88  W400-BYTE-STREAM                           Value 9.
        88  W400-FIXED-LENGTH                          Value Zero.
        88  W400-HIERARCHICAL-DIRECTORY                Value 10.
        88  W400-UNDEFINED-LENGTH                      Value 2.
        88  W400-VARIABLE-LENGTH                       Value 1.
      05  W400-CARRIAGE-CONTROL        Pic S9(09) Comp.
        88  W400-CCTL                                  Value 1.
        88  W400-NO-CCTL                               Value Zero.
      05  W400-FILE-EQUATIONS          Pic S9(09) Comp.
        88  W400-ALLOW-FILE-EQUATIONS                  Value Zero.
        88  W400-DISALLOW-FILE-EQUATIONS               Value 1.
      05  W400-FILE-TYPE               Pic S9(09) Comp.
        88  W400-CIRCULAR-FILE                         Value 4.
        88  W400-HFS-DIRECTORY-FILE                    Value 9.
        88  W400-KSAM-FILE                             Value 1.
        88  W400-KSAM64-FILE                           Value 7.
        88  W400-KSAMXL-FILE                           Value 3.
        88  W400-MESSAGE-FILE                          Value 6.
        88  W400-NM-SPOOLFILE                          Value 5.
        88  W400-RELATIVE-IO-FILE                      Value 2.
        88  W400-STANDARD-FILE                         Value Zero.
      05  W400-ACCESS-TYPE             Pic S9(09) Comp.
        88  W400-APPEND-ACCESS                         Value 3.
        88  W400-DIRECTORY-READ-ACCESS                 Value 9.
        88  W400-EXECUTE-ACCESS                        Value 6.
        88  W400-EXECUTE-READ-ACCESS                   Value 7.
        88  W400-READ-ACCESS                           Value Zero.
        88  W400-READ-WRITE-ACCESS                     Value 4.
        88  W400-UPDATE-ACCESS                         Value 5.
        88  W400-WRITE-ACCESS                          Value 1.
        88  W400-WRITE-SAVE-ACCESS                     Value 2.
      05  W400-DYNAMIC-LOCKING         Pic S9(09) Comp.
        88  W400-ALLOW-DYNAMIC-LOCKING                 Value Zero.
        88  W400-DISALLOW-DYNAMIC-LOCKING              Value 1.
      05  W400-EXCLUSIVE               Pic S9(09) Comp Value 1.
      05  W400-RECORD-SIZE             Pic S9(09) Comp.
      05  W400-OUTPUT-PRIORITY         Pic S9(09) Comp.
        88  W400-DEFAULT-PRIORITY                      Value 8.
        88  W400-DEFERED-PRIORITY                      Value Zero.
        88  W400-HIGH-PRIORITY                         Value 13.
      05  W400-MAX-FILE-SIZE           Pic S9(09) Comp.
      05  W400-FILE-CODE               Pic S9(09) Comp.
      05  W400-DEVICE-CLASS            Pic X(012).
      05  W400-DATA-TYPE               Pic S9(09) Comp.
        88  W400-ASCII-DATA                            Value 1.
       88  W400-BINARY-DATA                            Value Zero.

    01  W405-FFILEINFO-PARAMETERS.
      05  W405-FILE-NUMBER             Pic S9(04) Comp.
      05  W405-CM-RECORD-SIZE          Pic S9(04) Comp.
      05  W405-NM-RECORD-SIZE          Pic  9(09) Comp.

    *> -------------------------------------------------------------------------
    *> W5nn -- File Handles and Buffers.
    *> -------------------------------------------------------------------------

    01  W500-JOBSTREAM-FILE.
      05  W500-FILE-NUMBER             Pic S9(09) Comp.
      05  W500-BUFFER                  Pic X(512).
      05  W500-BUFFER-SIZE             Pic S9(04) Comp.
      05  W500-BYTE-COUNT              Pic S9(04) Comp.
      05  W500-SAVE-POINTER            Pic S9(04) Comp.

    *> -------------------------------------------------------------------------
    *> W6nn -- General work variables.
    *> -------------------------------------------------------------------------

    01  W600-RUN-TIME-PARAMETERS.
      05  W600-FILE-SET                Pic X(036) Value Spaces.
      05  W600-DELIMITER               Pic X(001) Value Space.
      05  W600-KEYWORDS                           Occurs 10.
        10  W600-NAME                  Pic X(006).
        10  W600-VALUE                 Pic X(008).
      05  W600-KEYWORD-COUNT           Pic S9(04) Comp Value Zero.
      05  W600-KEYWORD-INDEX           Pic S9(04) Comp Value Zero.

    01  W605-LISTF-COMMAND.
      05                               Pic X(006) Value "LISTF".
      05  W605-FILE-SET                Pic X(026).
      05                               Pic X(013) Value ",6 > JOBCARDL".

    01  W610-MESSAGE-TEXT              Pic X(080).

    01  W615-JOB-ITEMS.
      05  W615-COMMAND                 Pic X(005).
      05  W615-ITEMS.
        10  W615-ITEM                  Pic X(010) Occurs 7.
        10  W615-DELIMITER             Pic X(001) Occurs 7.

    01  W620-JOB-OPTIONS.
      05  W620-OPTIONS.
        10  W620-OPTION                Pic X(030) Occurs 10.
        10  W620-DELIMITER             Pic X(001) Occurs 10.
      05  W620-OPTION-COUNT            Pic S9(04) Comp.

    01  W625-JOB-CARD-ITEMS.
      05  W625-STREAM-CHARACTER        Pic X(001).
      05  W625-JOB-NAME                Pic X(008).
      05  W625-USER-NAME-START         Pic X(001).
      05  W625-USER-NAME               Pic X(008).
      05  W625-USER-PASS-START         Pic X(001).
      05  W625-USER-PASSWORD           Pic X(008).
      05  W625-ACCOUNT-NAME-START      Pic X(001).
      05  W625-ACCOUNT-NAME            Pic X(008).
      05  W625-ACCOUNT-PASS-START      Pic X(001).
      05  W625-ACCOUNT-PASSWORD        Pic X(008).
      05  W625-GROUP-NAME-START        Pic X(001).
      05  W625-GROUP-NAME              Pic X(008).
      05  W625-GROUP-PASS-START        Pic X(001).
      05  W625-GROUP-PASSWORD          Pic X(008).
      05  W625-OPTION-START            Pic X(001).

    01  W630-LOGON-STRING              Pic X(056).

    01  W635-NEW-JOB-CARD.
      05  W635-BUFFER.
        10  W635-CHARACTER             Pic X(001) Occurs 512.
      05  W635-INDEX                   Pic S9(04) Comp.
      05  W635-BUFFER-LENGTH           Pic S9(04) Comp Value 512.

    *> -------------------------------------------------------------------------
    *> W7nn -- Hard coded messages.
    *> -------------------------------------------------------------------------

    01  W700-ABORT-MESSAGES.
      05  W700-ABORT-MESSAGE-01        Pic x(079).

    01  W705-ERROR-MESSAGES.
      05  W705-ERROR-MESSAGE-01        Pic X(079) Value "ERROR: Unable to determine the end of the fileset.".
      05  W705-ERROR-MESSAGE-02        Pic X(079) Value "ERROR: A fileset has not been specified.".
      05  W705-ERROR-MESSAGE-03        Pic X(079) Value "ERROR: No keywords specified. Nothing to do.".

    01  W710-WARNING-MESSAGES.
      05  W710-WARNING-MESSAGE-01      Pic x(079) Value "WARN: No file(s) found in the specified fileset.".
      05  W710-WARNING-MESSAGE-02      Pic x(079) Value "WARN: NOT Changed. Job card will be too long in file *".

    01  W715-INFO-MESSAGES.
      05  W715-INFO-MESSAGE-01         Pic x(079) Value "INFO: Unable to find a job card in file *".
      05  W715-INFO-MESSAGE-02         Pic x(079) Value "INFO: Unable to :PURGE the temporary work file.".

    *> ---------------------------------------------------------------
    *> W9nn -- Process control switches.
    *> ---------------------------------------------------------------

    01  W900-JSFL-EOF                  Pic X(001).
      88  W900-END-OF-JSFL                        Value "E".
      88  W900-MORE-JSFL                          Value "M".

    01  W905-JOBSTREAM-EOF             Pic X(001).
      88  W905-END-OF-JOBSTREAM                   Value "E".
      88  W905-MORE-JOBSTREAM                     Value "M".

    01  W910-JOB-CARD-INDICATOR        Pic X(001).
      88  W910-JOB-CARD-FOUND                     Value "F".
      88  W910-JOB-CARD-NOT-FOUND                 Value "N".

    01  W915-JOBSTREAM-FILE-STATUS     Pic X(001).
      88  W915-JOBSTREAM-OPEN                     Value "O".
      88  W915-JOBSTREAM-CLOSED                   Value "C".

Procedure Division

  .JOBCARDC-MAINLINE.
    *> -------------------------------------------------------------------------
    *> Program control block.
    *> -------------------------------------------------------------------------

    Perform A000-INITIAL

    Perform B000-MAIN-PROCESS
       Until W900-END-OF-JSFL

    Perform C000-TERMINATE

  %Paragraph(A000#,INITIAL#)
    *> -------------------------------------------------------------------------
    *> Start of program processing.
    *> -------------------------------------------------------------------------

    *> Display program name and version information.

    Display W100-LINE-01
    Display W100-LINE-02
    Display Space

    *> Get the ;info= and ;parm= run-time parameters.

    %GetInfo(A000#)

    *> Upshift contents of run-time info string.

    Move Function Upper-Case(GETINFO-STRING) To GETINFO-STRING

    *> Display usage instructions and terminate if run-time info string is empty.

    If GETINFO-STRING-LENGTH = Zero Then
      Perform A100-DISPLAY-INSTRUCTIONS
      GoBack
    End-If

    *> Extract jobstream fileset and keyword pairs from info string.

    Perform A200-EXTRACT-RUN-TIME-PARMS

    *> Get a list of the jobstream file(s) that are to be modified.

    Perform A300-GET-JOBSTREAM-LIST

    *> Open jobstream list file and read first record.

    Open Input JSFL-FILE

    Read JSFL-FILE
      At End
        Set W900-END-OF-JSFL To True
      Not At End
        Set W900-MORE-JSFL To True
    End-Read

  %Paragraph(A100#,DISPLAY-INSTRUCTIONS#)
    *> -------------------------------------------------------------------------
    *> Display usage instructions if ;info= parameter is empty.
    *> -------------------------------------------------------------------------

    Display Space
    Display W105-LINE-01
    Display Space
    Display W105-LINE-02
    Display Space
    Display W105-LINE-03
    Display Space
    Display W105-LINE-04
    Display Space
    Display W105-LINE-05
    Display Space
    Display W105-LINE-06
    Display W105-LINE-07
    Display W105-LINE-08
    Display Space
    Display W105-LINE-09
    Display W105-LINE-10
    Display Space
    Display W105-LINE-11
    Display Space

  %Paragraph(A200#,EXTRACT-RUN-TIME-PARMS#)
    *> -------------------------------------------------------------------------
    *> Extract jobstream fileset and keyword pairs.
    *> -------------------------------------------------------------------------

    Unstring GETINFO-STRING Delimited By ";" Or "%" Or "="
      Into
        W600-FILE-SET Delimiter In W600-DELIMITER
        W600-NAME(01)
        W600-VALUE(01)
        W600-NAME(02)
        W600-VALUE(02)
        W600-NAME(03)
        W600-VALUE(03)
        W600-NAME(04)
        W600-VALUE(04)
        W600-NAME(05)
        W600-VALUE(05)
        W600-NAME(06)
        W600-VALUE(06)
        W600-NAME(07)
        W600-VALUE(07)
        W600-NAME(08)
        W600-VALUE(08)
        W600-NAME(09)
        W600-VALUE(09)
        W600-NAME(10)
        W600-VALUE(10)
      Tallying In W600-KEYWORD-COUNT
    End-Unstring

    If W600-KEYWORD-COUNT > 1 Then
      Compute W600-KEYWORD-COUNT
        = W600-KEYWORD-COUNT - 1
      End-Compute
    End-If

    If W600-DELIMITER <> ";" Then
      Display W705-ERROR-MESSAGE-01
      GoBack
    End-If

    If W600-FILE-SET = Spaces Then
      Display W705-ERROR-MESSAGE-02
      GoBack
    End-If

    If W600-KEYWORD-COUNT = 0 Then
      Display W705-ERROR-MESSAGE-03
      GoBack
    End-If

  %Paragraph(A300#,GET-JOBSTREAM-LIST#)
    *> -------------------------------------------------------------------------
    *> Generate list of jobstream files to modify.
    *> -------------------------------------------------------------------------

    Move W600-FILE-SET To W605-FILE-SET

    %Command(A300#,W605-LISTF-COMMAND#)

    If (COMMAND-STATUS = -431) Or (COMMAND-STATUS = 907) Then
      Display W710-WARNING-MESSAGE-01
      GoBack
    Else If Not COMMAND-SUCCESSFUL Then
      %FatalGoBack(A300#,MPE#,Error invoking LISTF#,HPCICOMMAND#)
    End-If End-If

  %Paragraph(B000#,MAIN-PROCESS#)
    *> -------------------------------------------------------------------------
    *> Main process loop.
    *> Continue until all files in jobstream list have been check and changed.
    *> -------------------------------------------------------------------------

    Perform B100-FIND-JOB-CARD

    If W915-JOBSTREAM-OPEN And W910-JOB-CARD-FOUND Then
      Perform B200-DECOMPILE-JOB-CARD
      Perform B300-MODIFY-JOB-CARD
      Perform B400-TIDY-JOB-CARD
      Perform B500-REBUILD-JOB-CARD
      Perform B600-UPDATE-JOB-CARD
    End-If

    If W915-JOBSTREAM-OPEN Then
      Perform B700-CLOSE-JOBSTREAM
    End-If

    *> Get the next entry from the jobstream list.

    Read JSFL-File
      At End
        Set W900-END-OF-JSFL To True
    End-Read

  %Paragraph(B100#,FIND-JOB-CARD#)
    *> -------------------------------------------------------------------------
    *> Find the job card.
    *> -------------------------------------------------------------------------

    Perform B110-OPEN-JOBSTREAM-FILE

    If W915-JOBSTREAM-OPEN Then
      Perform B120-GET-RECORD-SIZE
      Perform B130-GET-JOBCARD
    End-iF

  %Paragraph(B110#,OPEN-JOBSTREAM-FILE#)
    *> -------------------------------------------------------------------------
    *> Open jobstream file.
    *> -------------------------------------------------------------------------

    Set W915-JOBSTREAM-CLOSED To True

    Move Zero To W400-FILE-NUMBER
    Move Spaces To W400-FILE-NAME

    String
      "%" Delimited By Size
      JSFL-RECORD Delimited By Space
      "%" Delimited By Size
      Into W400-FILE-NAME
    End-String

    Set W400-OLD-PERMANENT To True
    Set W400-UPDATE-ACCESS To True

    Call "HPFOPEN"
      Using W400-FILE-NUMBER, W400-STATUS, 2, W400-FILE-NAME, 3, W400-DOMAIN, 11, W400-ACCESS-TYPE, 13, W400-EXCLUSIVE, Zero
    End-Call

    If W400-STATUS <> Zero Then
      %FileSysError(B110#,HPFOPEN#,W400-FILE-NUMBER#)
    Else
      Move W400-FILE-NUMBER To W500-FILE-NUMBER
      Set W915-JOBSTREAM-OPEN To True
    End-If

  %Paragraph(B120#,GET-RECORD-SIZE#)
    *> -------------------------------------------------------------------------
    *> Get the record size for the jobstream file.
    *> -------------------------------------------------------------------------

    Move W500-FILE-NUMBER To W405-FILE-NUMBER

    Call "FFILEINFO"
      Using W405-FILE-NUMBER, 4, W405-CM-RECORD-SIZE, 67, W405-NM-RECORD-SIZE, Zero
    End-Call

    If Intrinsic-Code <> Zero Then
      %FatalGoBack(B120#,FILE#,Unable to get record size#,FFILEINFO#)
    End-If

    If W405-CM-RECORD-SIZE = Zero Then
      Multiply -1 By W405-NM-RECORD-SIZE Giving W500-BUFFER-SIZE
    Else
      Move W405-CM-RECORD-SIZE To W500-BUFFER-SIZE
    End-If

  %Paragraph(B130#,GET-JOBCARD#)
    *> -------------------------------------------------------------------------
    *> Get the first jobcard in the jobstream file.
    *> -------------------------------------------------------------------------

    Set W910-JOB-CARD-NOT-FOUND   To True

    %Fread(B100-1#,W500-FILE-NUMBER#,W500-BUFFER#,W500-BUFFER-SIZE#,W500-BYTE-COUNT#)

    If FREAD-END-OF-FILE Then
      Set W905-END-OF-JOBSTREAM To True
    Else
      Set W905-MORE-JOBSTREAM To True
    End-If

    Perform
      Until W910-JOB-CARD-FOUND
         Or W905-END-OF-JOBSTREAM

      Move Function Upper-Case(W500-BUFFER) To W500-BUFFER

      If W500-BUFFER(2:3) = "JOB" Then
        Set W910-JOB-CARD-FOUND To True
      End-If

      If W910-JOB-CARD-NOT-FOUND Then

        %Fread(B100-2#,W500-FILE-NUMBER#,W500-BUFFER#,W500-BUFFER-SIZE#,W500-BYTE-COUNT#)

        If FREAD-END-OF-FILE Then
          Set W905-END-OF-JOBSTREAM To True
        End-If

      End-If

    End-Perform

    If W910-JOB-CARD-NOT-FOUND Then

      Move Spaces To W610-MESSAGE-TEXT

      String
        W715-INFO-MESSAGE-01 Delimited by "*"
        JSFL-RECORD Delimited by Space
        Into W610-MESSAGE-TEXT
      End-String
      Display W610-MESSAGE-TEXT

    End-If

  %Paragraph(B200#,DECOMPILE-JOB-CARD#)
    *> -------------------------------------------------------------------------
    *> Break jobcard into it's constituent parts.
    *> -------------------------------------------------------------------------

    Move Spaces To W620-OPTIONS
    Move Zero To W620-OPTION-COUNT

    Unstring W500-BUFFER Delimited By ";"
      Into
        W630-LOGON-STRING
        W620-OPTION(01) Delimiter In W620-DELIMITER(01)
        W620-OPTION(02) Delimiter In W620-DELIMITER(02)
        W620-OPTION(03) Delimiter In W620-DELIMITER(03)
        W620-OPTION(04) Delimiter In W620-DELIMITER(04)
        W620-OPTION(05) Delimiter In W620-DELIMITER(05)
        W620-OPTION(06) Delimiter In W620-DELIMITER(06)
        W620-OPTION(07) Delimiter In W620-DELIMITER(07)
        W620-OPTION(08) Delimiter In W620-DELIMITER(08)
        W620-OPTION(09) Delimiter In W620-DELIMITER(09)
        W620-OPTION(10) Delimiter In W620-DELIMITER(10)
      Tallying In W620-OPTION-COUNT
    End-Unstring

    Compute W620-OPTION-COUNT
      = W620-OPTION-COUNT - 1
    End-Compute

    Move Spaces To W615-ITEMS.

    Unstring W630-LOGON-STRING Delimited By " " Or "." Or "/" Or ","
      Into
        W615-COMMAND
        W615-ITEM(01) Delimiter In W615-DELIMITER(01)
        W615-ITEM(02) Delimiter In W615-DELIMITER(02)
        W615-ITEM(03) Delimiter In W615-DELIMITER(03)
        W615-ITEM(04) Delimiter In W615-DELIMITER(04)
        W615-ITEM(05) Delimiter In W615-DELIMITER(05)
        W615-ITEM(06) Delimiter In W615-DELIMITER(06)
        W615-ITEM(07) Delimiter In W615-DELIMITER(07)
    End-Unstring

    Move Spaces To W625-JOB-CARD-ITEMS.

    Move W630-LOGON-STRING(1:1) To W625-STREAM-CHARACTER

    Evaluate W615-DELIMITER(01)
      When ","
        Move W615-ITEM(01) To W625-JOB-NAME
      When "."
        Move W615-ITEM(01) To W625-USER-NAME
      When "/"
        Move W615-ITEM(01) To W625-USER-NAME
    End-Evaluate

    Evaluate W615-DELIMITER(01) Also W615-DELIMITER(02)
      When "," Also "."
        Move W615-ITEM(02) To W625-USER-NAME
      When "," Also "/"
        Move W615-ITEM(02) To W625-USER-NAME
      When "/" Also "."
        Move W615-ITEM(02) To W625-USER-PASSWORD
      When "." Also "/"
        Move W615-ITEM(02) To W625-ACCOUNT-NAME
      When "." Also ","
        Move W615-ITEM(02) To W625-ACCOUNT-NAME
      When "." Also " "
        Move W615-ITEM(02) To W625-ACCOUNT-NAME
    End-Evaluate

    Evaluate W615-DELIMITER(02) Also W615-DELIMITER(03)
      When "/" Also "."
        Move W615-ITEM(03) To W625-USER-PASSWORD
      When "." Also "/"
        Move W615-ITEM(03) To W625-ACCOUNT-NAME
      When "." Also ","
        Move W615-ITEM(03) To W625-ACCOUNT-NAME
      When "." Also " "
        Move W615-ITEM(03) To W625-ACCOUNT-NAME
      When "." Also ";"
        Move W615-ITEM(03) To W625-ACCOUNT-NAME
      When "/" Also ","
        Move W615-ITEM(03) To W625-ACCOUNT-PASSWORD
      When "/" Also " "
        Move W615-ITEM(03) To W625-ACCOUNT-PASSWORD
      When "," Also "/"
        Move W615-ITEM(03) To W625-GROUP-NAME
      When "," Also " "
        Move W615-ITEM(03) To W625-GROUP-NAME
    End-Evaluate

    Evaluate W615-DELIMITER(03) Also W615-DELIMITER(04)
      When "." Also "/"
        Move W615-ITEM(04) To W625-ACCOUNT-NAME
      When "." Also " "
        Move W615-ITEM(04) To W625-ACCOUNT-NAME
      When "." Also ","
        Move W615-ITEM(04) To W625-ACCOUNT-NAME
      When "/" Also ","
        Move W615-ITEM(04) To W625-ACCOUNT-PASSWORD
      When "/" Also " "
        If W615-DELIMITER(02) = "." Then
          Move W615-ITEM(04) To W625-ACCOUNT-PASSWORD
        Else
          Move W615-ITEM(04) To W625-GROUP-PASSWORD
        End-If
      When "," Also "/"
        Move W615-ITEM(04) To W625-GROUP-NAME
      When "," Also " "
        Move W615-ITEM(04) To W625-GROUP-NAME
    End-Evaluate

    Evaluate W615-DELIMITER(04) Also W615-DELIMITER(05)
      When "/" Also ","
        Move W615-ITEM(05) To W625-ACCOUNT-PASSWORD
      When "/" Also " "
        If W615-DELIMITER(03) = "." Then
          Move W615-ITEM(05) To W625-ACCOUNT-PASSWORD
        Else
          Move W615-ITEM(05) To W625-GROUP-PASSWORD
        End-If
      When "," Also "/"
        Move W615-ITEM(05) To W625-GROUP-NAME
      When "," Also " "
        Move W615-ITEM(05) To W625-GROUP-NAME
    End-Evaluate

    Evaluate W615-DELIMITER(05) Also W615-DELIMITER(06)
      When "," Also "/"
        Move W615-ITEM(06) To W625-GROUP-NAME
      When "," Also " "
        Move W615-ITEM(06) To W625-GROUP-NAME
      When "/" Also " "
        Move W615-ITEM(06) To W625-GROUP-PASSWORD
    End-Evaluate

    Evaluate W615-DELIMITER(06) Also W615-DELIMITER(07)
      When "/" Also " "
        Move W615-ITEM(07) To W625-GROUP-PASSWORD
    End-Evaluate

  %Paragraph(B300#,MODIFY-JOB-CARD#)
    *> -------------------------------------------------------------------------
    *> Apply requested changes to jobcard items.
    *> -------------------------------------------------------------------------

    Perform
      Varying W600-KEYWORD-INDEX From 1 By 1
      Until W600-KEYWORD-INDEX = W600-KEYWORD-COUNT

      Evaluate W600-NAME(W600-KEYWORD-INDEX)
        When "UNAME"
          Move W600-VALUE(W600-KEYWORD-INDEX) To W625-USER-NAME
        When "UPASS"
          If W600-VALUE(W600-KEYWORD-INDEX) <> Spaces Then
            Move W600-VALUE(W600-KEYWORD-INDEX) To W625-USER-PASSWORD
          Else
            Move Spaces To W625-USER-PASSWORD
          End-If
        When "ANAME"
          Move W600-VALUE(W600-KEYWORD-INDEX) To W625-ACCOUNT-NAME
        When "APASS"
          If W600-VALUE(W600-KEYWORD-INDEX) <> Spaces Then
            Move W600-VALUE(W600-KEYWORD-INDEX) To W625-ACCOUNT-PASSWORD
          Else
            Move Spaces To W625-ACCOUNT-PASSWORD
          End-If
        When "GNAME"
          If W600-VALUE(W600-KEYWORD-INDEX) <> Spaces Then
            Move W600-VALUE(W600-KEYWORD-INDEX) To W625-GROUP-NAME
          Else
            Move Spaces To W625-GROUP-NAME
          End-If
        When "GPASS"
          If W600-VALUE(W600-KEYWORD-INDEX) <> Spaces Then
            Move W600-VALUE(W600-KEYWORD-INDEX) To W625-GROUP-PASSWORD
          Else
            Move Spaces To W625-GROUP-PASSWORD
          End-If
      End-Evaluate

    End-Perform

  %Paragraph(B400#,TIDY-JOB-CARD#)
    *> -------------------------------------------------------------------------
    *> Remove unused delimiters and items.
    *> -------------------------------------------------------------------------

    If W625-JOB-NAME = Spaces Then
      Move Space To W625-USER-NAME-START
    Else
      Move "," To W625-USER-NAME-START
    End-If

    If W625-USER-PASSWORD = Spaces Then
      Move Space To W625-USER-PASS-START
    Else
      Move "/" To W625-USER-PASS-START
    End-If

    Move "." To W625-ACCOUNT-NAME-START

    If W625-ACCOUNT-PASSWORD = Spaces Then
      Move Space To W625-ACCOUNT-PASS-START
    Else
      Move "/" To W625-ACCOUNT-PASS-START
    End-If

    If W625-GROUP-NAME = Spaces Then
      Move Space To W625-GROUP-NAME-START
    Else
      Move "," To W625-GROUP-NAME-START
    End-If

    If W625-GROUP-NAME = Spaces Then
      Move Spaces To W625-GROUP-PASSWORD
    End-If

    If W625-GROUP-PASSWORD = Spaces Then
      Move Space To W625-GROUP-PASS-START
    Else
      Move "/" To W625-GROUP-PASS-START
    End-If

    If W620-OPTION-COUNT > Zero Then
      Move ";" To W625-OPTION-START
    Else
      Move Space To W625-OPTION-START
    End-If

  %Paragraph(B500#,REBUILD-JOB-CARD#)
    *> -------------------------------------------------------------------------
    *> Create the new jobcard.
    *> -------------------------------------------------------------------------

    Move Spaces To W635-BUFFER

    String
      W625-STREAM-CHARACTER, "JOB " Delimited by Size
      W625-JOB-NAME
      W625-USER-NAME-START, W625-USER-NAME
      W625-USER-PASS-START, W625-USER-PASSWORD Delimited by Space
      W625-ACCOUNT-NAME-START Delimited by Size
      W625-ACCOUNT-NAME,
      W625-ACCOUNT-PASS-START, W625-ACCOUNT-PASSWORD,
      W625-GROUP-NAME-START, W625-GROUP-NAME,
      W625-GROUP-PASS-START, W625-GROUP-PASSWORD,
      W625-OPTION-START,
      W620-OPTION(01), W620-DELIMITER(01),
      W620-OPTION(02), W620-DELIMITER(02),
      W620-OPTION(03), W620-DELIMITER(03),
      W620-OPTION(04), W620-DELIMITER(04),
      W620-OPTION(05), W620-DELIMITER(05),
      W620-OPTION(06), W620-DELIMITER(06),
      W620-OPTION(07), W620-DELIMITER(07),
      W620-OPTION(08), W620-DELIMITER(08),
      W620-OPTION(09), W620-DELIMITER(09),
      W620-OPTION(10), W620-DELIMITER(10) Delimited by Space
      Into W635-BUFFER
    End-String

  %Paragraph(B600#,UPDATE-JOB-CARD#)
    *> -------------------------------------------------------------------------
    *> Write jobcard back to the jobstream file.
    *> -------------------------------------------------------------------------

    Move W635-BUFFER-LENGTH To W635-INDEX

    Perform
      Until W635-CHARACTER(W635-INDEX) <> Space
      Subtract 1 From W635-INDEX
    End-Perform

    If W635-INDEX > (-1 * W500-BUFFER-SIZE) Then
      Move Spaces To W610-MESSAGE-TEXT
      String
        W710-WARNING-MESSAGE-02 Delimited by "*"
        JSFL-RECORD Delimited by Space
        Into W610-MESSAGE-TEXT
      End-String
      Display W610-MESSAGE-TEXT
    Else
      %Fupdate(B600#,W500-FILE-NUMBER#,W635-BUFFER#,W500-BUFFER-SIZE#)
    End-If

  %Paragraph(B700#,CLOSE-JOBSTREAM#)
    *> -------------------------------------------------------------------------
    *> Close the jobstream file.
    *> -------------------------------------------------------------------------

    Call Intrinsic "FCLOSE"
      Using W500-FILE-NUMBER, Zero, Zero
    End-Call

    Move Zero To W500-FILE-NUMBER

    Set W915-JOBSTREAM-CLOSED To True

  %Paragraph(C000#,TERMINATE#)
    *> -------------------------------------------------------------------------
    *> Close/purge the listf file and then exit program.
    *> -------------------------------------------------------------------------

    Close JSFL-FILE

    %Command(C000#,"PURGE JOBCARDL,TEMP"#)

    If Not COMMAND-SUCCESSFUL Then
      Display W715-INFO-MESSAGE-02
    End-If

    GoBack

  .Z999-ABORT.
    *> -------------------------------------------------------------------------
    *> Abnormal termination processing.
    *> -------------------------------------------------------------------------

    Display Space
    Display "***************************************************"
    Display "*    PROGRAM HAS TERMINATED IN AN ERROR STATE     *"
    Display "*-------------------------------------------------*"
    Display "  Location    : " FATALGOBACK-LOCATION
    Display "  SubLocation : " FATALGOBACK-SUBLOCATION
    Display "  SubSystem   : " FATALGOBACK-SUBSYSTEM
    Display "  Message     : " FATALGOBACK-MESSAGE
    Display "  Intrinsic   : " FATALGOBACK-INTRINSIC
    Display "***************************************************"
    Display Space

    Stop Run
    .
    *> -------------------------------------------------------------------------
    *> End of source code.
    *> -------------------------------------------------------------------------
