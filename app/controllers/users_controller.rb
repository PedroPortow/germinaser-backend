class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_admin_user!

  def index
    users = User.all
    render json: users, each_serializer: UserSerializer
  end

  private

  def ensure_admin_user!
    unless current_user_admin_or_owner
      render json: { error: 'Acesso negado' }, status: :forbidden
    end
  end
end
