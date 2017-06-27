@echo off
setlocal

:: check if started directly
echo %cmdcmdline% | find /i "%~0" >nul
if errorlevel 1 (
   set interactive=1
) else (
   set interactive=0
)

:: use venv from local dist directory, if available
if exist "%~dp0\python\Scripts\activate.bat" (
   call "%~dp0\python\Scripts\activate.bat"
   echo Using venv from "%~dp0\python"
) else (
  :: check for python executable
  where /q python.exe
  if errorlevel 1 (
     echo ERROR: python.exe is missing in PATH
     goto :end
  )
)

:: remove old dist folder if existing
if exist "%TEMP%\BPEdit-dist\" (
   rmdir "%TEMP%\BPEdit-dist" /S /Q
)
if exist "%~dp0\BPEdit-dist\" (
   rmdir "%~dp0\BPEdit-dist" /S /Q
)

:: create the virtual environment for later running
echo creating the virtual python environment for distribution
python.exe -m venv --copies "%TEMP%\BPEdit-dist\python"
echo.

:: change to containing directory
pushd %~dp0

:: copy source files
echo copying BPEdit sources for distribution
echo.
xcopy . "%TEMP%\BPEdit-dist" /v /s /exclude:%~dp0\exclude.lst
echo.

move "%TEMP%\BPEdit-dist" .

echo.
echo.
echo finished
echo.
echo Please change the second line in %~dp0BPEdit-dist\python\Scripts\activate.bat to:
echo set "VIRTUAL_ENV=%%~dp0.."
notepad.exe "%~dp0BPEdit-dist\python\Scripts\activate.bat"

:end
if _%interactive%_==_0_ (
   echo.
   pause
)

endlocal