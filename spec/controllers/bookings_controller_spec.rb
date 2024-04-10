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
end
