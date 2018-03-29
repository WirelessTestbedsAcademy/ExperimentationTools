set autoscale xfix
#set xrange [0:*]
#set xrange [0:500]
#set yrange [-1:70]
set autoscale
plot	"plot.dat" using 1:2 title 'Current (mA)' with lines, \
	"plot.dat" using 1:3 title 'Voltage (dV)' with lines
pause 1
reread
