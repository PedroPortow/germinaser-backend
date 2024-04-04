class ClinicsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_clinic, only: [:show, :update, :destroy]
  before_action :check_owner, only: [:create, :update, :destroy]

  # GET /clinics
  def index
    @clinics = Clinic.all
    # AMS irá automaticamente usar o ClinicSerializer para cada clínica na coleção
    render json: @clinics, status: :ok
  end

  # GET /clinics/1
  def show
    # AMS irá automaticamente usar o ClinicSerializer para serializar @clinic
    render json: @clinic, status: :ok
  end

  # POST /clinics
  def create
    @clinic = Clinic.new(clinic_params)
    if @clinic.save
      # Note que não é mais necessário chamar .serializable_hash manualmente
      render json: @clinic, status: :created
    else
      render json: @clinic.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /clinics/1
  def update
    if @clinic.update(clinic_params)
      render json: @clinic, status: :ok
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
      params.require(:clinic).permit(:name, :address) # Certifique-se de que :address é o correto aqui, não :location
    end

    def check_owner
      # Garante que somente o proprietário possa criar, atualizar ou deletar
      head :unauthorized unless current_user.owner?
    end
end
