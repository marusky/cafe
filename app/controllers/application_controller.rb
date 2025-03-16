class ApplicationController < ActionController::Base
  # allow_browser versions: :modern

  def current_customer
    customer_id = cookies.encrypted[:cui]
    return if customer_id.nil?

    @current_customer ||= Customer.find(customer_id)
  end
end
