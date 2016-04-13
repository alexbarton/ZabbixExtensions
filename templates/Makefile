#
# Makefile
#

TEMPLATES = \
	"Template App Backup-Script.xml" \
	"Template App TimeMachine.xml"

TEMPLATE_D = /share/zabbix-extensions/templates

include ../lib/Makefile.ax

install-local:
	install -d -o $(USER) -g $(GROUP) -m 755 \
	 $(DESTDIR)$(PREFIX)$(TEMPLATE_D)
	install -o $(USER) -g $(GROUP) -m 644 \
	 $(TEMPLATES) $(DESTDIR)$(PREFIX)$(TEMPLATE_D)
