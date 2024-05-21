# lib/tasks/setup.rake
namespace :setup do
  desc 'Create a user with provided email, password, and role'
  task create_user: :environment do
    require 'io/console'

    print "Enter email: "
    email = STDIN.gets.chomp

    print "Enter password: "
    password = STDIN.noecho(&:gets).chomp
    puts "\n"

    print "Enter role (user, admin, owner): "
    role = STDIN.gets.chomp

    if User.roles.keys.include?(role)
      user = User.find_or_create_by!(email: email) do |user|
        user.password = password
        user.password_confirmation = password
        user.role = role
      end

      if user.persisted?
        puts "User #{user.email} with role #{user.role} created or already exists."
      else
        puts "Failed to create user."
      end
    else
      puts "Invalid role. Please enter one of the following: #{User.roles.keys.join(', ')}"
    end
  end
end
