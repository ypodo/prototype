class PagesController < ApplicationController
require 'net/http'

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
  
  def foo
    render :js => "alert('Hello');"
  end
  
end
