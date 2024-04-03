class RoomsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_room, only: [:show, :update, :destroy]
  before_action :check_permission, only: [:create, :update, :destroy]

  # GET /rooms ou GET /clinics/:clinic_id/rooms
  def index
    @rooms = params[:clinic_id] ? Room.where(clinic_id: params[:clinic_id]) : Room.all
    render json: RoomSerializer.new(@rooms).serializable_hash, status: :ok
  end

  # GET /rooms/1
  def show
    render json: RoomSerializer.new(@room).serializable_hash, status: :ok
  end

  # POST /rooms
  def create
    @room = Room.new(room_params)
    if @room.save
      render json: RoomSerializer.new(@room).serializable_hash, status: :created
    else
      render json: @room.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /rooms/1
  def update
    if @room.update(room_params)
      render json: RoomSerializer.new(@room).serializable_hash, status: :ok
    else
      render json: @room.errors, status: :unprocessable_entity
    end
  end

  # DELETE /rooms/1
  def destroy
    @room.destroy
    head :no_content
  end

  private
    def set_room
      @room = Room.find(params[:id])
    end

    def room_params
      params.require(:room).permit(:clinic_id, :name)
    end

    def check_permission
      unless current_user.owner? || current_user.admin?
        render json: { error: 'Not authorized' }, status: :unauthorized
      end
    end
end
