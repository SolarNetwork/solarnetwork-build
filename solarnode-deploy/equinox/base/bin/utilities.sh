#!/bin/sh

# Utilities for managing the SolarNode server

SOLARNODE_HOME=/home/solar
RAM_DIR=/run/solar

TMP_DIR=${RAM_DIR}/tmp
LOG_DIR=${RAM_DIR}/log
DB_DIR=${RAM_DIR}/db
VAR_DIR=${SOLARNODE_HOME}/var
DB_BAK_DIR=${VAR_DIR}/db-bak
EQUINOX_JAR=org.eclipse.osgi-3.8.2.v20130124-134944.jar
EQUINOX_CONF=${RAM_DIR}


# function to create directory if doesn't already exist
setup_dir () {
	if [ ! -e $1 ]; then
		if [ -z "${RUNAS}" ]; then
			mkdir -p $1
		else
			su - $RUNAS -c "mkdir -p $1"
		fi
	fi
}

#function to copy the conf/config.ini into EQUINOX_CONF
setup_ini () {
	if [ ! -e "${EQUINOX_CONF}/config.ini" ]; then
		if [ -z "${RUNAS}" ]; then
			cp ${SOLARNODE_HOME}/conf/config.ini ${EQUINOX_CONF}
		else
			su - $RUNAS -c "cp ${SOLARNODE_HOME}/conf/config.ini ${EQUINOX_CONF}"
		fi
	fi
}

do_setup () {
	# Verify ram dir exists; create if necessary
	setup_dir ${RAM_DIR}
	
	# Verify tmp dir exists; create if necessary
	setup_dir ${TMP_DIR}
	
	# Verify log dir exists; create if necessary
	setup_dir ${LOG_DIR}
	
	# Verify var dir exists; create if necessary
	setup_dir ${VAR_DIR}
	
	# Copy config.ini into Equinox configuration dir
	setup_ini
	
	# Check to restore backup database
	if [ ! -e ${DB_DIR} -a -e ${DB_BAK_DIR} ]; then
		echo -n "restoring database... "
		cp -a ${DB_BAK_DIR} ${DB_DIR}
		echo "restored."
	fi
}

do_sync () {
	# Backup DB to persistent storage if daemon stopped
	if [ -e ${DB_DIR} ]; then
		echo -n "syncing database to backup dir... "
		setup_dir ${DB_BAK_DIR}
		rsync -am --delete ${DB_DIR}/* ${DB_BAK_DIR} 1>/dev/null 2>&1
		echo "done."
	fi
}

# Parse command line parameters.
case $1 in
	start)
		do_setup
		;;

	stop)
		exit_status=`systemctl show solarnode.service --no-pager |grep ExecMainStatus |cut -d= -f2`
		if [ $exit_status -eq 0 -o $exit_status -eq 143 ]; then
			do_sync
		else
			echo "Database NOT synced to backup dir after error exit status ($exit_status)."
		fi
		;;

	*)
		# Print help
		echo "Usage: $0 {start|stop}" 1>&2
		exit 1
		;;
esac

exit 0
