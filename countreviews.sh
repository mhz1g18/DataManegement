#!/bin/bash
# #!/bin/sh

# countreviews.sh

# Author: Milko Zlatev
# Processes raw data files to extract the number of reviews of hotels

if [ $# = 0 ]; then
	echo "Usage: ./countreviews.sh [file/directory]" # Define script use
	exit 0
fi 

ARGUMENT=$1

if [[ -d $ARGUMENT ]]; then
    for i in $ARGUMENT/*.dat
        do
	echo  "$(basename $i .dat) $(grep -o '<Author>' $i |  wc -l)"  
	done | sort -k2nr
elif [[ -f $ARGUMENT ]]; then
    grep -o '<Author>' $ARGUMENT | wc -l
fi

exit 0
