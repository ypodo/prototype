module CompletionHelper
 def check_completion_status(token)
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
         return
       end
     else
       self.sleep(timer)
     end  
   end
 end
end
