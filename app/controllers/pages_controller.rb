class PagesController < ApplicationController
include ApplicationHelper
require 'net/http'
skip_before_filter  :verify_authenticity_token
  def home
    @user=User.new      
  end

  def contact
   
  end

  def about
    #"Mozilla/5.0 (X11; Linux i686) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/27.0.1453.93 Safari/537.36"
    #windows IE 10
    #"Mozilla/5.0 (compatible; MSIE 10.0; Windows NT 6.1; WOW64; Trident/6.0; BOIE9;ENUS)"
    #win Ie 9
    #"Mozilla/5.0 (compatible; MSIE 9.0; Windows NT 6.1; WOW64; Trident/5.0; BOIE9;ENUS)"
    #win Ie 8
    #"Mozilla/4.0 (compatible; MSIE 8.0; Windows NT 6.1; WOW64; Trident/4.0; SLCC2; .NET CLR 2.0.50727; .NET CLR 3.5.30729; .NET CLR 3.0.30729; .NET CLR 1.1.4322; .NET4.0C; .NET4.0E; InfoPath.3; BOIE9;ENUS)"
    #puts request.env['HTTP_USER_AGENT']
  end
  
  def support
    
  end    
  def help
    
  end
  
  def term_of_use    
  end
  
  def recorder
    @user = current_user
  end
  
  def unavailable
    
  end
    
end
