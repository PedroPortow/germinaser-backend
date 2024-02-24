class RoomsController < ApplicationController
  before_action :set_room, only: [:show, :update, :destroy]
  before_action :check_admin_or_owner, only: [:create, :update, :destroy]

  # GET /rooms
  def index
    @rooms = Room.all
    render json: @rooms
  end

  # GET /rooms/:id
  def show
    render json: @room
  end

  # POST /rooms
  def create
    @room = Room.new(room_params)
    if @room.save
      render json: @room, status: :created, location: @room
    else
      render json: @room.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /rooms/:id
  def update
    if @room.update(room_params)
      render json: @room
    else
      render json: @room.errors, status: :unprocessable_entity
    end
  end

  # DELETE /rooms/:id
  def destroy
    @room.destroy
    head :no_content
  end

  private
    def set_room
      @room = Room.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      render json: { error: "Room not found" }, status: :not_found
    end

    def room_params
      params.require(:room).permit(:name, :clinic_id)
    end

    def check_admin_or_owner
      current_user.admin? || current_user.owner?
    end
end
