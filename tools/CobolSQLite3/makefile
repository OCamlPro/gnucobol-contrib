# Makefile for CobolSQLite3
.RECIPEPREFIX = >
.ONESHELL:

help:
> #
> # This makefile contains the following options:
> #
> # library    - Compiles the Cobol SQLite3 Library.
> # listing    - Generates a hard-copy listing of the library.
> # copylibs   - Generates the required Copylibrary Modules.
> # html       - Generates the HTML User Guide.
> # test-1     - Compile and run example/test program 1.
> # test-1d    - Compile and run example/test program 1 with debug displays.
> # test-2     - Compile and run example/test program 2.
> # test-2d    - Compile and run example/test program 2 with debug displays.
> # test-3     - Compile and run example/test program 3.
> # test-3d    - Compile and run example/test program 3 with debug displays.
> #

library:
> @echo
> @cobc -o CobolSQLite3.so -debug CobolSQLite3.cob -lsqlite3
> @echo Library written to CobolSQLite3.so
> @echo

listing:
> @echo
> @cobc -F -Xref -T CobolSQLite3.lst CobolSQLite3.cob
> @echo Library hard-copy listing written to CobolSQLite3.lst
> @echo

copylibs: CobolSQLite3.so
> @echo
> @cobcrun ./CobolSQLite3 --copylib > CobolSQLite3-WS.cpy
> @echo Working-Storage Module written to CobolSQLite3-WS.cpy
> @cobcrun ./CobolSQLite3 --repository > CobolSQLite3-CSR.cpy
> @echo Repository Module written to CobolSQLite3-CSR.cpy
> @echo

html:
> @echo
> @ocdoc CobolSQLite3.cob CobolSQLite3.rst CobolSQLite3.html rwmcug.css
> @rm CobolSQLite3.rst
> @echo HTML User Guide written to CobolSQLite3.html
> @echo

test-1:
> @cobc -x Test-1.cob
> @export COB_PRE_LOAD=CobolSQLite3
> @echo Running example/test program 1
> ./Test-1
> @echo

test-1d:
> @cobc -x -fdebugging-line Test-1.cob
> @export COB_PRE_LOAD=CobolSQLite3
> @echo Running example/test program 1 with debug displays
> ./Test-1
> @echo

test-2:
> @cobc -x Test-2.cob
> @export COB_PRE_LOAD=CobolSQLite3
> @echo Running example/test program 2
> ./Test-2
> @echo

test-2d:
> @cobc -x -fdebugging-line Test-2.cob
> @export COB_PRE_LOAD=CobolSQLite3
> @echo Running example/test program 2 with debug displays
> ./Test-2
> @echo

test-3:
> @cobc -x Test-3.cob
> @export COB_PRE_LOAD=CobolSQLite3
> @echo Running example/test program 3
> ./Test-3
> @echo

test-3d:
> @cobc -x -fdebugging-line Test-3.cob
> @export COB_PRE_LOAD=CobolSQLite3
> @echo Running example/test program 3 with debug displays
> ./Test-3
> @echo

# End of CobolSQLite3 makefile.
