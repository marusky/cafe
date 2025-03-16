class PagesController < ApplicationController
  def home
  end

  def app
    return redirect_to_welcome if current_customer.nil?

    # render layout: 'app'
  end

  private

  def redirect_to_welcome
    redirect_to welcome_customer_url
  end
end
