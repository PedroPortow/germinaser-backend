require 'rails_helper'

RSpec.describe Clinic, type: :model do
  describe 'validations' do
    it 'is valid with valid attributes' do
      expect(FactoryBot.build(:clinic)).to be_valid
    end

    it 'is not valid without a name' do
      clinic = FactoryBot.build(:clinic, name: nil)
      expect(clinic).not_to be_valid
      expect(clinic.errors[:name]).to include("can't be blank")
    end

    it 'is not valid without a unique name' do
      FactoryBot.create(:clinic, name: "Unique Clinic")
      clinic = FactoryBot.build(:clinic, name: "Unique Clinic")
      expect(clinic).not_to be_valid
      expect(clinic.errors[:name]).to include("has already been taken")
    end

    it 'is not valid without an address' do
      clinic = FactoryBot.build(:clinic, address: nil)
      expect(clinic).not_to be_valid
      expect(clinic.errors[:address]).to include("can't be blank")
    end
  end

  describe 'associations' do
    it 'has many rooms' do
      clinic = FactoryBot.create(:clinic)
      room1 = FactoryBot.create(:room, clinic: clinic)
      room2 = FactoryBot.create(:room, clinic: clinic)

      expect(clinic.rooms).to include(room1, room2)
    end
  end
end
