import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="order-item-modal"
export default class extends Controller {
  newOrder({ currentTarget }) {
    const productId = currentTarget.dataset.productId

    fetch(`${location.origin}/order_items/new?product_id=${productId}`, {
      method: "GET",
      headers: {
        Accept: "text/vnd.turbo-stream.html",
      },
    })
      .then(r => r.text())
      .then(html => Turbo.renderStreamMessage(html))
  }
}
