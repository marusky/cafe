import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="push"
export default class PushController extends Controller {
  static values = {
    vapidPublicKey: String
  }

  async connect() {
  }

  async handleToggle (e) {
    const state = e.target.dataset.state

    if (state === 'checked') {
      const permissionResult = await this.requestPermission()

      switch (permissionResult) {
        case "default":
          e.target.click();
          break;
        case "denied":
          e.target.click();
          break;
      }
    }
  }

  async requestPermission() {
    const result = await Notification.requestPermission()
    switch (result) {
      case "granted":
        await this.subscribe()
        await this.getSubscription()  
        break;
      case "denied":
        alert('V poriadku, ale o to viac budeš musieť kontrolovať svoje číslo objednávky.')
        break;
        case "default":
        alert('Pro tip: So zapnutými upozorneniami sa skôr dostaneš k svojmu hot-dogu.')
        break;
      }

    return result
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
      alert(`PushSubscription sa nepodarilo subscribnúť. ${responseJSON.join(', ')}`)
    } else if (response.status === 500) {
      alert('Nečakaný move. Teda my sme ho nečakali. Už to ale pls nerob. #dík')
    } else {
      const responseJSON = response.json()
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
