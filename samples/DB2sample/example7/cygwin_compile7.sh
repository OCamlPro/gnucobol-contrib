# clean
rm DB2TEST7.exe
rm DB2SQLMSG.dll
rm DB2MOD7.dll
rm DB2MOD7.bnd
rm DB2MOD7.cbl

# db2cmd -i -w -c db2 [command line parameters]
# -i : don't open a new console, share the existing console and stdin, stdout handles
# -c : run the specified command (db2 etc.) and terminate
# -w : wait until the spawned command process ends

db2cmd -i -w -c db2 -tvf db2_precompile7.sql

# pause
read -n1 -r -p "Press any key to continue..." key

# compile
cobc -m -std=mf DB2SQLMSG.cob -I/cygdrive/c/IBM/SQLLIB/include/cobol_mf -L/cygdrive/c/IBM/SQLLIB/lib -ldb2api
cobc -m -std=mf DB2MOD7.cbl -I/cygdrive/c/IBM/SQLLIB/include/cobol_mf -L/cygdrive/c/IBM/SQLLIB/lib -ldb2api
cobc -x DB2TEST7.cob
