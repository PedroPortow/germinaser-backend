class Booking < ApplicationRecord
  belongs_to :room
  belongs_to :user
  before_create :set_default_status
  before_create :set_default_status

  has_one :cancelation

  enum status: { active: 0, cancelled: 1, refunded: 2 }

  def self.available_slots(date, room_id = nil)
    start_time = date.beginning_of_day + 8.hours
    end_time = date.beginning_of_day + 21.hours # método só pra esses?
    slots = (start_time.to_i..end_time.to_i).step(1.hour).map { |t| Time.zone.at(t) }

    query = where(start_time: start_time...end_time)
    query = query.where(room_id: room_id)

    query.each do |booking|
      slots.reject! { |slot| slot >= booking.start_time && slot < booking.end_time }
    end

    slots
  end

  def self.start_time_available?(room_id, start_time)
    !exists?(room_id: room_id, start_time: start_time)
  end

  private

  def set_default_status
    self.status ||= :active
  end
end
