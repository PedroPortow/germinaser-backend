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

  describe 'PUT #update' do
    let(:new_attributes) { { name: 'Teste nome atualizado' } }

    context 'with valid params' do
      it 'updates the requested booking' do
        booking = bookings.first
        patch :update, params: { id: booking.id, booking: new_attributes }
        booking.reload
        expect(booking.name).to eq('Teste nome atualizado')
      end

      it 'renders a JSON response with the booking' do
        booking = bookings.first
        patch :update, params: { id: booking.id, booking: new_attributes }
        expect(response).to have_http_status(:ok)
        expect(response.content_type).to match(a_string_including('application/json'))
      end
    end

    context 'with invalid params' do
      it 'renders a JSON response with errors for the booking' do
        booking = bookings.first
        patch :update, params: { id: booking.id, booking: { start_time: nil } }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'POST #cancel' do
    it 'cancels the booking' do
      booking = bookings.first
      post :cancel, params: { id: booking.id }
      booking.reload
      expect(booking.canceled_at).not_to be_nil
      expect(response).to have_http_status(:ok)
    end

    it 'handles errors when canceling is not possible' do
      allow_any_instance_of(Booking).to receive(:cancel).and_raise("Cancellation failed")
      booking = bookings.first
      post :cancel, params: { id: booking.id }
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  describe 'GET #upcoming' do
    it 'returns upcoming bookings' do
      get :upcoming
      expect(response).to be_successful
      expect(json_response.size).to eq(bookings.size) #Pq na factory de bookings a data de start_time é 2 days depois de agr
    end
  end

  describe 'GET #day_available_slots' do
    it 'returns available slots for the day' do
      get :day_available_slots, params: { room_id: room.id, date: '2025-01-01' }
      expect(response).to have_http_status(:ok)
      expect(json_response).to include('available_slots')
    end

    context 'if there is a booking not canceled with the same start_time' do
      let(:start_time) { Time.zone.parse("2025-01-01 10:00:00") }
      let!(:booking) { FactoryBot.create(:booking, user: user, room: room, start_time: start_time, canceled_at: nil) }

      it 'does not return it as an available slot' do
        get :day_available_slots, params: { room_id: room.id, date: '2025-01-01' } # TODO: Arrumar esses testes válidos até 2025 pqp
        available_slots = json_response['available_slots']
        expect(available_slots).not_to include(start_time.strftime('%H:%M'))
      end
    end
  end
end
