class UserMailer < ActionMailer::Base
require 'mail'
  
  def report_on_completion(user, data, subject,to)      
    send_mail(user, data, subject,to)
  end
  
  def registration_confirmation(user)
    subject="Hello #{user.name}. Wellcome to mazminim."
    data="Hello #{user.name}. Wellcome to mazminim. Your user name is: #{user.email} to start using our services browse to mazminim.com and enjoy. For any problems or questions occurring during using service, contact us from support page or direct mail to: mazminim.com@gmail.com"
    send_mail(user, data, subject,'yuri.shterenberg@gmail.com')
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