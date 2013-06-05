class UsersController < ApplicationController
include ApplicationHelper
require 'fastthread'

  before_filter :authenticate, :only => [:index,:edit, :update,:destroy,:show]
  before_filter :correct_user, :only => [:edit, :update, :show]
  before_filter :admin_user,   :only => :destroy
  
  def export_google_contacts
    
  end
  
  def wami
    params
  end
  def recorder        
    if !File.directory? File.join('public','nfs-share',"#{user_from_remember_token.id}") # if directory not exist it will be created
      Dir.mkdir(File.join('public','nfs-share', "#{user_from_remember_token.id}")) # directory create      
    end
    #copy audio to user section from temperory server section.
    @record_tmp=File.open(Rails.root.join(params[:record].tempfile.path), 'r').read
    
    File.open(File.join('public','nfs-share',"#{user_from_remember_token.id}","#{user_from_remember_token.id}.wav"), "w") do |f|
      f.write(@record_tmp)
    end    
    convert_audio_to_sln    
  end
  
  def convert_audio_to_sln
    if File.exist?(File.join('public','nfs-share',"#{user_from_remember_token.id}","#{user_from_remember_token.id}.wav"))              
      Kernel.system "public/nfs-share/scripts/convert_audio.sh #{user_from_remember_token.id}"        
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
        flash[:success] = "Welcome to the Mazminim.com you can start using the service!"
        UserMailer.registration_confirmation(@user)
        redirect_to @user
        # Обработка успешного сохранения.
      else
        @title = "Please sign up"
        render 'new'
      end
    else
      flash[:error] ="User with same email already exist"
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
    if current_user.orders.last.nil? && params[:mail].nil?
      render :text => "Mail could not be sent nil invites found"    
    else
      current_token=current_user.orders.last.token
      if !current_token.nil?
        @invite_history=current_user.inviteHistorys.where(:token=>current_token)
        report=render_to_string(:partial => "report/full_report_mail")    
        UserMailer.report_on_completion(current_user,report,"User Report after calling process complited",params[:mail])
        render :text => "Mail sent to #{params[:mail]}"
      end
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
