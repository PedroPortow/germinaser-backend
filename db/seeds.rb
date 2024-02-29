# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

Role.create(name: "Owner", description: "Has all permissions and doesnt have to use credits")
Role.create(name: "Admin", description: "Has all permissions but has to use credits")
Role.create(name: "User", description: "Normal user")

owner_role = Role.find_by(name: "Owner").id
admin_role = Role.find_by(name: "Admin").id
user_role = Role.find_by(name: "User").id

User.create(name: "Owner", email: "owner@gmail.com", password: "123456", role_id: owner_role)
User.create(name: "Admin", email: "admin@gmail.com", password: "123456", role_id: admin_role, credits: 50)
User.create(name: "User",  email: "user@gmail.com", password: "123456", role_id: user_role, credits: 50)

Clinic.create(name: "Casa 1", adress: "endereco legal")
Clinic.create(name: "Casa 2", adress: "endereco legal")

first_clinic = Clinic.find_by(name: "Casa 1").id
second_clinic = Clinic.find_by(name: "Casa 2").id

Room.create(name: "Sala 1", clinic_id: first_clinic)
Room.create(name: "Sala 2", clinic_id: first_clinic)
Room.create(name: "Sala 1", clinic_id: second_clinic)
Room.create(name: "Sala 2", clinic_id: second_clinic)

puts "Criando bookings...."
Room.all.each do |room|
  user = User.where(role: [admin_role, user_role]).sample
  
  (8..21).each do |hour|
    Booking.create(
      room_id: room.id,
      user_id: user.id,
      start_time: Time.zone.today.beginning_of_day + hour.hours,
      end_time: Time.zone.today.beginning_of_day + (hour + 1).hours,
      status: ['active', 'cancelled', 'refunded'].sample 
    )
  end
end

puts "bookings criados com sucesso."
