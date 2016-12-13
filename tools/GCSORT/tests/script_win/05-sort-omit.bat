@echo off
set rtc=0
if %rtc% == 0    call execsort ..\takefile_win\sort\05-omit\somisqfch01_take.prm   somisqfch01
if %rtc% == 0    call execsort ..\takefile_win\sort\05-omit\somisqfbi01_take.prm   somisqfbi01
if %rtc% == 0    call execsort ..\takefile_win\sort\05-omit\somisqffi01_take.prm   somisqffi01
if %rtc% == 0    call execsort ..\takefile_win\sort\05-omit\somisqffl01_take.prm   somisqffl01
if %rtc% == 0    call execsort ..\takefile_win\sort\05-omit\somisqfpd01_take.prm   somisqfpd01
if %rtc% == 0    call execsort ..\takefile_win\sort\05-omit\somisqfzd01_take.prm   somisqfzd01

if %rtc% == 0    call execsort ..\takefile_win\sort\05-omit\somisqfmlt03_take.prm  somisqfmlt03


