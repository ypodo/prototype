File.open("/tmp/google1.txt", 'w') do |file| 
email=""
feed.elements.to_a('entry').each do |entry|
if (!entry.elements['gd:phoneNumber'].nil?)
entry.elements.each('gd:phoneNumber') do |number|
puts "*********************"

name=entry.elements['title'].text
entry.elements.each('gd:email') do |e|
email=e.attribute('address').value
end
number = number.to_s.split(">")[1].split("<")[0] 
puts number
#puts name, number, email

file.write("name: "+name.to_s)
file.write("\n")
file.write("number: "+number)
file.write("\n")
file.write("email: "+email.to_s)
file.write("\n")
email=""
end
end
end
end
