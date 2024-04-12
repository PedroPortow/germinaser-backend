class Room < ApplicationRecord
  belongs_to :clinic
  has_many :bookings

  validates :clinic, presence: true
  validates :name, presence: true, uniqueness: { scope: :clinic_id, message: "O nome da sala deve ser único dentro de cada clínica" }
end
