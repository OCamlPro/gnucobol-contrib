
       >>SOURCE FORMAT IS FREE

identification division.
function-id.    cgivalue.
 *>author. (c) 2016, wim niemans, rotterdam

environment division.
data division.
working-storage section.

linkage section.

01  cgiName  any length pic x.

01  cgiValue any length pic x.

procedure division using cgiName returning cgiValue.
0000-main-frame.

    call "cgiGetValue" using cgiName returning cgiValue.

009-einde.
    goback.

       end function cgivalue.
