# frozen_string_literal: true

class User < ApplicationRecord
  require "securerandom"
  
  has_secure_password

  validates :email, presence: true, uniqueness: true
  validates :password, presence: true
  validates :name, presence: true
  validates :credits, numericality: { greater_than_or_equal_to: 0, allow_nil: true }

  def is_owner?
    role.name == 'owner'
  end

  def is_admin?
    role.name == "admin"
  end 

end
