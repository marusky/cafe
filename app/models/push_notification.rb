class PushNotification < ApplicationRecord
  belongs_to :push_subscription

  validates :title, :body, presence: true

  after_create :send_notification

  private
    def send_notification
      WebPush.payload_send(
        endpoint: push_subscription.endpoint,
        message: { title: title, options: { body: body } }.to_json,
        p256dh: push_subscription.p256dh,
        auth: push_subscription.auth,
        vapid: {
          subject: "mailto:#{Rails.application.credentials.push_subscriptions.email}",
          public_key: Rails.application.credentials.push_subscriptions.vapid_public_key,
          private_key: Rails.application.credentials.push_subscriptions.vapid_private_key
        }
      )
    end
end
