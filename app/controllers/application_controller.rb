class ApplicationController < ActionController::API
  include JsonWebToken
  before_action :authenticate_request

  # Retorna o usuário autenticado atualmente baseado no token JWT
  def current_user
    @current_user
  end

  private

  def authenticate_request
    header = request.headers["Authorization"]
    header = header.split(" ").last if header
    begin
      decoded = jwt_decode(header)
      @current_user = set_current_user(decoded[:user_id])
    rescue ActiveRecord::RecordNotFound => e
      render json: { errors: e.message }, status: :unauthorized
    rescue JWT::DecodeError => e
      render json: { errors: "Invalid token" }, status: :unauthorized
    end
  end

  def set_current_user(user_id)
    @current_user = User.find(user_id)
  end
end
