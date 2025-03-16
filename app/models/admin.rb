class Admin < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy

  normalizes :name, with: ->(e) { e.strip.downcase }
end
