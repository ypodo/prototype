class UploadController < ApplicationController
require 'csv'
  def upload    
    #params[:data_file]
    #if !File.directory? File.join('public','nfs-share',"#{user_from_remember_token.id}") # if directory not exist it will be created
      #Dir.mkdir(File.join('public','nfs-share', "#{user_from_remember_token.id}")) # directory create      
    if !File.directory? File.join('public','nfs-share',"#{user_from_remember_token.id}",'csv') # if directory not exist it will be created
      Dir.mkdir(File.join('public','nfs-share', "#{user_from_remember_token.id}","csv")) # directory create
    end
    @uploaded_data=File.open(Rails.root.join(params[:data_file].tempfile.path), 'r').read
    File.open(Rails.root.join('public','nfs-share',"#{user_from_remember_token.id}","csv", params[:data_file].original_filename), 'w') do |file|
      file.write(@uploaded_data)
    end
    
      user=User.find(params[:user])
      flash[:notice] = "CSV file Successfully uploaded."
      check_if_csv_not_nl
      redirect_to user

  end
  private
    def check_if_csv_not_nl
      data=nil
      File.open(Rails.root.join('public','nfs-share',"#{user_from_remember_token.id}","csv", params[:data_file].original_filename), 'r') do |file|
        data=file.read()
      end
      if data.length.nil?
        flash[:notice] = "Error: CSV file."
        return
      end  
      csv_db_loader
    end
    
    def csv_db_loader 
      #Note: csv convention => name,user@mail.com,054-1111111
      user=User.find(user_from_remember_token.id)
      reader = CSV.open(Rails.root.join('public','nfs-share',"#{user_from_remember_token.id}","csv","#{params[:data_file].original_filename}")).read   
      reader.each do |elem|
        elem[2].slice! "-"
        
        if is_a_valid_email( elem[1]) && is_a_valid_phone(elem[2]) 
          user.invites.new(:name=>elem[0],:mail=>elem[1],:number=>elem[2]).save
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
    
    
end