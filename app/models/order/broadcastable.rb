module Order::Broadcastable
  extend ActiveSupport::Concern

  included do
    after_commit :broadcast_changes, on: :update, if: :saved_change_to_state?
  end

  private
    def broadcast_changes
      broadcast_changes_to_customer
      broadcast_changes_to_admins
      broadcast_changes_to_tv
    end

    def broadcast_changes_to_customer
      broadcast_update_to :order, partial: "orders/states/#{state}"
      broadcast_replace_to :customer_orders
    end

    def broadcast_changes_to_admins
      case state.to_sym
      when :finalized
        broadcast_append_to :orders, partial: 'admin/orders/order'
      when :received, :prepared
        broadcast_replace_to :orders, partial: 'admin/orders/order'
      when :canceled, :delivered
        broadcast_remove_to :orders
      end
    end

    def broadcast_changes_to_tv
      case state.to_sym
      when :received
        broadcast_append_to :tv_orders, target: 'orders-received', partial: 'pages/tv/order_number', locals: { id:, state: }
      when :prepared
        broadcast_append_to :tv_orders, target: 'orders-prepared', partial: 'pages/tv/order_number', locals: { id:, state: }
        broadcast_remove_to :tv_orders, target: "order-number-#{id}-received"
      when :delivered
        broadcast_remove_to :tv_orders, target: "order-number-#{id}-prepared"
      when :canceled
        broadcast_remove_to :tv_orders, target: "order-number-#{id}-received"
      end
  end
end
