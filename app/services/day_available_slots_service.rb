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

    existing_fixed_bookings = FixedBooking.where(room_id: @room.id, day_of_week: @date.wday)

    slots.reject! do |slot|
      slot_time = slot.strftime('%H:%M')

      existing_bookings.any? do |booking|
        booking_time = booking.start_time.in_time_zone('UTC').strftime('%H:%M')


        booking_time == slot_time && booking.canceled_at.nil?
      end


      existing_fixed_bookings.any? do |fixed_booking|
        fixed_start_time = fixed_booking.start_time.in_time_zone('UTC').strftime('%H:%M')
        fixed_end_time = fixed_booking.end_time.in_time_zone('UTC').strftime('%H:%M')

        (fixed_start_time <= slot_time && slot_time < fixed_end_time) && fixed_booking.canceled_at.nil?
      end
    end

    formatted_slots = slots.map { |slot| slot.strftime('%H:%M') }

    formatted_slots
  end
end
