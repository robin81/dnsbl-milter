# $Id$
#
# Copyright (C) 2007-2014 Haw Loeung <h.loeung@unixque.com>
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
#

WARN     = -Wall -Wextra -Wpointer-arith -Wstrict-prototypes -O2
LIBS     = -lmilter -lpthread
PROGNAME = dnsbl-milter

INSTPATH = /usr/local/sbin/

INCDIRS  = -I/usr/include/libmilter/ -I./inih/include
LIBDIRS  = -L/usr/lib/ -L/usr/lib/libmilter/

DEPENDENCIES = ini.o

default all: $(PROGNAME)

ini.o: ./inih/lib/ini.c
	$(CC) $(WARN) $(INCDIRS) -c ./inih/lib/ini.c

$(PROGNAME).o: $(PROGNAME).c
	$(CC) $(WARN) $(CFLAGS) -D_REENTRANT $(LIBS) $(INCDIRS) $(LIBDIRS) -c $(PROGNAME).c


$(PROGNAME): $(PROGNAME).o $(DEPENDENCIES)
	$(CC) $(PROGNAME).o $(DEPENDENCIES) $(LIBS) $(INCDIRS) $(LIBDIRS) -o $(PROGNAME)

install: $(PROGNAME)
	if [ -f "$(INSTPATH)/$(PROGNAME)" ]; then \
		cp -af "$(INSTPATH)/$(PROGNAME)" "$(INSTPATH)/$(PROGNAME).bak"; \
	fi
	install -m 755 -D $(PROGNAME) $(INSTPATH)/$(PROGNAME)
	strip $(INSTPATH)/$(PROGNAME)

clean:
	rm -f $(PROGNAME) $(PROGNAME).o $(DEPENDENCIES)
