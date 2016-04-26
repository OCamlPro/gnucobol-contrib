
       >>SOURCE FORMAT IS FREE

identification division.
function-id.    cstring.
 *> author. (c) 2016, wim niemans, rotterdam
environment division.
configuration section.
repository.

       function concatenate intrinsic.

data division.
working-storage section.
77      newLength          pic 9(04) usage binary.

linkage section.
01      stringx any length pic x.

01      stringy any length pic x.

procedure division using stringx returning stringy.

0000-main-frame.

    move concatenate(stringx, X'00') to stringy.

009-einde.
    exit function.

       end function cstring.
