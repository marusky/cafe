class Admin::OrdersController < AdminController
  before_action :set_order, except: :index

  def index
    @orders = Order.done.order(created_at: :desc)
    return @orders if params[:state] == 'done'

    @orders = Order.in_progress.order(:created_at)
  end

  def receive
    return unless @order.finalized?

    @order.received!
  end

  def prepare
    return unless @order.received?

    @order.prepared!
    PushService.send_notification(
      push_subscription: @order.customer.push_subscription,
      title: "Objednávka ##{@order.id} je hotová! 📣",
      body: "Pri vyzdvihnutí budeš potrebovať kód: #{@order.code}.",
    ) if @order.customer.push_subscription
  end

  def deliver
    return unless @order.prepared!

    @order.delivered!
  end

  def cancel
    return unless @order.finalized? || @order.received?

    service = CustomerOrderService.new(customer: @order.customer, order: @order)

    service.cancel_order!
    PushService.send_notification(
      push_subscription: @order.customer.push_subscription,
      title: "Objednávka ##{@order.id} je zrušená. ❌", 
      body: "Asi nám práve niečo došlo. Radi ti však pripravíme to, čo máme.",
    )
  end

  private

  def set_order
    @order = Order.find(params[:id])
  end
end