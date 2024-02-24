class BookingRefundJob < ApplicationJob
  queue_as :default

  def perform(booking_id)
    new_booking = Booking.find_by(id: booking_id)
    return unless new_booking&.active?

    cancelled_bookings = Booking.where(room: new_booking.room, start_time: new_booking.start_time, status: 'cancelled')
                                .where('canceled_at > ?', 24.hours.ago)

    cancelled_bookings.find_each do |cancelled_booking|
      next if cancelled_booking.refunded?

      user = cancelled_booking.user
      user.increment!(:credits)
      cancelled_booking.update(status: 'refunded')

      # TODO: Enviar EMAIL pro usuário
    end
  end
end
