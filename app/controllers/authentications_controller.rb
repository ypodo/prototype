# coding: utf-8
class AuthenticationsController < ApplicationController
  def index
    @authentications = current_user.authentications if current_user
  end
  
  def create
    auth = request.env["rack.auth"]
    current_user.authentications.find_or_create_by_provider_and_uid(auth['provider'], auth['uid'])
    flash[:notice] = "אימות הסתיים בהצלחה"
    redirect_to authentications_url
  end
  
  def destroy
    @authentication = current_user.authentications.find(params[:id])
    @authentication.destroy
    flash[:notice] = "התנתקות בוצעה בהצלחה"
    redirect_to authentications_url
  end
end
