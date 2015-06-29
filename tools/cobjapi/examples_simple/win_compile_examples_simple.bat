:: set directories to match your installation
set examples_simple_dir="C:\oc_projekt\cobjapi\examples_simple"
set src_c_dir="C:\oc_projekt\cobjapi\src_c"
set src_cobol_dir="C:\oc_projekt\cobjapi\src_cobol"

:: test if directories exist
if not exist "%examples_simple_dir%\" (
   echo Please set examples_simple_dir correct, currently set to %examples_simple_dir%
   goto :eof
)
if not exist "%src_c_dir%\" (
   echo Please set src_c_dir correct, currently set to %src_c_dir%
   goto :eof
)
if not exist "%src_cobol_dir%\" (
   echo Please set src_cobol_dir correct, currently set to %src_cobol_dir%
   goto :eof
)

:: delete old files (ignoring errors)
del "%examples_simple_dir%\*.obj"    2>NUL
del "%examples_simple_dir%\*.lib"    2>NUL
del "%examples_simple_dir%\*.exp"    2>NUL
del "%examples_simple_dir%\*.exe"    2>NUL

:: set env. variables
call "C:\Program Files (x86)\Microsoft Visual Studio 11.0\VC\vcvarsall.bat"

:: set compiler parameters
SET COBCOBJ=cobjapi.obj fileselect.obj imageio.obj japilib.obj
SET COBCLIB=-lWS2_32.Lib

:: change directory
cd %examples_simple_dir%

:: compile the C programs
cobc -c -v %src_c_dir%\fileselect.c
cobc -c -v %src_c_dir%\imageio.c
cobc -c -v %src_c_dir%\japilib.c

:: compile the cobjapi interface
cobc -c -free -v %src_cobol_dir%\cobjapi.cob

:: compile the simple examples
cobc -x -free -v -I%src_cobol_dir% alert.cob              %COBCOBJ% %COBCLIB%
cobc -x -free -v -I%src_cobol_dir% borderlayout.cob       %COBCOBJ% %COBCLIB%
cobc -x -free -v -I%src_cobol_dir% borderpanel.cob        %COBCOBJ% %COBCLIB%
cobc -x -free -v -I%src_cobol_dir% button.cob             %COBCOBJ% %COBCLIB%
cobc -x -free -v -I%src_cobol_dir% canvas.cob             %COBCOBJ% %COBCLIB%
cobc -x -free -v -I%src_cobol_dir% checkbox.cob           %COBCOBJ% %COBCLIB%
cobc -x -free -v -I%src_cobol_dir% choice.cob             %COBCOBJ% %COBCLIB%
cobc -x -free -v -I%src_cobol_dir% colors.cob             %COBCOBJ% %COBCLIB%
cobc -x -free -v -I%src_cobol_dir% colors1.cob            %COBCOBJ% %COBCLIB%
cobc -x -free -v -I%src_cobol_dir% componentlistener.cob  %COBCOBJ% %COBCLIB%
cobc -x -free -v -I%src_cobol_dir% cursor.cob             %COBCOBJ% %COBCLIB%
cobc -x -free -v -I%src_cobol_dir% daemon.cob             %COBCOBJ% %COBCLIB%
cobc -x -free -v -I%src_cobol_dir% dialog.cob             %COBCOBJ% %COBCLIB%
cobc -x -free -v -I%src_cobol_dir% dialogmodal.cob        %COBCOBJ% %COBCLIB%
cobc -x -free -v -I%src_cobol_dir% filedialog.cob         %COBCOBJ% %COBCLIB%
cobc -x -free -v -I%src_cobol_dir% flowlayout.cob         %COBCOBJ% %COBCLIB%
cobc -x -free -v -I%src_cobol_dir% flowsimple.cob         %COBCOBJ% %COBCLIB%
cobc -x -free -v -I%src_cobol_dir% focuslistener.cob      %COBCOBJ% %COBCLIB%
cobc -x -free -v -I%src_cobol_dir% font.cob               %COBCOBJ% %COBCLIB%
cobc -x -free -v -I%src_cobol_dir% frame.cob              %COBCOBJ% %COBCLIB%
cobc -x -free -v -I%src_cobol_dir% graphic.cob            %COBCOBJ% %COBCLIB%
cobc -x -free -v -I%src_cobol_dir% graphicbutton.cob      %COBCOBJ% %COBCLIB%
cobc -x -free -v -I%src_cobol_dir% graphiclabel.cob       %COBCOBJ% %COBCLIB%
cobc -x -free -v -I%src_cobol_dir% gridlayout.cob         %COBCOBJ% %COBCLIB%
cobc -x -free -v -I%src_cobol_dir% image.cob              %COBCOBJ% %COBCLIB%
cobc -x -free -v -I%src_cobol_dir% insets.cob             %COBCOBJ% %COBCLIB%
cobc -x -free -v -I%src_cobol_dir% keylistener.cob        %COBCOBJ% %COBCLIB%
cobc -x -free -v -I%src_cobol_dir% label.cob              %COBCOBJ% %COBCLIB%
cobc -x -free -v -I%src_cobol_dir% lines.cob              %COBCOBJ% %COBCLIB%
cobc -x -free -v -I%src_cobol_dir% list.cob               %COBCOBJ% %COBCLIB%
cobc -x -free -v -I%src_cobol_dir% listmultiple.cob       %COBCOBJ% %COBCLIB%
cobc -x -free -v -I%src_cobol_dir% menu.cob               %COBCOBJ% %COBCLIB%
cobc -x -free -v -I%src_cobol_dir% mousebuttons.cob       %COBCOBJ% %COBCLIB%
cobc -x -free -v -I%src_cobol_dir% mouselistener.cob      %COBCOBJ% %COBCLIB%
cobc -x -free -v -I%src_cobol_dir% panel.cob              %COBCOBJ% %COBCLIB%
cobc -x -free -v -I%src_cobol_dir% popupmenu.cob          %COBCOBJ% %COBCLIB%
cobc -x -free -v -I%src_cobol_dir% print.cob              %COBCOBJ% %COBCLIB%
cobc -x -free -v -I%src_cobol_dir% radiobutton.cob        %COBCOBJ% %COBCLIB%
cobc -x -free -v -I%src_cobol_dir% rubberband.cob         %COBCOBJ% %COBCLIB%
cobc -x -free -v -I%src_cobol_dir% scaledimage.cob        %COBCOBJ% %COBCLIB%
cobc -x -free -v -I%src_cobol_dir% scrollbar.cob          %COBCOBJ% %COBCLIB%
cobc -x -free -v -I%src_cobol_dir% scrollpane.cob         %COBCOBJ% %COBCLIB%
cobc -x -free -v -I%src_cobol_dir% simple.cob             %COBCOBJ% %COBCLIB%
cobc -x -free -v -I%src_cobol_dir% simplemenu.cob         %COBCOBJ% %COBCLIB%
cobc -x -free -v -I%src_cobol_dir% textfield.cob          %COBCOBJ% %COBCLIB%
cobc -x -free -v -I%src_cobol_dir% vumeter.cob            %COBCOBJ% %COBCLIB%
cobc -x -free -v -I%src_cobol_dir% window.cob             %COBCOBJ% %COBCLIB%
cobc -x -free -v -I%src_cobol_dir% windowlistener.cob     %COBCOBJ% %COBCLIB%

:eof

pause
