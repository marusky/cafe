import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="home"
export default class extends Controller {
  connect() {
    document.body.style.backgroundColor = '#FAF2E6'
  }

  install() {
    const pwaInstall = document.querySelector('pwa-install');
    pwaInstall.showDialog(true);
  }
}
