#!/usr/bin/env sh
#
# Reset SolarNode application.

# stop SolarNode
systemctl stop solarnode

# remove transient data
echo 'Removing SolarNode transient data...'
rm -rf /run/solarnode/*

# remove persisted data
echo 'Removing SolarNode persistent data...'
rm -rf /var/lib/solarnode/var/*

# remove identity
echo 'Removing SolarNode identity...'
rm -f /etc/solarnode/identity.json
rm -f /etc/solarnode/tls/node.jks

# start SolarNode again
systemctl start solarnode
