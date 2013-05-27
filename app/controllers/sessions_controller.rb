class SessionsController < ApplicationController
require 'omniauth'
require 'omniauth-facebook'

  def new
    @title="Sign in"
  end
  
  def destroy
    sign_out
    redirect_to root_path
  end
  
  def create
    if !request.env['omniauth.auth'].nil? do
        auth_hash = request.env['omniauth.auth'] 
        @authorization = Authorization.find_by_provider_and_uid(auth_hash["provider"], auth_hash["uid"])
        if @authorization
          render :text => "Welcome back #{@authorization.user.name}! You have already signed up."
        else
          user = User.new :name => auth_hash["user_info"]["name"], :email => auth_hash["user_info"]["email"]
          user.authorizations.build :provider => auth_hash["provider"], :uid => auth_hash["uid"]
          user.save
       
          render :text => "Hi #{user.name}! You've signed up."
        end   
      end
    end
       
    user = User.authenticate(params[:session][:email],
                             params[:session][:password])
    if user.nil?
      flash.now[:error] = "Invalid email/password combination, please try again."
      @title = "Sign in"
      render 'new'
    else
      sign_in user
      redirect_to user
      #redirect_back_or user
    end
  end
  
  def failure
    
  end
end
