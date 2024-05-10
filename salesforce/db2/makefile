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
	liblist -c $(BIN_LIB);\
	system -ks "RUNSQLSTM SRCSTMF('$<') COMMIT(*NONE) NAMING(*SQL)"

OBJECTS = concrta concrtb condlta condltb congeta congetb

all: compile 

compile: $(OBJECTS)

purge:
	-system "RUNSQL SQL('DROP PROCEDURE $(BIN_LIB).CONTACT_CREATE_A') COMMIT(*NONE) NAMING(*SQL)"
	-system "RUNSQL SQL('DROP PROCEDURE $(BIN_LIB).CONTACT_CREATE_B') COMMIT(*NONE) NAMING(*SQL)"
	-system "RUNSQL SQL('DROP PROCEDURE $(BIN_LIB).CONTACT_DELETE_A') COMMIT(*NONE) NAMING(*SQL)"
	-system "RUNSQL SQL('DROP PROCEDURE $(BIN_LIB).CONTACT_DELETE_B') COMMIT(*NONE) NAMING(*SQL)"
	-system "RUNSQL SQL('DROP PROCEDURE $(BIN_LIB).CONTACT_GET_A') COMMIT(*NONE) NAMING(*SQL)"
	-system "RUNSQL SQL('DROP PROCEDURE $(BIN_LIB).CONTACT_GET_B') COMMIT(*NONE) NAMING(*SQL)"

.PHONY: purge
