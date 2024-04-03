class Clinic < ApplicationRecord
  has_many :rooms, dependent: :destroy
end
