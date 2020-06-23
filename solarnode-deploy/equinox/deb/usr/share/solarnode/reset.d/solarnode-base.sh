#!/usr/bin/env sh
#
# Reset SolarNode application.

# stop SolarNode
systemctl stop solarnode

# remove transient data
rm -rf /run/solarnode/*

# remove persisted data
rm -rf /var/lib/solarnode/var

# remove identity
rm -rf /etc/solarnode/identity.json
rm -rf /etc/solarnode/tls/node.jks

# start SolarNode again
systemctl start solarnode
