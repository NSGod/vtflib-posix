LIBSRC=$(wildcard VTFLib/*.cpp)
LIBOBJ=$(LIBSRC:.cpp=.o)
LIBOUT=lib/libvtf.a

DYLIBOUT=lib/libvtf.dylib

BINSRC=$(wildcard VTFCmd/*.c)
BINOBJ=$(BINSRC:.c=.o)
BINOUT=bin/vtfcmd

# C++ compiler flags (-g -O2 -Wall)
CCFLAGS=-g -Os -Wall
CFLAGS=-g -Os -Wall

# compiler
CCC=clang++
CC=clang

# compile flags
LDFLAGS=-g

default: $(BINOUT)

$(BINOUT): $(LIBOUT) $(BINOBJ)
	$(CC) -o $@ $(BINOBJ) -lIL -Llib/ -lvtf -lc -lstdc++ -lm

.c.o:
	$(CC) $(CFLAGS) -c $< -o $@

$(LIBOUT): $(LIBOBJ)
	ar rcs $(LIBOUT) $(LIBOBJ)
	
$(DYLIBOUT): $(LIBOBJ)
	$(CCC) $(CCFLAGS) -install_name "@rpath/libvtf.dylib" -dynamiclib -o $(DYLIBOUT) $(LIBOBJ)

.cpp.o:
	$(CCC) $(CCFLAGS) -c $< -o $@

clean: cleanlib cleanbin
	rm -f Makefile.bak

cleanlib:
	rm -f $(LIBOBJ) $(LIBOUT) $(DYLIBOUT)

cleanbin:
	rm -f $(BINOBJ) $(BINOUT)
