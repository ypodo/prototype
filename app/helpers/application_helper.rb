module ApplicationHelper
#require 'nokogiri'
  
  def unit_price
    # invites_count
    # cost_per_call=0.18 Icomm
    # profit %
    # mam %
    cost_per_call=0.23
    profit=0.7
    mam=0.18    
    return (cost_per_call*(1+profit)*(1+mam)).round(2)      
  end
  def unit_price_whithout_profit
    cost_per_call=0.23
    paypal_rent=0.034    
    return (cost_per_call*(1+paypal_rent)).round(2)
  end
  
  def unit_price_with_out_vat
    # invites_count
    # cost_per_call=0.18 Icomm
    # profit %
    # mam %
    cost_per_call=0.23
    profit=0.7
    mam=0.18    
    return (cost_per_call*(1+profit)*(1+mam)).round(2)      
  end
  
  def unit_price_with_vat
    # invites_count
    # cost_per_call=0.18 Icomm
    # profit %
    # mam %
    cost_per_call=0.23
    profit=0.7
    mam=0.18    
    return (cost_per_call*(1+profit)*(1+mam)).round(2)      
  end
  
  def test_price
    cost_per_call=0.23
    paypal_rent=0.034
    paypal_transaction_rent=1.20   
          
    return (cost_per_call-(cost_per_call*paypal_rent+paypal_transaction_rent)).round(2)
  end
      
end
