# coding: utf-8
class PasswordResetsController < ApplicationController
  
  def create
    begin
      user = User.find_by_email(params[:email])         
      if user
        if user.provider.nil? #If user not created from sotial login 
          user.send_password_reset
        end      
      end
      redirect_to root_url, :notice => "בדוק את תיבת הדואר שלך להוראות נוספות"
    rescue Exception => e
      logger.error { "message: #{e}" }
      UserMailer.error("message: #{e}")
    end
  end
  
  def edit
    @user = User.find_by_password_reset_token!(params[:id])
  end
  
  def update
    @user = User.find_by_password_reset_token!(params[:id])
    if @user.password_reset_sent_at < 2.hours.ago
      redirect_to new_password_reset_path, :alert => "נסיון זה לא תקף - התחל את התהליך מהתחלה"
    elsif @user.update_attributes(params[:user])      
      redirect_to root_url, :notice => "הסיסמא הוחלפה בהצלחה"
    else
      render :edit
    end
  end
end
