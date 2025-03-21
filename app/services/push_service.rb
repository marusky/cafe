class PushService
  def self.send_notification(push_subscription:, title:, body:, icon: nil)
    WebPush.payload_send(
      endpoint: push_subscription.endpoint,
      message: { title:, options: { body: } }.to_json,
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
