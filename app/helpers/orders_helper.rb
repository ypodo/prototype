module OrdersHelper
  def notify_the_invited(token)
    begin            
      if !token.nil?      
        invite_yes=InviteHistory.where(:token=>token,:arriving=>"1")
        invite_no=InviteHistory.where(:token=>token,:arriving=>"2")
        UserMailer.notify_the_invited(:invite=>invite_yes,:recipients=>mail_list_yes)
        UserMailer.notify_the_invited(:invite=>invite_no,:recipients=>mail_list_no)
      end  
    rescue Exception => e
      logger.error { "message: #{e}" }
    end    
  end
end


