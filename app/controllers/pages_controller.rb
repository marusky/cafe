class PagesController < ApplicationController
  def home
  end

  def admin
  end

  def app
    return redirect_to_welcome if current_customer.nil?

    @categories = Category.order(:title).includes(:products)
    @order = current_customer.orders.open.first
    render layout: "app"
  end

  private

  def redirect_to_welcome
    redirect_to welcome_customer_url
  end
end
