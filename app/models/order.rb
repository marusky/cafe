class Order < ApplicationRecord
  include Broadcastable, Finalizable, Receivable, Cancelable, Preparable, Deliverable

  belongs_to :customer
  has_many :order_items, dependent: :destroy
  has_many :products, through: :order_items

  before_create :generate_code

  scope :in_progress, -> { where(state: %w[open finalized received prepared]).order(:created_at) }
  scope :done, -> { where(state: %w[delivered canceled]).order(created_at: :desc) }
  scope :filtered_by_state, ->(state) { state == "done" ? done : in_progress }

  enum :state, {
    open: 0,
    finalized: 1,
    received: 2,
    prepared: 3,
    delivered: 4,
    canceled: 5
  }

  def total_sum
    order_items.sum("amount * cost")
  end

  private

  def generate_code
    self.code = ("0".."9").to_a.shuffle.first(4).join("")
  end
end
