:: 07-sumfields
@echo off
set rtc=0
if %rtc% == 0    call execsort ..\takefile_win\sort\10-outfil\soutfsqfmlt01_take.prm  soutfsqfmlt01
if %rtc% == 0    call execsort ..\takefile_win\sort\10-outfil\soutfsqfmlt02_take.prm  soutfsqfmlt02
if %rtc% == 0    call execsort ..\takefile_win\sort\10-outfil\soutfsqfmlt03_take.prm  soutfsqfmlt03
if %rtc% == 0    call execsort ..\takefile_win\sort\10-outfil\soutfsqfmlt04_take.prm  soutfsqfmlt04
if %rtc% == 0    call execsort ..\takefile_win\sort\10-outfil\soutfsqfmlt05_take.prm  soutfsqfmlt05
if %rtc% == 0    call execsort ..\takefile_win\sort\10-outfil\soutfsqfmlt06_take.prm  soutfsqfmlt06
if %rtc% == 0    call execsort ..\takefile_win\sort\10-outfil\soutfsqfmlt07_take.prm  soutfsqfmlt07
if %rtc% == 0    call execsort ..\takefile_win\sort\10-outfil\soutfsqfmlt08_take.prm  soutfsqfmlt08
if %rtc% == 0    call execsort ..\takefile_win\sort\10-outfil\soutfsqfmlt09_take.prm  soutfsqfmlt09

