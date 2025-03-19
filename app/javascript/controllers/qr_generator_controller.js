import { Controller } from "@hotwired/stimulus"
import QRCode from "qrcode";

// Connects to data-controller="qr-generator"
export default class extends Controller {
  connect() {
    console.log("QR Generator Controller connected!");
    QRCode.toCanvas(document.getElementById('canvas'), 'https://www.youtube.com/watch?v=dQw4w9WgXcQ&cid=0195af90-9786-78e3-bb66-0fcf697e28a6&eur=5', function (error) {
      if (error) console.error(error)
      console.log('success!');
    })
  }
}
