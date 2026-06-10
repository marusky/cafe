module Order::Broadcastable
  extend ActiveSupport::Concern

  included do
    broadcasts_refreshes
  end

  private

    def broadcast_changes_to_tv
      # not used

      case state.to_sym
      when :received
        broadcast_append_to :tv_orders, target: "orders-received", partial: "pages/tv/order_number", locals: { id:, state: }
      when :prepared
        broadcast_append_to :tv_orders, target: "orders-prepared", partial: "pages/tv/order_number", locals: { id:, state: }
        broadcast_remove_to :tv_orders, target: "order-number-#{id}-received"
      when :delivered
        broadcast_remove_to :tv_orders, target: "order-number-#{id}-prepared"
      when :canceled
        broadcast_remove_to :tv_orders, target: "order-number-#{id}-received"
      end
    end
end
