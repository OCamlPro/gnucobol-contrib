:: 07-sumfields-ssumsqfzd03

set exedir=..\bin
set filedir=..\files
set takedir=..\takefile_win

set sqzd03=%filedir%\sqzd03
%exedir%\iosqzd03
set sqzd03=

call execsort %takedir%\sort\07-sumfields\ssumsqfzd03_take.prm  ssumsqfpd03
set rtc=%errorlevel%
set sqzd03c=%filedir%\sqzd03_07.srt
%exedir%\iosqzd03c
call checkerr2
set rtc=%errorlevel%
set sqzd03c= 