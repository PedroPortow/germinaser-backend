# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

owner = User.create(email: "owner@gmail.com", password: "123456", role: "owner", credits: 50)
admin = User.create(email: "admin@gmail.com", password: "123456", role: "admin", credits: 50)
user = User.create(email: "user@gmail.com", password: "123456", role: "user", credits: 50)

clinic1 = Clinic.create(name: "Casa 1", address: "endereco legal")
clinic2 = Clinic.create(name: "Casa 2", address: "endereco legal 2")

room1 = Room.create(name: "Sala Azul", clinic: clinic1)
room2 = Room.create(name: "Sala Rosa", clinic: clinic1)
room3 = Room.create(name: "Sala 42", clinic: clinic2)
room4 = Room.create(name: "Sala 3", clinic: clinic2)

Booking.create(room: room1, user: user, start_time: Time.zone.now)
Booking.create(room: room1, user: user, start_time: 1.day.since(Time.zone.now))
Booking.create(room: room1, user: user, start_time: 2.day.since(Time.zone.now))
Booking.create(room: room2, user: user, start_time: 3.day.since(Time.zone.now))
Booking.create(room: room2, user: user, start_time: 4.day.since(Time.zone.now))
Booking.create(room: room3, user: user, start_time: 5.day.since(Time.zone.now))
Booking.create(room: room4, user: user, start_time: 6.day.since(Time.zone.now))
Booking.create(room: room2, user: user, start_time: 7.day.since(Time.zone.now))
Booking.create(room: room2, user: user, start_time: 8.day.since(Time.zone.now))
