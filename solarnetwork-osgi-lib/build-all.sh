#!/bin/sh

ANT_OPTS=""

function usage () {
	echo "Usage: $0 [-D <ant opt>] target file1 ..."
}

while getopts ":D:" opt; do
	case $opt in
		D) 
			ANT_OPTS="${ANT_OPTS} ${OPTARG}"
			;;
		
		\?)
			usage
			exit 1
	esac
done

shift $(($OPTIND - 1))

if [[ -z "$2" ]]; then
	usage
fi

TARGET="$1"

shift 1

for fileName; do
	echo "Building project $fileName..."
	if [ -e "$fileName/ivy.xml" ]; then
		ant -f $fileName $ANT_OPTS $TARGET
	fi
done
