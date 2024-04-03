# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

User.create(email: "owner@gmail.com", password: "123456", role: "owner", credits: 50)
User.create(email: "admin@gmail.com", password: "123456", role: "admin", credits: 50)
User.create(email: "user@gmail.com", password: "123456", role: "user", credits: 50)

Clinic.create(name: "Casa 1", address: "endereco legal")
Clinic.create(name: "Casa 2", address: "endereco legal 2")

Room.create(name: "Sala 1 - Clinica 1", clinic_id: 1)
Room.create(name: "Sala 2 - Clinica 1", clinic_id: 1)
Room.create(name: "Sala 1 - Clinica 2", clinic_id: 2)
Room.create(name: "Sala 2 - Clinica 2", clinic_id: 2)
