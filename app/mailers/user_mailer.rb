class UserMailer < ActionMailer::Base
require 'mail'

  default from: "mazminim.com@gmail.com"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.password_reset.subject
  #
  def password_reset(user)
    @user = user
    mail :to => user.email, :subject => "Password Reset"
  end
  
  
  def report_on_completion(user, data, subject,to)      
    send_mail(user, data, subject,to)
  end
  
  def registration_confirmation(user)
    subject="Hello #{user.name}. Wellcome to mazminim."
    data="Hello #{user.name}. Wellcome to mazminim. Your user name is: #{user.email}    To start using our services browse to mazminim.com and enjoy.
                          For any problems or questions occurring during using service, contact us from support page or direct mail to: mazminim.com@gmail.com"
    send_mail(user, data, subject,'yuri.shterenberg@gmail.com')
  end
  
  private
   
    def send_mail(user,data,subject,to)      
      data ||="Body"
      subject ||= "deafult subject"
      to ||=user.email
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
