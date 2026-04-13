# The makefile for the Xyink: XY Inverse Kinematics Program
.POSIX:

# GNU MAKE convention 
SHELL = /bin/sh
SRC = xyink.c
SIMSSRC = xyink_sims.c

# CONFIG
NAME = xyink
SIMSNAME = xyink_sims
BDIR = ./build/
VERSION = 0.6
DATE = April 04, 2023
PREFIX = /usr/local
MANPREFIX = $(PREFIX)/share/man
CC := gcc
# INCS =  # No includes
LIBS = -L. -lm
XYCFLAGS = -Wall # add -g if debugging
WINCC := x86_64-w64-mingw32-gcc

all: options compile

compile:
	@echo "Compiling main executable..."
	${CC} $(XYCFLAGS) $(LIBS) $(SRC) -o $(BDIR)$(NAME)

options:
	@echo "------------- Compile Options -------------"
	@echo "VERSION 	= $(VERSION)"
	@echo "CC		= $(CC)"
	@echo "WinCC	= $(WINCC)"
	@echo "XYCFLAGS = $(XYCFLAGS)"
	@echo "LIBS 	= $(LIBS)"
	@echo "BUILD DIR = $(BDIR)"
	@echo "DESTDIR 	= $(DESTDIR)"

install: all
	@echo "Installing..."
	mkdir -p $(DESTDIR)$(PREFIX)/bin
	# Copy the compiled executable to path
	cp -f $(BDIR)$(NAME) $(DESTDIR)$(PREFIX)/bin
	chmod 755 $(DESTDIR)$(PREFIX)/bin/$(NAME)
	mkdir -p $(DESTDIR)$(MANPREFIX)/man1
	# Create the man page in the path
	echo ".Dd $(DATE)\n" > $(DESTDIR)$(MANPREFIX)/man1/$(NAME).1
	cat ./$(NAME).info >> $(DESTDIR)$(MANPREFIX)/man1/$(NAME).1
	chmod 644 $(DESTDIR)$(MANPREFIX)/man1/$(NAME).1
	@echo "Installation complete."

sims:
	${CC} $(XYCFLAGS) $(LIBS) $(SIMSSRC) -o $(SIMSNAME)

win64:
	@echo "Compiling Windows Executable x64"
	${WINCC} $(XYCFLAGS) $(LIBS) $(SRC) -o $(BDIR)$(NAME)

uninstall:
	@echo "Uninstalling..."
	rm -f $(DESTDIR)$(PREFIX)/bin/$(NAME)
	rm -f $(DESTDIR)$(PREFIX)/man1/$(NAME).1
	@echo "Uninstall complete."

.PHONY: all options install uninstall
