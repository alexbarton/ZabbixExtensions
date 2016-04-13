#
# Makefile
#

USERPARAMETERS = \
	userparameter_app-backup-script.conf \
	userparameter_app-timemachine.conf

AGENT_CONF_D = /etc/zabbix/zabbix_agentd.conf.d

include ../../lib/Makefile.ax

install-local:
	install -d -o $(USER) -g $(GROUP) -m 755 \
	 $(DESTDIR)$(PREFIX)$(AGENT_CONF_D)
	install -o $(USER) -g $(GROUP) -m 644 \
	 $(USERPARAMETERS) $(DESTDIR)$(PREFIX)$(AGENT_CONF_D)
