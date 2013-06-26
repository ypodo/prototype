class CallsController < ApplicationController
  def can_start
    if (current_user.invites.count == 0 or !File.exist?(File.join('private','nfs-share',"#{user_from_remember_token.id}","#{user_from_remember_token.id}.wav")))
      render :text => false
    else
      render :text => true
    end
  end  
end
