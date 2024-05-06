class DayAvailableSlotsService
  def initialize(room_id, date)
    @room = Room.find(room_id)
    @date = date.in_time_zone('Brasilia')
  end

  def call
    Time.zone = 'Brasilia'

    start_period = @date.beginning_of_day + 8.hours
    end_period = @date.beginning_of_day + 21.hours

    slots = (start_period.to_i..end_period.to_i).step(1.hour).map { |t| Time.zone.at(t) }

    current_time = Time.zone.now

    if @date.today?
      slots = slots.select { |slot| slot > current_time }
    end

    existing_bookings = Booking.where(room_id: @room.id, start_time: start_period...end_period)

    slots.reject! do |slot|
      existing_bookings.any? { |booking| booking.start_time.in_time_zone('Brasilia').strftime('%H:%M') == slot.strftime('%H:%M') && booking.canceled_at.nil? }
    end

    formatted_slots = slots.map { |slot| slot.strftime('%H:%M') }

    formatted_slots
  end
end
