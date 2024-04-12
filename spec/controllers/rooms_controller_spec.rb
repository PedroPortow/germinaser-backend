require 'rails_helper'

RSpec.describe RoomsController, type: :controller do
  let!(:user) { FactoryBot.create(:user) }
  let!(:admin) { FactoryBot.create(:user, :admin) }
  let!(:clinic) { FactoryBot.create(:clinic) }
  let!(:rooms) { FactoryBot.create_list(:room, 5, clinic: clinic) }

  before do
    sign_in user
  end

  describe "GET #index" do
    context "without clinic_id" do
      it "returns all rooms" do
        get :index
        expect(response).to have_http_status(:ok)
        expect(assigns(:rooms)).to match_array(rooms)
      end
    end

    context "with clinic_id" do
      it "returns rooms for a specific clinic" do
        get :index, params: { clinic_id: clinic.id }
        expect(response).to have_http_status(:ok)
        expect(assigns(:rooms)).to match_array(clinic.rooms)
      end
    end
  end

  describe "GET #show" do
    it "returns the specific room" do
      room = rooms.first
      get :show, params: { id: room.id }
      expect(response).to have_http_status(:ok)
      expect(json_response['id']).to eq(room.id)
    end
  end

  describe "POST #create" do
    let(:valid_attributes) { { room: { name: 'New Room', clinic_id: clinic.id } } }

    context "as admin" do
      before { sign_in admin }

      it "creates a new Room" do
        expect {
          post :create, params: valid_attributes
        }.to change(Room, :count).by(1)
      end

      it "renders a JSON response with the new room" do
        post :create, params: valid_attributes
        expect(response).to have_http_status(:created)
        expect(response.content_type).to match(a_string_including('application/json'))
      end
    end

    context "as regular user" do
      it "doesnt allow creating a room" do
        post :create, params: valid_attributes
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe "PATCH/PUT #update" do
    let(:new_attributes) { { name: 'New testing name' } }

    context "as admin" do
      before { sign_in admin }

      it "updates the requested room" do
        room = rooms.first
        patch :update, params: { id: room.id, room: new_attributes }
        room.reload
        expect(room.name).to eq('New testing name')
      end

      it "renders a JSON response with the room" do
        room = rooms.first
        patch :update, params: { id: room.id, room: new_attributes }
        expect(response).to have_http_status(:ok)
        expect(json_response['name']).to eq('New testing name')
      end
    end

    context "as regular user" do
      it "does not allow updating a room" do
        room = rooms.first
        patch :update, params: { id: room.id, room: new_attributes }
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe "DELETE #destroy" do
    context "as admin" do
      before { sign_in admin }

      it "destroys the requested room" do
        room = rooms.first
        expect {
          delete :destroy, params: { id: room.id }
        }.to change(Room, :count).by(-1)
      end

      it "responds with no content" do
        room = rooms.first
        delete :destroy, params: { id: room.id }
        expect(response).to have_http_status(:no_content)
      end
    end

    context "as regular user" do
      it "does not allow destroying a room" do
        room = rooms.first
        delete :destroy, params: { id: room.id }
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
