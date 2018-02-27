#!/bin/bash

set -e
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

jmeter $@
echo "`date`" >> /home/jmeteruser/$REPORTID.report.txt
