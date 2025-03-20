class OrdersController < ApplicationController
  layout "app"

  before_action :set_order

  def show
    set_order_items
  end

  def edit
  end

  def update
    @order.update!(note: params[:order][:note])
  end

  def finalize
    return unless @order.open?

    service = CustomerOrderService.new(customer: current_customer, order: @order)

    if service.any_order_item_unavailable?
      service.remove_unavailable_order_items
      set_order_items

      flash.now[:alert] = 'To bolo tesné! Niektorý z našich produktov už, žiaľ, nie je dostupný.'
      return render :show, status: :unprocessable_entity
    end

    if service.sufficient_balance?
      service.pay
    else
      flash.now[:alert] = 'Na túto objednávku nemáš dostatok žetónov.'
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
end
