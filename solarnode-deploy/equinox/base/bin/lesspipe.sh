#!/bin/sh
# preprocessor for less(1); invoked via env: LESSOPEN='|lesspipe.sh %s'

case "$1" in
	*.tar)
		# Handle tar archive:
		echo "==== Directory of archive '$1':"
		tar -tvf "$1"
		;;
	
	*.tar.gz|*.tgz)
		# Handle compressed tar archive:
		echo "==== Directory of archive '$1':"
		tar -tzvf "$1"
		;;
	
	*.gz|*.[zZ])
		# Handle other compressed files.
		# gunzip can read .gz, .z, and .Z formats:
		gunzip -c "$1"
		;;
esac
