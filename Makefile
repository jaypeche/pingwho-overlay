# Makefile for clamav-realtime v0.2.0b
# Including platform definitions

# WARNING: Gentoo masked package, build with AI assistant

NAME=clamav-realtime
VERSION=0.2.0b

include Makefile.defs

CC=		gcc
STD=		_GNU_SOURCE
OBJS=		fanotify_daemon.o notify_send.o
LIBS=		-lnotify -lclamav
PKGCONFIG=	`pkg-config --cflags --libs libnotify libclamav`

.c.o:
		@echo Compiling sources...
		$(CC) -c -Wall $(CFLAGS) -D$(STD) $(PKGCONFIG) $<

build: $(OBJS)
		@echo Building executable...
		$(CC) $(OBJS) $(LDFLAGS) $(LIBS) -o $(NAME)

all: build install clean
		@echo $(NAME) was successfully installed !

install:
		@echo Installing files...
		install -d $(DESTDIR)/$(PREFIX)
		@chmod 655 $(NAME)
		@cp $(NAME) $(DESTDIR)/$(PREFIX)
		install -d $(DESTDIR)/$(PIXMAPS)
		@cp files/$(NAME).png $(DESTDIR)/$(PIXMAPS)
		install -d $(DESTDIR)/$(DOCDIR)/$(NAME)-$(VERSION)
		for doc in $(DOCFILES); do \
			cp $$doc $(DESTDIR)/$(DOCDIR)/$(NAME)-$(VERSION); \
		done

clean:
		@echo Cleaning sources...
		rm -f $(NAME) *.o core

clobber: clean
		@echo Uninstall application...
		rm -f $(PREFIX)/$(NAME)
		rm -f $(PIXMAPS)/$(NAME).png
		[ -e $(DOCDIR)/$(NAME)-$(VERSION) ] && rm -Rf $(DOCDIR)/$(NAME)-$(VERSION);
		@echo $(NAME) was successfully uninstalled !
