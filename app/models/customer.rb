class Customer < ApplicationRecord
  has_paper_trail

  after_update_commit -> { broadcast_update_to :balance, target: "balance-#{id}", html: balance }

  before_create :generate_uuid_v7
  validates :name, presence: true

  has_one :push_subscription, dependent: :delete
  has_many :orders

  def send_notification(title:, body:)
    return unless subscribed?

    push_subscription.push_notifications.create!(title: title, body: body)
  end

  private
    def subscribed?
      push_subscription.present?
    end
end
