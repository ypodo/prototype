#!/usr/bin/env ruby
#This command should be executed from rails server "saasbook"
# invite_id ARGV[0]
# user_id ARGV[1]
# answer ARGV[2]

require 'rubygems'
require 'net/ssh'
user_id = ARGV[1]
invite_id = ARGV[0]
answer = ARGV[2]
puts "User_id: "+user_id
puts "Invite_id: "+invite_id
puts "Answer: "+answer

HOST = '192.168.1.11' #Rails server ip
USER = 'root'
PASS = 'saasbook'
command="ruby /home/ubuntu/Documents/prototype/private/nfs-share/scripts/update_db.rb "+invite_id+" "+user_id+" "+answer # Execution command on Rails server
puts command 
Net::SSH.start( HOST, USER, :password => PASS ) do|ssh|
  result = ssh.exec!(command)
  puts result
end
puts "ssh_command_copy_to_spool_END"
