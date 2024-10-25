class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  # allow_browser versions: :modern

  def current_customer
    customer_id = cookies.encrypted[:cui]
    return if customer_id.nil?

    @current_customer ||= Customer.find(customer_id)
  end
end
