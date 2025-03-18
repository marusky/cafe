import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["knob", "progress", "text"];
  static values = {
    orderId: String,
  }
  connect() {
    this.dragging = false;
    this.startX = 0;
    this.currentX = 0;
    this.maxWidth = this.element.offsetWidth - this.knobTarget.offsetWidth;
  }

  startDrag(event) {
    event.preventDefault();
    this.dragging = true;
    this.startX = event.type.includes("touch") ? event.touches[0].clientX : event.clientX;

    document.addEventListener("mousemove", this.drag.bind(this));
    document.addEventListener("touchmove", this.drag.bind(this));
    document.addEventListener("mouseup", this.stopDrag.bind(this));
    document.addEventListener("touchend", this.stopDrag.bind(this));
  }

  drag(event) {
    if (!this.dragging) return;

    const clientX = event.type.includes("touch") ? event.touches[0].clientX : event.clientX;
    this.currentX = clientX - this.startX;

    // Constrain movement
    this.currentX = Math.max(0, Math.min(this.currentX, this.maxWidth));
    this.knobTarget.style.transform = `translateX(${this.currentX}px)`;
    this.progressTarget.style.width = `${(this.currentX / this.maxWidth) * 80 + 20}%`;

    // Check if registered
    if (this.currentX >= this.maxWidth) {
      this.textTarget.textContent = "Posielam objednávku...";
      this.textTarget.classList.add('text-green-50')
      this.textTarget.style.transform = 'translateX(-30px)'
      this.progressTarget.style.width = "100%";
      this.dragging = false;
      this.triggerRegister();
    }
  }

  stopDrag() {
    if (!this.dragging) return;
    this.dragging = false;

    if (this.currentX < this.maxWidth) {
      this.knobTarget.style.transform = "translateX(0)";
      this.progressTarget.style.width = "0%";
      this.textTarget.style.transform = 'translateX(0px)'
      this.textTarget.classList.remove('text-green-50')
      this.textTarget.textContent = "potiahni pre objednanie";
    }

    document.removeEventListener("mousemove", this.drag);
    document.removeEventListener("touchmove", this.drag);
    document.removeEventListener("mouseup", this.stopDrag);
    document.removeEventListener("touchend", this.stopDrag);
  }

  triggerRegister() {
    const csrfToken = document.querySelector("[name='csrf-token']").content

    fetch(`${location.origin}/orders/${this.orderIdValue}/finalize`, {
      method: "PATCH",
      headers: {
        Accept: "text/vnd.turbo-stream.html",
        "Content-Type": "application/json",
        "X-CSRF-Token": csrfToken,
      },
    })
    .then(r => r.text())
    .then(html => Turbo.renderStreamMessage(html))
  }
}