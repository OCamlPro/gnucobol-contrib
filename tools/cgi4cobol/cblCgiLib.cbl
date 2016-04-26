
       >>SOURCE FORMAT IS FREE

*> CDDL HEADER START
*>
*> The contents of this file are subject to the terms of the
*> Common Development and Distribution License, Version 1.0 only
*> (the "License").  You may not use this file except in compliance
*> with the License.
*>
*> You can obtain a copy of the license at license/CDDL_1.LICENSE
*> or at https://opensource.org/licenses/CDDL-1.0
*> See the License for the specific language governing permissions
*> and limitations under the License.
*>
*> When distributing Covered Code, include this CDDL HEADER in each
*> file and include the License file at license/CDDL.LICENSE.
*> If applicable, add the following below this CDDL HEADER, with the
*> fields enclosed by brackets "[]" replaced with your own identifying
*> information: Portions Copyright [yyyy] [name of copyright owner]
*>
*> CDDL HEADER END
*>
*> cblCgiLib.cbl - Cobol Cgi Interface library for GnuCobol
*> Copyright (C) 2016 by Wim Niemans <niemans@pbsolo.nl>
*>
*> Contains cgivalue       (function to retrieve a CGI variable)
*>          setTplVar      (program to identify a field as a template variable) 
*>          rendertemplate (function that does the actual DISPLAY)
*>

       >>SOURCE FORMAT IS FREE

identification division.
function-id.    cgivalue.
 *>author. wim niemans, nl-rotterdam, d-bonn
 *>        (c) solutions only, 2016
environment division.
configuration section.
repository.
       function concatenate intrinsic.
data division.
working-storage section.

77  nrOfArguments       usage binary-char value zero.

77  cgiValueAddress     usage pointer.
77  cgiReturnedValue    pic x(80) based.

77  myValueIndex        pic 99 binary.

linkage section.
01  cgiName             any length pic x.
01  valueIndex          any length pic 9.
01  myCgiValue          pic x(80).

procedure division using cgiName, optional valueIndex returning myCgiValue.
0000-main-frame.

  call X'91' using return-code, 16, nrOfArguments.

*> signature cgi_getValue(name, 9) returning value (address).

  if nrOfArguments > 1 and valueIndex > 0
     move valueIndex to myValueIndex
     call "cgi_getCgiValue" using cgiName, by value myValueIndex returning cgiValueAddress
  else
     call "cgi_getCgiValue" using cgiName, by value 0            returning cgiValueAddress.

    if cgiValueAddress = null                                  *> when the named value is not-found
       move spaces to myCgiValue
    else
       set address of cgiReturnedValue to cgiValueAddress      *> cgiReturnedValue is now a c-string, delimited by null.
       unstring cgiReturnedValue delimited by X'00' into myCgiValue.

009-einde.
    exit function.

end function cgivalue.
*> -----------------------------------

       >>SOURCE FORMAT IS FREE

identification division.
program-id.    setTplVar.
 *>author. wim niemans, nl-rotterdam, d-bonn
 *>        (c) solutions only, 2016
environment division.
configuration section.
repository.
       function concatenate intrinsic.

data division.
linkage section.
01  tplVarName          any length pic x.
01  tplVarValue         any length pic x.
01  tplTemplateName     any length pic x.

procedure division using tplVarName, tplVarValue.
0000-main-frame.

*> signature cgi_addTplVar(name, value)

    call "cgi_addTplVar" using concatenate(tplVarName, X'00'), concatenate(tplVarValue, X'00').

009-einde.
    exit program.

end program setTplVar.
*> -----------------------------------

       >>SOURCE FORMAT IS FREE

identification division.
function-id.    rendertemplate.
 *>author. wim niemans, nl-rotterdam, d-bonn
 *>        (c) solutions only, 2016
environment division.
configuration section.
repository.
       function concatenate intrinsic.
data division.
linkage section.
01  tplTemplateName any length pic x.
01  nothingx         pic x.

procedure division using tplTemplateName returning nothingx.
0000-main-frame.

*> signature cgi_renderTpl(templateFileName)

    call "cgi_renderTpl" using concatenate(tplTemplateName, X'00').
    move X'0D' to nothingx.

009-einde.
    exit function.

end function rendertemplate.
*> -----------------------------------
