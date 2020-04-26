all:	testmmul.exe mmul.dll

testmmul.exe:	testmmul.cob copy_files/z-constants.cpy
	cobc -x -free -debug -Wall testmmul.cob

mmul.dll:	mmul.cob copy_files/z-constants.cpy
	cobc -m -free -debug -Wall mmul.cob

clean:
	rm -f testmmul.exe
	rm -f mmul.dll
