import { Controller } from "@hotwired/stimulus"
import { Turbo } from "@hotwired/turbo-rails"

export default class extends Controller {
  connect() {
    this.handleVisibilityChange = this.handleVisibilityChange.bind(this)

    document.addEventListener(
      "visibilitychange",
      this.handleVisibilityChange
    )
  }

  disconnect() {
    document.removeEventListener(
      "visibilitychange",
      this.handleVisibilityChange
    )
  }

  handleVisibilityChange() {
    if (!document.hidden) {
      Turbo.visit(window.location.href, {
        action: "replace"
      })
    }
  }
}
