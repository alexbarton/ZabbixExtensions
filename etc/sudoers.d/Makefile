#
# Makefile
#

USER_LINUX ?= zabbix
USER_OSX ?= admin

SUDOERS_D ?= $(PREFIX)/etc/sudoers.d

include ../../lib/Makefile.ax

all-local: zabbix-extensions

clean-local:
	rm -f zabbix-extensions

install-local:
	install -d -o $(USER) -g $(GROUP) -m 755 \
	 $(DESTDIR)$(SUDOERS_D)
	install -o $(USER) -g $(GROUP) -m 440 \
	 zabbix-extensions $(DESTDIR)$(SUDOERS_D)/zabbix-extensions

zabbix-extensions: zabbix-extensions.in
	cat zabbix-extensions.in | sed \
	 -e 's/%USER_LINUX%/$(USER_LINUX)/g' \
	 -e 's/%USER_OSX%/$(USER_OSX)/g' \
	 >zabbix-extensions
