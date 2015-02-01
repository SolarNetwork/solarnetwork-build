#!/bin/sh

sudo apt-get update
sudo apt-get install -y xorg fluxbox
sudo apt-get install -y postgresql-9.3-plv8 git git-flow openjdk-7-jdk librxtx-java

if [ -e /usr/share/java/RXTXcomm.jar -a -d /usr/lib/jvm/java-7-openjdk-i386/jre/lib/ext \
		-a ! -e /usr/lib/jvm/java-7-openjdk-i386/jre/lib/ext/RXTXcomm.jar ]; then
	echo 'Linking RXTX JAR to JRE...'
	sudo ln -s /usr/share/java/RXTXcomm.jar \
		/usr/lib/jvm/java-7-openjdk-i386/jre/lib/ext/RXTXcomm.jar
fi

# Add the solardev user if it doesn't already exist, password solardev
getent passwd solardev >/dev/null
if [ $? -ne 0 ]; then
	echo 'Adding solardev user.'
	sudo useradd -c 'SolarNet Developer' -m -U solardev
	sudo sh -c 'echo "solardev:solardev" |chpasswd'
fi

grep -q solarnetworkdev /etc/hosts
if [ $? -ne 0 ]; then
	echo 'Setting up solarnetworknet.dev host'
	sed 's/^127.0.0.1 localhost$/127.0.0.1 solarnetworkdev.net localhost/' /etc/hosts >/tmp/hosts.new
	chmod 644 /tmp/hosts.new
	sudo chown root:root /tmp/hosts.new
	sudo cp -a /etc/hosts /etc/hosts.bak
	sudo mv -f /tmp/hosts.new /etc/hosts
fi

grep -q plv8.start_proc /etc/postgresql/9.3/main/postgresql.conf
if [ $? -ne 0 -a -e /etc/postgresql/9.3/main/postgresql.conf ]; then
	echo 'Configuring plv8 global procedure...'
	sudo sh -c "echo \"plv8.start_proc = 'plv8_startup'\" >> /etc/postgresql/9.3/main/postgresql.conf"
	sudo service postgresql restart
fi

sudo grep -q solarnet /etc/postgresql/9.3/main/pg_ident.conf
if [ $? -ne 0 ]; then
	echo 'Configuring Postgres solardev user mapping...'
	sudo sh -c "echo \"solarnet solardev solarnet\" >> /etc/postgresql/9.3/main/pg_ident.conf"
	sudo sh -c "echo \"solartest solardev solarnet_test\" >> /etc/postgresql/9.3/main/pg_ident.conf"
	sudo service postgresql restart
fi

sudo grep -q map=solarnet /etc/postgresql/9.3/main/pg_hba.conf
if [ $? -ne 0 -a -e /vagrant/pg_hba.sed ]; then
	echo 'Configuring Postgres SolarNetwork peer mapping...'
	sudo sh -c 'sed -f /vagrant/pg_hba.sed /etc/postgresql/9.3/main/pg_hba.conf > /etc/postgresql/9.3/main/pg_hba.conf.new'
	sudo chown postgres:postgres /etc/postgresql/9.3/main/pg_hba.conf.new
	sudo chmod 640 /etc/postgresql/9.3/main/pg_hba.conf.new
	sudo mv /etc/postgresql/9.3/main/pg_hba.conf /etc/postgresql/9.3/main/pg_hba.conf.bak
	sudo mv /etc/postgresql/9.3/main/pg_hba.conf.new /etc/postgresql/9.3/main/pg_hba.conf
	sudo service postgresql restart
fi

sudo -u postgres sh -c "psql -d solarnetwork -c 'SELECT now()'" >/dev/null 2>&1
if [ $? -ne 0 ]; then
	echo 'Creating SolarNetwork Postgres database...'
	sudo -u postgres createuser -AD solarnet
	sudo -u postgres psql -U postgres -d postgres -c "alter user solarnet with password 'solarnet';"
	sudo -u postgres createdb -E UNICODE -O solarnet solarnetwork
	sudo -u postgres createlang plv8 solarnetwork
fi

sudo -u postgres sh -c "psql -d solarnet_unittest -c 'SELECT now()'" >/dev/null 2>&1
if [ $? -ne 0 ]; then
	echo 'Creating SolarNetwork unit test Postgres database...'
	sudo -u postgres createuser -AD solarnet_test
	sudo -u postgres psql -U postgres -d postgres -c "alter user solarnet_test with password 'solarnet_test';"
	sudo -u postgres createdb -E UNICODE -O solarnet_test solarnet_unittest
	sudo -u postgres createlang plv8 solarnet_unittest
fi

if [ -x /vagrant/solardev.sh ]; then
	sudo -i -u solardev /vagrant/solardev.sh
fi
