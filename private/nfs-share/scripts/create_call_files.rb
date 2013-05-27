#!/usr/bin/env ruby
#create call files
#/home/ubuntu/prototype/public/nfs-share/scripts
#ARGV[0] => user_id
var1 = ARGV[0]
puts var1
puts "public/nfs-share/"+var1+"/phonenumbers.txt"
if !File.directory?("/home/ubuntu/prototype/public/nfs-share/"+var1+"/call")
  Dir.mkdir "/home/ubuntu/prototype/public/nfs-share/"+var1+"/call"
else
  FileUtils.rm Dir.glob "/home/ubuntu/prototype/public/nfs-share/"+var1+"/call/*"
end
data=File.open "/home/ubuntu/prototype/public/nfs-share/"+var1+"/phonenumbers.txt"
puts !data.nil?
data.each do |elem|
  elem=elem.gsub(/\n/,"")
  puts elem
  File.open("/home/ubuntu/prototype/public/nfs-share/"+var1+"/call/"+elem+".call", 'w') do |f| 
    f.write("Channel:SIP/"+elem +"\n")    
    f.write("CallerID:" + elem +" " + "<"+var1+"> \n")
    f.write("MaxRetries: 0 \n")
    f.write("RetryTime: 60 \n")
    f.write("WaitTime: 60 \n")
    f.write("Context: default \n")
    f.write("Extension:"+ elem +"\n")
    #f.write("Priority: 1 \n")
  end
end

