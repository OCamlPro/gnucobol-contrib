
ask * Accept Special Keys. 
 
This program shows how the extended ACCEPT special keys are used. 
 
The program starts with a help screen.
Simply run the program and follow the directions. 

An ncurses package is required to be in the runtime. 
Not all F keys are available on all platforms.  For example, 
TERM=xterm gives all F keys 1 through 12, most of 13 through 24, 
but few after that. 

To compile and run under Linux, 
 
cobc -x ask.cob 
./ask 

If it does not find the screenio copy file, then set the COB_COPY_DIR 
or COBCPY environment variables.

Published under GNU General Public License. 
