#!/usr/bin/env ruby
#This command should be executed from rails server "saasbook"

require 'rubygems'
require 'net/ssh'

user_id = ARGV[0]
puts user_id

HOST = '192.168.56.102'
USER = 'root'
PASS = '1qaz!QAZ'
command="cp /srv/nfs/"+user_id+"/call/*.call /var/spool/asterisk/outgoing/"
puts command 
Net::SSH.start( HOST, USER, :password => PASS, :paranoid => false ) do|ssh|
  result = ssh.exec!(command)
  puts result
end
puts "ssh_command_copy_to_spool_END"
