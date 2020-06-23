#!/usr/bin/env sh
#
# Reset SolarNode application.

# stop SolarNode
systemctl stop solarnode

echo 'Removing SolarNode configuration and data...'

# remove transient data
rm -vrf /run/solarnode/*

# remove persisted data
rm -vrf /var/lib/solarnode/var

# remove identity
rm -vf /etc/solarnode/identity.json
rm -vf /etc/solarnode/tls/node.jks

# start SolarNode again
systemctl start solarnode
