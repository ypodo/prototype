#!/usr/bin/env ruby
#This command should be executed from rails server "saasbook"
# invite_id ARGV[0]
# user_id ARGV[1]
# answer ARGV[2]

#require 'rubygems'
#require 'net/ssh'
require '/usr/local/rvm/gems/ruby-1.9.2-p320/gems/net-ssh-2.6.5/lib/net/ssh'
ip="192.168.56.102"
path="/var/www/prototype/public/nfs-share/scripts"
invite_id = ARGV[0]
user_id = ARGV[1]
answer = ARGV[2]


puts require 'net/ssh'
puts "User_id: "+user_id
puts "Invite_id: "+invite_id
puts "Answer: "+answer

HOST = ip #Rails server ip
USER = 'root'
PASS = '1qaz!QAZ'

command="#{path}/update_db.sh "+invite_id+" "+user_id+" "+answer # Execution command on Rails server
#command="ruby #{path}/update_db.rb "+invite_id+" "+user_id+" "+answer # Execution command on Rails server
#command="ruby /home/ubuntu/Documents/prototype/public/nfs-share/scripts/update_db.rb 151 4 1"
puts command 
Net::SSH.start( HOST, USER, :password => PASS ) do|ssh|
  result = ssh.exec!(command)
  #result = ssh.exec!('rvm use 1.9.2 --default')
  #result = ssh.exec!('ruby --version')

  #result = ssh.exec!(command)
  puts result
end
puts "ssh_update_END"
