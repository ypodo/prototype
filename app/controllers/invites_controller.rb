class InvitesController < ApplicationController
  def edit
    @invite = Invite.find(params[:id])
  end
  
  def create
    # AJAX method return invite if secseed
    #proverka esli prigloshenni nomer uje su4estvuet u dannogo usera
    #ispolzuetsa togda kogda user dobovlet novogo priglashennogo 4erez web ui
    begin
      if !current_user.invites.find_by_number(params[:invite][:number]).nil?
        render :js => "alert('Validation notification: number already exists');"
        return
      end
      @invite  = current_user.invites.build(params[:invite])
      #validate(@invite)
      if @invite.save            
        render :json => @invite
        #redirect_to current_user
      else
        render :js => "alert('Validation error: please check email or number format.');"
      end  
    rescue Exception => e
      logger.error { "message: #{e}" }      
    end
    
    
  end
  
  def destroy
    @invite=Invite.find(params[:id])
    @user=User.find(@invite.user)    
    @invite.destroy
    @invites=@user.invites
    #flash[:success] = "Record deleted!"    
    render :json => @invite    
  end
  
  def delete_all
    # THis is ajax method it used by javascript function => delete_all_ajax();
    User.find(current_user.id).invites.delete_all    
    render :status => 200      
    #redirect_to current_user    
  end
  
  private
  
    def validate(invite)        
     if !invite.number.match(/^(\d\d\d\d\d\d\d\d\d\d)\z|^(\d\d\d\d\d\d\d\d\d)\z/).nil?
       return true
     end      
    end
  
  
end
