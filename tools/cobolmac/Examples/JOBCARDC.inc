    *> =========================================================================
    *>  Standard Cobol Macros. (c) Robert W.Mills, 1992-2002, 2014.
    *> -------------------------------------------------------------------------
    *>  This is a cut-down version made specifically for this utility.
    *> =========================================================================

    *> *************************************************************************
    *>  %CobolFileError(location#,filename#)
    *> -------------------------------------------------------------------------
    *>  Generate the message for a Cobol file error and execute FatalGoback.
    *> *************************************************************************

$if x1=off
$control locoff
$if
    01  COBOLFILEERROR-MACRO.
      05  COBOLFILEERROR-STATUS.
        10  COBOLFILEERROR-STATUS-1    Pic X(001).
          88  COBOLFILEERROR-IMPLEMENTOR         Value "9".
        10  COBOLFILEERROR-STATUS-2    Pic X(001).
      05  COBOLFILEERROR-RESULT        Pic 9(004).
      05  COBOLFILEERROR-NUMBER        Pic S9(04) Comp.
      05  COBOLFILEERROR-MSG-BUFFER    Pic X(256).
      05  COBOLFILEERROR-MSG-LENGTH    Pic S9(04) Comp.

$preprocessor delimiter=~
$define %CobolFileError=
$if x1=off
$control locoff
$if
*> Check if it's an implementor defined file error.

If COBOLFILEERROR-IMPLEMENTOR Then *> Get the file system error number.

  Call "CKERROR"
    Using COBOLFILEERROR-STATUS, COBOLFILEERROR-RESULT
  End-Call

  Move COBOLFILEERROR-RESULT To COBOLFILEERROR-NUMBER

  *> Get the error message associated with the error code.

  Call "FERRMSG"
    Using COBOLFILEERROR-NUMBER, COBOLFILEERROR-MSG-BUFFER, COBOLFILEERROR-MSG-LENGTH
  End-Call

  Move Spaces To FATALGOBACK-MESSAGE

  String
    "!2: ", COBOLFILEERROR-MSG-BUFFER Delimited By Size
    Into FATALGOBACK-MESSAGE
  End-String

Else *> Not an implementor defined error, check for standard error.

  Evaluate COBOLFILEERROR-STATUS

    *> Permanent Errors.

    When "30"
      Move "!2: No more information available." To FATALGOBACK-MESSAGE
    When "31"
      Move "!2: Dynamic file attribute conflict." To FATALGOBACK-MESSAGE
    When "34"
      Move "!2: Boundry violation." To FATALGOBACK-MESSAGE
    When "35"
      Move "!2: Missing file." To FATALGOBACK-MESSAGE
    When "37"
      Move "!2: Invalid device/unwritable file." To FATALGOBACK-MESSAGE
    When "38"
      Move "!2: Open on file closed with LOCK." To FATALGOBACK-MESSAGE
    When "39"
      Move "!2: Fixed file attribute conflict." To FATALGOBACK-MESSAGE

    *> Logic Errors.

    When "41"
      Move "!2: File is already open." To FATALGOBACK-MESSAGE
    When "42"
      Move "!2: File is already closed." To FATALGOBACK-MESSAGE
    When "43"
      Move "!2: No read before rewrite/delete." To FATALGOBACK-MESSAGE
    When "44"
      Move "!2: Boundry violation." To FATALGOBACK-MESSAGE
    When "46"
      Move "!2: Unsuccessful read/start." To FATALGOBACK-MESSAGE
    When "47"
      Move "!2: File not open for input." To FATALGOBACK-MESSAGE
    When "48"
      Move "!2: File not open for output." To FATALGOBACK-MESSAGE
    When "49"
      Move "!2: File not open for I-O." To FATALGOBACK-MESSAGE

    *> Unknown Error.

    When Other
      Move Spaces To FATALGOBACK-MESSAGE
      String
        "!2: Unknown error code (", COBOLFILEERROR-STATUS, ") detected." Delimited By Size
        Into FATALGOBACK-MESSAGE
      End-String

  End-Evaluate

End-If

*> Execute FatalGoBack macro returning the error message.

%FatalGoBack(!1#,FILE#,#,COBOL#)
$control locon
    ~
$preprocessor delimiter=#
$control locon

    *> *************************************************************************
    *>  %Command(sublocation#,command#)
    *> -------------------------------------------------------------------------
    *>  Executes the requested command.
    *>  NOTE: No error/warning messages are printed on $STDLIST.
    *> *************************************************************************

$if x1=off
$control locoff
$if
    01  COMMAND-MACRO.
      05  COMMAND-IMAGE                Pic X(256).
      05  COMMAND-STATUS               Pic S9(04) Comp.
        88  COMMAND-SUCCESSFUL                    Value Zero.
        88  COMMAND-WARNING                       Value +1 Thru +9999.
        88  COMMAND-ERROR                         Value -9999 Thru -1.
      05  COMMAND-PARM-NUMBER          Pic S9(04) Comp.
      05  COMMAND-MSG-LEVEL            Pic S9(04) Comp Value 2.
      05  COMMAND-INDEX                Pic S9(04) Comp.

$preprocessor delimiter=~
$define %Command=
$if x1=off
$control locoff
$if
*> Find the end of the command string.

Move !2 To COMMAND-IMAGE
Move 256 To COMMAND-INDEX

Perform
  Until COMMAND-IMAGE(COMMAND-INDEX:1) <> Space
     Or COMMAND-INDEX = Zero
  Subtract 1 From COMMAND-INDEX
End-Perform

*> Append a carriage return to the end of the command string.

Add 1 To COMMAND-INDEX
Move %15 To COMMAND-IMAGE(COMMAND-INDEX:1)

*> Invoke the command.

Call "HPCICOMMAND"
  Using COMMAND-IMAGE, COMMAND-STATUS, COMMAND-PARM-NUMBER, COMMAND-MSG-LEVEL
End-Call
$control locon
    ~
$preprocessor delimiter=#
$control locon

    *> *************************************************************************
    *>  %FatalGoBack(sublocation#,subsystem#,message#,intrinsic#)
    *> -------------------------------------------------------------------------
    *>  Initialises the fatal error fields and performs Z999-ABORT.
    *> *************************************************************************

$if x1=off
$control locoff
$if
    01  FATALGOBACK-MACRO.
      05  FATALGOBACK-LOCATION         Pic X(020).
      05  FATALGOBACK-SUBLOCATION      Pic X(020).
      05  FATALGOBACK-SUBSYSTEM        Pic X(004).
      05  FATALGOBACK-MESSAGE          Pic X(256).
      05  FATALGOBACK-INTRINSIC        Pic X(016).
      05  FATALGOBACK-NULL             Pic X(002) Value Spaces.

$define %FatalGoBack=
$if x1=off
$control locoff
$if
If "!1 " <> FATALGOBACK-NULL Then
  Move "!1 " To FATALGOBACK-SUBLOCATION
Else
  Move Spaces To FATALGOBACK-SUBLOCATION
End-If

Move "!2" To FATALGOBACK-SUBSYSTEM

If "!3 " <> FATALGOBACK-NULL Then
  Move "!3 " To FATALGOBACK-MESSAGE
End-If

If "!4 " <> FATALGOBACK-NULL Then
  Move "!4 " To FATALGOBACK-INTRINSIC
Else
  Move Spaces To FATALGOBACK-INTRINSIC
End-If

Perform Z999-ABORT
$control locon
    #
$control locon

    *> *************************************************************************
    *>  %FileSysError(sublocation#,intrinsic#,filenumber#)
    *> -------------------------------------------------------------------------
    *>  Retrieves the error message from the system catalog for the  supplied
    *>  file system error and executes FatalGoBack.
    *> *************************************************************************

$if x1=off
$control locoff
$if
    01  FILESYSERROR-MACRO.
      05  FILESYSERROR-FCHECK-CODE     Pic S9(04) Comp.
      05  FILESYSERROR-MSG-BUFFER      Pic X(256).
      05  FILESYSERROR-MSG-LENGTH      Pic S9(04) Comp.

$preprocessor delimiter=~
$define %FileSysError=
$if x1=off
$control locoff
$if
*> Get the file system error code.

Call "FCHECK"
  Using !3, FILESYSERROR-FCHECK-CODE
End-Call

If Intrinsic-Code < Zero Then
  %FatalGoBack(!1 - FileSysError Macro#,FILE#,Invalid File Number or Bounds Violation#,FCHECK#)
End-If

*> Get the error message associated with the error code.

Call "FERRMSG"
  Using FILESYSERROR-FCHECK-CODE, FILESYSERROR-MSG-BUFFER, FILESYSERROR-MSG-LENGTH
End-Call

Move FILESYSERROR-MSG-BUFFER To FATALGOBACK-MESSAGE

*> Execute FatalGoBack returning the error message.

%FatalGoBack(!1#,FILE#,#,!2#)
$control locon
    ~
$preprocessor delimiter=#
$control locon

    *> *************************************************************************
    *>  %Fread(sublocation#,filenumber#,buffer#,rlength#,alength#)
    *> -------------------------------------------------------------------------
    *>  Reads upto rlength bytes from file specified by filenumber into buffer.
    *>  Number of bytes read is returned in alength.
    *> *************************************************************************

$if x1=off
$control locoff
$if
    01  FREAD-MACRO.
      05  FREAD-LENGTH                 Pic S9(09) Comp.
      05  FREAD-STATUS                 Pic S9(09) Comp.
        88  FREAD-SUCCESSFUL                      Value Zero.
        88  FREAD-WARNING                         Value +1 Thru +9999.
        88  FREAD-ERROR                           Value -9999 Thru -1.
        88  FREAD-TIMEOUT                         Value +22.
        88  FREAD-END-OF-FILE                     Value -1.
      05  FREAD-FSERROR-CODE           Pic S9(04) Comp.
        88  FREAD-SOFTWARE-TIMEOUT                Value +22.
      05  FREAD-MSG-BUFFER             Pic X(256).
      05  FREAD-MSG-LENGTH             Pic S9(04) Comp.

$preprocessor delimiter=~
$define %Fread=
$if x1=off
$control locoff
$if
*> Make the reqdlength parameter a negative value.

Move !4 To FREAD-LENGTH

If FREAD-LENGTH > Zero Then
  Multiply -1 By FREAD-LENGTH Giving FREAD-LENGTH
End-If

*> Read a record from the file.

Call "FREAD"
  Using !2, !3, FREAD-LENGTH
  Giving !5
End-Call

*> Decode the returned intrinsic condition code.

If Intrinsic-Code = Zero Then
  Set FREAD-SUCCESSFUL To True
Else

  If Intrinsic-Code > Zero Then
    Set FREAD-END-OF-FILE To True
  Else
    Set FREAD-ERROR To True
  End-If

End-If

*> Check if read error caused by a software timeout.

If FREAD-ERROR Then

  Call "FCHECK"
    Using !2, FREAD-FSERROR-CODE
  End-Call

  If FREAD-SOFTWARE-TIMEOUT Then
    Set FREAD-TIMEOUT To True
  End-If

End-If

*> If valid read error, execute FatalGoBack.

If FREAD-ERROR Then

  Call "FERRMSG"
    Using FREAD-FSERROR-CODE, FREAD-MSG-BUFFER, FREAD-MSG-LENGTH
  End-Call

  %FatalGoBack(!1#,FILE#,FREAD-MSG-BUFFER#,FREAD#)

End-If
$control locon
    ~
$preprocessor delimiter=#
$control locon

    *> *************************************************************************
    *>  %Fupdate(sublocation#,filenumber#,buffer#,length#)
    *> -------------------------------------------------------------------------
    *>  Updates the current record in file specified by filenumber with the
    *>  contents of buffer.
    *> *************************************************************************

$if x1=off
$control locoff
$if
    01  FUPDATE-MACRO.
      05  FUPDATE-LENGTH               Pic S9(09) Comp.
      05  FUPDATE-STATUS               Pic S9(09) Comp.
        88  FUPDATE-SUCCESSFUL                    Value Zero.
        88  FUPDATE-WARNING                       Value +1 Thru +9999.
        88  FUPDATE-ERROR                         Value -9999 Thru -1.
        88  FUPDATE-END-OF-FILE                   Value -1.
      05  FUPDATE-FSERROR-CODE         Pic S9(04) Comp.
      05  FUPDATE-MSG-BUFFER           Pic X(256).
      05  FUPDATE-MSG-LENGTH           Pic S9(04) Comp.

$preprocessor delimiter=~
$define %Fupdate=
$if x1=off
$control locoff
$if
*> Make the buffer length parameter a negative value.

Move !4 To FUPDATE-LENGTH

If FUPDATE-LENGTH > Zero Then
  Multiply -1 By FUPDATE-LENGTH Giving FUPDATE-LENGTH
End-If

*> Write the record to the file.

Call "FUPDATE"
  Using !2, !3, FUPDATE-LENGTH
End-Call

*> Decode the returned intrinsic condition code.

If Intrinsic-Code = Zero Then
  Set FUPDATE-SUCCESSFUL To True
Else

  If Intrinsic-Code > Zero Then
    Set FUPDATE-END-OF-FILE To True
  Else
    Set FUPDATE-ERROR To True
  End-If

End-If

*> If valid write error, execute FatalGoBack.

If FUPDATE-ERROR Then

  Call "FCHECK"
    Using !2, FUPDATE-FSERROR-CODE
  End-Call

  Call "FERRMSG"
    Using FUPDATE-FSERROR-CODE, FUPDATE-MSG-BUFFER, FUPDATE-MSG-LENGTH
  End-Call

  Move FUPDATE-MSG-BUFFER To FATALGOBACK-MESSAGE
  %FatalGoBack(!1#,FILE#,#,FUPDATE#)

End-If
$control locon
    ~
$preprocessor delimiter=#
$control locon

    *> *************************************************************************
    *>  %Fwrite(location#,filenumber#,buffer#,length#,cctl#)
    *> -------------------------------------------------------------------------
    *>  Writes contents of buffer to file specified by filenumber.
    *>  cctl is the carriage control code that is to be used.
    *> *************************************************************************

$if x1=off
$control locoff
$if
    01  FWRITE-MACRO.
      05  FWRITE-LENGTH                Pic S9(09) Comp.
      05  FWRITE-STATUS                Pic S9(09) Comp.
        88  FWRITE-SUCCESSFUL                     Value Zero.
        88  FWRITE-WARNING                        Value +1 Thru +9999.
        88  FWRITE-ERROR                          Value -9999 Thru -1.
        88  FWRITE-END-OF-FILE                    Value -1.
      05  FWRITE-FSERROR-CODE          Pic S9(04) Comp.
      05  FWRITE-MSG-BUFFER            Pic X(256).
      05  FWRITE-MSG-LENGTH            Pic S9(04) Comp.

$preprocessor delimiter=~
$define %Fwrite=
$if x1=off
$control locoff
$if
*> Make the buffer length parameter a negative value.

Move !4 To FWRITE-LENGTH

If FWRITE-LENGTH > Zero Then
  Multiply -1 By FWRITE-LENGTH Giving FWRITE-LENGTH
End-If

*> Write the record to the file.

Call "FWRITE"
  Using !2, !3, FWRITE-LENGTH
  Giving !5
End-Call

*> Decode the returned intrinsic condition code.

If Intrinsic-Code = Zero Then
  Set FWRITE-SUCCESSFUL To True
Else

  If Intrinsic-Code > Zero Then
    Set FWRITE-END-OF-FILE To True
  Else
    Set FWRITE-ERROR To True
  End-If

End-If

*> If valid write error, execute FatalGoBack.

If FWRITE-ERROR Then

  Call "FCHECK"
    Using !2, FWRITE-FSERROR-CODE
  End-Call

  Call "FERRMSG"
    Using FWRITE-FSERROR-CODE, FWRITE-MSG-BUFFER, FWRITE-MSG-LENGTH
  End-Call

  Move FWRITE-MSG-BUFFER To FATALGOBACK-MESSAGE
  %FatalGoBack(!1#,FILE#,#,FWRITE#)

End-If
$control locon
    ~
$preprocessor delimiter=#
$control locon

    *> *************************************************************************
    *>  %GetInfo(sublocation#)
    *> -------------------------------------------------------------------------
    *>  Retrieves the ;info='<string>' and ;parm=<value> parameters (if any)
    *>  that are supplied at run-time.
    *> *************************************************************************

$if x1=off
$control locoff
$if
    01  GETINFO-MACRO.
      05  GETINFO-STRING               Pic X(256) Value Spaces.
      05  GETINFO-STRING-LENGTH        Pic S9(04) Comp Value 256.
      05  GETINFO-PARM                 Pic S9(04) Comp.
      05  GETINFO-RESULT               Pic S9(04) Comp.
        88  GETINFO-SUCCESSFUL                    Value Zero.
        88  GETINFO-ERROR                         Value 1.

$preprocessor delimiter=~
$define %GetInfo=
$if x1=off
$control locoff
$if
Call "GETINFO"
  Using GETINFO-STRING, GETINFO-STRING-LENGTH, GETINFO-PARM
  Giving GETINFO-RESULT
End-Call

If GETINFO-ERROR Then
  %FatalGoBack(!1#,MPE#,Parameter error#,GETINFO#)
End-If
$control locon
    ~
$preprocessor delimiter=#
$control locon

    *> *************************************************************************
    *>  %HpError(location#,intrinsic#,status#)
    *> -------------------------------------------------------------------------
    *>  Retrieves the error message from the system catalog for the supplied
    *>  HPxxxx intrinsic status and executes FatalGoBack.
    *> *************************************************************************

$if x1=off
$control locoff
$if
    01  HPERROR-MACRO.
      05  HPERROR-BUFFER-LENGTH        Pic S9(04) Comp.
      05  HPERROR-STATUS.
        10  HPERROR-STATUS-1           Pic S9(04) Comp.
          88  HPERROR-SUCCESSFUL                  Value Zero.
          88  HPERROR-WARNING                     Value +1 Thru +9999.
          88  HPERROR-ERROR                       Value -9999 Thru -1.
          88  HPERROR-MSG-TRUNCATED               Value -8.
        10  HPERROR-STATUS-2           Pic S9(04) Comp.

$preprocessor delimiter=~
$define %HpError=
$if x1=off
$control locoff
$if
*> Get the length of the FatalGoBack message buffer.

Compute HPERROR-BUFFER-LENGTH
  = Function Length(FATALGOBACK-MESSAGE)
End-Compute

*> Get the error message associated with the error code.

Call "HPERRMSG"
  Using 3, 1, 0, !3, FATALGOBACK-MESSAGE, HPERROR-BUFFER-LENGTH, HPERROR-STATUS
End-Call

*> Check that first call to hperrmsg was successful.

If (Not HPERROR-SUCCESSFUL) And (Not HPERROR-MSG-TRUNCATED) Then

  Call "HPERRMSG"
    Using 3, 1, 0, HPERROR-STATUS, FATALGOBACK-MESSAGE, HPERROR-BUFFER-LENGTH, HPERROR-STATUS
  End-Call

  %FatalGoBack(!1 - HPERROR macro#,MPE#,#,HPERRMSG#)

End-If

*> Execute FatalGoBack returning the error message.

%FatalGoBack(!1#,FILE#,#,!2#)
$control locon
    ~
$preprocessor delimiter=#
$control locon

    *> *************************************************************************
    *>  %Paragraph(prefix#,title#)
    *> -------------------------------------------------------------------------
    *>  Creates a paragraph label and loads the FatalGoBack location.
    *> *************************************************************************

$if x1=off
$control locoff
$if
$define %Paragraph=
$if x1=off
$control locoff
$if
.!1-!2.
  Move "!1-!2" To FATALGOBACK-LOCATION
$control locon
    #
$control locon

    *> *************************************************************************
    *>  End of Standard Cobol macros.
    *> *************************************************************************
