class PushService
  def self.send_notification(push_subscription:, title:, body:, icon: nil)
    return if push_subscription.nil?

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

  def self.sunday_notification
    Customer.where(balance: 1..).each do |customer|
      send_notification(
        push_subscription: customer.push_subscription,
        title: 'Posledná šanca minúť e-žetóny!',
        body: 'Ešte ti ich tu zopár ostalo a Kaféem je otvorené už len dnes.'
      )
    end
  end
end
