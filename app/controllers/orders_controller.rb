class OrdersController < ApplicationController
  layout "app"

  before_action :set_order, except: :index
  before_action :authorize_check, except: :index

  def index
    @orders = current_customer.orders.includes(:order_items).order(created_at: :desc)
  end

  def show
    set_order_items
  end

  def update
    @order.update!(note: params[:order][:note])
  end

  def finalize
    @order.finalize

    if @order.errors.any?
      flash.now[:alert] = @order.errors.full_messages.first
      set_order_items
      render :show, status: :unprocessable_entity
    end
  end

  private

  def set_order
    @order = Order.find(params[:id])
  end

  def set_order_items
    @order_items = @order.order_items
  end

  def authorize_check
    return if @order.customer == current_customer

    redirect_to app_url, alert: '"...čo ťa do toho?" (Ján 21:22)'
  end
end
