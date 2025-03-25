import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="accepting-orders"
export default class extends Controller {
  toggle(e) {
    const state = e.target.dataset.state
    const csrfToken = document.querySelector("[name='csrf-token']").content

    const body = JSON.stringify({
      admin: {
        accepting_orders: state === 'checked',
      },
    })

    fetch(`${location.origin}/toggle_accepting_orders`, {
      method: "PUT",
      headers: {
        Accept: "text/vnd.turbo-stream.html",
        "Content-Type": "application/json",
        "X-CSRF-Token": csrfToken,
      },
      body,
    })
      .then(r => r.text())
      .then(html => Turbo.renderStreamMessage(html))
  }
}
