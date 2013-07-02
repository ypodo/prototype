#!/usr/bin/env ruby

#############################################
# 
# This script will be started by rails as a process
# it will check if the user status is comlited 
# each user will have one like this
# when the status is complited or script get the time out it will exit with status 1

#scipt params
user_id=ARGV[0]
token=ARGV[1]
time_out=ARGV[2]
#initials
db_path="db/development.sqlite3"
timer=300000 # 5 min sleep process
update_str='UPDATE invite_histories SET arriving='+value_to_update+"  WHERE id="+invite_id
select_invite_histories_str="SELECT * from invite_histories where token="+token
update_orders_str='UPDATE orders SET status="complited" WHERE token="'+token

while true do
  begin
    complet=true
    #sqlite3 db/development.sqlite3 "select name from invites where id=144"
    db = SQLite3::Database.open path_to_db
    invites=db.execute select_invite_histories_str
    if !invites.nil?
      invites.each do |elem|
        if elem.arriving.nil? || elem.arriving < -40
          complet=false
          break
        end
      end  
    end
     
    if complet
      db.execute update_orders_str
      db.close if db
      UserMailer.notify("Process complited noticy teh user")
      exit 0
    end
    
  rescue Exception => e
    puts e  
  ensure
    db.close if db
  end
  
  if time_out > DateTime.now
    db.close if db
    UserMailer.notify("Process complited noticy teh user")
    exit 1
  else 
    sleep timer  
  end  
end
    
