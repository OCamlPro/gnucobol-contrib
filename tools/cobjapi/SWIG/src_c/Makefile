# GNU MAKE Makefile for japi library used in COBJAPI
#
# Usage: make [DEBUG=Y] [VERBOSE=Y] [CFLAGS=-Wno-unused-result]

O = o

ifndef COBC
	COBC = cobc
endif

ifeq ($(DEBUG),Y)
	COBCFLAGS = $(COBFLAGS) -g
else
	COBCFLAGS = $(COBFLAGS) -O2
endif

ifeq ($(VERBOSE),Y)
	COBCFLAGS += -v
endif

ifdef CFLAGS
	COBCFLAGS += -A "$(CFLAGS)"
endif
ifdef LDFLAGS
	COBCFLAGS += -Q "$(LDFLAGS)"
endif

uname_S := $(shell uname -s 2>/dev/null)

ifneq (,$(findstring MINGW32_NT,$(uname_S)))
	#  Insert MINGW32-specific changes here
	COBCFLAGS += -lws2_32
endif
ifneq (,$(findstring MINGW64_NT,$(uname_S)))
	#  Insert MINGW64-specific changes here
	COBCFLAGS += -lws2_32
endif

ifeq ($(uname_S),)
	DELETE = -del
	# we may check for COB_OBJECT_EXT and set O here
else
	DELETE = rm -f
endif


# actual target...
all : libjapi.a

.PHONY: clean

# Object Files
imageio.$(O) : imageio.c japi.h
	$(COBC) $(COBCFLAGS) -c imageio.c
fileselect.$(O) : fileselect.c japi_p.h japi.h
	$(COBC) $(COBCFLAGS) -c fileselect.c
japilib.$(O) : japilib.c japi_p.h japi.h 
	$(COBC) $(COBCFLAGS) -c japilib.c 


# link together 
libjapi.a  : japilib.$(O) imageio.$(O) fileselect.$(O)
	$(COBC) $(COBCFLAGS) -b -o $@ japilib.$(O) imageio.$(O) fileselect.$(O)

clean :
	$(DELETE) *.a *.$(O)
