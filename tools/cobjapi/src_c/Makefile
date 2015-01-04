CC = gcc
CFLAGS = -c -O2 -Wall -D_GCC
AR = ar
AFLAGS = -sr

all : libjapi.a

# Object Files
imageio.o : imageio.c japi.h
	$(CC) $(CFLAGS) imageio.c
fileselect.o : fileselect.c japi_p.h japi.h
	$(CC) $(CFLAGS) fileselect.c
japilib.o : japilib.c japi_p.h japi.h 
	$(CC) $(CFLAGS) japilib.c 


# link together 
libjapi.a  : japilib.o imageio.o fileselect.o
	$(AR) $(AFLAGS) $@ japilib.o imageio.o fileselect.o

# cleanman
clean :
	rm *.a *.o 
	