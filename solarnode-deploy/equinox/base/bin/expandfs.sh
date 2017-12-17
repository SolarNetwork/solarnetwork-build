#!/usr/bin/env bash

if [ ! `id -u` = 0 ]; then
	echo "You must be root to run this script."
	exit 3
fi

DRYRUN=0
VERBOSE=0
OLD_GEOM_FILE=/var/local/solarnode-expandfs.saved

while getopts ":no:v" opt; do
	case $opt in
		n) DRYRUN=1 ;;
		o) OLD_GEOM_FILE=$OPTARG ;;
		v) VERBOSE=1 ;;
	esac
done

shift $(($OPTIND - 1))

SOLARNODE_PART=`lsblk -npo kname,label |grep -i SOLARNODE |cut -d' ' -f 1`

if [ -z "$SOLARNODE_PART" ]; then
	echo "Error: SOLARNODE partition not discovered"
	exit 1
elif [ $VERBOSE = 1 ]; then
	echo "Discovered SOLARNODE partition ${SOLARNODE_PART}..."
fi

# get the device and partition number with the SOLARNODE label
SOLARNODE_DEV=
SOLARNODE_PART_NUM=
MMC_REGEX='(.*[0-9]+)p([0-9]+)'
SD_REGEX='(.*)([0-9]+)'
if [[ $SOLARNODE_PART =~ $MMC_REGEX ]]; then
	SOLARNODE_DEV=${BASH_REMATCH[1]}
	SOLARNODE_PART_NUM=${BASH_REMATCH[2]}
elif [[ $SOLARNODE_PART =~ $SD_REGEX ]]; then
	SOLARNODE_DEV=${BASH_REMATCH[1]}
	SOLARNODE_PART_NUM=${BASH_REMATCH[2]}
fi
if [ -z "$SOLARNODE_DEV" ]; then
	echo "Error: SOLARNODE device not discovered"
	exit 1
fi
if [ -z "$SOLARNODE_PART_NUM" ]; then
	echo "Error: SOLARNODE partition number not discovered"
	exit 1
fi

if [ $VERBOSE = 1 ]; then
	echo "Expanding ${SOLARNODE_DEV} partition ${SOLARNODE_PART_NUM}"
	echo "Saving recovery output to ${OLD_GEOM_FILE}..."
fi
if [ $DRYRUN = 1 ]; then
	echo ',+' |sfdisk ${SOLARNODE_DEV} -N${SOLARNODE_PART_NUM} --no-reread \
		-f -uS -q -n 2>/dev/null
else
	echo ',+' |sfdisk ${SOLARNODE_DEV} -N${SOLARNODE_PART_NUM} --no-reread \
		-f -uS -q -O "${OLD_GEOM_FILE}" 2>/dev/null
fi

# Inform the kernel of the partition change
if [ $VERBOSE = 1 ]; then
	echo -e "\nReloading partition table for ${SOLARNODE_DEV}..."
fi
if [ $DRYRUN = 1 ]; then
	echo "partx -u ${SOLARNODE_DEV}"
else
	partx -u ${SOLARNODE_DEV}
fi

# Resize the filesystem to use the entire partition
if [ $VERBOSE = 1 ]; then
	echo -e "\nExpanding filesystem on partition ${SOLARNODE_PART}..."
fi
if [ $DRYRUN = 1 ]; then
	echo "resize2fs ${SOLARNODE_PART}"
else
	resize2fs "${SOLARNODE_PART}"
fi
