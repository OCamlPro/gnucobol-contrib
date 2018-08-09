gcv
===

Get C Value.  Given C expression and list of headers, display the expression
result (as a %d number by default).

First argument of -h for help or -v for gcv version.

Last argument of -C for a COBOL constant line, underscores translated to
dashes, and the value. -V for a COBOL usage binary-long output line.

-E is echo of generated C, and shows the gcc compile commands used.

Any other trailing options are treated as the C printf spec used to display the
result of the expression.

Relies on exported CFLAGS for the include file search path.

Example
-------

~~
prompt$ gcc -o gcv gcv.c

prompt$ export CFLAGS='-I /usr/local/include'
prompt$ ./gcv AG_OBJECT_READONLY agar/core.h -C
01 AG-OBJECT-READONLY constant as 64.

prompt$ ./gcv AG_OBJECT_NAME_MAX agar/core.h
64prompt$
~~

gcv was written to help bind libAgar into a GnuCOBOL user defined function
repository, -D AGAR during gcv compile will add the Agar core and gui headers
so they do not need to be mentioned. Still needs the CFLAGS search path set.

For other large pieces of C binding work, it'll likely be worthwhile
to build a custom gcv using includes files specfic to the task at hand.


commands.sed
------------

Paired with `commands.sed` `gcv` can be pretty handy when interfacing with C
sources.  It will display values that are normally C preprocessor or C enums
and hidden from COBOL.

~~sed
# Replace #indent prog params# with the captured output indented 4 spaces
s%#indent ([^ ]*)[ ]?([^ ]*)[ ]?([^ ]*)[ ]?([^ ]*)[ ]?(.*)#%\1 \2 \3 \4 \5 | sed 's/^/    /'%e

# Replace #command prog params# with the captured output
s%#command ([^ ]*)[ ]?([^ ]*)[ ]?([^ ]*)[ ]?([^ ]*)[ ]?(.*)#%\1 \2 \3 \4 \5%e

# Replace agar constants and C expressions
s#(.*)\[\[symbol[ ]?(.*)[ ]?(.*)\]\](.*)#printf "%s%s%s" "\1" "$(./gcv \2 \3)" "\4"#e
s#(.*)\[\[eval[ ]?'(.*)'[ ]?(.*)\]\](.*)#printf "%s%s%s" "\1" "$(./gcv "\2" \3)" "\4"#e 

# Output suitable for replacement in COBOL source
s#(.*)\[\[constant[ ]?(.*)[ ]?(.*)\]\](.*)#printf "%s%s%s" "\1" "$(./gcv \2 \3 -c)" "\4"#e 
s#(.*)\[\[value[ ]?(.*)[ ]?(.*)\]\](.*)#printf "%s%s%s" "\1" "$(./gcv \2 \3 -v)" "\4"#e 

s#(.*)\[\[shell[ ]?([^ ]*)[ ]?'(.*)'[ ]?\]\](.*)#printf "%s%s%s" "\1" "$("\2" "\3")" "\4"#e
~~

Usage:

    sed -r -f commands.sed [inputs]

Will replace double square bracketed text with a C expression result using
gcv.

    [[symbol symbol includes... spec]] the symbol value, no newline
    [[constant symbol includes spec] a line of 01 symbol constant as num.
    [[value symbol includes spec] line 05 symbol usage binary-long value num.
    [[eval 'expression' includes spec]] result of C expression, no newline

Not using gcv:

    [[shell commands]] result of shell commands

For Markdown or ReStructuredText documentation:

   #indent command args# replaced with output of command, indented
   #command command args# replaced with output of command
