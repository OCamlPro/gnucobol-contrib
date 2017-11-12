:: Batch for compilation of the java test runner
@echo off
setlocal

:: check if started directly
echo %cmdcmdline% | find /i "%~0" >nul
if errorlevel 1 (
   set interactive=1
) else (
   set interactive=0
)

:: check for javac/jar executable
for %%b in (javac jar) do (
  where /q %%b
  if errorlevel 1 (
     echo ERROR: %%b is missing in PATH
     goto :end
  )
)

:: change directory
pushd "%~dp0"

:: remove old content
rmdir /s/q classes
if exist "..\wintest.jar"   del /q "..\wintest.jar"

:: class compilation
mkdir classes
cd src
dir /b/s *.java > list
set CP=.
javac -encoding UTF-8 -O -d ..\classes -cp %CP% @list 2>..\compile.err

if errorlevel 1 (
   echo compiling classes not successfull
   echo warnings/errors:
   type ..\compile.err
   set error=1
) else (
   del /q ..\compile.err
   echo compilation of classes successfull
)

del list

if "%error%"=="1" goto :end

cd ..\classes

:: jar creation
jar cf ..\..\wintest.jar *

if errorlevel 1 (
   echo creation of wintest.jar not successfull
) else (
   echo creation of wintest.jar successfull
)

:end
if _%interactive%_==_0_ (
   echo.
   pause
)

endlocal