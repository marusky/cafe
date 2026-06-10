class Admin::OrdersController < AdminController
  before_action :set_order, except: :index

  def index
    @orders = Order.filtered_by_state(params[:state])
  end

  def receive
    @order.mark_as_received!

    redirect_to orders_url
  end

  def prepare
    @order.mark_as_prepared!

    redirect_to orders_url
  end

  def deliver
    @order.mark_as_delivered!

    redirect_to orders_url
  end

  def cancel
    @order.mark_as_canceled!

    redirect_to orders_url
  end

  private
    def set_order
      @order = Order.find(params[:id])
    end
end
