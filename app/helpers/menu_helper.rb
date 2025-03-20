module MenuHelper
  def cafe_tab_active
    ["categories", "products"].include?(controller_name) ? "text-zinc-700" : "text-zinc-400"
  end

  def customer_cafe_tab_active
    action_name == "app" ? "text-zinc-700" : "text-zinc-400"
  end

  def orders_tab_active
    controller_name == "orders" ? "text-zinc-700" : "text-zinc-400"
  end

  def balance_tab_active
    controller_name == "balances" ? "text-zinc-700" : "text-zinc-400"
  end

  def account_tab_active
    action_name == "account" ? "text-zinc-700" : "text-zinc-400"
  end

  def tokens_tab_active
    action_name == "tokens" ? "text-zinc-700" : "text-zinc-400"
  end
end
