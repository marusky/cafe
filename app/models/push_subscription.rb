class PushSubscription < ApplicationRecord
  validates :endpoint, :p256dh, :auth, presence: true

  belongs_to :customer
  has_many :push_notifications

  def send_notification(title:, icon:)
    WebPush.payload_send(
      endpoint: endpoint,
      message: { title: title, options: { body: body } }.to_json,
      p256dh: p256dh,
      auth: auth,
      vapid: {
        subject: "mailto:#{Rails.application.credentials.push_subscriptions.email}",
        public_key: Rails.application.credentials.push_subscriptions.vapid_public_key,
        private_key: Rails.application.credentials.push_subscriptions.vapid_private_key
      }
    )
  end
end
