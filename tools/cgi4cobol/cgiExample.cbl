
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
*> cgiExample.cbl - Demo Main Program for GnuCobol 2.0
*> Copyright (C) 2016 by Wim Niemans <niemans@pbsolo.nl>

*> Contains cgiExample (demo main program)
*>          cgiAccept  (to replace ACCEPT external-form)
*>          cgiDisplay (to replace DISPLAY external-form)
*>  calling cgivalue   (retrieve a CGI value)
*>          setTplvar  (name a field as template variable)
*>          rendertemplate
*> 

       >>SOURCE FORMAT IS FREE

identification division.
program-id.    cgiExample.
 *>author. wim niemans, nl-rotterdam, d-bonn
 *>        (c) solutions only, 2016
environment division.
data division.
working-storage section.
77  requestMethod       pic X(04) value space.
77  debugx              pic x(01) value "n".
    88 debug-requested            value "y".

*> 01 cgiFields is external-form.
01  cgiFields.
    05   A        pic x(05) value "abcde".
    05   B        pic 9(05) value 12345.
    05   C        pic x(15) value "a_a_ab_b_bc_c_c".
    05   filler redefines C.
     10  D        pic x(05) occurs 3 times.
    05   E        pic x(30).

*> 01 tplFields is external-form identified by tplTemplateName.
01  tplFields.
    05   A        pic x(05).
    05   B        pic 9(05).
    05   C        pic x(15).
    05   filler redefines C.
     10  D        pic x(05) occurs 3 times.
    05   E        pic x(30).

01  tplTemplateName pic x(13) value "template.html".


procedure division.
0000-main-frame.

*> Debugging: level 1: cgi variable processing
*>            level 2: multipart processing
*>            level 3: upload file processing
*>            level 4: internal checks
*>            level 5: low-level

*>            type 0 : embed in html output
*>            type 1 : display console
*>            type 2 : logfile
   if debug-requested
      accept requestMethod from environment "REQUEST_METHOD"
      if requestMethod = space
         call "cgi_Debug" using by value 1, 1         *> level 1 on terminal stdout
      else
         call "cgi_Debug" using by value 1, 0.        *> level 1 on html stdout   


   if debug-requested
      display "Start of program     : " cgiFields.

*> accept cgiFields: is external-form.
   call "cgiAccept" using cgiFields.

   if debug-requested
      display "cgi parameters loaded: " cgiFields.

   move corresponding cgiFields to tplFields.

   if debug-requested
      display "tpl parameters loaded: " tplFields.

*> display cgiFields: is identified by.
   call "cgiDisplay" using tplTemplateName, tplFields.

009-einde.
   stop run.

end program cgiExample.
*> -----------------------------------

       >>SOURCE FORMAT IS FREE

identification division.
program-id.    cgiAccept.
 *>author. wim niemans, nl-rotterdam, d-bonn
 *>        (c) solutions only, 2016
environment division.
configuration section.
repository.
       function cgivalue.
data division.
working-storage section.

linkage section.

01  cgiFields.
    05  A        pic x(05).
    05  B        pic 9(05).
    05  C.
     10 D        pic x(05) occurs 3 times.
    05  E        pic x(30).

procedure division using cgiFields.
0000-main-frame.

*> signature cgivalue(name) returning value.

    move cgivalue(z"A") to A.
    move cgivalue(z"B") to B.

    move cgivalue(z"D", 1) to D(1).
    move cgivalue(z"D", 2) to D(2).
    move cgivalue(z"D", 3) to D(3).

    move cgivalue(z"E") to E.

009-einde.
    exit program.

end program cgiAccept.
*> -----------------------------------

       >>SOURCE FORMAT IS FREE

identification division.
program-id.    cgiDisplay.
 *>author. wim niemans, nl-rotterdam, d-bonn
 *>        (c) solutions only, 2016
environment division.
configuration section.
repository.
       function concatenate intrinsic
       function cgivalue
       function rendertemplate.

data division.
working-storage section.
77  requestMethod  pic X(04) value space.
77  contentLength  pic 9(04) value zero.

linkage section.

01  tplTemplateName any length pic x.

01  tplFields.
    05  A        pic x(05).
    05  B        pic 9(05).
    05  C.
     10 D        pic x(05) occurs 3 times.
    05  E        pic x(30).

procedure division using tplTemplateName, tplFields.
0000-main-frame.

*> signature cgi_addTplVar(name, value)


    accept requestMethod from environment "REQUEST_METHOD".
    accept contentLength from environment "CONTENT_LENGTH".

    call "setTplVar" using z"request_method",  concatenate(requestMethod, X'00').
    call "setTplVar" using z"content_length",  concatenate(contentLength, X'00').
    call "setTplVar" using z"$0",       concatenate(cgivalue("$0", X'00')).

    call "setTplVar" using z"title",   z"Sample cgiExample for your pleasure".
    call "setTplVar" using z"program", z"cgiExample.cgi".

    call "setTplVar" using z"fieldA",  concatenate(A, X'00').
    call "setTplVar" using z"fieldB",  concatenate(B, X'00').
    call "setTplVar" using z"fieldC",  concatenate(C, X'00').

    call "setTplVar" using z"fieldD1", concatenate(D(1), X'00').
    call "setTplVar" using z"fieldD2", concatenate(D(2), X'00').
    call "setTplVar" using z"fieldD3", concatenate(D(3), X'00').

    call "setTplVar" using z"fieldE",  concatenate(E, X'00').

    call "setTplVar" using z"tplFields", concatenate(tplFields, X'00').

*> signature cgi_renderTpl(templateFileName)

    display rendertemplate(concatenate(tplTemplateName, X'00')).

009-einde.
    exit program.

end program cgiDisplay.
*> -----------------------------------
