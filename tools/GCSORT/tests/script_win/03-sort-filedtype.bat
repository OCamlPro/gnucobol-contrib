@echo off
set rtc=0

if %rtc% == 0    call execsort ..\takefile_win\sort\03-filetype\sflbifbi01_take.prm   sflbifbi01


:: ================ conversion file type ix
:: ls -> ix
set inp002ix=..\files\inp002ix
if %rtc% == 0    call execsort ..\takefile_win\sort\03-filetype\sflixlsix01_take.prm  sflixlsix01
:: ix -> sq
set inp002ix=..\files\inp002ix
if %rtc% == 0    call execsort ..\takefile_win\sort\03-filetype\sflixixsq02_take.prm  sflixixsq02
:: sq -> ls
if %rtc% == 0    call execsort ..\takefile_win\sort\03-filetype\sflixsqls03_take.prm  sflixsqls03
:: check / compare input first step with output third step
:: comp (windows) - diff (linux)


:: ================ conversion file type rl
:: ls -> rl
if %rtc% == 0    call execsort ..\takefile_win\sort\03-filetype\sflrllsrl01_take.prm  sflrllsrl01
:: rl -> sq
if %rtc% == 0    call execsort ..\takefile_win\sort\03-filetype\sflrlrlsq02_take.prm  sflrlrlsq02
:: sq -> ls
if %rtc% == 0    call execsort ..\takefile_win\sort\03-filetype\sflrlsqls03_take.prm  sflrlsqls03
:: check / compare input first step with output third step
:: comp (windows) - diff (linux)


