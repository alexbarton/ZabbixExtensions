# Extensions for the Zabbix Monitoring Platform


## Installation

Install all components to the `/usr/local` hierarchy:

```
make all check
make install
```

Deploy files to a remote system:

```
./deploy.sh <host> [<host> [...]]
```

*Note:*
This requires `ssh`, `rsync` and access as user "root" (and "admin" on OS X,
the latter being the one running `zabbix_agentd` from Homebrew) on the target
system(s).


## References

- [Zabbix](http://www.zabbix.com): Home of Zabbix
- [Zabbix Share](https://share.zabbix.com): Zabbix templates, modules & more
