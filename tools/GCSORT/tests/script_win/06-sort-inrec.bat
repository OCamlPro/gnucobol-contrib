
@echo off
set rtc=0
if %rtc% == 0    call execsort ..\takefile_win\sort\06-inrec\sinrsqfch01_take.prm    sinrsqfch01
if %rtc% == 0    call execsort ..\takefile_win\sort\06-inrec\sinrsqfmlt01_take.prm   sinrsqfmlt01
if %rtc% == 0    call execsort ..\takefile_win\sort\06-inrec\sinrsqfmlt05_take.prm   sinrsqfmlt05
