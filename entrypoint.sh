#!/bin/bash -x

# set -e

cd /home/jmeteruser

# This assumes using the Ubuntu derivative of the java:8 Docker image
echo "Pulling $JMETER_SCRIPT_S3_LOCATION"
/usr/local/bin/aws s3 cp $JMETER_SCRIPT_S3_LOCATION /home/jmeteruser/
JMETER_SCRIPT=$(basename "$JMETER_SCRIPT_S3_LOCATION")

# Pull the CSV data
echo "Pulling $JMETER_CSV_DATA_SCRIPT_S3_LOCATION"
/usr/local/bin/aws s3 cp $JMETER_CSV_DATA_SCRIPT_S3_LOCATION /home/jmeteruser/
JMETER_CSV_DATA=$(basename "$JMETER_CSV_DATA_SCRIPT_S3_LOCATION")

# Find sed
SED=`which sed`

# Update the script data for the host
$SED -i "s/%%HTTP_HOST%%/$JMETER_HTTP_HOST/g" /home/jmeteruser/$JMETER_SCRIPT

# Update the script data for the CSV file
$SED -i "s/%%HTTP_HOST%%/$JMETER_HTTP_HOST/g" /home/jmeteruser/$JMETER_SCRIPT

freeMem=`awk '/MemFree/ { print int($2/1024) }' /proc/meminfo`
s=$(($freeMem/10*8))
x=$(($freeMem/10*8))
n=$(($freeMem/10*2))
export JVM_ARGS="-Xmn${n}m -Xms${s}m -Xmx${x}m"

REPORT_FILE=/home/jmeteruser/$JMETER_RUN_ID.report.txt
touch $REPORT_FILE

START_TIME=`date +%Y-%m-%dT%H:%M:%S-04:00`
sleep 30s
echo "$START_TIME" >> $REPORT_FILE
echo "START Running Jmeter on `date`"
echo "JVM_ARGS=${JVM_ARGS}"
echo ""
echo "Using JMeter script ${JMETER_SCRIPT}"
echo "Using JMeter data file ${JMETER_CSV_DATA}"
echo ""
echo "Times logged in report /home/jmeteruser/$JMETER_RUN_ID.report.txt"
echo ""
echo "Testing host ${JMETER_HTTP_HOST}"

jmeter -n -t /home/jmeteruser/$JMETER_SCRIPT
sleep 30s

END_TIME=`date +%Y-%m-%dT%H:%M:%S-04:00`
echo "$END_TIME" >> $REPORT_FILE

exit 0
