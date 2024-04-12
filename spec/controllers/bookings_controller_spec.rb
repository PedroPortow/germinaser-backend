require 'rails_helper'

RSpec.describe BookingsController, type: :controller do
  let!(:user) { FactoryBot.create(:user, :user) }
  let!(:admin) { FactoryBot.create(:user, :admin) }
  let!(:owner) { FactoryBot.create(:user, :owner) }
  let!(:room) { FactoryBot.create(:room) }
  let!(:bookings) { FactoryBot.create_list(:booking, 5, user: user, room: room) }
  
  before do
    sign_in user
  end

  describe "GET #index" do
    it "returns a success response" do
      get :index
      expect(response).to be_successful
    end

    it "loads all of the bookings into @bookings for the current user" do
      get :index
      expect(assigns(:bookings)).to match_array(bookings)
    end

    it "does not load bookings for other users" do
      FactoryBot.create_list(:booking, 3, user: admin, room: room)
      get :index
      expect(assigns(:bookings)).to match_array(bookings)
    end
  end

  describe "GET #show" do
    it "returns the specific booking" do
      get :show, params: { id: bookings.first.id }
      expect(response).to be_successful
      expect(json_response['id']).to eq(bookings.first.id)
    end
  end

  describe  "POST #create" do
    context 'with valid params' do
      let(:valid_attributes) { { booking: { name: 'Nova Reserva teste', room_id: room.id, start_time: 3.days.from_now } } }
      
      it 'creates a new Booking' do
        expect { post :create, params: valid_attributes }.to change(Booking, :count).by(1)
      end
  
      it 'renders a JSON response with the new booking' do
        post :create, params: valid_attributes
        expect(response).to have_http_status(:created)
        expect(response.content_type).to match(a_string_including('application/json'))
      end
    end

    context "if has a booking at the same start time" do
      let(:start_time) { "2025-04-15T14:00:00Z"  } # TODO: Arrumar isso aqui
      let!(:existing_booking) { FactoryBot.create(:booking, user: user, room: room, start_time: start_time) }
      let(:invalid_attributes) { { booking: { name: 'Teste reserva mesmo horário', room_id: room.id, start_time: start_time } } }
  
      it 'doesnt create a new booking due to time conflict' do
        expect { post :create, params: invalid_attributes }.not_to change(Booking, :count)
      end
  
      it 'renders a JSON response with errors' do
        post :create, params: invalid_attributes
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end
end
