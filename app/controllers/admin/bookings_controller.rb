class Admin::BookingsController < ApplicationController
  before_action :authenticate_user!
  before_action :check_admin
  before_action :filter_bookings, only: [:index]
  before_action :set_booking, only: [:show, :update]

  def index
    @bookings = @bookings.page(params[:page]).per(params[:per_page])
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

  private

  def filter_bookings
    @bookings = Booking.all
    @bookings = @bookings.by_user(params[:user_id]) if params[:user_id].present?
    @bookings = @bookings.by_clinic(params[:clinic_id]) if params[:clinic_id].present?
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
