require 'rails_helper'

RSpec.describe BookingsController, type: :controller do
  let!(:user) { FactoryBot.create(:user, :user) }
  let!(:admin) { FactoryBot.create(:user, :admin) }
  let!(:owner) { FactoryBot.create(:user, :owner) }
  let!(:room) { FactoryBot.create(:room) }
  let!(:booking) { FactoryBot.create(:booking, user: user, room: room) }
  
  before do
    sign_in user
  end

  describe "GET #index" do
    it "returns a success response" do
      get :index
      expect(response).to be_successful
    end
  end
end
