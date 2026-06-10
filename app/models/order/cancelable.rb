module Order::Cancelable
  extend ActiveSupport::Concern

  def mark_as_canceled!
    return unless finalized? || received?

    cancel_and_return_tokens!
    notify_customer_of_cancelation
  end

  private
    def notify_customer_of_cancelation
      customer.send_notification(
        title: "Objednávka ##{id} je zrušená. ❌",
        body: "Asi nám práve niečo došlo. Skús si objednať znovu, radi ti pripravíme to, čo máme.",
      )
    end

    def cancel_and_return_tokens!
      transaction do
        canceled!
        customer.update!(balance: customer.balance + total_sum)
      end
    end
end
