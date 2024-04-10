class Booking < ApplicationRecord
  belongs_to :room
  belongs_to :user
  before_create :consume_credit_if_needed

  validates :name, presence: true, uniqueness: { scope: :user_id, message: 'O nome da reserva deve ser único por usuário' }
  validates :room, presence: true
  validates :start_time, presence: true
  validates :user, presence: true

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
end
