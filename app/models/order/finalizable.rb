module Order::Finalizable
  extend ActiveSupport::Concern

  def finalize
    return unless open?

    check_cafe_open
    return if errors.any?

    clean_up_unavailable_products
    return if errors.any?

    check_empty_order
    return if errors.any?

    check_diverged_prices
    return if errors.any?

    pay_if_possible
  end

  private
    def check_cafe_open
      add_error :cafe_closed unless Cafe.open?
    end

    def clean_up_unavailable_products
      return unless has_unavailable_products?

      remove_unavailable_products
      add_error :unavailable_products
    end

    def check_empty_order
      add_error :empty if is_empty?
    end

    def check_diverged_prices
      return unless prices_diverged?

      reconcile_prices!
      add_error :prices_diverged
    end

    def pay_if_possible
      return pay! if sufficient_balance?

      add_error :insufficient_balance
    end

    def has_unavailable_products?
      products.unavailable.exists?
    end

    def remove_unavailable_products
      order_items.unavailable.delete_all
    end

    def is_empty?
      !order_items.exists?
    end

    def prices_diverged?
      order_items.outdated_price.exists?
    end

    def reconcile_prices!
      order_items.includes(:product).outdated_price.find_each do |order_item|
        order_item.update!(cost: order_item.product.price)
      end
    end

    def sufficient_balance?
      customer.balance >= total_sum
    end

    def pay!
      transaction do
        update!(state: :finalized, finalized_at: Time.current)
        customer.update!(balance: customer.balance - total_sum)
      end
    end

    def add_error(type)
      errors.add :base, I18n.t("order.alerts.#{type}")
    end
end
