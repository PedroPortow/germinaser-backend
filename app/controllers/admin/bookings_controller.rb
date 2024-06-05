class Admin::BookingsController < ApplicationController
  before_action :authenticate_user!
  before_action :check_admin
  before_action :filter_bookings, only: [:index]
  before_action :set_booking, only: [:show, :update, :cancel]

  def index
    @bookings = @bookings.order(updated_at: :desc).page(params[:page]).per(params[:per_page])
    render json: @bookings, meta: pagination_info(@bookings), adapter: :json, status: :ok
  end

  def show
    render json: @booking, status: :ok
  end

  def update
    if @booking.update(booking_params)
      render json: @booking, status: :ok
    else
      render json: @booking.errors, status: :unprocessable_entity
    end
  end

  def cancel
    @booking.cancel
    render json: { message: "Reserva cancelada com sucesso." }, status: :ok
  rescue => e
    render json: { error: e.message }, status: :unprocessable_entity
  end

  private

  def filter_bookings
    filters = {
      status: params[:status],
      room_id: params[:room_id],
      clinic_id: params[:clinic_id],
      user_id: params[:user_id]
    }

    @bookings = Booking.admin_filter_bookings(filters)
  end

  def set_booking
    @booking = Booking.find(params[:id])
  end

  def booking_params
    # admins can only update name or cancel booking
    params.require(:booking).permit(:name, :canceled_at)
  end

  def pagination_info(bookings)
    {
      current_page: bookings.current_page,
      next_page: bookings.next_page,
      prev_page: bookings.prev_page,
      total_pages: bookings.total_pages,
      total_count: bookings.total_count
    }
  end

  def check_admin
    unless current_user.admin? || current_user.owner?
      render json: { error: "Acesso não autorizado" }, status: :unauthorized
    end
  end
end
