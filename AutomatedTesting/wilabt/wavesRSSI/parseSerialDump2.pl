#!/usr/bin/perl
use strict;
use warnings;
use DBI;

#insta output to stdout
$| = 1;
#some vars parsed from cmd ln param 
my $myHost = shift || 'localhost';
my $myDev = shift || '/dev/ttyUSB0';
my $myDBHost = shift || 'localhost';
my $myDBPort = shift || '3306';
my $myDatabase = shift || 'wavesrssi';
my $myDBuser = shift || 'wavesrssi';
my $myDBpassword = shift || 'wavesrssi';
my $myTable = shift || 'wavesrssi';

my $dsn = "DBI:mysql:database=$myDatabase;host=$myDBHost;port=$myDBPort";
my $dbh = DBI->connect($dsn, $myDBuser, $myDBpassword);
my $sth = $dbh->prepare(
	"INSERT INTO  $myTable (node, radio, mcs, txAddr, rssi, lqi) VALUES ('$myHost',?,?,?,?,?)" )
        or die "prepare statement failed: $dbh->errstr()";

my $cmd = qq{./serialdump-linux -b115200 $myDev 2>&1};

open(CMD, "$cmd |")  or die "Cannot run $cmd\n"; 
while (my $line = <CMD>) {
	if ($line =~ /WAVES/) {
		my @field = split(/,/, $line);
		 $sth->execute($field[1], $field[2], $field[3], $field[4], $field[5]) or die "execution failed: $dbh->errstr()";
		#my $values = "$myHost, $field[1], $field[2], $field[3], $field[4], $field[5]"; 
		#print "$values"; 
	}
}
print $sth->rows . " rows found.\n";
#while (my $ref = $sth->fetchrow_hashref()) {
#	print "Found a row: id = $ref->{'id'}, fn = $ref->{'first_name'}\n";
#}
$sth->finish;

