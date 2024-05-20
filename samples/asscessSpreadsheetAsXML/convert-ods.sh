#!/bin/bash 
 INPUT_FILE=/home/mickeyw/Xtra/Data/NameAge6.ods
 OUTPUT_FILE=/home/mickeyw/Xtra/Data/ConvertedToXML
  soffice --headless --convert-to xml --outdir $OUTPUT_FILE $INPUT_FILE

 echo "We done playing now" 

