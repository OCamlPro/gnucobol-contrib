
~~~ BPE - Breakpoint Editor ~~~ README ~~~

Python 3.4 and Qt5 based editor for breakpoints in GC 2 Debugger

Functionality:

 - Load GnuCOBOL module for showing COBOL code
 - Browse / Search in the code
 - Set Breakpoints (placed in breakpoint list file)

Requirements:

- Python3
- PyQt5
- pyQode

Installation:

a) when running from source:

- install Python3, pip and PyQt5 using your package manager or the installer files for your platform.
- once: run env-setup (.bat on Windows, .sh on GNU/Linux and Mac OS) to install the dependencies
- run BPEdit.pyw

b) when running from dist-package (windows):
- run BPEdit.bat (if the dist-package doesn't contain all prerequisites: run env-setup.bat once)

Settings are placed in paths.ini:

- Directory with cobol modules
  src_folder=X:\bin
- Path to breakpoint list
  bp_file=X:\xanim_breakpoint.lst
- Path to Qt5 UI file
  ui_file=X:\bpedit.ui
- Path to directory with libcob.dll
  (Alternative: GNU/Linux: export LD_LIBRARY_PATH; Windows: set PATH)
  libcob_path=X:\

To add/remove a breakpoint, click in the gutter of the editor (beside the line number area).
