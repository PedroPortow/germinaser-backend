class BookingRefundJob < ApplicationJob
  queue_as :default

  def perform(booking_id)
    booking = Booking.find_by(id: booking_id)
    return unless booking && booking.status == 'cancelled'

    canceled_bookings = Booking.where(
      room_id: booking.room_id,
      start_time: booking.start_time,
      end_time: booking.end_time,
      status: 'cancelled'
    )

    canceled_bookings.each do |canceled_booking|
      user_to_refund = User.find(canceled_booking.user_id)
      if user_to_refund.present? && !user_to_refund.is_owner?
        user_to_refund.increment!(:credits)
        canceled_booking.update(status: 'refunded')
      end
    end
  end
end
