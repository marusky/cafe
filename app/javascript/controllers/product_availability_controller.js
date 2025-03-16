import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="product-availability"
export default class extends Controller {
  toggle(e) {
    const state = e.target.dataset.state
    const csrfToken = document.querySelector("[name='csrf-token']").content

    const body = JSON.stringify({
      product: {
        is_available: state === 'checked',
      },
    })

    fetch(`${location.href}/availability`, {
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
