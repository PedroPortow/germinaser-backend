class BookingsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_booking, only: [:show, :update, :destroy]
  # before_action :check_permission, only: [:create, :update, :destroy]

  def index
    @bookings = Booking.all
    render json: BookingSerializer.new(@bookings).serializable_hash, status: :ok
  end

  def show
    render json: BookingSerializer.new(@booking).serializable_hash, status: :ok
  end

  def create
    @booking = current_user.bookings.build(booking_params)

    if @booking.save
      render json: BookingSerializer.new(@booking).serializable_hash, status: :created
    else
      render json: @booking.errors, status: :unprocessable_entity
    end
  rescue StandardError => e
    render json: { error: e.message }, status: :unprocessable_entity
  end


  def update
    if @booking.update(booking_params)
      render json: BookingSerializer.new(@booking).serializable_hash, status: :ok
    else
      render json: @booking.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @booking.destroy
    head :no_content
  end

  private

  def set_booking
    @booking = Booking.find(params[:id])
  end

  def booking_params
    params.require(:booking).permit(:room_id, :start_time, :canceled_at)
  end
end
