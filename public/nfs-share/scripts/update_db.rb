#!/usr/bin/ruby
# This script will update invite table
# ARGV[0] represents the invite_id
# ARGV[1] Represents user_id
# ARGV[2] DTMF 
require 'sqlite3'
path="/var/www/prototype/db"
begin
  invite_id = ARGV[0]
  user_id = ARGV[1]
  value_to_update = ARGV[2]
  #puts Dir.pwd
  path_to_db="#{path}/development.sqlite3"
  puts "invite id: "+invite_id
  puts "User id: "+user_id
  puts "Value to update: "+value_to_update
  update_str='UPDATE invite_histories SET arriving='+value_to_update+"  WHERE id="+invite_id
  puts update_str
  #sqlite3 db/development.sqlite3 "select name from invites where id=144"
  db = SQLite3::Database.open path_to_db
  name = db.execute "SELECT name from invite_histories where id="+invite_id
  if !name.nil?
    puts name
    db.execute update_str      
  else        
    puts "Nil"
  end      
  
rescue SQLite3::Exception => e 
    
    puts "Exception occured"
    puts e
    
ensure
    db.close if db    
end
