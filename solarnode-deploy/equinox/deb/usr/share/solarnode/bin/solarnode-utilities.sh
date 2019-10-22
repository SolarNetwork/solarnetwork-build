#!/bin/sh

# Utilities for managing the SolarNode server

SOLARNODE_HOME="/var/lib/solarnode"
SOLARNODE_SHARE="/usr/share/solarnode"
RAM_DIR="/run/solarnode"
CONF_DIR="/etc/solarnode"

TMP_DIR="${RAM_DIR}/tmp"
LOG_DIR="${RAM_DIR}/log"
DB_DIR="${RAM_DIR}/db"
VAR_DIR="${SOLARNODE_HOME}/var"
DB_BAK_DIR="${VAR_DIR}/db-bak"
EQUINOX_CONF="${RAM_DIR}"
SED_ESCAPE='s#[]\#$*.^[]#\\&#g'

##############################################################################
# equinox_reset_config
# 
# Clear the Equinox runtime config.ini
#
equinox_reset_config () {
	if [ -e ${EQUINOX_CONF}/config.ini ]; then
		rm ${EQUINOX_CONF}/config.ini
	fi
}

##############################################################################
# equinox_config_add_bundles conf add
#
# Add bundle start information to the `osgi.bundles` property in the Equinox
# config.ini file. Pass the path to the file as the first argument, and the
# literal text to add as the second argument. The text will only be added
# if it does not already exist.
#
equinox_config_add_bundles () {
	local conf_ini="$1"
	local ini_add="$2"
	local sed_esc=""
	if [ -e "$conf_ini" ]; then
		if ! grep -qF "$ini_add" "$conf_ini" >/dev/null 2>&1; then
			sed_esc=$(echo "$ini_add" |sed -e "$SED_ESCAPE")
			echo "Adding $ini_add to osgi.bundles in $conf_ini"
			sed -i -e '/osgi.bundles=/ s#$#'"$sed_esc"'#' "$conf_ini"
		fi
	fi
}

##############################################################################
# equinox_config_remove_bundles conf remove
#
# Remove bundle start information to the `osgi.bundles` property in the
# Equinox config.ini file. Pass the path to the file as the first argument,
# and the literal text to remove as the second argument. No change will be
# made if the text is not found in the configuration file.
#
equinox_config_remove_bundles () {
	local conf_ini="$1"
	local ini_rm="$2"
	local sed_esc=""
	if grep -qF "$ini_rm" "$conf_ini" >/dev/null 2>&1; then
		sed_esc=$(echo "$ini_rm" |sed -e "$SED_ESCAPE")
		echo "Removing $ini_rm from osgi.bundles in $conf_ini"
		sed -i -e "s#$sed_esc##g" "$conf_ini"
	fi
}

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
	if [ ! -e "${EQUINOX_CONF}/config.ini" -a -e "${SOLARNODE_HOME}/conf/config.ini" ]; then
		if [ -z "${RUNAS}" ]; then
			cp ${SOLARNODE_HOME}/conf/config.ini ${EQUINOX_CONF}
		else
			su - $RUNAS -c "cp ${SOLARNODE_HOME}/conf/config.ini ${EQUINOX_CONF}"
		fi
		if [ -d ${SOLARNODE_SHARE}/conf/config.ini.d ]; then
			for f in ${SOLARNODE_SHARE}/conf/config.ini.d/*.bundles; do
				# double-check in case there were NO .bundles files
				if [ -e "$f" ]; then
					b=$(cat "$f")
					equinox_config_add_bundles "${EQUINOX_CONF}/config.ini" "$b"
				fi
			done
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

# add/update the auto-settings.csv database from another CSV file
auto_settings_add () {
	local csv="$1"
	local auto="${CONF_DIR}/auto-settings.csv"
	if [ -e "$csv" ];then
		if [ ! -e "$auto" ]; then
			# file doesn't exist, so just copy this settings file directly
			echo "Copying auto settings $auto -> $csv"
			cp "$csv" "$auto"
		else
			# file exists, so either append or replace lines
			while IFS= read -r line; do
				local key="${line%,*,*,*}"
				if [ -n "$key" -a "$key" != 'key,type' ]; then
					if grep -q "^$key," "$auto"; then
						local currline="$(grep "^$key," "$auto")"
						if [ "$currline" != "$line" ]; then
							echo "Updating auto setting $key in $auto"
							sed -i -e "/^$key,/c $line" "$auto"
						fi
					else
						echo "Adding auto setting $key to $auto"
						echo "$line" >> "$auto"
					fi
				fi
			done < "$csv"
		fi
	fi
}

# remove settings from the auto-settings.csv database found in another CSV file
auto_settings_remove () {
	local csv="$1"
	local auto="${CONF_DIR}/auto-settings.csv"
	if [ -e "$csv" -a -e "$auto" ];then
		while IFS= read -r line; do
			local key="${line%,*,*,*}"
			if [ "$key" != 'key,type' ]; then
				if grep -q "^$key," "$auto"; then
					echo "Removing auto setting $key from $auto"
					sed -i -e "/^$key,/d" "$auto"
				fi
			fi
		done < "$csv"
	fi
}

# Parse command line parameters.
case $1 in
	auto-settings-add)
		auto_settings_add "$2"
		;;
		
	auto-settings-remove)
		auto_settings_remove "$2"
		;;
		
	equinox-bundles-add)
		if [ -z "$2" ]; then
			echo "Must provide bundle start configuration to add." 1>&2
		else
			equinox_config_add_bundles "${SOLARNODE_HOME}/conf/config.ini" "$2"
		fi
		;;
		
	equinox-bundles-remove)
		if [ -z "$2" ]; then
			echo "Must provide bundle start configuration to remove." 1>&2
		else
			equinox_config_remove_bundles "${SOLARNODE_HOME}/conf/config.ini" "$2"
		fi
		;;
	
	reset)
		equinox_reset_config
		;;
		
	setup)
		do_setup
		;;
		
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
		echo "Usage: $0 {auto-settings-add|auto-settings-remove|equinox-bundles-add|equinox-bundles-remove|reset|setup|start|stop}" 1>&2
		exit 1
		;;
esac

exit 0
