#!/usr/bin/perl
use strict;
use warnings;

$| = 1;
my $myHost = shift || 'localhost';
my $myDev = shift || '/dev/ttyUSB0';

my $cmd = qq{./serialdump-linux -b115200 $myDev 2>&1};
open(CMD, "$cmd |")  or die "Cannot run $cmd\n"; 
while (my $line = <CMD>) {
	if ($line =~ /WAVES/) {
		my @field = split(/,/, $line);
		my $values = "$myHost, $field[1], $field[2], $field[3], $field[4]"; 
		print "$values"; 
	}
}

