class FixedBooking < ApplicationRecord
  belongs_to :room
  belongs_to :user

  validates :name, presence: true
  validates :room, presence: true
  validates :start_time, presence: true
  validates :end_time, presence: true
  validates :user, presence: true

  # 0 - Domingo, ..., 6 - Sabado
  validates :day_of_week, inclusion: { in: 0..6 }
  validate :end_time_after_start_time

  def cancel
    update(canceled_at: Time.current)
  end

  private

   def end_time_after_start_time
     errors.add(:end_time, 'must be after the start time') if end_time <= start_time
   end
end
