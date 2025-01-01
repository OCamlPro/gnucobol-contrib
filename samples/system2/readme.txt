System2 is a cross-platform c library that allows you to call shell commands and
other executables (subprocess), just like `system` but with the ability to
provide input to stdin and capture the output from stdout and stderr.

You can check out System2 from https://github.com/Neko-Box-Coder/System2
but it is also here with this GnuCOBOL example.

Features:

- Written in C99, and is ready to be used in C++ as well
- Cross-platform (POSIX and Windows)
- Command interaction with stdin, stdout, and stderr
- Invoking shell commands and launching executables
- Blocking (sync) and non-blocking (async) version
- No dependencies (only standard C and system libraries).
    No longer need a heavy framework like boost or poco just to capture output
	from running a command.
- Header only library (source version available as well)
- UTF-8 support
- CMake integration

For more please check the files and examples under System2_src.

Files:

makefile       - for compile
readme.txt     - this file
system2_cmd.c  - system2_cmd() function, it reads the output in async mode
testsys2.cob   - small GnuCOBOL test program to call the system2_cmd() function
System2_src    - System2 source code

It was tested with 
- Windows 10 Enterprise; 
- GnuCOBOL 3.2.0; 
- C-Version (MinGW) "13.1.0" 
