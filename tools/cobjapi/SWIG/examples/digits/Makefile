# GNU MAKE Makefile for COBJAPI examples
#
# Usage: make [DEBUG=Y] [VERBOSE=Y] [COBFLAGS=-Wno-unfinished]

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

ifneq (,$(findstring CYGWIN,$(uname_S)))
	#  Insert Cygwin-specific changes here
	ON_WINDOWS = 1
endif
ifneq (,$(findstring MINGW32_NT,$(uname_S)))
	#  Insert MINGW32-specific changes here
	COBCFLAGS += -lws2_32
	ON_WINDOWS = 1
endif
ifneq (,$(findstring MINGW64_NT,$(uname_S)))
	#  Insert MINGW64-specific changes here
	COBCFLAGS += -lws2_32
	ON_WINDOWS = 1
endif

ifeq ($(uname_S),)
	DELETE = -del
	# we may check for COB_OBJECT_EXT and set O here
	ON_WINDOWS = 1
else
	DELETE = rm -f
endif

ifdef ON_WINDOWS
	EXE_EXT = .exe
else
	EXE_EXT =
endif

COBJAPI_MAIN_SRC = ../..

# static link
COBJAPI = $(COBJAPI_MAIN_SRC)/src_cobol/cobjapi.$(O)
CJAPI = $(COBJAPI_MAIN_SRC)/src_c/japilib.$(O) \
		$(COBJAPI_MAIN_SRC)/src_c/imageio.$(O) \
		$(COBJAPI_MAIN_SRC)/src_c/fileselect.$(O)

SOURCES = $(wildcard *.cob)
DEMOS = $(SOURCES:.cob=$(EXE_EXT))

.PHONY: clean

# target list
all : $(DEMOS)

$(DEMOS) : $(COBJAPI) $(CJAPI)

# compile
%$(EXE_EXT): %.cob
	$(COBC) -x -free -I"$(COBJAPI_MAIN_SRC)/src_cobol" $(COBCFLAGS) $^

# clean
clean :
	$(DELETE) $(DEMOS)
