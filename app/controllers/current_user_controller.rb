class CurrentUserController < ApplicationController
  before_action :authenticate_user!

  def index
    render json: current_user, status: :ok
  end

  def available_credits
    render json: { credits: current_user.credits }, status: :ok
  end

  def active_bookings_count
    active_count = current_user.bookings.scheduled.count
    render json: { active_bookings_count: active_count }
  end
end
