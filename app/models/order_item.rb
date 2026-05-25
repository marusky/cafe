class OrderItem < ApplicationRecord
  belongs_to :product
  belongs_to :order

  validates :amount, :cost, presence: true
  validates :amount, :cost, numericality: {
    only_integer: true, greater_than_or_equal_to: 1
  }

  scope :unavailable, -> { joins(:product).merge(Product.unavailable) }
  scope :outdated_price, -> {
    joins(:product).where("order_items.cost != products.price")
  }

  def total
    amount * cost
  end
end
