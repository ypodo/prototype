class UploadController < ApplicationController
#require 'csv'
require 'iconv'
require 'roo'

  def upload  #action 
    #params[:data_file]
    
    if !/(.xlsx)|(.csv)/.match(params[:data_file].original_filename)    
      redirect_to user :notice =>"uploaded file extension is not correct"
      return
    end
    if !File.directory? File.join('public','nfs-share',"#{user_from_remember_token.id}",'csv') # if directory not exist it will be created
      Dir.mkdir(File.join('public','nfs-share', "#{user_from_remember_token.id}","csv")) # directory create
    end
    @uploaded_data=File.open(Rails.root.join(params[:data_file].tempfile.path), 'r').read
    File.open(Rails.root.join('public','nfs-share',"#{user_from_remember_token.id}","csv", params[:data_file].original_filename), 'w') do |file|
      file.write(@uploaded_data+".xlsx")
    end
    excel_path="public/nfs-share/#{user_from_remember_token.id}/csv/#{params[:data_file].original_filename}"
    
    if /(.xlsx)/.match(params[:data_file].original_filename)
      s = Roo::Excelx.new(excel_path)
      
    elsif /(.csv)/.match(params[:data_file].original_filename)
      s = Roo::Csv.new(excel_path)
    
    elsif /(.xls)/.match(params[:data_file].original_filename)
      s = Roo::Excel.new(params[:data_file].original_filename)
    
    elsif /(.ods)/.match(params[:data_file].original_filename)
      s = Roo::Openoffice.new(excel_path)
    elsif /(http:)/.match(params[:data_file].original_filename)
      
    else
      redirect_to user, :notice => "Error: file extension uncorrected"
    end
     
    if s.nil?
      redirect_to current_user, :notice => "Error occurred while convert process"
      return
    end
    csv_db_loader(s)
          
    cookies[:ui_location]="tab2"         
    redirect_to current_user, :notice =>"File Successfully uploaded."

  end
  private
    
    def csv_db_loader(rooObject) 
      if rooObject.nil?
        return 
      end
      #Note: csv convention => name,user@mail.com,054-1111111
      user=current_user
      rooObject.each do |elem|
        if elem[2].nil? && !elem[1].nil?    # dva stolbika
          elem[1]=elem[1].to_s
          elem[1].slice! "-"
          if is_a_valid_phone(elem[1]) 
            user.invites.new(:name=>elem[0],:number=>elem[1]).save
          end
        elsif !elem[0].nil? && elem[1].nil? && !elem[2].nil?
          elem[2]=elem[2].to_s
          elem[2].slice! "-"
          if is_a_valid_phone(elem[2]) 
            user.invites.new(:name=>elem[0],:number=>elem[2]).save
          end
        else
          elem[2]=elem[2].to_s
          elem[2].slice! "-"  
          if is_a_valid_email(elem[1]) && is_a_valid_phone(elem[2]) 
            user.invites.new(:name=>elem[0],:mail=>elem[1],:number=>elem[2]).save
          end  
        end         
        
      end
         
    end
        
    def is_a_valid_email(value)
      if /^([a-zA-Z0-9&_?\/`!|#*$^%=~{}+'-]+|"([\x00-\x0C\x0E-\x21\x23-\x5B\x5D-\x7F]|\\[\x00-\x7F])*")(\.([a-zA-Z0-9&_?\/`!|#*$^%=~{}+'-]+|"([\x00-\x0C\x0E-\x21\x23-\x5B\x5D-\x7F]|\\[\x00-\x7F])*"))*@([a-zA-Z0-9&_?\/`!|#*$^%=~{}+'-]+|\[([\x00-\x0C\x0E-\x5A\x5E-\x7F]|\\[\x00-\x7F])*\])(\.([a-zA-Z0-9&_?\/`!|#*$^%=~{}+'-]+|\[([\x00-\x0C\x0E-\x5A\x5E-\x7F]|\\[\x00-\x7F])*\]))*$/.match(value)
        return true
      else return false
      end
    end
    
    def is_a_valid_phone(value)
      if /(^0\d)-(\d\d\d\d\d\d\d{,1})|(^0\d\d)-(\d\d\d\d\d\d\d{,1})|(^0\d\d)(\d\d\d\d\d\d\d{,1})/.match(value) || value == ""
        return true      
      else return false
      end 
    end
    
    def self.import(file)
      spreadsheet = open_spreadsheet(file)
      header = spreadsheet.row(1)
      (2..spreadsheet.last_row).each do |i|
        row = Hash[[header, spreadsheet.row(i)].transpose]
        invite = find_by_id(row["id"]) || new
        invite.attributes = row.to_hash.slice(*accessible_attributes)
        invite.save!
      end
    end

    def self.open_spreadsheet(file)
      case File.extname(file.original_filename)
      when ".csv" then Csv.new(file.path, nil, :ignore)
      when ".xls" then Excel.new(file.path, nil, :ignore)
      when ".xlsx" then Excelx.new(file.path, nil, :ignore)
      else raise "Unknown file type: #{file.original_filename}"
      end
    end
    
    
end