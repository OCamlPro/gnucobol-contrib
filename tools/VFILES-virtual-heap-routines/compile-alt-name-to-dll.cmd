gcc  cbl_vfiles.c                  ^
     -o cwh_vfiles.dll             ^
     -DALT_NAME                    ^
     -s                            ^
     -shared                       ^
     -Wl,--subsystem,windows       ^
     -lpsapi                       ^
     -lcob
