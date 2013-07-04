class UserMailer < ActionMailer::Base
require 'mail'

  default from: "mazminim.com@gmail.com"
  def password_reset(user)
    @user = user
    #send_mail(user,data,subject,to)
    data =  render_to_string :partial => "user_mailer/password_reset"
    subject= "password reset"
    send_mail(user, data, subject,user.email)
  end
  
  
  def report_on_completion(user)
    if user
      begin
        @user=user
        data=render_to_string :partial => "user_mailer/final_report"
        subject="Call process completed for #{user.name}."
        send_mail(user, data, subject)
      rescue Exception => e
        logger.error { "message: #{e.message}" }
      end          
    end      
    
  end
  
  def send_mail_to_recipient(mail_to_recipient,user,invites)
    begin
      if mail_to_recipient
        to=mail_to_recipient
        @user=user
        @invite_history=invites
        data=render_to_string :partial => "user_mailer/final_report"
        subject="Call process completed for #{user.name}."
        send_mail(user, data, subject,to)  
      end
    rescue Exception => e
      logger.error { "message: #{e.message}" }
    end 
  end
  
  def registration_confirmation(user)    
    begin
      @user=user
      subject="Hello #{user.name} and welcome to mazminim.com!"    
      walcome_html=render_to_string(:partial => "user_mailer/welcome")
      send_mail(user, walcome_html, subject,user.email)
    rescue Exception => e
      logger.error { "message: #{e.message}" }
    end
  end
  def error(message)
    begin          
      send_error_mail(message, "Error",'mazminim.com@gmail.com')
    rescue Exception => e
      logger.error { "message: #{e.message}" }
    end
  end
  def notify(message)
    begin          
      send_error_mail(message, "Notification",'mazminim.com@gmail.com')
    rescue Exception => e
      logger.error { "message: #{e.message}" }
    end
  end
  private
    def auth
      Mail.defaults do
        delivery_method :smtp, { 
          :address => 'smtp.gmail.com',
          :port => '587',
          :user_name => "mazminim.com@gmail.com",
          :password => "8ik,*IK<",
          :authentication => :plain,
          :enable_starttls_auto => true
        }
      end
    end
    def send_mail(user,data,subject,to)      
      data ||="Body"
      subject ||= "deafult subject"
      to ||=user.email
      auth
      mail = Mail.new do
        from    'Mazminim, automatic calling system'
        to      to
        subject subject
        
        html_part do
          content_type 'text/html; charset=UTF-8'
          body data
        end
            
      end
      mail.deliver!      
    end
    def send_mail(user,data,subject)      
      data ||="Body"
      subject ||= "deafult subject"
      auth
      mail = Mail.new do
        from    'Mazminim, automatic calling system'
        to      user.email
        subject subject
        
        html_part do
          content_type 'text/html; charset=UTF-8'
          body data
        end
            
      end
      mail.deliver!      
    end
    def send_error_mail(data,subject,to)      
      data ||="Body"
      subject ||= "deafult subject"      
      auth
      mail = Mail.new do
        from    'Mazminim automatic calling system'
        to      to
        subject subject
        
        html_part do
          content_type 'text/html; charset=UTF-8'
          body data
        end
            
      end
      mail.deliver!      
    end

end
