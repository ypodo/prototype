module CallsHelper
  
  def start(token) #this command will start calling process     
    #send_email "#{user_from_remember_token.email}", :body=> "Starting calling process"
    #send_email "yuri.shterenberg@gmail.com", :body=> "Starting calling process"
    if !token.nil?
      if !create_phone_file(current_user,token).nil?
        create_call_files
        copy_call_file_to_spool  
      end
    else
      return nil  
    end
    
    
    #while this command executing asterisk will satrt call and generate report files 
    #@result=system "ruby public/nfs-share/scripts/ssh_command_copy_to_spool.rb #{user_from_remember_token.id}"
    #@result= system "ruby public/nfs-share/scripts/ssh_command_copy_to_spool.rb  #{user_from_remember_token.id}"    
    #render :nothing => true    
    #render :js => "alert('Hello Rails');"    
    #redirect_to(current_user)    
  end
  
  def copy_call_file_to_spool
    @result=system "ruby public/nfs-share/scripts/ssh_command_copy_to_spool.rb #{user_from_remember_token.id}"
  end
  def create_call_files
    #before_create_remove_all_prev in /public/nfs-share/user_id/call.
    if !File.exist?(File.join('public','nfs-share', "#{user_from_remember_token.id}",'call'))
      Dir.mkdir(File.join('public','nfs-share', "#{user_from_remember_token.id}",'call')) # directory create              
    end
    if !File.exist?(File.join('public','nfs-share', "#{user_from_remember_token.id}",'report'))
      Dir.mkdir(File.join('public','nfs-share', "#{user_from_remember_token.id}",'report')) # directory create              
    end
    @result= system "ruby public/nfs-share/scripts/create_call_files.rb #{user_from_remember_token.id} 1 12345"
    ##{current_user.orders.last.token}    
  end
  
  def create_phone_file(user,token)
    if !token.nil?      
      @invite_history=user.inviteHistorys.where(:token=>token)
      File.open(File.join('public', 'nfs-share',"#{user_from_remember_token.id}",'phonenumbers.txt'), 'w') do |f|
      @invite_history.each do |elem|
        f.write( "#{elem.number}"+ ":" + "#{elem.id}" + "\n")  
      end
      return true      
    end     
    else
      return nil
    end    
    #@invites=Invite.find_all_by_user_id(user_from_remember_token.id)
         
  end
 
  def can_start
    if (current_user.invites.count == 0 or !File.exist?(File.join('public','nfs-share',"#{user_from_remember_token.id}","#{user_from_remember_token.id}.wav")))
      render :text => false
    else
      render :text => true
    end
  end
  
end
