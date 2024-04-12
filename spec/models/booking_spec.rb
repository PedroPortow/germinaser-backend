require 'rails_helper'

RSpec.describe Booking, type: :model do
  describe 'after_create :return_credits_if_pending' do
    let(:user) { FactoryBot.create(:user, credits: 1) }
    let(:other_user) { FactoryBot.create(:user, credits: 1) }
    let(:room) { FactoryBot.create(:room) }
    let(:start_time) { 3.days.from_now }
    puts "chegou aquiaaaasdasdsad"
    let!(:previous_booking) { FactoryBot.create(:booking, :canceled_credit_pending, user: user, room: room, start_time: start_time) }

    context 'when a previous canceled booking with credit_return_pending is true' do
      it 'returns the pending credit for the previous canceled booking user' do
        puts "chegou aqui"
        puts room
        expect {
          FactoryBot.create(:booking, room: room, start_time: start_time, user: other_user)
        }.to change { user.reload.credits }.by(1)

        expect(previous_booking.reload.credit_return_pending).to be false
      end
    end
  end

  describe '#cancel' do
    context 'when booking is in the future' do
      it 'cancels the booking' do
        booking = FactoryBot.create(:booking, start_time: 2.days.from_now)
        expect { booking.cancel }.not_to raise_error
        expect(booking.canceled_at).not_to be_nil
      end
    end

    context 'when booking is in the past' do
      it 'raises an error' do
        booking = FactoryBot.build(:booking, start_time: 2.days.ago)
        booking.save(validate: false)
        expect { booking.cancel }.to raise_error("Não é possível cancelar reservas passadas ou já canceladas")
      end
    end
  end

  describe '#clinic' do
    it 'returns the clinic associated with the booking room' do
      clinic = FactoryBot.create(:clinic)
      room = FactoryBot.create(:room, clinic: clinic)
      booking = FactoryBot.create(:booking, room: room)
      
      expect(booking.clinic).to eq(clinic)
    end
  end

  describe 'before_create #consume_credit_if_needed' do
    context 'when user is not an owner' do
      it 'decrements user credits by 1' do
        user = FactoryBot.create(:user, credits: 5)
        room = FactoryBot.create(:room)
        expect {
          FactoryBot.create(:booking, user: user, room: room)
        }.to change { user.reload.credits }.by(-1)
      end
    end

    context 'when user is owner' do
      it 'doesnt decrements owner credits' do
        owner = FactoryBot.create(:user, :owner, credits: 5)
        room = FactoryBot.create(:room)
        expect {
          FactoryBot.create(:booking, user: owner, room: room)
         }.not_to change { owner.reload.credits }
      end
    end
  end

  describe 'validations' do
    let(:start_time) { Time.zone.now + 1.day + 10.hours } 
  
    it 'prevents duplicate bookings for the same room and start time' do
      user = FactoryBot.create(:user)
      room = FactoryBot.create(:room)
      FactoryBot.create(:booking, user: user, room: room, start_time: start_time)
  
      duplicate_booking = FactoryBot.build(:booking, user: user, room: room, start_time: start_time)
      expect(duplicate_booking).not_to be_valid
      expect(duplicate_booking.errors[:base]).to include('Já existe uma reserva para esta sala no horário especificado')
    end

    it 'is valid with valid attributes' do
      booking = FactoryBot.build(:booking)
      expect(booking).to be_valid
    end
  
    it 'is not valid without a name' do
      booking = FactoryBot.build(:booking, name: nil)
      expect(booking).not_to be_valid
      expect(booking.errors[:name]).to include("can't be blank")
    end
  
    it 'is not valid without a room' do
      booking = FactoryBot.build(:booking, room: nil)
      expect(booking).not_to be_valid
      expect(booking.errors[:room]).to include("can't be blank")
    end
  
    it 'is not valid with a start time in the past' do
      booking = FactoryBot.build(:booking, start_time: 1.day.ago)
      expect(booking).not_to be_valid
      expect(booking.errors[:start_time]).to include("deve ser maior que o horário atual")
    end
  end
end
