@echo off
setlocal

:: set env. variables for 32 or 64 bit
:: call "C:\GC22\GC22-VBI-32bit\set_env.cmd"
call "C:\GC22\GC22B-64bit\bin\cobenv.cmd"

:: set compiler parameters
set "COBCOBJ=cobjapi.o fileselect.o imageio.o japilib.o"
set "COBCLIB=-lWS2_32"
rem set "verbose=-v"

:: set directories to match your installation (only necessary for systems older than WinXP...)
set "examples_simple_dir=%~dp0"
set "src_c_dir=%examples_simple_dir%..\src_c"
set "src_cobol_dir=%examples_simple_dir%..\src_cobol"

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
del *.o      2>NUL
del *.lib    2>NUL
del *.exp    2>NUL
del *.exe    2>NUL

echo compile the C programs...
cobc -c %verbose% "%src_c_dir%\fileselect.c"
cobc -c %verbose% "%src_c_dir%\imageio.c"
cobc -c %verbose% "%src_c_dir%\japilib.c"

echo compile the cobjapi interface...
cobc -c -free -Wno-unfinished %verbose% "%src_cobol_dir%\cobjapi.cob" %*

echo compile the simple examples...
cobc -x -free -Wno-unfinished %verbose% -I"%src_cobol_dir%" alert.cob             %* %COBCOBJ% %COBCLIB% 
cobc -x -free -Wno-unfinished %verbose% -I"%src_cobol_dir%" borderlayout.cob      %* %COBCOBJ% %COBCLIB% 
cobc -x -free -Wno-unfinished %verbose% -I"%src_cobol_dir%" borderpanel.cob       %* %COBCOBJ% %COBCLIB% 
cobc -x -free -Wno-unfinished %verbose% -I"%src_cobol_dir%" button.cob            %* %COBCOBJ% %COBCLIB% 
cobc -x -free -Wno-unfinished %verbose% -I"%src_cobol_dir%" button-keylsnr.cob    %* %COBCOBJ% %COBCLIB% 
cobc -x -free -Wno-unfinished %verbose% -I"%src_cobol_dir%" canvas.cob            %* %COBCOBJ% %COBCLIB% 
cobc -x -free -Wno-unfinished %verbose% -I"%src_cobol_dir%" checkbox.cob          %* %COBCOBJ% %COBCLIB% 
cobc -x -free -Wno-unfinished %verbose% -I"%src_cobol_dir%" choice.cob            %* %COBCOBJ% %COBCLIB% 
cobc -x -free -Wno-unfinished %verbose% -I"%src_cobol_dir%" colors.cob            %* %COBCOBJ% %COBCLIB% 
cobc -x -free -Wno-unfinished %verbose% -I"%src_cobol_dir%" colors1.cob           %* %COBCOBJ% %COBCLIB% 
cobc -x -free -Wno-unfinished %verbose% -I"%src_cobol_dir%" componentlistener.cob %* %COBCOBJ% %COBCLIB% 
cobc -x -free -Wno-unfinished %verbose% -I"%src_cobol_dir%" cursor.cob            %* %COBCOBJ% %COBCLIB% 
cobc -x -free -Wno-unfinished %verbose% -I"%src_cobol_dir%" daemon.cob            %* %COBCOBJ% %COBCLIB% 
cobc -x -free -Wno-unfinished %verbose% -I"%src_cobol_dir%" dialog.cob            %* %COBCOBJ% %COBCLIB% 
cobc -x -free -Wno-unfinished %verbose% -I"%src_cobol_dir%" dialogmodal.cob       %* %COBCOBJ% %COBCLIB% 
cobc -x -free -Wno-unfinished %verbose% -I"%src_cobol_dir%" filedialog.cob        %* %COBCOBJ% %COBCLIB% 
cobc -x -free -Wno-unfinished %verbose% -I"%src_cobol_dir%" flowlayout.cob        %* %COBCOBJ% %COBCLIB% 
cobc -x -free -Wno-unfinished %verbose% -I"%src_cobol_dir%" flowsimple.cob        %* %COBCOBJ% %COBCLIB% 
cobc -x -free -Wno-unfinished %verbose% -I"%src_cobol_dir%" focuslistener.cob     %* %COBCOBJ% %COBCLIB% 
cobc -x -free -Wno-unfinished %verbose% -I"%src_cobol_dir%" font.cob              %* %COBCOBJ% %COBCLIB% 
cobc -x -free -Wno-unfinished %verbose% -I"%src_cobol_dir%" formattedtextfield.cob %* %COBCOBJ% %COBCLIB% 
cobc -x -free -Wno-unfinished %verbose% -I"%src_cobol_dir%" frame.cob             %* %COBCOBJ% %COBCLIB% 
cobc -x -free -Wno-unfinished %verbose% -I"%src_cobol_dir%" graphic.cob           %* %COBCOBJ% %COBCLIB% 
cobc -x -free -Wno-unfinished %verbose% -I"%src_cobol_dir%" graphicbutton.cob     %* %COBCOBJ% %COBCLIB% 
cobc -x -free -Wno-unfinished %verbose% -I"%src_cobol_dir%" graphiclabel.cob      %* %COBCOBJ% %COBCLIB% 
cobc -x -free -Wno-unfinished %verbose% -I"%src_cobol_dir%" gridlayout.cob        %* %COBCOBJ% %COBCLIB% 
cobc -x -free -Wno-unfinished %verbose% -I"%src_cobol_dir%" image.cob             %* %COBCOBJ% %COBCLIB% 
cobc -x -free -Wno-unfinished %verbose% -I"%src_cobol_dir%" insets.cob            %* %COBCOBJ% %COBCLIB% 
cobc -x -free -Wno-unfinished %verbose% -I"%src_cobol_dir%" keylistener.cob       %* %COBCOBJ% %COBCLIB% 
cobc -x -free -Wno-unfinished %verbose% -I"%src_cobol_dir%" label.cob             %* %COBCOBJ% %COBCLIB% 
cobc -x -free -Wno-unfinished %verbose% -I"%src_cobol_dir%" lines.cob             %* %COBCOBJ% %COBCLIB% 
cobc -x -free -Wno-unfinished %verbose% -I"%src_cobol_dir%" list.cob              %* %COBCOBJ% %COBCLIB% 
cobc -x -free -Wno-unfinished %verbose% -I"%src_cobol_dir%" listmultiple.cob      %* %COBCOBJ% %COBCLIB% 
cobc -x -free -Wno-unfinished %verbose% -I"%src_cobol_dir%" menu.cob              %* %COBCOBJ% %COBCLIB% 
cobc -x -free -Wno-unfinished %verbose% -I"%src_cobol_dir%" mousebuttons.cob      %* %COBCOBJ% %COBCLIB% 
cobc -x -free -Wno-unfinished %verbose% -I"%src_cobol_dir%" mouselistener.cob     %* %COBCOBJ% %COBCLIB% 
cobc -x -free -Wno-unfinished %verbose% -I"%src_cobol_dir%" panel.cob             %* %COBCOBJ% %COBCLIB% 
cobc -x -free -Wno-unfinished %verbose% -I"%src_cobol_dir%" popupmenu.cob         %* %COBCOBJ% %COBCLIB% 
cobc -x -free -Wno-unfinished %verbose% -I"%src_cobol_dir%" print.cob             %* %COBCOBJ% %COBCLIB% 
cobc -x -free -Wno-unfinished %verbose% -I"%src_cobol_dir%" radiobutton.cob       %* %COBCOBJ% %COBCLIB% 
cobc -x -free -Wno-unfinished %verbose% -I"%src_cobol_dir%" rubberband.cob        %* %COBCOBJ% %COBCLIB% 
cobc -x -free -Wno-unfinished %verbose% -I"%src_cobol_dir%" scaledimage.cob       %* %COBCOBJ% %COBCLIB% 
cobc -x -free -Wno-unfinished %verbose% -I"%src_cobol_dir%" scrollbar.cob         %* %COBCOBJ% %COBCLIB% 
cobc -x -free -Wno-unfinished %verbose% -I"%src_cobol_dir%" scrollpane.cob        %* %COBCOBJ% %COBCLIB% 
cobc -x -free -Wno-unfinished %verbose% -I"%src_cobol_dir%" simple.cob            %* %COBCOBJ% %COBCLIB% 
cobc -x -free -Wno-unfinished %verbose% -I"%src_cobol_dir%" simplemenu.cob        %* %COBCOBJ% %COBCLIB% 
cobc -x -free -Wno-unfinished %verbose% -I"%src_cobol_dir%" splitpane.cob         %* %COBCOBJ% %COBCLIB% 
cobc -x -free -Wno-unfinished %verbose% -I"%src_cobol_dir%" 2frames.cob           %* %COBCOBJ% %COBCLIB% 
cobc -x -free -Wno-unfinished %verbose% -I"%src_cobol_dir%" textfield.cob         %* %COBCOBJ% %COBCLIB% 
cobc -x -free -Wno-unfinished %verbose% -I"%src_cobol_dir%" vumeter.cob           %* %COBCOBJ% %COBCLIB% 
cobc -x -free -Wno-unfinished %verbose% -I"%src_cobol_dir%" window.cob            %* %COBCOBJ% %COBCLIB% 
cobc -x -free -Wno-unfinished %verbose% -I"%src_cobol_dir%" windowlistener.cob    %* %COBCOBJ% %COBCLIB%

echo compilation finished

:end
if _%interactive%_==_0_ (
   echo.
   pause
)

endlocal
