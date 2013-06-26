module UsersHelper
  def unit_price
    # invites_count
    # cost_per_call=0.18 Icomm
    # profit %
    # mam %
    cost_per_call=0.23
    profit=0.7
    mam=0.18    
    return (cost_per_call*(1+profit)*(1+mam))      
  end
  
  def unit_price_with_out_vat
    # invites_count
    # cost_per_call=0.18 Icomm
    # profit %
    # mam %
    cost_per_call=0.23
    profit=0.7
    mam=0.18    
    return (cost_per_call*(1+profit)*(1+mam))      
  end
  
  def unit_price_with_vat
    # invites_count
    # cost_per_call=0.18 Icomm
    # profit %
    # mam %
    cost_per_call=0.23
    profit=0.7
    mam=0.18    
    return (cost_per_call*(1+profit)*(1+mam))      
  end
  
  def convert_audio_to_sln
    if File.exist?(File.join('private','nfs-share',"#{user_from_remember_token.id}","#{user_from_remember_token.id}.wav"))              
      Kernel.system "private/nfs-share/scripts/convert_audio.sh #{user_from_remember_token.id}"        
    end 
  end
end
