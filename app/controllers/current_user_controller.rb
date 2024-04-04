class CurrentUserController < ApplicationController
  before_action :authenticate_user!
  
  def index
    render json: current_user, status: :ok
  end

  def available_credits
    render json: { credits: current_user.credits }, status: :ok
  end
end
