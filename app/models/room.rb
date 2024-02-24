class Room < ApplicationRecord
  belongs_to :clinic

  validates :name, presence: true, uniqueness: { scope: :clinic_id, message: 'O nome da sala deve ser único dentro da mesma clínica' }
  validates :clinic_id, presence: true
end
