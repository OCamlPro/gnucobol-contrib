@echo off
set logfile=..\log\logexecution.log
set rtc=0
if %rtc% == 0    call execsort ..\takefile_win\sort\01-use\susesqvmlt01_take.prm  susesqvmlt01
if %rtc% == 0    call execsort ..\takefile_win\sort\01-use\susesqvmlt02_take.prm  susesqvmlt02
if %rtc% == 0    call execsort ..\takefile_win\sort\01-use\susesqvmlt03_take.prm  susesqvmlt03

