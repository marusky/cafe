import { Controller } from "@hotwired/stimulus"
import QRCode from "qrcode";

// Connects to data-controller="qr-generator"
export default class extends Controller {
  static values = {
    cid: String,
  }
  static targets = ['eur', 'qrCode']

  generate() {
    this.qrCodeTarget.classList.remove('hidden')
    QRCode.toCanvas(
      this.qrCodeTarget, 
      `https://www.youtube.com/watch?v=dQw4w9WgXcQ&cid=${this.cidValue}&eur=${this.eurTarget.value}`,
      {
        width: 300,
        color: {
          dark: '09090bff',
          light: 'fafafaff'
        }
      }
    )
  }
}
