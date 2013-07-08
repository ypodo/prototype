module CompletionHelper
 def check_completion_status(token)
   #Thread function
   #This thread will run for each runing call process and determining the completion
   #Thread will update Order table to set status column to complet   
   Thread.new do
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
           UserMailer.report_on_completion(user,token)
           return
         end
       else
         self.sleep(timer)
       end  
     end
   end
 end
end
