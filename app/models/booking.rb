class Booking < ApplicationRecord
  belongs_to :room
  belongs_to :user

  has_one :cancelation

  enum status: { active: 0, cancelled: 1, refunded: 2 }

  
end
