#!/usr/bin/ruby

######################################################
# Author: vincent.sercu@intec.ugent.be
# Date: 30-apr-2012
# Version: 0.3beta
#
# Feel free to modify this script according to your needs.
######################################################

require 'socket'
# dynamicly include packetlayout file.
begin 
  if ARGV[0].nil?
    require File.join(File.dirname(__FILE__), "packetlayoutEE.rb")
  else
    require File.join(File.dirname(__FILE__), "#{ARGV[0]}")
  end
rescue Exception=>e
  puts "Error, invalid packet-layout file specified or no packetlayout.rb file found in script dir.\nUsage: #{$0} packetlayoutfile.rb"
  puts "#{e}"
end

#----------------
# constants
HOSTNAME = 'localhost'
SERVPORT = 10003

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
        'nx_uint64_t'   => 'Q', # TODO untested, also its not big endian... ----- Q> is big endian but only in ruby 1.9.3
        'nx_int16_t'    => 's',
        'char'    => 'A',       # single byte, convert to character -- removing trailing nulls ('a' to keep)
]
# calculates the byte-size of a 2-dim array: name / datatype
def size(ary)
  c = 0
  ary.each{ |elem|
    case Datatype[elem[1]]
    when 'Q' then c += 8
    when 'N1' , 'V' then c += 4
    when 'n1' , 'v', 's' then c += 2
    when 'C' , 'A'  then c += 1
    else
      puts "WARN: size calculation: unknown type #{elem[1]} (-> #{Datatype[elem[1]]}), #{elem.inspect}, #{Datatype[elem[1]].inspect}"
    end
  }
  c
end

#----------------

# sends a bitstring to the wrapper
def send_to_wrapper(bitstring)
  begin
    socket = TCPSocket.open(HOSTNAME, SERVPORT)
    puts "Connected to #{HOSTNAME}:#{SERVPORT}."

    socket.write(bitstring)

    socket.close
  rescue => err
    puts "Send failed, exception caught: #{err}"
  end
end


# waits for data on STDIN, parses the fields and constructs a packet accordingly
# stdin should be formatted like:
# msgnameA{field1=0x1, field2=3, field3='a'} [space(s)|tab] msgnameB{f=>3}
# -> fields have to be the SAME name as in the packetlayout file
# -> if no default value is specified for a field, it is required to be on STDIN
# Example: "Ackpacket{msgt_am=10, len=1, type=1, sender=0, seqno=4}"
while line=STDIN.gets()
  line.gsub!(/\t|[ ]+/, "") # remove spaces

  line.scan(/(.*?)\{(.*?)\}/).each { |packettype,params|  # begin parsing packets and their fieldvalues

    messageArgs = Hash.new()
    msgbin = Array[]
    msgpack = ""

    # fill the hash using user parameters
    params.split(/,\s?/).each { |i|       # parse commandline args,
      i.scan(/(.*)=>?(.*)/) { |key,val|   # each , is new key/val pair
        if val.start_with? "0x"           # is hex data?
          messageArgs[key.strip] = eval(val)
        else
          messageArgs[key.strip] = val.strip # put it in hash
        end
      }
    }

    puts "User values are: #{messageArgs.inspect}."

    # construct binary packetstring
    begin
      ptype = eval(packettype)         # fancy: fetch the array with the name inside the packettype variable
      raise "'#{packettype}' is not an array, check declaration in packet-layout file." unless ptype.is_a? Array

      if ptype.take(6) == eval('Msgt') # are the first 6 fields like the Msgt-predef array?
        messageArgs[ptype[3][0]] = size(ptype - eval('Msgt')) # put size of <actual data> into args (e.g. key="msgt_len") to fill the msgt-length field
      end

      # for each element in the array, check the corresponding value in msgh-hash
      ptype.each { |packet_field|                # [0: name, 1: datatype, 2: def value]
        if messageArgs[packet_field[0]].nil?     # not specified on STDIN by user
          if packet_field[2].nil?                # does it have default value?
            raise "#{packet_field[0]} expected, but not specified."
          else                                  # take pre-defined, default value
            #puts "pushing #{packet_field[0]} -- #{packet_field[2]} (default)"

            packet_field[1].start_with?('char') ? msgbin.push(packet_field[2]) : msgbin.push(packet_field[2].to_i) # convert to int unless its a char
            msgpack << "#{Datatype[packet_field[1]]} "
          end
        else                                    # append user value to bytestring
          #puts "pushing #{packet_field[0]} -- #{messageArgs[packet_field[0]]}"
        
          packet_field[1].start_with?('char') ? msgbin.push(messageArgs[packet_field[0]]) : msgbin.push(messageArgs[packet_field[0]].to_i) # convert to int unless its a char
          msgpack << "#{Datatype[packet_field[1]]} "
        end
      }

      # convert array to binary
      puts "Packing #{msgbin.inspect} with #{msgpack.inspect} and sending!"
      puts "#{msgbin.pack(msgpack)}"

      # append first byte: length of everything that follows (tinyOS-sf)
      send_to_wrapper([size(ptype)].pack('C') << msgbin.pack(msgpack))
    
    rescue => err
      puts "Exception while constructing binairy packetstring:\n#{err}"
    end

  } # end .each for packet|params
end
