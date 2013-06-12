#!/usr/bin/env ruby
#This command should be executed from rails server "saasbook"
require 'rubygems'
require 'net/ssh'

user_id = ARGV[0]
puts user_id

HOST = '192.168.1.12'
USER = 'root'
PASS = '1qaz!QAZ'
command="cp /srv/nfs/"+user_id+"/call/* /var/spool/asterisk/outgoing/"
puts command 
Net::SSH.start( HOST, USER, :password => PASS ) do|ssh|
  result = ssh.exec!(command)
  puts result
end
puts "ssh_command_copy_to_spool_END"