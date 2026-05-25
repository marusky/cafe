module Order::Deliverable
  extend ActiveSupport::Concern

  def mark_as_delivered!
    return unless prepared?

    delivered!
  end
end
