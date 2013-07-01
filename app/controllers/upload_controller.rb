class UploadController < ApplicationController
include UsersHelper
require 'iconv'
require 'roo'
require 'gdata'
  before_filter :authenticate, :only => [:upload,:google_contacts]
  
  def upload_audio
    max_size=1048576
    if(params[:user]==current_user.id.to_s && params[:AUDIO_FILE].content_type == "audio/wav")
      if(File.size(params[:AUDIO_FILE].tempfile)<max_size)        
        if !File.directory? File.join('private','nfs-share',"#{user_from_remember_token.id}") # if directory not exist it will be created
          Dir.mkdir(File.join('private','nfs-share', "#{user_from_remember_token.id}")) # directory create      
        end        
        if !File.directory? File.join('public','nfs-share',"#{user_from_remember_token.id}") # if directory not exist it will be created
          Dir.mkdir(File.join('public','nfs-share', "#{user_from_remember_token.id}")) # directory create      
        end
        #copy audio to user section from temperory server section.
        @record_tmp=File.open(Rails.root.join(params[:AUDIO_FILE].tempfile.path), 'r').read    
        File.open(File.join('public','nfs-share',"#{user_from_remember_token.id}","#{user_from_remember_token.audio_file[0].audio_hash}.wav"), "w") do |f|
          f.write(@record_tmp)
        end    
        convert_audio_to_sln    
      end
       @color="true"
    else
       @color="false"
    end      
    @user = current_user   
    render :partial => "users/upload_frame", :color => @color  
  end
  
  def upload  #action 
    #params[:data_file]    
    if !/(.xlsx)|(.csv)/.match(params[:data_file].original_filename)    
      redirect_to user :notice =>"uploaded file extension is not correct"
      return
    end
    if !File.directory? File.join('private','nfs-share',"#{user_from_remember_token.id}",'csv') # if directory not exist it will be created
      Dir.mkdir(File.join('private','nfs-share', "#{user_from_remember_token.id}","csv")) # directory create
    end
    @uploaded_data=File.open(Rails.root.join(params[:data_file].tempfile.path), 'r').read
    File.open(Rails.root.join('private','nfs-share',"#{user_from_remember_token.id}","csv", params[:data_file].original_filename), 'w') do |file|
      file.write(@uploaded_data+".xlsx")
    end
    excel_path="private/nfs-share/#{user_from_remember_token.id}/csv/#{params[:data_file].original_filename}"
    
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
  def google_contacts
    login=params[:login]
    pass=params[:pass]
    if login.nil? || pass.nil?
      render :text => "Login or password is empty"
      return  
    end
    matching=0    
    raw_data=get_raw_data_from_google_contacts(login,pass)
    if raw_data.nil?
      flash[:notice] = "Something goes wrong, please try again."
      redirect_to current_user
      return
    end
    list=parse_name_number_email(raw_data)
    if list.nil? #error
      render :text=> "Error accured while Google contact adta parsing"
      return false
    else      
      list.each do |elem|
        name=elem[0]
        email=elem[1]
        number=elem[2]        
        number=normalize_phone(number)
        number=number_correction(number)        
        if is_a_valid_name(name) && is_a_valid_phone(number)
          if is_a_valid_email(email) #if mail exist            
            current_user.invites.new(:name=>name,:number=>number,:mail=>email).save
            matching+=1          
          else #mail not existe
            current_user.invites.new(:name=>name,:number=>number).save
            matching+=1
          end          
        else          
        end
      end
    end
    cookies[:ui_location]="tab2"         
    redirect_to current_user, :notice =>"Google contacts successfully uploaded. #{matching}"
  end
  private
    def authenticate
      deny_access unless signed_in?
    end
    
    def number_correction(number)
      number
    end
    
    def csv_db_loader(rooObject) 
      if rooObject.nil?
        return 
      end
      #Note: csv convention => name,user@mail.com,054-1111111
      user=current_user
      rooObject.each do |elem|
        if elem[2].nil? && !elem[1].nil?    # dva stolbika
          elem[1]=elem[1].to_s.gsub(/\D/, '')
          if is_a_valid_phone(elem[1]) 
            user.invites.new(:name=>elem[0],:number=>elem[1]).save
          end
        elsif !elem[0].nil? && elem[1].nil? && !elem[2].nil?
          elem[2]=elem[2].to_s.gsub(/\D/, '')
          if is_a_valid_phone(elem[2]) 
            user.invites.new(:name=>elem[0],:number=>elem[2]).save
          end
        else
          elem[2]=elem[2].to_s.gsub(/\D/, '')          
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
      if /(^0\d)-(\d\d\d\d\d\d\d{,1})|(^0\d\d)-(\d\d\d\d\d\d\d{,1})|(^0\d\d)(\d\d\d\d\d\d\d{,1})/.match(value)
        return true      
      else return false
      end 
    end
    
    def is_a_valid_name(value)
      if !value.nil? && value.length < 20  
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
    
    def normalize_phone(number)
      if !number.nil?
        number.gsub(/\D/, '')
      else
        return false        
      end
    end
    
    def parse_name_number_email(data)
      email=""
      list=[]
      if !data.nil?
        data.elements.to_a('entry').each do |entry|
          if (!entry.elements['gd:phoneNumber'].nil?)
            entry.elements.each('gd:phoneNumber') do |number|
              name=entry.elements['title'].text
              entry.elements.each('gd:email') do |e|
                email=e.attribute('address').value
              end
              number = number.to_s.split(">")[1].split("<")[0]        
            list.push([name, email, number]) 
            email=""
            end
          end
        end
      end
      return list
    end
    
    def get_raw_data_from_google_contacts(login,password)
      begin
        _CONTACTS_SCOPE = 'http://www.google.com/m8/feeds/'
        _CONTACTS_FEED = _CONTACTS_SCOPE + 'contacts/default/full/?max-results=1000'
        @client = GData::Client::Contacts.new
        @client.clientlogin(login, password, @captcha_token, @captcha_response)      
        feed = @client.get(_CONTACTS_FEED).to_xml
      rescue Exception => e                
        return nil
      end
    end
    
    
    
end