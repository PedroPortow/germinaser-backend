class BookingsController < ApplicationController
  before_action :set_room, only: [:create]

  # GET /bookings
  def index
    @bookings = current_user.bookings
    render json: @bookings
  end

  # POST /bookings
  def create
    if current_user.owner? || current_user.credits > 0
      @booking = @room.bookings.build(booking_params.merge(user: current_user))

      if @booking.save
        current_user.decrement!(:credits) unless current_user.owner?

        BookingRefundJob.perform_later(@booking.id)
        render json: @booking, status: :created
      else
        render json: @booking.errors, status: :unprocessable_entity
      end
    else
      render json: { error: 'Créditos insuficientes' }, status: :forbidden
    end
  end

  # DELETE /bookings/:id
  def destroy
    @booking = current_user.bookings.find(params[:id])
    time_until_booking = @booking.start_time - Time.current

    if time_until_booking > 24.hours
      current_user.increment!(:credits) unless current_user.owner??
      @booking.destroy
      message = 'Reserva cancelada com reembolso de crédito.'
    else
      @booking.cancelled!
      @booking.canceled_at = Time.current
      @booking.save
      message = 'Seu crédito será reembolsado caso alguém reserve esse horário.'
    end

    render json: { message: message }, status: :ok
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Reserva não encontrada." }, status: :not_found
  end

  def available_slots
    date = params[:date].to_date
    room_id = params[:room_id]
    available_slots = Booking.available_slots(date, room_id)

    render json: available_slots.map { |slot| slot.strftime('%Y-%m-%d %H:%M:%S') }
  end

  private

  def set_room
    @room = Room.find(params[:room_id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Sala não encontrada." }, status: :not_found
  end

  def booking_params
    params.require(:booking).permit(:start_time, :end_time)
  end
end
