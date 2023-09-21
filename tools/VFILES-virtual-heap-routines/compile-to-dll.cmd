gcc  cbl_vfiles.c                  ^
     -o cbl_vfiles.dll             ^
     -s                            ^
     -shared                       ^
     -Wl,--subsystem,windows       ^
     -lpsapi                       ^
     -lcob
