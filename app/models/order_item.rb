class OrderItem < ApplicationRecord
  belongs_to :product
  belongs_to :order

  validates :amount, :cost, presence: true
  validates :amount, :cost, numericality: {
    only_integer: true, greater_than_or_equal_to: 1
  }

  def total
    amount * cost
  end
end
