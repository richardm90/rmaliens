#
# Build script for RMALIENS
#


#-------------------------------------------------------------------------------
# User-defined part start
#

# BIN_LIB is the destination library for the programs.
BIN_LIB=RMALIENS

# The directory where all dependencies have their copy books.
INCDIR=$(HOME)/builds/include

#
# User-defined part end
#-------------------------------------------------------------------------------



all: env 
	$(MAKE) -C src/ all $*
	$(MAKE) -C db2/ all $*

clean:
	$(MAKE) -C src/ clean $*

purge:
	$(MAKE) -C src/ purge $*
	$(MAKE) -C db2/ purge $*

env:

install:
	$(MAKE) -C src/ install $*

.PHONY: env clean purge install