class WelcomeController < ApplicationController
  def download
  end

  def customer
    redirect_to welcome_permissions_url if current_customer

    @customer = Customer.new
  end

  def permissions
    redirect_to welcome_customer_url if current_customer.nil?
  end
end
