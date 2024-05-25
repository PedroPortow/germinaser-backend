if Rails.env.development? || Rails.env.test?
  require 'dotenv'
  Dotenv.load
end

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

default_user = User.create!(name: ENV['DEFAULT_USER_NAME'], email: ENV['DEFAULT_USER_EMAIL'], password: ENV['DEFAULT_USER_PASSWORD'], credits: 999, role: "owner")
owner = User.create!(name: ENV['OWNER_NAME'], email: ENV['OWNER_EMAIL'], password: ENV['OWNER_PASSWORD'], credits: 999, role: "owner")

clinic1 = Clinic.create!(name: "Casa 1", address: "R. Voluntários da Pátria, 684")
clinic2 = Clinic.create!(name: "Casa 2", address: "R. Tiradentes, 2306")

Room.create!(name: "Sala Azul", clinic: clinic1)
Room.create!(name: "Sala Rosa", clinic: clinic1)
Room.create!(name: "Sala Verde", clinic: clinic1)
yellow_room = Room.create!(name: "Sala Amarela", clinic: clinic1) # Has fixed booking

Room.create!(name: "Sala 1", clinic: clinic2)
Room.create!(name: "Sala 2", clinic: clinic2)
Room.create!(name: "Sala 3", clinic: clinic2)
Room.create!(name: "Sala 4", clinic: clinic2)
Room.create!(name: "Sala 5", clinic: clinic2)

# Segunda
FixedBooking.create!(
  name: 'Reserva Fixa Deisi - Segunda',
  room: yellow_room,
  user: owner,
  day_of_week: 1, 
  start_time: '08:00',
  end_time: '12:00'
)

# Segunda
FixedBooking.create!(
  name: 'Reserva Fixa Deisi - Segunda',
  room: yellow_room,
  user: owner,
  day_of_week: 1, 
  start_time: '17:00',
  end_time: '19:00'
)

# Terça
FixedBooking.create!(
  name: 'Reserva Fixa Deisi - Terça',
  room: yellow_room,
  user: owner,
  day_of_week: 2, 
  start_time: '08:00',
  end_time: '19:00'
)

# Quarta
FixedBooking.create!(
  name: 'Reserva Fixa Deisi - Quarta',
  room: yellow_room,
  user: owner,
  day_of_week: 3, 
  start_time: '08:00',
  end_time: '12:00'
)

# Quarta
FixedBooking.create!(
  name: 'Reserva Fixa Deisi - Quarta',
  room: yellow_room,
  user: owner,
  day_of_week: 3, 
  start_time: '17:00',
  end_time: '19:00'
)

# Quinta
FixedBooking.create!(
  name: 'Reserva Fixa Deisi - Quinta',
  room: yellow_room,
  user: owner,
  day_of_week: 4, 
  start_time: '08:00',
  end_time: '19:00'
)

# Sexta
FixedBooking.create!(
  name: 'Reserva Fixa Deisi - Sexta',
  room: yellow_room,
  user: owner,
  day_of_week: 5, 
  start_time: '08:00',
  end_time: '19:00'
)
