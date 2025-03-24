class CustomerOrderService
  def initialize(customer:, order:)
    @customer = customer
    @order = order
  end

  def any_order_item_unavailable?
    @order.unavailable_order_items.present?
  end

  def remove_unavailable_order_items
    @order.unavailable_order_items.delete_all
  end

  def sufficient_balance?
    @customer.balance >= total_sum
  end

  def pay!
    ActiveRecord::Base.transaction do
      @order.update!(state: :finalized, finalized_at: Time.current)
      @customer.update!(balance: @customer.balance - total_sum)
    end
  end

  def cancel_order!
    ActiveRecord::Base.transaction do
      @order.update!(state: :cancelled)

      @customer.update!(balance: @customer.balance + total_sum)
    end
  end

  private

  def total_sum
    @_total_sum ||= @order.order_items.sum { |order_item| order_item.amount * order_item.cost }
  end
end