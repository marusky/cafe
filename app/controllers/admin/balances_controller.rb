class Admin::BalancesController < AdminController
  def show
  end

  def update
    @customer = Customer.find(params[:cid])
    @customer.balance += params[:balance]

    @customer.save!
  end

  def add_tokens
    @customer = Customer.find(params[:cid])
    @eur = params[:eur].to_i
    @tokens = @eur * 4
  end
end
