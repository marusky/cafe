class Current < ActiveSupport::CurrentAttributes
  attribute :session
  delegate :cafe, to: :session, allow_nil: true
end
