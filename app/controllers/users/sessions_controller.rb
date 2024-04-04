class Users::SessionsController < Devise::SessionsController
  include RackSessionFix
  respond_to :json

  private

  def respond_with(resource, _opts = {})
    if resource
      render json: resource, status: :ok
    else
      render json: { error: 'Login failed' }, status: :unauthorized
    end
  end

  def respond_to_on_destroy
    if current_user
      render json: { message: "Logged out successfully" }, status: :ok
    else
      render json: { error: "Couldn't find an active session." }, status: :unauthorized
    end
  end
end
