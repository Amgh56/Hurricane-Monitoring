#!/bin/bash
# A condition check the number of arguments $# passed if it is not 
# two then it print a message 

if [ "$#" -ne 2 ]; then
    echo "Usage: $0 input_path.kml output_path.csv"
    exit 1
fi

# Assign the input and output files 
inputFile="$1" 
outputFile="$2" 


# This to write as a header to the outputFile
echo "Timestamp,Latitude,Longitude,MinSeaLevelPressure,MaxIntensity" > "$outputFile"

# The paste command is used here to merge the lines together and seperate it with commas
# And i used afterwards the grep and sed to extract the wanted data and assigin them with the units
paste -d ',' \
  <(grep -oP '<dtg>\K[^<]+' "$inputFile") \
  <(grep -oP '<lat>\K[^<]+' "$inputFile" | sed 's/$/ N/') \
  <(grep -oP '<lon>\K[^<]+' "$inputFile" | sed 's/$/ W/') \
  <(grep -oP '<minSeaLevelPres>\K[^<]+' "$inputFile" | sed 's/$/ mb/') \
  <(grep -oP '<intensity>\K[^<]+' "$inputFile" | sed 's/$/ knots/') \
  >> "$outputFile"

echo "Done"

