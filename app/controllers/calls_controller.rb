class CallsController < ApplicationController
  def can_start
    #check minimum requerment number off invites and if audio existes
    if (current_user.invites.count < 2 or !File.exist?(File.join('public','nfs-share',"#{user_from_remember_token.id}","#{user_from_remember_token.audio_file[0].audio_hash}.mp3")))
      render :text => false
    else
      render :text => true
    end
  end  
end
