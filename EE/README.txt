========
HoWTo EE
========

/dev/ee (to be confirmed every time you connect your device!)
-------------------------------------------------------------
all scripts reference to /dev/ee
If your EE device gets this dev path /dev/ttyUSB1.
Please execute:

	sudo ln -s /dev/ttyUSB1 /dev/ee

From now on you can connect to the /dev/ee.

Confirm the EE firmware (only when you got a new EE, or your EE is not responding).
-----------------------------------------------------------------------------------
Please execute:
	./tos-bsl --invert-reset --swap-reset-test -c /dev/ee -r -e -I -p main.ihex

verify dialout group
--------------------
To add your username to the dialout group
please execute:
	sudo adduser `whoami` dialout

Reason: on a Debian based OS the EE will be owned by the user root and the group dialout.
Please verify with executing:

	ls -al /dev/ee.

You need to relogin to have the rights of the dialout group!

run the EE service
-------------------
Please execute:
	./connectEE
Keep this service running and open a new terminal for the next steps.
If the EE is not responding please stop and start this service again.


use the EE service
------------------

write_to_ee.rb can generate EE compatible messages (described in packetlayoutEE.rb) towards the connectEE service.
An example of how to use it can be found in the oedl1.sh
Before every line with signature "echo..... | ./write_to_ee.rb", there should be a line that starts with echo to describes every step.

example scenario
----------------
please have a look at the oedl1.sh to investigate the scenario. While running connectEE will dump the samples (voltage and current) to plot.dat.
In the background gnuplot will make a live graph of the samples.
After the scenario you need to hit <enter> to stop the oedl1.sh and gnuplot.

Please execute:
	./oed1.sh


Please contact me if you have more questions: bart.jooris@ugent.be 
