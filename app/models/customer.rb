class Customer < ApplicationRecord
  # self.primary_key = "id"

  before_create :generate_uuid_v7
  validates :name, presence: true

  has_one :push_subscription, dependent: :delete
end
