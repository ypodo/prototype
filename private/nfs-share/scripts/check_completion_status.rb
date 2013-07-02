#!/usr/bin/env ruby

user_id=ARGV[0]
token=ARGV[1]

timer=300000 # 5 min
 while true     
   complet=true
   invites=InviteHistory.where(:token => token)
   invites.each do |elem|
     if elem.arriving.nil? || elem.arriving < -30
       complet=false
       break
     end
   end
   
   if complet
     order=Order.find_by_token(token)
     order.status="completed"
 if order.save
   #call other function
     user=User.find_by_id(order.user_id)
     UserMailer.report_on_completion(user)
     return
   end
 else                    
   sleep(timer)
   report_on_completion(" ")
     end  
   end
 end