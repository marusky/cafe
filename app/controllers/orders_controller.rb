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

    @order.update!(state: :finalized, finalized_at: Time.current)
  end

  def receive
    return unless @order.finalized?

    @order.received!
  end

  def cancel
    return if @order.open? || @order.delivered?

    @order.cancelled!
  end

  private

  def set_order
    @order = Order.find(params[:id])
  end
end
