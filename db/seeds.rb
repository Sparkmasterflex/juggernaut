puts "Creating User"
if User.find_by_email("raymondke99@gmail.com").nil?
  User.create({
    :first_name => "Keith",
    :last_name => "Raymond",
    :email => "raymondke99@gmail.com",
    :password => "password",
    :password_confirmation => "password"
  })
  
  puts "Keith Raymond created..."
else
  puts "Keith Raymond already in system..."
end
