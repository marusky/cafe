class ApplicationController < ActionController::Base
  helper_method :current_customer
  # allow_browser versions: :modern

  def current_customer
    customer_id = cookies.encrypted.permanent[:cui]
    return if customer_id.nil?

    @current_customer ||= Customer.find(customer_id)
  end
end
