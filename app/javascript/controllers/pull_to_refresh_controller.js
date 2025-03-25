import { Controller } from "@hotwired/stimulus"
import PullToRefresh from 'pulltorefreshjs';

// Connects to data-controller="pull-to-refresh"
export default class extends Controller {
  connect() {
  }

  initializeRefresher() {
    const standalone = navigator.standalone ||
      window.matchMedia("(display-mode: standalone)").matches;

    if (!standalone) {
      return;
    }

    PullToRefresh.init({
      mainElement: 'main',
      instructionsPullToRefresh: 'Potiahni nadol',
      instructionsReleaseToRefresh: 'Pusti',
      instructionsRefreshing: 'Obnovujem',
      onRefresh() {
        Turbo.visit(window.location)
      }
    });
  }
}
