#!/bin/bash
# #!/bin/sh

# averagereviews.sh

# Author: Milko Zlatev
# Processes raw data files to extract the average user rating of hotels

if [ $# = 0 ]; then
	echo "Usage: ./averagereviews.sh [file/directory]" # Define script use
	exit 0
fi 

ARGUMENT=$1

if [[ -d $ARGUMENT ]]; then
    for i in $ARGUMENT/*.dat
        do
		echo  "$(basename $i .dat) $(grep '<Overall>' $i | awk 'BEGIN{count=0;} {s+=substr($1,10); count++} END {printf "%5.2f", s/count}')"
	done | sort -k2nr
elif [[ -f $ARGUMENT ]]; then
    echo  "$(basename $ARGUMENT .dat) $(grep '<Overall>' $ARGUMENT | awk 'BEGIN{count=0;} {s+=substr($1,10); count++} END {printf "%5.2f", s/count}')"
fi

exit 0
