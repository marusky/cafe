class OrderItemsController < ApplicationController
  before_action :set_order_item, only: [:update, :destroy]

  def new
    @product = Product.find(params[:product_id])
    @order_item = OrderItem.new(cost: @product.price, amount: 1, product: @product)
  end

  def create
    service = OrderItemCreationService.new(
      order_item_params:,
      customer: current_customer,
    )

    if service.order_item.valid?
      service.call

      redirect_to app_url, notice: 'Produkt bol pridaný.'
    else
      redirect_to app_url, alert: 'Hups! Niečo sa pokazilo!'
    end
  end

  def update
    return unless @order_item.order.open?

    @order_item.update!(amount: order_item_params[:amount])
  end

  def destroy
    return unless @order_item.order.open?

    @order_item.destroy!
  end

  private

  def set_order_item
    @order_item = OrderItem.find(params[:id])
  end

  def order_item_params
    params.expect(order_item: [:amount, :product_id])
  end

  def authorize_check
    return if @order_item.order.customer == current_customer 

    redirect_to app_url, alert: '"...čo ťa do toho?" (Ján 21:22)'
  end
end
