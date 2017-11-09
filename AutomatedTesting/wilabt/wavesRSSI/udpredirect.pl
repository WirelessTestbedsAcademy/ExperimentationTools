#!/usr/bin/perl
use IO::Socket::INET;
use strict;
# flush after every write
$| = 1;

sub usage {
  print "Copyright IBCN-UGent-iMinds 2013: Author Bart Jooris for iLab.t @ 10 Feb 2013.\n";
  print "Usage $0 [-h host] -p port [-pci] [-pcp] [-d]\n";
  print "\t -p    If only a port is passed then a server socket is created.\n";
  print "\t       The port will be used at both ends of the udp socket.\n";
  print "\t -h    The host must be the name/ip of the server socket instance.\n";
  print "\t -pci  In server mode the client  IP  will be prefixed for every line.\n";
  print "\t -pcp  In server mode the client port will be prefixed for every line.\n";
  print "\t -d    Enables debugging line numbers.\n";
  print "\n";
  print "\t       Designed to have a cascade *->1 config:\n";
  print "\t       1) First *->1 is created by setting up a fifo on the host \n";
  print "\t          in scripts you can then redirect to this fifo. \n";
  print "\t                 mkfifo /tmp/collector1 \n";
  print "\t                 chmod 666 /tmp/collector1 \n";
  print "\t       2) Second *->1 is done by connectionless udp \n";
  print "\t          multiple clients will connect to 1 server, udp is used to \n";
  print "\t          reduce the overhead. ncat does not support connectionless udp! \n";
  exit;
}

sub increaseBufferSize {
	my $socket = shift;
	my $packed = $socket->getsockopt(SOL_SOCKET,SO_RCVBUF);
	my $mybuffer = unpack("I", $packed);
	my $myNewbuffer = $mybuffer *10;

	print "\n Buffer size : $mybuffer -> $myNewbuffer \n";
	#$socket->sockopt(SO_RCVBUF, $myNewbuffer);

	$packed = $socket->getsockopt(SOL_SOCKET,SO_SNDBUF);
	$mybuffer = unpack("I", $packed);
	print "\n Buffer size : $mybuffer \n";
}


my $serverAddress = "";
my $port = "";
my ($socket,$data);
my ($clientaddress,$clientport);
my $argID = 0;
my $prefixClientAddress = 0;
my $prefixClientPort = 0;
my $debug = 0;

while ($argID <= $#ARGV) {
	if ($ARGV[$argID] eq "-p") {
		$argID ++;
		$port = $ARGV[$argID];
	}
	elsif ($ARGV[$argID] eq "-h") {
		$argID ++;
		$serverAddress = $ARGV[$argID];
	}
	elsif ($ARGV[$argID] eq "-pci") {
		$prefixClientAddress = 1;
	}
	elsif ($ARGV[$argID] eq "-pcp") {
		$prefixClientPort = 1;
	}
	elsif ($ARGV[$argID] eq "-d") {
		$debug = 1;
	}
	else {
		usage();
	}
	$argID ++;
}

if ($port eq "") {
	usage();
}

if ($serverAddress eq "") {
	$socket = new IO::Socket::INET (
#		PeerAddr 	=> inet_ntoa(INADDR_BROADCAST),
#		PeerPort	=> $port,
		LocalPort	=> $port,
#		Broadcast 	=> 1, 
		Proto		=> 'udp')
	or
	die "ERROR in Server Socket Creation : $!\n";
}
else {
	$socket = new IO::Socket::INET (
		PeerAddr	=> $serverAddress,
		PeerPort	=> $port,
		LocalPort	=> $port,
		Proto		=> 'udp')
	or
	$socket = new IO::Socket::INET (
		PeerAddr	=> $serverAddress,
		PeerPort	=> $port,
		Proto		=> 'udp')
	or
	die "ERROR in Client Socket Creation : $!\n";
}

my $data2sock = "";
my $data2stdout = "";
my $m = 1;
my $n = 1;

#child process
if ($serverAddress eq "") {
	if (0 && (fork() == 0)) { # 0 && implies that this chunck will not be executed! As we don't know where to send it
		my $data;
		while (1) {
			while ($data2sock = <STDIN>) {
				#last if ($data2sock eq "");
				#send operation
				#print "$n $data2sock";
				if ($debug) {
					$data = "$m, $data2sock";
				} 
				else {
					$data = $data2sock; 
				}
				$socket->send("$data");
				$n++;
			}
		}
		exit;
	}	
}
else {
	if (0 && (fork() == 0)) {
		#read operation
		if ($serverAddress eq "") {
			while ($data2stdout = <$socket>) {
				if ($debug) {
					print "$m, ";
				} 
				print " $data2stdout";
				$m++;
			}
		}
		exit;
	}
}

if ($serverAddress eq "") {
	while(1) {
		# read operation on the socket
		$socket->recv($data2stdout,1024);
		#get the client host and port at which the recent data received.
		$clientaddress = $socket->peerhost();
		$clientport = $socket->peerport();
		if ($debug) {
			print "$m, ";
		} 
		if ($prefixClientAddress) {
			print "$clientaddress, ";
		}
		if ($prefixClientPort) {
			print "$clientport, ";
		}
		print "$data2stdout";
		$m++;
	}
}
else {
	my $data;
	while (1) {
		while ($data2sock = <STDIN>) {
			if ($debug) {
				$data = "$n, $data2sock";
			} 
			else {
				$data = $data2sock; 
			}
			$socket->send("$data");
			$n++;
		}
		sleep 5;
	}
}

$socket->close();
print "$0 stopped!\n";
