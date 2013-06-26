module RecorderHelper
  
  def record_exist
    if !File.exist?(File.join('private','nfs-share',"#{user_from_remember_token.id}","#{user_from_remember_token.id}.wav"))
      nil
    else
      true
    end
         
  end
end
