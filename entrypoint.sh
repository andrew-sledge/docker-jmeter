#!/bin/bash

set -e

# This assumes using the Ubuntu derivative of the java:8 Docker image
echo "Pulling $JMETER_SCRIPT_S3_LOCATION"
/usr/local/bin/aws s3 cp $JMETER_SCRIPT_S3_LOCATION /home/jmeteruser/
JMETER_SCRIPT=$(basename "$JMETER_SCRIPT_S3_LOCATION")

# Pull the CSV data
echo "Pulling $JMETER_CSV_DATA_SCRIPT_S3_LOCATION"
/usr/local/bin/aws s3 cp $JMETER_CSV_DATA_SCRIPT_S3_LOCATION /home/jmeteruser/
JMETER_CSV_DATA=$(basename "$JMETER_CSV_DATA_SCRIPT_S3_LOCATION")

# Update the script data for the host
/usr/bin/sed -i "s/%%HTTP_HOST%%/$JMETER_HTTP_HOST/g" /home/jmeteruser/$JMETER_SCRIPT

# Update the script data for the CSV file
/usr/bin/sed -i "s/%%HTTP_HOST%%/$JMETER_HTTP_HOST/g" /home/jmeteruser/$JMETER_SCRIPT

freeMem=`awk '/MemFree/ { print int($2/1024) }' /proc/meminfo`
s=$(($freeMem/10*8))
x=$(($freeMem/10*8))
n=$(($freeMem/10*2))
export JVM_ARGS="-Xmn${n}m -Xms${s}m -Xmx${x}m"

# Create report ID
REPORTID=`head /dev/urandom | tr -dc A-Za-z0-9 | head -c 13 ; echo ''`

echo "`date`" >> /home/jmeteruser/$REPORTID.report.txt

echo "START Running Jmeter on `date`"
echo "JVM_ARGS=${JVM_ARGS}"
echo "jmeter args=$@"
echo ""
echo "Using JMeter script ${JMETER_SCRIPT}"
echo "Using JMeter data file ${JMETER_CSV_DATA}"
echo ""
echo "Testing host ${JMETER_HTTP_HOST}"

jmeter -n -t /home/jmeteruser/$JMETER_SCRIPT
echo "`date`" >> /home/jmeteruser/$REPORTID.report.txt
