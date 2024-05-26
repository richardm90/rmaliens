#
# Build script for RMALIENS RPGLE programs
#

#-------------------------------------------------------------------------------
# User-defined part start
#

SHELL=/QOpenSys/pkgs/bin/bash

# BIN_LIB is the destination library for the programs.
BIN_LIB=RMALIENS
LIBLIST=$(BIN_LIB) LIBHTTP YAJL

# The directory where all dependencies have their copy books.
INCDIR=$(HOME)/builds/include

TGTRLS=*CURRENT

# RCFLAGS = RPG compile parameter
RCFLAGS=OPTION(*SRCSTMT) DBGVIEW(*ALL) INCDIR('$(INCDIR)') TGTRLS($(TGTRLS)) TGTCCSID(*JOB)

# SCFLAGS = RPG compile parameter
SCFLAGS=DBGVIEW(*SOURCE) RPGPPOPT(*LVL2) INCDIR('$(INCDIR)') TGTRLS($(TGTRLS)) CVTCCSID(*JOB) COMPILEOPT('TGTCCSID(*JOB)')

# BINDFLAGS = binding parameter
BINDFLAGS=TEXT(*MODULE) STGMDL(*INHERIT) TGTRLS($(TGTRLS))

#
# User-defined part end
#-------------------------------------------------------------------------------


.SUFFIXES: .rpgle .sqlrpgle

# suffix rules
.rpgle:
	liblist -a $(LIBLIST);\
	system -ks "CRTBNDRPG PGM($(BIN_LIB)/$@) SRCSTMF('$<') $(RCFLAGS)"
.sqlrpgle:
	liblist -a $(LIBLIST);\
	system -ks "CRTSQLRPGI OBJ($(BIN_LIB)/$@) SRCSTMF('$<') $(SCFLAGS)"
	
OBJECTS = concrt condlt condltall condown conget congetall conup

all: clean compile 

clean:

compile: $(OBJECTS)

install:
	cp *.rpgleinc $(INCDIR)

purge: clean
	-system "DLTPGM $(BIN_LIB)/CONCRT"
	-system "DLTPGM $(BIN_LIB)/CONDLT"
	-system "DLTPGM $(BIN_LIB)/CONDLTALL"
	-system "DLTPGM $(BIN_LIB)/CONDOWN"
	-system "DLTPGM $(BIN_LIB)/CONGET"
	-system "DLTPGM $(BIN_LIB)/CONGETALL"
	-system "DLTPGM $(BIN_LIB)/CONUP"

.PHONY: install purge
