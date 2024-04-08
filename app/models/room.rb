class Room < ApplicationRecord
  belongs_to :clinic
  has_many :bookings

end
