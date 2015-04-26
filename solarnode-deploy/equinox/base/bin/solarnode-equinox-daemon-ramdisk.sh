#!/bin/sh
### BEGIN INIT INFO
# Provides:          solarnode
# Required-Start:    $remote_fs $syslog
# Required-Stop:     $remote_fs $syslog
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: SolarNode daemon
# Description:       The SolarNode daemon is for collecting energy related
#                    data and uploading that to the central SolarNet service,
#                    as well as intelligently responding to "smart grid"
#                    events such as load shedding.
### END INIT INFO
# 
# SysV init script for the SolarNode daemon for Eclipse Equinox. Designed
# to be run as an /etc/init.d service by the root user. Uses deamon to 
# manage the server process (see http://libslack.org/daemon/). 
#
# chkconfig: 3456 99 01
# description: Control the SolarNode Equinox server
#
# Set JAVA_HOME to the path to your JDK or JRE.
# 
# Set SOLARNODE_HOME to the directory that contains the following:
# 
# + <SOLARNODE_HOME>/
# |
# +--+ conf/                      <-- configuration
# |  |
# |  +-- config.init              <-- main Equinox configuration
# |  +--+ services/               <-- runtime configuration
# |
# +--+ app/                      
#    |
#    +--+ boot/                   <-- OSGi bootstrap bundles
#    +--+ core/                   <-- Core OSGi bundles
#    +--+ main/                   <-- SolarNode OSGi bundles
#
#
# Set RUNAS to the name of the user to run the process as.
# 
# The application is expected to be configured such that the main
# database and log files are stored in an OS-configured RAM disk,
# such as /dev/shm. This script will use rsync when the "stop"
# command is used to sync the DB_DIR contents into DB_BAK_DIR.
# When the "start" command is used, this script checks for the 
# existence of DB_BAK_DIR and if DB_DIR does not exist, will copy
# DB_BAK_DIR to DB_DIR before starting up the application.
# 
# A typical RAM disk hierarchy looks like the following:
# 
# + <RAM_DISK>/
# |
# +--+ db/                        <-- Main database
# +--+ log/                       <-- Application logs
# 
# Modify the APP_ARGS and JVM_ARGS variables as necessary.

DAEMON=/usr/bin/daemon
JAVA_HOME=/usr
SOLARNODE_HOME=/home/solar
RAM_DIR=/run/shm/solar
RUNAS=solar

TMP_DIR=${RAM_DIR}/tmp
LOG_DIR=${RAM_DIR}/log
DB_DIR=${RAM_DIR}/db
VAR_DIR=${SOLARNODE_HOME}/var
DB_BAK_DIR=${VAR_DIR}/db-bak
EQUINOX_JAR=org.eclipse.osgi-3.8.2.v20130124-134944.jar
EQUINOX_CONF=${RAM_DIR}
EQUINOX_CONSOLE=4202
PID_FILE=${RAM_DIR}/solarnode.pid
APP_ARGS="-Dsn.home=${SOLARNODE_HOME} -Dderby.system.home=${DB_DIR}"
JVM_ARGS="-Xmx64m -Djava.io.tmpdir=${TMP_DIR}"

# NOTE: for debugging support, add these flags:
#JVM_ARGS="-Xdebug -Xnoagent -Xrunjdwp:server=y,transport=dt_socket,address=9142,suspend=n"

# NOTE: this supports Debian JNI, such as RXTX
if [ -d /usr/lib/jni ]; then
	JVM_ARGS="${JVM_ARGS} -Djava.library.path=/usr/lib/jni"
fi

# NOTE: this supports local JNI, such as YASDI
if [ -d ${SOLARNODE_HOME}/lib ]; then
	JVM_ARGS="${JVM_ARGS} -Djava.library.path=${SOLARNODE_HOME}/lib"
fi

JAVA_CMD="${JAVA_HOME}/bin/java ${JVM_ARGS} ${APP_ARGS} -jar ${SOLARNODE_HOME}/app/${EQUINOX_JAR} -configuration ${EQUINOX_CONF} -console ${EQUINOX_CONSOLE} -clean"
STOP_TRIES=5

DAEMON_NAME="SolarNode"
DAEMON_CMD="${DAEMON} --name=${DAEMON_NAME} --pidfile=${PID_FILE} --chdir=${SOLARNODE_HOME} --output=daemon.info --respawn --acceptable=20 --attempts=5 --delay=10"
if [ -n "${RUNAS}" ]; then
	DAEMON_CMD="${DAEMON_CMD} --user=${RUNAS}"
fi

# function to create directory if doesn't already exist
setup_dir () {
	if [ ! -e $1 ]; then
		if [ -z "${RUNAS}" ]; then
			mkdir $1
		else
			su - $RUNAS -c "mkdir -p $1"
		fi
	fi
}

# function to start process and wait for it to create pid file
start_proc () {
	count=$1
	while { [ $((count-=1)) -gt 0 -a ! -e $PID_FILE ]; } do
		${DAEMON_CMD} -- ${JAVA_CMD}
		sleep 1
	done
}

# function to stop process and wait for its pid file to be removed
stop_proc () {
	count=$1
	while { [ $((count-=1)) -gt 0 -a -e $PID_FILE ]; } do
		${DAEMON_CMD} --stop
		sleep 1
	done
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

# function to start up process
do_start () {
	if ! ${DAEMON_CMD} --running; then
		echo -n "Starting SolarNode server... "
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
		fi
		
		start_proc 2
		if [ -e $PID_FILE ]; then
			echo "Running as PID" `cat $PID_FILE`
		else
			echo "SolarNode does not appear to be running."
		fi
	else
		echo "SolarNode is already running (`cat $PID_FILE`)"
	fi
}

# function to stop process
do_stop () {
	if ${DAEMON_CMD} --running; then
		echo -n "Stopping SolarNode `cat $PID_FILE`... "
		stop_proc $STOP_TRIES
		# Backup DB to persistent storage if daemon stopped
		${DAEMON_CMD} --running
		if [ $? != 0 -a -e ${DB_DIR} ]; then
			echo -n "syncing database to backup dir... "
			setup_dir ${DB_BAK_DIR}
			rsync -am --delete ${DB_DIR}/* ${DB_BAK_DIR} 1>/dev/null 2>&1
		fi
		echo "done."
	else
		echo "SolarNode does not appear to be running."
	fi
}

# function to check status
do_status () {
 	if ${DAEMON_CMD} --running; then
 		echo "SolarNode is running (PID `cat $PID_FILE`)"
 	else
 		echo "SolarNode does not appear to be running."
 	fi
}

# Parse command line parameters.
case $1 in
	start)
		do_start
		;;

	status)
		do_status
		;;
	
	stop)
		do_stop
		;;

	*)
		# Print help
		echo "Usage: $0 {start|stop|status}" 1>&2
		exit 1
		;;
esac

exit 0


