#
# Build script for RMALIENS DB2 objects
#
# - The current library is set to the BIN_LIB value. This means the RUNSQLSTM
#   command will create the DB2 objects in this library.
#

#-------------------------------------------------------------------------------
# User-defined part start
#

SHELL=/QOpenSys/pkgs/bin/bash

# BIN_LIB is the destination library for the programs.
BIN_LIB=RMALIENS

#
# User-defined part end
#-------------------------------------------------------------------------------


.SUFFIXES: .sql

# suffix rules
.sql:
	system -ks "CHGCURLIB CURLIB($(BIN_LIB))"
	system -ks "RUNSQLSTM SRCSTMF('$<') COMMIT(*NONE) NAMING(*SYS)"

OBJECTS = download percrt perdlt perdltall perget pergetall person upload

all: compile 

compile: $(OBJECTS)

purge:
	-system "RUNSQL SQL('DROP PROCEDURE $(BIN_LIB).PERSON_CREATE') COMMIT(*NONE) NAMING(*SQL)"
	-system "RUNSQL SQL('DROP PROCEDURE $(BIN_LIB).PERSON_DELETE') COMMIT(*NONE) NAMING(*SQL)"
	-system "RUNSQL SQL('DROP PROCEDURE $(BIN_LIB).PERSON_DELETEALL') COMMIT(*NONE) NAMING(*SQL)"
	-system "RUNSQL SQL('DROP PROCEDURE $(BIN_LIB).PERSON_DOWNLOAD') COMMIT(*NONE) NAMING(*SQL)"
	-system "RUNSQL SQL('DROP PROCEDURE $(BIN_LIB).PERSON_GETALL') COMMIT(*NONE) NAMING(*SQL)"
	-system "RUNSQL SQL('DROP PROCEDURE $(BIN_LIB).PERSON_GET') COMMIT(*NONE) NAMING(*SQL)"
	-system "RUNSQL SQL('DROP PROCEDURE $(BIN_LIB).PERSON_UPLOAD') COMMIT(*NONE) NAMING(*SQL)"
	-system "RUNSQL SQL('DROP TABLE $(BIN_LIB).PERSON') COMMIT(*NONE) NAMING(*SQL)"

.PHONY: purge
