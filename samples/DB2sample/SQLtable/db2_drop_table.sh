# db2cmd -i -w -c db2 [command line parameters]
# -i : don't open a new console, share the existing console and stdin, stdout handles
# -c : run the specified command (db2 etc.) and terminate
# -w : wait until the spawned command process ends

db2cmd -i -w -c db2 -tvf db2_drop_table.sql
