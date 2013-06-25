class PasswordResetsController < ApplicationController
  
  def create
    user = User.find_by_email(params[:email])         
    if user
      if user.provider.nil? #If user not created from sotial login 
        user.send_password_reset
      end      
    end
    redirect_to root_url , :notice => "Email sent with password reset instructions."
  end
  
  def edit
    @user = User.find_by_password_reset_token!(params[:id])
  end
  
  def update
    @user = User.find_by_password_reset_token!(params[:id])
    if @user.password_reset_sent_at < 2.hours.ago
      redirect_to new_password_reset_path, :alert => "Password reset has expired."
    elsif @user.update_attributes(params[:user])      
      redirect_to root_url, :notice => "Password has been reset use it to login!"
    else
      render :edit
    end
  end
end
