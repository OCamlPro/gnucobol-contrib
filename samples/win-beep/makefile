COBCEXE = cobc -x -free
COBCMOD = cobc -m -free
COBCOBJ = cobc -c -free

all : tstwinbeep.exe tstwbeep.exe

# compile and link with User32 lib
tstwbeep.exe : tstwbeep.cob
	$(COBCEXE) tstwbeep.cob -fno-gen-c-decl-static-call -A "-include Windows.h" -lUser32

# compile and link with User32 lib
tstwinbeep.exe : tstwinbeep.cob winbeep.cob win_beep.c winbeep.o win_beep.o
	$(COBCEXE) tstwinbeep.cob winbeep.o win_beep.o -lUser32
	
winbeep.o : winbeep.cob
	$(COBCOBJ) winbeep.cob
	
win_beep.o : win_beep.c
	$(COBCOBJ) win_beep.c 
	
# clean
clean :
	rm -f *.exe
	rm -f *.o

	