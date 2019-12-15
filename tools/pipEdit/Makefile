# tune these for your setup & compile options
#
#
### compile with the curses replacement pipcurses
OPTIONS=-O -D__USE_PIPCURSES__=1
LDFLAGS=
#
#
### compile with curses 
###OPTIONS=-O
###LDFLAGS=-lcurses

# basic compiling and linking - rarely changed
### compile with debugging support (gdb)
###CFLAGS=-Wall -ggdb $(OPTIONS) 
### compile without debugging support
CFLAGS=-Wall $(OPTIONS) 

# the objects we need
OBJS=pipedit.o

CC=gcc

# the compile targets
pipedit.bin: $(OBJS)
	$(CC) $(CFLAGS) -o pipedit.bin $(OBJS) $(LDFLAGS)

%.o: %.c %.h
	$(CC) $(CFLAGS) -c $*.c

clean:
	-rm -f $(OBJS) pipedit.bin *.o

