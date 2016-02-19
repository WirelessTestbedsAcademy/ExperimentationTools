#
# Copyright 2012-2014 National ICT Australia (NICTA)
#
# This software may be used and distributed solely under the terms of
# the MIT license (License).  You should find a copy of the License in
# COPYING or at http://opensource.org/licenses/MIT. By downloading or
# using this software you accept the terms and the liability disclaimer
# in the License.
#
defApplication('iperf', 'iperf') do |app|

  app.description = %{Iperf is a traffic generator and bandwidth measurement
tool. It provides generators producing various forms of packet streams and port
for sending these packets via various transports, such as TCP and UDP.
  }
  app.binary_path = "/usr/bin/iperf-oml2"

  app.defProperty('interval', 'pause n seconds between periodic bandwidth reports', '-i',
                  :type => :int32, :unit => "second", :default => '1.')
  app.defProperty('len', 'set length read/write buffer to n (default 8 KB)', '-l',
                  :type => :int32, :unit => "KiBytes")
  app.defProperty('print_mss', 'print TCP maximum segment size (MTU - TCP/IP header)', '-m',
                  :type => :boolean)
  app.defProperty('output', 'output the report or error message to this specified file', '-o',
                  :type => :string)
  app.defProperty('port', 'set server port to listen on/connect to to n (default 5001)', '-p',
                  :type => :int32)
  app.defProperty('udp', 'use UDP rather than TCP', '-u',
                  :type => :boolean,
                  :order => 2)
  app.defProperty('window', 'TCP window size (socket buffer size)', '-w',
                  :type => :int32, :unit => "Bytes")
  app.defProperty('bind', 'bind to <host>, an interface or multicast address', '-B',
                  :type => :string)
  app.defProperty('compatibility', 'for use with older versions does not sent extra msgs', '-C',
                  :type => :boolean)
  app.defProperty('mss', 'set TCP maximum segment size (MTU - 40 bytes)', '-M',
                  :type => :int32, :unit => "Bytes")
  app.defProperty('nodelay', 'set TCP no delay, disabling Nagle\'s Algorithm', '-N',
                  :type => :boolean)
  app.defProperty('IPv6Version', 'set the domain to IPv6', '-V',
                  :type => :boolean)
  app.defProperty('reportexclude', 'exclude C(connection) D(data) M(multicast) S(settings) V(server) reports', '-x',
                  :type => :string, :unit => "[CDMSV]")
  app.defProperty('reportstyle', 'C or c for CSV report, O or o for OML', '-y',
                  :type => :string, :unit => "[CcOo]", :default => "o") # Use OML reporting by default

  app.defProperty('server', 'run in server mode', '-s',
                  :type => :boolean)

  app.defProperty('bandwidth', 'set target bandwidth to n bits/sec (default 1 Mbit/sec)', '-b',
                  :type => :string, :unit => "Mbps")
  app.defProperty('client', 'run in client mode, connecting to <host>', '-c',
                  :type => :string,
                  :order => 1)
  app.defProperty('dualtest', 'do a bidirectional test simultaneously', '-d',
                  :type => :boolean)
  app.defProperty('num', 'number of bytes to transmit (instead of -t)', '-n',
                  :type => :int32, :unit => "Bytes")
  app.defProperty('tradeoff', 'do a bidirectional test individually', '-r',
                  :type => :boolean)
  app.defProperty('time', 'time in seconds to transmit for (default 10 secs)', '-t',
                  :type => :int32, :unit => "second")
  app.defProperty('fileinput', 'input the data to be transmitted from a file', '-F',
                  :type => :string)
  app.defProperty('stdin', 'input the data to be transmitted from stdin', '-I',
                  :type => :boolean)
  app.defProperty('listenport', 'port to recieve bidirectional tests back on', '-L',
                  :type => :int32)
  app.defProperty('parallel', 'number of parallel client threads to run', '-P',
                  :type => :int32)
  app.defProperty('ttl', 'time-to-live, for multicast (default 1)', '-T',
                  :type => :int32,
                  :default => 1)
  app.defProperty('linux-congestion', 'set TCP congestion control algorithm (Linux only)', '-Z',
                  :type => :boolean)

  app.defMeasurement("application"){ |m|
    m.defMetric('pid', :guid,
                :description => 'Globally unique identifier of this Iperf instance')
    m.defMetric('version', :string,
                :description => 'Iperf version')
    m.defMetric('cmdline', :string,
                :description => 'Iperf invocation command line')
    m.defMetric('starttime_s', :int32, :unit => "second",
                :description => 'Time the application was received')
    m.defMetric('starttime_us', :int32, :unit => "microsecond",
                :description => 'Time the application was received')
  }

  app.defMeasurement("settings"){ |m|
    m.defMetric('pid', :guid,
                :description => 'Globally unique identifier of this Iperf instance')
    m.defMetric('server_mode', :int32, :unit => "[0-1]",
                :description => '1 if in server mode, 0 otherwise')
    m.defMetric('bind_address', :string,
                :description => 'Address to bind')
    m.defMetric('multicast', :int32,
                :description => '1 if listening to a Multicast group')
    m.defMetric('multicast_ttl', :int32, :unit => "nhops",
                :description => 'Multicast TTL if relevant')
    m.defMetric('transport_protocol', :int32, :unit => "IANA number",
                :description => 'Transport protocol')
    m.defMetric('window_size', :int32, :unit => "Byte",
                :description => 'TCP window size')
    m.defMetric('buffer_size', :int32, :unit => "Byte",
                :description => 'UDP buffer size')
  }

  app.defMeasurement("connection"){ |m|
    m.defMetric('pid', :guid,
                :description => 'Globally unique identifier of this Iperf instance')
    m.defMetric('connection_id', :guid,
                :description => 'Globally unique identifier of the connection')
    m.defMetric('local_address', :string,
                :description => 'Local network address')
    m.defMetric('local_port', :int32,
                :description => 'Local port')
    m.defMetric('remote_address', :string,
                :description => 'Remote network address')
    m.defMetric('remote_port', :int32,
                :description => 'Remote port')
  }

  app.defMeasurement("transfer"){ |m|
    m.defMetric('pid', :guid,
                :description => 'Globally unique identifier of this Iperf instance')
    m.defMetric('connection_id', :guid,
                :description => 'Globally unique identifier of the connection')
    m.defMetric('begin_interval', :double, :unit => "second",
                :description => 'Start of the averaging interval (Iperf timestamp)')
    m.defMetric('end_interval', :double, :unit => "second",
                :description => 'End of the averaging interval (Iperf timestamp)')
    m.defMetric('size', :long, :unit => "Byte",
                :description => 'Amount of transmitted data ')
  }

  app.defMeasurement("losses"){ |m|
    m.defMetric('pid', :guid,
                :description => 'Globally unique identifier of this Iperf instance')
    m.defMetric('connection_id', :guid,
                :description => 'Globally unique identifier of the connection')
    m.defMetric('begin_interval', :double,
                :description => 'Start of the averaging interval (Iperf timestamp)')
    m.defMetric('end_interval', :double, :unit => "second",
                :description => 'End of the averaging interval (Iperf timestamp)')
    m.defMetric('total_datagrams', :int32, :unit => "second",
                :description => 'Total number of datagrams')
    m.defMetric('lost_datagrams', :int32,
                :description => 'Number of lost datagrams')
  }

  app.defMeasurement("jitter"){ |m|
    m.defMetric('pid', :guid,
                :description => 'Globally unique identifier of this Iperf instance')
    m.defMetric('connection_id', :guid,
                :description => 'Globally unique identifier of the connection')
    m.defMetric('begin_interval', :double, :unit => "second",
                :description => 'Start of the averaging interval (Iperf timestamp)')
    m.defMetric('end_interval', :double, :unit => "second",
                :description => 'End of the averaging interval (Iperf timestamp)')
    m.defMetric('jitter', :double, :unit => "millisecond",
                :description => 'Average jitter')
  }

  app.defMeasurement("packets"){ |m|
    m.defMetric('pid', :guid,
                :description => 'Globally unique identifier of this Iperf instance')
    m.defMetric('connection_id', :guid,
                :description => 'Globally unique identifier of the connection')
    m.defMetric('packet_id', :int32,
                :description => 'Packet sequence number for datagram-oriented protocols')
    m.defMetric('packet_size', :int32, :unit => "Byte",
                :description => 'Packet size')
    m.defMetric('packet_time_s', :int32, :unit => "second",
                :description => 'Time the packet was processed')
    m.defMetric('packet_time_us', :int32, :unit => "microsecond",
                :description => 'Time the packet was processed')
    m.defMetric('packet_sent_time_s', :int32, :unit => "second",
                :description => 'Time the packet was sent for datagram-oriented protocols')
    m.defMetric('packet_sent_time_us', :int32, :unit => "microsecond",
                :description => 'Time the packet was sent for datagram-oriented protocols')
  }

end

# Local Variables:
# mode:ruby
# End:
# vim: ft=ruby:sw=2
