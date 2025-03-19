class Order < ApplicationRecord
  belongs_to :customer
  has_many :order_items

  before_create :generate_code

  after_update_commit -> { broadcast_replace_to :orders, partial: 'admin/orders/order' }
  after_update_commit -> { broadcast_append_to :orders, partial: 'admin/orders/order' }, if: :finalized?

  after_update_commit -> { broadcast_update_to :order, partial: "orders/states/#{state}" }, if: :customer_trackable?

  enum :state, {
    open: 0,
    finalized: 1,
    received: 2,
    prepared: 3,
    delivered: 4,
    cancelled: 5
  }

  def customer_trackable?
    finalized? || received? || prepared?
  end

  def generate_code
    self.code = ('0'..'9').to_a.shuffle.first(4).join('')
  end
end
