class AuthController < ApplicationController
  skip_before_action :authenticate_request

  # POST /auth/login
  def login
    @user = User.find_by_email(auth_params[:email])

    if @user&.authenticate(auth_params[:password])
      token = jwt_encode(user_id: @user.id)
      render json: { token: token }, status: :ok
    else 
      render json: { error: 'unauthorized'}, status: :unauthorized
    end
  end


  private

  def auth_params
    params.require(:auth).permit(:email, :password)
  end
end
