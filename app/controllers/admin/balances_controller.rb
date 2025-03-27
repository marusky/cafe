class Admin::BalancesController < AdminController
  def show
  end

  def update
    @customer = Customer.find(params[:cid])
    @customer.balance += params[:tokens].to_i

    @customer.save!

    PushService.send_notification(
      push_subscription: @customer.push_subscription,
      title: 'Pribudli ti žetóny! 🤩', 
      body: "#{params[:tokens]} žetónov, k tvojim službám."
    )

    redirect_to balance_url
  end

  def add_tokens
    @customer = Customer.find(params[:cid])
    @eur = params[:eur].to_i
    @tokens = @eur * 4
  end
end
