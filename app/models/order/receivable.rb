module Order::Receivable
  extend ActiveSupport::Concern

  def mark_as_received!
    return unless finalized?

    received!
  end
end
