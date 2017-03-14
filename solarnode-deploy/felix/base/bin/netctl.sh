#!/bin/sh
#
# Manage systemd-networkd device up/down status. Designed to be used
# for things like the SolarNode HTTP Ping Control. Add this script
# to the sudoers config for the solarnode user, then it can restart
# network devices in response to ping failures.

# function(device) to check status
do_status () {
	ip addr show dev $1
}

# function(device) to check status
do_stop () {
	ip link set down $1
	ip addr flush dev $1
}

do_netrestart() {
	systemctl restart systemd-networkd
}

# Print help
do_help () {
	echo "Usage: $0 {status|start|stop|restart} device" 1>&2
}

# Verify command arguments
ACTION="$1"
IFACE="$2"

if [ -z "$ACTION" -o -z "$IFACE" ]; then
	do_help
	exit 1
fi

# Parse command line parameters.
case $ACTION in
	status)
		do_status $IFACE
		;;

	start)
		do_netrestart
		;;

	stop)
		do_stop $IFACE
		;;

	restart)
		do_stop $IFACE
		sleep 1
		do_netrestart
		;;

	*)
		do_help
		exit 1
		;;
esac

exit 0
