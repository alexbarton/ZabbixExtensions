#!/bin/sh

BASE_DIR=$(dirname "$0")
DEST_DIR="/usr/local/etc/zabbix/zabbix_agentd.conf.d"
ZABBIX_AGENT_OSX="/usr/local/sbin/zabbix_agentd"

# Include "ax-common.sh":
for dir in "$HOME/lib" "$HOME/.ax" /usr/local /opt/ax /usr; do
	[ -z "$ax_common_sourced" ] || break
	ax_common="${dir}/lib/ax/ax-common.sh"
	[ -r "$ax_common" ] && . "$ax_common"
done
if [ -z "$ax_common_sourced" ]; then
	ax_msg() {
		shift
		echo "$@"
	}
fi
unset dir ax_common ax_common_sourced

ax_msg - "Building project ..."
make all check || exit 1
echo

restart_agent() {
	echo "Restarting Zabbix agent ..."
	ssh root@$1 "chmod -R a+rX '$DEST_DIR'; service zabbix-agent restart"
	result=$?
	if [ $result -ne 0 ]; then
		# Try OS X (Homebrew) variant
		ssh root@$1 "su - admin -c 'pkill zabbix_agentd; $ZABBIX_AGENT_OSX'"
		result=$?
	fi
	if [ $result -eq 0 ]; then
		ax_msg 0 "Ok, agent restarted."
		return 0
	fi
	ax_msg 2 "FAILED to restart agent (code $result)!"
	return 1
}

refresh_sudo() {
	echo "Fixing sudo configuration file permissions ..."
	ssh root@$1 "chown 0:0 /etc/sudoers.d/zabbix-extensions; chmod 440 /etc/sudoers.d/zabbix-extensions"
	result=$?
	if [ $result -eq 0 ]; then
		ax_msg 0 "Ok, permissions fixed."
		return 0
	fi
	ax_msg 2 "FAILED to fix sudo configuration permissions (code $result)!"
	return 1
}

for host in "$@"; do
	ax_msg - "$host ..."

	ssh root@$host mkdir -p /usr/local/etc/zabbix/zabbix_agentd.conf.d

	# Zabbix agent configuration
	out=$(rsync -rt --delete --log-format=%f -e ssh --exclude Makefile \
	 "$BASE_DIR/etc/zabbix_agentd.conf.d/" \
	 "root@$host:$DEST_DIR"
	)
	if [ $? -eq 0 ]; then
		changes=$(printf "%s" "$out" | wc -c)
		if [ $changes -gt 0 ]; then
			ax_msg 1 "Ok, updated Zabbix configuration."
			restart_agent "$host"
		else
			ax_msg 0 "Ok, no changes for Zabbix configuration."
		fi
	else
		ax_msg 2 "Failed to sync Zabbix configuration to $host!"
	fi

	# sudo configuration
	out=$(rsync -t --log-format=%f -e ssh \
	 "$BASE_DIR/etc/sudoers.d/zabbix-extensions" \
	 "root@$host:/etc/sudoers.d/zabbix-extensions"
	)
	if [ $? -eq 0 ]; then
		changes=$(printf "%s" "$out" | wc -c)
		if [ $changes -gt 0 ]; then
			ax_msg 1 "Ok, updated sudo configuration."
			refresh_sudo "$host"
		else
			ax_msg 0 "Ok, no for sudo configuration."
		fi
	else
		ax_msg 2 "Failed to sync sudo configuration to $host!"
	fi

	echo
done
