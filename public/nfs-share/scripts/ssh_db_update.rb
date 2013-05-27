#!/usr/bin/env ruby
#This command should be executed by Asterisk over ssh from rails server
# invite_id ARGV[0]
# user_id ARGV[1]
# answer ARGV[2]
#ssh_db_update.rb
#require 'rubygems'
require 'net/ssh'
invite_id = ARGV[0]
user_id = ARGV[1]
answer = ARGV[2]

puts "User_id: "+user_id
puts "Invite_id: "+invite_id
puts "Answer: "+answer

HOST = '192.168.1.12' #Rails server ip prod
USER = 'root'
PASS = 'saasbook'
command="ruby /home/ubuntu/Documents/prototype/public/nfs-share/scripts/update_db.rb "+invite_id+" "+user_id+" "+answer # Execution command on Rails server
#command="ruby /home/ubuntu/Documents/prototype/public/nfs-share/scripts/update_db.rb 151 4 1"
puts command 
Net::SSH.start( HOST, USER, :password => PASS ) do|ssh|
  result = ssh.exec!(command)
  puts result
end
puts "ssh_update_END"
