module CallsHelper  
  def start(token) #this command will start calling process     
    #send_email "#{user_from_remember_token.email}", :body=> "Starting calling process"
    #send_email "yuri.shterenberg@gmail.com", :body=> "Starting calling process"
    begin
      if !token.nil?
        if !create_phone_file(current_user,token).nil?
          if create_call_files
            if copy_call_file_to_spool || true #to do
              #to do
              check_completion_status(token)  
            else
              #to do
              return false
            end
          end
        end
      else
        return nil  
      end
    rescue
      UserMailer.error("module CallsHelper  error start(#{token})")
    end
    #while this command executing asterisk will satrt call and generate report files 
    #@result=system "ruby private/nfs-share/scripts/ssh_command_copy_to_spool.rb #{user_from_remember_token.id}"
    #@result= system "ruby private/nfs-share/scripts/ssh_command_copy_to_spool.rb  #{user_from_remember_token.id}"    
    #render :nothing => true    
    #render :js => "alert('Hello Rails');"    
    #redirect_to(current_user)    
  end
  
  def copy_call_file_to_spool
    begin
      @result=system "ruby private/nfs-share/scripts/ssh_command_copy_to_spool.rb #{user_from_remember_token.id}"
      if !@result        
        #script error execution
        logger.error("Script execution error in copy_call_file_to_spool:, return parameter false")
        UserMailer.error("Script execution error in copy_call_file_to_spool: return parameter false user_from_remember_token: #{user_from_remember_token.id}")
        return false
      else
        return true
      end   
    rescue Exception => e
      logger.error { "#{e}" }
      UserMailer.error("Script Exeption in copy_call_file_to_spool: user_id #{current_user.id}")
    end
  end
  
  def create_call_files
    #before_create_remove_all_prev in /private/nfs-share/user_id/call.
    if !File.exist?(File.join('private','nfs-share', "#{user_from_remember_token.id}",'call'))
      Dir.mkdir(File.join('private','nfs-share', "#{user_from_remember_token.id}",'call')) # directory create              
    end    
    @result= system "ruby private/nfs-share/scripts/create_call_files.rb #{user_from_remember_token.id} 1 12345"
    if !@result        
      #script error execution
      logger.error("Script execution error in create_call_files")
      UserMailer.error("Script execution error in create_call_files, user_from_remember_token.id #{user_from_remember_token.id}")
      return false
    else
      return true
    end       
  end
  
  def create_phone_file(user,token)
    begin
      if !token.nil?      
        @invite_history=user.inviteHistorys.where(:token=>token)
        File.open(File.join('private', 'nfs-share',"#{user_from_remember_token.id}",'phonenumbers.txt'), 'w') do |f|
        @invite_history.each do |elem|
          f.write( "#{elem.number}"+ ":" + "#{elem.id}" + "\n")  
        end
        return true      
      end     
      else
        return false
      end
    rescue Exception => e
      logger.error { "#{e}" }
      UserMailer.error("Script Exception error in create_phone_file, user_from_remember_token.id #{user_from_remember_token.id}")
      return false
    end
    
    #@invites=Invite.find_all_by_user_id(user_from_remember_token.id)
         
  end
 
  def can_start
    if (current_user.invites.count == 0 or !File.exist?(File.join('public','nfs-share',"#{user_from_remember_token.id}","#{user_from_remember_token.audio_file[0].audio_hash}.wav")))
      render :text => false
    else
      render :text => true
    end
  end
  
  def check_completion_status(token)
   #Thread function
   #This thread will run for each runing call process and determining the completion
   #Thread will update Order table to set status column to complet   
   begin
     UserMailer.notify("Started check_completion_status: #{token}")
     Thread.new do
       timer=3000000 # 5 min
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
   rescue Exception => e     
     logger.error { "message: #{e}" }
   end
  end
  
end
