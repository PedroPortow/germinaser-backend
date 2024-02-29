class Room < ApplicationRecord
  belongs_to :clinic
  has_many :bookings

  validates :name, presence: true, uniqueness: { scope: :clinic_id, message: 'O nome da sala deve ser único dentro da mesma clínica' }
  validates :clinic_id, presence: true
end
