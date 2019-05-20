#!/bin/bash

sn-log-path() {
	echo /run/solarnode/log/solarnode.log
}

sn-log-tail() {
	tail "$@" `sn-log-path`
}

sn-ctl() {
	sudo systemctl $1 solarnode
}

sn-stop() {
	sn-ctl stop
}

sn-start() {
	sn-ctl start
}

sn-restart() {
	sn-ctl restart
}

sn-status() {
	sn-ctl status
}
