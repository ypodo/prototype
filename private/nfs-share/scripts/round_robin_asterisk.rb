#!/usr/bin/env ruby
#create call files
#/home/ubuntu/prototype/public/nfs-share/scripts
asterisk="10.0.0.1","10.0.0.2","10.0.0.3"

def test
  ping("127.0.0.1")
end

def ping(ip)
  ping_count = 3  
  result = `ping -q -c #{ping_count} #{ip}`
  if ($?.exitstatus == 0)
    return true
  end  
end

test