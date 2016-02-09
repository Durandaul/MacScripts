#!/bin/bash
# A script that interrogates the airport application and outputs it in JSON format.
# Currently tested on El Capitan (11.11.+).  
# Steps:
#  1) Create a temporary file
#  2) Remove the leading characters before the colon in each line
#  3) Take the temporary file data and assign it to variables
#  4) Remove the temporary file
#  5) For each variable, echo it into a file that will be title wfReport(ProcessID).json
#  6) Exit


function cleanUpReports()
{
# A function to remove extra reports. 
rm -v "wfReport"????\.json
}

function gatherInfo(){
# Create the temporary file 
/System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport -I > wifi$$.tmp
DATA=$(cat "wifi$$.tmp" | cut -d":" -f2)
}

function createVars()
{
# Create a variable for each output from the temp file
# Each variable is formatted to be a JSON string with quotes included between the colons. Each quote needs to be escaped to allow for partial string and variable expansion
# NOTE: DO NOT REPLACE DOUBLE QUOTES WITH SINGLE QUOTES. Otherwise your output will be literally "$1" instead of the 1st variable of the list


agrCTLRSSI="\"agrCtlRSSI\" : \"$1\"," 
agrExtRSSI="\"agrExtRSSI\": \"$2\","
agrCtlNoise="\"agrCtlNoise\": \"$3\","
agrExtNoise="\"agrExtNois\": \"$4\","
State="\"state\": \"$5\","
OpMode="\"op mode\": \"$6\"," 
lastTxRate="\"lastTxRate\":\"$7\","
maxRate="\"maxRate\":\"$8\","
lastAssocStatus="\"lastAssocStatus\": \"$9\","
Eight0211auth="\"802.11 auth\": \"$10\","
linkAuth="\"link auth\": \"$11\","
BSSID="\"BSSID\": \"$12\","
SSID="\"SSID\": \"$13\","
MCS="\"MCS\": \"$14\","
CHANNEL="\"channel\": \"15\""

}

function createReport()
{
  #Create a report with the process ID as part of the name and output the valid json format
  #
  fName="wfReport$$.json"
  touch "$fName"
  echo "{\"Report\":{ "> $fName
  echo -n "$agrCTLRSSI" >> $fName
  echo "$argExtRSSI" >> $fName
  echo "$agrCtlNoise" >> $fName
  echo "$agrExtNoise" >> $fName
  echo "$State" >> $fName
  echo "$OpMode" >> $fName
  echo "$lastTxRate" >> $fName
  echo "$maxRate" >> $fName
  echo "$lastAssocStatus" >> $fName
  echo "$Eight0211auth" >> $fName
  echo "$linkAuth" >> $fName
  echo "$BSSID" >> $fName
  echo "$SSID" >> $fName
  echo "$MCS" >> $fName
  echo "$CHANNEL" >> $fName
  echo "}  }">> $fName
  
}
vars="$@"
function flagCheck()
{
  for line in "$vars"
    do
     [[ $line =~ '-c' ]] && cleanUpReports 
     [[ $line =~ '-v' ]] && echo "verbose mode! How talkative!"
    done
}

function main()
{
# Main loop 
flagCheck
gatherInfo 
createVars $DATA
rm "wifi$$.tmp"
createReport

}

main $*
