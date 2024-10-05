class WelcomeController < ApplicationController
  def download
  end

  def customer
    @customer = Customer.new
  end

  def permissions
  end
end
