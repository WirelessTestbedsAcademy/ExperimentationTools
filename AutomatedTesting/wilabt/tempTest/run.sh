#!/bin/bash
export LC_ALL=C
PWD=`pwd`
MYDIR=`dirname $0`
echo will switch from $PWD to $MYDIR
cd $MYDIR
HOSTNAME=`hostname`
EXP=`echo $HOSTNAME | cut -d '.' -f 2`
DATE=`date | sed -e 's/ /_/g'`

sudo adduser `whoami` dialout
groups

CONTROLINT=ERROR
CONTROLIP=ERROR
HOST=ERROR
YEPKITID=ERROR
DEV=ERROR
DEVNAME=ERROR
TEMP=ERROR

CONTROLINT=`route -n | awk '{print $4 " " $8}' | grep UG | awk '{print $2}'`
CONTROLIP=`ifconfig $CONTROLINT | grep 'inet addr' | awk '{print $2} ' | cut -d ':' -f 2` 
HOST=`dig +noall +answer -x $CONTROLIP | awk '{print $5}' | sed 's/\.$//'`

if [ ! -e RESULTS ]; then
	mkdir -p RESULTS
fi

function finalize()
{
	result=`printf "=====%s, %s, %s, %s, %s, %s, %s, %s, %s =====\n" $CONTROLINT $CONTROLIP $HOST $YEPKITID $DEV $DEVNAME $TEMP $EXP $DATE`
	echo $result
	if [ ! -z "`echo $result | grep ERROR`" ]; then
		echo ERROR
	fi
	echo $result >> RESULTS/$HOST.$EXP
	sudo deluser `whoami` dialout
	exit 0
}

if [ -z "`dpkg -l | grep libhidapi-libusb0`" ]; then
	sudo /share/yepkit-USB-hub/missing-lib.sh
fi 

YEPKITID=`/share/yepkit-USB-hub/ykushcmd -l | grep Serial | awk '{print $7}'`
if [ -z $YEPKITID ]; then
	YEPKITID=ERROR
	finalize
fi
 
sudo /share/yepkit-USB-hub/ykushcmd -d 1
sudo /share/yepkit-USB-hub/ykushcmd -d 2
sudo /share/yepkit-USB-hub/ykushcmd -d 3
sudo /share/yepkit-USB-hub/ykushcmd -u 1
#sudo /share/yepkit-USB-hub/ykushcmd -u 2
#sudo /share/yepkit-USB-hub/ykushcmd -u 3

echo "will try motelist..."
sleep 1
DEV=`motelist -c | tail -n 1 | grep '/dev/' | cut -d ',' -f 2`
if [ -z $DEV ]; then 
	DEV=ERROR
	finalize
fi 
DEVNAME=`motelist -c | cut -d ',' -f 1`

which sg
ls -la /bin/sh
WAI=`sg dialout whoami`
echo WAI $WAI
ls -la
chmod a+x serialdump-linux

sg dialout "python cc2538-bsl.py -e -w -v -a 0x00202000 -p $DEV -i ab:cd:00:ff:fe:00:00:1 tempTest.bin 2>&1"
sg dialout "timeout 3 ./serialdump-linux -b115200 $DEV 2>&1"
TEMP=`sg dialout "timeout 3 ./serialdump-linux -b115200 $DEV | grep Temp | tail -n 1 | cut -f 3 -d ' '"`
echo "TEMP = $TEMP"

if [ -z "${TEMP##*[!0-9]*}" ]; then 
	TEMP=ERROR
fi
finalize

