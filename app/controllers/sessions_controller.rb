class SessionsController < ApplicationController
  include ActionView::Helpers::OutputSafetyHelper

  def new    
  end
  
  def destroy
    sign_out
    redirect_to root_path
  end
  
  def create    
    if !request.env['omniauth.auth'].nil?
      auth = request.env["omniauth.auth"]
      user = User.find_by_provider_and_uid(auth["provider"], auth["uid"]) || User.create_with_omniauth(auth)
      session[:user_id] = user.id
      sign_in user
      redirect_to user, :notice => "Signed in!"
       
    elsif User.authenticate(params[:session][:email], params[:session][:password])
      user = User.authenticate(params[:session][:email], params[:session][:password])
      if user.nil?
        #flash.now[:notice] = fading_flash_message("Thank you for your message.", 2)
        flash.now[:error] = fading_flash_message("Invalid email/password combination, please try again")
        #flash.now[:alert] = "Invalid email/password combination, please try again"
      
       

        render 'new'
        
      else
        sign_in user
        redirect_to user
        #redirect_back_or user
      end
    else
      redirect_to root_url
    end
  end
  
  def omniauth_failure
    redirect_to root_url, alert: "Authentication failed, please try again."
    #redirect wherever you want.
  end
  
  def fading_flash_message(text, seconds=3)
  raw text +
    <<-EOJS
      <body onload="fadeOutFlashArea()"></body>
      <script type='text/javascript'>
        function fadeOutFlashArea() { 
                 setTimeout(function() {
                       $(function() {
              $('#flash_field').delay(1000).fadeIn('normal', function() {
              $(this).delay(2500).fadeOut();
             });  
              });
          }, #{seconds*1000});   
          
           };
           
      </script>
    EOJS
  end
  
  
end
