#!/bin/bash

sqlFile="hotelreviews.sql" # sql file name
table="HotelReviews" # table name
ARGUMENT=$1 # The target folder
 
if [ $# = 0 ] || [ -f $ARGUMENT ]; then
	echo "Usage: ./ex10.sh [directory]" # Define script use
	exit 0
fi 

# Remove hotelreviews.sql if it already exists
if [ -f $sqlFile ]; then
	rm $sqlFile	
fi

# Adjust some SQLite parameters to more easily check the table 
echo ".headers ON" >> $sqlFile
echo ".mode columns" >> $sqlFile
echo "DROP TABLE IF EXISTS $table;" >> $sqlFile # Delete the table if it already exists

# SQL Query to create the table
echo "CREATE TABLE $table(hotel_id integer, ovr_rating real, avg_price real, 
url text, author_id integer, author text, content text, date real, no_read integer, no_help integer, overall integer, 
value integer, rooms integer, location integer, cleanliness integer, checkin integer, 
service integer, business integer, PRIMARY KEY (hotel_id, author_id, date));" >> $sqlFile

# Loop through the .dat files in the specified directory
for i in $ARGUMENT/*.dat
do
	hotel_id=$(basename $i .dat| cut -d'_' -f 2)
	ovr_rating=$(grep '<Overall Rating>' $i | cut -d'>' -f 2)
	avg_price=$(grep '<Avg. Price>' $i | cut -d'$' -f2)
	url=$(grep '<URL>' $i | cut -d'>' -f2)
	echo "Parsing $i"
	
	sed -i '/img src/d' $i
	#echo ""
	sed -i '/div class=/d' $i

	
	#echo "INSERT INTO $table VALUES($hotel_id, $ovr_rating, $avg_price, '$url', $authorid ,'$1', '$3', '$5', $7, $9, $11, $13, $15, $17, $19, $21, $23, $25);" >> $sqlFile
	#tr '\n' ' ' <$i | awk 'BEGIN{authorid=0; RS="<Author>"; FS="<|>"; OFS=",";} {gsub("\'", "\'\'", $5); print $5} { if (NR > 1) print $1,$3,$5,$7,$9,$11,$13,$15,$17,$19,$21,$23, $25;  }' >> $sqlFile
	tr '\n' ' ' <$i | awk -v table="$table" -v hotel="$hotel_id" -v ovr="$ovr_rating", -v avg="$avg_price", -v url="$url" 'BEGIN{authorid=0; RS="<Author>"; FS="<|>"; OFS=",";} 
	{gsub("\047", "\047\047", $3);} { if (NR > 1) print "INSERT INTO " table " VALUES (" hotel, ovr avg "\"" url "\"", authorid , "\"" $1 "\"", "\"" $3 "\"", "\"" $5 "\"", $7, $9, $11, $13 ,$15 , $17, $19, $21, $23, $25 ");" ;  } { authorid++;}' >> $sqlFile
	
	
done
