import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["knob", "progress", "text", "button"];

  connect() {
    this.dragging = false;
    this.currentX = 0;

    this.boundDrag = this.drag.bind(this);
    this.boundStopDrag = this.stopDrag.bind(this);

    this.updateDimensions();
    window.addEventListener("resize", () => this.updateDimensions());
  }

  updateDimensions() {
    this.maxWidth =
      this.element.offsetWidth - this.knobTarget.offsetWidth;
  }

  startDrag(event) {
    event.preventDefault();

    this.dragging = true;

    const clientX = this.getClientX(event);

    this.startX = clientX;
    this.initialPosition = this.currentX;

    // disable transitions while dragging
    this.knobTarget.style.transition = "none";
    this.progressTarget.style.transition = "none";

    document.addEventListener("mousemove", this.boundDrag);
    document.addEventListener("touchmove", this.boundDrag, {
      passive: false,
    });

    document.addEventListener("mouseup", this.boundStopDrag);
    document.addEventListener("touchend", this.boundStopDrag);
  }

  drag(event) {
    if (!this.dragging) return;

    if (event.cancelable) {
      event.preventDefault();
    }

    const clientX = this.getClientX(event);

    this.currentX =
      this.initialPosition + (clientX - this.startX);

    this.currentX = Math.max(
      0,
      Math.min(this.currentX, this.maxWidth)
    );

    this.knobTarget.style.transform = `translateX(${this.currentX}px)`;

    const progressWidth =
    ((this.currentX + this.knobTarget.offsetWidth - 4) /
      this.element.offsetWidth) *
    100;

    this.progressTarget.style.width = `${progressWidth}%`;

    if (this.currentX >= this.maxWidth) {
      this.complete();
    }
  }

  stopDrag() {
    if (!this.dragging) return;

    this.dragging = false;

    document.removeEventListener("mousemove", this.boundDrag);
    document.removeEventListener("touchmove", this.boundDrag);
    document.removeEventListener("mouseup", this.boundStopDrag);
    document.removeEventListener("touchend", this.boundStopDrag);

    if (this.currentX < this.maxWidth) {
      this.knobTarget.style.transition = "transform 300ms ease";
      this.progressTarget.style.transition = "width 300ms ease";

      this.currentX = 0;

      this.knobTarget.style.transform = "translateX(0)";
      this.progressTarget.style.width = "0%";

      this.textTarget.textContent = "potiahni pre objednanie";
      this.textTarget.classList.remove("text-green-50");
      this.textTarget.style.transform = "translateX(0)";
    }
  }

  complete() {
    this.dragging = false;

    document.removeEventListener("mousemove", this.boundDrag);
    document.removeEventListener("touchmove", this.boundDrag);
    document.removeEventListener("mouseup", this.boundStopDrag);
    document.removeEventListener("touchend", this.boundStopDrag);

    this.knobTarget.style.transform = `translateX(${this.maxWidth}px)`;
    this.progressTarget.style.width = "100%";

    this.textTarget.textContent = "Posielam objednávku...";
    this.textTarget.classList.remove("text-zinc-500");
    this.textTarget.classList.add("text-white");
    this.textTarget.style.transform = "translateX(-30px)";

    this.buttonTarget.click();
  }

  getClientX(event) {
    return event.type.includes("touch")
      ? event.touches[0].clientX
      : event.clientX;
  }
}