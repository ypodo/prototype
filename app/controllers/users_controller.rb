# coding: utf-8
class UsersController < ApplicationController
include ApplicationHelper
require 'fastthread'

  before_filter :authenticate, :only => [:index,:edit, :update,:destroy,:show]
  before_filter :correct_user, :only => [:edit, :update, :show]
  before_filter :admin_user,   :only => :destroy
  before_filter :set_cache_buster

  def set_cache_buster
    response.headers["Cache-Control"] = "no-cache, no-store, max-age=0, must-revalidate"
    response.headers["Pragma"] = "no-cache"
    response.headers["Expires"] = "Fri, 01 Jan 1990 00:00:00 GMT"
  end
  def set_language
    #change user language in User 
    begin
      laguage=params[:user][:language]
      current_user.skip_callbacks = true
      current_user.update_attribute(:language, language)
      current_user.skip_callbacks = false
    rescue Exception => e
      logger.error { "#{e}" }  
    end
  end
  
  def wami
    if !File.directory? File.join('public','nfs-share',"#{user_from_remember_token.id}") # if directory not exist it will be created
      Dir.mkdir(File.join('public','nfs-share', "#{user_from_remember_token.id}")) # directory create
    end
    if !File.directory? File.join('private','nfs-share',"#{user_from_remember_token.id}") # if directory not exist it will be created
      Dir.mkdir(File.join('private','nfs-share', "#{user_from_remember_token.id}")) # directory create
    end
    File.open(File.join('public','nfs-share',"#{user_from_remember_token.id}","#{user_from_remember_token.audio_file[0].audio_hash}.wav"), "w+b") do |f|
      #f.write("first attempt")
      f.write(request.env["rack.input"].read)
      f.close()
    end
    convert_audio_to_sln
  end
  
  def wami_play
    @user = current_user
  end
  def upload
    #uplode_frame
    @user = current_user
    #rendered_data=render_to_string(:partial => "upload_frame")  
    render :partial => "upload_frame"
  end
  
  def load_recorder
    @user = current_user
    render :partial => "wami_recorder"
  end
    
  def recorder
    if !File.directory? File.join('public','nfs-share',"#{user_from_remember_token.id}") # if directory not exist it will be created
      Dir.mkdir(File.join('public','nfs-share', "#{user_from_remember_token.id}")) # directory create
    end
    if !File.directory? File.join('private','nfs-share',"#{user_from_remember_token.id}") # if directory not exist it will be created
      Dir.mkdir(File.join('private','nfs-share', "#{user_from_remember_token.id}")) # directory create
    end

    #copy audio to user section from temperory server section.
    @record_tmp=File.open(Rails.root.join(params[:record].tempfile.path), 'r').read
    
    #File.open(File.join('public','nfs-share',"#{user_from_remember_token.id}","#{user_from_remember_token.audio_file[0].audio_hash}.wav"), "w") do |f|
    File.open(File.join('public','nfs-share',"#{user_from_remember_token.id}","#{user_from_remember_token.audio_file[0].audio_hash}.wav"), "w+b") do |f|
      f.write(@record_tmp)
    end    
    convert_audio_to_sln    
  end
  
  def convert_audio_to_sln
    begin
      if File.exist?(File.join('public','nfs-share',"#{user_from_remember_token.id}","#{user_from_remember_token.audio_file[0].audio_hash}.wav"))              
        Kernel.system "private/nfs-share/scripts/convert_audio.sh #{user_from_remember_token.id} #{user_from_remember_token.audio_file[0].audio_hash}"        
      end
    rescue Exception => e
      logger.error("#{e}")
      UserMailer.error("convert_audio_to_sln, #{user_from_remember_token.id}")
    end 
  end
  
  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User destroyed."
    redirect_to users_path
  end
  
  def index
    @title = "All users"
    @users = User.all
  end
  
  def show 
    #show.html.rb will be renderen on the end    
    @user = User.find(params[:id])         
    @title = @user.name    
    
    #show all Invites belong to user_id in _inviteT.html.erb
    @invites=@user.invites    
    
    #used in _invite.html.erb
    @new_invite=Invite.new  
    
    #report and result
    if !@user.orders.last.nil?
      current_token=@user.orders.last.token
      @invite_history=@user.inviteHistorys.where(:token=>current_token)
    else
      @invite_history=nil
    end    
  end
  
  def create
    #create new user in User table
    if(User.find_by_email(params[:user][:email]).nil?) #if user not exist then create
      @user = User.new(params[:user])    
      @invites=@user.invites
      if @user.save      
        sign_in @user
        flash[:success] = "ברוכים הבאים לאתר מזמינים!"        

        #Digest::SHA2.hexdigest("2")[0..32]
        fileH=current_user.audio_file.new
        fileH.audio_hash=Digest::SHA2.hexdigest(fileH.user_id.to_s)[0..32]
        if !fileH.save
          flash[:error] = "ארעה שגיאה"
        end
        
#        if !File.directory? File.join('public','nfs-share',"#{user_from_remember_token.id}") # if directory not exist it will be created
#          Dir.mkdir(File.join('public','nfs-share', "#{user_from_remember_token.id}")) # directory create
#        end
#        if !File.directory? File.join('private','nfs-share',"#{user_from_remember_token.id}") # if directory not exist it will be created
#          Dir.mkdir(File.join('private','nfs-share', "#{user_from_remember_token.id}")) # directory create
#        end
#        File.open(File.join('public','nfs-share',"#{user_from_remember_token.id}","#{user_from_remember_token.audio_file[0].audio_hash}.wav"), "w+b") do |f|
#          f.write("")
#          f.close()
#        end        
       
        
        redirect_to categories_path
        UserMailer.registration_confirmation(@user)

      else
        @title = "התחברות לאתר"
        render 'new'
      end
    else
      flash[:error] ="משתמש עם כתובת דואר שסופקה קיים"
      redirect_to root_path
    end
    
  end
  
  def edit
    @user = User.find(params[:id])
    @title = "Edit user"
  end
  
  def update
    @user = User.find(params[:id])
    if @user.update_attributes(params[:user])
      flash[:success] = "Profile updated."
      redirect_to @user
    else
      @title = "Edit user"
      render 'edit'
    end
  end
  
  
################# START Ajax section
  def ajax_progress_call
    #Progress bar updating
    count=0
    last_token=current_user.orders.last.token
    if !last_token.nil?
      @invites = current_user.inviteHistorys.where(:token=>last_token)#User.find(user_from_remember_token.id).invites
      total_invites=@invites.count    
      @invites.each do |elem|
        if (elem.arriving.nil?)
          count+=1
        else
        end
      end  
    end
    
    total_completed=total_invites-count    
    #render(:text => "#{100/total_invites*total_completed}" )
    render :text => "#{100/total_invites*total_completed}" # return to client browser procent of complition
    #render(:text => "Total comlited:"+"#{total_completed}"+"\n Total invites:"+"#{total_invites}" )
  end
  def ajax_report
    # this function should dynamic update the report table
    @user=current_user
    current_token=@user.orders.last.token
    @invite_history=@user.inviteHistorys.where(:token=>current_token)            
    #render :text => ("#{@user.invites.count}"+":"+"#{count_comm}"+":"+"#{count_nil}")
    render :partial => 'users/invites_each', :object => @user
  end
  def ajax_report_sum    
    # this function should dynamic update the summery_report table              
    #report and result
    current_token=current_user.orders.last.token
    @invite_history=current_user.inviteHistorys.where(:token=>current_token)
    render :partial => 'users/report', :object => @invite_history # litle table with short description   
  end
  
  def ajax_report_mail_to
    begin
      current_token=current_user.orders.last.token
      if !current_token.nil?
        @invite_history=current_user.inviteHistorys.where(:token=>current_token)    
        report=render_to_string(:partial => "user_mailer/final_report")      
        UserMailer.send_mail_to_recipient(params[:mail],current_user,@invite_history)
        render :text => "Mail sent to #{params[:mail]}"
      end
    rescue Exception => e
      logger.error { "message: #{e}" }
    end    
  end
  
  def ajax_payment_details
    @user=current_user    
    render :partial => 'payment_details',:object =>@user
  end
  
# END AJAX
  private

    def authenticate
      deny_access unless signed_in?
    end
    
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_path) unless current_user?(@user)    
    end
    
    def admin_user
      redirect_to(root_path) unless current_user.admin?
    end
    
end
