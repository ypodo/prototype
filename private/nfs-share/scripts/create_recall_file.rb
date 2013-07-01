#!/usr/bin/env ruby
#create recall file

require 'fileutils'

unless ARGV.length == 5
  puts "Illegal number of arguments. Should be <ext_out> <invite_id> <user_id> <attempt> <event_id>..."
  exit
end

ext_out = ARGV[0]
invite_id = ARGV[1]
user_id = ARGV[2]
attempt = ARGV[3]
event_id = ARGV[4]

delay = 5 # default recall delay interval 

if !File.directory?(Dir.pwd+"/redial")
  puts "Creating redial directory for the first time"
  Dir.mkdir Dir.pwd+"/redial"
end

call_file = "redial/" + ext_out + "."+ invite_id + "." + user_id + "." + attempt + "." + event_id + ".call"

File.open(Dir.pwd+"/"+call_file, 'w') do |f| 
  f.write("Channel:IAX2/" + ext_out + "\n")    
  f.write("CallerID: mazminim"+ "\n")
  f.write("MaxRetries: 0 \n")
  f.write("RetryTime: 300 \n")
  f.write("WaitTime: 25 \n")
  f.write("Context: external \n")
  f.write("Extension:" + ext_out + "\n")
  f.write("Priority: 1 \n")
  f.write("Setvar: invite_id=" +invite_id+"\n")
  f.write("Setvar: user_id=" +user_id+"\n")
  f.write("Setvar: inviter=" +user_id+"\n")
  f.write("Setvar: ext_out=" + ext_out+"\n")
  f.write("Setvar: attempt=" + attempt +"\n")
  f.write("Setvar: event_id="+ event_id+"\n" )
  f.write("Archive: yes\n" )
  f.close()
end

if attempt == '2'
  delay = 5
elsif attempt == '3'
  delay = 10
elsif attempt == '4'
  delay = 20
else
  puts "wrong delay param"
  exit
end
puts "touching call file for + #{delay} "
`touch -d "#{delay} seconds" #{call_file}`

`mv #{call_file} /var/spool/asterisk/outgoing/`

