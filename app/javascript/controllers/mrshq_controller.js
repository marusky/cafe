import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="mrshq"
export default class extends Controller {
  connect() {
    document.body.style.backgroundColor = '#09090b'
  }
}
