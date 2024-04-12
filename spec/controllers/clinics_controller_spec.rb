require 'rails_helper'

RSpec.describe ClinicsController, type: :controller do
  let(:owner) { FactoryBot.create(:user, :owner) }
  let(:user) { FactoryBot.create(:user) }
  let(:admin) { FactoryBot.create(:user, :admin) }
  let!(:clinics) { FactoryBot.create_list(:clinic, 3) }

  before do
    sign_in owner
  end

  describe "GET #index" do
    it "returns all clinics" do
      Clinic.delete_all
      clinics = FactoryBot.create_list(:clinic, 3)  # Recriando pra esse teste, todo: arrumar essa bosta
      get :index
      expect(response).to have_http_status(:ok)
      expect(assigns(:clinics)).to match_array(clinics)
    end
  end

  describe "GET #show" do
    it "returns the specific clinic" do
      clinic = clinics.first
      get :show, params: { id: clinic.id }
      expect(response).to have_http_status(:ok)
      expect(json_response['id']).to eq(clinic.id)
    end
  end

  describe "POST #create" do
    let(:valid_attributes) { { clinic: { name: 'New Clinic', address: '123 Test Lane' } } }
    let(:invalid_attributes) { { clinic: { name: '', address: '' } } }

    context "as owner" do
      it "creates a new Clinic" do
        expect {
          post :create, params: valid_attributes
        }.to change(Clinic, :count).by(1)
      end

      it "renders a JSON response with the new clinic" do
        post :create, params: valid_attributes
        expect(response).to have_http_status(:created)
        expect(response.content_type).to match(a_string_including('application/json'))
      end
    end

    context "as normal user" do
      before { sign_in user }

      it "does not allow creating a clinic" do
        post :create, params: valid_attributes
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context "as admin user" do
      before { sign_in admin }

      it "does not allow creating a clinic" do
        post :create, params: valid_attributes
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context "with invalid attributes" do
      it "does not create a new clinic" do
        expect {
          post :create, params: invalid_attributes
        }.not_to change(Clinic, :count)
      end

      it "renders a JSON response with errors" do
        post :create, params: invalid_attributes
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "PATCH/PUT #update" do
    let(:new_attributes) { { name: 'Updated Clinic', address: '321 Test Walk' } }

    context "as owner" do
      it "updates the requested clinic" do
        clinic = clinics.first
        patch :update, params: { id: clinic.id, clinic: new_attributes }
        clinic.reload
        expect(clinic.name).to eq('Updated Clinic')
      end

      it "renders a JSON response with the clinic" do
        clinic = clinics.first
        patch :update, params: { id: clinic.id, clinic: new_attributes }
        expect(response).to have_http_status(:ok)
        expect(json_response['name']).to eq('Updated Clinic')
      end
    end

    context "as normal user " do
      before { sign_in user }

      it "does not allow updating a clinic" do
        clinic = clinics.first
        patch :update, params: { id: clinic.id, clinic: new_attributes }
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context "as admin user" do
      before { sign_in admin }

      it "does not allow updating a clinic" do
        clinic = clinics.first
        patch :update, params: { id: clinic.id, clinic: new_attributes }
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe "DELETE #destroy" do
    context "as owner" do
      it "destroys the requested clinic" do
        clinic = clinics.first
        expect {
          delete :destroy, params: { id: clinic.id }
        }.to change(Clinic, :count).by(-1)
      end

      it "responds with a message" do
        clinic = clinics.first
        delete :destroy, params: { id: clinic.id }
        expect(response).to have_http_status(:ok)
        expect(json_response['message']).to eq('Clinic successfully deleted')
      end
    end

    context "as user" do
      before { sign_in user }

      it "does not allow destroying a clinic" do
        clinic = clinics.first
        delete :destroy, params: { id: clinic.id }
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context "as admin user" do
      before { sign_in admin }

      it "does not allow destroying a clinic" do
        clinic = clinics.first
        delete :destroy, params: { id: clinic.id }
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
