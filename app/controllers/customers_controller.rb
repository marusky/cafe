class CustomersController < ApplicationController
  def create
    @customer = Customer.new(customer_params)

    if @customer.save
      cookies.encrypted.permanent[:cui] = @customer.id

      redirect_to welcome_permissions_url
    else 
      render 'welcome/customer', status: :unprocessable_entity
    end
  end

  private

  def customer_params
    params.require(:customer).permit(:name)
  end
end