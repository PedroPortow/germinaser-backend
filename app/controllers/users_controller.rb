class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_admin_user!
  before_action :set_user, only: [:show, :update, :destroy]

  def index
    users = User.all
    render json: users, each_serializer: UserSerializer
  end

  def show
    render json: @user, serializer: UserSerializer
  end

  def create
    user = User.new(user_params)
    if user.save
      render json: user, serializer: UserSerializer, status: :created
    else
      render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    if @user.update(user_params)
      render json: @user, serializer: UserSerializer
    else
      render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    @user.destroy
    head :no_content
  end

  def roles
    render json: { roles: User.roles_keys }
  end

  private

  def ensure_admin_user!
    unless current_user.admin? || current_user.owner?
      render json: { error: 'Acesso negado' }, status: :forbidden
    end
  end

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation, :role)
  end
end
