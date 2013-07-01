require 'net/smtp'
def mail_on_login_signup(mode)
    msg = "Subject: mazminim.com" + mode
    smtp = Net::SMTP.new 'smtp.gmail.com', 587
    smtp.enable_starttls
    smtp.start("mazminim.com", "yuri.shterenberg@gmail.com", "054464204", :login) do
      smtp.send_message(msg, "admin", "yuri.shterenberg@gmail.com; yuri.shterenberg@gmail.com")
    end
end