module RecorderHelper
  
  def record_exist
    begin
      if !File.exist?(File.join('public','nfs-share',"#{user_from_remember_token.id}","#{user_from_remember_token.audio_file[0].audio_hash}.mp3"))
        return false
      else
        return true
      end
    rescue Exception => e
      logger.error("#{e}")
    end  
  end
end