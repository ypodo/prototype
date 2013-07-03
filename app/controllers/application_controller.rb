class ApplicationController < ActionController::Base
  protect_from_forgery
  include SessionsHelper  
  require 'omniauth-google-oauth2'
  #def current_user
  #  @current_user ||= User.find_by_auth_token!(cookies[:auth_token]) if cookies[:auth_token]
  #end
  before_filter :set_cache_buster
  def set_cache_buster
    response.headers["Cache-Control"] = "no-cache, no-store, max-age=0, must-revalidate"
    response.headers["Pragma"] = "no-cache"
    response.headers["Expires"] = "Fri, 01 Jan 1990 00:00:00 GMT"
  end
  
  
  
end
