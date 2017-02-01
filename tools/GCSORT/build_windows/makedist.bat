:: Batch for preparing distribution folder

::@echo off
setlocal

:: Set distribution folder
set GCS_DIST_PATH="%~dp0\dist\"

:: Set clean source directory
set GCS_SOURCE_PATH="%~dp0..\"

:: Set directory with generated release files
set GCS_RELEASE_PATH="%~dp0"

:: Set directory with necessary library files
set GCS_LIB_PATH="GCS_RELEASE_PATH..\"

:: clean dist and copy all files
%~d0

if exist "%1GCS_DIST_PATH%" (
   rmdir /S /Q "%GCS_DIST_PATH%"
)

mkdir "%GCS_DIST_PATH%"
cd "%GCS_DIST_PATH%"

copy "%GCS_SOURCE_PATH%AUTHORS"			.
copy "%GCS_SOURCE_PATH%COPYING*"		.
copy "%GCS_SOURCE_PATH%NEWS"			.
copy "%GCS_SOURCE_PATH%README"			.
copy "%GCS_SOURCE_PATH%THANKS"			.
copy "%GCS_SOURCE_PATH%TODO"			.

call :copyrel
call :copyrel x64

mkdir doc
copy "%GCS_SOURCE_PATH%doc\*.pdf"		doc\


goto :end

:copyrel
if NOT "%1"=="x64" (
   set copyfrom="%GCS_RELEASE_PATH%Win32\release"
   set  copytobin=bin
   set  copytolib=lib
) else (
   set  copyfrom="%GCS_RELEASE_PATH%x64\release"
   set  copytobin=bin_x64
   set  copytolib=lib_x64
)
mkdir %copytobin%
copy "%copyfrom%\gcsort.exe"			%copytobin%\
copy "%copyfrom%\gcsort.pdb"			%copytobin%\

copy "%copyfrom%\..\gnucobol\libcob.dll"			%copytobin%\
copy "%copyfrom%\..\gnucobol\libvbisam.dll"		%copytobin%\
copy "%copyfrom%\..\gnucobol\mpir.dll"			%copytobin%\
copy "%copyfrom%\..\gnucobol\pdcurses.dll"		%copytobin%\

mkdir "%copytolib%"
copy "%copyfrom%\..\gnucobol\libcob.lib"			%copytolib%\
copy "%copyfrom%\..\gnucobol\libvbisam.lib"		%copytolib%\
copy "%copyfrom%\..\gnucobol\mpir.lib"			%copytolib%\
copy "%copyfrom%\..\gnucobol\mpirxx.lib"			%copytolib%\
copy "%copyfrom%\..\gnucobol\pdcurses.lib"		%copytolib%\

goto :eof

:end

echo.
echo.

if exist "%ProgramFiles%\7-Zip\7z.exe" (
   erase "..\GCSort.7z"
   "%ProgramFiles%\7-Zip\7z.exe" a -r -mx=9 "..\GCSort.7z" *
) else if exist "%ProgramFiles(x86)%\7-Zip\7z.exe" (
   erase "..\GCSort.7z"
   "%ProgramFiles(x86)%\7-Zip\7z.exe" a -r -mx=9 "..\GCSort.7z" *
) else (
   echo 7-zip not found, "GCSort.7z" not created
)

pause
endlocal