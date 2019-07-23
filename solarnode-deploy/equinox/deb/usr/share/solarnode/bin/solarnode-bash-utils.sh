#!/bin/bash

# provide hook to load in shell utilities from directory files
if [ -d /usr/share/solarnode/bash-utils.d ]; then
	for f in $(ls -1 /usr/share/solarnode/bash-utils.d/*.sh 2>/dev/null); do
		. "$f"
	done
fi

sn-home () {
	echo '/var/lib/solarnode'
}

sn-log-path () {
	echo '/run/solarnode/log/solarnode.log'
}

sn-log-tail () {
	tail "$@" $(sn-log-path)
}

sn-ctl () {
	sudo systemctl "$1" solarnode
}

sn-stop () {
	sn-ctl stop
}

sn-start () {
	sn-ctl start
}

sn-restart () {
	sn-ctl restart
}

sn-status () {
	sn-ctl status
}
