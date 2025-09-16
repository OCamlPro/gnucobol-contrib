:: setup folders
if not exist "..\bin"           mkdir "..\bin"
if not exist "..\listing"       mkdir "..\listing"
if not exist "..\files"         mkdir "..\files"
if not exist "..\log"           mkdir "..\log"
if not exist "..\takefile\tmp"  mkdir "..\takefile\tmp"

cd ..\bin
set "COBC_FLAGS=-fbinary-size=1--8 -fnotrunc -fbinary-byteorder=big-endian"

:: To compile setup program
cobc -x %COBC_FLAGS% -t ../listing/gctestset.lst -I ../copy -Wall ../src/gctestset.cbl
cobc -x %COBC_FLAGS% ../src/gcsysop.c
cobc -m %COBC_FLAGS% ../src/gctestgetop.cbl

gcsysop
