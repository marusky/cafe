module Order::Preparable
  extend ActiveSupport::Concern

  def mark_as_prepared!
    return unless received?

    prepared!
    notify_customer_to_pick_up
  end

  private
    def notify_customer_to_pick_up
      customer.send_notification(
        title: "Objednávka ##{id} je hotová! 📣",
        body: "Pri vyzdvihnutí budeš potrebovať kód: #{code}.",
      )
    end
end
