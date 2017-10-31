#!/bin/bash
export LC_ALL=C
PWD=`pwd`
HOSTNAME=`hostname`
EXP=`echo $HOSTNAME | cut -d '.' -f 2`
DATE=`date | sed -e 's/ /_/g'`

PRIGRP=`groups | awk '{print $1}'`
sudo adduser `whoami` dialout
newgrp dialout << EONG1
EONG1
newgrp $PRIGRP << EONG2
EONG2

CONTROLINT=ERROR
CONTROLIP=ERROR
HOST=ERROR
YEPKITID=ERROR
DEV=ERROR
DEVNAME=ERROR
TEMP=ERROR

function finalize()
{
	result=`printf "====%s, %s, %s, %s, %s, %s, %s, %s, %s ====\n" $CONTROLINT $CONTROLIP $HOST $YEPKITID $DEV $DEVNAME $TEMP $EXP $DATE`
	echo $result
	echo $result >> RESULTS/$HOST.$EXP
	exit 0
}


CONTROLINT=`route -n | awk '{print $4 " " $8}' | grep UG | awk '{print $2}'`
CONTROLIP=`ifconfig $CONTROLINT | grep 'inet addr' | awk '{print $2} ' | cut -d ':' -f 2` 
HOST=`dig +noall +answer -x $CONTROLIP | awk '{print $5}' | sed 's/\.$//'`

if [ -z "`dpkg -l | grep libhidapi-libusb0`" ]; then
	sudo /share/yepkit-USB-hub/missing-lib.sh
fi 
YEPKITID=`/share/yepkit-USB-hub/ykushcmd -l | grep Serial | awk '{print $7}'`
if [ -z $YEPKITID ]; then finalize; fi 
sudo /share/yepkit-USB-hub/ykushcmd -d 1
sudo /share/yepkit-USB-hub/ykushcmd -d 2
sudo /share/yepkit-USB-hub/ykushcmd -d 3
sudo /share/yepkit-USB-hub/ykushcmd -u 1
#sudo /share/yepkit-USB-hub/ykushcmd -u 2
#sudo /share/yepkit-USB-hub/ykushcmd -u 3

echo "will try motelist..."
sleep 1
DEV=`motelist -c | cut -d ',' -f 2`
DEVNAME=`motelist -c | cut -d ',' -f 1`
if [ -z $DEV ]; then finalize; fi 

sudo python cc2538-bsl.py -e -w -v -a 0x00202000 -p $DEV -i ab:cd:00:ff:fe:00:00:1 tempTest.bin
TEMP=`sudo timeout 3 ./serialdump-linux -b115200 $DEV | grep Temp | tail -n 1 | cut -f 3 -d ' '`
finalize
