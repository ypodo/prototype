#!/usr/bin/env ruby
#create call files
#/home/ubuntu/prototype/public/nfs-share/scripts
#ARGV[0] => user_id
# this script got only one params (user_id)
require 'fileutils'
user_id = ARGV[0]
path_dev="/home/ubuntu/prototype/public/nfs-share/"
path_prod="/var/www/prototype/public/nfs-share/"
#puts user_id
#puts "public/nfs-share/"+user_id+"/phonenumbers.txt"
if !File.directory?(path_prod+user_id+"/call")
  Dir.mkdir path_prod+user_id+"/call"
else
  FileUtils.rm Dir.glob path_prod+user_id+"/call/*"
end
data=File.open path_prod+user_id+"/phonenumbers.txt"

data.each do |elem|
  elem=elem.gsub(/\n/,"")
  #puts elem.split(":")[0]
  File.open(path_prod+user_id+"/call/"+elem.split(":")[0]+".call", 'w') do |f| 
    f.write("Channel:SIP/"+elem.split(":")[0] +"\n")    
    f.write("CallerID: mazminim"+ "\n")
    f.write("MaxRetries: 0 \n")
    f.write("RetryTime: 30 \n")
    f.write("WaitTime: 30 \n")
    f.write("Context: external \n")
    f.write("Extension:"+ elem.split(":")[0] +"\n")
    #f.write("Data:" + elem.split(":")[1])
    f.write("Priority: 1 \n")
    f.write("Setvar: invite_id="+elem.split(":")[1]+"\n" )
    f.write("Setvar: user_id="+user_id+"\n")
    f.write("Setvar: inviter="+user_id+"\n")
  end
end

