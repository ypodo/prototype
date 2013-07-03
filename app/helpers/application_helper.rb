module ApplicationHelper
require 'nokogiri'
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
    
  def translate(leng)
  #in view you should do this <%=translate("eng").at("tab1").text%>
    if File.exist?("private/translate.xml")      
      doc = Nokogiri::XML(File.open("private/translate.xml"))
      if leng=="eng"
        return doc.at("english")
      elsif leng =="hebrew"
        return doc.at("hebrew")
      else
        return nil
      end
    end
    
  end  
end
