class PushSubscription < ApplicationRecord
  validates :endpoint, :p256dh, :auth, presence: true

  belongs_to :customer
end
