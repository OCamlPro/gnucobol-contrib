copy /Y bpedit.ui dist\bpedit.ui
python C:\Python34\Scripts\cxfreeze --target-name=bpedit.exe --include-path=.;Backend;GUI;Utils --include-modules=StringUtils,LoadEnv,BreakPointMgt,CWrapper GUI\Start.py > log.txt
