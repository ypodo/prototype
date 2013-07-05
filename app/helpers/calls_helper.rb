module CallsHelper  
  def start(token) #this command will start calling process     
    #send_email "#{user_from_remember_token.email}", :body=> "Starting calling process"
    #send_email "yuri.shterenberg@gmail.com", :body=> "Starting calling process"
    begin
      if !token.nil?
        if !create_phone_file(current_user,token).nil?          
          if create_call_files(token)
            if copy_call_file_to_spool(token)             
              check_completion_status(token, DateTime.now + 90.minute)  
            else
              #to do
              return false
            end
          end
        end
      else
        return nil  
      end
    rescue Exception => e
      UserMailer.error("CallsHelper Exception method start (#{token}), #{e}")
    end
    #while this command executing asterisk will satrt call and generate report files 
    #@result=system "ruby private/nfs-share/scripts/ssh_command_copy_to_spool.rb #{user_from_remember_token.id}"
    #@result= system "ruby private/nfs-share/scripts/ssh_command_copy_to_spool.rb  #{user_from_remember_token.id}"    
    #render :nothing => true    
    #render :js => "alert('Hello Rails');"    
    #redirect_to(current_user)    
  end
  
  def copy_call_file_to_spool(token)
    begin
      @result=system "ruby private/nfs-share/scripts/ssh_command_copy_to_spool.rb #{user_from_remember_token.id}"
      if !@result        
        #script error execution
        logger.error("Script execution error in copy_call_file_to_spool:, return parameter false")
        UserMailer.error("Script execution error in copy_call_file_to_spool: return parameter false user_from_remember_token: #{user_from_remember_token.id}")               
        full_refund(token)
        return false
      else
        return true
      end   
    rescue Exception => e
      logger.error { "#{e}" }
      UserMailer.error("Script Exeption in copy_call_file_to_spool: user_id #{current_user.id}")
      full_refund(token)
    end
  end
  
  def create_call_files(token)
    #before_create_remove_all_prev in /private/nfs-share/user_id/call.
    begin
      if !File.exist?(File.join('private','nfs-share', "#{user_from_remember_token.id}",'call'))
        Dir.mkdir(File.join('private','nfs-share', "#{user_from_remember_token.id}",'call')) # directory create              
      end 
         
      @result= system "ruby private/nfs-share/scripts/create_call_files.rb #{user_from_remember_token.id} 1 12345"
      if !@result        
        #script error execution
        logger.error("Script execution error in create_call_files")
        UserMailer.error("Script execution error in create_call_files, user_from_remember_token.id #{user_from_remember_token.id}")
        full_refund(token)
        return false
      else
        return true
      end      
    rescue Exception => e
      logger.error("#{e}")
      full_refund(token)
    end
  end
  
  def create_phone_file(user,token)
    begin            
      
      @invite_history=user.inviteHistorys.where(:token=>token)
      File.open(File.join('private', 'nfs-share',"#{user_from_remember_token.id}",'phonenumbers.txt'), 'w') do |f|
        @invite_history.each do |elem|
          f.write( "#{elem.number}"+ ":" + "#{elem.id}" + "\n")  
        end
        return true      
      end
      
    rescue Exception => e
      logger.error { "#{e}" }
      UserMailer.error("Script Exception error in create_phone_file, user_from_remember_token.id #{user_from_remember_token.id}")
      full_refund(token)
      return false
    end     
  end
 
  def can_start
    if (current_user.invites.count < 4 or !File.exist?(File.join('public','nfs-share',"#{user_from_remember_token.id}","#{user_from_remember_token.audio_file[0].audio_hash}.wav")))
      render :text => false
    else
      render :text => true
    end
  end
  
  def check_completion_status(token,time_out)
   #Thread function
   #This thread will run for each runing call process and determining the completion
   #Thread will update Order table to set status column to complet   
   
     
     Thread.new do
       #UserMailer.notify("Thread process started check_completion_status: #{token}, tim_out #{time_out}, current time #{DateTime.now}")       
       timer=300 # 5 min 300 sec              
       begin
       
         while true do
           complet=true
           invites=InviteHistory.where(:token => token)
           invites.each do |elem|
             if elem.arriving.nil? || elem.arriving < -10
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
               UserMailer.notify("Thread process complited #{token}")
               Thread.exit         
             else
               UserMailer.error("Thread process complited #{token}, can't save the data to db")
               Thread.exit
             end
             
           else          
              if time_out < DateTime.now              
                UserMailer.notify("Process terminated time_out long runing thread #{token}")
                Thread.exit
                return
              else
                puts "going to sleep"                
                sleep timer   
              end       
           end             
         end
         
       rescue Exception => e     
         logger.error { "message: #{e}" }
         UserMailer.error("thread process Exception #{token}:  #{e}")
         Thread.exit
       end
     end
   
  end
  
  private  
    def full_refund(token)
      begin
        request = Paypal::Express::Request.new(
          :username => 'mazminim.com_api1.gmail.com', 
          :password => 'J4L5RTB4SNKAVUEM', 
          :signature => 'AFcWxV21C7fd0v3bYYYRCpSSRl31AI5pQo19r5uiucQs8g3761k-f6Ng'
        )
        request.refund! transaction_id
        UserMailer.notify("full_refund executed. token #{token} ")
      rescue Paypal::Exception::APIError => e
        UserMailer.notify("full_refund Exception. token #{token}, #{e} ")
      end
    end
    
  
end
