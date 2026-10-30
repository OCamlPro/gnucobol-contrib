# ====================================================================
#  Cross-Platform Makefile for testlibgcs (Linux & MinGW/MSYS2)
# ====================================================================

# 1. AUTOMATIC OPERATING SYSTEM DETECTION
ifeq ($(OS),Windows_NT)
    EXE_EXT = .exe
    OS_CFLAGS = -fcommon
    COB_CFLAGS := $(shell cob-config --cflags 2>nul)
    COB_LDFLAGS := $(shell cob-config --libs 2>nul)
    ifeq ($(COB_LDFLAGS),)
        COB_LDFLAGS = -lcob
    endif
else
    EXE_EXT =
    OS_CFLAGS =
    COB_CFLAGS := $(filter -I%,$(shell cob-config --cflags 2>/dev/null))
    COB_LDFLAGS := $(shell cob-config --libs 2>/dev/null)
    ifeq ($(COB_LDFLAGS),)
        COB_LDFLAGS = -lcob
    endif
endif

# 2. COMPILER AND DIRECTORIES DEFINITION
CC       = gcc
INC_DIR  = .

# Include sia la radice che la sottocartella libgcs per gli header .h
CFLAGS   = -g -Wall -Wextra -O2 -std=c11 -I$(INC_DIR) -I./libgcs -I../libgcs $(COB_CFLAGS) $(OS_CFLAGS)

# LINKER FLAGS: Risoluzione del caricamento dinamico nativo
ifeq ($(OS),Windows_NT)
    # Su MinGW usiamo la libreria di importazione statica creata nella cartella lib/
    LDFLAGS  = lib/libgcs.a $(COB_LDFLAGS) -Wl,--allow-multiple-definition
else
    # Su Linux usiamo la convenzione standard -L e -l, impostando il rpath relativo all'eseguibile
    LDFLAGS  = -Llib -lgcs $(COB_LDFLAGS) -Wl,-rpath,'$$ORIGIN/../../lib':./lib:/usr/local/lib
endif

# Il target scrive l'eseguibile direttamente nella cartella finale tests/bin/
TARGET_NAME = testlibgcs
OUTDIR      = tests/bin
TARGET      = $(OUTDIR)/$(TARGET_NAME)$(EXE_EXT)

SRCS     = testlibgcs/testlibgcs.c
OBJS     = testlibgcs/testlibgcs.o

# 3. BUILD RULES
all: $(TARGET)

# Il compilatore genera l'eseguibile direttamente in tests/bin
$(TARGET): $(OBJS)
	@echo [Target] Linking test executable: $(TARGET)
	$(CC) $(CFLAGS) -o $(TARGET) $(OBJS) $(LDFLAGS)
	@echo Compilation successful! Executable created: $(TARGET)

# Compilazione del file oggetto
testlibgcs/testlibgcs.o: testlibgcs/testlibgcs.c
	$(CC) $(CFLAGS) -c testlibgcs/testlibgcs.c -o testlibgcs/testlibgcs.o

# Target unico di pulizia compatibile sia con Linux che con MSYS2/MinGW (Senza if/spaces bug)
clean:
	@echo "Cleaning test environment artifacts..."
	-rm -f testlibgcs/testlibgcs.o
	-rm -f tests/bin/testlibgcs
	-rm -f tests/bin/testlibgcs.exe
	@echo Cleanup completed.

rebuild: clean all

.PHONY: all clean rebuild

