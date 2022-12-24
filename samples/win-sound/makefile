COBCEXE = cobc -x -free
COBCMOD = cobc -m -free
COBCOBJ = cobc -c -free

all : tstwinsound.exe tstwsound.exe

# compile and link with Winmm lib
tstwsound.exe : tstwsound.cob
	$(COBCEXE) tstwsound.cob -fno-gen-c-decl-static-call -A "-include Windows.h" -lWinmm

# compile and link with Winmm lib
tstwinsound.exe : tstwinsound.cob winsound.cob win_sound.c winsound.o win_sound.o
	$(COBCEXE) tstwinsound.cob winsound.o win_sound.o -lWinmm
	
winsound.o : winsound.cob
	$(COBCOBJ) winsound.cob
	
win_sound.o : win_sound.c
	$(COBCOBJ) win_sound.c 
	
# clean
clean :
	rm -f *.exe
	rm -f *.o

	