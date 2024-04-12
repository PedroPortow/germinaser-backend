require 'rails_helper'

RSpec.describe Room, type: :model do
  describe 'validations' do
    subject { FactoryBot.create(:room) }
    let(:clinic) { FactoryBot.create(:clinic) }

    it 'is valid with valid attributes' do
      expect(FactoryBot.build(:room, clinic: clinic)).to be_valid
    end

    it 'is not valid without a clinic' do
      room = FactoryBot.build(:room, clinic: nil)
      expect(room).not_to be_valid
      expect(room.errors[:clinic]).to include("can't be blank")
    end

    it 'is not valid without a name' do
      room = FactoryBot.build(:room, name: nil)
      expect(room).not_to be_valid
      expect(room.errors[:name]).to include("can't be blank")
    end

    it 'requires a unique name within the same clinic' do
      existing_room = FactoryBot.create(:room, clinic: clinic, name: "Unique Room")
      new_room = FactoryBot.build(:room, clinic: clinic, name: "Unique Room")
      expect(new_room).not_to be_valid
      expect(new_room.errors[:name]).to include("O nome da sala deve ser único dentro de cada clínica")
    end
  end

  describe 'associations' do
    it 'belongs to a clinic' do
      clinic = FactoryBot.create(:clinic)
      room = FactoryBot.create(:room, clinic: clinic)
      expect(room.clinic).to eq(clinic)
    end
  end
end
