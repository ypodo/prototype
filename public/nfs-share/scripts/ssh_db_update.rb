#!/usr/bin/env ruby
#This command should be executed from rails server "saasbook"
# invite_id ARGV[0]
# user_id ARGV[1]
# answer ARGV[2]
# reason ARGV[3]

require 'rubygems'
require 'net/ssh'

ip="192.168.56.102"

path="/var/www/prototype/public/nfs-share/"
#path="/home/ubuntu/Documents/prototype/private/nfs-share/"

invite_id = ARGV[0]
user_id = ARGV[1]
answer = ARGV[2]
reason = ARGV[3]

puts "User_id: "+user_id
puts "Invite_id: "+invite_id
puts "Answer: "+answer

# in case of any failure (no answer, busy, wrong number, etc. pass a negative number to store in DB
unless reason.nil?
  answer = reason
end

HOST = ip #Rails server ip
USER = 'root'
PASS = '1qaz!QAZ'

command="ruby #{path}/update_db.rb "+invite_id+" "+user_id+" "+answer # Execution command on Rails server
command_bash="#{path}/update_db.sh "+invite_id+" "+user_id+" "+answer # Execution command on Rails server
puts command 
Net::SSH.start( HOST, USER, :password => PASS ) do|ssh|
  result = ssh.exec!(command_bash)
  #result = ssh.exec!('rvm use 1.9.2 --default')
  #result = ssh.exec!('ruby --version')

  #result = ssh.exec!(command)
  puts result
end
puts "ssh_update_END"
