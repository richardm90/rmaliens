#
# Build script for Template Engine
#


#-------------------------------------------------------------------------------
# User-defined part start
#

SHELL=/QOpenSys/pkgs/bin/bash

# BIN_LIB is the destination library for the programs.
BIN_LIB=RMALIENS

# The directory where all dependencies have their copy books.
INCDIR=$(HOME)/builds/include

TGTRLS=*CURRENT

#
# User-defined part end
#-------------------------------------------------------------------------------



all: env 
	$(MAKE) -C cloud_mssql/ all $*
	$(MAKE) -C salesforce/ all $*

clean:
	$(MAKE) -C cloud_mssql/ clean $*
	$(MAKE) -C salesforce/ clean $*

purge:
	-rm -rf $(INCDIR)
	$(MAKE) -C cloud_mssql/ purge $*
	$(MAKE) -C salesforce/ purge $*

env:
	-system "CRTLIB LIB($(BIN_LIB)) TEXT('RMALIENS Demo Library')"

install:
	-mkdir -p $(INCDIR)
	$(MAKE) -C cloud_mssql/ install $*
	$(MAKE) -C salseforce/ install $*

.PHONY: env clean purge install