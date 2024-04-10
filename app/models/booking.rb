class Booking < ApplicationRecord
  belongs_to :room
  belongs_to :user
  before_create :consume_credit_if_needed
  before_update :return_credits_on_cancel, if: :canceled_at_changed?

  validates :name, presence: true, uniqueness: { scope: :user_id, message: 'O nome da reserva deve ser único por usuário' }
  validates :room, presence: true
  validates :start_time, presence: true
  validates :user, presence: true

  validate :unique_active_booking_per_room_and_time, on: [:create, :update]
  validate :start_time_must_be_in_the_future

  scope :active, -> { where('start_time > ? AND canceled_at IS NULL', Time.zone.now) }
  scope :done, -> { where('start_time < ? AND canceled_at IS NULL', Time.zone.now) }
  scope :canceled, -> { where.not(canceled_at: nil) }


  def clinic
    room.clinic
  end

  private 

  def consume_credit_if_needed
    return if user.owner?
    raise "Créditos insuficientes" if user.credits <= 0

    user.decrement!(:credits)
  end


  def unique_active_booking_per_room_and_time
    existing_booking = Booking.where(room_id: room_id)
                              .where(start_time: start_time)
                              .where.not(id: id)
                              .where(canceled_at: nil)
                              .exists?

    errors.add(:base, 'Já existe uma reserva para esta sala no horário especificado') if existing_booking
  end

  def start_time_must_be_in_the_future
    if start_time.present? && start_time < Time.zone.now
      errors.add(:start_time, "deve ser maior que o horário atual")
    end
  end

  def return_credits_on_cancel
    return unless canceled_at && start_time > Time.zone.now

    if (start_time - Time.zone.now) > 24.hours # antecedencia dde 24  horas
      user.increment!(:credits)
  end
end
