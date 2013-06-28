class OrdersController < ApplicationController
include CallsHelper
include ApplicationHelper
include UsersHelper
#https://github.com/nov/paypal-express/wiki/_pages
https://developer.paypal.com/webapps/developer/applications/myapps
  def checkout     
    begin
      amount=(current_user.invites.count*(unit_price)).to_f.round(2)
      if (amount <= 0)
        render :nothing => true
        return
      end  
      
      payment_request = Paypal::Payment::Request.new(
        :currency_code => :ILS, # if nil, PayPal use USD as default
        :amount        => amount,
        :items => [{
          :name => "Mazminim.com",
          :description => "Automated calling services",
          :amount => amount,
          :category => :Digital
        }]
      )    
      response = express.setup(
        payment_request,
        "http://"+env["HTTP_HOST"]+"/orders/confirm",
        "http://"+env["HTTP_HOST"]+"/orders/cancel",
        :no_shipping => true
      )
      cookies[:ui_location]="tab4"    
      render :text => response.popup_uri
      #redirect_to gateway.redirect_url_for(setup_response.token)
    rescue Paypal::Exception::APIError => e
       logger.error { "message: #{e}" }
    ensure
      UserMailer.error(message)
    end
  end
  
  def confirm
    begin
      if (!params[:token].nil? && !params[:PayerID].nil?)
        semaphore = Mutex.new
        token = params[:token]
        payer_id=params[:PayerID]  
        #or  response.payer.identifier 
        if Order.find_by_token(token).nil?
          response_paypal = express.details(token)
          complete(response_paypal)
        else
          return      
        end
      else
        flash[:error] = "PayPal error. Try again"
        redirect_to root_path  
      end
    rescue Paypal::Exception::APIError => e
     redirect_to root_path
     logger.error { "message: #{e}" }
    end 
  end
  
  def cancel 
    #This script will help to redirec user after payment process closed
    render :partial => 'scripts/close_opened_windows'
  end
  
  private
    def complete(var)
      # This process will be the last who 
      begin
        if Order.find_by_token(var.token).nil?
          amount=current_user.invites.count*(unit_price)
          payment_request = Paypal::Payment::Request.new(
          :currency_code => :ILS, # if nil, PayPal use USD as default
          :amount        => amount,
          :items => [{
            :name => "Mazminim automated calling system",
            :description => "Automation services",
            :amount => amount,
            :category => :Digital
            }]
          )  
       
          #need to avoid dublicate transsction        
          token=var.token
          payer_id=var.payer.identifier      
          response_paypal = express.checkout!(token, payer_id, payment_request)
          # inspect this attribute for more details
          #response_paypal.payment_info      
          if add_payment_to_orders(response_paypal)
            copy_invites_to_history_table
            start(token)        
            
            render :partial => 'scripts/close_opened_windows'    
            return true
          else
            render :text => "Error while checkout process, contact mazminim support to resolve the problem"
            return false
          end
        else 
         render :text => "Process already started, please whait!"           
        end
      rescue Paypal::Exception::APIError => e
        logger.error { "#{e}" }
      end
      
            
    end
    
    def add_payment_to_orders(response_paypal)
      order=current_user.orders.new      
      order.token=response_paypal.token
      order.amount=response_paypal.payment_info[0].amount.total
      if order.save.nil?
        false
      end
      return true
    end
    def copy_invites_to_history_table
      current_token=current_user.orders.last.token
      current_invites=current_user.invites
      current_invites.each do |elem|  
        if !elem.number.nil? && elem.number!=""
         current_user.inviteHistorys.new(          
          :name=>elem.name,
          :mail=>elem.mail,
          :token => current_token,
          :number=>elem.number).save 
        end                
      end        
    end
      
    def express
      #set sandbox mode
      #to do
      Paypal.sandbox=true
      Paypal::Express::Request.new(
      :username => 'mazminim.com-facilitator_api1.gmail.com', 
      :password => '1366565411', 
      :signature => 'AFcWxV21C7fd0v3bYYYRCpSSRl31AUS9RX-zEZtLQLv1Dp1odN9RwOeR' 
      ) 
    end
end
#lev
#lefontiy_api1.gmail.com
#HQ3CNVX486425GL6
#AFcWxV21C7fd0v3bYYYRCpSSRl31AzGeNVQV2CTY6pLh3SaZQuwei0PL
#yuri
#:login => 'yuri.shterenberg_api1.gmail.com', 
#:password => '683ZWNFL5LNHDKSL', 
#:signature => 'A3AU4NDVw7j.oSslgS-kreIwyR6TABxWlJoOrTPWr-YUcK1BXX41dur8' 

