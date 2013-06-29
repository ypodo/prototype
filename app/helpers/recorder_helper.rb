module RecorderHelper
  
  def record_exist
    if !File.exist?(File.join('public','nfs-share',"#{user_from_remember_token.id}","#{user_from_remember_token.audio_file[0].audio_hash}.wav"))
      false
    else
      true
    end
         
  end
end