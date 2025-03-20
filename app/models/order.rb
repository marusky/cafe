class Order < ApplicationRecord
  belongs_to :customer
  has_many :order_items

  before_create :generate_code

  after_update_commit :broadcast_changes_to_admins
  after_update_commit :broadcast_changes_to_customer

  enum :state, {
    open: 0,
    finalized: 1,
    received: 2,
    prepared: 3,
    delivered: 4,
    cancelled: 5
  }

  def available_order_items
    order_items
      .joins(:product)
      .where(product: { is_available: true })
      .order(:created_at)
  end

  def unavailable_order_items
    order_items
      .joins(:product)
      .where(product: { is_available: false })
      .order(:created_at)
  end

  private

  def generate_code
    self.code = ('0'..'9').to_a.shuffle.first(4).join('')
  end

  def customer_trackable?
    finalized? || received? || prepared?
  end

  def broadcast_changes_to_customer
    broadcast_update_to :order, partial: "orders/states/#{state}" if customer_trackable?
  end

  def broadcast_changes_to_admins
    case state.to_sym
    when :finalized
      broadcast_append_to :orders, partial: 'admin/orders/order'
    when :received, :prepared
      broadcast_replace_to :orders, partial: 'admin/orders/order'
    when :cancelled, :delivered
      broadcast_remove_to :orders
    end
  end
end
