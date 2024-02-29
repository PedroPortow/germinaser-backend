class Booking < ApplicationRecord
  belongs_to :room
  belongs_to :user
  before_create :set_default_status
  before_create :set_end_time

  has_one :cancelation

  enum status: { active: 0, cancelled: 1, refunded: 2 }

  def self.available_slots(date, room_id = nil)
    start_period = date.beginning_of_day + 8.hours
    end_period = date.beginning_of_day + 21.hours 
    slots = (start_period.to_i..end_period.to_i).step(1.hour).map { |t| Time.zone.at(t) }
  
    existing_bookings = where(room_id: room_id, start_time: start_period...end_period)
  
    existing_bookings.each do |booking|
      slots.reject! { |slot| slot == booking.start_time }
    end
  
    slots
  end
  

  def self.is_available?(room_id, start_time)
    !exists?(room_id: room_id, start_time: start_time)
  end

  private

  def set_default_status
    self.status ||= :active
  end

  def set_end_time
    self.end_time = self.start_time + 1.hour
  end
end
