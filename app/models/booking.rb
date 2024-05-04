class Booking < ApplicationRecord
  belongs_to :room
  belongs_to :user
  before_create :consume_credit_if_needed
  after_create :return_credits_if_pending

  validates :name, presence: true, uniqueness: { scope: :user_id, message: 'O nome da reserva deve ser único por usuário' }
  validates :room, presence: true
  validates :start_time, presence: true
  validates :user, presence: true

  validate :unique_active_booking_per_room_and_time, on: [:create, :update], unless: -> { skip_room_time_validation }

  validate :start_time_must_be_in_the_future

  scope :active, -> { where('start_time > ? AND canceled_at IS NULL', Time.zone.now) }
  scope :done, -> { where('start_time < ? AND canceled_at IS NULL', Time.zone.now) }
  scope :canceled, -> { where.not(canceled_at: nil) }

  scope :by_user, -> (user_id) { where(user_id: user_id) if user_id.present? }
  scope :by_clinic, -> (clinic_id) {
    joins(room: :clinic).where(clinics: { id: clinic_id }) if clinic_id.present?
  }
  scope :by_room, -> (room_id) {
    where(room_id: room_id) if room_id.present?
  }

  attr_accessor :skip_room_time_validation

  def self.filter_bookings(user, filters)
    bookings = user.bookings

    case filters[:status]
    when 'canceled'
      bookings = bookings.canceled
    when 'scheduled'
      bookings = bookings.where('start_time > ?', Time.zone.now).where(canceled_at: nil)
    when 'completed'
      bookings = bookings.where('start_time < ?', Time.zone.now).where(canceled_at: nil)
    end

    bookings = bookings.by_room(filters[:room_id]) if filters[:room_id].present? && filters[:room_id] != 'all'

    bookings = bookings.by_clinic(filters[:clinic_id]) if filters[:clinic_id].present? && filters[:clinic_id] != 'all'

    bookings
  end

  def self.admin_filter_bookings(filters)
    bookings = self.all
    bookings = bookings.by_user(filters[:user_id]) if filters[:user_id].present? && filters[:user_id] != 'all'

    case filters[:status]
    when 'canceled'
      bookings = bookings.canceled
    when 'scheduled'
      bookings = bookings.where('start_time > ?', Time.zone.now).where(canceled_at: nil)
    when 'completed'
      bookings = bookings.where('start_time < ?', Time.zone.now).where(canceled_at: nil)
    end

    bookings = bookings.by_room(filters[:room_id]) if filters[:room_id].present? && filters[:room_id] != 'all'

    bookings = bookings.by_clinic(filters[:clinic_id]) if filters[:clinic_id].present? && filters[:clinic_id] != 'all'

    bookings
  end

  def status
    return 'canceled' if canceled_at.present?
    return 'completed' if start_time < Time.zone.now
    'scheduled'
  end

  def clinic
    room.clinic
  end

  # TODO: Passar isso pra um service
  def cancel
    raise "Não é possível cancelar reservas passadas ou já canceladas" if past_or_already_cancelled?

    Booking.transaction do
      if (start_time - Time.zone.now) < 24.hours
        self.credit_return_pending = true
      else
        user.increment!(:credits)
      end

      self.canceled_at = Time.zone.now
      save!
    end
  end

  private

  def past_or_already_cancelled?
    start_time < Time.zone.now || canceled_at.present?
  end

  # TODO: Passar pra um concern
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

  def return_credits_if_pending
    previous_booking = Booking.where(room_id: room_id, start_time: start_time)
                              .where(credit_return_pending: true)
                              .where.not(id: id)
                              .first

    if previous_booking
      previous_booking.skip_room_time_validation = true
      previous_booking.user.increment!(:credits)
      previous_booking.update!(credit_return_pending: false)
    end
  end
end
