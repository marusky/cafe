class OrderItemCreationService
  def initialize(customer:, order_item_params:)
    @customer = customer
    @order_item_params = order_item_params
  end

  def order_item
    @order_item ||= OrderItem.new(@order_item_params.merge(cost: product.price, product:, order:))
  end

  def call
    if existing_order_item_for_same_product
      update_existing_order_item_amount!
    else
      save_order_and_order_item!
    end
  end

  private

  def product
    @product ||= Product.find(@order_item_params[:product_id])
  end

  def order
    @order ||= existing_order || new_order
  end

  def existing_order
    @customer.orders.open.first
  end

  def new_order
    @customer.orders.build
  end

  def existing_order_item_for_same_product
    @_existing_order_item_for_same_product = 
      order.order_items.find do |existing_order_item|
        existing_order_item.product == order_item.product
      end
  end

  def update_existing_order_item_amount!
    amount = existing_order_item_for_same_product.amount + order_item.amount

    existing_order_item_for_same_product.update!(amount:)
  end

  def save_order_and_order_item!
    ActiveRecord::Base.transaction do
      order.save!
      order_item.save!
    end
  end
end