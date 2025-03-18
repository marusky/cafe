class OrderItem < ApplicationRecord
  belongs_to :product
  belongs_to :order

  def total
    amount * cost
  end
end
