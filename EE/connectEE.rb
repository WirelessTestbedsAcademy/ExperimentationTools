#!/usr/bin/ruby

# Author: vincent.sercu@intec.ugent.be

######################################################

APPID = 'sf'
OMLSERVER = 'am.wilab2.ilabt.iminds.be'
HOSTNAME = 'localhost'
PORT = 9003
DEVICE = '/dev/ee' # TESTBED WILAB2 IS USB1!!! usb0 there is EE
BAUDRATE = 230400       # baudrate for EE
#SFEXEC = '/opt/tinyos-2.1.1/support/sdk/c/sf/sf'
SFEXEC = './sf'

LISTENPORT = 10003

$EEreportCnt=0
$lastTimestamp = 0

########################################################################################
## WARNING: WATCH OUT FOR DUPLICATE NAMES!! => OML WILL CRASH ON CREATING TABLE IN DB
require File.join(File.dirname(__FILE__), 'packetlayoutEE.rb')
########################################################################################

########## do not change anything after this #########

require 'socket'      # Sockets are in standard library
#require "/usr/share/liboml2-dev/oml4r.rb"
#require "/var/lib/gems/1.8/gems/oml4r-2.9.1/lib/oml4r.rb"
#require "./oml4r.rb"
require 'thread'
require 'time'

#require "/usr/share/omf-common-5.4/omf-common/mobject.rb"


# The different datatypes possible/allowed.
# They are converted to template-strings that are interpretable by Ruby's .pack function
# See http://ruby-doc.org/core-1.9.3/Array.html#method-i-pack for more details
Datatype = Hash[
        'nx_uint32_t' => "N1",  # big-endian 32 bit integer
        'nx_uint16_t' => "n1",  # nx_struct, which is a network format, that is, big-endian (!) and byte-aligned
        'uint8_t' => 'C',       # single char, 1 byte
        'nx_uint8_t' => 'C',
        'nx_bool' => 'C',       # TODO test this.................
        'nxle_uint16_t' => 'v', # TODO untested
        'nxle_uint32_t' => 'V', # TODO untested
        'nx_uint64_t'   => 'Q', # TODO untested, also its not big endian... ----- Q>
#        'nx_int16_t'    => 's',
        'nx_int16_t'    => 'v',
        'char'    => 'A',       # single byte, convert to character -- removing trailing nulls ('a' to keep)
]

##
# Maps 'type' to the actual template string used by Ruby's .pack function using the Datatype hash
##
def translate(type)
    number = type.scan(/\[(\d+)\]/).flatten     # possible array
    if number.empty?
        return "#{Datatype[type]}"
    else
        t = type.scan(/(.*)\[/) # everyting before []
        return "#{Datatype[t.flatten[0]]}#{number[0]}"
    end
end

Msgid_packstr = "a#{Msgid_offset} #{Datatype[Msgid_datatype]}" # ruby's pack method


##### FACTORY ######
# check if a class exists, returns true if it does
def class_exists?(class_name)
  klass = Module.const_get(class_name)
  return klass.is_a?(Class)
rescue NameError
  return false
end

#
# The class creating class (fancy!)
# - Each created class inherits from the MPBase OML-class.
#
class MPBaseClassFactory
    # this is where the magic happens:
    def self.create_class(new_class, nam, params)
        c = Class.new OML4R::MPBase do                      # create new class c that extends MPBase
            name :"#{nam}"                                  # call MPBase method name with symbol
  
            params.each { |par|                             # for each param, call MPBase method param with :ParName and type = string, int32, double
                if par[1].start_with?('char')
                    param :"#{par[0]}"                      # default type is string
                else
                    param :"#{par[0]}", :type => :int32      # type set to int32 (long is deprecated)
                end
           }
        end

        Kernel.const_set new_class, c                       # so that you can new_class-param now becomes a reference to this class
    end
end

#### /factory

#
# Inserts the packet using the AM address to determine the correct OML-class
# - using the class naming convention
#
def insertOML(pkt, am)
    if class_exists?("AM_#{am}")
        pkt[-1].gsub!(/[\n]/, '~') if am == 100 && pkt[-1].is_a?(String) # TODO maybe fix this quick and dirty solution because AFAIK oml does not insert text after \n so we'll replace it by a tilde ~

        klasse = Kernel.const_get("AM_#{am}")
        klasse.send(:inject, *pkt)

        if AM[am].count != pkt.count
            puts Time.new.strftime("%Y-%m-%d %H:%M:%S") + " Warning: unparsed fields remain (requested #{AM[am].count} but got #{pkt.count})."
        else
            #puts "Done " + pkt.join(" ")
        end
    else
        puts Time.new.strftime("%Y-%m-%d %H:%M:%S") + " No class available for AM=#{am} -- ignoring packet"
    end
end

#
# Splits a packet (bytestring) in an array using an AM address
# - AM address determines the data that comes into an array-cell
#
def unpack(packet, am)
    layout = AM[am]          			# map the correct layout-array to this AM addr

    if layout.nil?
        #puts  Time.new.strftime("%Y-%m-%d %H:%M:%S") + "No layoutclass for msg_identifier=#{am}"
        return nil
    end

    fields = 0
    packstr = ""

    layout.each { |i|
        packstr += translate(i[1]) + ' ' # 2nd column in two dim array is the corresponding pack-directive
        fields += 1
    }  
    
    arr = packet.unpack(packstr+"H*")   # split it into an array of int-values (each 8bits = 1 byte value (0-255))
    if arr[fields] != ""    			# if the H* gets matched
        puts  Time.new.strftime("%Y-%m-%d %H:%M:%S") + "Warning: unparsed data remains: #{arr[fields]} -- for layout: #{packstr}"
    else
        arr.pop 						# remove the last field (that is "" when H* is matched to <nothing left>)
    end

    arr
end


def grabAvgCurrVolt(packet, am, plotdat)
    layout = AM[am]          			# map the correct layout-array to this AM addr

    if layout.nil?
        #puts  Time.new.strftime("%Y-%m-%d %H:%M:%S") + "No layoutclass for msg_identifier=#{am}"
        return nil
    end

    fields = 0
    packstr = ""

    layout.each { |i|
        packstr += translate(i[1]) + ' ' # 2nd column in two dim array is the corresponding pack-directive
        fields += 1
    }  
    
    arr = packet.unpack(packstr+"H*")   # split it into an array of int-values (each 8bits = 1 byte value (0-255))
    if arr[fields] != ""    			# if the H* gets matched
        puts  Time.new.strftime("%Y-%m-%d %H:%M:%S") + "Warning: unparsed data remains: #{arr[fields]} -- for layout: #{packstr}"
    else
        arr.pop 						# remove the last field (that is "" when H* is matched to <nothing left>)
    end
	sampleID = 0
	
	#if arr[7] == 0 
	#	$EEreportCnt = 0
	#end
	
	now = Time.now.to_i
	if 	 now - 1 > $lastTimestamp
		$EEreportCnt = 0
	end
	$lastTimestamp = now
	
	while sampleID < 64  do
		plotdat.puts "#{$EEreportCnt+sampleID} #{((arr[27+sampleID]*70)/4095).round(3)} #{((arr[11+sampleID/4.floor] *34.8)/4095).round(3)}"
		sampleID +=1
	end
	
	$EEreportCnt +=64
end


#
# Receives bytes from a socket located at hostname:port
# - also unpacks the packets & inserts them into OML
#
def recvAndInsert(plotdat)
    while len = $sf.recv(1)       				# packet of 1 byte: the length of the packet that is next
        len = len.unpack('C')[0]    			# convert it to decimal
        print "recv'ing #{len.to_s} bytes.\n"
        packet = $sf.recv(len)            		# get the next packet that is as big as the value in the prev packet

		#puts packet.unpack("H*")[0].scan(/../).join(" ")

        am = packet.unpack(Msgid_packstr)[1]     # get the message-id, 2nd element in array (first element are either unrelevant bytes or empty in case that the message starts with the id)
		#puts unpack(packet, am)
		grabAvgCurrVolt(packet, am, plotdat)
        #insertOML(unpack(packet, am), am)
    end

    $sf.close               						# Close the socket when done
	puts "Recv. stopped"
end

#
# Initialize: create a class for each AM-type and set up the OML service
# - Each created follows following naming convention: prefix "AM_", suffix <AMID>
#
def initOML(layoutHash) 
    layoutHash.each { |am, layoutarray| # create an OML-class for each AM type
        if not class_exists?("AM_#{am}")
            MPBaseClassFactory.create_class("AM_#{am}", "sfdata_am#{am}", layoutarray)
        else
            throw "Class #{am} already exists, it shouldn't..."
        end
    }

    # FIRST create the classes, THEN init OML4R! Important!
    OML4R::init(nil, { :appName => APPID, :omlServer => OMLSERVER,
                           #:expID => 'sfwrap3', :nodeID => 'n1', :omlFile => "lokaal.db" ## TESTing purposes
    } )
end

#
# Listens to a socket and forwards every packet that comes to the SF
# 
#
def forward_to_sf()
    server = TCPServer.open(LISTENPORT) # Socket to listen on port
    loop {                              # Servers run forever
      client = server.accept            # Wait for a client to connect
      #puts Time.new.strftime("%Y-%m-%d %H:%M:%S") + "*** Client (#{client}) connected. ***"
      while ! client.eof?
        r = client.read(1)
        len = r.unpack('C')[0]          # fetch length and parse
        packet = client.read(len)       # read whole packet

        full = r << packet
        $sf.write(full)  # forward packet to sf

        puts Time.new.strftime("%Y-%m-%d %H:%M:%S") + " WRITE (#{len} bytes): [#{full.unpack("H*").to_s.scan(/../).join(' ')}] ==> serial"
      end
      #puts Time.new.strftime("%Y-%m-%d %H:%M:%S") + "*** Client (#{client}) disconnected. ***"
    }
end

#
# Main()
#
#class Logtest < MObject
#        def Logtest.log
# MObject.initLog('nodeAgent', nil, {:configFile => '/etc/omf-resctl-5.3/omf-resctl_log.xml'})
# MObject.info "yoooooooooooo"

#        end
#end


begin
    puts "Executing SF-wrapper"
    puts "Packetformats are: "

	AM.each { | amaddr, pktlay |
		puts amaddr.to_s +  "\t" + pktlay.map { |x| x.inspect }.join(" ") + "\n "
	}

    #initOML(AM)    # first create all classes that extend MPBase
 
    Thread.abort_on_exception = true

    sfthrd = Thread.new { 
        `#{SFEXEC} #{PORT} #{DEVICE} #{BAUDRATE}`
    }
    sleep 2

    if sfthrd.alive?; puts "SF Started in background (#{sfthrd})."
    else; puts "Failed to start SF thread..."; end
    
    $sf = TCPSocket.open(HOSTNAME, PORT)

    # make connection with the SF, send handshake
    handshake = 'U '
    $sf.write(handshake)
    line = $sf.recv(1024)   				        # Read lines from the socket
    puts "Connected to sf @ #{HOSTNAME}:#{PORT}."

	#Logtest.log

    fwdthrd = Thread.new {
        forward_to_sf()
    }
    puts "Listening to #{LISTENPORT} and forwarding the data to sf."

=begin # Unit TEST
    5.times { |i| insertOML([0, 65535, 0, 8, 0, 204, 2, 0, 4, 35 + i], 204)   }
    5.times { |i| insertOML([0, 65535, 0, 8, 0, 204, 2 + i], 205)  }
    insertOML([0, 65535, 0, 8, 0, 204], 200)
    insertOML([0, 65535, 0, 8, 0, 100, "abc\ndef\n\n\nghi"], 100)
=end
	#File.new("plot.dat", "w+")
	File.open("plot.dat", "w+") do |plotdat|
		plotdat.sync = true
		recvAndInsert(plotdat) # blocks here
	end


#rescue Exception => ex
 #   puts "ERR: #{ex}\n"
end


