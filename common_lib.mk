##
# Common settings for Makefiles
#
# Stefan Wendler, sw@kaltpost.de
##

# compiler prefix
PREFIX	?= arm-none-eabi-
# PREFIX	?= arm-elf-

CC			 = $(PREFIX)gcc
AR			 = $(PREFIX)ar

INCDIR		+= -I./include -I$(HOME)/sat/arm-none-eabi/include
CFLAGS		+= -Os -g -Wall -Wextra -fno-common -mcpu=cortex-m3 -mthumb -msoft-float -MD $(INCDIR) -DSTM32F1
ARFLAGS		 = rcs

# where to put generated libraries to
LIBDIR		?= ../lib

# doxygen executable
DOXYGEN = doxygen

# doxygen flags
DOXYGENFLAGS = ../doxygen.conf

# styler to use
STYLER = astyle

# which c-style to use
# - see man astyle
STYLERFLAGS = --style=stroustrup

# cpp checker
CHECKER = cppcheck

# flags for checker
# CHECKERFLAGS = --error-exitcode=1 --enable=all
CHECKERFLAGS = --enable=all --error-exitcode=1

.SUFFIXES: .elf .bin .hex .srec .list .images
.SECONDEXPANSION:
.SECONDARY:

all: $(LIBNAME).a

$(LIBNAME).a: $(OBJS)
	@#printf "  AR      $(subst $(shell pwd)/,,$(@))\n"
	$(AR) $(ARFLAGS) $@ $^ && cp $(LIBNAME).a $(LIBDIR)/.

%.o: %.c Makefile
	@#printf "  CC      $(subst $(shell pwd)/,,$(@))\n"
	$(CC) $(CFLAGS) -o $@ -c $<

%.o: %.cpp Makefile
	@#printf "  CC      $(subst $(shell pwd)/,,$(@))\n"
	$(CC) $(CFLAGS) -o $@ -c $<

SRC = $(wildcard *.c)
HDR = $(wildcard include/*.h)

style:
	$(STYLER) $(STYLERFLAGS) $(SRC)
	$(STYLER) $(STYLERFLAGS) $(HDR)

clean:
	rm -f *.o
	rm -f *.a
	rm -f *.d
	rm -f *.elf
	rm -f *.bin
	rm -f *.hex
	rm -f *.srec
	rm -f *.list
	rm -f *.orig
	rm -f include/*.orig

.PHONY: images clean
