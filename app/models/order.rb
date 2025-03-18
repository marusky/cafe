class Order < ApplicationRecord
  belongs_to :customer
  has_many :order_items

  enum :state, {
    open: 0,
    finalized: 1,
    received: 2,
    prepared: 3,
    delivered: 4,
    cancelled: 5
  }
end
