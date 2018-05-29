Always:
-----------

check/guess which /dev/ttyUSBx device is the EE
execute:
sudo ln -fs /dev/ttyUSBX /dev/ee

Initially
---------
So only the first time you use this toolkit you need to flash the EE
./tos-bsl --invert-reset --swap-reset-test -c /dev/ee -r -e -I -p main.ihex
Install gnuplot 

I have:
dpkg -l | grep gnuplot
ii  gnuplot                                       4.6.6-3                                      all          Command-line driven interactive plotting program
ii  gnuplot-tex                                   4.6.6-3                                      all          Command-line driven interactive plotting program. Tex-files
ii  gnuplot5-data                                 5.0.3+dfsg2-1                                all          Command-line driven interactive plotting program. Data-files
ii  gnuplot5-qt                                   5.0.3+dfsg2-1                                amd64        Command-line driven interactive plotting program. QT-package


Current measurement
------------------
open two terminals:
1st terminal: ./connectEE
2nd terminal: ./oedl.sh 
Gnuplot is greedy with the foucs of your windows manager

I you don't get a fresh, please repeat cmds for terminal 1 and 2
