#!/bin/bash
stat=($(</proc/$$/stat))    # create an array
ppid=${stat[3]}
logfile=/tmp/RSSIserver
echo "New run current PID:$$ and parent PID:$ppid" >> $logfile
while read data; do
	TIMESTAMP=`date '+%y_%h_%d-%H_%M_%S_%N'`
	echo "$TIMESTAMP, $data" >> /tmp/RSSIserver
	#exit -1
done
#echo "over and out"

