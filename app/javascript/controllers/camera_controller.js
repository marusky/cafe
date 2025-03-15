import { Controller } from "@hotwired/stimulus"
import jsQR from 'jsqr'

// Connects to data-controller="camera"
export default class extends Controller {
  static targets = ["video", "code", "canvas"]

  connect() {
    this.startCamera()
  }

  openTokensModal(cid) {
    fetch(`/balance/${cid}/add-tokens`, {
      method: "GET",
      headers: {
        Accept: "text/vnd.turbo-stream.html"
      }
    })
      .then(r => r.text())
      .then(html => Turbo.renderStreamMessage(html))
  }

  async startCamera() {
    const constraints = {
      audio: false,
      video: {
        width: 300,
        height: 300,
        facingMode: 'environment',
      },
    };

    await this.getMedia(constraints)
  }

  async getMedia(constraints) {
    let stream = null;

    try {
      stream = await navigator.mediaDevices.getUserMedia(constraints);
      
      this.videoTarget.srcObject = stream;
      this.videoTarget.onloadedmetadata = () => {
        this.videoTarget.play();
        requestAnimationFrame(this.tick.bind(this));
      };

    } catch (err) {
      console.error(`${err.name}: ${err.message}`);
    }
  }

  tick() {
    if (this.videoTarget.readyState === this.videoTarget.HAVE_ENOUGH_DATA) {
      var canvas = this.canvasTarget.getContext("2d");

      this.canvasTarget.hidden = false;

      this.canvasTarget.height = this.videoTarget.videoHeight;
      this.canvasTarget.width = this.videoTarget.videoWidth;
      canvas.drawImage(this.videoTarget, 0, 0, this.canvasTarget.width, this.canvasTarget.height);
      var imageData = canvas.getImageData(0, 0, this.canvasTarget.width, this.canvasTarget.height);
      var code = jsQR(imageData.data, imageData.width, imageData.height, {
        inversionAttempts: "dontInvert",
      });

      if (code) {
        const parsedUrl = new URL(code.data);
        const cid = parsedUrl.searchParams.get("cid");
        
        this.openTokensModal(cid)
      } else {
        requestAnimationFrame(this.tick.bind(this));
      }
    }
  }
}
