class OrderItemsController < ApplicationController
  before_action :set_order_item, only: :update

  def new
    @product = Product.find(params[:product_id])
    @order_item = OrderItem.new(cost: @product.price, amount: 1, product: @product)
  end

  def create
    product = Product.find(order_item_params[:product_id])
    order = Order.open.find_by(customer: current_customer) || Order.new(customer: current_customer)
    order_item = OrderItem.new(order_item_params.merge(cost: product.price, product:, order:))

    if order_item.valid?
      if product_already_in_order?(order, order_item)
        existing_order_item = order.order_items.find { |any_order_item| any_order_item.product == order_item.product }
        existing_order_item.update!(amount: existing_order_item.amount + order_item.amount)
      else
        order.save!
        order_item.save!
      end

      redirect_to app_url
    end
  end

  def update
    return unless @order_item.order.open?

    @order_item.update!(amount: order_item_params[:amount])
  end

  private

  def set_order_item
    @order_item = OrderItem.find(params[:id])
  end

  def order_item_params
    params.expect(order_item: [:amount, :product_id])
  end

  def product_already_in_order?(order, order_item)
    order.order_items.any? { |any_order_item| any_order_item.product == order_item.product }
  end
end
