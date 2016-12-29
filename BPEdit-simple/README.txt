
~~~ BPE - Breakpoint Editor ~~~ README ~~~

Python 3.4 and Qt5 based editor for breakpoints in GC 2 Debugger

Functionality:
 - Load GnuCOBOL module for showing COBOL code
 - Browse / Search in the code
 - Set Breakpoints (placed in breakpoint list file)

Settings are placed in GUI\paths.ini

- Directory with cobol modules
  src_folder=X:\bin
- Path to breakpoint list
  bp_file=X:\xanim_breakpoint.lst
- Path to Qt5 UI file
  ui_file=X:\bpedit.ui
- Path to directory with libcob.dll
  (Alternative: GNU/Linux: export LD_LIBRARY_PATH; Windows: set PATH)
  libcob_path=X:\
 
Dependencies: 
 - Python 3.4
 - cxfreeze for Python
 - Qt 5 for Windows
 