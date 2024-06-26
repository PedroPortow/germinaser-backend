class BookingsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_booking, only: [:show, :update, :destroy, :cancel]
  before_action :filter_bookings, only: [:index]
  before_action :set_date, only: [:day_available_slots, :week_available_slots, :rooms_available_slots]
  before_action :set_room, only: [:day_available_slots]
  before_action :set_clinic, only: [:week_available_slots, :rooms_available_slots]

  def index
    @bookings = @bookings.page(params[:page]).per(params[:per_page])
    render json: @bookings, meta: pagination_info(@bookings), adapter: :json, status: :ok
  end

  def show
    render json: @booking, status: :ok
  end

  def create
    @booking = current_user.bookings.build(booking_params)

    if @booking.save
      render json: @booking, status: :created
    else
        render json: { errors: @booking.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    if @booking.update(booking_params)
      render json: @booking, status: :ok
    else
        render json: { errors: @booking.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def upcoming
    start_date = Time.zone.now.beginning_of_day
    end_date = start_date + 7.days

    @bookings = current_user.bookings.where(start_time: start_date..end_date)
    render json: @bookings, status: :ok
  end

  def day_available_slots
    service = DayAvailableSlotsService.new(@room.id, @date)
    available_slots = service.call

    render json: { available_slots: available_slots }, status: :ok
  end

  def rooms_available_slots
    rooms_available_slots = []

    Room.where(clinic_id: @clinic.id).each do |room|
      service = DayAvailableSlotsService.new(room.id, @date)
      slots = service.call

      rooms_available_slots << { room: room, availableTimeSlots: slots }
    end

    render json: rooms_available_slots, status: :ok
  end

  def week_available_slots
    start_date = @date.beginning_of_week
    end_date = @date.end_of_week

    available_slots = {}
    Room.where(clinic_id: @clinic.id).each do |room|
      (start_date..end_date).each do |date|
        service = DayAvailableSlotsService.new(room.id, date)
        slots = service.call
        available_slots[date.to_s] ||= []
        available_slots[date.to_s] << { name: room.name, availableTimeSlots: slots }
      end
    end

    render json: available_slots, status: :ok
  end

  def cancel
    @booking.cancel
    render json: { message: "Reserva cancelada com sucesso." }, status: :ok
  rescue => e
    render json: { error: e.message }, status: :unprocessable_entity
  end

  private

  def set_booking
    @booking = Booking.find(params[:id])
  end

  def filter_bookings
    filters = { status: params[:status], room_id: params[:room_id], clinic_id: params[:clinic_id] }
    @bookings = Booking.filter_bookings(current_user, filters)
  end

  def set_room
    room_id = if params[:booking].present?
                params.dig(:booking, :room_id)
              else
                params[:room_id]
              end

    @room = Room.find_by_id(room_id)

    if @room.nil?
      render json: { error: "Sala não encontrada." }, status: :not_found
    end
  end

  def set_date
    @date = Date.parse(params[:date])
  rescue ArgumentError, TypeError
    render json: { error: "Formato de data inválido ou data não fornecida." }, status: :unprocessable_entity
  end

  def set_clinic
    clinic_id = params[:clinic_id]
    @clinic = Clinic.find_by_id(clinic_id)

    if @clinic.nil?
      render json: { error: "Clinica não encontrada." }, status: :not_found
    end
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

  def booking_params
    params.require(:booking).permit(:name, :room_id, :start_time, :canceled_at)
  end
end
