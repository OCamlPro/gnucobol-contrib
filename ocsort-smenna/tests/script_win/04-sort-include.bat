@echo off
set rtc=0
if %rtc% == 0    call execsort ..\takefile_win\sort\04-include\sincsqfch01_take.prm   sincsqfch01
if %rtc% == 0    call execsort ..\takefile_win\sort\04-include\sincsqfbi01_take.prm   sincsqfbi01
if %rtc% == 0    call execsort ..\takefile_win\sort\04-include\sincsqffi01_take.prm   sincsqffi01
if %rtc% == 0    call execsort ..\takefile_win\sort\04-include\sincsqffl01_take.prm   sincsqffl01
if %rtc% == 0    call execsort ..\takefile_win\sort\04-include\sincsqfpd01_take.prm   sincsqfpd01
if %rtc% == 0    call execsort ..\takefile_win\sort\04-include\sincsqfzd01_take.prm   sincsqfzd01

if %rtc% == 0    call execsort ..\takefile_win\sort\04-include\sincsqfmlt03_take.prm  sincsqfmlt03


