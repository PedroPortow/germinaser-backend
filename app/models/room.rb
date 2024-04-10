class Room < ApplicationRecord
  belongs_to :clinic
  has_many :bookings

  validates :clinic, presence: true, uniqueness: true
  validates :name, presence: true, uniqueness: true
end
