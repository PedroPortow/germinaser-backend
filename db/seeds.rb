# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

owner = User.create(email: "owner@gmail.com", password: "123456", role: "owner", credits: 50, name: "Pedro Porto")
admin = User.create(email: "admin@gmail.com", password: "123456", role: "admin", credits: 50, name: "Maurício Farias")
admin = User.create(email: "admin@gmail.com", password: "123456", role: "admin", credits: 50, name: "Marcio")
user = User.create(email: "user@gmail.com", password: "123456", role: "user", credits: 50, name:"Deisi Moura Rodrigues")

clinic1 = Clinic.create(name: "Casa 1", address: "endereco legal")
clinic2 = Clinic.create(name: "Casa 2", address: "endereco legal 2")

room1 = Room.create(name: "Sala Azul", clinic: clinic1)
room2 = Room.create(name: "Sala Rosa", clinic: clinic1)
room3 = Room.create(name: "Sala 42", clinic: clinic2)
room4 = Room.create(name: "Sala 3", clinic: clinic2)

start_date = Time.zone.tomorrow

Booking.create(name: "Reserva ANTIGA (criado com data anterior)", room: room1, user: owner, start_time: start_date - 1.day)

Booking.create(name: "Reserva Pedro", room: room1, user: owner, start_time: start_date)
Booking.create(name: "Reserva teste 2", room: room2, user: owner, start_time: start_date + 1.day)
Booking.create(name: "Reserva teste 3", room: room3, user: owner, start_time: start_date + 2.day)
Booking.create(name: "Reserva teste 4", room: room1, user: owner, start_time: start_date + 3.day)
Booking.create(name: "Reserva teste 5", room: room2, user: owner, start_time: start_date + 5.day)