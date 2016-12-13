:: 07-sumfields
@echo off
set rtc=0

if %rtc% equ 0    call sort\07-sumfields\ssumsqfbi01
if %rtc% equ 0    call sort\07-sumfields\ssumsqfbi03
if %rtc% equ 0    call sort\07-sumfields\ssumsqffi01
if %rtc% equ 0    call sort\07-sumfields\ssumsqffi03
if %rtc% equ 0    call sort\07-sumfields\ssumsqffl01
if %rtc% equ 0    call sort\07-sumfields\ssumsqfpd01
if %rtc% equ 0    call sort\07-sumfields\ssumsqfpd03
if %rtc% equ 0    call sort\07-sumfields\ssumsqfzd01
if %rtc% equ 0    call sort\07-sumfields\ssumsqfzd03
if %rtc% equ 0    call execsort ..\takefile_win\sort\07-sumfields\ssumsqfmlt01_take.prm ssumsqfmlt01
if %rtc% equ 0    call execsort ..\takefile_win\sort\07-sumfields\ssumsqfmlt02_take.prm ssumsqfmlt02
if %rtc% equ 0    call execsort ..\takefile_win\sort\07-sumfields\ssumsqfmlt04_take.prm ssumsqfmlt04
