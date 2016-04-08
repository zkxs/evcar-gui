# cross compilers:
# i686-w64-mingw32-gcc     # 32-bit
# x86_64-w64-mingw32-gcc   # 64-bit

WINCC=x86_64-w64-mingw32-gcc

# other nifty flags: -Werror -Wno-unused-function

# GTK+3 flags
GTKFLAGS:=$(shell pkg-config --cflags gtk+-3.0)
# GTK+3 libraries
GTKLIBS:=$(shell pkg-config --libs gtk+-3.0)

# for debugging
CFLAGS=-g -std=c99 -Wall -Wmissing-prototypes $(GTKFLAGS)

# for production
#CFLAGS=-O3 -std=c99 -Wall -Wmissing-prototypes $(GTKFLAGS)

# desired build targets
SDIR=src
ODIR=bin
_TARGETS=example-0
TARGETS=$(patsubst %,$(ODIR)/%,$(_TARGETS))

# libraries required during linking
LIBS=
WINLIBS=

all: setup $(TARGETS)

test:
	echo $@

# cross compile static libraries (the native compile is implicit)
%.lib: %.c
	$(WINCC) $(CFLAGS) -c $< -o $@
# build the executables
%.exe: %.c $(WINLIBS)
	$(WINCC) $(CFLAGS) $(WINLIBS) $< -o $@ $(GTKLIBS)
$(ODIR)/%: $(SDIR)/%.c $(LIBS)
	$(CC) $(CFLAGS) $(LIBS) $< -o $@ $(GTKLIBS)

setup:
	mkdir -p $(ODIR)

clean: 
	rm -rf $(ODIR)
#rm -f $(ODIR)/$(LIBS) $(ODIR)/$(WINLIBS) $(ODIR)/$(TARGETS)
