import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="push"
export default class extends Controller {
  static values = {
    vapidPublicKey: String
  }

  async connect() {
  }

  async requestPermission() {
    const result = await Notification.requestPermission()
    switch (result) {
      case "granted":
        await this.subscribe()
        await this.getSubscription()  
        break;
      case "denied":
        console.log('If you denied the permissions, you cannot order through the app.')
        break;
      case "default":
        console.log('You need this to use the app.')
        break;
    }
  }
  
  async getSubscription() {
    const registration = await navigator.serviceWorker.ready
    const subscription = await registration.pushManager.getSubscription()
    const subscriptionJSON = subscription.toJSON()
    const csrfToken = document.querySelector("[name='csrf-token']").content

    const url = `${window.location.origin}/push_subscriptions`;
    const options = {
      method: 'POST',
      headers: {
        'Accept': 'application/json',
        "X-CSRF-Token": csrfToken,
        'Content-Type': 'application/json;charset=UTF-8'
      },
      body: JSON.stringify({
        push_subscription: {
          endpoint: subscriptionJSON.endpoint,
          p256dh: subscriptionJSON.keys.p256dh,
          auth: subscriptionJSON.keys.auth
        }
      })
    };
    
    const response = await fetch(url, options)
    if (response.status === 422) {
      const responseJSON = response.json()
      console.log(`Error creating PushSubscription. ${responseJSON.join(', ')}`)
    } else if (response.status === 500) {
      console.log('Server problem, contact ajaj@mrshq.io')
    } else {
      const responseJSON = response.json()
      console.log(responseJSON.message)
    }
  }

  async subscribe() {
    const registration = await navigator.serviceWorker.ready
    
    await registration.pushManager.subscribe({
      userVisibleOnly: true,
      applicationServerKey: this.vapidPublicKeyValue,
    });
  }
}
