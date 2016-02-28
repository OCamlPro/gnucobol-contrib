How to build in native Windows environments:

* get/build necessary headers, link libraries and runtime dlls,
  place them in build_windows\Win32 and build_windows\x64
* get MPIR, libcob, Bison and Flex 
* compile with your environment, for example via IDE by opening the solution
  and click "build" or starting the VS/WinSDK command prompt and calling
  msbuild "ocsort.sln" /p:Platform=x32 /p:Configuration=Release

* Custom build :
  Last step of compiler is copy of  executable in folder directoy ocsort_gentestcase\bin.
  You can enable or disable this step.

* Flex_Bison_cmd.Bat  
  This script check if scanner.l or parser.y are read-only
  If files are not read-only script execute win_flex / win_bison  
  for compile only if scanner.l or parser.y 
  
How to test the native builds:

* use subproject ocsort_gentestcase

