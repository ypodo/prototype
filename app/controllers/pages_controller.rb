class PagesController < ApplicationController
require 'net/http'
skip_before_filter  :verify_authenticity_token
  def home
    @user=User.new    
    
  end

  def contact
   
  end

  def about
    
  end
  
  def support
    
  end    
  def help
    @time=Time.now
  end
  
  def term_of_use    
  end
  
  def recorder
    @user = current_user
  end
  
  def unavailable
    
  end
    
end
