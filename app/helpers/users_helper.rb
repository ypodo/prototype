module UsersHelper
  def unit_price
    # invites_count
    # cost_per_call=0.18 Icomm
    # profit %
    # mam %
    cost_per_call=0.23
    profit=0.7
    mam=0.18    
    return (cost_per_call*(1+profit)*(1+mam)).round(2)       
  end
  
  def unit_price_with_out_vat
    # invites_count
    # cost_per_call=0.18 Icomm
    # profit %
    # mam %
    cost_per_call=0.23
    profit=0.7
    mam=0.18    
    return (cost_per_call*(1+profit)*(1+mam)).round(2)       
  end
  
  def unit_price_with_vat
    # invites_count
    # cost_per_call=0.18 Icomm
    # profit %
    # mam %
    cost_per_call=0.23
    profit=0.7
    mam=0.18    
    return (cost_per_call*(1+profit)*(1+mam)).round(2)       
  end  
  def total_price
    (current_user.invites.count*unit_price).to_f.round(2)
  end
  def paypal_fee
    1.20
  end
  def convert_audio_to_sln
    begin
      if File.exist?(File.join('public','nfs-share',"#{user_from_remember_token.id}","#{user_from_remember_token.audio_file[0].audio_hash}.mp3"))              
        Kernel.system "private/nfs-share/scripts/convert_audio.sh #{user_from_remember_token.id} #{user_from_remember_token.audio_file[0].audio_hash}"        
      end
    rescue Exception => e
      logger.error("#{e}")
      UserMailer.error("convert_audio_to_sln, #{user_from_remember_token.id}")
    end 
  end
end
