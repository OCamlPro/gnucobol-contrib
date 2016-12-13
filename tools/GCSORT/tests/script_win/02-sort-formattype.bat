@echo off
set rtc=0
if %rtc% == 0    call execsort ..\takefile_win\sort\02-formattype\sftsqfbi01_take.prm  sftsqfbi01
if %rtc% == 0    call execsort ..\takefile_win\sort\02-formattype\sftsqfbi03_take.prm  sftsqfbi03
if %rtc% == 0    call execsort ..\takefile_win\sort\02-formattype\sftsqffl01_take.prm  sftsqffl01
if %rtc% == 0    call execsort ..\takefile_win\sort\02-formattype\sftsqfpd01_take.prm  sftsqfpd01
if %rtc% == 0    call execsort ..\takefile_win\sort\02-formattype\sftsqfpd03_take.prm  sftsqfpd03
if %rtc% == 0    call execsort ..\takefile_win\sort\02-formattype\sftsqfzd01_take.prm  sftsqfzd01
if %rtc% == 0    call execsort ..\takefile_win\sort\02-formattype\sftsqfzd03_take.prm  sftsqfzd03
