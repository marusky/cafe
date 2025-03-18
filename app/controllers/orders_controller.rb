class OrdersController < ApplicationController
  layout "app"

  before_action :set_order

  def show
    @order_items = @order.order_items.includes(:product).order(:created_at)
  end

  def edit
  end

  def finalize
    return unless @order.open?

    @order.finalized!
  end

  private

  def set_order
    @order = Order.find(params[:id])
  end
end
