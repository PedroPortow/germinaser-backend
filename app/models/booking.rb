class Booking < ApplicationRecord
  belongs_to :room
  belongs_to :user
  before_create :consume_credit_if_needed

  def clinic
    room.clinic
  end

  private 

  def consume_credit_if_needed
    return if user.owner?
    raise "Créditos insuficientes" if user.credits <= 0

    user.decrement!(:credits)
  end
end
