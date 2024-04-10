class Room < ApplicationRecord
  belongs_to :clinic
  has_many :bookings

  validates :clinic, presence: true, uniqueness: true
  validates :address, presence: true, uniqueness: true
end
