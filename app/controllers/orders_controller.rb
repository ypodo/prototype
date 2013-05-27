class OrdersController < ApplicationController
include CallsHelper
  def checkout     
    amount=current_user.invites.count*(0.5)
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
    render :text => response.popup_uri
    #redirect_to gateway.redirect_url_for(setup_response.token)
  end
  
  def confirm
    if (!params[:token].nil? && !params[:PayerID].nil?)
      token = params[:token]
      payer_id=params[:PayerID]  
      #or  response.payer.identifier      
      response_paypal = express.details(token)
      # inspect these attributes for more details    
      if complete(response_paypal) == true
        #render :json => response_paypal
        
      end       
     end     
  end
  
  def cancel 
  end
  
  private
    def complete(var)
      # This process will be the last who 
      amount=current_user.invites.count*(0.5)
      payment_request = Paypal::Payment::Request.new(
      :currency_code => :ILS, # if nil, PayPal use USD as default
      :amount        => amount,
      :items => [{
        :name => "Mazminim automatin calling system",
        :description => "Automation services",
        :amount => amount,
        :category => :Digital
        }]
      )  
      if Order.find_by_token(var.token).nil?
        #need to avoid dublicate transsction        
        token=var.token
        payer_id=var.payer.identifier      
        response_paypal = express.checkout!(token, payer_id, payment_request)
        # inspect this attribute for more details
        #response_paypal.payment_info      
        if add_payment_to_orders(response_paypal)
          copy_invites_to_history_table
          start(token)        
          render :text => '<button type="button" onclick="window.close();">Click Me!</button><h1> Your payment has been processed successfully, please close the window to continue."'      
          return true
        else
          render :text => "Error while checkout process, contact mazminim support to resolve the problem"
          return false
        end
      else 
       render :text => "Process already started, please whait!"           
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