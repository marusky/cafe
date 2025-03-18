import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="order-items"
export default class extends Controller {
  static targets = ['sum', 'amount']

  connect() {
    this.updateSum(parseInt(this.amountTarget.value))
  }

  minus() {
    const amount = parseInt(this.amountTarget.value) - 1
    const orderItemId = this.amountTarget.dataset.orderItemId
    
    if (amount > 0) {
      this.amountTarget.value = amount
      this.updateSum(amount)

      if (orderItemId) {
        void this.updateAmount(orderItemId, amount)
      }
    }
  }
  
  plus() {
    const amount = parseInt(this.amountTarget.value) + 1
    const orderItemId = this.amountTarget.dataset.orderItemId
    
    this.amountTarget.value = amount
    this.updateSum(amount)

    if (orderItemId) {
      void this.updateAmount(orderItemId, amount)
    }
  }

  updateSum(amount) {
    const price = parseInt(this.sumTarget.dataset.price)
    this.sumTarget.innerText = this.humanizedSum(amount * price)
  }

  close({ target, currentTarget }) {
    if (target === currentTarget) {
      document.getElementById('order-item-modal').innerHTML = ''
    }
  }

  updateAmount(orderItemId, amount) {
    const csrfToken = document.querySelector("[name='csrf-token']").content

    const body = JSON.stringify({
      order_item: {
        amount,
      },
    })

    fetch(`${location.origin}/order_items/${orderItemId}`, {
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

  humanizedSum(sum) {
    if (sum === 1) {
      return `${sum} žetón`
    } else if (sum < 5) {
      return `${sum} žetóny`
    } else {
      return `${sum} žetónov`
    }
  }
}
