#!/bin/sh

# Setup .xinitrc to launch Fluxbox
if [ ! -e ~/.xinitrc ]; then
	echo 'Configuring Fluxbox in .xinitrc...'
	echo "exec startfluxbox" > ~/.xinitrc
fi

# Setup X to start on console login
grep -q xinit ~/.bashrc
if [ $? -ne 0 ]; then
	echo 'Configuring X to start on login...'
	cat >> ~/.bashrc <<"EOF"

if [ -z "$DISPLAY" ] && [ "$(tty)" = "/dev/tty1" ]; then
	exec /usr/bin/xinit -- -nolisten tcp
fi
EOF
fi

# Setup Eclipse
eclipseDownload=/var/tmp/eclipse.tgz
eclipseDownloadMD5=7385aaff4872800153ebc90d8c92e707
eclipseDownloadHash=
if [ -e "$eclipseDownload" ]; then
	eclipseDownloadHash=`md5sum $eclipseDownload |cut -d' ' -f1`
fi
if [ "$eclipseDownloadHash" != "$eclipseDownloadMD5" ]; then
	echo 'Downloading Eclipse Luna...'
	#wget -c -O $eclipseDownload -nv http://mirrors.ibiblio.org/eclipse/technology/epp/downloads/release/luna/SR1a/eclipse-jee-luna-SR1a-linux-gtk.tar.gz
	curl -C - -s -S -o $eclipseDownload http://mirrors.ibiblio.org/eclipse/technology/epp/downloads/release/luna/SR1a/eclipse-jee-luna-SR1a-linux-gtk.tar.gz
fi
if [ -e "$eclipseDownload" ]; then
	eclipseDownloadHash=`md5sum $eclipseDownload |cut -d' ' -f1`
fi
if [ ! -d ~/eclipse -a -e "$eclipseDownload" ]; then
	if [ "$eclipseDownloadHash" = "$eclipseDownloadMD5" ]; then
		echo "Installing Eclipse Luna..."
		tar -C ~/ -xzf "$eclipseDownload"
	else
		echo 'Eclipse Luna not completely downloaded, cannot install.'
	fi
fi

# Install EGit
# ls -1d ~/eclipse/features/org.eclipse.egit* >/dev/null 2>&1
# if [ $? -ne 0 -a -x ~/eclipse/eclipse ]; then
# 	echo 'Installing EGit...'
# 	~/eclipse/eclipse -application org.eclipse.equinox.p2.director \
# 		-repository http://download.eclipse.org/releases/luna \
# 		-installIU org.eclipse.egit.feature.group \
# 		-tag AddEGit \
# 		-destination ~/eclipse/ -profile SDKProfile
# fi

# Checkout SolarNetwork sources
for proj in build external common central node; do
	if [ ! -d ~/git/solarnetwork-$proj ]; then
		echo "Cloning project solarnetwork-$proj..."
		mkdir -p ~/git/solarnetwork-$proj
		git clone "https://github.com/SolarNetwork/solarnetwork-$proj.git" ~/git/solarnetwork-$proj
		cd ~/git/solarnetwork-$proj
		git checkout -b develop origin/develop
	fi
done

cd ~

# Setup standard setup files
if [ ! -d ~/git/solarnetwork-build/solarnetwork-osgi-target/config ]; then
	echo 'Creating solarnetwork-build/solarnetwork-osgi-target/config files...'
	cp -a ~/git/solarnetwork-build/solarnetwork-osgi-target/example/config ~/git/solarnetwork-build/solarnetwork-osgi-target/
	
	# Enable the SolarIn SSL connector in tomcat-server.xml
	sed -e '9s/$/-->/' -e '16d' ~/git/solarnetwork-build/solarnetwork-osgi-target/example/config/tomcat-server.xml \
		> ~/git/solarnetwork-build/solarnetwork-osgi-target/config/tomcat-server.xml
fi

if [ ! -e ~/git/solarnetwork-build/solarnetwork-osgi-target/configurations/services/net.solarnetwork.central.dao.jdbc.cfg ]; then
	echo 'Creating JDBC configuration...'
	cat > ~/git/solarnetwork-build/solarnetwork-osgi-target/configurations/services/net.solarnetwork.central.dao.jdbc.cfg <<-EOF
		jdbc.driver = org.postgresql.Driver
		jdbc.url = jdbc:postgresql://localhost:5432/solarnetwork
		jdbc.user = solarnet
		jdbc.pass = solarnet
EOF
fi

if [ ! -e ~/git/solarnetwork-build/solarnetwork-osgi-target/configurations/services/net.solarnetwork.central.in.cfg ]; then
	echo 'Creating developer SolarIn configuration...'
	cat > ~/git/solarnetwork-build/solarnetwork-osgi-target/configurations/services/net.solarnetwork.central.in.cfg <<-EOF
		SimpleNetworkIdentityBiz.host = solarnetworkdev.net
		SimpleNetworkIdentityBiz.port = 8683
		SimpleNetworkIdentityBiz.forceTLS = true
EOF
fi

if [ ! -e ~/git/solarnetwork-build/solarnetwork-osgi-target/configurations/services/net.solarnetwork.central.user.biz.dao.DaoRegistrationBiz.cfg ]; then
	echo 'Creating developer X.509 subject pattern...'
	cat > ~/git/solarnetwork-build/solarnetwork-osgi-target/configurations/services/net.solarnetwork.central.user.biz.dao.DaoRegistrationBiz.cfg <<-EOF
		networkCertificateSubjectDNFormat = UID=%s,O=SolarDev
EOF
fi

if [ ! -e ~/git/solarnetwork-external/net.solarnetwork.org.apache.log4j.config/log4j.properties ]; then
	echo 'Creating platform logging configuration...'
	cp ~/git/solarnetwork-external/net.solarnetwork.org.apache.log4j.config/example/log4j.properties \
		~/git/solarnetwork-external/net.solarnetwork.org.apache.log4j.config/log4j.properties
fi

if [ ! -e ~/git/solarnetwork-external/net.solarnetwork.org.apache.log4j.config/log4j.properties ]; then
	echo 'Creating platform logging configuration...'
	cp ~/git/solarnetwork-external/net.solarnetwork.org.apache.log4j.config/example/log4j.properties \
		~/git/solarnetwork-external/net.solarnetwork.org.apache.log4j.config/log4j.properties
fi

if [ ! -e ~/git/solarnetwork-common/net.solarnetwork.common.test/environment/local/log4j.properties ]; then
	echo 'Creating common unit test configuration...'
	cp ~/git/solarnetwork-common/net.solarnetwork.common.test/environment/example/* \
		~/git/solarnetwork-common/net.solarnetwork.common.test/environment/local/
fi

if [ ! -e ~/git/solarnetwork-central/net.solarnetwork.central.test/environment/local/log4j.properties ]; then
	echo 'Creating SolarNet unit test configuration...'
	cp ~/git/solarnetwork-central/net.solarnetwork.central.test/environment/example/* \
		~/git/solarnetwork-central/net.solarnetwork.central.test/environment/local/
fi

if [ ! -e ~/git/solarnetwork-node/net.solarnetwork.node.test/environment/local/log4j.properties ]; then
	echo 'Creating SolarNode unit test configuration...'
	cp ~/git/solarnetwork-node/net.solarnetwork.node.test/environment/example/* \
		~/git/solarnetwork-node/net.solarnetwork.node.test/environment/local/
fi

psql -d solarnetwork -U solarnet -c 'select count(*) from solarnet.sn_node' >/dev/null 2>&1
if [ $? -ne 0 ]; then
	echo 'Creating solarnet database tables...'
	cd ~/git/solarnetwork-central/net.solarnetwork.central.datum/defs/sql/postgres
	# for some reason, plv8 often chokes on the inline comments, so strip them out
	sed -e '/^\/\*/d' -e '/^ \*/d' postgres-init-plv8.sql |psql -d solarnetwork -U solarnet
	psql -d solarnetwork -U solarnet -f postgres-init.sql
fi

psql -d solarnet_unittest -U solarnet_test -c 'select count(*) from solarnet.sn_node' >/dev/null 2>&1
if [ $? -ne 0 ]; then
	echo 'Creating solarnet_unittest database tables...'
	cd ~/git/solarnetwork-central/net.solarnetwork.central.datum/defs/sql/postgres
	# for some reason, plv8 often chokes on the inline comments, so strip them out
	sed -e '/^\/\*/d' -e '/^ \*/d' postgres-init-plv8.sql |psql -d solarnet_unittest -U solarnet_test
	psql -d solarnet_unittest -U solarnet_test -f postgres-init.sql
fi
