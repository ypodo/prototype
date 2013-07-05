# coding: utf-8
class SessionsController < ApplicationController
  include ActionView::Helpers::OutputSafetyHelper

  def new    
  end
  
  def destroy
    sign_out
    redirect_to root_path
  end
  
  def create    
    begin
      if !request.env['omniauth.auth'].nil?
        auth = request.env["omniauth.auth"]
        if User.find_by_provider_and_uid(auth["provider"], auth["uid"])
          user=User.find_by_provider_and_uid(auth["provider"], auth["uid"])
          session[:user_id] = user.id
          sign_in user
          redirect_to user, :notice => "מחובר!"
        else        
          user = User.create_with_omniauth(auth)
          session[:user_id] = user.id
          sign_in user
          redirect_to categories_path, :notice => "משתמש חדש נוצר בהצלחה"
        end       
      else
        user = User.authenticate(params[:session][:email], params[:session][:password])
        if user.nil?
          #flash.now[:notice] = fading_flash_message("Thank you for your message.", 2)
          flash.now[:error] = "סיסמא שגויה - נסה שנית"
          #flash.now[:error] = "Invalid email/password combination, please try again"
          render 'new'          
        else
          sign_in user
          redirect_to user
          #redirect_back_or user
        end
      end
    rescue
      flash.now[:error] = "אירעה שגיאה - נסה שנית"
      redirect_to root_path
    end
  end
  
  def omniauth_failure
    redirect_to root_url, alert: "אירעה שגיאה באימות נתונים - נסה שנית"
    #redirect wherever you want.Authentication failed, please try again.
  end
  
  #def fading_flash_message(text, seconds=3)
  #raw text +
  #  <<-EOJS
  #    <body onload="fadeOutFlashArea()"></body>
  #    <script type='text/javascript'>
  #         
  #    </script>
  #  EOJS
  #end
  
  
end
