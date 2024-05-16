class FixedBookingsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_fixed_booking, only: [:show, :update, :destroy, :cancel]

  # GET /fixed_bookings
  def index
    @fixed_bookings = FixedBooking.page(params[:page]).per(params[:per_page])
    render json: @fixed_bookings, meta: pagination_info(@fixed_bookings), adapter: :json, status: :ok
  end

  # GET /fixed_bookings/:id
  def show
    render json: @fixed_booking, status: :ok
  end

  # POST /fixed_bookings
  def create
    @fixed_booking = FixedBooking.new(fixed_booking_params)
    if @fixed_booking.save
      render json: @fixed_booking, status: :created
    else
      render json: @fixed_booking.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /fixed_bookings/:id
  def update
    if @fixed_booking.update(fixed_booking_params)
      render json: @fixed_booking, status: :ok
    else
      render json: @fixed_booking.errors, status: :unprocessable_entity
    end
  end

  # DELETE /fixed_bookings/:id
  def destroy
    @fixed_booking.destroy
    render json: { message: 'Fixed booking was successfully destroyed.' }, status: :ok
  end

  def cancel
    if @fixed_booking.cancel
      render json: { message: "Reserva fixa cancelada com sucesso." }, status: :ok
    else
      render json: { error: "Falha ao cancelar a reserva fixa." }, status: :unprocessable_entity
    end
  end

  private

  def set_fixed_booking
    @fixed_booking = FixedBooking.find(params[:id])
  end

  def fixed_booking_params
    params.require(:fixed_booking).permit(:room_id, :user_id, :day_of_week, :start_time, :end_time, :name)
  end

  def pagination_info(fixed_bookings)
    {
      current_page: fixed_bookings.current_page,
      next_page: fixed_bookings.next_page,
      prev_page: fixed_bookings.prev_page,
      total_pages: fixed_bookings.total_pages,
      total_count: fixed_bookings.total_count
    }
  end
end
