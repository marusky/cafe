class Admin::OrdersController < AdminController
  before_action :set_order, except: :index

  def index
    @orders = Order.order(:created_at)
  end

  def receive
    return unless @order.finalized?

    @order.received!
  end

  def prepare
    return unless @order.received?

    @order.prepared!
  end

  def deliver
    return unless @order.prepared!

    @order.delivered!
  end

  def cancel
    return unless @order.finalized? || @order.received?

    @order.cancelled!
  end

  private

  def set_order
    @order = Order.find(params[:id])
  end
end