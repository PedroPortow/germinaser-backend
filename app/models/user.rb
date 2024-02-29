# frozen_string_literal: true

class User < ApplicationRecord
  require "securerandom"
  
  has_secure_password

  belongs_to :role

  validates :email, presence: true, uniqueness: true
  validates :password, presence: true
  validates :name, presence: true
  validates :credits, numericality: { greater_than_or_equal_to: 0, allow_nil: true }

  def owner?
    role.name == 'Owner'
  end

  def admin?
    role.name == "Admin"
  end 

  def user?
    role.name == "User"
  end
end
