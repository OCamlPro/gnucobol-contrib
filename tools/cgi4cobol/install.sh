#!/bin/bash
#
# compile the subprograms, functions and lowlevel c routines
# outputs cblCgiLib.o and libcobcgi.o
#
cobc -m cblCgiLib.cbl -c libcobcgi.c
#
#-------------------------------------------------------------------------static 
# compile as proof of concept the example as a stand alone executable
# with all *.o staticly linked
#
cobc -x cgiExample.cbl cblCgiLib.o libcobcgi.o -o cgiExample
#
# combine the output into a single dynamic loadable module
#
#
# run the example: output is based on template.html
#
./cgiExample.bin
#
#-------------------------------------------------------------------------static + dynamic
cobc -b cblCgiLib.o libcobcgi.o -o interfaceCgi.dylib
#
# compile as proof of concept the example as a stand alone executable
# we'll choose the extension .bin to avoid mistakes
#
cobc -x cgiExample.cbl -o cgiExample.bin
#
# declare the loadable module interfaceCgi.dylib
#
export COB_PRE_LOAD=interfaceCgi.dylib
#
# run the example: output is based on template.html
#
./cgiExample.bin
#
#-------------------------------------------------------------------------dynamic (cobcrun)
# compile as proof of concept the example as a dynamic loadable module
#
cobc -m cgiExample.cbl
#
# declare the loadable module interfaceCgi.dylib
#
export COB_PRE_LOAD=interfaceCgi.dylib
#
# run the example: output is based on template.html
#
cobcrun cgiExample
#
#-------------------------------------------------------------------------what's next
# you may put the main program cgiExample(.bin and/or .dylib) and the library interfaceCgi.dylib in your cgi-bin
#
# when you're not able to have the export of COB_PRE_LOAD in the webserver shell,
# or you must rely on dynamic modules (and must use cobcrun ),
# than use a custom shell script doing so and executing the main program in the same script.
# See myCgi.cgi, which assumes that cgiExample is renamed to cgiExample.bin and displays its own http headers.
#
# .htaccess in cgi-bin contains 
#
# Options +ExecCGI
# AddHandler cgi-script cgi sh bin
#