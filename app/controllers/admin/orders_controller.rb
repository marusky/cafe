class Admin::OrdersController < AdminController
  before_action :set_order, except: :index

  def index
    @orders = Order.filtered_by_state(params[:state])
  end

  def receive
    @order.mark_as_received!
  end

  def prepare
    @order.mark_as_prepared!
  end

  def deliver
    @order.mark_as_delivered!
  end

  def cancel
    @order.mark_as_canceled!
  end

  private
    def set_order
      @order = Order.find(params[:id])
    end
end
