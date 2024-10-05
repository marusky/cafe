class PushService
  def self.send_notification(push_subscription:, title:, body:, icon: nil)
    WebPush.payload_send(
      endpoint: push_subscription.endpoint,
      message: { title:, options: { body: } }.to_json,
      p256dh: push_subscription.p256dh,
      auth: push_subscription.auth,
      vapid: {
        subject: "mailto:#{ENV["PUSH_SUBSCRIPTIONS_EMAIL"]}",
        public_key: ENV["VAPID_PUBLIC_KEY"],
        private_key: ENV["VAPID_PRIVATE_KEY"]
      }
    )
  end
end
