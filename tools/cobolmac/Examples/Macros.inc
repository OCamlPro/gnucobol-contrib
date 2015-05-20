    *> *************************************************************************
    *>  %AppendCsv(Field#,CsvRecord#)
    *> -------------------------------------------------------------------------
    *>  Append Field to CsvRecord. If Field contains a comma (,) then Field is
    *>  quoted (") before being added. Quotes (") within Field will be replaced
    *>  with single-quotes (').
    *> *************************************************************************

    01  AppendCsv-macro.
      05  AppendCsv-comma-count        pic s9(04) comp value zero.
      05  AppendCsv-field              pic x(512) value spaces.
      05  AppendCsv-field-length       pic s9(04) comp value zero.
      05  AppendCsv-index              pic s9(04) comp value zero.
      05  AppendCsv-pointer            pic s9(04) comp value zero.

$define %AppendCsv=
initialize AppendCsv-macro

move function trim(!1) to AppendCsv-field
move length(function trim(AppendCsv-field)) to AppendCsv-field-length
move length(function trim(!2, trailing)) to AppendCsv-pointer

if AppendCsv-pointer > 1 then
  move "," to !2(!3:1)
  add 1 to AppendCsv-pointer end-add
end-if

perform
  varying AppendCsv-index from 1 by 1
    until AppendCsv-index > AppendCsv-field-length
  if AppendCsv-field(AppendCsv-index:1) = "," then
    add 1 to AppendCsv-comma-count end-add
  end-if
  if AppendCsv-field(AppendCsv-index:1) = quote then
    move "'" to AppendCsv-field(AppendCsv-index:1)
  end-if
end-perform

if AppendCsv-field-length > zero then
  if AppendCsv-comma-count > zero then
    string
      quote, function trim(AppendCsv-field), quote delimited by size
      into !2 with pointer AppendCsv-pointer
    end-string
  else
    string
      function trim(AppendCsv-field) delimited by size
      into !2 with pointer AppendCsv-pointer
    end-string
  end-if
end-if#

    *> *************************************************************************
    *>  %JustifyRightLeadZero(InString#,OutString#)
    *> -------------------------------------------------------------------------
    *>  Right-justify InString, add leading zeros and return it in OutString.
    *> *************************************************************************

    01  JustifyRightLeadZero-macro.
      05  JRLZ-30-zeros                pic x(030) value all '0'.
      05  JRLZ-instring-char-count     pic s9(04) comp value zero.
      05  JRLZ-number-of-zeros         pic s9(04) comp value zero.
      05  JRLZ-outstring-length        pic s9(04) comp value zero.

$define %JustifyRightLeadZero=
initialize JustifyRightLeadZero-macro

move !1 to JRLZ-instring

compute JRLZ-outstring-length
  = function length(!2)
end-compute

move zero to JRLZ-instring-character-count

inspect !1
  tallying JRLZ-instring-char-count for characters before initial ' '

if JRLZ-instring-character-count = 0 then
  move JRLZ-zeros(1:JRLZ-outstring-length) to !2
else

  compute JRLZ-number-of-zeros
    = JRLZ-outstring-length - JRLZ-instring-char-count
  end-compute

  if JRLZ-number-of-zeros = 0 then
    move !1 to !2
  else

    string
      JRLZ-30-zeros(1:JRLZ-number-of-zeros),
      !1(1:JRLZ-instring-char-count) delimited by size
      into !2
    end-string

  end-if

end-if#

    *> *************************************************************************
    *>  %JustifyCenter(InString#,OutString#)
    *> -------------------------------------------------------------------------
    *>  Center InString and return it in OutString.
    *> *************************************************************************

    01  JustifyCenter-macro.
      05  JC-100-spaces                pic x(100) value spaces.
      05  JC-instring-char-count       pic s9(04) comp value zero.
      05  JC-instring-length           pic s9(04) comp value zero.
      05  JC-number-of-left-spaces     pic s9(04) comp value zero.
      05  JC-number-of-right-spaces    pic s9(04) comp value zero.
      05  JC-outstring-length          pic s9(04) comp value zero.

$define %JustifyCenter=
initialize JustifyCenter-macro

compute JC-instring-length
  = function length(!1)
end-compute

compute JC-outstring-length
  = function length(!2)
end-compute

perform
  varying JC-instring-char-count from JC-instring-length by -1
    until (!1(JC-instring-char-count:1) <> spaces)
       or (JC-instring-char-count = 1)
  continue
end-perform

if JC-instring-char-count > 1 then

  compute JC-number-of-left-spaces rounded
    = (JC-outstring-length - JC-instring-char-count) / 2
  end-compute

  compute JC-number-of-right-spaces
    = JC-outstring-length - (JC-number-of-left-spaces + JC-instring-char-count)
  end-compute

  string
    JC-100-spaces(1:JC-number-of-left-spaces),
    !1(1:JC-instring-char-count),
    JC-100-spaces(1:JC-number-of-right-spaces) delimited by size
    into !2
  end-string

else
  move spaces to !2
end-if#

    *> *************************************************************************
    *>  %JustifyName(Last#,First#,Initial#,OutString#)
    *> -------------------------------------------------------------------------
    *>  Format Last, First and Initial as 'Last, First Initial.' and return it
    *>  in OutString.
    *> *************************************************************************

    01  JustifyName-macro.
      05  JN-first-name-char-count     pic s9(04) comp value zero.
      05  JN-first-name-length         pic s9(04) comp value zero.
      05  JN-last-name-char-count      pic s9(04) comp value zero.
      05  JN-last-name-length          pic s9(04) comp value zero.

$define %JustifyName=
initialize JustifyName-macro

compute JN-last-name-length
  = function length(!1)
end-compute

perform
  varying JN-last-name-char-count from JN-last-name-length by -1
    until !1(JN-last-name-char-count:1) <> spaces
  continue
end-perform

compute JN-first-name-length
  = function length(!2)
end-compute

perform
  varying JN-first-name-char-count from JN-first-name-length by -1
    until !2(JN-first-name-char-count:1) <> spaces
  continue
end-perform

string
  !1(1:JN-last-name-char-count), ', ',
  !2(1:JN-first-name-char-count), ' ',
  !3, '.' delimited by size
  into !4
end-string#

    *> *************************************************************************
    *>  %MoveText(Text#,Destination#,Column#)
    *> -------------------------------------------------------------------------
    *>  Move Text to Destination starting at the location specified by Column.
    *> *************************************************************************

    01  MoveText-macro.
      05  MoveText-pointer             pic s9(04) comp.

$define %MoveText=
move !3 to MoveText-pointer

string
  !1 delimited by size
  into !2 with pointer MoveText-pointer
end-string#

    *> *************************************************************************
    *>  %MoveNumber(Number#,Destination#,Column#,Edit#)
    *> -------------------------------------------------------------------------
    *>  Convert Number to the format specified by Format (available formats are
    *>  listed in this macros working-storage). Converted number is then moved
    *>  to Destination starting at the location specified by Column.
    *> *************************************************************************

    01  MoveNumber-macro.
      05  MoveNumber-pointer           pic s9(04) comp.
      05  MoveNumber-edits.
        10  MoveNumber-4v0             pic z(3)9.
        10  MoveNumber-7v2             pic z(6)9.99.
        10  MoveNumber-9v2             pic z(8)9.99.

$define %MoveNumber=
move !3 to MoveNumber-column
move !1 to MoveNumber-!4

string
  MoveNumber-!4 delimited by size
  into !2 with pointer MoveNumber-column
end-string#
