require 'net/smtp'

def send_email(to,opts={})
  opts[:server]      ||= 'smtp.intel.com'
  opts[:from]        ||= 'prototype@mazminim.com'
  opts[:from_alias]  ||= 'Mazminim.com: notification mail'
  opts[:subject]     ||= "Hi #{@user}"
  opts[:body]        ||= "Important stuff!"

  msg = <<END_OF_MESSAGE
From: #{opts[:from_alias]} <#{opts[:from]}>
To: <#{to}>
Subject: #{opts[:subject]}

#{opts[:body]}
END_OF_MESSAGE

  Net::SMTP.start(opts[:server]) do |smtp|
    smtp.send_message msg, opts[:from], to
  end
end

send_email "yuri.shterenberg@intel.com", :body=> "test from rails app"