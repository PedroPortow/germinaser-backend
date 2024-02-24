class ClinicsController < ApplicationController
  before_action :set_clinic, only: [:show, :update, :destroy]
  before_action :check_admin_or_owner, only: [:create, :update, :destroy]

  # GET /clinics
  def index
    @clinics = Clinic.all
    render json: @clinics
  end

  # GET /clinics/:id
  def show
    render json: @clinic
  end

  # POST /clinics
  def create
    @clinic = Clinic.new(clinic_params)
    if @clinic.save
      render json: @clinic, status: :created, location: @clinic
    else
      render json: @clinic.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /clinics/:id
  def update
    if @clinic.update(clinic_params)
      render json: @clinic
    else
      render json: @clinic.errors, status: :unprocessable_entity
    end
  end

  # DELETE /clinics/:id
  def destroy
    @clinic.destroy
    head :no_content
  end

  private
    def set_clinic
      @clinic = Clinic.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      render json: { error: "clinic not found" }, status: :not_found
    end

    # TODO: Arrumar typo na tabela Adress -> Address :( q triste isso em
    def clinic_params
      params.require(:clinic).permit(:name, :adress)
    end

    def check_admin_or_owner
      unless current_user.admin? || current_user.owner?
        render json: { error: "Not authorized" }, status: :unauthorized
        return
      end
    end
end
