:: 07-sumfields-ssumsqfzd01

set exedir=..\bin
set filedir=..\files
set takedir=..\takefile_win

set sqzd01=%filedir%\sqzd01
%exedir%\iosqzd01
set sqzd01=

call execsort %takedir%\sort\07-sumfields\ssumsqfzd01_take.prm  ssumsqfpd03
set rtc=%errorlevel%
set sqzd01c=%filedir%\sqzd01_07.srt
%exedir%\iosqzd01c
call checkerr2
set rtc=%errorlevel%
set sqzd01c= 