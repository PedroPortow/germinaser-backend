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

Booking.create(
  room_id: 1, 
  user_id: 2, 
  start_time: Time.zone.now.beginning_of_day + 8.hours, 
  end_time: Time.zone.now.beginning_of_day + 9.hours, 
  status: 1
)
