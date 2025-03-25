class CustomerOrderService
  def initialize(customer:, order:)
    @customer = customer
    @order = order
  end

  def not_accepting_new_orders?
    !Admin.first.accepting_orders
  end

  def any_order_item_unavailable?
    @order.unavailable_order_items.present?
  end

  def remove_unavailable_order_items
    @order.unavailable_order_items.delete_all
  end

  def any_product_price_has_changed?
    order_items_with_changed_product_price.present?
  end

  def update_order_items_with_changed_product_price!
    order_items_with_changed_product_price.each do |order_item|
      order_item.update!(cost: order_item.product.price)
    end
  end

  def sufficient_balance?
    @customer.balance >= @order.total_sum
  end

  def pay!
    ActiveRecord::Base.transaction do
      @order.update!(state: :finalized, finalized_at: Time.current)
      @customer.update!(balance: @customer.balance - @order.total_sum)
    end
  end

  def cancel_order!
    ActiveRecord::Base.transaction do
      @order.update!(state: :cancelled)

      @customer.update!(balance: @customer.balance + @order.total_sum)
    end
  end

  private
  
  def order_items_with_changed_product_price
    @_order_items_with_changed_product_price ||= @order
      .order_items
      .includes(:product)
      .select do |order_item|
        order_item.cost != order_item.product.price
      end
  end
end