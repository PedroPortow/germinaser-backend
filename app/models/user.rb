class User < ApplicationRecord
  include Devise::JWT::RevocationStrategies::JTIMatcher
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :validatable,
         :jwt_authenticatable, jwt_revocation_strategy: self

  enum role: [:user, :admin, :owner]
  after_initialize :set_default_role, if: :new_record?
  after_initialize :set_default_credits, if: :new_record?
  has_many :bookings, dependent: :destroy


  def self.roles_keys
    roles.keys
  end

  private

  def set_default_role
    self.role ||= :user
  end

  def set_default_credits
    self.credits ||= 0
  end
end
