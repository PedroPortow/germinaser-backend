class ClinicsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_clinic, only: [:show, :update, :destroy]
  before_action :check_owner, only: [:create, :update, :destroy]

  # GET /clinics
  def index
    @clinics = Clinic.all
    render json: ClinicSerializer.new(@clinics).serializable_hash, status: :ok
  end

  # GET /clinics/1
  def show
    render json: ClinicSerializer.new(@clinic).serializable_hash, status: :ok
  end

  # POST /clinics
  def create
    @clinic = Clinic.new(clinic_params)
    if @clinic.save
      render json: ClinicSerializer.new(@clinic).serializable_hash, status: :created
    else
      render json: @clinic.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /clinics/1
  def update
    if @clinic.update(clinic_params)
      render json: ClinicSerializer.new(@clinic).serializable_hash, status: :ok
    else
      render json: @clinic.errors, status: :unprocessable_entity
    end
  end

  # DELETE /clinics/1
  def destroy
    @clinic.destroy
    render json: { message: 'Clinic successfully deleted' }, status: :ok
  end

  private
    def set_clinic
      @clinic = Clinic.find(params[:id])
    end

    def clinic_params
      params.require(:clinic).permit(:name, :location)
    end

    def check_owner
      render json: { error: 'Not authorized' }, status: :unauthorized unless current_user.owner?
    end
end
