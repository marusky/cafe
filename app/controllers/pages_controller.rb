class PagesController < ApplicationController
  def home
  end

  def app
    return redirect_to_welcome if current_customer.nil?

    @categories = Category.order(:title).includes(:products)
    @orders_in_progress = current_customer.orders.where(state: [:open, :finalized, :received, :prepared])
    render layout: "app"
  end

  def tokens
    render layout: "app"
  end

  def mrshq
  end

  private

  def redirect_to_welcome
    redirect_to welcome_customer_url
  end
end
