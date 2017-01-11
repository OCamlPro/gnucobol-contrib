@echo off
setlocal

:: set env. variables
call "C:\Program Files (x86)\Microsoft Visual Studio 11.0\VC\vcvarsall.bat"

:: set compiler parameters
SET COBCOBJ=cobjapi.obj fileselect.obj imageio.obj japilib.obj
SET COBCLIB=-lWS2_32.Lib

:: set directories to match your installation (only necessary for systems older than WinXP...)
set examples_simple_dir="%~dp0
set src_c_dir=%examples_simple_dir%../src_c
set src_cobol_dir=%examples_simple_dir%../src_cobol


:: check if started directly
echo %cmdcmdline% | find /i "%~0" >nul
if errorlevel 1 (
   set interactive=1
) else (
   set interactive=0
)

:: check for cobc executable
where /q cobc.exe
if errorlevel 1 (
   echo ERROR: cobc.exe is missing in PATH
   goto :end
)

:: test if directories exist
if not exist "%examples_simple_dir%\" (
   echo ERROR: Please set examples_simple_dir correct, currently set to %examples_simple_dir%
   goto :end
)
if not exist "%src_c_dir%\" (
   echo ERROR: Please set src_c_dir correct, currently set to %src_c_dir%
   goto :end
)
if not exist "%src_cobol_dir%\" (
   echo ERROR: Please set src_cobol_dir correct, currently set to %src_cobol_dir%
   goto :end
)


:: change directory
pushd "%examples_simple_dir%"

:: delete old files (ignoring errors)
del *.obj    2>NUL
del *.lib    2>NUL
del *.exp    2>NUL
del *.exe    2>NUL


:: compile the C programs
cobc -c -v "%src_c_dir%\fileselect.c"
cobc -c -v "%src_c_dir%\imageio.c"
cobc -c -v "%src_c_dir%\japilib.c"

:: compile the cobjapi interface
cobc -c -free -v "%src_cobol_dir%\cobjapi.cob"

:: compile the simple examples
cobc -x -free -v -I"%src_cobol_dir%" %COBCOBJ% %COBCLIB% alert.cob
cobc -x -free -v -I"%src_cobol_dir%" %COBCOBJ% %COBCLIB% borderlayout.cob
cobc -x -free -v -I"%src_cobol_dir%" %COBCOBJ% %COBCLIB% borderpanel.cob
cobc -x -free -v -I"%src_cobol_dir%" %COBCOBJ% %COBCLIB% button.cob
cobc -x -free -v -I"%src_cobol_dir%" %COBCOBJ% %COBCLIB% canvas.cob
cobc -x -free -v -I"%src_cobol_dir%" %COBCOBJ% %COBCLIB% checkbox.cob
cobc -x -free -v -I"%src_cobol_dir%" %COBCOBJ% %COBCLIB% choice.cob
cobc -x -free -v -I"%src_cobol_dir%" %COBCOBJ% %COBCLIB% colors.cob
cobc -x -free -v -I"%src_cobol_dir%" %COBCOBJ% %COBCLIB% colors1.cob
cobc -x -free -v -I"%src_cobol_dir%" %COBCOBJ% %COBCLIB% componentlistener.cob
cobc -x -free -v -I"%src_cobol_dir%" %COBCOBJ% %COBCLIB% cursor.cob
cobc -x -free -v -I"%src_cobol_dir%" %COBCOBJ% %COBCLIB% daemon.cob
cobc -x -free -v -I"%src_cobol_dir%" %COBCOBJ% %COBCLIB% dialog.cob
cobc -x -free -v -I"%src_cobol_dir%" %COBCOBJ% %COBCLIB% dialogmodal.cob
cobc -x -free -v -I"%src_cobol_dir%" %COBCOBJ% %COBCLIB% filedialog.cob
cobc -x -free -v -I"%src_cobol_dir%" %COBCOBJ% %COBCLIB% flowlayout.cob
cobc -x -free -v -I"%src_cobol_dir%" %COBCOBJ% %COBCLIB% flowsimple.cob
cobc -x -free -v -I"%src_cobol_dir%" %COBCOBJ% %COBCLIB% focuslistener.cob
cobc -x -free -v -I"%src_cobol_dir%" %COBCOBJ% %COBCLIB% font.cob
cobc -x -free -v -I"%src_cobol_dir%" %COBCOBJ% %COBCLIB% frame.cob
cobc -x -free -v -I"%src_cobol_dir%" %COBCOBJ% %COBCLIB% graphic.cob
cobc -x -free -v -I"%src_cobol_dir%" %COBCOBJ% %COBCLIB% graphicbutton.cob
cobc -x -free -v -I"%src_cobol_dir%" %COBCOBJ% %COBCLIB% graphiclabel.cob
cobc -x -free -v -I"%src_cobol_dir%" %COBCOBJ% %COBCLIB% gridlayout.cob
cobc -x -free -v -I"%src_cobol_dir%" %COBCOBJ% %COBCLIB% image.cob
cobc -x -free -v -I"%src_cobol_dir%" %COBCOBJ% %COBCLIB% insets.cob
cobc -x -free -v -I"%src_cobol_dir%" %COBCOBJ% %COBCLIB% keylistener.cob
cobc -x -free -v -I"%src_cobol_dir%" %COBCOBJ% %COBCLIB% label.cob
cobc -x -free -v -I"%src_cobol_dir%" %COBCOBJ% %COBCLIB% lines.cob
cobc -x -free -v -I"%src_cobol_dir%" %COBCOBJ% %COBCLIB% list.cob
cobc -x -free -v -I"%src_cobol_dir%" %COBCOBJ% %COBCLIB% listmultiple.cob
cobc -x -free -v -I"%src_cobol_dir%" %COBCOBJ% %COBCLIB% menu.cob
cobc -x -free -v -I"%src_cobol_dir%" %COBCOBJ% %COBCLIB% mousebuttons.cob
cobc -x -free -v -I"%src_cobol_dir%" %COBCOBJ% %COBCLIB% mouselistener.cob
cobc -x -free -v -I"%src_cobol_dir%" %COBCOBJ% %COBCLIB% panel.cob
cobc -x -free -v -I"%src_cobol_dir%" %COBCOBJ% %COBCLIB% popupmenu.cob
cobc -x -free -v -I"%src_cobol_dir%" %COBCOBJ% %COBCLIB% print.cob
cobc -x -free -v -I"%src_cobol_dir%" %COBCOBJ% %COBCLIB% radiobutton.cob
cobc -x -free -v -I"%src_cobol_dir%" %COBCOBJ% %COBCLIB% rubberband.cob
cobc -x -free -v -I"%src_cobol_dir%" %COBCOBJ% %COBCLIB% scaledimage.cob
cobc -x -free -v -I"%src_cobol_dir%" %COBCOBJ% %COBCLIB% scrollbar.cob
cobc -x -free -v -I"%src_cobol_dir%" %COBCOBJ% %COBCLIB% scrollpane.cob
cobc -x -free -v -I"%src_cobol_dir%" %COBCOBJ% %COBCLIB% simple.cob
cobc -x -free -v -I"%src_cobol_dir%" %COBCOBJ% %COBCLIB% simplemenu.cob
cobc -x -free -v -I"%src_cobol_dir%" %COBCOBJ% %COBCLIB% textfield.cob
cobc -x -free -v -I"%src_cobol_dir%" %COBCOBJ% %COBCLIB% vumeter.cob
cobc -x -free -v -I"%src_cobol_dir%" %COBCOBJ% %COBCLIB% window.cob
cobc -x -free -v -I"%src_cobol_dir%" %COBCOBJ% %COBCLIB% windowlistener.cob

:end
if _%interactive%_==_0_ (
   echo.
   pause
)

endlocal
