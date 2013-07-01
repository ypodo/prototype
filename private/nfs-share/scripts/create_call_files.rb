#!/usr/bin/env ruby

require 'fileutils'
#path="/var/www/prototype/private/nfs-share/"
path="/home/ubuntu/Documents/prototype/private/nfs-share/"

user_id = ARGV[0]
attempt = ARGV[1]
event_id = ARGV[2]

if !File.directory?(path+user_id+"/call")
  Dir.mkdir path+user_id+"/call"
else
  FileUtils.rm Dir.glob path+user_id+"/call/*"
end
data=File.open path+user_id+"/phonenumbers.txt"

data.each do |elem|
  elem=elem.gsub(/\n/,"")
  File.open(path+user_id+"/call/"+elem.split(":")[0]+"."+ attempt + ".missing-id.call", 'w') do |f| 
    f.write("Channel:SIP/"+elem.split(":")[0] +"\n")    
    f.write("CallerID: mazminim"+ "\n")
    f.write("MaxRetries: 0 \n")
    f.write("RetryTime: 300 \n")
    f.write("WaitTime: 20 \n")
    f.write("Context: external \n")
    f.write("Extension:"+ elem.split(":")[0] +"\n")
    f.write("Priority: 1 \n")
    f.write("Setvar: invite_id="+elem.split(":")[1]+"\n" )
    f.write("Setvar: user_id="+user_id+"\n" )
    f.write("Setvar: inviter="+user_id+"\n" )
    f.write("Setvar: ext_out="+ elem.split(":")[0] +"\n" )
    f.write("Setvar: attempt=1\n" )
    f.write("Setvar: event_id="+event_id+"\n" )
    f.write("Archive: yes\n" )
  end
end

