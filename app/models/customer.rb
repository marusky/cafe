class Customer < ApplicationRecord
  # self.primary_key = "id"

  after_update_commit -> { broadcast_update_to :balance, target: "balance-#{id}", html: balance }

  before_create :generate_uuid_v7
  validates :name, presence: true

  has_one :push_subscription, dependent: :delete
  has_many :orders
end
