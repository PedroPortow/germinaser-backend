class BookingsController < ApplicationController
  before_action :set_room, only: [:create]
  before_action :set_booking, only: [:show, :update, :destroy] 
  before_action :set_bookings, only: [:index] 


  # GET /bookings
  def index
    render json: @bookings
  end

  # GET /bookings/:id
  def show
    render json: @booking
  end

  # POST /bookings
  def create
    if current_user.owner? || current_user.credits > 0
      if Booking.is_available?(@room.id, booking_params[:start_time])
        @booking = @room.bookings.build(booking_params.merge(user: current_user))
  
        if @booking.save
          current_user.decrement!(:credits) unless current_user.owner?
  
          BookingRefundJob.perform_later(@booking.id)
          render json: @booking, status: :created
        else
          render json: @booking.errors, status: :unprocessable_entity
        end
      else
        render json: { error: 'Este horário já está reservado' }, status: :unprocessable_entity
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
      current_user.increment!(:credits) unless current_user.owner?
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
    date_param = params[:date].
    room_id = params[:room_id]
    available_slots = Booking.available_slots(date, room_id)

    date = Date.parse(date_param)

    render json: available_slots.map { |slot| slot.strftime('%Y-%m-%d %H:%M:%S') }
  end
  def weekly_slots
    date_param = params.dig(:booking, :date)
    room_id = params.dig(:booking, :room_id)
  
    if date_param.present?
      date = Date.parse(date_param)
      slots = Booking.weekly_available_slots(date, room_id)
      render json: slots
    else
      render json: { error: "Data é necessária." }, status: :bad_request
    end
  rescue ArgumentError
    render json: { error: "Formato de data inválido." }, status: :unprocessable_entity
  end
  
  
  private
  
  def set_room
    room_id = params.dig(:booking, :room_id)
    @room = Room.find(room_id)
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Sala não encontrada." }, status: :not_found
  end

  def set_booking
    @booking = Booking.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Reserva não encontrada." }, status: :not_found
  end

  def set_bookings
    @bookings = current_user.bookings
  end

  def booking_params
    params.require(:booking).permit(:start_time, :room_id) 
  end
end
