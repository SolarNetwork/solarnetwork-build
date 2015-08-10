#!/bin/sh

# Very basic script to collect memory and JVM statistics over time,
# designed to be run periodically via cron.
#
# The pidstat program is part of the sysstat package.

LOG=/var/log/memstat
PID_FILE=/dev/shm/solar/solarnode.pid
APP_LOG=/dev/shm/solar/log/solarnode.log
JSTDOUT=/dev/shm/solar/log/stdout.log

echo -e "\n==========\n`date`" >>$LOG
vmstat >>$LOG
pidstat -C java -r -u -s -h >>$LOG

echo >>$LOG
echo "SolarNode log:" >>$LOG
tail -10 $APP_LOG >>$LOG

pid=
run=
if [ -e $PID_FILE ]; then
	pid=`cat $PID_FILE`
	run=`ps -o pid= -p $pid`
fi
if [ -n "$run" ]; then
	kill -3 $pid
	sleep 5
	echo >>$LOG
	echo "JVM dump:" >>$LOG
	cat $JSTDOUT >>$LOG
	cat /dev/null >$JSTDOUT
	# or, if solarnode service started without 1>>$JSTDOUT
	#truncate -c -s 0 $JSTDOUT
else
	echo "SolarNode does not appear to be running." >>$LOG
fi
