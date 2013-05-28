module ApplicationHelper

  def unit_price
    # invites_count
    # cost_per_call=0.18 Icomm
    # profit %
    # mam %
    cost_per_call=0.23
    profit=0.7
    mam=0.18    
    return (cost_per_call*(1+profit)*(1+mam))      
  end
  
  def unit_price_with_out_vat
    # invites_count
    # cost_per_call=0.18 Icomm
    # profit %
    # mam %
    cost_per_call=0.23
    profit=0.7
    mam=0.18    
    return (cost_per_call*(1+profit)*(1+mam))      
  end
  
  def unit_price_with_vat
    # invites_count
    # cost_per_call=0.18 Icomm
    # profit %
    # mam %
    cost_per_call=0.23
    profit=0.7
    mam=0.18    
    return (cost_per_call*(1+profit)*(1+mam))      
  end
    
end
