class TransactionsController < ApplicationController
  def create
    transaction = Transaction.new(transaction_params)

    return redirect_back if transaction.invalid?

    redirect_to transaction.link, allow_other_host: true
  end

  private
    def transaction_params
      params.expect(transaction: [:amount]).merge(sender: current_customer.name)
    end
end
