class Admin::OrdersController < AdminController
  def index
    @orders = Order.order(:created_at)
  end
end