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

  def self.weekly_available_slots(date, room_id)
    start_of_week = date.beginning_of_week(:sunday)
    end_of_week = start_of_week.end_of_week(:sunday)

    weekly_slots = {}

    (start_of_week.to_date..end_of_week.to_date).each do |day|
      daily_slots = available_slots(day, room_id)
      
      formatted_slots = daily_slots.map { |slot| slot.strftime('%H:%M') }

      weekly_slots[day] = formatted_slots
    end

    weekly_slots
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
