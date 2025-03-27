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

  def edit
  end

  def update
    @order.update!(note: params[:order][:note])
  end

  def finalize
    return unless @order.open?

    service = CustomerOrderService.new(customer: current_customer, order: @order)

    if service.not_accepting_new_orders?
      set_order_items
      
      flash.now[:alert] = 'Kaféem momentálne neprijíma nové objednávky.'
      return render :show, status: :unprocessable_entity
    end

    if service.any_order_item_unavailable?
      service.remove_unavailable_order_items
      set_order_items

      flash.now[:alert] = 'To bolo tesné! Niektorý z našich produktov už, žiaľ, nie je dostupný.'
      return render :show, status: :unprocessable_entity
    end

    if service.empty_order?
      set_order_items

      flash.now[:alert] = 'Objednávka je prázdna.'
      return render :show, status: :unprocessable_entity
    end

    if service.any_product_price_has_changed?
      service.update_order_items_with_changed_product_price!
      set_order_items

      flash.now[:alert] = 'Niektorý z produktov, ktoré máš v objednávke, zmenil svoju cenu. Pred potvrdením objednávky si to pre istotu skontroluj.'
      return render :show, status: :unprocessable_entity
    end

    if service.sufficient_balance?
      service.pay!
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

  def authorize_check
    return if @order.customer == current_customer 

    redirect_to app_url, alert: '"...čo ťa do toho?" (Ján 21:22)'
  end
end
